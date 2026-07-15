# TODO

This is the active short list. Old completed task logs were collapsed into
[`archive.md`](archive.md); use git history for exact old wording.

## Active Random Object Work

- Keep `RandomFamily` as a vocabulary layer only; defer filtrations,
  adaptedness, martingales, and independence conditioning to later contracts.
- Next random-object task: `RP-API-random-family-downstream-consumer-contract`.

### Five-Stage Chaining Roadmap

1. [x] **finite chaining.** Keep the existing finite chain and
   centered-subGaussian level-supremum theorems limited to supplied finite
   levels, parents, and cardinality certificates. The metric increment
   adapter is now `expect_abs_sub_chain_le_sum_of_level_sup_of_subGaussianMGFIncrements`.
2. [x] **minimal-cover adapter.**
   `exists_finset_isInternalEpsilonNet_of_totallyBounded` now connects
   `TotallyBounded K` and `0 < ε` to a finite internal epsilon-net with exact
   `coveringNumber K ε` cardinality relations.
3. [ ] **dyadic entropy sum.** The single-layer and finite-level parent bridges
   `exists_parentMap_of_subset_of_isInternalEpsilonNet` and
   `exists_finset_parentMap_of_internalLevels` are proved. Add compatible
   dyadic nets, endpoint paths, and entropy sums only after fixing the
   cover-radius convention and the `dist` bound needed by
   `HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le`.
4. [ ] **entropy integral.** Add the dyadic-to-integral comparison with an
   explicit positive scale range and finiteness hypothesis. No integral
   declaration exists yet.
5. [ ] **Dudley.** Add a limiting supremum theorem only after the finite stages,
   separability/measurable-version contract, and entropy-integral finiteness
   are proved. This stage is not currently available.

Boundary reminder: `HasSubGaussianMGFIncrements` itself does not require
`0 < σ`; its radius adapter requires `0 < σ`, `0 < r`, and `dist s t ≤ r`.
The current measurable supremum API is finite `Finset`-only. The completed
minimal-cover adapter does not provide an infinite-process or separability
theorem; no dyadic sum, entropy integral, or Dudley endpoint exists yet.

## Active RandomMatrix Work

- Keep the Matrix Bernstein API boundary honest: the generated-history
  `MatrixBernstein.*_of_primitives` facades close the canonical optimized and
  high-probability statements, but do not provide automatic variance-proxy
  bounds, the older arbitrary-denominator statement, or an unconditional full
  Matrix Bernstein theorem. Golden--Thompson is now proved separately by
  `goldenThompsonTraceExp`.
- Use `MatrixBernstein.highProbability_of_primitives` for the closed
  generated-history `1 - delta` route. Preserve `0 < n`, `0 < delta <= 1`,
  `0 <= sigmaSq`, `0 <= R`, and `0 < sigmaSq or 0 < R`; keep this finite-family
  route separate from the older arbitrary-denominator and unconditional
  contracts.
- Use `TraceExpConditioning.troppStep_of_history_le` when a consumer can prove
  `mHist <= MeasurableSpace.comap H _`; use
  `TraceExpConditioning.bernsteinStep_of_history_le` when the current step has
  the standard Bernstein primitives and packet construction is the only missing
  adapter. Do not use either theorem to claim independence for an arbitrary
  larger history sigma-algebra.
- Prefer shared RandomMatrix APIs over unfolded formulas in examples, tests,
  judge files, and docs.
- Keep new Matrix Bernstein/sample-covariance route variants behind named
  target axes and assumption records when possible; bridge-layer declarations may
  be public infrastructure, but they should not become the preferred user route
  merely because a proof leaf exposed them.
- `MatrixBernstein.centeredRankOneExactRow` and
  `MatrixBernstein.sampleCovarianceExactRow` now close the generated-history
  exact-row tail route, while
  `MatrixBernstein.sampleCovarianceExactRowHighProbability` closes its
  normalized `1 - delta` specialization. Use `iIndepFun_centeredRankOne`
  when raw random-vector independence is available. The next safe task is a
  reader-facing exact-row application or a Loewner/spectral corollary; keep the
  older Tropp bundles as compatibility surfaces.
- S16 now has `matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions`
  as the provider-compressed natural-state tail wrapper. Future work should
  compress only genuinely provider-dischargeable assumptions and keep
  finite-family independence, conditional expectation, variance-proxy
  normalization, full-sum trace-integrability, and tail measurability explicit.
  The exact history/current-step contract is now synthesized from the bundle's
  random-matrix data. The
  self-adjoint TailEvent provider wrappers discharge the event-subset premise
  but do not prove the rest of the endpoint. The
  strengthened history/current-step independence bridge is available through
  `TroppNaturalHistory.historyStepIndependent` and
  `TroppNaturalHistory.historyStepContractOfIsRandomMatrix`. The latter returns
  the exact legacy contract under explicit random-matrix data; the weaker bare
  hardbone statement and conditional expectation remain separate.
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
  consume it as an explicit assumption and register it in `docs/STATEMENTS.md`.
  The left/right relative-entropy, Lieb/Epstein, Golden--Thompson, and legacy
  Lieb/Jensen Tropp one-step contract are closed; do not conflate them with
  arbitrary-history conditional expectation, automatic variance-proxy control,
  or unconditional full Matrix Bernstein.

## Active PrecisionDA Application Work

- Keep `HighDimProb.Applications.PrecisionDA` as an application statement and
  deterministic algebra layer. Do not promote paper-specific objects into core
  RandomMatrix APIs unless a second consumer needs the same abstraction.
- Next PrecisionDA task: continue with a small deterministic/application proof
  leaf or a provider-contract audit; do not claim H1/H2 probability bounds,
  deterministic equivalents, concentration, or Theorem 1 without separate
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
python3 .github/scripts/check_text_quality.py
python3 scripts/judge_policy_check.py
lake build
lake build HighDimProbJudge
lake test
```

For docs-only edits, run at least the two Python checks and `git diff --check`.
