// Oracle-assisted validation for Wave 5 (images but no answer key).
//
// Runs each image through BOTH our production model (gemini-3.5-flash + the
// prod prompt + parser) AND a stronger "oracle" (default gemini-2.5-pro) asked
// for just the answer token. Auto-drafts an answer key from the oracle and
// flags every disagreement / low-confidence case for human review.
//
// Usage:
//   GEMINI_API_KEY=<key> dart run tool/oracle_validate.dart <images_dir> [out_key.json]
//   (optional) ORACLE_MODEL=gemini-3.1-pro-preview
//
// Flutter-free imports so it runs under a plain `dart run`.
import "dart:convert";
import "dart:io";

import "package:dio/dio.dart";
import "package:exam_scanner/core/config/gemini_config.dart";
import "package:exam_scanner/core/error/failures.dart";
import "package:exam_scanner/features/scan/data/gemini_client.dart";
import "package:exam_scanner/features/scan/domain/answer_result.dart";

const String _oracleSystem =
    "You are an expert Google Cloud Associate Cloud Engineer (ACE) exam solver. "
    "Determine the single best answer to the question shown in the image. "
    "Respond with ONLY the answer token and nothing else: the option letter(s) "
    "(e.g. C, or 'A, C' for multi-select), or True/False, or the option number(s).";

Future<void> main(List<String> args) async {
  final String key = Platform.environment["GEMINI_API_KEY"] ?? "";
  if (key.isEmpty) {
    stderr.writeln("Set GEMINI_API_KEY.");
    exit(2);
  }
  if (args.isEmpty) {
    stderr.writeln("Usage: dart run tool/oracle_validate.dart <images_dir> [out_key.json]");
    exit(2);
  }
  final Directory dir = Directory(args.first);
  if (!dir.existsSync()) {
    stderr.writeln("Directory not found: ${args.first}");
    exit(2);
  }
  final String outPath = args.length > 1 ? args[1] : "${dir.path}/answer_key.draft.json";
  final String oracleModel = Platform.environment["ORACLE_MODEL"] ?? "gemini-2.5-pro";

  final List<File> images =
      dir
          .listSync()
          .whereType<File>()
          .where((File f) => RegExp(r"\.(jpe?g|png)$", caseSensitive: false).hasMatch(f.path))
          .toList()
        ..sort((File a, File b) => _natCompare(a.path, b.path));
  if (images.isEmpty) {
    stderr.writeln("No images found.");
    exit(2);
  }

  final String prompt = await File("assets/prompts/ace_solver_prompt.txt").readAsString();
  final Dio dio = Dio();
  final GeminiClient client = GeminiClient(dio: dio, apiKey: key);

  final Map<String, String> draftKey = <String, String>{};
  final List<String> review = <String>[];
  int agree = 0;

  stdout.writeln("flash=${GeminiConfig.model}  oracle=$oracleModel  images=${images.length}\n");
  for (final File image in images) {
    final String name = image.uri.pathSegments.last;
    final String mime = name.toLowerCase().endsWith(".png") ? "image/png" : "image/jpeg";
    final String base64Image = base64Encode(await image.readAsBytes());

    String flashAns = "?";
    String flashConf = "?";
    try {
      final String md = await client.analyze(
        prompt: prompt,
        base64Image: base64Image,
        mimeType: mime,
      );
      final AnswerResult r = AnswerResult.fromMarkdown(md);
      flashAns = r.quickAnswer.isEmpty ? "?" : r.quickAnswer;
      flashConf = r.confidence;
    } on ScanFailure catch (e) {
      flashAns = "FAIL(${e.runtimeType})";
    }

    String oracleAns = "?";
    try {
      oracleAns = await _askOracle(dio, key, oracleModel, base64Image, mime);
    } on Object {
      oracleAns = "FAIL";
    }

    draftKey[name] = oracleAns;

    final bool flashOk = flashAns != "?" && !flashAns.startsWith("FAIL");
    final bool oracleOk = oracleAns != "?" && !oracleAns.startsWith("FAIL");
    final bool agreed = flashOk && oracleOk && _norm(flashAns) == _norm(oracleAns);
    if (agreed) {
      agree++;
    }
    final bool needsReview = !agreed || flashConf == "Low" || flashConf == "Unknown";
    if (needsReview) {
      review.add(name);
    }

    stdout.writeln(
      "$name  flash=$flashAns ($flashConf)  oracle=$oracleAns  "
      "${agreed ? "AGREE" : "DIFF"}${needsReview ? "  <-- review" : ""}",
    );
  }

  await File(outPath).writeAsString(const JsonEncoder.withIndent("  ").convert(draftKey));

  stdout.writeln("\n${"=" * 52}");
  final String pct = (100 * agree / images.length).toStringAsFixed(0);
  stdout.writeln("Flash/oracle agreement: $agree / ${images.length} ($pct%)");
  stdout.writeln("Needs review (${review.length}): ${review.join(", ")}");
  stdout.writeln("Draft key: $outPath");
}

String _norm(String s) {
  final List<String> tokens = RegExp(
    r"[A-Za-z0-9]+",
  ).allMatches(s.toUpperCase()).map((RegExpMatch m) => m.group(0)!).toList()..sort();
  return tokens.join(",");
}

int _natCompare(String a, String b) {
  int an(String p) => int.tryParse(RegExp(r"(\d+)\.\w+$").firstMatch(p)?.group(1) ?? "") ?? 0;
  return an(a).compareTo(an(b));
}

Future<String> _askOracle(
  Dio dio,
  String key,
  String model,
  String base64Image,
  String mime,
) async {
  final Map<String, dynamic> body = <String, dynamic>{
    "system_instruction": <String, dynamic>{
      "parts": <Map<String, String>>[
        <String, String>{"text": _oracleSystem},
      ],
    },
    "contents": <Map<String, dynamic>>[
      <String, dynamic>{
        "parts": <Map<String, dynamic>>[
          <String, dynamic>{"text": "What is the single best answer? Reply with ONLY the token."},
          <String, dynamic>{
            "inline_data": <String, String>{"mime_type": mime, "data": base64Image},
          },
        ],
      },
    ],
    "generationConfig": <String, dynamic>{"temperature": 0.0, "maxOutputTokens": 8192},
  };

  for (int attempt = 1; attempt <= 2; attempt++) {
    try {
      final Response<Map<String, dynamic>> resp = await dio.post<Map<String, dynamic>>(
        "${GeminiConfig.baseUrl}/models/$model:generateContent",
        data: body,
        options: Options(
          headers: <String, String>{GeminiConfig.apiKeyHeader: key},
          sendTimeout: const Duration(seconds: 120),
          receiveTimeout: const Duration(seconds: 120),
        ),
      );
      final String t = AnswerResult.fromMarkdown(
        "## Best Answer\n\n${_extractText(resp.data)}",
      ).quickAnswer;
      return t.isEmpty ? "?" : t;
    } on DioException catch (e) {
      final int? code = e.response?.statusCode;
      final bool retryable = code == null || code >= 500 || code == 429;
      if (attempt == 2 || !retryable) {
        rethrow;
      }
    }
  }
  return "?";
}

String _extractText(Map<String, dynamic>? data) {
  if (data == null) {
    return "";
  }
  final List<dynamic>? candidates = data["candidates"] as List<dynamic>?;
  if (candidates == null || candidates.isEmpty) {
    return "";
  }
  final Map<String, dynamic>? content =
      (candidates.first as Map<String, dynamic>)["content"] as Map<String, dynamic>?;
  final List<dynamic>? parts = content?["parts"] as List<dynamic>?;
  if (parts == null) {
    return "";
  }
  return parts
      .map((dynamic p) => (p as Map<String, dynamic>)["text"]?.toString() ?? "")
      .join()
      .trim();
}
