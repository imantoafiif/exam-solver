import "package:freezed_annotation/freezed_annotation.dart";

import "gemini_request.dart";

part "gemini_response.freezed.dart";
part "gemini_response.g.dart";

/// Top-level response body from the Gemini `generateContent` endpoint.
@freezed
abstract class GeminiResponse with _$GeminiResponse {
  const factory GeminiResponse({
    List<GeminiCandidate>? candidates,
    GeminiPromptFeedback? promptFeedback,
  }) = _GeminiResponse;

  factory GeminiResponse.fromJson(Map<String, dynamic> json) => _$GeminiResponseFromJson(json);
}

/// A single generated candidate.
@freezed
abstract class GeminiCandidate with _$GeminiCandidate {
  const factory GeminiCandidate({GeminiContent? content, String? finishReason}) = _GeminiCandidate;

  factory GeminiCandidate.fromJson(Map<String, dynamic> json) => _$GeminiCandidateFromJson(json);
}

/// Prompt-level feedback; [blockReason] is set when the request was blocked.
@freezed
abstract class GeminiPromptFeedback with _$GeminiPromptFeedback {
  const factory GeminiPromptFeedback({String? blockReason}) = _GeminiPromptFeedback;

  factory GeminiPromptFeedback.fromJson(Map<String, dynamic> json) =>
      _$GeminiPromptFeedbackFromJson(json);
}
