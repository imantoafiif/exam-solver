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

/// The answer letter from the Best Answer section, or "" if absent.
///
/// Tries the most specific patterns first so prose like "Cloud Run" can't be
/// mistaken for option "C" (a bare `[A-E]` scan would match the C in "Cloud").
String _bestAnswer(String md) {
  final String section = _section(md, "Best Answer");
  final List<RegExp> patterns = <RegExp>[
    RegExp(r"\*\*\s*([A-E])\b"), // **C** or **C)
    RegExp(r"\b([A-E])[).:]"), // C) or C. or C:
    RegExp(r"answer\s*(?:is|:)?\s*\*{0,2}([A-E])\b", caseSensitive: false),
    RegExp(r"(?<![A-Za-z])([A-E])(?![A-Za-z])"), // a standalone letter
  ];
  for (final RegExp re in patterns) {
    final RegExpMatch? match = re.firstMatch(section);
    if (match != null) {
      return match.group(1)!;
    }
  }
  return "";
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
