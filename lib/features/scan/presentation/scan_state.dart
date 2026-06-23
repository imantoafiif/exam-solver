import "dart:typed_data";

import "package:freezed_annotation/freezed_annotation.dart";

import "../domain/answer_result.dart";

part "scan_state.freezed.dart";

/// The analysis flow state, independent of camera readiness.
///
/// Sealed so the UI can render each case exhaustively. The captured [frame] is
/// carried from [ScanAnalyzing] onward so the result/error UI can freeze and
/// show the photographed frame behind the panel.
@freezed
sealed class ScanState with _$ScanState {
  /// Idle: live preview showing, waiting for the user to tap.
  const factory ScanState.cameraReady() = ScanCameraReady;

  /// A still frame is being captured + compressed (no frame yet).
  const factory ScanState.capturing() = ScanCapturing;

  /// The frame has been captured and sent to Gemini; awaiting the answer.
  const factory ScanState.analyzing(Uint8List frame) = ScanAnalyzing;

  /// Analysis succeeded; [answer] is ready, [frame] is the photographed image.
  const factory ScanState.result(AnswerResult answer, Uint8List frame) = ScanResult;

  /// Something failed; [message] is user-facing. [frame] is present when the
  /// failure happened during analysis (so the user can retry the same frame).
  const factory ScanState.error(String message, {Uint8List? frame}) = ScanError;
}
