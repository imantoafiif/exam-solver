// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeminiRequest _$GeminiRequestFromJson(Map<String, dynamic> json) =>
    _GeminiRequest(
      systemInstruction: GeminiContent.fromJson(
        json['system_instruction'] as Map<String, dynamic>,
      ),
      contents: (json['contents'] as List<dynamic>)
          .map((e) => GeminiContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      generationConfig: GeminiGenerationConfig.fromJson(
        json['generationConfig'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$GeminiRequestToJson(_GeminiRequest instance) =>
    <String, dynamic>{
      'system_instruction': instance.systemInstruction,
      'contents': instance.contents,
      'generationConfig': instance.generationConfig,
    };

_GeminiContent _$GeminiContentFromJson(Map<String, dynamic> json) =>
    _GeminiContent(
      parts: (json['parts'] as List<dynamic>?)
          ?.map((e) => GeminiPart.fromJson(e as Map<String, dynamic>))
          .toList(),
      role: json['role'] as String?,
    );

Map<String, dynamic> _$GeminiContentToJson(_GeminiContent instance) =>
    <String, dynamic>{'parts': ?instance.parts, 'role': ?instance.role};

_GeminiPart _$GeminiPartFromJson(Map<String, dynamic> json) => _GeminiPart(
  text: json['text'] as String?,
  inlineData: json['inline_data'] == null
      ? null
      : GeminiInlineData.fromJson(json['inline_data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GeminiPartToJson(_GeminiPart instance) =>
    <String, dynamic>{
      'text': ?instance.text,
      'inline_data': ?instance.inlineData,
    };

_GeminiInlineData _$GeminiInlineDataFromJson(Map<String, dynamic> json) =>
    _GeminiInlineData(
      mimeType: json['mime_type'] as String,
      data: json['data'] as String,
    );

Map<String, dynamic> _$GeminiInlineDataToJson(_GeminiInlineData instance) =>
    <String, dynamic>{'mime_type': instance.mimeType, 'data': instance.data};

_GeminiGenerationConfig _$GeminiGenerationConfigFromJson(
  Map<String, dynamic> json,
) => _GeminiGenerationConfig(
  temperature: (json['temperature'] as num).toDouble(),
  maxOutputTokens: (json['maxOutputTokens'] as num).toInt(),
  thinkingConfig: json['thinkingConfig'] == null
      ? null
      : GeminiThinkingConfig.fromJson(
          json['thinkingConfig'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$GeminiGenerationConfigToJson(
  _GeminiGenerationConfig instance,
) => <String, dynamic>{
  'temperature': instance.temperature,
  'maxOutputTokens': instance.maxOutputTokens,
  'thinkingConfig': ?instance.thinkingConfig,
};

_GeminiThinkingConfig _$GeminiThinkingConfigFromJson(
  Map<String, dynamic> json,
) => _GeminiThinkingConfig(
  thinkingBudget: (json['thinkingBudget'] as num).toInt(),
);

Map<String, dynamic> _$GeminiThinkingConfigToJson(
  _GeminiThinkingConfig instance,
) => <String, dynamic>{'thinkingBudget': instance.thinkingBudget};
