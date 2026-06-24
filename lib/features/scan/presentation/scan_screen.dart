import "dart:developer" as developer;
import "dart:io";

import "package:camera/camera.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:gal/gal.dart";

import "../../../core/config/app_config.dart";
import "../../../core/error/failures.dart";
import "../data/image_compressor.dart";
import "scan_controller.dart";
import "scan_state.dart";
import "widgets/camera_top_bar.dart";
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
    final CameraController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    // Release the camera when backgrounded; re-acquire on resume.
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      controller.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    setState(() {
      _status = _CameraStatus.initializing;
      _errorMessage = null;
    });
    try {
      final List<CameraDescription> cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          setState(() => _status = _CameraStatus.noCamera);
        }
        return;
      }
      final CameraDescription back = cameras.firstWhere(
        (CameraDescription c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final CameraController controller = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      _minZoom = await controller.getMinZoomLevel();
      _maxZoom = await controller.getMaxZoomLevel();
      _currentZoom = _minZoom;
      _baseZoom = _minZoom;
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _status = _CameraStatus.ready;
      });
    } on CameraException catch (e, stackTrace) {
      developer.log(
        "Camera init failed: ${e.code} ${e.description}",
        name: "ScanScreen",
        error: e,
        stackTrace: stackTrace,
      );
      if (!mounted) {
        return;
      }
      final String code = e.code.toLowerCase();
      final bool denied = code.contains("denied") || code.contains("permission");
      setState(() {
        _status = denied ? _CameraStatus.denied : _CameraStatus.error;
        _errorMessage = e.description;
      });
    }
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
    // Optional, gated data-collection: persist the frame we send to Gemini.
    if (AppConfig.saveCapturesToGallery) {
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
          final bool quickMode = ref.watch(quickModeProvider);
          final bool zoomSupported = _maxZoom > _minZoom;
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _baseLayer(scanState),
              if (scanState is ScanCameraReady)
                CameraTopBar(
                  zoom: _currentZoom,
                  showZoom: zoomSupported,
                  quickMode: quickMode,
                  onQuickModeChanged: (bool value) =>
                      ref.read(quickModeProvider.notifier).set(value),
                ),
              ScanStatusOverlay(
                state: scanState,
                onReset: notifier.reset,
                onRetry: notifier.retry,
                quickMode: quickMode,
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
    return CameraView(controller: _controller!);
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
