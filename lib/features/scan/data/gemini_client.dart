import "dart:developer" as developer;

import "package:dio/dio.dart";

import "../../../core/config/gemini_config.dart";
import "../../../core/error/failures.dart";
import "dto/gemini_request.dart";
import "dto/gemini_response.dart";

/// Thin wrapper around the Gemini Developer API `generateContent` endpoint.
///
/// Sends the system prompt plus a single inline JPEG and returns the model's
/// raw markdown text. Errors surface as [ScanFailure] subtypes. This class is
/// intentionally free of Flutter/Riverpod imports so it can run under a plain
/// `dart run` smoke test; wiring lives in `scan_providers.dart`.
class GeminiClient {
  GeminiClient({required this._dio, required this._apiKey});

  final Dio _dio;
  final String _apiKey;

  static const int _maxAttempts = 2;

  /// Analyzes [base64Image] with [prompt] as the system instruction and returns
  /// the model's markdown text. Retries once on transient network/5xx errors.
  Future<String> analyze({required String prompt, required String base64Image}) async {
    if (_apiKey.isEmpty) {
      throw const ConfigFailure("GEMINI_API_KEY is not set. Add it to .env.");
    }

    final GeminiRequest request = GeminiRequest(
      systemInstruction: GeminiContent(parts: <GeminiPart>[GeminiPart(text: prompt)]),
      contents: <GeminiContent>[
        GeminiContent(
          parts: <GeminiPart>[
            const GeminiPart(text: "Analyze the exam question in this image."),
            GeminiPart(
              inlineData: GeminiInlineData(mimeType: GeminiConfig.imageMimeType, data: base64Image),
            ),
          ],
        ),
      ],
      generationConfig: const GeminiGenerationConfig(
        temperature: GeminiConfig.temperature,
        maxOutputTokens: GeminiConfig.maxOutputTokens,
      ),
    );

    for (int attempt = 1; attempt <= _maxAttempts; attempt++) {
      try {
        final Response<Map<String, dynamic>> response = await _dio.post<Map<String, dynamic>>(
          GeminiConfig.generateContentUrl,
          data: request.toJson(),
          options: Options(
            headers: <String, String>{GeminiConfig.apiKeyHeader: _apiKey},
            sendTimeout: GeminiConfig.requestTimeout,
            receiveTimeout: GeminiConfig.requestTimeout,
          ),
        );
        return _extractText(response.data);
      } on DioException catch (e) {
        if (!_isRetriable(e) || attempt == _maxAttempts) {
          throw _mapDioError(e);
        }
        developer.log(
          "Gemini request failed (attempt $attempt of $_maxAttempts), retrying",
          name: "GeminiClient",
          error: e,
        );
      }
    }
    // Loop always returns or throws above; this satisfies the analyzer.
    throw const NetworkFailure("Gemini request failed.");
  }

  String _extractText(Map<String, dynamic>? data) {
    if (data == null) {
      throw const EmptyResponseFailure("Gemini returned an empty body.");
    }
    final GeminiResponse parsed;
    try {
      parsed = GeminiResponse.fromJson(data);
    } on Object catch (e) {
      throw ParseFailure("Could not parse Gemini response: $e");
    }

    final String? block = parsed.promptFeedback?.blockReason;
    if (block != null) {
      throw EmptyResponseFailure("Gemini blocked the request: $block");
    }

    final List<GeminiCandidate>? candidates = parsed.candidates;
    if (candidates == null || candidates.isEmpty) {
      throw const EmptyResponseFailure("Gemini returned no candidates.");
    }

    final List<GeminiPart> parts = candidates.first.content?.parts ?? <GeminiPart>[];
    final String text = parts.map((GeminiPart p) => p.text ?? "").join().trim();
    if (text.isEmpty) {
      throw const EmptyResponseFailure("Gemini returned no text content.");
    }
    return text;
  }

  bool _isRetriable(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final int? code = e.response?.statusCode;
        return code != null && code >= 500;
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return false;
    }
  }

  ScanFailure _mapDioError(DioException e) {
    if (e.type == DioExceptionType.badResponse) {
      final int? code = e.response?.statusCode;
      final String detail = _apiErrorMessage(e.response?.data) ?? e.message ?? "request failed";
      return ApiFailure("Gemini API error ($code): $detail", statusCode: code);
    }
    return NetworkFailure(e.message ?? "Network error contacting Gemini.");
  }

  String? _apiErrorMessage(Object? data) {
    if (data is Map && data["error"] is Map) {
      final Object? msg = (data["error"] as Map)["message"];
      if (msg is String) {
        return msg;
      }
    }
    return null;
  }
}
