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

The exact full Dudley facade is complete. The proved route is:

- [x] **D1 finite anchored supremum.** Finite terminal nets are bounded by the
  truncated entropy integral with a fixed anchor.
- [x] **D2 small-scale/full-integral passage.** Dyadic radii tend to zero and
  the explicit interval-integrable entropy integrand bounds every truncation.
- [x] **D3 actual set-supremum passage.** Independent finite nets converge
  pointwise to the actual `sSup` over a totally bounded `K`; the finite-limit
  API proves measurability and integrability of the limit.
- [x] **D4 exact full Dudley facade.** `dudley_full_supremum_bound` proves the
  measurable, `Integrable` supremum and
  `E sup ≤ 4 * sigma * ∫_0^R sqrt(2 * log(2 * N(K,t))) dt` under explicit
  probability, geometry, coordinate-measurability, subGaussian-increment,
  every-sample-uniform-continuity, and
  `IntervalIntegrable (dudleyEntropyIntegrand K) volume 0 R` assumptions.

Optional future work, not an incompleteness of the current theorem:

- [ ] Investigate an a.e.-only sample-path regularity contract or a separable
  modification when a downstream application needs a weaker hypothesis.
- [ ] Add alternate entropy representations for settings where an extended
  (`ENNReal`) entropy object is preferable to the current real-valued API.

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
  normalized `1 - delta` specialization. Prefer the
  `CenteredRankOneInputs.ofIIndepFun` /
  `CenteredRankOneExactRowInputs.ofIIndepFun` constructors (backed by
  `iIndepFun_centeredRankOne`) so callers state only vector-level `iIndepFun`.
  The LoRA and NTK Gram examples now both use this exact-row + vector-independence
  route with normalized, high-probability, and Loewner-sandwich endpoints via the
  shared `upperTailProb_operatorNorm_smul_one_div_natCast` scaling helper. The
  generic `MatrixBernstein.CenteredSelfAdjointObservationInputs` /
  `centeredSelfAdjointObservations` route now lifts self-adjoint observations to
  the optimized tail under explicit centered-square-integrability, centered
  operator-norm, and variance-proxy obligations. `.ofIIndepFun` discharges only
  the centered independence obligation from observation-level `iIndepFun` via
  `iIndepFun_centeredRandomMatrix`, so this is a conditional facade, not an
  unconditional integrable/self-adjoint Bernstein theorem;
  `CenteredSelfAdjointClosureUsage` is its thin end-to-end consumer. The
  Attention feature-Gram example now uses the same exact-row + vector-independence
  route (`AttentionGramInputs.ofIIndepFun`, normalized/high-probability/sandwich),
  so the rewritten LoRA / NTK / Attention examples no longer expose
  provider/Tropp interfaces; the sample-covariance, empirical-Fisher, and
  random-feature-kernel examples still use explicit Tropp bundles and remain the
  next alignment candidates. Keep the older Tropp bundles in core as
  compatibility surfaces.
- Application-naming and constant-sharpness follow-ups (from a math review): the
  LoRA example controls the uncentered second moment `(1/m) sum x x^T`, not the
  gradient covariance; identifiers keep the legacy `Covariance` label pending a
  decision to rename to `SecondMoment`/`Gram`. The centered rank-one exact-row
  radius `2 R` and proxy `sum Rvar_i^2` are valid but non-optimal; the sharp
  rank-one providers (radius `R` from `0 <= B, M <= R I`, and variance bound
  `(1/4) sum r_i^2` from `E[Y^2] <= r_i M_i - M_i^2 <= (r_i^2 / 4) I`) are not yet
  formalized. The deterministic Loewner-sandwich endpoints are vacuous at zero
  sample count (documented in their docstrings); the tail/high-probability
  endpoints already require a positive count.
- Softmax-attention v1 is closed at a positive temperature: the public interface
  `attentionSoftmaxFeatures` / `attentionSoftmaxGramInputs` /
  `attentionSoftmaxGram_highProbability` takes `tau : {t : Real // 0 < t}` and
  turns independent measurable random logits into bounded (`vectorSqNorm <= 1`)
  attention-weight probability features that close the centered rank-one Bernstein
  consumer with radius and variance radii `1`. The general all-real object is the
  core `HighDimProb.expNormalized` (exponential/Gibbs normalization). Deferred: the
  softmax Jacobian / `1 / (2 tau)` Lipschitz layer (which genuinely needs
  `tau > 0`) and the shared-random-input (conditional) self-attention case, which
  the current unconditional Bernstein API cannot express.
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
