import "dart:developer" as developer;

import "package:camera/camera.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "widgets/camera_view.dart";

/// Lifecycle status of the camera foundation on [ScanScreen].
enum _CameraStatus { initializing, ready, denied, noCamera, error }

/// The single, full-screen, camera-first screen of the app.
///
/// Wave 1: opens straight into a live full-screen preview and detects taps.
/// Capture and AI analysis are wired in later waves (the tap currently logs).
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  _CameraStatus _status = _CameraStatus.initializing;
  String? _errorMessage;

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
    // Wave 3 wires this to capture -> compress -> Gemini analysis.
    developer.log("tap captured -> capture frame (wired in Wave 3)", name: "ScanScreen");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(onTap: _onTap, behavior: HitTestBehavior.opaque, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    switch (_status) {
      case _CameraStatus.ready:
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CameraView(controller: _controller!),
            const _TapHint(),
          ],
        );
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
}

/// Subtle hint shown over the live preview telling the user what to do.
class _TapHint extends StatelessWidget {
  const _TapHint();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 48),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(24)),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Tap anywhere to scan",
              style: TextStyle(color: Colors.white, fontSize: 14),
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
    return Center(
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
    );
  }
}
