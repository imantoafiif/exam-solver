import "package:flutter/material.dart";

import "../scan_state.dart";
import "answer_panel.dart";
import "error_overlay.dart";
import "loading_overlay.dart";
import "quick_answer_overlay.dart";

/// Maps the current [ScanState] to the foreground overlay drawn on top of the
/// base layer (live preview or frozen frame, decided by the screen).
class ScanStatusOverlay extends StatelessWidget {
  const ScanStatusOverlay({
    required this.state,
    required this.onReset,
    required this.onRetry,
    required this.quickMode,
    required this.coloredOverlay,
    super.key,
  });

  final ScanState state;
  final VoidCallback onReset;
  final VoidCallback onRetry;

  /// When true, a result is shown as a big, fading token in the center instead
  /// of the detailed bottom pane.
  final bool quickMode;

  /// Experimental: when true (and in quick mode), fill the screen with a color
  /// mapped to the answer behind the big token.
  final bool coloredOverlay;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ScanCameraReady() => const _TapHint(),
      ScanCapturing() => const LoadingOverlay(label: "Capturing…"),
      ScanAnalyzing() => const LoadingOverlay(label: "Analyzing…"),
      ScanResult(:final answer) =>
        quickMode
            ? QuickAnswerOverlay(
                answer: answer.quickAnswer,
                onDone: onReset,
                coloredOverlay: coloredOverlay,
              )
            : AnswerPanel(answer: answer, onClose: onReset),
      ScanError(:final message, :final frame) => ErrorOverlay(
        message: message,
        onRetry: onRetry,
        onDismiss: onReset,
        canRetry: frame != null,
      ),
    };
  }
}

/// Subtle hint shown over the live preview telling the user what to do.
class _TapHint extends StatelessWidget {
  const _TapHint();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Tap anywhere to scan",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
