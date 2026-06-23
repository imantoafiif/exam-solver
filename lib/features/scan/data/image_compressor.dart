import "dart:typed_data";

import "package:flutter_image_compress/flutter_image_compress.dart";

/// Downscales [bytes] so its longest edge is at most [maxEdge] and re-encodes
/// as JPEG at [quality].
///
/// Uses native (hardware-accelerated) compression via `flutter_image_compress`,
/// which runs off the main thread — far faster than pure-Dart decode/encode.
/// Passing the same value for both bounds caps the longest edge regardless of
/// orientation (the image is scaled to fit a maxEdge×maxEdge box, aspect ratio
/// preserved, never upscaled). Falls back to the original bytes if compression
/// returns nothing.
Future<Uint8List> compressJpeg(Uint8List bytes, {int maxEdge = 1568, int quality = 85}) async {
  final Uint8List result = await FlutterImageCompress.compressWithList(
    bytes,
    minWidth: maxEdge,
    minHeight: maxEdge,
    quality: quality,
    format: CompressFormat.jpeg,
  );
  return result.isEmpty ? bytes : result;
}
