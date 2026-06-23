import "package:freezed_annotation/freezed_annotation.dart";

part "answer_result.freezed.dart";

/// UI-ready result of analyzing an exam image.
///
/// [rawMarkdown] is the full model output in the PRD §18 format and is what the
/// result screen renders. The other fields are cheap extractions used for
/// emphasis (e.g. showing the best-answer letter prominently).
@freezed
abstract class AnswerResult with _$AnswerResult {
  const AnswerResult._();

  const factory AnswerResult({
    required String rawMarkdown,
    required String bestAnswer,
    required String confidence,
    required String reconstructedQuestion,
  }) = _AnswerResult;

  /// Parses the model's markdown output into an [AnswerResult]. Extraction is
  /// best-effort; the full markdown is always preserved in [rawMarkdown].
  factory AnswerResult.fromMarkdown(String markdown) {
    return AnswerResult(
      rawMarkdown: markdown,
      bestAnswer: _bestAnswer(markdown),
      confidence: _confidence(markdown),
      reconstructedQuestion: _section(markdown, "Reconstructed Question"),
    );
  }
}

/// Returns the body under a `## <header>` section up to the next `## ` heading.
String _section(String md, String header) {
  final RegExp re = RegExp(
    "##\\s*${RegExp.escape(header)}\\s*\\n+([\\s\\S]*?)(?=\\n##\\s|\$)",
    caseSensitive: false,
  );
  return re.firstMatch(md)?.group(1)?.trim() ?? "";
}

/// First A–E letter found in the Best Answer section, or "" if absent.
String _bestAnswer(String md) {
  final String section = _section(md, "Best Answer");
  return RegExp("[A-E]").firstMatch(section)?.group(0) ?? "";
}

/// Normalizes the Confidence section to High / Medium / Low, else "Unknown".
String _confidence(String md) {
  final String section = _section(md, "Confidence");
  final RegExpMatch? m = RegExp("high|medium|low", caseSensitive: false).firstMatch(section);
  if (m == null) {
    return "Unknown";
  }
  final String v = m.group(0)!.toLowerCase();
  return "${v[0].toUpperCase()}${v.substring(1)}";
}
