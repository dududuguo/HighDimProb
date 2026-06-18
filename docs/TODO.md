# TODO

This is the active short list. Old completed task logs were collapsed into
[`archive.md`](archive.md); use git history for exact old wording.

## Active RandomMatrix Work

- Audit remaining explicit CFC fields in the sample-covariance route. Reuse
  `bernsteinMatrixExp_le_quadratic` and the new Tropp-only Matrix Bernstein
  bundles before adding any new fields.
- Keep the Matrix Bernstein under-primitives API honest: wrappers may use Tropp/provider assumptions explicitly, but should not claim missing Tropp/Lieb, Golden-Thompson, trace-MGF, or full Matrix Bernstein proofs.
- Continue reducing repeated optimized-RHS formulas through shared helpers in `ConcentrationStatements.lean`.
- Keep public examples readable: name families and adapters first, then call the shared RandomMatrix API.
- Next RandomMatrix hardbone task:
  `RM-HB-sample-covariance-cfc-free-wrapper-contract`.

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
