import "dart:async";

import "package:flutter/material.dart";

/// Quick-result display.
///
/// - Single answer: shows the one big token for [singleDuration].
/// - Multi-select ("A, C, F"): shows each token **sequentially**, [stepDuration]
///   each, in order, then returns to the camera.
///
/// No transitions: tokens swap instantly and control snaps back to the camera
/// (via [onDone]) with no fade. Tapping dismisses immediately.
///
/// When [coloredOverlay] is on, each token gets its rainbow background
/// (A red, B yellow, C green, D blue, E black, F white). Multi-select falls back
/// to a dark scrim per step when a token has no mapped color (or coloring off).
class QuickAnswerOverlay extends StatefulWidget {
  const QuickAnswerOverlay({
    required this.answer,
    required this.onDone,
    required this.coloredOverlay,
    super.key,
  });

  final String answer;
  final VoidCallback onDone;
  final bool coloredOverlay;

  static const Duration singleDuration = Duration(seconds: 5);
  static const Duration stepDuration = Duration(milliseconds: 2500);

  /// Dark scrim used behind multi-select tokens that have no rainbow color.
  static const Color _scrim = Color(0xD9000000); // black @ ~85%

  /// Maps an answer token to its color: A→red, B→yellow, C→green, D→blue,
  /// E→black, F→white (numbers 1–6 likewise; True→green, False→red). Returns
  /// null for tokens we can't confidently color.
  static Color? colorForAnswer(String answer) {
    switch (answer.trim().toUpperCase()) {
      case "A":
      case "1":
        return Colors.red.shade600;
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
        return Colors.black;
      case "F":
      case "6":
        return Colors.white;
      case "FALSE":
        return Colors.red.shade700;
      default:
        return null;
    }
  }

  @override
  State<QuickAnswerOverlay> createState() => _QuickAnswerOverlayState();
}

class _QuickAnswerOverlayState extends State<QuickAnswerOverlay> {
  late final List<String> _tokens;
  int _index = 0;
  Timer? _timer;

  bool get _isMulti => _tokens.length > 1;

  @override
  void initState() {
    super.initState();
    // Multi-select answers come through as "A, C, F".
    _tokens = widget.answer
        .split(RegExp(r"\s*,\s*"))
        .map((String t) => t.trim())
        .where((String t) => t.isNotEmpty)
        .toList();
    _scheduleNext();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _scheduleNext() {
    _timer = Timer(
      _isMulti ? QuickAnswerOverlay.stepDuration : QuickAnswerOverlay.singleDuration,
      _advance,
    );
  }

  void _advance() {
    if (!mounted) {
      return;
    }
    if (_index < _tokens.length - 1) {
      setState(() => _index++); // instant swap, no transition
      _scheduleNext();
    } else {
      widget.onDone(); // last token shown — snap back to the camera
    }
  }

  void _dismiss() {
    _timer?.cancel();
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    final String token = _tokens.isEmpty ? "?" : _tokens[_index];

    final Color? mapped = widget.coloredOverlay ? QuickAnswerOverlay.colorForAnswer(token) : null;
    // Single-select with no color → transparent (token over the frozen frame).
    // Multi-select always gets a background (its color, else a dark scrim).
    final Color? bg = mapped ?? (_isMulti ? QuickAnswerOverlay._scrim : null);
    final Color textColor = bg != null && bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    final Widget content = Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            token,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 240,
              fontWeight: FontWeight.w900,
              height: 1.0,
              shadows: const <Shadow>[Shadow(blurRadius: 28, color: Colors.black54)],
            ),
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: _dismiss,
      behavior: HitTestBehavior.opaque,
      child: bg != null
          ? ColoredBox(
              color: bg,
              child: SizedBox.expand(child: content),
            )
          : content,
    );
  }
}
