import "package:flutter/material.dart";

/// Error panel shown over the frozen frame. Offers a retry (when the same frame
/// can be re-analyzed) and a dismiss back to the live camera.
class ErrorOverlay extends StatelessWidget {
  const ErrorOverlay({
    required this.message,
    required this.onRetry,
    required this.onDismiss,
    required this.canRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onDismiss;
  final bool canRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.7),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.error_outline, size: 56, color: Colors.white70),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: onDismiss,
                      style: TextButton.styleFrom(foregroundColor: Colors.white70),
                      child: const Text("Back to camera"),
                    ),
                    if (canRetry) ...<Widget>[
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: onRetry,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Try again"),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
