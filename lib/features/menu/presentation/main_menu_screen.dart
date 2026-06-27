import "package:flutter/material.dart";

import "../../scan/presentation/scan_screen.dart";
import "settings_screen.dart";

/// Simple landing screen shown before the camera: Start and Settings.
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Centered when it fits; scrolls instead of overflowing (e.g. landscape).
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.document_scanner_outlined,
                          size: 72,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "AI Exam Assistant",
                          style: theme.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Point, capture, get the answer.",
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),
                        SizedBox(
                          width: 240,
                          child: FilledButton.icon(
                            onPressed: () => Navigator.of(
                              context,
                            ).push(MaterialPageRoute<void>(builder: (_) => const ScanScreen())),
                            icon: const Icon(Icons.camera_alt_outlined),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text("Start Scanning"),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 240,
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.of(
                              context,
                            ).push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen())),
                            icon: const Icon(Icons.settings_outlined),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text("Settings"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
