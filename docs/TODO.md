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
  full-sum trace-integrability, and tail-event domination explicit.
- Next RandomMatrix hardbone task: attack the explicit analytic/provider
  blockers behind `EpsteinAffineLineConcavity` or the sigma-algebra
  independence/conditional-expectation bridge; do not add new Matrix Bernstein
  wrappers unless they consume existing provider APIs.
- Current strategy is progress-first: if a hard analytic ingredient is missing,
  consume it as an explicit assumption, register it in `docs/STATEMENTS.md`, and
  keep moving the high-level Tropp/Lieb trace-MGF route forward. Do not claim
  Lieb/Jensen, Golden-Thompson, operator-log monotonicity, trace-exp
  monotonicity, conditional expectation, or full Matrix Bernstein unless a
  separate provider theorem proves it.

## Active PrecisionDA Work

- Keep PrecisionDA probabilistic surfaces as typed provider contracts until
  the deterministic/probabilistic bridge is explicit.
- Current completed stochastic vocabulary leaf: H1 provider contract
  (`PaperH1SubGaussianModelStatement` /
  `PaperH1SubGaussianModelProvider`) for `X = SigmaSqrt * Z` with independent
  subGaussian latent entries and sample-column covariance fields, plus H2
  leave-one-out good-event vocabulary
  (`leaveOneOutCovarianceLowerBound`, `paperH2LeaveOneOutGoodEvent`,
  `PaperH2LeaveOneOutGoodEventStatement`, and
  `PaperH2LeaveOneOutGoodEventProvider`) as typed assumptions only.
- Current completed H2 good-event probability target leaf:
  `PaperH2GoodEventProbabilityRHS`, `paperH2LeaveOneOutBadEvent`,
  `paperH2LeaveOneOutBadEvent_mem_iff`,
  `paperH2LeaveOneOutBadEvent_eq_compl`,
  `PaperH2LeaveOneOutBadEventMeasurabilityProvider`,
  `paperH2LeaveOneOutBadEvent_measurable_of_provider`,
  `PaperH2LeaveOneOutGoodEventProbabilityStatement`,
  `PaperH2LeaveOneOutGoodEventProbabilityProvider`,
  `paperH2LeaveOneOutGoodEventProbabilityStatement_of_provider`, and
  `paperH2LeaveOneOutGoodEventProbability_bound_of_provider` expose the typed bad-event
  measurability/probability contracts with explicit `bad_event_measurable`,
  `eta_positive`, `rhs_nonnegative`, and `bad_event_probability` fields. This
  is only a proof-entry target; it does not prove probability bounds,
  measurability, concentration, deterministic equivalents, Theorem 1, or the
  closed-form RHS.
- Current completed first proof-stage leaves:
  `paperH2LeaveOneOutBadEvent_mem_iff` proves the definitional rewrite
  `omega ∈ paperH2LeaveOneOutBadEvent X eta lam ↔
  omega ∉ paperH2LeaveOneOutGoodEvent X eta lam` by `rfl`.
  `paperH2LeaveOneOutBadEvent_eq_compl` proves the corresponding set-level
  complement identity by `rfl`, and
  `paperH2LeaveOneOutBadEvent_measurable_of_provider` projects the explicit
  measurability-provider field. These do not prove measurability, probability
  bounds, concentration, deterministic equivalents, Theorem 1, or the
  closed-form RHS.
- Current completed H2 good-event probability provider projection leaf:
  `paperH2LeaveOneOutGoodEventProbabilityStatement_of_provider` projects the
  existing `h2_probability` field, and
  `paperH2LeaveOneOutGoodEventProbability_bound_of_provider` projects the
  existing `bad_event_probability` field through that statement. These are
  downstream API convenience leaves only; they do not prove probability bounds,
  measurability, concentration, deterministic equivalents, Theorem 1, or the
  closed-form RHS.
- Current completed H2 probability consumer statement leaf:
  `PaperH2LeaveOneOutProbabilityConsumerStatement` combines the explicit
  `PaperH2LeaveOneOutBadEventMeasurabilityProvider` with the supplied
  `PaperH2LeaveOneOutGoodEventProbabilityProvider`.
  `paperH2LeaveOneOutProbabilityConsumerStatement_of_providers` builds the
  consumer statement by projection, and
  `paperH2LeaveOneOutProbabilityConsumer_bound_of_providers` exposes the already
  supplied bad-event probability bound. These are downstream API convenience
  leaves only; they do not prove probability bounds, measurability,
  concentration, deterministic equivalents, Theorem 1, or the closed-form RHS.
- Current completed H2 lower-singular-value provider shell leaf:
  `PaperH2LowerSingularValueProvider` names the future “H2 from lower singular
  value” proof-entry boundary while keeping all content as explicit fields:
  `eta_positive`, `rhs_nonnegative`, `bad_event_measurable`, and
  `bad_event_probability` for the existing `paperH2LeaveOneOutBadEvent`.
  The projection theorems
  `paperH2LeaveOneOutBadEventMeasurabilityProvider_of_lowerSingularValueProvider`,
  `paperH2LeaveOneOutGoodEventProbabilityProvider_of_lowerSingularValueProvider`,
  and
  `paperH2LeaveOneOutProbabilityConsumerStatement_of_lowerSingularValueProvider`
  only repackage those fields into existing H2 provider/consumer surfaces. This
  does not prove a lower-singular-value theorem, probability bound,
  measurability, concentration, deterministic equivalent, Theorem 1, or the
  closed-form RHS.
- Current completed Theorem 1 scaffolding leaf: minimal
  `ShrinkageTheorem1Providers` typed bundle tying H1/H2 providers together.
- Current completed Theorem 1 statement leaf: typed tail skeleton
  (`ShrinkageTheorem1BiasTerm`, `ShrinkageTheorem1TailRHS`,
  `shrinkageTheorem1TailEvent`, and `ShrinkageTheorem1TailStatement`) consuming
  `ShrinkageTheorem1Providers` with explicit bias/RHS placeholders.
- Current completed Theorem 1 estimator/bias vocabulary leaf: typed
  paper-facing names for `E_X(lambda)`, `hat E_X(lambda)`, and
  `Delta_X(lambda)` via `paperShrinkageError`, `PaperShrinkageEstimator`,
  `PaperShrinkageBias`, their evaluators, and random pointwise lifts. These
  names do not prove probability bounds, concentration, deterministic
  equivalents, bias estimates, or Theorem 1.
- Current completed Theorem 1 paper-tail wrapper leaf: the named shrinkage
  quantities `paperShrinkageError`, `PaperShrinkageEstimator`, and
  `PaperShrinkageBias` are threaded through a paper-facing Theorem 1 tail
  event/statement surface by `shrinkageTheorem1PaperTailEvent` and
  `ShrinkageTheorem1PaperTailStatement`. This is only a statement-boundary
  adapter; it does not prove probability bounds, concentration, deterministic
  equivalents, bias estimates, or Theorem 1.
- Current completed Theorem 1 paper-tail RHS provider leaf: the paper-side
  scalar RHS slot is named by `PaperShrinkageTailRHS` and
  `paperShrinkageTailRHS`, and connected to the theorem scalar RHS through
  `ShrinkageTheorem1PaperTailRHSProvider` with only identification and
  nonnegativity fields. It does not prove the paper exponential formula,
  probability bound, concentration, deterministic equivalent, or H1/H2
  discharge.
- Current completed Theorem 1 bias-control provider leaf: pointwise
  `Delta_X(lambda)` nonnegativity is exposed by
  `PaperShrinkageBiasControlProvider` through the proof projection
  `pointwise_nonneg : forall omega, 0 <= paperShrinkageBiasTerm bias (X omega)
  lam`. This is only a fixed-`lambda`, pointwise provider contract; it does not
  prove a bound on `Delta_X(lambda)`, any uniform bias control, probability
  bound, concentration, deterministic-equivalent control, H1/H2 discharge, or
  measurability side conditions.
- Current completed Theorem 1 paper-tail measurability provider leaf:
  `ShrinkageTheorem1PaperTailMeasurabilityProvider` exposes the explicit
  measurable-event side condition for `shrinkageTheorem1PaperTailEvent` through
  `tail_event_measurable`. This is only a statement-boundary provider contract;
  it does not prove measurability, probability bounds, concentration,
  deterministic-equivalent control, H1/H2 discharge, or Theorem 1.
- Current completed Theorem 1 paper-tail provider bundle leaf:
  `ShrinkageTheorem1PaperTailProviders` bundles the already separate
  `ShrinkageTheorem1Providers`, `ShrinkageTheorem1PaperTailRHSProvider`,
  `PaperShrinkageBiasControlProvider`, and
  `ShrinkageTheorem1PaperTailMeasurabilityProvider` contracts for downstream
  paper-tail consumers. This is only an aggregation boundary; it does not prove
  Theorem 1, any probability bound, measurability, concentration,
  deterministic-equivalent control, the closed-form RHS, or any
  `Delta_X(lambda)` bound.
- Current completed Theorem 1 paper-tail statement bridge leaf:
  `shrinkageTheorem1PaperTailStatement_of_providers` consumes
  `ShrinkageTheorem1PaperTailProviders`, explicit `0 < lam`, explicit
  `0 <= t`, and an explicit `tail_bound` assumption to produce
  `ShrinkageTheorem1PaperTailStatement`. It only projects existing provider
  fields and does not prove probability bounds, concentration, measurability,
  deterministic equivalents, the closed-form RHS, or `Delta_X(lambda)` bounds.
- Current completed Theorem 1 paper-tail statement bridge API-check leaf:
  downstream API checks project `providers`, `lambda_positive`,
  `threshold_nonnegative`, `tail_rhs_nonnegative`, and `tail_bound` from
  `shrinkageTheorem1PaperTailStatement_of_providers`. This verifies bridge
  field preservation only; it does not prove probability bounds, concentration,
  measurability, deterministic equivalents, the closed-form RHS, or
  `Delta_X(lambda)` bounds.
- Current completed Theorem 1 paper-tail H2 probability consumer leaf:
  `shrinkageTheorem1PaperTailH2Probability_of_providers` threads an explicitly
  supplied `PaperH2LeaveOneOutGoodEventProbabilityProvider` alongside the
  existing `ShrinkageTheorem1PaperTailProviders` bundle and returns that
  provider unchanged. This preserves the old bundle shape and proves no
  probability bound, concentration, measurability, deterministic equivalent,
  Theorem 1 statement, closed-form RHS, or `Delta_X(lambda)` bound.
- Current completed Theorem 1 paper-tail H2 probability consumer-statement
  wrapper leaf:
  `shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_providers`
  threads `ShrinkageTheorem1PaperTailProviders` together with explicit
  `PaperH2LeaveOneOutBadEventMeasurabilityProvider` and
  `PaperH2LeaveOneOutGoodEventProbabilityProvider` inputs into the existing
  `PaperH2LeaveOneOutProbabilityConsumerStatement`. The short-name alias
  `shrinkageTheorem1PaperTailH2ProbabilityConsumer_of_providers` has the same
  target. This preserves the paper-tail bundle shape and proves no probability
  bound, bad-event measurability, concentration, deterministic equivalent,
  Theorem 1 statement, closed-form RHS, or `Delta_X(lambda)` bound.
- Current completed Theorem 1 paper-tail H2 bad-event probability projection
  leaf:
  `shrinkageTheorem1PaperTailH2ProbabilityConsumer_badEventProbability_of_providers`
  projects the `bad_event_probability` field after threading the paper-tail
  provider bundle plus explicit H2 bad-event measurability and probability
  providers into `PaperH2LeaveOneOutProbabilityConsumerStatement`. This is only
  an API convenience theorem; it proves no new probability, measurability,
  concentration, deterministic equivalent, Theorem 1, closed-form RHS, or
  `Delta_X(lambda)` result.
- Current completed H2 lower-singular-value eta-only event leaf:
  `paperH2LowerSingularValueGoodEvent`, its definitional bad-event complement,
  `PaperH2LowerSingularValueStatement`, and
  `PaperH2LowerSingularValueEventProvider` now name the eta-only
  leave-one-out lower-covariance event layer. This is separate from the
  lam-dependent `PaperH2LowerSingularValueProvider` proof-entry shell and
  proves no measurability, probability bound, concentration, Theorem 1 result,
  closed-form RHS, or `Delta_X(lambda)` bound.
- Next safe PrecisionDA task: continue with another pure deterministic/API
  proof leaf. Still do not prove probability bounds, concentration,
  measurability, deterministic equivalents, the closed-form RHS, or
  `Delta_X(lambda)` bounds.

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
