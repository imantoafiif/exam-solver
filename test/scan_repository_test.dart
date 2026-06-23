import "dart:convert";

import "package:dio/dio.dart";
import "package:exam_scanner/core/error/failures.dart";
import "package:exam_scanner/core/prompt/prompt_loader.dart";
import "package:exam_scanner/features/scan/data/gemini_client.dart";
import "package:exam_scanner/features/scan/data/scan_repository.dart";
import "package:exam_scanner/features/scan/domain/answer_result.dart";
import "package:exam_scanner/features/scan/domain/scan_repository_ref.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

/// Returns a canned HTTP response for every request (no real network).
class _StubAdapter implements HttpClientAdapter {
  _StubAdapter({required this.statusCode, required this.body});

  final int statusCode;
  final String body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      body,
      statusCode,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>["application/json"],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _FakeBundle extends AssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async => "ACE prompt";

  @override
  Future<ByteData> load(String key) => throw UnimplementedError();
}

String _geminiBody(String markdown) {
  return jsonEncode(<String, dynamic>{
    "candidates": <Map<String, dynamic>>[
      <String, dynamic>{
        "content": <String, dynamic>{
          "parts": <Map<String, dynamic>>[
            <String, dynamic>{"text": markdown},
          ],
          "role": "model",
        },
        "finishReason": "STOP",
      },
    ],
  });
}

ScanRepository _repositoryWith({required int statusCode, required String body}) {
  final Dio dio = Dio()..httpClientAdapter = _StubAdapter(statusCode: statusCode, body: body);
  return GeminiScanRepository(
    client: GeminiClient(dio: dio, apiKey: "test-key"),
    promptLoader: PromptLoader(_FakeBundle()),
  );
}

void main() {
  group("GeminiScanRepository", () {
    test("parses a successful response into an AnswerResult", () async {
      const String markdown =
          "## Reconstructed Question\n\nQ\n\n## Best Answer\n\n**B**\n\n## Confidence\n\nHigh\n";
      final ScanRepository repo = _repositoryWith(statusCode: 200, body: _geminiBody(markdown));

      final AnswerResult result = await repo.analyzeImage(Uint8List.fromList(<int>[1, 2, 3]));

      expect(result.bestAnswer, "B");
      expect(result.confidence, "High");
      // The client trims surrounding whitespace from the model's text.
      expect(result.rawMarkdown, markdown.trim());
    });

    test("maps a 4xx response to ApiFailure", () async {
      final ScanRepository repo = _repositoryWith(
        statusCode: 400,
        body: jsonEncode(<String, dynamic>{
          "error": <String, dynamic>{"message": "bad request"},
        }),
      );

      expect(repo.analyzeImage(Uint8List.fromList(<int>[1])), throwsA(isA<ApiFailure>()));
    });
  });
}
