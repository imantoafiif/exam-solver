# Development Waves — AI Exam Assistant (MVP)

A wave-by-wave, checkbox tracker for building the MVP. Each wave has a **goal**, **actionable tasks**, and a **"Done when"** acceptance gate. Work top to bottom; do not start a wave until the previous wave's gate is green. Tick boxes as you go.

Legend: `[ ]` todo · `[~]` in progress · `[x]` done · `[!]` blocked

Source of truth for design = `docs/implementation-plan.md` and `CLAUDE.md`.

---

## Wave 0 — Project setup & configuration

**Goal:** project compiles with all dependencies, secrets, and assets wired.

- [x] Add dependencies to `pubspec.yaml`: `camera`, `image`, `dio`, `flutter_riverpod`, `flutter_dotenv`, `freezed_annotation`, `json_annotation`, `flutter_markdown_plus` (swapped from discontinued `flutter_markdown`)
- [x] Add dev dependencies: `build_runner`, `freezed`, `json_serializable`
- [x] Register assets in `pubspec.yaml`: `assets/prompts/ace_solver_prompt.txt` and `.env`
- [x] Confirm `.env` is gitignored and `.env.example` is committed
- [x] Android: add `CAMERA` permission to `AndroidManifest.xml`; set required `minSdkVersion` (`maxOf(21, flutter.minSdkVersion)`)
- [x] iOS: add `NSCameraUsageDescription` to `Info.plist`
- [x] Create folder skeleton (`core/`, `features/scan/{data,domain,presentation}`, `shared/`)
- [x] `core/config/env.dart` — read `GEMINI_API_KEY` from dotenv
- [x] `core/config/gemini_config.dart` — model id, endpoint, temperature, maxTokens constants

**Done when:** `flutter pub get` succeeds, `flutter analyze` is clean, app builds and runs on a device/emulator (default counter screen still fine).
**Gate status:** ✅ `flutter pub get` OK (no discontinued warning) · ✅ `flutter analyze` clean · app run deferred to Wave 1 (`main.dart` still default counter, builds fine).

---

## Wave 1 — Camera foundation

**Goal:** opening the app shows a full-screen live camera; tapping is detected.

- [x] `main.dart` — init `flutter_dotenv`, lock portrait orientation, run app into `ScanScreen`
- [x] `core/theme/app_theme.dart` — Material 3, dark theme (camera-friendly)
- [x] Initialize back camera with `camera` (`ResolutionPreset.high`, `enableAudio: false`)
- [x] `features/scan/presentation/widgets/camera_view.dart` — full-screen `CameraPreview` (BoxFit.cover)
- [x] `features/scan/presentation/scan_screen.dart` — full-screen camera, no app bar/chrome
- [x] Tap-anywhere `GestureDetector` (for now: log "tap captured")
- [x] Handle camera permission denied → simple "enable camera" prompt + Retry
- [x] Dispose camera controller correctly on app pause/close (WidgetsBindingObserver)

**Done when:** launching the app goes straight to a live full-screen camera; tapping logs an event; no home screen; rotation locked; no leaks on background/foreground.
**Gate status:** ✅ `flutter analyze` clean · ✅ `flutter test` green · ✅ on-device run confirmed (full-screen camera, tap logs, no chrome).

---

## Wave 2 — Gemini integration (prompt + client)

**Goal:** send an image + prompt to Gemini and get a valid response (proven end-to-end).

- [x] `core/prompt/prompt_loader.dart` — load `ace_solver_prompt.txt` via `rootBundle`, cache in a provider; hard error if missing
- [x] `features/scan/data/dto/gemini_request.dart` — request body model (freezed/json)
- [x] `features/scan/data/dto/gemini_response.dart` — response model (freezed/json)
- [x] `features/scan/data/gemini_client.dart` — `dio` POST to `generateContent`, `x-goog-api-key` header, timeout + 1 retry
- [x] `features/scan/domain/answer_result.dart` — UI-ready parsed result (freezed) + `fromMarkdown` parser
- [x] `features/scan/domain/scan_repository_ref.dart` — abstract repository interface
- [x] `features/scan/data/scan_repository.dart` — bytes + prompt → `AnswerResult` (+ `scan_providers.dart` for Riverpod wiring)
- [x] Run `dart run build_runner build` (codegen OK; `--delete-conflicting-outputs` is removed in build_runner 2.15)
- [x] Temporary harness: `tool/gemini_smoke.dart` (runs under `dart run`, Flutter-free import graph)

**Done when:** a known test image returns a correctly parsed `AnswerResult` (markdown + best answer + confidence) from `gemini-3.5-flash`.
**Gate status:** ✅ `flutter analyze` clean · ✅ `flutter test` green (parser unit-tested) · ✅ harness loads under `dart run` · ⏳ live round-trip pending your Gemini key.

---

## Wave 3 — State machine & capture pipeline

**Goal:** real tap → capture in-memory frame → analyze → state transitions.

- [x] `features/scan/presentation/scan_state.dart` — sealed states: `cameraReady`, `capturing`, `analyzing`, `result`, `error`
- [x] `features/scan/presentation/scan_controller.dart` — Riverpod `Notifier` driving the state machine
- [x] Capture: `controller.takePicture()` → read bytes → **delete temp file immediately**
- [x] Compress/downscale captured frame with `image` (longest edge ~1568px, JPEG q~85, in a background isolate via `compute`)
- [x] Base64-encode and pass to repository (in `scan_repository.dart`)
- [x] Wire `ScanScreen` tap → controller capture (only when state is `cameraReady`)
- [x] Ignore taps while `capturing` / `analyzing` / `result` / `error`
- [x] Verify NO image is written to gallery or persistent storage (temp file deleted post-read)

**Done when:** tapping the live camera captures a frame, sends it, and the state advances `cameraReady → capturing → analyzing → result`; no image persists on device.
**Gate status:** ✅ `flutter analyze` clean · ✅ `flutter test` green (state-machine unit-tested) · ⏳ on-device tap→answer pending your review.

---

## Wave 4 — Result & error UI

**Goal:** the answer is displayed over the frozen frame; errors are recoverable.

- [x] `features/scan/presentation/widgets/loading_overlay.dart` — dimmed frame + "Analyzing…"
- [x] `features/scan/presentation/widgets/answer_panel.dart` — scrollable markdown (`flutter_markdown_plus`), best-answer + confidence badges, bottom sheet
- [x] Freeze/show the captured frame behind the answer panel (frame carried in `ScanState`, rendered by `_baseLayer`)
- [x] `features/scan/presentation/widgets/error_overlay.dart` — message + Retry (re-analyzes same frame) + Back to camera
- [x] Dismiss (scrim tap + ✕ button) → reset to `cameraReady`
- [x] Shutter feedback on capture (haptic + white flash); subtle "tap to scan" hint in `cameraReady`
- [x] Map failure types (network, api/429, parse, recitation, config) to friendly messages (`_friendlyMessage`)

**Done when:** full loop works on device — tap → loading → readable answer overlay → dismiss → back to live camera; errors show Retry and recover.
**Gate status:** ✅ `flutter analyze` clean · ✅ `flutter test` green (8 tests, incl. retry-same-frame) · ⏳ on-device review pending.

---

## Wave 5 — Prompt tuning & validation

**Goal:** answers are accurate and trustworthy on real ACE questions.

- [x] **Validation tooling:** `tool/validate_batch.dart` — runs a folder of images through the
      real client+parser and reports per-image answer/confidence/§18-compliance/assumptions/latency,
      plus accuracy vs an optional `answer_key.json`. (Demo: 1 known image → correct, 100%, ~6s.)
- [x] Harden best-answer parser (don't mistake prose like "Cloud Run" for option C) + tests
- [x] **Collected a 42-image real-world test set** (screens, monitor/projector photos, phone shots,
      glare/angle, multi-window, ExamTopics + Architect scenarios) via the gallery save mode
- [x] Ran the set through an **oracle cross-check** (`tool/model_compare.dart`): flash vs the stronger
      `gemini-3.1-pro` → **41/42 identical answers (98%)**, all High confidence; verified answers
      correct against known/revealed solutions. See `docs/model-comparison.md`.
- [x] Verify **bias prevention**: set included questions showing the revealed "Correct Answer"/"Most
      Voted" — solver still reasoned independently and matched the correct answer
- [x] Verify imperfect-image handling: **42/42 read with zero failures/refusals** (glare/angle/phone);
      conclusion — **no image preprocessing needed for the MVP**
- [x] Prompt held up — no iteration needed (anti-recitation + terse Best Answer already in place)
- [x] **Model decision: keep `gemini-3.5-flash`** — matches Pro's answers at ~71% faster, ~2.6× cheaper
- [x] Confirm output matches the §18 format and renders correctly (batch reports `format=complete`;
      markdown renders in the answer panel)
- [x] **Decision: keep markdown rendering (A).** It works, renders cleanly, the parser reliably
      extracts answer/confidence, and §18 compliance is consistent. Structured JSON (B —
      `responseSchema`) is deferred; not worth the added complexity for the MVP.

**Done when:** on the test set, the app reliably returns correct best answers with sound reasoning,
ignores answer indicators, and never crashes on imperfect input. **✅ VALIDATED** (42-image set,
98% agreement with the stronger oracle, zero crashes/refusals).

---

## Wave 6 — Polish & release prep

**Goal:** stable, measurable, shippable MVP.

- [x] **Speed up the "Capturing…" step (capture-pipeline latency, ~1.5s observed).** Root
      cause was our post-processing, not the camera: the pure-Dart `image` package decode →
      resize → re-encode (which ran even when no resize was needed). **Resolved by switching to
      native, hardware-accelerated compression (`flutter_image_compress`)** — `compressJpeg`
      now calls `FlutterImageCompress.compressWithList` (off-thread native), and the pure-Dart
      `image` dependency was removed. Remaining latency is just `takePicture()` autofocus/
      metering; lower `ResolutionPreset` if that needs trimming too. Verify on device.
- [x] Measure **Time-To-Answer** — dominated by the Gemini call (~6s measured via
      `validate_batch.dart`); capture/compress is now negligible. Image already capped at 1568px;
      60s timeout. Biggest future lever is a faster/cheaper model (e.g. gemini-2.5-flash).
- [x] Loading/responsiveness pass — double-submit guarded (taps ignored unless `cameraReady`);
      native compression removed the capture jank; loading/analyzing overlays in place.
- [~] App icon, name, splash — **name set** (Android label + iOS display name = "Exam Scanner").
  **Icon + splash still need design assets** (use `flutter_launcher_icons` / `flutter_native_splash`).
- [x] Empty/edge states — typed failures mapped to friendly messages (network, 429 rate-limit,
      RECITATION, MAX_TOKENS truncation, SAFETY, parse, empty); retry-same-frame on errors.
- [x] Unit tests: `scan_repository` (stubbed Dio adapter) + `prompt_loader` (load/cache/empty)
- [x] Widget tests: overlays (`scan_status_overlay_test`: result badge, error retry/no-retry) +
      state machine (`scan_controller_test`). Full `ScanScreen` camera test skipped (camera plugin).
- [x] Final `flutter analyze` clean; `flutter test` green (**18 tests**)
- [ ] **Default "Save captures to gallery" OFF before release** — it's now a user setting in the
      Settings screen, defaulting to `AppConfig.saveCapturesToGallery` (currently `true` for data
      collection). Flip that const to `false` so fresh installs don't persist images by default.
- [ ] Review accepted risks (client-side API key per `CLAUDE.md` §7) before any public release
- [ ] Build release artifacts (`flutter build apk` / `ios`)

**Done when:** MVP success criteria met — user can open → point → tap → receive a correct answer → understand the reasoning; KPIs measurable.

---

## Out-of-scope guardrail (all waves)

Do NOT build (PRD §4 / `CLAUDE.md` §3): OCR, question localization, auto-crop, image hashing, caching, live/continuous analysis, AR overlays, auto-capture, history, backend/auth. These are roadmap V2–V6.

---

## Progress summary

| Wave | Title                                | Status                                                                           |
| ---- | ------------------------------------ | -------------------------------------------------------------------------------- |
| 0    | Project setup & configuration        | [x]                                                                              |
| 1    | Camera foundation                    | [x]                                                                              |
| 2    | Gemini integration (prompt + client) | [x]                                                                              |
| 3    | State machine & capture pipeline     | [x]                                                                              |
| 4    | Result & error UI                    | [x]                                                                              |
| 5    | Prompt tuning & validation           | [x] validated — 42-image set, 98% vs gemini-3.1-pro oracle; keep flash           |
| 6    | Polish & release prep                | [~] code polish + tests done; icon/splash, save-toggle off, release build remain |
