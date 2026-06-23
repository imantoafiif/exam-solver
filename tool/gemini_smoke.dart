// Smoke test for the Gemini integration (Wave 2).
//
// Usage:
//   GEMINI_API_KEY=<key> dart run tool/gemini_smoke.dart <path-to-image.jpg>
//
// Reads the ACE prompt from assets/prompts/ace_solver_prompt.txt, sends the
// image to gemini-3.5-flash, and prints the parsed AnswerResult. Requires a
// real API key. This file imports only Flutter-free libraries so it runs under
// a plain `dart run`.
import "dart:convert";
import "dart:io";

import "package:dio/dio.dart";
import "package:exam_scanner/core/error/failures.dart";
import "package:exam_scanner/features/scan/data/gemini_client.dart";
import "package:exam_scanner/features/scan/domain/answer_result.dart";

Future<void> main(List<String> args) async {
  final String apiKey = Platform.environment["GEMINI_API_KEY"] ?? "";
  if (apiKey.isEmpty) {
    stderr.writeln("Set GEMINI_API_KEY in the environment.");
    exit(2);
  }
  if (args.isEmpty) {
    stderr.writeln("Usage: dart run tool/gemini_smoke.dart <path-to-image.jpg>");
    exit(2);
  }

  final File imageFile = File(args.first);
  if (!imageFile.existsSync()) {
    stderr.writeln("Image not found: ${args.first}");
    exit(2);
  }

  final String prompt = await File("assets/prompts/ace_solver_prompt.txt").readAsString();
  final String base64Image = base64Encode(await imageFile.readAsBytes());

  final GeminiClient client = GeminiClient(dio: Dio(), apiKey: apiKey);
  try {
    final String markdown = await client.analyze(prompt: prompt, base64Image: base64Image);
    final AnswerResult result = AnswerResult.fromMarkdown(markdown);
    stdout.writeln(
      "=== BEST ANSWER: ${result.bestAnswer}  (confidence: ${result.confidence}) ===\n",
    );
    stdout.writeln(result.rawMarkdown);
  } on ScanFailure catch (e) {
    stderr.writeln("FAILED: $e");
    exit(1);
  }
}
