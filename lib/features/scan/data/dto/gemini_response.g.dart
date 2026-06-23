// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeminiResponse _$GeminiResponseFromJson(Map<String, dynamic> json) =>
    _GeminiResponse(
      candidates: (json['candidates'] as List<dynamic>?)
          ?.map((e) => GeminiCandidate.fromJson(e as Map<String, dynamic>))
          .toList(),
      promptFeedback: json['promptFeedback'] == null
          ? null
          : GeminiPromptFeedback.fromJson(
              json['promptFeedback'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$GeminiResponseToJson(_GeminiResponse instance) =>
    <String, dynamic>{
      'candidates': instance.candidates,
      'promptFeedback': instance.promptFeedback,
    };

_GeminiCandidate _$GeminiCandidateFromJson(Map<String, dynamic> json) =>
    _GeminiCandidate(
      content: json['content'] == null
          ? null
          : GeminiContent.fromJson(json['content'] as Map<String, dynamic>),
      finishReason: json['finishReason'] as String?,
    );

Map<String, dynamic> _$GeminiCandidateToJson(_GeminiCandidate instance) =>
    <String, dynamic>{
      'content': instance.content,
      'finishReason': instance.finishReason,
    };

_GeminiPromptFeedback _$GeminiPromptFeedbackFromJson(
  Map<String, dynamic> json,
) => _GeminiPromptFeedback(blockReason: json['blockReason'] as String?);

Map<String, dynamic> _$GeminiPromptFeedbackToJson(
  _GeminiPromptFeedback instance,
) => <String, dynamic>{'blockReason': instance.blockReason};
