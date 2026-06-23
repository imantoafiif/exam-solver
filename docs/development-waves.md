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

- [ ] `features/scan/presentation/widgets/loading_overlay.dart` — dimmed frame + "Analyzing…"
- [ ] `features/scan/presentation/widgets/answer_panel.dart` — scrollable markdown render of the §18 response, best-answer emphasized
- [ ] Freeze/show the captured frame behind the answer panel
- [ ] `features/scan/presentation/widgets/error_overlay.dart` — message + Retry + Dismiss
- [ ] Dismiss (scrim tap + ✕ button) → reset to `cameraReady`
- [ ] Shutter feedback on capture; subtle "tap to scan" hint in `cameraReady`
- [ ] Map failure types (network, api, parse, camera) to friendly messages

**Done when:** full loop works on device — tap → loading → readable answer overlay → dismiss → back to live camera; errors show Retry and recover.

---

## Wave 5 — Prompt tuning & validation

**Goal:** answers are accurate and trustworthy on real ACE questions.

- [ ] Collect a test set of real ACE question images (screen, monitor photo, glare, partial, multi-window)
- [ ] Run each through the app; record correctness + confidence
- [ ] Verify **bias prevention**: questions with a pre-highlighted (wrong) answer are still solved independently
- [ ] Verify imperfect-image handling: assumptions stated, no false refusals
- [ ] Iterate `ace_solver_prompt.txt` only (no Dart changes) until accuracy is acceptable
- [ ] Confirm output always matches the §18 format and renders correctly
- [ ] Decide: keep markdown rendering (A) or move to structured JSON (B)

**Done when:** on the test set, the app reliably returns correct best answers with sound reasoning, ignores answer indicators, and never crashes on imperfect input.

---

## Wave 6 — Polish & release prep

**Goal:** stable, measurable, shippable MVP.

- [ ] Measure **Time-To-Answer** (tap → answer rendered); optimize image size / timeout if slow
- [ ] Loading/responsiveness pass (no jank, no double-submits)
- [ ] App icon, name, splash
- [ ] Empty/edge states: no question detected, totally illegible image
- [ ] Unit tests: `scan_repository` (mock dio), `prompt_loader`
- [ ] Widget tests: `ScanScreen` state transitions, overlays
- [ ] Final `flutter analyze` clean; `flutter test` green
- [ ] Review accepted risks (client-side API key per `CLAUDE.md` §7) before any public release
- [ ] Build release artifacts (`flutter build apk` / `ios`)

**Done when:** MVP success criteria met — user can open → point → tap → receive a correct answer → understand the reasoning; KPIs measurable.

---

## Out-of-scope guardrail (all waves)

Do NOT build (PRD §4 / `CLAUDE.md` §3): OCR, question localization, auto-crop, image hashing, caching, live/continuous analysis, AR overlays, auto-capture, history, backend/auth. These are roadmap V2–V6.

---

## Progress summary

| Wave | Title                                | Status |
| ---- | ------------------------------------ | ------ |
| 0    | Project setup & configuration        | [x]    |
| 1    | Camera foundation                    | [x]    |
| 2    | Gemini integration (prompt + client) | [x]    |
| 3    | State machine & capture pipeline     | [x]    |
| 4    | Result & error UI                    | [ ]    |
| 5    | Prompt tuning & validation           | [ ]    |
| 6    | Polish & release prep                | [ ]    |
