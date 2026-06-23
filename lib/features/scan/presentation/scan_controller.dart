import "dart:developer" as developer;
import "dart:typed_data";

import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/error/failures.dart";
import "../data/scan_providers.dart";
import "../domain/answer_result.dart";
import "scan_state.dart";

/// Drives the scan flow state machine: idle → capturing → analyzing → result.
///
/// Camera-agnostic by design: the screen owns the [CameraController] and passes
/// a capture callback, so this controller never touches the camera plugin.
class ScanController extends Notifier<ScanState> {
  @override
  ScanState build() => const ScanState.cameraReady();

  /// Runs one scan cycle. [capture] takes the still frame and returns
  /// compressed JPEG bytes. Ignored unless currently idle ([ScanCameraReady]).
  Future<void> scan(Future<Uint8List> Function() capture) async {
    if (state is! ScanCameraReady) {
      return;
    }
    state = const ScanState.capturing();
    final Uint8List frame;
    try {
      frame = await capture();
    } on ScanFailure catch (e) {
      state = ScanState.error(_friendlyMessage(e));
      return;
    } on Object catch (e, stackTrace) {
      developer.log("Capture failed", name: "ScanController", error: e, stackTrace: stackTrace);
      state = const ScanState.error("Couldn't capture the image. Please try again.");
      return;
    }
    await _analyze(frame);
  }

  /// Retries analysis on the already-captured frame (after an error), avoiding a
  /// re-capture. Falls back to [reset] if there is no frame to retry.
  Future<void> retry() async {
    final ScanState current = state;
    if (current is ScanError && current.frame != null) {
      await _analyze(current.frame!);
    } else {
      reset();
    }
  }

  /// Returns to the idle live-camera state.
  void reset() => state = const ScanState.cameraReady();

  Future<void> _analyze(Uint8List frame) async {
    state = ScanState.analyzing(frame);
    try {
      final AnswerResult answer = await ref.read(scanRepositoryProvider).analyzeImage(frame);
      state = ScanState.result(answer, frame);
    } on ScanFailure catch (e) {
      state = ScanState.error(_friendlyMessage(e), frame: frame);
    } on Object catch (e, stackTrace) {
      developer.log("Analysis failed", name: "ScanController", error: e, stackTrace: stackTrace);
      state = ScanState.error("Something went wrong. Please try again.", frame: frame);
    }
  }

  /// Maps a typed failure to a concise, user-facing message.
  String _friendlyMessage(ScanFailure failure) {
    return switch (failure) {
      ConfigFailure() => failure.message,
      NetworkFailure() => "Network problem. Check your connection and try again.",
      ApiFailure(:final int? statusCode) =>
        statusCode == 429
            ? "You're scanning too fast or hit today's limit. Wait a moment and try again."
            : "The AI service had a problem. Please try again.",
      RecitationFailure() => failure.message,
      EmptyResponseFailure() => failure.message,
      ParseFailure() => "Couldn't read the AI's response. Please try again.",
    };
  }
}

/// The scan flow controller the screen watches and drives.
final scanControllerProvider = NotifierProvider<ScanController, ScanState>(ScanController.new);
