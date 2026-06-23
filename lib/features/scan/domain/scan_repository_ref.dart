import "dart:typed_data";

import "answer_result.dart";

/// Contract for turning a captured exam image into an [AnswerResult].
///
/// Implemented by the Gemini-backed repository; abstracted so the AI provider
/// can be swapped without touching the presentation layer. Implementations
/// throw a `ScanFailure` subtype on configuration / network / API / parse
/// errors.
abstract interface class ScanRepository {
  /// Analyzes [jpegBytes] (a single still frame) and returns the parsed result.
  Future<AnswerResult> analyzeImage(Uint8List jpegBytes);
}
