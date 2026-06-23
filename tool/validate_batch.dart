// Batch validation harness for Wave 5 (prompt tuning & accuracy).
//
// Runs every image in a folder through the real Gemini client + parser and
// prints a per-image report plus a summary: success/failure, best answer,
// confidence, §18 format compliance, whether assumptions were stated, and
// latency. Optionally scores accuracy against an answer key.
//
// Usage:
//   GEMINI_API_KEY=<key> dart run tool/validate_batch.dart <images_dir> [answer_key.json]
//
//   answer_key.json (optional): { "q1.jpg": "C", "q2.jpg": "A", ... }
//
// Imports only Flutter-free libraries so it runs under a plain `dart run`.
import "dart:convert";
import "dart:io";

import "package:dio/dio.dart";
import "package:exam_scanner/core/error/failures.dart";
import "package:exam_scanner/features/scan/data/gemini_client.dart";
import "package:exam_scanner/features/scan/domain/answer_result.dart";

const List<String> _sections = <String>[
  "Reconstructed Question",
  "Question Summary",
  "Key Requirements",
  "Option Analysis",
  "Best Answer",
  "Explanation",
  "Confidence",
  "Assumptions",
];

Future<void> main(List<String> args) async {
  final String apiKey = Platform.environment["GEMINI_API_KEY"] ?? "";
  if (apiKey.isEmpty) {
    stderr.writeln("Set GEMINI_API_KEY in the environment.");
    exit(2);
  }
  if (args.isEmpty) {
    stderr.writeln("Usage: dart run tool/validate_batch.dart <images_dir> [answer_key.json]");
    exit(2);
  }

  final Directory dir = Directory(args.first);
  if (!dir.existsSync()) {
    stderr.writeln("Directory not found: ${args.first}");
    exit(2);
  }

  final Map<String, String> answerKey = args.length > 1
      ? (jsonDecode(File(args[1]).readAsStringSync()) as Map<String, dynamic>).map(
          (String k, Object? v) => MapEntry<String, String>(k, "$v".toUpperCase()),
        )
      : <String, String>{};

  final List<File> images =
      dir
          .listSync()
          .whereType<File>()
          .where((File f) => RegExp(r"\.(jpe?g|png)$", caseSensitive: false).hasMatch(f.path))
          .toList()
        ..sort((File a, File b) => a.path.compareTo(b.path));

  if (images.isEmpty) {
    stderr.writeln("No .jpg/.jpeg/.png images found in ${dir.path}");
    exit(2);
  }

  final String prompt = await File("assets/prompts/ace_solver_prompt.txt").readAsString();
  final GeminiClient client = GeminiClient(dio: Dio(), apiKey: apiKey);

  int ok = 0;
  int correct = 0;
  int scored = 0;
  final List<int> latencies = <int>[];

  stdout.writeln("Validating ${images.length} image(s)...\n");
  for (final File image in images) {
    final String name = image.uri.pathSegments.last;
    final String mime = name.toLowerCase().endsWith(".png") ? "image/png" : "image/jpeg";
    final String base64Image = base64Encode(await image.readAsBytes());
    final Stopwatch sw = Stopwatch()..start();
    try {
      final String md = await client.analyze(
        prompt: prompt,
        base64Image: base64Image,
        mimeType: mime,
      );
      sw.stop();
      latencies.add(sw.elapsedMilliseconds);
      ok++;
      final AnswerResult r = AnswerResult.fromMarkdown(md);
      final List<String> missing = _sections
          .where((String s) => !md.toLowerCase().contains("## ${s.toLowerCase()}"))
          .toList();
      final bool hasAssumptions = r.rawMarkdown.toLowerCase().contains("## assumptions");

      String mark = "";
      final String? expected = answerKey[name];
      if (expected != null) {
        scored++;
        final bool hit = r.bestAnswer.toUpperCase() == expected;
        if (hit) {
          correct++;
        }
        mark = hit ? "  ✓ (expected $expected)" : "  ✗ (expected $expected)";
      }

      stdout.writeln(
        "$name\n"
        "  answer=${r.bestAnswer.isEmpty ? "?" : r.bestAnswer}  "
        "confidence=${r.confidence}  ${sw.elapsedMilliseconds}ms$mark\n"
        "  format=${missing.isEmpty ? "complete" : "MISSING ${missing.join(", ")}"}  "
        "assumptions=${hasAssumptions ? "yes" : "no"}",
      );
    } on ScanFailure catch (e) {
      sw.stop();
      stdout.writeln("$name\n  FAILED: ${e.runtimeType} — ${e.message}");
    }
    stdout.writeln("");
  }

  final int avg = latencies.isEmpty
      ? 0
      : latencies.reduce((int a, int b) => a + b) ~/ latencies.length;
  stdout.writeln("=" * 48);
  stdout.writeln("Succeeded: $ok / ${images.length}");
  if (scored > 0) {
    final String pct = (100 * correct / scored).toStringAsFixed(0);
    stdout.writeln("Accuracy:  $correct / $scored ($pct%)");
  }
  stdout.writeln("Avg latency (successful): ${avg}ms");
}
