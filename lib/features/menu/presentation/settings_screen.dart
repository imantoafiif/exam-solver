import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/settings/settings.dart";

/// Settings: the three user-configurable toggles, persisted across launches.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppSettings settings = ref.watch(settingsProvider);
    final SettingsNotifier notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            SwitchListTile(
              value: settings.quickAnswer,
              onChanged: notifier.setQuickAnswer,
              title: const Text("Quick answer"),
              subtitle: const Text(
                "Show the answer as a big letter in the center instead of the detailed panel.",
              ),
            ),
            SwitchListTile(
              value: settings.saveImages,
              onChanged: notifier.setSaveImages,
              title: const Text("Save captures to gallery"),
              subtitle: const Text(
                "Store each scanned image in the device gallery (for collecting test data).",
              ),
            ),
            SwitchListTile(
              value: settings.coloredOverlay,
              onChanged: settings.quickAnswer ? notifier.setColoredOverlay : null,
              title: const Text("Colored answer background"),
              subtitle: Text(
                settings.quickAnswer
                    ? "Fill the screen with a color per answer "
                          "(A red, B yellow, C green, D blue, E black, F white)."
                    : "Requires Quick answer to be on.",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
