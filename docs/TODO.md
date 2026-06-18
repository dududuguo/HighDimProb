# TODO

This is the active short list. Old completed task logs were collapsed into
[`archive.md`](archive.md); use git history for exact old wording.

## Active RandomMatrix Work

- Audit remaining negative-side operator-norm and trace-MGF assumptions in the sample-covariance route. Reuse the named opposite-parameter exp/trace/CFC provider-transfer adapters before adding any new fields.
- Keep the Matrix Bernstein under-primitives API honest: wrappers may use Tropp/CFC/provider assumptions explicitly, but should not claim the missing primitive proofs.
- Continue reducing repeated optimized-RHS formulas through shared helpers in `ConcentrationStatements.lean`.
- Keep public examples readable: name families and adapters first, then call the shared RandomMatrix API.
- Next RandomMatrix hardbone task:
  `RM-HB11-select-first-hardbone-proof-leaf`.

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
