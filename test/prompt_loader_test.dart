import "package:exam_scanner/core/error/failures.dart";
import "package:exam_scanner/core/prompt/prompt_loader.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

/// AssetBundle stub that returns a fixed string and counts loads.
class _FakeBundle extends AssetBundle {
  _FakeBundle(this._text);

  final String _text;
  int loadStringCalls = 0;

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loadStringCalls++;
    return _text;
  }

  @override
  Future<ByteData> load(String key) => throw UnimplementedError();
}

void main() {
  group("PromptLoader", () {
    test("loads the prompt text", () async {
      final PromptLoader loader = PromptLoader(_FakeBundle("ACE solver prompt"));
      expect(await loader.load(), "ACE solver prompt");
    });

    test("caches after the first load", () async {
      final _FakeBundle bundle = _FakeBundle("prompt");
      final PromptLoader loader = PromptLoader(bundle);

      await loader.load();
      await loader.load();

      expect(bundle.loadStringCalls, 1);
    });

    test("throws ConfigFailure when the asset is empty", () async {
      final PromptLoader loader = PromptLoader(_FakeBundle("   \n  "));
      expect(loader.load(), throwsA(isA<ConfigFailure>()));
    });
  });
}
