# Model Comparison — gemini-3.5-flash vs gemini-3.1-pro

**Wave 5 validation.** 42 real captured ACE/Architect exam images (screens, monitor/projector
photos, phone shots, glare/angle, multi-window), each run through **both** models with the **same
production prompt**. Flash used our prod config (thinking off, 4096 cap); Pro ran with thinking on
(its natural mode). Pro acts as the stronger "oracle" reference (it benchmarks above flash on
reasoning), so flash agreeing with Pro is strong evidence flash is correct.

> Note: the comparison crashed on the 43rd image only because that cached file was deleted
> mid-run (a missing-file error, not a model error). All 42 prior results are complete.

## Headline result

| Axis                     | gemini-3.5-flash (prod)            | gemini-3.1-pro               | Verdict                                                  |
| ------------------------ | ---------------------------------- | ---------------------------- | -------------------------------------------------------- |
| **Agreement / accuracy** | —                                  | —                            | **41 / 42 identical answers (98%)**, all High confidence |
| **Execution time**       | avg **5.8 s** (3.3–9.1 s)          | avg **19.8 s** (12.2–50.5 s) | flash **~71% faster**                                    |
| **Image processing**     | 42/42 read OK, 0 failures/refusals | 42/42 read OK                | tie — both robust                                        |
| **Cost / scan**          | ~**$0.0114**                       | ~**$0.0297**                 | flash **~2.6× cheaper**                                  |
| **Cost (42 imgs)**       | ~$0.48                             | ~$1.25                       | —                                                        |

## 1. Execution time

- **flash:** avg **5,811 ms**, range 3,272–9,117 ms.
- **pro:** avg **19,820 ms**, range 12,177–50,506 ms (two big spikes where Pro generated 3,700–4,500
  thinking tokens on hard scenarios).
- **flash is ~71% faster** — directly relevant to the primary KPI (Time-To-Answer).

## 2. Answer accuracy

- **41 of 42 answers identical**, every one at **High** confidence on both models.
- On the questions with known/▸revealed answers (e.g. SSH→C OS Login, Q11→A Deployment Manager which
  matched the on-screen "Correct Answer: A", Dockerfile→C, Jenkins→D Marketplace), the agreed answers
  were **correct** — so this is real accuracy, not just two models echoing each other.
- **The 1 divergence:** `31.png` — flash=**C**, pro=**B**. Pro deliberated heavily here (2,923
  thinking tokens), which marks it as a genuinely hard, multi-step scenario (the kind where a thinking
  model has an edge). Could not be re-adjudicated because the image cache was cleared. Treat as the
  single "hard reasoning" case to spot-check manually.

## 3. Image processing (robustness)

- **Both models succeeded on all 42 images — zero failures, zero refusals, zero RECITATION blocks.**
- This includes the degraded captures: angled phone shots, screen glare, multi-window laptop photos,
  and partial/scrolled views.
- **Implication for preprocessing:** none needed for the MVP. Gemini's vision is handling the
  imperfect real-world captures as-is; deskew/lighting preprocessing would be solving a problem we
  don't currently have. (Revisit only if specific image-quality failures appear later.)

## 4. Cost

- Rates: flash $1.50 in / $9 out per 1M; pro $2.00 in / $12 out per 1M (output includes thinking).
- **Pro's cost is dominated by thinking tokens** — 50,590 total across 42 images (avg ~1,204/image),
  all billed at the $12/1M output rate.
- Per scan: **flash ~$0.0114** vs **pro ~$0.0297** → flash is **~2.6× cheaper**.
- (Estimated from logged thinking tokens + measured token profile; the exact-token JSON was lost to
  the end-of-run crash, but the per-scan figures match our earlier direct measurement.)

## Recommendation: keep gemini-3.5-flash

Pro costs **~2.6× more** and is **~3.5× slower**, yet produced an **identical answer on 41 of 42**
real questions. The only difference was one hard IAM-scenario question. For an exam-assist app where
**Time-To-Answer is the primary KPI**, paying 3.5× the latency and 2.6× the cost to _maybe_ fix one
hard question in ~forty is the wrong trade.

**Decision: stay on `gemini-3.5-flash` (thinking off).** Keep Pro available only as a future
escalation path — e.g. an optional "deep mode" for low-confidence or known-hard questions, if user
demand ever justifies it.
