import "package:flutter/services.dart" show AssetBundle, rootBundle;
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../error/failures.dart";

/// Path to the bundled ACE system prompt asset.
const String kAcePromptAsset = "assets/prompts/ace_solver_prompt.txt";

/// Loads and caches the ACE system prompt from the bundled text asset.
///
/// The prompt is correctness-critical (CLAUDE.md §6), so a missing or empty
/// asset is a hard [ConfigFailure] rather than a silent empty prompt.
class PromptLoader {
  PromptLoader(this._bundle);

  final AssetBundle _bundle;
  String? _cached;

  /// Returns the prompt text, loading it once and caching thereafter.
  Future<String> load() async {
    final String? cached = _cached;
    if (cached != null) {
      return cached;
    }
    final String text = await _bundle.loadString(kAcePromptAsset);
    if (text.trim().isEmpty) {
      throw const ConfigFailure("System prompt asset is empty: $kAcePromptAsset");
    }
    _cached = text;
    return text;
  }
}

/// Provides a singleton [PromptLoader] backed by the app's [rootBundle].
final promptLoaderProvider = Provider<PromptLoader>((ref) => PromptLoader(rootBundle));
