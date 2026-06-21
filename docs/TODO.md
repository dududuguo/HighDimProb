# TODO

This is the active short list. Old completed task logs were collapsed into
[`archive.md`](archive.md); use git history for exact old wording.

## Active Random Object Work

- Keep `RandomFamily` as a vocabulary layer only; defer filtrations,
  adaptedness, martingales, and independence conditioning to later contracts.
- Next random-object task: `RP-API-random-family-downstream-consumer-contract`.

## Active RandomMatrix Work

- Keep the Matrix Bernstein under-primitives API honest: wrappers may use
  Tropp/provider assumptions explicitly, but must not claim missing Tropp/Lieb,
  Golden-Thompson, trace-MGF, variance-proxy sharp-chain providers, or full
  Matrix Bernstein proofs.
- Prefer shared RandomMatrix APIs over unfolded formulas in examples, tests,
  judge files, and docs.
- Keep new Matrix Bernstein/sample-covariance route variants behind named
  target axes and assumption records when possible; bridge-layer declarations may
  be public infrastructure, but they should not become the preferred user route
  merely because a proof leaf exposed them.
- Exact-row centered-square sample-covariance wrappers, negative-side exact-row
  transfer, and PSD Loewner norm monotonicity are bridge-layer infrastructure for
  future provider compression; the compact bounded-row sample-covariance route
  remains the reader-facing surface.
- Next RandomMatrix hardbone task:
  `RM-LIEB-S7-real-to-complexified-positivity-order-bridge-audit-contract`.
- That next task should audit whether HighDimProb real PSD, `MatrixLE`, and real
  strict-positivity assumptions can provide the complexified premises consumed
  by the proved real-to-`CStarMatrix` transport lemmas. Do not treat `CFC.log`
  log-back compatibility as proved unless a separate compatibility theorem is
  established.

## Active Documentation Work

- Keep `Status.md`, `TODO.md`, and plan files short.
- Move only short historical summaries to `archive.md` instead of expanding
  active docs.
- Keep `RandomMatrixAPI.md`, `TermMap.md`, `TheoremAtlas.md`, and
  `TestPlan.md` as current indices only.
- Update API docs when public names or example routes change.

## Verification Before Commit

```bash
python .github/scripts/check_text_quality.py
python scripts/judge_policy_check.py
lake build
lake build HighDimProbJudge
lake test
```

For docs-only edits, run at least the two Python checks and `git diff --check`.
