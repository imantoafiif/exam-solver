import "dart:convert";
import "dart:typed_data";

import "../../../core/prompt/prompt_loader.dart";
import "../domain/answer_result.dart";
import "../domain/scan_repository_ref.dart";
import "gemini_client.dart";

/// Gemini-backed implementation of [ScanRepository].
///
/// Orchestrates the pipeline: load the system prompt, base64-encode the image
/// bytes, call Gemini, and parse the markdown into an [AnswerResult].
class GeminiScanRepository implements ScanRepository {
  GeminiScanRepository({required this._client, required this._promptLoader});

  final GeminiClient _client;
  final PromptLoader _promptLoader;

  @override
  Future<AnswerResult> analyzeImage(Uint8List jpegBytes) async {
    final String prompt = await _promptLoader.load();
    final String base64Image = base64Encode(jpegBytes);
    final String markdown = await _client.analyze(prompt: prompt, base64Image: base64Image);
    return AnswerResult.fromMarkdown(markdown);
  }
}
