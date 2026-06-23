import "package:freezed_annotation/freezed_annotation.dart";

part "gemini_request.freezed.dart";
part "gemini_request.g.dart";

/// Top-level request body for the Gemini `generateContent` endpoint.
@freezed
abstract class GeminiRequest with _$GeminiRequest {
  const factory GeminiRequest({
    @JsonKey(name: "system_instruction") required GeminiContent systemInstruction,
    required List<GeminiContent> contents,
    required GeminiGenerationConfig generationConfig,
  }) = _GeminiRequest;

  factory GeminiRequest.fromJson(Map<String, dynamic> json) => _$GeminiRequestFromJson(json);
}

/// A content block: an ordered list of [GeminiPart]s with an optional role.
/// Used for both the request and (when decoding) the response.
@freezed
abstract class GeminiContent with _$GeminiContent {
  const factory GeminiContent({
    required List<GeminiPart> parts,
    @JsonKey(includeIfNull: false) String? role,
  }) = _GeminiContent;

  factory GeminiContent.fromJson(Map<String, dynamic> json) => _$GeminiContentFromJson(json);
}

/// A single part — either text or inline image data (never both populated).
@freezed
abstract class GeminiPart with _$GeminiPart {
  const factory GeminiPart({
    @JsonKey(includeIfNull: false) String? text,
    @JsonKey(name: "inline_data", includeIfNull: false) GeminiInlineData? inlineData,
  }) = _GeminiPart;

  factory GeminiPart.fromJson(Map<String, dynamic> json) => _$GeminiPartFromJson(json);
}

/// Base64-encoded inline image payload.
@freezed
abstract class GeminiInlineData with _$GeminiInlineData {
  const factory GeminiInlineData({
    @JsonKey(name: "mime_type") required String mimeType,
    required String data,
  }) = _GeminiInlineData;

  factory GeminiInlineData.fromJson(Map<String, dynamic> json) => _$GeminiInlineDataFromJson(json);
}

/// Generation tuning sent with each request.
@freezed
abstract class GeminiGenerationConfig with _$GeminiGenerationConfig {
  const factory GeminiGenerationConfig({
    required double temperature,
    required int maxOutputTokens,
  }) = _GeminiGenerationConfig;

  factory GeminiGenerationConfig.fromJson(Map<String, dynamic> json) =>
      _$GeminiGenerationConfigFromJson(json);
}
