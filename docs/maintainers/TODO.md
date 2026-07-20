# TODO

This file is the sole authority for active tasks and next-task selection.
No status page, plan, archive, or historical note assigns current work; if
another document appears to conflict with this file, this file governs. Old
completed task logs were collapsed into [`archive.md`](../archive/README.md), and
[`LeafPlan.md`](../archive/LeafPlan.md) is retained only as historical chronology; use git
history for exact old wording.

## Active Random Object Work

- Keep `RandomFamily` as a vocabulary layer only; defer filtrations,
  adaptedness, martingales, and independence conditioning to later contracts.
- Next random-object task: `RP-API-random-family-downstream-consumer-contract`.

### Dudley Closure Roadmap

The Dudley route is closed under explicit boundary conditions. D1 supplies the
finite anchored entropy bound, D2/D3 supply the residual/integral and dense-sup
passages, and `dudleyEntropyIntegral` constructs the dyadic finite geometry and
controls its terminal residual by the finite subGaussian maximum theorem. The
endpoint retains explicit dense-sequence, singleton-anchor-net,
total-boundedness, sample regularity, full-supremum integrability, and entropy
interval-integrability assumptions.

- [x] **D1 finite anchored supremum.** The finite anchored process supremum is
  bounded by the truncated entropy integral plus an explicit integrable
  terminal-residual envelope, under a supplied common-anchor compatible path
  family and shared finite level data.
- [x] **D2 small-scale/full-integral passage.** The finite-prefix residual in
  `dudleyEntropyIntegral` tends to `0` by a finite subGaussian maximum estimate;
  no dominated-convergence adapter is needed for this endpoint. The deterministic
  compact bridges `tendstoUniformlyOn_abs_sub_of_isCompact`,
  `tendsto_edist_uniformFun_abs_sub_of_isCompact`, and
  `tendsto_toReal_edist_uniformFun_abs_sub_of_isCompact` are proved under their
  explicit compactness, continuity, uniform-approximation, and mapping inputs;
  they do not connect an actual D1 path/net construction to expectation. The
  integral half is proved by `tendsto_intervalIntegral_of_leftEndpoint_tendsto`,
  `tendsto_dyadicRadius_atTop`, and
  `tendsto_intervalIntegral_dyadicRadius_atTop`, with
  `le_intervalIntegral_of_le_residual_add_of_tendsto_zero` handling a supplied
  residual limit under an explicit `IntervalIntegrable` hypothesis.
- [x] **D3 supplied dense-sequence/full supremum passage.**
  `expect_iSup_abs_sub_anchor_le_of_denseRange_of_prefix_bound` transfers a
  uniform expected bound on finite prefix maxima to the full anchored
  supremum. It reuses Mathlib partial suprema and monotone integral convergence
  plus `ciSup_eq_ciSup_of_denseRange`; its dense sequence, sample continuity,
  pointwise boundedness, measurability, and full-supremum integrability remain
  explicit inputs. The D2-to-D3 assembly bridge
  `expect_iSup_abs_sub_anchor_le_mul_intervalIntegral_of_denseRange_of_prefix_bound`
  is also proved, but only from supplied prefix bounds and supplied residual
  expectation convergence. A separable-space consumer may supply Mathlib's
  `denseSeq`.
- [x] **D4 exact full Dudley facade.** `dudleyEntropyIntegral` proves the
  anchored expected-supremum entropy-integral bound under explicit probability,
  geometry, increment, regularity, and entropy-integrability assumptions.

No active Dudley closure leaf remains. A future API refinement may weaken or
derive the explicit full-supremum integrability assumption, but must not replace
the current theorem with a stronger unproved claim.

- Optional/nonblocking covering refinement: prove the sharper Maurey l1 bound
  `(2d + 1)^ceil(R^2 / eps^2)`; the current volumetric covering bounds are
  proved and supported.

Do not build:

- duplicate net constructors, cardinality conversions, or a single-path theorem;
- custom dense-sequence, `Measurable.iSup`, monotone convergence, or
  adjacent-interval machinery;
- convenience aliases before two consumers exist.

Risk gates:

- Total boundedness plus continuity is insufficient to guarantee boundedness on
  nonclosed `K`.
- The same anchor/base term must be used throughout the comparison.
- Entropy at `t = 0` must be handled by an explicit limiting/integral contract.
- An increment MGF does not imply sample-path regularity.
- The abstract endpoint must have no coordinate/product-space restriction.

## Active RandomMatrix Work

- Hanson-Wright is closed at the stable finite real-matrix endpoint
  `HighDimProb.HansonWright.hanson_wright_inequality_hdp`; no Hanson-Wright task
  remains active. Keep any extension separate from this finite-coordinate,
  no-symmetry contract.
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
- The directional matrix sub-Gaussian route now closes the explicit finite-net
  operator-norm tail. Its next safe refinement is a thin Euclidean unit-sphere
  net construction/cardinality consumer that reuses the geometry APIs and
  specializes `N.card`; do not replace it with a false directional-to-Loewner
  MGF bridge.
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
  consume it as an explicit assumption and register it in `docs/maintainers/STATEMENTS.md`.
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
