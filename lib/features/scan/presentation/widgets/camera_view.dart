import "package:camera/camera.dart";
import "package:flutter/material.dart";

/// Full-bleed (cover) live preview for an already-initialized
/// [CameraController].
///
/// The camera reports [CameraValue.previewSize] in landscape orientation, so
/// width/height are swapped to fill a portrait screen via [BoxFit.cover].
class CameraView extends StatelessWidget {
  const CameraView({required this.controller, super.key});

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const ColoredBox(color: Colors.black);
    }

    // `CameraPreview` is already an orientation-aware `AspectRatio`. Centering
    // it (instead of cover-cropping) shows the FULL sensor frame, letterboxed —
    // so what the user sees matches what `takePicture()` captures (WYSIWYG),
    // and it isn't over-zoomed in landscape.
    return Center(child: CameraPreview(controller));
  }
}
