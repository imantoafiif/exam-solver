import "package:exam_scanner/features/scan/domain/answer_result.dart";
import "package:flutter_test/flutter_test.dart";

const String _sample = """
## Reconstructed Question

A company needs to run a stateless container with minimal ops. What should they use?

## Question Summary

Pick the managed, serverless option.

## Key Requirements

- Stateless
- Minimal operations

## Option Analysis

### A
Compute Engine — too much ops overhead.

### B
Cloud Run — managed, serverless, scales to zero.

## Best Answer

B

## Explanation

Cloud Run is the managed serverless choice.

## Confidence

High

## Assumptions

None.
""";

void main() {
  group("AnswerResult.fromMarkdown", () {
    test("extracts best answer, confidence, and question", () {
      // Act
      final AnswerResult result = AnswerResult.fromMarkdown(_sample);

      // Assert
      expect(result.bestAnswer, "B");
      expect(result.confidence, "High");
      expect(result.reconstructedQuestion, contains("stateless container"));
      expect(result.rawMarkdown, _sample);
    });

    test("does not mistake prose like 'Cloud Run' for option C", () {
      const String md = "## Best Answer\n\nThe correct answer is **B) Cloud Run**.\n";
      expect(AnswerResult.fromMarkdown(md).bestAnswer, "B");
    });

    test("extracts a bare letter answer", () {
      const String md = "## Best Answer\n\nC\n";
      expect(AnswerResult.fromMarkdown(md).bestAnswer, "C");
    });

    test("degrades gracefully when sections are missing", () {
      // Act
      final AnswerResult result = AnswerResult.fromMarkdown("no headers here");

      // Assert
      expect(result.bestAnswer, "");
      expect(result.confidence, "Unknown");
      expect(result.reconstructedQuestion, "");
      expect(result.rawMarkdown, "no headers here");
    });
  });
}
