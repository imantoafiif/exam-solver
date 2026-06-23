# CLAUDE.md — AI Exam Assistant

Project context and working agreement for Claude. Read this at the start of every session before making changes.

---

## 1. What we are building

**AI Exam Assistant** — a Flutter mobile app (Android + iOS). The user points the device camera at an exam question, captures an image, the image is sent to a vision-capable LLM (**Gemini Vision**, preferred), and the app displays the AI's reconstructed question, best answer, and explanation directly on screen.

**Core flow:**

```
Launch App → Camera Preview → Point at Question → Capture →
Upload to AI → Analyze → Generate Answer → Display Explanation
```

**Primary target user:** Google Associate Cloud Engineer (ACE) certification candidates.
**Secondary:** other technical certs (AWS, Azure, Kubernetes, Terraform). **Future:** general students.

**Purpose:** collapse the "read → type → search → compare" study loop into a single capture action.

---

## 2. Guiding principle (read this before proposing anything)

> **Always choose simplicity over sophistication unless user demand justifies additional complexity.**

The goal is **not** the most technically advanced solution. It is the **fastest path to validating** whether users find value in an AI-powered exam assistant.

- Prioritize: **user validation, speed of development, simplicity.**
- Reject: **premature optimization** and complex engineering until there is evidence users need it.
- When you (Claude) are tempted to add a layer, an abstraction, a cache, or a pipeline — stop and check it against this principle and the **Out of Scope** list below. Propose the simple version first.

---

## 3. MVP scope

### In scope

- **Camera preview** — live camera feed.
- **Manual image capture** — user taps a button to capture.
- **AI analysis** — captured image sent to a vision LLM.
- **Answer generation** — AI returns: reconstructed question, answer, reasoning, confidence.
- **Display results** — rendered in-app.

### Explicitly OUT of scope for the MVP (do NOT build these unless asked)

- OCR / text preprocessing
- Question localization / object detection
- Automatic cropping / region selection
- Image hashing / duplicate detection
- OCR-based or text caching
- Real-time / continuous analysis
- Live AR overlays
- Auto capture
- Background / periodic scanning
- Backend services, auth, billing, analytics

Rationale recorded in PRD §6, §7: OCR and image hashing were evaluated and **postponed** — question position is unpredictable, they add complexity, and they don't validate user demand. Manual capture naturally limits request volume.

---

## 4. Technology stack

| Layer                 | Choice                                                                                                                        |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Framework             | Flutter (stable 3.44.x), Dart 3.12.x                                                                                          |
| Camera                | `camera`                                                                                                                      |
| Image handling        | `flutter_image_compress` (native, hardware-accelerated JPEG downscale/compress; replaced pure-Dart `image` for capture speed) |
| HTTP                  | `dio`                                                                                                                         |
| Models / immutability | `freezed` (+ `json_serializable`)                                                                                             |
| State management      | `riverpod` (`flutter_riverpod` / `hooks_riverpod`)                                                                            |
| AI provider           | **Gemini Developer API (REST), called directly via `dio`.** Default model `gemini-3.5-flash`                                  |
| Config / secrets      | API key in `.env` (gitignored), loaded with `flutter_dotenv`                                                                  |
| Backend               | **None initially.** Add (Node/Nest/Express) only when auth, billing, caching, or analytics genuinely require it               |

Project: package `exam_scanner`, org `id.commsult`, platforms Android + iOS.

### Gemini integration (locked)

- **Model:** `gemini-3.5-flash` — keep as a config constant; swapping to `gemini-flash-latest` or `gemini-2.5-flash` is a one-line change. Do **not** target `gemini-2.0-flash` (sunset June 1, 2026).
- **SDK choice:** raw REST via `dio`. The `google_generative_ai` Dart package is deprecated; we intentionally do **not** use `firebase_ai` because this project uses a plain Gemini API key, not a Firebase project.
- **Endpoint:** `POST https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent`
- **Auth:** pass the key in the `x-goog-api-key` header (not `?key=` in the URL — keeps it out of logs).
- **Request:** still-frame image → base64 → `contents[].parts[].inline_data` with `mime_type: "image/jpeg"`; user text in the same parts array; the ACE solver + bias-prevention prompt goes in `system_instruction`.
- **generationConfig:** low `temperature` (~0.2) for consistent reasoning; `maxOutputTokens` ~2048 to fit the full response format (§6).

---

## 5. Architecture

Pragmatic clean architecture, feature-based — kept light to honor the simplicity principle. Do not over-layer the MVP.

```
lib/
  features/
    scan/                     # the one MVP feature
      data/                   # GeminiAnswerRepository, dio client, DTOs
      domain/                 # AnswerResult entity, repository interface
      presentation/           # camera screen, result screen, providers, widgets
  core/                       # theme, env/config, router, constants, error types
  shared/                     # reusable widgets, common models
  main.dart
```

**Conventions** (from flutter-skill / dart-skill):

- `const` constructors everywhere possible; `final` for non-reassigned vars.
- Widgets are classes, not functions; keep them < 300 lines, < 3 nesting levels — extract widgets.
- Riverpod providers for state; `AsyncValue` for loading/error/data. Use `FutureProvider` for the AI call, not raw `FutureBuilder`.
- GoRouter (or simple `Navigator` for the 2-screen MVP — simplest that works) for navigation.
- `Theme.of(context)`, Material 3; no hardcoded theme values.
- Files/folders `snake_case`, widgets `PascalCase`, vars `camelCase`, booleans `is`/`has` prefixed, double-quoted strings, max line length 150.
- Model the AI response with `freezed`. Run `dart run build_runner build` after editing freezed/json classes.

---

## 6. The AI is the product — behavior contract

The AI must behave like an **experienced instructor + cloud architect + exam coach**, NOT an OCR engine. It reconstructs the question, then reasons. **Never jump straight to an answer.**

### AI responsibilities (in order)

1. Understand the image. 2. Locate the question. 3. Reconstruct text. 4. Reconstruct answer choices. 5. Analyze each option. 6. Select the best answer. 7. Explain the reasoning.

### Handling imperfect images

Images may be blurry, low-res, cropped, glared, perspective-distorted, partial. The AI must **infer missing info, state its assumptions, and continue** — do **not** fail on minor imperfections.

### Bias prevention (critical)

The image may show selected/highlighted answers, correct/incorrect indicators, explanations, review-mode screens, or community solutions. The AI **MUST IGNORE all of these**, evaluate every option independently, and **never assume a highlighted answer is correct.**

### ACE-specific heuristics

When solving ACE questions, prefer: managed services, operational simplicity, cost optimization, reliability, scalability, security. Concretely prefer: Cloud Run > Compute Engine; Cloud SQL > self-managed DBs; Managed Instance Groups > manual VM fleets; Secret Manager > hardcoded secrets; Service Accounts > user credentials; IAM least privilege > broad permissions; Cloud NAT > unnecessary public IPs.

### System prompt must include

Question reconstruction · visual understanding · ACE heuristics · bias prevention · option-by-option analysis · confidence scoring.

Keep the production system prompt in a single, version-controlled, easy-to-edit location (e.g. `lib/features/scan/data/prompts.dart`). Prompt iteration is a primary lever — treat it as first-class.

### Required response format (the model is asked to output this)

```
## Reconstructed Question
## Question Summary
## Key Requirements        (bulleted)
## Option Analysis         (### A / ### B / ### C / ### D ...)
## Best Answer             (letter)
## Explanation             (detailed reasoning)
## Confidence              (High / Medium / Low)
## Assumptions             (list)
```

The result screen should render this clearly. Markdown rendering is acceptable and simplest.

---

## 7. Security / config notes

- **Do not hardcode the Gemini API key.** Inject via `--dart-define` (e.g. `GEMINI_API_KEY`) read in `core/` config, or a gitignored config. Never commit keys.
- MVP calls the AI directly from the client, so the key ships in the app — this is an **accepted MVP risk** for validation speed. The correct long-term fix (proxy through a backend) is deferred per the simplicity principle; revisit before any public release.
- Add `.env`, key files, and build artifacts to `.gitignore`.

---

## 8. Future roadmap (do not pull forward without a reason)

- **V1** Manual capture → AI → answer (← we are here)
- **V2** Question history (capture → save → review later)
- **V3** OCR layer (image → OCR → question text)
- **V4** Caching layer (question → hash → cache → AI)
- **V5** Live analysis (camera → auto detection → AI)
- **V6** AR assistant (camera → question detection → overlay answer)

---

## 9. Success metrics

MVP succeeds if a user can: open the app → point at a question → capture → receive a correct answer → understand the reasoning.

- **Primary KPI:** Time To Answer
- **Secondary KPI:** Answer Accuracy
- **Tertiary KPI:** User Retention

Favor decisions that reduce Time To Answer and improve perceived accuracy of the explanation.

---

## 10. Working conventions for Claude (every session)

- **Default to the simplest implementation** that satisfies the MVP. Flag when you think more is warranted; don't build it unprompted.
- Check any new idea against §2 (simplicity) and §3 (out-of-scope) before proposing.
- Match existing code style; prefer the project's idioms over introducing new patterns.
- After dependency or freezed/json changes: `flutter pub get`, then `dart run build_runner build --delete-conflicting-outputs`.
- Validate before declaring done: `flutter analyze` (expect zero issues) and run relevant `flutter test`.
- The **AI prompt and the bias-prevention rules are correctness-critical** — never weaken them for convenience.
- Useful commands:
  ```bash
  flutter run                 # run on device/emulator
  flutter analyze             # static analysis (keep clean)
  flutter test                # tests
  dart run build_runner build # codegen (freezed/json/riverpod)
  ```

---

_Source of truth: "AI Exam Assistant PRD". If this file and the code disagree, reconcile and update this file in the same change._
