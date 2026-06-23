import "dart:typed_data";

import "package:exam_scanner/features/scan/domain/answer_result.dart";
import "package:exam_scanner/features/scan/presentation/scan_state.dart";
import "package:exam_scanner/features/scan/presentation/widgets/scan_status_overlay.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

Widget _host(ScanState state, {VoidCallback? onReset, VoidCallback? onRetry}) {
  return MaterialApp(
    home: Scaffold(
      body: ScanStatusOverlay(state: state, onReset: onReset ?? () {}, onRetry: onRetry ?? () {}),
    ),
  );
}

void main() {
  const AnswerResult answer = AnswerResult(
    rawMarkdown: "## Best Answer\n\nB",
    bestAnswer: "B",
    confidence: "High",
    reconstructedQuestion: "Q",
  );

  testWidgets("result state shows the best-answer badge", (WidgetTester tester) async {
    await tester.pumpWidget(_host(ScanState.result(answer, Uint8List(0))));
    await tester.pumpAndSettle();

    expect(find.textContaining("Best answer"), findsOneWidget);
    expect(find.textContaining("High"), findsWidgets);
  });

  testWidgets("error with a frame shows Try again and fires onRetry", (WidgetTester tester) async {
    bool retried = false;
    await tester.pumpWidget(
      _host(
        ScanState.error("Network problem.", frame: Uint8List(0)),
        onRetry: () => retried = true,
      ),
    );

    expect(find.text("Try again"), findsOneWidget);
    await tester.tap(find.text("Try again"));
    expect(retried, isTrue);
  });

  testWidgets("error without a frame hides Try again", (WidgetTester tester) async {
    await tester.pumpWidget(_host(const ScanState.error("Couldn't capture.")));

    expect(find.text("Try again"), findsNothing);
    expect(find.text("Back to camera"), findsOneWidget);
  });
}
