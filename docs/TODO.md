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
- S16 now has `matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions`
  as the provider-compressed natural-state tail wrapper. Future work should
  compress only genuinely provider-dischargeable assumptions and keep
  independence, conditional expectation, variance-proxy normalization,
  full-sum trace-integrability, and tail-event domination explicit. The
  strengthened history/current-step independence bridge is available through
  `TroppNaturalHistory.historyStepIndependent` and the compatibility theorem
  `troppHistoryStepIndependent_of_iIndepFun_of_measurable`, but the exact
  weaker hardbone statement and conditional expectation remain separate.
- Short resolvent derivative provider layer is now upstream as
  `HighDimProb.RandomMatrix.ResolventDerivativeProvider`, including
  `hasDerivAt_trace_mul_inverse_affineLine_general_neg_cycle` and
  `hasDerivAt_trace_mul_inverse_affineLine_general_neg_cycle_of_strictlyPositive`.
  Any later downstream resolvent work should stay limited to exact proved
  inverse/trace bridges and must not claim a log-resolvent representation or an
  Epstein sign theorem without separate proofs.
- Keep the hardbone integrability signature unchanged until a downstream-safe
  tightening pass is ready; the honest main-provider bridges are now
  `troppCurrentRandomStep_operatorNorm_le_of_summand_bound`,
  `troppStateHistory_operatorNorm_le_of_summand_and_comparison_bounds`, and the
  finite-measure wrappers
  `traceExpIntegrable_troppStateHistory_add_step_of_summand_and_comparison_bounds_finiteMeasure`
  / `traceExpIntegrable_troppStateHistory_add_K_of_summand_and_comparison_bounds_finiteMeasure`.
- Current strategy is progress-first: if a hard analytic ingredient is missing,
  consume it as an explicit assumption, register it in `docs/STATEMENTS.md`, and
  keep moving the high-level Tropp/Lieb trace-MGF route forward. Do not claim
  Lieb/Jensen, Golden-Thompson, operator-log monotonicity, trace-exp
  monotonicity, conditional expectation, or full Matrix Bernstein unless a
  separate provider theorem proves it.

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
