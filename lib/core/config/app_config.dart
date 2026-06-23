/// App-level feature toggles.
class AppConfig {
  const AppConfig._();

  /// TEMPORARY data-collection toggle.
  ///
  /// When `true`, every captured frame (the compressed JPEG actually sent to
  /// Gemini) is also saved to the device gallery, so a real-world test set can
  /// be gathered for prompt tuning (Wave 5).
  ///
  /// **Turn this OFF before any release.** The product's privacy posture is to
  /// never persist images (CLAUDE.md §3 / §7); this flag is an intentional,
  /// temporary exception for dataset collection only.
  static const bool saveCapturesToGallery = true;

  /// Album name used when [saveCapturesToGallery] is enabled.
  static const String captureAlbum = "Exam Scanner";
}
