# TODO

This is the active short list. Old completed task logs were collapsed into
[`archive.md`](archive.md); use git history for exact old wording.

## Active Random Object Work

- Keep `RandomFamily` as a vocabulary layer only; defer filtrations,
  adaptedness, martingales, and independence conditioning to later contracts.
- Next random-object task: `RP-API-random-family-downstream-consumer-contract`

## Active RandomMatrix Work

- Select the next smallest theorem-backed hardbone proof leaf with a read-only
  Mathlib/API audit before editing Lean; the local
  `matrixExpLogSelfAdjointNormalization` leaf is now done.
- Keep the Matrix Bernstein under-primitives API honest: wrappers may use Tropp/provider assumptions explicitly, but should not claim missing Tropp/Lieb, Golden-Thompson, trace-MGF, or full Matrix Bernstein proofs.
- Continue reducing repeated optimized-RHS formulas through shared helpers in `ConcentrationStatements.lean`.
- Keep public examples statement-oriented: name families and adapters first, then call the shared RandomMatrix API. Keep `StatementRoutes` as the examples-only entry index for theorem-family routes.
- Completed RandomMatrix hardbone wrapper task:
  `RM-HB-sample-covariance-cfc-free-wrapper-contract`.
- Completed RandomMatrix hardbone proof leaf:
  `RM-HB12-matrix-exp-log-selfadjoint-normalization-leaf`.
- Completed RandomMatrix hardbone proof leaf:
  `RM-HB12-matrix-log-le-of-le-matrix-exp-bridge-leaf`.
- Completed RandomMatrix hardbone proof leaf:
  `RM-HB12-trace-exp-rank-support-bound-leaf`.
- Completed RandomMatrix hardbone proof leaf:
  `RM-HB12-tropp-conditional-step-of-iindepfun-bridge-leaf`.
- Completed RandomMatrix hardbone proof leaf:
  `CG-B17-star-projection-rank-support-consumer-contract`.
- Completed RandomMatrix hardbone proof leaf:
  `CG-B18-star-projection-psd-bridge-contract`: prove
  `isPSDMatrix_of_isStarProjection` and remove the explicit PSD premise from
  the star-projection rank/support consumer.
- Completed RandomMatrix hardbone abstraction leaf:
  `CG-B19-support-domination-certificate-contract`: name the support-domination
  premise as `MatrixExpSupportDomination` without proving a provider.
- Completed RandomMatrix hardbone abstraction leaf:
  `CG-B20-support-domination-provider-contract`: split the provider frontier
  into the ambient identity-support target and the corrected excess-support
  target, without proving either provider.
- Next RandomMatrix hardbone task:
  `CG-B21-excess-support-trace-bridge-contract`: audit the trace-linear algebra
  needed for the excess-support route, including the explicit nonnegative
  excess-coefficient premise.

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
