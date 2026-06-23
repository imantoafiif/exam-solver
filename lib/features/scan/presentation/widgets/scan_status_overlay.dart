import "package:flutter/material.dart";

import "../../domain/answer_result.dart";
import "../scan_state.dart";

/// Renders the overlay that sits on top of the live preview for each scan
/// state. Minimal for Wave 3 (functional, not polished); Wave 4 replaces the
/// result/error cases with markdown rendering, a frozen frame, and richer UX.
class ScanStatusOverlay extends StatelessWidget {
  const ScanStatusOverlay({required this.state, required this.onReset, super.key});

  final ScanState state;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ScanCameraReady() => const _TapHint(),
      ScanCapturing() => const _Busy(label: "Capturing…"),
      ScanAnalyzing() => const _Busy(label: "Analyzing…"),
      ScanResult(:final AnswerResult answer) => _ResultBasic(answer: answer, onClose: onReset),
      ScanError(:final String message) => _ErrorBasic(message: message, onDismiss: onReset),
    };
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

/// Dimmed scrim with a spinner + label for the busy states.
class _Busy extends StatelessWidget {
  const _Busy({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

/// Bare-bones result panel (Wave 4 renders markdown + frozen frame).
class _ResultBasic extends StatelessWidget {
  const _ResultBasic({required this.answer, required this.onClose});

  final AnswerResult answer;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.92),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Best answer: ${answer.bestAnswer.isEmpty ? "?" : answer.bestAnswer}"
                      "   •   Confidence: ${answer.confidence}",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close, color: Colors.white),
                    tooltip: "Close",
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  answer.rawMarkdown,
                  style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bare-bones error panel (Wave 4 adds friendlier messaging + retry).
class _ErrorBasic extends StatelessWidget {
  const _ErrorBasic({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.85),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.error_outline, size: 56, color: Colors.white70),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onDismiss,
                icon: const Icon(Icons.refresh),
                label: const Text("Try again"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
