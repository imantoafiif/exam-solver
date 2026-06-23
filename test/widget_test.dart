import "package:exam_scanner/core/theme/app_theme.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("app theme is dark Material 3", () {
    // Arrange & Act
    final ThemeData theme = AppTheme.dark;

    // Assert
    expect(theme.useMaterial3, isTrue);
    expect(theme.brightness, Brightness.dark);
  });
}
