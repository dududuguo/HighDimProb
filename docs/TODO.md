# TODO

This is the active short list. Old completed task logs were collapsed into
[`archive.md`](archive.md); use git history for exact old wording.

## Active RandomMatrix Work

- Select the next smallest theorem-backed hardbone proof leaf with a read-only
  Mathlib/API audit before editing Lean.
- Keep the Matrix Bernstein under-primitives API honest: wrappers may use Tropp/provider assumptions explicitly, but should not claim missing Tropp/Lieb, Golden-Thompson, trace-MGF, or full Matrix Bernstein proofs.
- Continue reducing repeated optimized-RHS formulas through shared helpers in `ConcentrationStatements.lean`.
- Keep public examples readable: name families and adapters first, then call the shared RandomMatrix API.
- Completed RandomMatrix hardbone wrapper task:
  `RM-HB-sample-covariance-cfc-free-wrapper-contract`.
- Completed RandomMatrix hardbone proof leaf:
  `RM-HB12-tropp-conditional-step-of-iindepfun-bridge-leaf`.
- Next RandomMatrix hardbone task:
  `RM-HB12-select-next-hardbone-proof-leaf`.

## Active Documentation Work

- Keep `Status.md`, `TODO.md`, and plan files short.
- Move only short historical summaries to `archive.md` instead of expanding active docs.
- Keep `RandomMatrixAPI.md`, `TermMap.md`, `TheoremAtlas.md`, and `TestPlan.md` as current indices only.
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
