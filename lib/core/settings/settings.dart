import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../config/app_config.dart";

/// Immutable snapshot of the user-configurable app settings.
class AppSettings {
  const AppSettings({
    required this.quickAnswer,
    required this.saveImages,
    required this.coloredOverlay,
  });

  /// Show the answer as a big, fading token in the center (vs the detailed pane).
  final bool quickAnswer;

  /// Persist each capture to the device gallery (data-collection mode).
  final bool saveImages;

  /// Experimental: full-screen colored background behind the quick answer
  /// (A→red, B→yellow, C→green, D→blue). Only effective when [quickAnswer] is on.
  final bool coloredOverlay;

  AppSettings copyWith({bool? quickAnswer, bool? saveImages, bool? coloredOverlay}) {
    return AppSettings(
      quickAnswer: quickAnswer ?? this.quickAnswer,
      saveImages: saveImages ?? this.saveImages,
      coloredOverlay: coloredOverlay ?? this.coloredOverlay,
    );
  }
}

/// Holds the [SharedPreferences] instance. Overridden in `main()` after load.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (Ref ref) => throw UnimplementedError("sharedPreferencesProvider must be overridden in main()"),
);

/// Reads settings from [SharedPreferences] and persists changes back.
class SettingsNotifier extends Notifier<AppSettings> {
  static const String _kQuickAnswer = "quick_answer";
  static const String _kSaveImages = "save_images";
  static const String _kColoredOverlay = "colored_overlay";

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  AppSettings build() {
    return AppSettings(
      quickAnswer: _prefs.getBool(_kQuickAnswer) ?? true,
      saveImages: _prefs.getBool(_kSaveImages) ?? AppConfig.saveCapturesToGallery,
      coloredOverlay: _prefs.getBool(_kColoredOverlay) ?? false,
    );
  }

  void setQuickAnswer(bool value) {
    _prefs.setBool(_kQuickAnswer, value);
    state = state.copyWith(quickAnswer: value);
  }

  void setSaveImages(bool value) {
    _prefs.setBool(_kSaveImages, value);
    state = state.copyWith(saveImages: value);
  }

  void setColoredOverlay(bool value) {
    _prefs.setBool(_kColoredOverlay, value);
    state = state.copyWith(coloredOverlay: value);
  }
}

/// The single source of truth for user settings, persisted across launches.
final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
