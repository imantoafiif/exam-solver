import "dart:typed_data";

import "package:exam_scanner/features/scan/domain/answer_result.dart";
import "package:exam_scanner/features/scan/presentation/scan_state.dart";
import "package:exam_scanner/features/scan/presentation/widgets/scan_status_overlay.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

Widget _host(
  ScanState state, {
  VoidCallback? onReset,
  VoidCallback? onRetry,
  bool quickMode = false,
  bool coloredOverlay = false,
}) {
  return MaterialApp(
    home: Scaffold(
      body: ScanStatusOverlay(
        state: state,
        onReset: onReset ?? () {},
        onRetry: onRetry ?? () {},
        quickMode: quickMode,
        coloredOverlay: coloredOverlay,
      ),
    ),
  );
}

void main() {
  const AnswerResult answer = AnswerResult(
    rawMarkdown: "## Best Answer\n\nB",
    bestAnswer: "B",
    confidence: "High",
    reconstructedQuestion: "Q",
    quickAnswer: "B",
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

  testWidgets("quick mode shows the big token and dismisses to onReset", (
    WidgetTester tester,
  ) async {
    bool done = false;
    await tester.pumpWidget(
      _host(ScanState.result(answer, Uint8List(0)), quickMode: true, onReset: () => done = true),
    );
    await tester.pump();

    // Big token shown, no detailed pane.
    expect(find.text("B"), findsOneWidget);
    expect(find.textContaining("Best answer"), findsNothing);

    // Tap dismisses immediately (no transition) and triggers onReset.
    await tester.tap(find.text("B"));
    await tester.pump();
    expect(done, isTrue);
  });

  testWidgets("quick mode shows multi-select answers sequentially, 2.5s each", (
    WidgetTester tester,
  ) async {
    const AnswerResult multi = AnswerResult(
      rawMarkdown: "## Best Answer\n\nA, C, F",
      bestAnswer: "A",
      confidence: "High",
      reconstructedQuestion: "Q",
      quickAnswer: "A, C, F",
    );
    bool done = false;
    await tester.pumpWidget(
      _host(ScanState.result(multi, Uint8List(0)), quickMode: true, onReset: () => done = true),
    );
    await tester.pump();

    // Only the first token shows initially (sequential, not side-by-side).
    expect(find.text("A"), findsOneWidget);
    expect(find.text("C"), findsNothing);

    // After 2.5s → second token; after another 2.5s → third.
    await tester.pump(const Duration(milliseconds: 2500));
    expect(find.text("C"), findsOneWidget);
    expect(find.text("A"), findsNothing);

    await tester.pump(const Duration(milliseconds: 2500));
    expect(find.text("F"), findsOneWidget);

    // After the last token's 2.5s, control returns to the camera (onReset).
    await tester.pump(const Duration(milliseconds: 2500));
    expect(done, isTrue);
  });
}
