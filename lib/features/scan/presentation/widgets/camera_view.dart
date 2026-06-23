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
    final Size? previewSize = controller.value.previewSize;
    if (previewSize == null) {
      return const ColoredBox(color: Colors.black);
    }

    return ClipRect(
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: previewSize.height,
            height: previewSize.width,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }
}
