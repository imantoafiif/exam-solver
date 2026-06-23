import "package:flutter_dotenv/flutter_dotenv.dart";

/// Access to environment values loaded from the bundled `.env` asset.
///
/// `dotenv.load()` must be awaited in `main()` before any access here.
class Env {
  const Env._();

  /// The Gemini Developer API key. Read from `.env` (gitignored).
  ///
  /// Note (per CLAUDE.md §7): in the MVP this key ships inside the app — an
  /// accepted risk to be revisited via a backend proxy before public release.
  static String get geminiApiKey => dotenv.get("GEMINI_API_KEY", fallback: "");

  /// Whether a non-empty Gemini key is configured.
  static bool get hasGeminiKey => geminiApiKey.isNotEmpty;
}
