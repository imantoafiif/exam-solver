import "package:exam_scanner/features/scan/presentation/widgets/quick_answer_overlay.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("QuickAnswerOverlay.colorForAnswer", () {
    test("maps A→red, B→yellow, C→green, D→blue (rainbow order)", () {
      expect(QuickAnswerOverlay.colorForAnswer("A"), Colors.red.shade600);
      expect(QuickAnswerOverlay.colorForAnswer("B"), Colors.amber.shade600);
      expect(QuickAnswerOverlay.colorForAnswer("C"), Colors.green.shade600);
      expect(QuickAnswerOverlay.colorForAnswer("D"), Colors.blue.shade600);
    });

    test("handles true/false and numbers", () {
      expect(QuickAnswerOverlay.colorForAnswer("True"), Colors.green.shade600);
      expect(QuickAnswerOverlay.colorForAnswer("2"), Colors.amber.shade600);
    });

    test("returns null for tokens it can't confidently color", () {
      expect(QuickAnswerOverlay.colorForAnswer("A, C"), isNull);
      expect(QuickAnswerOverlay.colorForAnswer(""), isNull);
    });
  });
}
