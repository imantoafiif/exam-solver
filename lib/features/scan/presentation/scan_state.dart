import "package:freezed_annotation/freezed_annotation.dart";

import "../domain/answer_result.dart";

part "scan_state.freezed.dart";

/// The analysis flow state, independent of camera readiness.
///
/// Sealed so the UI can render each case exhaustively. Lives only while the
/// camera is initialized; [ScanCameraReady] is the idle state awaiting a tap.
@freezed
sealed class ScanState with _$ScanState {
  /// Idle: live preview showing, waiting for the user to tap.
  const factory ScanState.cameraReady() = ScanCameraReady;

  /// A still frame is being captured + compressed.
  const factory ScanState.capturing() = ScanCapturing;

  /// The frame has been sent to Gemini and we're awaiting the answer.
  const factory ScanState.analyzing() = ScanAnalyzing;

  /// Analysis succeeded; [answer] is ready to display.
  const factory ScanState.result(AnswerResult answer) = ScanResult;

  /// Something failed; [message] is user-facing.
  const factory ScanState.error(String message) = ScanError;
}
