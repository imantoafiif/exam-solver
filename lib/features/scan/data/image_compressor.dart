import "dart:typed_data";

import "package:flutter/foundation.dart" show compute;
import "package:image/image.dart" as img;

/// Arguments for the off-main-thread compression run.
class CompressRequest {
  const CompressRequest({required this.bytes, required this.maxEdge, required this.quality});

  final Uint8List bytes;
  final int maxEdge;
  final int quality;
}

/// Downscales [bytes] so its longest edge is at most [maxEdge] and re-encodes
/// as JPEG at [quality]. Runs in a background isolate (via [compute]) to keep
/// the UI responsive. Falls back to the original bytes if decoding fails.
Future<Uint8List> compressJpeg(Uint8List bytes, {int maxEdge = 1568, int quality = 85}) {
  return compute(_runCompress, CompressRequest(bytes: bytes, maxEdge: maxEdge, quality: quality));
}

/// Top-level entry point executed inside the isolate.
Uint8List _runCompress(CompressRequest req) {
  final img.Image? decoded = img.decodeImage(req.bytes);
  if (decoded == null) {
    return req.bytes;
  }
  final int longest = decoded.width >= decoded.height ? decoded.width : decoded.height;
  if (longest <= req.maxEdge) {
    return img.encodeJpg(decoded, quality: req.quality);
  }
  final img.Image resized = decoded.width >= decoded.height
      ? img.copyResize(decoded, width: req.maxEdge)
      : img.copyResize(decoded, height: req.maxEdge);
  return img.encodeJpg(resized, quality: req.quality);
}
