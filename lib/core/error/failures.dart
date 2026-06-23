/// Typed failures for the scan / analysis flow.
///
/// Sealed so the presentation layer can handle each case exhaustively when the
/// error UI is built (Wave 4).
sealed class ScanFailure implements Exception {
  const ScanFailure(this.message);

  /// Human-readable, log-friendly description.
  final String message;

  @override
  String toString() => "$runtimeType: $message";
}

/// Misconfiguration: missing API key, or missing/empty prompt asset.
class ConfigFailure extends ScanFailure {
  const ConfigFailure(super.message);
}

/// Connectivity or timeout problem reaching Gemini.
class NetworkFailure extends ScanFailure {
  const NetworkFailure(super.message);
}

/// Gemini responded with a non-success HTTP status.
class ApiFailure extends ScanFailure {
  const ApiFailure(super.message, {this.statusCode});

  final int? statusCode;
}

/// Gemini returned no usable content (no candidates, safety block, empty text).
class EmptyResponseFailure extends ScanFailure {
  const EmptyResponseFailure(super.message);
}

/// The response body could not be parsed into the expected shape.
class ParseFailure extends ScanFailure {
  const ParseFailure(super.message);
}
