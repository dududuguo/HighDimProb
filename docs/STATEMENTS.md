# Statement Assumption Ledger

This file lists hard analytic assumptions that progress-first RandomMatrix
contracts are allowed to consume explicitly while separate provider work fills
them in. Entries here are not claims that the assumptions are proved.

This is a developer-facing hardbone ledger, not a downstream API reference.
The strategy is to make hard proof frontiers precise enough that independent
provider work can discharge them while HighDimProb remains deliverable and
extensible. Composition theorems recorded here may be useful scaffolds for
type-checking the route, but they should not be treated as the preferred
user-facing surface. Once provider theorems are imported, these scaffolds should
be collapsed, deprecated, or hidden behind smaller stable wrappers.

## RM-LIEB-S9: finite-family trace-MGF from explicit conditioning inputs

Consumer theorem:

- `traceMGFBernsteinVarianceProxyBound_of_conditioningBridge`

This theorem composes the conditioning bridge with the natural-state
finite-family trace-MGF route. It requires the following hard facts as explicit
premises:

- `troppConditionalStep_of_iIndepFun_statement theta X K mHist`, the
  source-level conditioning chain target.
- `troppNaturalHistoryMeasurable_statement theta X K mHist`, used with
  `hHistSub` to supply natural-state history measurability.
- `troppHistoryStepIndependent_of_iIndepFun_statement theta X K`, used with
  finite-family `iIndepFun X P` to supply history/current-step independence.
- Per-index `condExp_traceExp_history_add_independent_step_statement`, the
  conditional-expectation reduction from a history-measurable matrix and an
  independent current step.
- Natural-state side conditions for each index: history sub-sigma algebra,
  history/current random-matrix measurability, self-adjoint history/current
  steps, trace-exponential integrability of `H_i + Z_i`, matrix-exponential
  integrability of `Z_i`, self-adjointness and strict positivity of the
  matrix-exponential mean, sigma-finiteness of the trimmed history measure, and
  trace-exponential integrability of `H_i + K_i`.
- Finite-family Bernstein side conditions: random/self-adjoint summands,
  finite-family independence, scaled matrix-exponential integrability,
  full-sum trace-exponential integrability, self-adjoint comparison matrices,
  self-adjoint variance proxy, nonnegative radius, Bernstein theta range,
  per-index MGF Loewner comparison, and the variance-proxy normalization
  `sum K_i = SMul.smul (bernsteinMGFCoeff theta R) V`.

Non-goals for this consumer:

- It does not prove natural-history measurability, history/current-step
  independence, finite-family independence, conditional-expectation reduction,
  trace-exponential integrability propagation, strict positivity of the
  matrix-exponential mean, variance-proxy control, Lieb/Jensen,
  Golden-Thompson, or full Matrix Bernstein.

## RM-LIEB-S10: conditioning trace-MGF to explicit Laplace/tail route

Consumer theorems:

- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFTailAssumptions`,
  which is only a field-access wrapper around the named assumption bundle
  `MatrixBernsteinConditioningTraceMGFTailAssumptions`.

This theorem composes the S9 conditioning trace-MGF consumer with the existing
quadratic-form Laplace route. It requires all S9 assumptions listed above, plus
the following tail-side facts as explicit premises:

- AEMeasurability of `fun omega => ENNReal.ofReal
  (traceExpIntegrand (randomMatrixSum X) theta omega)`.
- The event bridge from `quadraticFormUpperTailEvent (randomMatrixSum X) t`
  to `traceExpThresholdEvent (randomMatrixSum X) theta t`.

The real trace-MGF to `TraceMGFBernsteinVarianceProxyBoundLIntegral` conversion
is provided by the existing proved bridge, using the explicit full-sum
trace-exponential integrability and self-adjoint summand assumptions already
required by S9.

Non-goals for this consumer:

- It does not prove the tail event domination, natural-history measurability,
  independence conditioning, conditional-expectation reduction, trace-exp
  integrability propagation, strict positivity of matrix-exponential means,
  variance-proxy control, Lieb/Jensen, Golden-Thompson, theta optimization,
  dimension/rank reduction, or full Matrix Bernstein.

## RM-LIEB-S11-S16: provider-facing Lieb/Tropp and natural-state route

Provider-facing import:

- `HighDimProb.RandomMatrix.LiebProvider`

Provider theorem surfaces:

- `EpsteinAffineLineConcavity`, an explicit analytic assumption. It is not
  proved here.
- `liebTraceExpConcavity_of_epsteinAffineLine` and
  `liebJensenTraceExp_statement_of_epsteinAffineLine`, which route the explicit
  Epstein affine-line assumption into the existing Lieb/Jensen statement shape.
- `troppMasterTraceMGFStep_of_epsteinAffineLine` and
  `troppMasterTraceMGFStep_trace_bound_of_epsteinAffineLine_and_providerLogOrder`,
  which compose the conditional Lieb/Jensen route with the proved deterministic
  log/order-to-`K` bridge.
- `MatrixBernsteinConditioningTraceMGFProviderAssumptions` and
  `MatrixBernsteinConditioningTraceMGFProviderAssumptions.toTailAssumptions`,
  which synthesize natural-history measurability and bounded finite-measure
  trace-exp integrability fields only.
- `matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions`,
  which exposes the S10 tail bound through the provider-compressed bundle.

Non-goals for this provider layer:

- It does not prove the unconditional Epstein affine-line theorem, full Lieb
  concavity, Golden-Thompson, history/current independence, conditional
  expectation, variance-proxy normalization, full-sum trace-integrability,
  tail-event domination, or full Matrix Bernstein.

## PrecisionDA-H1: paper subGaussian model provider vocabulary

Provider surfaces:

- `PaperH1SubGaussianModelStatement`
- `PaperH1SubGaussianModelProvider`

The statement records the paper-oriented random data matrix model
`X = SigmaSqrt * Z`, with entrywise independent/subGaussian latent `Z`,
sample-column independence, centered sample columns, and sample-column
covariance `Sigma`.

Non-goals for this surface:

- It does not prove H1 from primitive distributional assumptions.
- It does not prove any leave-one-out good-event probability, concentration
  inequality, deterministic equivalent, or Theorem 1 precision-matrix bound.

## PrecisionDA-H2: leave-one-out good-event provider vocabulary

Provider surfaces:

- `leaveOneOutCovarianceLowerBound`
- `paperH2LeaveOneOutGoodEvent`
- `PaperH2LeaveOneOutGoodEventStatement`
- `PaperH2LeaveOneOutGoodEventProvider`

The statement records the paper H2-style good event as a typed assumption:
positive `eta`, pointwise leave-one-out sample covariance lower bounds expressed
through `PosSemidef`/Loewner vocabulary, and the deterministic invertibility and
nonzero Sherman-Morrison denominator fields already consumed by the
leave-one-out Woodbury API.

Non-goals for this surface:

- It does not prove the H2 good event from H1 or distributional primitives.
- It does not prove a probability bound for the complement of the good event.
- It does not prove concentration, deterministic equivalents, or Theorem 1.

## PrecisionDA-H2-good-event-probability-target: typed bad-event probability provider

Provider surfaces:

- `PaperH2GoodEventProbabilityRHS`
- `paperH2LeaveOneOutBadEvent`
- `paperH2LeaveOneOutBadEvent_mem_iff`
- `paperH2LeaveOneOutBadEvent_eq_compl`
- `PaperH2LeaveOneOutBadEventMeasurabilityProvider`
- `paperH2LeaveOneOutBadEvent_measurable_of_provider`
- `PaperH2LeaveOneOutGoodEventProbabilityStatement`
- `PaperH2LeaveOneOutGoodEventProbabilityProvider`
- `paperH2LeaveOneOutGoodEventProbabilityStatement_of_provider`
- `paperH2LeaveOneOutGoodEventProbability_bound_of_provider`
- `PaperH2LeaveOneOutProbabilityConsumerStatement`
- `paperH2LeaveOneOutProbabilityConsumerStatement_of_providers`
- `paperH2LeaveOneOutProbabilityConsumer_bound_of_providers`
- Field `bad_event_measurable :
  MeasurableSet (paperH2LeaveOneOutBadEvent X eta lam)`
- Theorem `paperH2LeaveOneOutBadEvent_mem_iff :
  omega ∈ paperH2LeaveOneOutBadEvent X eta lam ↔
    omega ∉ paperH2LeaveOneOutGoodEvent X eta lam`
- Theorem `paperH2LeaveOneOutBadEvent_eq_compl :
  paperH2LeaveOneOutBadEvent X eta lam =
    (paperH2LeaveOneOutGoodEvent X eta lam)ᶜ`
- Theorem `paperH2LeaveOneOutBadEvent_measurable_of_provider :
  PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam ->
    MeasurableSet (paperH2LeaveOneOutBadEvent X eta lam)`
- Field `bad_event_probability :
  P (paperH2LeaveOneOutBadEvent X eta lam) <= ENNReal.ofReal rhs`
- Field `h2_probability :
  PaperH2LeaveOneOutGoodEventProbabilityStatement P X eta lam rhs`
- Theorem `paperH2LeaveOneOutGoodEventProbabilityStatement_of_provider :
  PaperH2LeaveOneOutGoodEventProbabilityProvider P X eta lam rhs ->
    PaperH2LeaveOneOutGoodEventProbabilityStatement P X eta lam rhs`
- Theorem `paperH2LeaveOneOutGoodEventProbability_bound_of_provider :
  PaperH2LeaveOneOutGoodEventProbabilityProvider P X eta lam rhs ->
    P (paperH2LeaveOneOutBadEvent X eta lam) <= ENNReal.ofReal rhs`

This surface is the first proof-entry contract for the paper H2 good-event
probability route.  It names the complement of the pointwise H2 good event,
exposes the bad-event measurability side condition as a separate provider, and
records the future probability estimate as an explicit statement field, with
only `eta_positive` and `rhs_nonnegative` side conditions.  The scalar RHS is a
placeholder for a later paper/concentration expression.

Semantically, this is a typed statement/provider target, not a proof.  It keeps
the pointwise H2 provider (`PaperH2LeaveOneOutGoodEventProvider`) separate from
the high-probability discharge provider, so downstream consumers can choose
which layer they require.

The membership and set-level complement theorems are proof-stage leaves on
this route.  They are purely definitional (`rfl`) and only rewrite the bad
event as the complement of the good event.  The measurability projection
theorem exposes an existing provider field; it does not prove measurability.
The probability-provider projection theorems similarly expose existing
`h2_probability` and `bad_event_probability` fields for downstream consumers;
they do not prove the probability estimate.

Non-goals for this surface:

- It does not prove the H2 good-event probability estimate.
- It does not prove measurability of the bad event.
- It does not prove concentration, deterministic equivalents, or Theorem 1.
- It does not identify or prove the closed-form RHS.
- It does not change the existing pointwise H2 good-event provider contract.
- It does not add assumptions beyond existing provider field projections.


## PrecisionDA-H2-probability-consumer-statement: combined H2 probability consumer

Consumer surfaces:

- `PaperH2LeaveOneOutProbabilityConsumerStatement`
- `paperH2LeaveOneOutProbabilityConsumerStatement_of_providers`
- `paperH2LeaveOneOutProbabilityConsumer_bound_of_providers`
- `PaperH2LowerSingularValueProvider`
- `paperH2LeaveOneOutBadEventMeasurabilityProvider_of_lowerSingularValueProvider`
- `paperH2LeaveOneOutGoodEventProbabilityProvider_of_lowerSingularValueProvider`
- `paperH2LeaveOneOutProbabilityConsumerStatement_of_lowerSingularValueProvider`

This consumer combines the already separate H2 bad-event measurability provider
and H2 good-event probability provider into one downstream statement boundary.
It records the explicit measurable bad event, the supplied
`PaperH2LeaveOneOutGoodEventProbabilityStatement`, and the projected probability
bound for `paperH2LeaveOneOutBadEvent`.

Semantically, this is a consumer/projection layer only.  The provider-to-statement
bridge threads existing fields from
`PaperH2LeaveOneOutBadEventMeasurabilityProvider` and
`PaperH2LeaveOneOutGoodEventProbabilityProvider`; the bound helper exposes the
already supplied probability field.

Non-goals for this surface:

- It does not prove the H2 good-event probability estimate.
- It does not prove measurability of the bad event.
- It does not prove concentration, deterministic equivalents, or Theorem 1.
- It does not identify or prove the closed-form RHS.

## PrecisionDA-H2-lower-singular-value-eta-only-event: eta-only event vocabulary

Provider surfaces:

- `paperH2LowerSingularValueGoodEvent`
- `paperH2LowerSingularValueBadEvent`
- `paperH2LowerSingularValueBadEvent_mem_iff`
- `paperH2LowerSingularValueBadEvent_eq_compl`
- `PaperH2LowerSingularValueStatement`
- `PaperH2LowerSingularValueEventProvider`

This surface splits out the eta-only lower-singular-value core of paper H2.  The
good event states only `forall k, leaveOneOutCovarianceLowerBound (X omega) k eta`.
It intentionally does not mention `lam`, determinant units, resolvent
invertibility, Sherman-Morrison denominators, or the lam-dependent
`paperH2LeaveOneOutBadEvent X eta lam`.

Semantically, this is event vocabulary and a typed assumption/provider wrapper
for the future lower-singular-value route.  It is distinct from
`PaperH2LowerSingularValueProvider`, which remains the proof-entry shell for
explicit measurability and probability fields targeting the existing
lam-dependent H2 bad event.

Non-goals for this surface:

- It does not prove any lower-singular-value theorem.
- It does not prove measurability of the eta-only bad event.
- It does not prove any probability bound or concentration estimate.
- It does not bridge the eta-only event into the lam-dependent H2 good event.
- It does not prove Theorem 1 or identify a closed-form RHS.


## PrecisionDA-H2-lower-singular-value-provider-shell: proof-entry provider boundary

Provider surfaces:

- `PaperH2LowerSingularValueProvider`
- Field `eta_positive : 0 < eta`
- Field `rhs_nonnegative : 0 <= rhs`
- Field `bad_event_measurable :
  MeasurableSet (paperH2LeaveOneOutBadEvent X eta lam)`
- Field `bad_event_probability :
  P (paperH2LeaveOneOutBadEvent X eta lam) <= ENNReal.ofReal rhs`
- `paperH2LeaveOneOutBadEventMeasurabilityProvider_of_lowerSingularValueProvider`
- `paperH2LeaveOneOutGoodEventProbabilityProvider_of_lowerSingularValueProvider`
- `paperH2LeaveOneOutProbabilityConsumerStatement_of_lowerSingularValueProvider`

This surface is a minimal proof-entry shell for the future route “H2 from a
lower-singular-value theorem.”  It does not introduce a new event vocabulary;
instead it targets the existing `paperH2LeaveOneOutBadEvent X eta lam` so that
downstream code can immediately reuse the already checked H2 measurability,
probability, and consumer statement boundaries.

Semantically, the lower-singular-value name records the intended future source
of the provider fields.  The current declarations only repackage explicit
fields into the existing H2 bad-event measurability provider, H2 good-event
probability provider, and combined probability consumer statement.

Non-goals for this surface:

- It does not prove any lower-singular-value theorem.
- It does not prove the H2 good-event probability estimate.
- It does not prove measurability of the bad event.
- It does not derive its probability fields from the separate eta-only
  lower-singular-value event layer.
- It does not prove concentration, deterministic equivalents, or Theorem 1.
- It does not identify or prove the closed-form RHS.

## PrecisionDA-Theorem1-provider-bundle: minimal shrinkage Theorem 1 provider bundle

Provider surfaces:

- `ShrinkageTheorem1Providers`
- Field `h1 : PaperH1SubGaussianModelProvider P X Z Sigma SigmaSqrt sigmaX`
- Field `h2 : PaperH2LeaveOneOutGoodEventProvider P X eta lam`

The bundle records the minimal named provider surface for the paper's shrinkage
Theorem 1 route. It only ties together the already-typed H1 subGaussian model
provider and H2 leave-one-out good-event provider, so downstream Theorem
1-shaped consumers can request a single named assumption bundle and project the
`h1` and `h2` fields.

Semantically, this is a provider vocabulary object, not a theorem statement.
The H1 side supplies the paper-oriented random data matrix model
`X = SigmaSqrt * Z`. The H2 side supplies the pointwise leave-one-out good
event, including the deterministic invertibility and Sherman-Morrison
denominator assumptions consumed by the resolvent/Woodbury API. The bundle
does not add any probability estimate to H2; it merely packages the pointwise
provider contracts that already exist.

Non-goals for this surface:

- It does not prove Theorem 1.
- It does not state or prove the Theorem 1 probability bound.
- It does not prove H1 or H2 from primitive distributional assumptions.
- It does not prove a probability bound for the complement of the H2 good event.
- It does not enter concentration estimates, deterministic equivalents,
  resolvent concentration, or precision-matrix error bounds.

## PrecisionDA-Theorem1-statement-skeleton: typed shrinkage Theorem 1 tail statement skeleton

Provider surfaces:

- `ShrinkageTheorem1BiasTerm`
- `ShrinkageTheorem1TailRHS`
- `shrinkageTheorem1TailEvent`
- `ShrinkageTheorem1TailStatement`

The statement skeleton records the paper-facing shape of the shrinkage Theorem
1 tail route as typed vocabulary. It sits above the minimal H1/H2 bundle
`ShrinkageTheorem1Providers`: the H1 side supplies the subGaussian data model
`X = SigmaSqrt * Z`, and the H2 side supplies the pointwise leave-one-out good
event and deterministic invertibility/Sherman-Morrison denominator providers.

Semantically, this is a statement target and provider-consumer boundary, not a
proof of the paper theorem. The event records the additive-bias tail shape
`|trueError - estimatedError| >= t + bias`; the statement records the H1/H2
providers, positive shrinkage parameter, nonnegative threshold/RHS side
conditions, and an explicit probability-bound field using the RHS placeholder.
The bias and RHS are named real parameters only; this layer does not define,
estimate, or identify them.

Non-goals for this surface:

- It does not prove any tail bound.
- It does not prove concentration from the H1 subGaussian model.
- It does not prove the H2 good-event probability estimate.
- It does not prove a deterministic equivalent or identify bias/rate terms.
- It does not prove resolvent concentration or precision-matrix error control.
- It does not prove Theorem 1.


## PrecisionDA-Theorem1-estimator-bias-vocabulary: typed paper estimator/bias names

Provider surfaces:

- `paperShrinkageError`, the paper-facing name for `E_X(lambda)` using the
  already-defined deterministic shrinkage precision error.
- `randomPaperShrinkageError`, the pointwise random lift of `paperShrinkageError`.
- `PaperShrinkageEstimator`, the data/lambda estimator slot for
  `hat E_X(lambda)`.
- `PaperShrinkageBias`, the data/lambda bias slot for `Delta_X(lambda)`.
- `paperShrinkageEstimatedError` and `randomPaperShrinkageEstimatedError`.
- `paperShrinkageBiasTerm` and `randomPaperShrinkageBiasTerm`.

This surface only names the paper estimator/bias vocabulary consumed by the
shrinkage Theorem 1 tail route. It separates the true paper error `E_X(lambda)`,
the data-computable estimator `hat E_X(lambda)`, and the additive bias
placeholder `Delta_X(lambda)` so later statement layers can refer to these roles
without anonymous real-valued arguments.

Semantically, these are typed vocabulary objects and statement-boundary names,
not estimates. `paperShrinkageError` reuses the deterministic Frobenius error
already available in the algebraic layer. The estimator and bias slots are
explicit functions of data and `lambda`; this layer does not encode the paper's
closed formula for the estimator or identify/bound the bias term.

Non-goals for this surface:

- It does not prove Theorem 1.
- It does not prove any probability bound.
- It does not prove concentration from H1.
- It does not prove the H2 good-event probability estimate.
- It does not prove a deterministic equivalent.
- It does not estimate or bound `Delta_X(lambda)`.
- It does not prove resolvent concentration or precision-matrix error control.


## PrecisionDA-Theorem1-paper-tail-wrapper: threaded paper shrinkage tail wrapper

Provider surfaces:

- `shrinkageTheorem1PaperTailEvent`
- `ShrinkageTheorem1PaperTailStatement`

This wrapper is the paper-facing adapter from the named shrinkage vocabulary to
the Theorem 1 tail surface. It threads the true paper error `E_X(lambda)`, the
estimator slot `hat E_X(lambda)`, and the bias/slack slot `Delta_X(lambda)`
through a visible paper-tail event using the already named objects:

- `paperShrinkageError` for the pointwise true error;
- `PaperShrinkageEstimator` through `paperShrinkageEstimatedError`;
- `PaperShrinkageBias` through `paperShrinkageBiasTerm`.

Semantically, this is only a naming and argument-threading layer. It makes the
paper roles visible at the statement boundary so downstream code no longer
passes anonymous `Omega -> Real` error terms when it means the shrinkage
Theorem 1 paper quantities. Any probability inequality recorded by the wrapper
remains an explicit statement field or assumption; it is not derived here from
H1, H2, concentration, or deterministic-equivalent estimates.

Non-goals for this surface:

- It does not prove Theorem 1.
- It does not prove any probability or tail bound.
- It does not prove concentration from H1.
- It does not prove the H2 good-event probability estimate.
- It does not prove a deterministic equivalent.
- It does not identify, estimate, or uniformly bound `Delta_X(lambda)`.
- It does not prove resolvent concentration or precision-matrix error control.


## PrecisionDA-Theorem1-paper-tail-RHS-provider: paper-side scalar tail RHS placeholder

Provider surfaces:

- `PaperShrinkageTailRHS`
- `paperShrinkageTailRHS`
- `ShrinkageTheorem1PaperTailRHSProvider`

This surface names the paper-side scalar RHS slot consumed by the shrinkage
Theorem 1 tail statement.  The evaluator is parameterized by the dimension
indices at the type level and by scalar model/tail parameters
`lambdaMinSigma`, `sigmaX`, `eta`, and `t` at the value level.  The provider
only connects a named evaluator value to the scalar `ShrinkageTheorem1TailRHS`
used by the tail statement and records its nonnegativity.

Semantically, this is a scalar probability-bound placeholder.  It intentionally
keeps random objects, H1/H2 provider discharge, bias-control assumptions, and
measurability side conditions outside this RHS object.  The paper's closed-form
exponential RHS, universal constants, and eigenvalue lower-bound proof remain
future provider work.

Non-goals for this surface:

- It does not prove Theorem 1.
- It does not prove any probability or tail bound.
- It does not prove H1/H2 probability discharge.
- It does not prove concentration or deterministic-equivalent estimates.
- It does not identify or bound `Delta_X(lambda)`.
- It does not prove measurability of the tail event.
- It does not encode the final closed-form exponential RHS.


## PrecisionDA-Theorem1-bias-control-provider: pointwise Delta_X(lambda) bias-control provider

Provider surfaces:

- `PaperShrinkageBiasControlProvider`
- Field projection `pointwise_nonneg`

This surface records the minimal pointwise side condition for the paper
bias/slack term `Delta_X(lambda)`.  The provider is parameterized by the random
data matrix `X`, a fixed shrinkage parameter `lambda`, and the already named
`PaperShrinkageBias` slot.  Because the provider is `Prop`-valued, the bias
slot is a parameter rather than a data projection; the only projected field is
the proof that `paperShrinkageBiasTerm bias (X omega) lambda` is nonnegative for
every sample outcome.

Semantically, this is a fixed-`lambda`, pointwise provider contract.  It does
not identify the paper formula for `Delta_X(lambda)`, estimate its size, or turn
the pointwise side condition into a probability statement.  Uniform bias bounds
and measurability side conditions remain separate future provider layers.

Non-goals for this surface:

- It does not prove Theorem 1.
- It does not prove a bound on `Delta_X(lambda)` beyond the recorded pointwise
  nonnegativity field.
- It does not prove any uniform-in-`lambda`, uniform-in-data, or uniform-in-sample
  bias control.
- It does not prove any probability or tail bound.
- It does not prove H1/H2 probability discharge.
- It does not prove concentration, deterministic-equivalent estimates,
  resolvent concentration, or precision-matrix error control.
- It does not prove measurability of the tail event.

## PrecisionDA-Theorem1-paper-tail-measurability-provider: paper-tail event measurability provider

Provider surfaces:

- `ShrinkageTheorem1PaperTailMeasurabilityProvider`
- Field projection `tail_event_measurable`

This surface records the named measurability side condition for the paper-facing
shrinkage Theorem 1 tail event `shrinkageTheorem1PaperTailEvent`.  The provider
is parameterized by the random data matrix `X`, deterministic inverse covariance
input `SigmaInv`, estimator slot, bias slot, fixed shrinkage parameter `lambda`,
and threshold `t`.  Its only projected field is the explicit `MeasurableSet`
assumption for that event.

Semantically, this is a statement-boundary provider contract.  It keeps event
measurability visible and separate from the probability inequality, RHS provider,
and bias-control provider so future tail consumers can request exactly the
measurable-event side condition they need.

Non-goals for this surface:

- It does not prove measurability of `shrinkageTheorem1PaperTailEvent`.
- It does not prove Theorem 1.
- It does not prove any probability or tail bound.
- It does not prove concentration from H1.
- It does not prove the H2 good-event probability estimate.
- It does not prove a deterministic equivalent.
- It does not identify, estimate, or uniformly bound `Delta_X(lambda)`.
- It does not prove resolvent concentration or precision-matrix error control.

## PrecisionDA-Theorem1-paper-tail-provider-bundle: bundled paper-tail provider surface

Provider surfaces:

- `ShrinkageTheorem1PaperTailProviders`
- Field projection `core`
- Field projection `rhs`
- Field projection `bias_control`
- Field projection `measurability`
- Thin H2 probability consumer `shrinkageTheorem1PaperTailH2Probability_of_providers`
- Thin H2 probability consumer-statement wrapper
  `shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_providers`
- Short-name alias
  `shrinkageTheorem1PaperTailH2ProbabilityConsumer_of_providers`
- Bad-event probability projection
  `shrinkageTheorem1PaperTailH2ProbabilityConsumer_badEventProbability_of_providers`

This surface bundles the already separate provider contracts needed by the
paper-facing shrinkage Theorem 1 tail route.  The `core` field supplies the
existing H1/H2 `ShrinkageTheorem1Providers` bundle, `rhs` supplies the named
paper-tail RHS provider, `bias_control` supplies pointwise nonnegativity for
`Delta_X(lambda)`, and `measurability` supplies the explicit measurable-event
side condition for `shrinkageTheorem1PaperTailEvent`.

The H2 probability consumer theorem deliberately takes an explicit
`PaperH2LeaveOneOutGoodEventProbabilityProvider` alongside this bundle and
returns that provider unchanged.  This keeps `ShrinkageTheorem1PaperTailProviders`
minimal (`core`, `rhs`, `bias_control`, `measurability`) while giving later
paper-tail code a named place to thread the H2 probability assumption.

The H2 probability consumer-statement wrapper similarly keeps the paper-tail
bundle unchanged, but also accepts the explicit
`PaperH2LeaveOneOutBadEventMeasurabilityProvider` and
`PaperH2LeaveOneOutGoodEventProbabilityProvider` needed to build
`PaperH2LeaveOneOutProbabilityConsumerStatement`.  The longer
`...ConsumerStatement_of_providers` name is the canonical statement wrapper;
`...Consumer_of_providers` is a short-name alias with the same target.  The
bad-event probability projection exposes the packaged
`bad_event_probability` field for downstream paper-tail consumers without
reproving the H2 probability estimate.

Semantically, this is only an aggregation boundary for downstream paper-tail
consumers.  It proves none of the bundled fields and adds no new probability,
concentration, deterministic-equivalent, measurability, RHS, or bias result.

Non-goals for this surface:

- It does not prove Theorem 1.
- It does not prove any probability or tail bound.
- It does not add the H2 probability provider to the paper-tail bundle.
- It does not prove H2 bad-event measurability or the H2 probability estimate;
  both remain explicit provider inputs.
- It does not prove measurability of `shrinkageTheorem1PaperTailEvent`.
- It does not prove concentration or deterministic-equivalent estimates.
- It does not encode or prove the closed-form RHS.
- It does not identify, estimate, or bound `Delta_X(lambda)`.

## PrecisionDA-Theorem1-paper-tail-statement-bridge: thin provider-to-statement bridge

Provider surfaces:

- `shrinkageTheorem1PaperTailStatement_of_providers`
- Bridge projection API checks for `providers`, `lambda_positive`,
  `threshold_nonnegative`, `tail_rhs_nonnegative`, and `tail_bound`

This thin consumer turns the bundled paper-tail provider surface into
`ShrinkageTheorem1PaperTailStatement` under only the remaining explicit scalar
and probability assumptions:

- `providers : ShrinkageTheorem1PaperTailProviders ...`
- `lambda_positive : 0 < lam`
- `threshold_nonnegative : 0 <= t`
- `tail_bound :
  P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) <=
    ENNReal.ofReal tailRHS`

The bridge projects `providers.core` for the H1/H2 statement field and
`providers.rhs.rhs_nonnegative` for the RHS nonnegativity field.  It does not
derive the probability inequality; `tail_bound` remains an explicit premise.

The bridge projection checks are downstream API regression coverage only; they
confirm result-field projection and add no new mathematical content.

Non-goals for this surface:

- It does not prove Theorem 1.
- It does not prove any probability or tail bound.
- It does not prove concentration.
- It does not prove deterministic equivalents.
- It does not prove measurability of `shrinkageTheorem1PaperTailEvent`.
- It does not encode or prove the closed-form RHS.
- It does not identify, estimate, or bound `Delta_X(lambda)`.
