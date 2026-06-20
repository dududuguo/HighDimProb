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
- Next RandomMatrix hardbone task:
  `RM-VP-centered-square-chain-wrapper-integration-contract`.
- The concrete exact-row row-moment bridge is available. The next task should
  add thin sample-covariance wrapper variants that consume the generic
  centered-square variance-proxy chain bridge instead of the sample-specific
  sharp-chain premise, without claiming new Tropp/Lieb or full Matrix Bernstein
  proofs.

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
