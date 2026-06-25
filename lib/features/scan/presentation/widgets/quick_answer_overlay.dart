import "dart:async";

import "package:flutter/material.dart";

/// Quick-result display: the answer token shown huge in the vertical center,
/// auto-fading after [visibleDuration]. Tapping dismisses early. When the fade
/// completes (or on early dismiss) [onDone] is called to return to the camera.
///
/// When [background] is non-null (the experimental "colored overlay" feature),
/// it fills the whole screen and the text color flips for contrast.
class QuickAnswerOverlay extends StatefulWidget {
  const QuickAnswerOverlay({
    required this.answer,
    required this.onDone,
    this.background,
    super.key,
  });

  final String answer;
  final VoidCallback onDone;
  final Color? background;

  static const Duration visibleDuration = Duration(seconds: 5);
  static const Duration fadeDuration = Duration(milliseconds: 450);

  /// Maps an answer token to its rainbow color: A→red, B→yellow, C→green,
  /// D→blue, E→purple (numbers 1–5 likewise; True→green, False→red). Returns
  /// null for tokens we can't confidently color (e.g. multi-select / unknown),
  /// in which case the caller should fall back to no colored background.
  static Color? colorForAnswer(String answer) {
    final String a = answer.trim().toUpperCase();
    switch (a) {
      case "A":
      case "1":
      case "FALSE":
        return a == "FALSE" ? Colors.red.shade700 : Colors.red.shade600;
      case "B":
      case "2":
        return Colors.amber.shade600;
      case "C":
      case "3":
      case "TRUE":
        return Colors.green.shade600;
      case "D":
      case "4":
        return Colors.blue.shade600;
      case "E":
      case "5":
        return Colors.purple.shade600;
      default:
        return null;
    }
  }

  @override
  State<QuickAnswerOverlay> createState() => _QuickAnswerOverlayState();
}

class _QuickAnswerOverlayState extends State<QuickAnswerOverlay> {
  double _opacity = 1.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(QuickAnswerOverlay.visibleDuration, _beginFade);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _beginFade() {
    if (mounted && _opacity != 0.0) {
      setState(() => _opacity = 0.0);
    }
  }

  void _dismissEarly() {
    _timer?.cancel();
    _beginFade();
  }

  void _onFadeEnd() {
    if (_opacity == 0.0) {
      widget.onDone();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Multi-select answers come through as "A, C, D" — split into tokens.
    final List<String> tokens = widget.answer
        .split(RegExp(r"\s*,\s*"))
        .map((String t) => t.trim())
        .where((String t) => t.isNotEmpty)
        .toList();
    final bool isMulti = tokens.length > 1;

    // Multi-select: no rainbow color, but a dark scrim so the letters pop.
    // Single-select: the optional colored background.
    final Color? bg = isMulti ? Colors.black.withValues(alpha: 0.85) : widget.background;
    // Contrast: dark text on light backgrounds (e.g. yellow), white otherwise.
    final Color textColor = bg != null && bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    final Widget content = isMulti ? _buildMulti(tokens, textColor) : _buildSingle(textColor);

    return GestureDetector(
      onTap: _dismissEarly,
      behavior: HitTestBehavior.opaque,
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: QuickAnswerOverlay.fadeDuration,
        onEnd: _onFadeEnd,
        child: bg != null
            ? ColoredBox(
                color: bg,
                child: SizedBox.expand(child: content),
              )
            : content,
      ),
    );
  }

  TextStyle _tokenStyle(Color color) {
    return TextStyle(
      color: color,
      fontSize: 240,
      fontWeight: FontWeight.w900,
      height: 1.0,
      shadows: const <Shadow>[Shadow(blurRadius: 28, color: Colors.black54)],
    );
  }

  /// One big centered token (single-select / true-false / number).
  Widget _buildSingle(Color textColor) {
    final String text = widget.answer.trim().isEmpty ? "?" : widget.answer.trim();
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(text, textAlign: TextAlign.center, style: _tokenStyle(textColor)),
        ),
      ),
    );
  }

  /// Multi-select tokens side by side, left→right, scaled so they all fit on
  /// one screen while staying as large as possible.
  Widget _buildMulti(List<String> tokens, Color textColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < tokens.length; i++) ...<Widget>[
                if (i > 0) const SizedBox(width: 96),
                Text(tokens[i], style: _tokenStyle(textColor)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
