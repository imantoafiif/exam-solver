import "dart:typed_data";

import "package:exam_scanner/core/error/failures.dart";
import "package:exam_scanner/features/scan/data/scan_providers.dart";
import "package:exam_scanner/features/scan/domain/answer_result.dart";
import "package:exam_scanner/features/scan/domain/scan_repository_ref.dart";
import "package:exam_scanner/features/scan/presentation/scan_controller.dart";
import "package:exam_scanner/features/scan/presentation/scan_state.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";

class _FakeRepository implements ScanRepository {
  _FakeRepository({this.result, this.failure});

  AnswerResult? result;
  ScanFailure? failure;

  @override
  Future<AnswerResult> analyzeImage(Uint8List jpegBytes) async {
    final ScanFailure? f = failure;
    if (f != null) {
      throw f;
    }
    return result!;
  }
}

ProviderContainer _containerWith(ScanRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [scanRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

Future<Uint8List> _fakeCapture() async => Uint8List(0);

void main() {
  const AnswerResult answer = AnswerResult(
    rawMarkdown: "## Best Answer\n\nB",
    bestAnswer: "B",
    confidence: "High",
    reconstructedQuestion: "Q",
  );

  group("ScanController", () {
    test("starts idle in cameraReady", () {
      final ProviderContainer container = _containerWith(_FakeRepository(result: answer));
      expect(container.read(scanControllerProvider), isA<ScanCameraReady>());
    });

    test("a successful scan ends in result with the answer", () async {
      final ProviderContainer container = _containerWith(_FakeRepository(result: answer));

      await container.read(scanControllerProvider.notifier).scan(_fakeCapture);

      final ScanState state = container.read(scanControllerProvider);
      expect(state, isA<ScanResult>());
      expect((state as ScanResult).answer.bestAnswer, "B");
    });

    test("a ScanFailure ends in error with a friendly message and the frame", () async {
      final ProviderContainer container = _containerWith(
        _FakeRepository(failure: const NetworkFailure("offline")),
      );

      await container.read(scanControllerProvider.notifier).scan(_fakeCapture);

      final ScanState state = container.read(scanControllerProvider);
      expect(state, isA<ScanError>());
      expect((state as ScanError).message, contains("Network"));
      // Analysis failed (not capture), so the frame is retained for retry.
      expect(state.frame, isNotNull);
    });

    test("retry re-analyzes the same frame after an error", () async {
      final _FakeRepository repo = _FakeRepository(failure: const NetworkFailure("offline"));
      final ProviderContainer container = _containerWith(repo);
      final ScanController controller = container.read(scanControllerProvider.notifier);

      await controller.scan(_fakeCapture);
      expect(container.read(scanControllerProvider), isA<ScanError>());

      // Repo recovers; retry should reuse the frame and succeed.
      repo
        ..failure = null
        ..result = answer;
      await controller.retry();
      expect(container.read(scanControllerProvider), isA<ScanResult>());
    });

    test("scan is ignored unless idle, and reset returns to cameraReady", () async {
      final ProviderContainer container = _containerWith(_FakeRepository(result: answer));
      final ScanController controller = container.read(scanControllerProvider.notifier);

      await controller.scan(_fakeCapture);
      expect(container.read(scanControllerProvider), isA<ScanResult>());

      // Already in result -> a second scan must be a no-op.
      await controller.scan(_fakeCapture);
      expect(container.read(scanControllerProvider), isA<ScanResult>());

      controller.reset();
      expect(container.read(scanControllerProvider), isA<ScanCameraReady>());
    });
  });
}
