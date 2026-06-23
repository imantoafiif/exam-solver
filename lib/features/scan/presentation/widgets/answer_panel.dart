import "package:flutter/material.dart";
import "package:flutter_markdown_plus/flutter_markdown_plus.dart";

import "../../domain/answer_result.dart";

/// The result panel: a bottom sheet rendering the AI answer as markdown, with
/// the best-answer letter and confidence emphasized. The captured frame stays
/// visible above the sheet; tapping it (or the close button) dismisses.
class AnswerPanel extends StatelessWidget {
  const AnswerPanel({required this.answer, required this.onClose, super.key});

  final AnswerResult answer;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: <Widget>[
        // Tap target over the frozen frame to dismiss.
        Expanded(
          child: GestureDetector(
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: const SizedBox.expand(),
          ),
        ),
        // The answer sheet (≈85% of the screen).
        Expanded(
          flex: 6,
          child: Material(
            color: theme.colorScheme.surface,
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            // top: false — the sheet starts mid-screen, so only inset the
            // sides + bottom (home indicator / landscape notch).
            child: SafeArea(
              top: false,
              child: Column(
                children: <Widget>[
                  _Header(answer: answer, onClose: onClose),
                  const Divider(height: 1),
                  Expanded(
                    child: Markdown(
                      data: answer.rawMarkdown,
                      selectable: true,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                      styleSheet: MarkdownStyleSheet.fromTheme(theme),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.answer, required this.onClose});

  final AnswerResult answer;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
      child: Column(
        children: <Widget>[
          // Grab handle.
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              _BestAnswerBadge(letter: answer.bestAnswer),
              const SizedBox(width: 8),
              _ConfidenceBadge(confidence: answer.confidence),
              const Spacer(),
              IconButton(onPressed: onClose, icon: const Icon(Icons.close), tooltip: "Close"),
            ],
          ),
        ],
      ),
    );
  }
}

class _BestAnswerBadge extends StatelessWidget {
  const _BestAnswerBadge({required this.letter});

  final String letter;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        letter.isEmpty ? "Best answer" : "Best answer: $letter",
        style: TextStyle(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ConfidenceBadge extends StatelessWidget {
  const _ConfidenceBadge({required this.confidence});

  final String confidence;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (confidence.toLowerCase()) {
      "high" => Colors.green,
      "medium" => Colors.amber,
      "low" => Colors.orange,
      _ => Colors.grey,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Text(
        confidence,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
