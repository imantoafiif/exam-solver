import "dart:async";

import "package:flutter/material.dart";

/// Quick-result display: the answer token shown huge in the vertical center,
/// auto-fading after [visibleDuration]. Tapping dismisses early. When the fade
/// completes (or on early dismiss) [onDone] is called to return to the camera.
class QuickAnswerOverlay extends StatefulWidget {
  const QuickAnswerOverlay({required this.answer, required this.onDone, super.key});

  final String answer;
  final VoidCallback onDone;

  static const Duration visibleDuration = Duration(seconds: 5);
  static const Duration fadeDuration = Duration(milliseconds: 450);

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
    final String text = widget.answer.trim().isEmpty ? "?" : widget.answer.trim();
    return GestureDetector(
      onTap: _dismissEarly,
      behavior: HitTestBehavior.opaque,
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: QuickAnswerOverlay.fadeDuration,
        onEnd: _onFadeEnd,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 240,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                  shadows: <Shadow>[Shadow(blurRadius: 28, color: Colors.black)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
