// Model comparison harness (Wave 5): gemini-3.5-flash (our prod config) vs
// gemini-3.1-pro-preview, on the same images with the same prod prompt.
//
// Records per model: answer token, confidence, latency, and token usage
// (prompt / output / thinking) so cost can be computed. Writes a JSON with all
// per-image data for later accuracy adjudication, and prints aggregates.
//
// Usage:
//   GEMINI_API_KEY=<key> dart run tool/model_compare.dart <images_dir> <out.json>
//   (optional) PRO_MODEL=gemini-3.1-pro-preview
//
// Flutter-free imports so it runs under a plain `dart run`.
import "dart:convert";
import "dart:io";

import "package:dio/dio.dart";
import "package:exam_scanner/core/config/gemini_config.dart";
import "package:exam_scanner/features/scan/domain/answer_result.dart";

// Paid-tier rates ($/1M tokens). Pro output includes thinking tokens.
const double _flashIn = 1.50;
const double _flashOut = 9.00;
const double _proIn = 2.00;
const double _proOut = 12.00;

class _Call {
  _Call({
    required this.answer,
    required this.confidence,
    required this.latencyMs,
    required this.promptTok,
    required this.outTok,
    required this.thoughtTok,
    required this.finish,
    required this.ok,
  });

  final String answer;
  final String confidence;
  final int latencyMs;
  final int promptTok;
  final int outTok; // candidates + thoughts (both billed at output rate)
  final int thoughtTok;
  final String finish;
  final bool ok;

  Map<String, dynamic> toJson() => <String, dynamic>{
    "answer": answer,
    "confidence": confidence,
    "latencyMs": latencyMs,
    "promptTok": promptTok,
    "outTok": outTok,
    "thoughtTok": thoughtTok,
    "finish": finish,
    "ok": ok,
  };
}

Future<void> main(List<String> args) async {
  final String key = Platform.environment["GEMINI_API_KEY"] ?? "";
  if (key.isEmpty || args.length < 2) {
    stderr.writeln(
      "Usage: GEMINI_API_KEY=<key> dart run tool/model_compare.dart <images_dir> <out.json>",
    );
    exit(2);
  }
  final Directory dir = Directory(args[0]);
  final String outJson = args[1];
  final String proModel = Platform.environment["PRO_MODEL"] ?? "gemini-3.1-pro-preview";

  final List<File> images =
      dir
          .listSync()
          .whereType<File>()
          .where((File f) => RegExp(r"\.(jpe?g|png)$", caseSensitive: false).hasMatch(f.path))
          .toList()
        ..sort((File a, File b) => _natKey(a.path).compareTo(_natKey(b.path)));
  if (images.isEmpty) {
    stderr.writeln("No images in ${dir.path}");
    exit(2);
  }

  final String prompt = await File("assets/prompts/ace_solver_prompt.txt").readAsString();
  final Dio dio = Dio();
  final List<Map<String, dynamic>> records = <Map<String, dynamic>>[];

  int flashLat = 0, proLat = 0, flashIn = 0, flashOut = 0, proIn = 0, proOut = 0;
  int flashOk = 0, proOk = 0, agree = 0;

  stdout.writeln("flash=${GeminiConfig.model}  pro=$proModel  images=${images.length}\n");
  for (final File image in images) {
    final String name = image.uri.pathSegments.last;
    final String mime = name.toLowerCase().endsWith(".png") ? "image/png" : "image/jpeg";
    final String b64 = base64Encode(await image.readAsBytes());

    // Flash: our production config (thinking off, 4096 cap).
    final _Call f = await _call(
      dio,
      key,
      GeminiConfig.model,
      prompt,
      b64,
      mime,
      4096,
      thinkingBudget: 0,
    );
    // Pro: thinking on (its natural mode), generous cap so it isn't truncated.
    final _Call p = await _call(dio, key, proModel, prompt, b64, mime, 16384);

    records.add(<String, dynamic>{"file": name, "flash": f.toJson(), "pro": p.toJson()});
    flashLat += f.latencyMs;
    proLat += p.latencyMs;
    flashIn += f.promptTok;
    flashOut += f.outTok;
    proIn += p.promptTok;
    proOut += p.outTok;
    if (f.ok) {
      flashOk++;
    }
    if (p.ok) {
      proOk++;
    }
    final bool agreed = f.ok && p.ok && _norm(f.answer) == _norm(p.answer);
    if (agreed) {
      agree++;
    }
    stdout.writeln(
      "$name\n  flash=${f.answer} (${f.confidence}, ${f.latencyMs}ms)  "
      "pro=${p.answer} (${p.confidence}, ${p.latencyMs}ms, think:${p.thoughtTok}t)  "
      "${agreed ? "AGREE" : "DIFF"}",
    );
  }

  await File(outJson).writeAsString(const JsonEncoder.withIndent("  ").convert(records));

  final int n = images.length;
  final double flashCost = (flashIn * _flashIn + flashOut * _flashOut) / 1e6;
  final double proCost = (proIn * _proIn + proOut * _proOut) / 1e6;

  stdout.writeln("\n${"=" * 60}");
  stdout.writeln("Images: $n");
  stdout.writeln("Succeeded   flash=$flashOk  pro=$proOk");
  stdout.writeln("Agreement   $agree / $n (${(100 * agree / n).toStringAsFixed(0)}%)");
  stdout.writeln("Avg latency flash=${flashLat ~/ n}ms  pro=${proLat ~/ n}ms");
  stdout.writeln("Tokens in   flash=$flashIn  pro=$proIn");
  stdout.writeln("Tokens out  flash=$flashOut  pro=$proOut");
  stdout.writeln(
    "Cost ($n)   flash=\$${flashCost.toStringAsFixed(4)}  pro=\$${proCost.toStringAsFixed(4)}",
  );
  stdout.writeln(
    "Cost/scan   flash=\$${(flashCost / n).toStringAsFixed(5)}  pro=\$${(proCost / n).toStringAsFixed(5)}",
  );
  stdout.writeln("JSON: $outJson");
}

String _norm(String s) {
  final List<String> t = RegExp(
    r"[A-Za-z0-9]+",
  ).allMatches(s.toUpperCase()).map((RegExpMatch m) => m.group(0)!).toList()..sort();
  return t.join(",");
}

int _natKey(String path) =>
    int.tryParse(RegExp(r"(\d+)\.\w+$").firstMatch(path)?.group(1) ?? "") ?? 0;

Future<_Call> _call(
  Dio dio,
  String key,
  String model,
  String prompt,
  String b64,
  String mime,
  int maxTok, {
  int? thinkingBudget,
}) async {
  final Map<String, dynamic> gen = <String, dynamic>{"temperature": 0.2, "maxOutputTokens": maxTok};
  if (thinkingBudget != null) {
    gen["thinkingConfig"] = <String, dynamic>{"thinkingBudget": thinkingBudget};
  }
  final Map<String, dynamic> body = <String, dynamic>{
    "system_instruction": <String, dynamic>{
      "parts": <Map<String, String>>[
        <String, String>{"text": prompt},
      ],
    },
    "contents": <Map<String, dynamic>>[
      <String, dynamic>{
        "parts": <Map<String, dynamic>>[
          <String, dynamic>{
            "text":
                "Analyze the exam question in this image. Paraphrase the question and options "
                "in your own words; never reproduce the source text verbatim.",
          },
          <String, dynamic>{
            "inline_data": <String, String>{"mime_type": mime, "data": b64},
          },
        ],
      },
    ],
    "generationConfig": gen,
  };

  final Stopwatch sw = Stopwatch()..start();
  for (int attempt = 1; attempt <= 3; attempt++) {
    try {
      final Response<Map<String, dynamic>> resp = await dio.post<Map<String, dynamic>>(
        "${GeminiConfig.baseUrl}/models/$model:generateContent",
        data: body,
        options: Options(
          headers: <String, String>{GeminiConfig.apiKeyHeader: key},
          sendTimeout: const Duration(seconds: 180),
          receiveTimeout: const Duration(seconds: 180),
        ),
      );
      sw.stop();
      final Map<String, dynamic> data = resp.data ?? <String, dynamic>{};
      final List<dynamic> cands = (data["candidates"] as List<dynamic>?) ?? <dynamic>[];
      final Map<String, dynamic>? cand = cands.isEmpty ? null : cands.first as Map<String, dynamic>;
      final String finish = cand?["finishReason"]?.toString() ?? "?";
      final List<dynamic> parts =
          ((cand?["content"] as Map<String, dynamic>?)?["parts"] as List<dynamic>?) ?? <dynamic>[];
      final String text = parts
          .map((dynamic p) => (p as Map<String, dynamic>)["text"]?.toString() ?? "")
          .join()
          .trim();
      final Map<String, dynamic> usage =
          (data["usageMetadata"] as Map<String, dynamic>?) ?? <String, dynamic>{};
      final int promptTok = (usage["promptTokenCount"] as num?)?.toInt() ?? 0;
      final int candTok = (usage["candidatesTokenCount"] as num?)?.toInt() ?? 0;
      final int thoughtTok = (usage["thoughtsTokenCount"] as num?)?.toInt() ?? 0;
      final AnswerResult r = AnswerResult.fromMarkdown(text);
      return _Call(
        answer: r.quickAnswer.isEmpty ? "?" : r.quickAnswer,
        confidence: r.confidence,
        latencyMs: sw.elapsedMilliseconds,
        promptTok: promptTok,
        outTok: candTok + thoughtTok,
        thoughtTok: thoughtTok,
        finish: finish,
        ok: text.isNotEmpty,
      );
    } on DioException catch (e) {
      final int? code = e.response?.statusCode;
      final bool retryable = code == null || code >= 500 || code == 429;
      if (attempt == 3 || !retryable) {
        sw.stop();
        return _Call(
          answer: "FAIL($code)",
          confidence: "?",
          latencyMs: sw.elapsedMilliseconds,
          promptTok: 0,
          outTok: 0,
          thoughtTok: 0,
          finish: "ERROR",
          ok: false,
        );
      }
    }
  }
  sw.stop();
  return _Call(
    answer: "FAIL",
    confidence: "?",
    latencyMs: sw.elapsedMilliseconds,
    promptTok: 0,
    outTok: 0,
    thoughtTok: 0,
    finish: "ERROR",
    ok: false,
  );
}
