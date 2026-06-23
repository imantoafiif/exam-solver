import "package:flutter/material.dart";

/// App-wide theming. The app is camera-first, so it uses a dark Material 3
/// theme with a black scaffold to keep chrome out of the way of the preview.
class AppTheme {
  const AppTheme._();

  /// The single dark theme used across the app.
  static ThemeData get dark {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4285F4),
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.black,
    );
  }
}
