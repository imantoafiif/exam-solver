# Implementation Plan — AI Exam Assistant (MVP)

Status: **Proposal** · Owner: app team · Aligns with `CLAUDE.md` and the PRD.

This plan describes the single-screen, camera-first MVP: open → live camera → tap to capture an in-memory frame → Gemini analyzes → answer overlaid on screen. No stored images, no home screen, no OCR.

---

## 1. Objective & flow

```
Open app
  └─ Full-screen live camera (no home screen, no chrome)
       └─ User taps anywhere
            └─ Capture frame to memory (NOT saved to disk)
                 └─ Send image + ACE prompt to Gemini (gemini-3.5-flash)
                      └─ Receive structured answer
                           └─ Overlay answer on top of the (frozen) frame
                                └─ Dismiss → back to live camera
```

**Pre-configuration:** the AI system prompt is **not** hardcoded. It lives in a bundled text asset (`assets/prompts/ace_solver_prompt.txt`) and is loaded once at startup. Editing the prompt = editing that file; no Dart changes.

---

## 2. UX states (single screen, state machine)

One screen, `ScanScreen`, driven by one sealed state. Tap behavior depends on the current state.

| State         | What the user sees                                     | Tap behavior                             |
| ------------- | ------------------------------------------------------ | ---------------------------------------- |
| `cameraReady` | Live camera preview, subtle "tap to scan" hint         | **Tap anywhere → capture & analyze**     |
| `capturing`   | Frozen frame + brief shutter feedback                  | ignored                                  |
| `analyzing`   | Frozen frame, dimmed, centered loading + "Analyzing…"  | ignored (optional: tap to cancel)        |
| `result`      | Frozen frame + scrollable answer panel over it         | panel scrolls; **tap scrim / ✕ → reset** |
| `error`       | Frozen frame + error card with **Retry** / **Dismiss** | buttons only                             |

Notes:

- The captured frame stays on screen (frozen) under the answer so the user keeps visual context. We do not persist it; it is discarded on reset.
- While `result`/`error` is shown, tap-anywhere-to-capture is disabled so it doesn't conflict with reading/scrolling. A scrim tap or close button returns to `cameraReady`.

---

## 3. Architecture & file layout

Feature-based clean architecture, kept light (per `CLAUDE.md` §5 and the simplicity principle).

```
lib/
  main.dart                         # init dotenv, load prompt, set portrait, runApp
  core/
    config/
      env.dart                      # reads GEMINI_API_KEY from dotenv
      gemini_config.dart            # model id, endpoint, temperature, maxTokens
    prompt/
      prompt_loader.dart            # loads assets/prompts/ace_solver_prompt.txt
    theme/app_theme.dart            # Material 3, dark (camera-friendly)
    error/failures.dart            # typed failures (network, api, parse, camera)
  features/
    scan/
      data/
        gemini_client.dart          # dio wrapper: POST generateContent
        scan_repository.dart        # orchestrates: bytes + prompt -> AnswerResult
        dto/
          gemini_request.dart       # request body (freezed/json)
          gemini_response.dart      # raw response (freezed/json)
      domain/
        answer_result.dart          # parsed, UI-ready result (freezed)
        scan_repository_ref.dart    # abstract interface (swap AI provider later)
      presentation/
        scan_screen.dart            # full-screen camera + tap handler
        scan_controller.dart        # Riverpod Notifier: the state machine
        scan_state.dart             # sealed state (freezed)
        widgets/
          camera_view.dart          # CameraPreview wrapper
          answer_panel.dart         # scrollable rendered answer
          loading_overlay.dart
          error_overlay.dart
  shared/
    widgets/                        # reusable bits if needed
assets/
  prompts/
    ace_solver_prompt.txt           # THE system prompt (editable, version-controlled)
```

---

## 4. The prompt asset (pre-configuration)

- File: `assets/prompts/ace_solver_prompt.txt`.
- Declared under `flutter: assets:` in `pubspec.yaml`.
- `PromptLoader.load()` calls `rootBundle.loadString(...)` **once** at app start; the string is cached in a Riverpod provider and injected into every request as Gemini's `system_instruction`.
- Content must encode (from PRD §12–17): reconstruct-before-solving, visual understanding, **bias prevention** (ignore highlighted/selected answers), ACE heuristics (managed services, Cloud Run > Compute Engine, etc.), option-by-option analysis, confidence scoring, and the exact **response format** (§18) so output is parseable/renderable.
- Failure to load the asset is a hard startup error (we cannot solve without the prompt) — show a clear message, do not silently fall back to an empty prompt.

---

## 5. Data model (`AnswerResult`)

Gemini returns markdown in the PRD §18 format. Two viable rendering approaches:

- **A (simplest, recommended for MVP):** ask Gemini for the markdown response, render it directly with a markdown widget. `AnswerResult` just holds the raw markdown + a parsed `confidence` + `bestAnswer` letter (cheap regex) for emphasis.
- **B (structured):** instruct Gemini to return JSON (`responseMimeType: application/json` + schema), deserialize into a fully typed `AnswerResult`. More robust, slightly more setup.

Recommendation: **start with A** (fastest path to validation), keep `AnswerResult` as the seam so we can move to B later without touching the UI.

```
AnswerResult {
  String reconstructedQuestion;
  String bestAnswer;        // "B"
  String confidence;        // High | Medium | Low
  String rawMarkdown;       // full §18 body for display
}
```

---

## 6. Networking (Gemini)

Per `CLAUDE.md` "Gemini integration (locked)":

- `dio` POST → `https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent`
- Header `x-goog-api-key: <key from .env>`
- Body: `system_instruction` = loaded prompt; `contents[].parts` = `[ {text}, {inline_data: image/jpeg, base64} ]`; `generationConfig` = `{ temperature: 0.2, maxOutputTokens: 2048 }`.
- Timeout (e.g. 60s), single retry on transient network error. No caching (out of scope).

---

## 7. Camera & capture

- `camera` package: initialize the back camera at app start, `ResolutionPreset.high` (balance clarity vs upload size).
- Tap → `controller.takePicture()` → read bytes → **delete the temp file immediately** → optionally downscale/compress with `image` package (cap longest edge ~1568px, JPEG q~85) to cut latency/cost → base64 → send.
- **Never write to gallery / app storage.** The temp file the plugin creates is removed right after we read its bytes.
- Lock orientation to portrait for the MVP.

---

## 8. Dependencies to add (`pubspec.yaml`)

| Package                                             | Purpose                           |
| --------------------------------------------------- | --------------------------------- |
| `camera`                                            | live preview + capture            |
| `image`                                             | downscale/compress captured frame |
| `dio`                                               | Gemini REST call                  |
| `flutter_riverpod`                                  | state management                  |
| `flutter_dotenv`                                    | load `.env` key                   |
| `freezed_annotation`, `json_annotation`             | models                            |
| `flutter_markdown` (if approach A)                  | render the answer                 |
| dev: `build_runner`, `freezed`, `json_serializable` | codegen                           |

---

## 9. Platform config

- **Android:** `CAMERA` permission in `AndroidManifest.xml`; `minSdkVersion` per `camera` plugin requirement; declare `.env` + prompt as assets.
- **iOS:** `NSCameraUsageDescription` in `Info.plist` ("Used to scan exam questions").
- **.env:** already gitignored; must be listed under `flutter: assets:` for `flutter_dotenv` to bundle it. (Reminder: the key ships in the app — accepted MVP risk per `CLAUDE.md` §7.)

---

## 10. Error handling & edge cases

| Case                     | Handling                                                                                        |
| ------------------------ | ----------------------------------------------------------------------------------------------- |
| Camera permission denied | Permission prompt screen with "Open settings"                                                   |
| Prompt asset missing     | Hard startup error (cannot operate)                                                             |
| Network/timeout          | `error` state with Retry                                                                        |
| Gemini 4xx/5xx           | `error` state, surface a friendly message + log raw                                             |
| Empty/garbled image      | Prompt already tells AI to infer + state assumptions; if Gemini returns low confidence, show it |
| Rapid repeated taps      | Ignore taps unless state is `cameraReady`                                                       |
| Very large image         | Downscale before send (step 7)                                                                  |

---

## 11. Build order (milestones)

1. **Scaffold deps & config** — add packages, `pubspec` assets, `.env` wiring, platform permissions, `build_runner` setup.
2. **Camera screen** — full-screen live preview, portrait lock, tap detector (no AI yet; tap just logs).
3. **Prompt + Gemini client** — `PromptLoader`, `gemini_client.dart`, hardcode a test image to validate end-to-end request/response.
4. **State machine** — `scan_state`, `scan_controller`, wire capture → analyze → result.
5. **Capture pipeline** — real `takePicture` → bytes → compress → base64 → discard temp file.
6. **Result & error UI** — answer panel (markdown), loading overlay, error overlay, dismiss-to-reset.
7. **Polish** — shutter feedback, "tap to scan" hint, theming, copy.
8. **Author the real prompt** — fill `ace_solver_prompt.txt` with PRD §12–18 content; iterate against real ACE screenshots.

Each milestone ends with `flutter analyze` clean.

---

## 12. Testing strategy

- **Unit:** `scan_repository` (mock `dio`) — request shaping + response parsing; `prompt_loader`.
- **Widget:** `ScanScreen` state transitions (mock controller) — tap in `cameraReady` triggers analyze; result/error overlays render.
- **Manual:** real ACE screenshots (screen, monitor photo, glare, partial) to validate the prompt + KPIs (Time-To-Answer, accuracy).

---

## 13. Explicitly NOT in this plan (PRD §4 / `CLAUDE.md` §3)

OCR · question localization · auto-crop · image hashing · caching · live/continuous analysis · AR overlays · auto-capture · history · backend/auth. Do not build these without an explicit decision to pull them forward.

---

## 14. Open questions

1. **Render mode:** markdown (A) vs structured JSON (B) — proposal: start with A.
2. **Cancel during analysis:** allow tap-to-cancel in `analyzing`, or block until done? (proposal: block for MVP.)
3. **Result dismissal:** scrim tap + ✕ button, or swipe-down sheet? (proposal: both scrim tap and ✕.)
4. **Resolution/compression target:** confirm ~1568px / q85 is acceptable for question legibility.

```

```
