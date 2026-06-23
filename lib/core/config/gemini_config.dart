/// Static configuration for the Gemini Developer API integration.
///
/// Decisions locked in CLAUDE.md ("Gemini integration"):
/// raw REST via dio, model `gemini-3.5-flash`, key in the `x-goog-api-key`
/// header, low temperature for consistent reasoning.
class GeminiConfig {
  const GeminiConfig._();

  /// Default model. Swapping to `gemini-flash-latest` or `gemini-2.5-flash`
  /// is a one-line change. Do NOT use `gemini-2.0-flash` (sunset 2026-06-01).
  static const String model = "gemini-3.5-flash";

  /// Base REST endpoint for the Gemini Developer API.
  static const String baseUrl = "https://generativelanguage.googleapis.com/v1beta";

  /// Full `generateContent` endpoint for the configured model.
  static String get generateContentUrl => "$baseUrl/models/$model:generateContent";

  /// Header name carrying the API key (preferred over `?key=` in the URL).
  static const String apiKeyHeader = "x-goog-api-key";

  /// Low temperature -> consistent, accurate reasoning over creativity.
  static const double temperature = 0.2;

  /// Enough room for the full response format (PRD section 18).
  static const int maxOutputTokens = 2048;

  /// MIME type used when sending the captured frame as inline image data.
  static const String imageMimeType = "image/jpeg";

  /// Network timeout for a single analysis request.
  static const Duration requestTimeout = Duration(seconds: 60);
}
