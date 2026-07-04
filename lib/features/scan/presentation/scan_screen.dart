import "dart:developer" as developer;
import "dart:io";

import "package:camera/camera.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:gal/gal.dart";

import "../../../core/config/app_config.dart";
import "../../../core/error/failures.dart";
import "../../../core/settings/settings.dart";
import "../data/image_compressor.dart";
import "scan_controller.dart";
import "scan_state.dart";
import "widgets/camera_view.dart";
import "widgets/scan_status_overlay.dart";

/// Lifecycle status of the camera foundation on [ScanScreen].
enum _CameraStatus { initializing, ready, denied, noCamera, error }

/// The single, full-screen, camera-first screen of the app.
///
/// The screen owns the [CameraController] (a lifecycle-bound platform
/// resource); the scan flow state machine lives in [scanControllerProvider].
/// On tap it hands the controller a capture callback so the state machine never
/// touches the camera plugin directly.
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  _CameraStatus _status = _CameraStatus.initializing;
  String? _errorMessage;

  // Back-facing lenses the platform exposes (Camera2 lists main / ultra-wide /
  // tele separately); the user cycles between them with the lens button.
  List<CameraDescription> _backCameras = <CameraDescription>[];
  int _backIndex = 0;

  // Pinch-to-zoom state.
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _currentZoom = 1.0;
  double _baseZoom = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      // Release the camera when backgrounded. Crucially, drop back to the
      // `initializing` state so the UI stops rendering the (now-null) controller
      // — otherwise a rebuild hits `_controller!` and crashes.
      final CameraController? controller = _controller;
      if (controller != null) {
        _controller = null;
        controller.dispose();
        if (mounted) {
          setState(() => _status = _CameraStatus.initializing);
        }
      }
    } else if (state == AppLifecycleState.resumed) {
      // Re-acquire only if we released it (don't double-init).
      if (_controller == null) {
        _initCamera();
      }
    }
  }

  Future<void> _initCamera() async {
    if (mounted) {
      setState(() {
        _status = _CameraStatus.initializing;
        _errorMessage = null;
      });
    }

    // CameraX's initializeCamera intermittently throws a (plain) null-check
    // error when preview resolution info isn't ready yet — especially on
    // resume. It's a timing race, so retry a few times before giving up.
    const int maxAttempts = 3;
    String? lastError;
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      CameraController? controller;
      try {
        final List<CameraDescription> cameras = await availableCameras();
        if (cameras.isEmpty) {
          if (mounted) {
            setState(() => _status = _CameraStatus.noCamera);
          }
          return;
        }
        // Build the selectable back-lens list (fall back to all cameras if none
        // report as back-facing). Keep the user's chosen index across re-inits.
        final List<CameraDescription> backs = cameras
            .where((CameraDescription c) => c.lensDirection == CameraLensDirection.back)
            .toList();
        _backCameras = backs.isEmpty ? cameras : backs;
        if (_backIndex >= _backCameras.length) {
          _backIndex = 0;
        }
        for (int i = 0; i < _backCameras.length; i++) {
          developer.log("backCam[$i]: '${_backCameras[i].name}'", name: "ScanScreen.cameras");
        }
        final CameraDescription back = _backCameras[_backIndex];
        controller = CameraController(back, ResolutionPreset.high, enableAudio: false);
        await controller.initialize();
        // Never fire the flash on capture (the default is auto). Guarded because
        // some lenses (e.g. ultra-wide) have no flash unit.
        try {
          await controller.setFlashMode(FlashMode.off);
        } on CameraException catch (e) {
          developer.log("setFlashMode(off) unsupported: ${e.code}", name: "ScanScreen");
        }
        _minZoom = await controller.getMinZoomLevel();
        _maxZoom = await controller.getMaxZoomLevel();
        _currentZoom = _minZoom;
        _baseZoom = _minZoom;
        developer.log(
          "camera '${back.name}' ready; zoom min=$_minZoom max=$_maxZoom",
          name: "ScanScreen.zoom",
        );
        if (!mounted) {
          await controller.dispose();
          return;
        }
        setState(() {
          _controller = controller;
          _status = _CameraStatus.ready;
        });
        return; // success
      } on CameraException catch (e, stackTrace) {
        await controller?.dispose();
        developer.log(
          "Camera init failed: ${e.code}",
          name: "ScanScreen",
          error: e,
          stackTrace: stackTrace,
        );
        final String code = e.code.toLowerCase();
        if (code.contains("denied") || code.contains("permission")) {
          if (mounted) {
            setState(() => _status = _CameraStatus.denied);
          }
          return; // permission won't fix itself by retrying
        }
        lastError = e.description;
      } on Object catch (e, stackTrace) {
        // Includes the CameraX plugin's internal null-check crash.
        await controller?.dispose();
        developer.log(
          "Camera init crashed (attempt $attempt)",
          name: "ScanScreen",
          error: e,
          stackTrace: stackTrace,
        );
        lastError = "Couldn't start the camera.";
      }
      if (attempt < maxAttempts) {
        await Future<void>.delayed(const Duration(milliseconds: 400));
      }
    }

    if (mounted) {
      setState(() {
        _status = _CameraStatus.error;
        _errorMessage = lastError ?? "Couldn't start the camera. Tap retry.";
      });
    }
  }

  /// Cycles to the next back lens (e.g. main → ultra-wide → tele) and re-inits.
  Future<void> _switchLens() async {
    if (_backCameras.length < 2) {
      return;
    }
    _backIndex = (_backIndex + 1) % _backCameras.length;
    final CameraController? old = _controller;
    _controller = null;
    await old?.dispose();
    await _initCamera();
  }

  void _onTap() {
    if (_status != _CameraStatus.ready) {
      return;
    }
    // Only start a scan when idle — ignore taps while capturing / analyzing /
    // showing a result or error.
    if (ref.read(scanControllerProvider) is! ScanCameraReady) {
      return;
    }
    HapticFeedback.mediumImpact();
    ref.read(scanControllerProvider.notifier).scan(_captureFrame);
  }

  void _onScaleStart(ScaleStartDetails details) {
    _baseZoom = _currentZoom;
  }

  Future<void> _onScaleUpdate(ScaleUpdateDetails details) async {
    // Only pinch (2+ pointers) should zoom; ignore single-finger drags.
    if (details.pointerCount < 2) {
      return;
    }
    final CameraController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    final double zoom = (_baseZoom * details.scale).clamp(_minZoom, _maxZoom);
    if (zoom == _currentZoom) {
      return;
    }
    setState(() => _currentZoom = zoom);
    await controller.setZoomLevel(zoom);
  }

  /// Captures a still frame, deletes the temp file (we never persist images),
  /// and returns compressed JPEG bytes ready for upload.
  Future<Uint8List> _captureFrame() async {
    final CameraController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw const ConfigFailure("Camera is not ready.");
    }
    final XFile shot = await controller.takePicture();
    final Uint8List raw = await shot.readAsBytes();
    try {
      final File temp = File(shot.path);
      if (await temp.exists()) {
        await temp.delete();
      }
    } on Object {
      // Best-effort cleanup; a leftover temp file is non-fatal.
    }
    final Uint8List compressed = await compressJpeg(raw);
    // Optional, user-toggled data-collection: persist the frame we send to Gemini.
    if (ref.read(settingsProvider).saveImages) {
      await _saveCapture(compressed);
    }
    return compressed;
  }

  /// Saves the compressed capture to the device gallery (data-collection mode).
  /// Best-effort: a save failure (e.g. permission denied) must not block a scan.
  Future<void> _saveCapture(Uint8List bytes) async {
    try {
      await Gal.putImageBytes(
        bytes,
        album: AppConfig.captureAlbum,
        name: "exam_${DateTime.now().millisecondsSinceEpoch}",
      );
    } on Object catch (e, stackTrace) {
      developer.log("Failed to save capture", name: "ScanScreen", error: e, stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _onTap,
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        behavior: HitTestBehavior.opaque,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_status) {
      case _CameraStatus.ready:
        {
          final ScanState scanState = ref.watch(scanControllerProvider);
          final ScanController notifier = ref.read(scanControllerProvider.notifier);
          final AppSettings settings = ref.watch(settingsProvider);
          final bool zoomSupported = _maxZoom > _minZoom;
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _baseLayer(scanState),
              if (scanState is ScanCameraReady && zoomSupported) _ZoomIndicator(zoom: _currentZoom),
              if (scanState is ScanCameraReady && _backCameras.length > 1)
                _LensButton(index: _backIndex, count: _backCameras.length, onSwitch: _switchLens),
              ScanStatusOverlay(
                state: scanState,
                onReset: notifier.reset,
                onRetry: notifier.retry,
                quickMode: settings.quickAnswer,
                coloredOverlay: settings.coloredOverlay,
              ),
            ],
          );
        }
      case _CameraStatus.initializing:
        return const Center(child: CircularProgressIndicator());
      case _CameraStatus.denied:
        return _CameraMessage(
          icon: Icons.no_photography_outlined,
          title: "Camera access needed",
          message:
              "This app scans exam questions with the camera. Please allow camera "
              "access, then tap retry.",
          onRetry: _initCamera,
        );
      case _CameraStatus.noCamera:
        return const _CameraMessage(
          icon: Icons.videocam_off_outlined,
          title: "No camera found",
          message: "This device has no usable camera.",
        );
      case _CameraStatus.error:
        return _CameraMessage(
          icon: Icons.error_outline,
          title: "Camera error",
          message: _errorMessage ?? "Something went wrong starting the camera.",
          onRetry: _initCamera,
        );
    }
  }

  /// The layer beneath the overlay: the live preview while idle/capturing, or
  /// the frozen captured frame once we have one (analyzing / result / error).
  Widget _baseLayer(ScanState state) {
    final Uint8List? frame = switch (state) {
      ScanAnalyzing(:final Uint8List frame) => frame,
      ScanResult(:final Uint8List frame) => frame,
      ScanError(:final Uint8List? frame) => frame,
      ScanCameraReady() || ScanCapturing() => null,
    };
    if (frame != null) {
      // `contain` (not cover) so the frozen capture is shown full-frame,
      // matching the live preview — a 1:1 representation of what was captured.
      return Image.memory(frame, fit: BoxFit.contain, gaplessPlayback: true);
    }
    // Defensive: the controller can be momentarily null/uninitialized around
    // app background/resume. Never `_controller!` here — show black instead.
    final CameraController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const ColoredBox(color: Colors.black);
    }
    return CameraView(controller: controller);
  }
}

/// Bottom-center button to cycle back lenses (main / ultra-wide / tele). Shows
/// the current lens index so the user can find the wide one.
class _LensButton extends StatelessWidget {
  const _LensButton({required this.index, required this.count, required this.onSwitch});

  final int index;
  final int count;
  final VoidCallback onSwitch;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Material(
            color: Colors.black54,
            shape: const StadiumBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onSwitch,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.cameraswitch_outlined, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      "Lens ${index + 1}/$count",
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small pill (top-center) showing the current zoom level; hints pinch-to-zoom.
class _ZoomIndicator extends StatelessWidget {
  const _ZoomIndicator({required this.zoom});

  final double zoom;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Text(
                "${zoom.toStringAsFixed(1)}×",
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Centered icon + message used for the non-ready camera states.
class _CameraMessage extends StatelessWidget {
  const _CameraMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 64, color: Colors.white70),
              const SizedBox(height: 16),
              Text(title, style: textTheme.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(message, style: textTheme.bodyMedium, textAlign: TextAlign.center),
              if (onRetry != null) ...<Widget>[
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
