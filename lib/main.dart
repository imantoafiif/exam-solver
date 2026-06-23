import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "core/theme/app_theme.dart";
import "features/scan/presentation/scan_screen.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Loads the bundled .env asset (gitignored) holding GEMINI_API_KEY.
  await dotenv.load(fileName: ".env");
  // The MVP is a single portrait, camera-first screen.
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: ExamScannerApp()));
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
      home: const ScanScreen(),
    );
  }
}
