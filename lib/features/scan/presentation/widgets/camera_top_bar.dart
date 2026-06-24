import "package:flutter/material.dart";

/// Top navbar shown over the live preview while idle: the current zoom level on
/// the left, and a "Quick" result toggle on the right.
class CameraTopBar extends StatelessWidget {
  const CameraTopBar({
    required this.zoom,
    required this.showZoom,
    required this.quickMode,
    required this.onQuickModeChanged,
    super.key,
  });

  final double zoom;
  final bool showZoom;
  final bool quickMode;
  final ValueChanged<bool> onQuickModeChanged;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (showZoom)
              _Pill(child: Text("${zoom.toStringAsFixed(1)}×", style: _labelStyle))
            else
              const SizedBox.shrink(),
            _QuickToggle(value: quickMode, onChanged: onQuickModeChanged),
          ],
        ),
      ),
    );
  }
}

const TextStyle _labelStyle = TextStyle(color: Colors.white, fontSize: 13);

class _Pill extends StatelessWidget {
  const _Pill({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: child,
      ),
    );
  }
}

class _QuickToggle extends StatelessWidget {
  const _QuickToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _Pill(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text("Quick", style: _labelStyle),
          const SizedBox(width: 6),
          // Compact the switch a touch so the pill stays small.
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
