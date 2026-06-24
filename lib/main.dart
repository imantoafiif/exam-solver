import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";

import "core/settings/settings.dart";
import "core/theme/app_theme.dart";
import "features/menu/presentation/main_menu_screen.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Loads the bundled .env asset (gitignored) holding GEMINI_API_KEY.
  await dotenv.load(fileName: ".env");
  // Persisted user settings (quick answer, save images, colored overlay).
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const ExamScannerApp(),
    ),
  );
}

/// Root application widget.
class ExamScannerApp extends StatelessWidget {
  const ExamScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AI Exam Assistant",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const MainMenuScreen(),
    );
  }
}
