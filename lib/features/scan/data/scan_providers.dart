import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/config/env.dart";
import "../../../core/prompt/prompt_loader.dart";
import "../domain/scan_repository_ref.dart";
import "gemini_client.dart";
import "scan_repository.dart";

/// Shared dio instance for outbound requests.
final dioProvider = Provider<Dio>((ref) => Dio());

/// Gemini API client wired with the key from `.env`.
final geminiClientProvider = Provider<GeminiClient>((ref) {
  return GeminiClient(dio: ref.watch(dioProvider), apiKey: Env.geminiApiKey);
});

/// The scan repository the presentation layer depends on.
final scanRepositoryProvider = Provider<ScanRepository>((ref) {
  return GeminiScanRepository(
    client: ref.watch(geminiClientProvider),
    promptLoader: ref.watch(promptLoaderProvider),
  );
});
