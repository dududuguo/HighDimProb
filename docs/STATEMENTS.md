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

- `matrixExpFDeriv`, `hasFDerivAt_matrix_exp`,
  `hasStrictFDerivAt_matrix_exp`, `hasFDerivAt_matrix_exp_trunc`,
  `matrixExpSelfAdjoint`, `matrixExpFDerivSelfAdjoint`,
  `matrixExpFDerivSelfAdjoint_spectral_equiv`,
  `hasFDerivAt_matrix_exp_selfAdjoint`, and
  `hasStrictFDerivAt_matrix_exp_selfAdjoint`, the ambient and self-adjoint
  carrier finite-dimensional matrix-exponential Frechet derivative layers plus
  the self-adjoint spectral-equivalence primitive.
- `cfcLogSelfAdjoint`, `CFCLog.derivSAAt`, `CFCLog.lineDeriv`,
  `CFCLog.hasDerivAt_line`,
  `exists_hasDerivAt_cfcLog_affineLine_of_strictlyPositive`, and
  `hasDerivAt_cfcLog_affineLine_of_strictlyPositive`, the strictly-positive
  self-adjoint carrier first-order `CFC.log` derivative layer. This is not a
  second-order sign theorem.
- `hasDerivAt_inverse_affineLine`,
  `hasDerivAt_trace_mul_inverse_affineLine_general_neg_cycle`, and their
  strict-positive / identity-line specializations, the short inverse and
  trace-resolvent derivative layer. This is not a log-resolvent representation.
- `lambdaMaxOrdered_le_of_matrixLE_selfAdjoint` and
  `lambdaMinOrdered_le_of_matrixLE_selfAdjoint`, ordered spectral endpoint
  monotonicity under explicit self-adjointness and `MatrixLE`.
- `traceMGFBernsteinVarianceProxyBoundLIntegral_of_real`,
  `matrixBernsteinTraceMGFToLaplaceContract`, and
  `matrixBernsteinTraceMGFToLaplaceContract_under_primitives`, thin
  trace-MGF-to-Laplace contracts under explicit premises.
- `troppNaturalHistoryMeasurable_of_suffix_entry_measurable`, the conditional
  suffix-entry measurability bridge for natural Tropp histories.
- `troppHistoryStepIndependent_of_iIndepFun_of_measurable`, the strengthened
  independence bridge from `iIndepFun X P` plus explicit summand measurability;
  the weaker exact statement contract is still kept separate.
- `matrixExpScaledIntegrable_of_provider_finiteMeasure`,
  `traceExpIntegrable_troppStateHistory_add_step_of_operatorNormBounds_finiteMeasure`,
  `traceExpIntegrable_troppStateHistory_add_K_of_operatorNormBounds_finiteMeasure`,
  `troppCurrentRandomStep_operatorNorm_le_of_summand_bound`,
  `troppStateHistory_operatorNorm_le_of_summand_and_comparison_bounds`, and the
  summand/comparison-bound finite-measure trace-exp wrappers, bounded
  replacements that do not discharge weaker unbounded hardbone statements.
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

- It does not prove a log-resolvent representation, the Epstein trace-second
  sign theorem, the unconditional Epstein affine-line theorem, full Lieb
  concavity, Golden-Thompson, the weaker exact history/current independence
  statement without explicit summand measurability, conditional expectation,
  variance-proxy normalization, full-sum trace-integrability, tail-event
  domination, or full Matrix Bernstein.

## PrecisionDA application statement/provider boundary

Application import:

- `HighDimProb.Applications.PrecisionDA`

Current surfaces:

- deterministic paper-oriented covariance, leave-one-out covariance, shrinkage
  resolvent, rank-one/Woodbury, and Frobenius trace-expansion wrappers;
- deterministic H2 event factorization, separating
  `paperH2LeaveOneOutGoodEvent X eta lam` into the eta-only
  `paperH2LowerSingularValueGoodEvent X eta` core and the lambda-dependent
  `paperH2ResolventGoodEvent X lam` invertibility/Woodbury side conditions.
  The complementary side now includes `paperH2ResolventBadEvent`,
  `paperH2ResolventBadEvent_mem_iff`, `paperH2ResolventBadEvent_eq_compl`,
  `paperH2LeaveOneOutBadEvent_mem_imp_lowerBad_or_resolventBad`, and
  `paperH2LeaveOneOutBadEvent_subset_lowerBad_union_resolventBad`, exposing
  the full bad event as a subset of the lower-bad/resolvent-bad union without
  proving any probability inequality.  Under an explicit pointwise
  lower-singular-value event provider, the deterministic wrappers
  `paperH2LeaveOneOutGoodEvent_of_lowerEventProvider_and_resolvent` and
  `paperH2LeaveOneOutGoodEvent_eq_resolventGood_of_lowerEventProvider`
  reduce the full leave-one-out good event to the lambda-dependent resolvent
  good event; they prove no lower-provider construction, measurability,
  concentration, or probability estimate.  The associated measurability
  wrappers
  `paperH2LeaveOneOutGoodEvent_measurable_of_lowerEventProvider_and_resolventProvider`,
  `paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_lowerEventProvider_and_resolventProvider`,
  and
  `paperH2LeaveOneOutBadEventMeasurabilityProvider_of_lowerEventProvider_and_resolventProvider`
  only repackage an explicit resolvent-good measurability provider through
  this deterministic equality and the existing good-to-bad complement bridge;
- minimal H2 event measurability provider shells for the lower-singular value
  factor, resolvent factor, and their leave-one-out intersection, with direct
  field projections
  `PaperH2LowerSingularValueStatement_eta_positive`,
  `PaperH2LowerSingularValueStatement_good_event`,
  `paperH2LowerSingularValueEventProvider_h2_lower_singular_value`,
  `paperH2LowerSingularValueEventProvider_eta_positive`,
  `paperH2LowerSingularValueGoodEventMeasurabilityProvider_lower_singular_value_good_event_measurable`,
  `paperH2LowerSingularValueBadEventMeasurabilityProvider_lower_singular_value_bad_event_measurable`,
  `paperH2ResolventGoodEventMeasurabilityProvider_resolvent_good_event_measurable`,
  `paperH2ResolventBadEventMeasurabilityProvider_resolvent_bad_event_measurable`,
  `paperH2LeaveOneOutGoodEventMeasurabilityProvider_good_event_measurable`,
  and
  `paperH2LeaveOneOutBadEventMeasurabilityProvider_bad_event_measurable`,
  short projection theorems, an intersection bridge, and
  good-event-to-bad-event complement provider bridges;
- eta-only lower-singular-value bad-event measurability vocabulary:
  `PaperH2LowerSingularValueBadEventMeasurabilityProvider`,
  `paperH2LowerSingularValueBadEvent_measurable_of_provider`,
  `paperH2LowerSingularValueGoodEvent_measurable_of_badEventProvider`,
  `paperH2LowerSingularValueGoodEventMeasurabilityProvider_of_badEventProvider`,
  and
  `paperH2LowerSingularValueBadEventMeasurabilityProvider_of_goodEventProvider`.
  These are only complement wrappers around
  `paperH2LowerSingularValueBadEvent_eq_compl`;
- lambda-dependent resolvent bad-event measurability vocabulary:
  `PaperH2ResolventBadEventMeasurabilityProvider`,
  `paperH2ResolventBadEvent_measurable_of_provider`, and
  `paperH2ResolventBadEventMeasurabilityProvider_of_goodEventProvider`.
  These are only complement wrappers around
  `paperH2ResolventBadEvent_eq_compl`;
- deterministic eta-only lower-singular-value event consequences:
  `paperH2LowerSingularValueEventProvider_eta_positive`,
  `paperH2LowerSingularValueGoodEvent_eq_univ_of_statement`,
  `paperH2LowerSingularValueGoodEvent_eq_univ_of_eventProvider`,
  `paperH2LowerSingularValueGoodEvent_mem_of_eventProvider`,
  `paperH2LowerSingularValueBadEvent_eq_empty_of_statement`,
  `paperH2LowerSingularValueGoodEvent_measurable_of_statement`,
  `paperH2LowerSingularValueBadEvent_measurable_of_statement`,
  `paperH2LowerSingularValueGoodEventMeasurabilityProvider_of_eventProvider`,
  `paperH2LowerSingularValueBadEventMeasurabilityProvider_of_eventProvider`,
  `paperH2LowerSingularValueBadEvent_measure_eq_zero_of_statement`,
  `paperH2LowerSingularValueBadEvent_eq_empty_of_eventProvider`, and
  `paperH2LowerSingularValueBadEvent_measure_eq_zero_of_eventProvider`.
  The new measurability wrappers only rewrite the pointwise good/bad events to
  `Set.univ` / `∅`; they do not prove primitive lower-singular-value
  measurability, probability, or concentration estimates.
  The same pointwise provider also supplies the deterministic leave-one-out
  good-event reduction
  `paperH2LeaveOneOutGoodEvent_of_lowerEventProvider_and_resolvent` and
  `paperH2LeaveOneOutGoodEvent_eq_resolventGood_of_lowerEventProvider`,
  isolating the remaining H2 event work on the resolvent factor only.
  Provider-form measurability wrappers now consume the same pointwise lower
  provider together with an explicit resolvent-good measurability provider,
  yielding full leave-one-out good/bad measurability without proving primitive
  resolvent measurability.
  The same deterministic leaf now has an eta-only probability contract and
  provider surface: `PaperH2LowerSingularValueBadEventProbabilityStatement`,
  `PaperH2LowerSingularValueBadEventProbabilityProvider`,
  `paperH2LowerSingularValueBadEventProbabilityProvider_lower_bad_event_probability`,
  `paperH2LowerSingularValueBadEventProbabilityStatement_of_statement`,
  `paperH2LowerSingularValueBadEventProbabilityProvider_of_eventProvider`, and
  `paperH2LowerSingularValueBadEventProbability_bound_of_eventProvider`.
  These consume the pointwise lower-singular-value statement/provider only;
  they are empty-event/zero-measure wrappers, not concentration bounds;
- lambda-dependent resolvent bad-event probability hypothesis surface:
  `PaperH2ResolventBadEventProbabilityStatement`,
  `PaperH2ResolventBadEventProbabilityProvider`,
  `paperH2ResolventBadEventProbabilityProvider_resolvent_bad_event_probability`,
  `paperH2ResolventBadEventProbabilityStatement_of_provider`,
  `paperH2ResolventBadEventProbabilityProvider_of_statement`, and
  `paperH2ResolventBadEventProbability_bound_of_provider`. These package an
  explicit RHS assumption for `paperH2ResolventBadEvent`; they do not prove a
  Woodbury-denominator, resolvent-tail, concentration, or probability estimate;
- full H2 bad-event union-bound consumer surface:
  `PaperH2LeaveOneOutBadEventUnionBoundStatement`,
  `PaperH2LeaveOneOutBadEventUnionBoundStatement_lower_bad_event_probability`,
  `PaperH2LeaveOneOutBadEventUnionBoundStatement_resolvent_bad_event_probability`,
  `PaperH2LeaveOneOutBadEventUnionBoundStatement_bad_event_probability`,
  `paperH2LeaveOneOutBadEventUnionBoundStatement_of_probabilityProviders`,
  `paperH2LeaveOneOutBadEventUnionBound_bound_of_probabilityProviders`,
  `paperH2LeaveOneOutBadEventUnionBoundRHS`,
  `paperH2LeaveOneOutBadEventUnionBoundRHS_nonnegative`,
  `paperH2LeaveOneOutBadEventUnionBound_bound_of_probabilityProviders_realRHS`,
  `PaperH2LeaveOneOutBadEventUnionBoundRHSProvider`,
  `paperH2LeaveOneOutBadEventUnionBoundRHSProvider_self`,
  `paperH2LeaveOneOutBadEventUnionBoundRHSProvider_rhs_eq`,
  `paperH2LeaveOneOutBadEventUnionBoundRHSProvider_nonnegative`,
  `paperH2LeaveOneOutBadEventUnionBound_bound_of_probabilityProviders_rhsProvider`,
  `paperH2LeaveOneOutBadEventUnionBoundStatement_of_lowerEventProvider_and_resolventProbabilityProvider`,
  `paperH2LeaveOneOutBadEventUnionBound_bound_of_lowerEventProvider_and_resolventProbabilityProvider`,
  `paperH2LeaveOneOutBadEventUnionBound_bound_of_lowerEventProvider_and_resolventProbabilityProvider_realRHS`,
  `PaperH2LeaveOneOutGoodEventStatement_eta_positive`,
  `PaperH2LeaveOneOutGoodEventStatement_good_event`,
  `paperH2LeaveOneOutGoodEventProvider_h2`,
  `paperH2LeaveOneOutGoodEventProbabilityProvider_of_unionBoundProbabilityProviders`,
  `paperH2LeaveOneOutGoodEventProbabilityProvider_of_lowerEventProvider_and_resolventProbabilityProvider`,
  `PaperH2LeaveOneOutGoodEventProbabilityStatement_eta_positive`,
  `PaperH2LeaveOneOutGoodEventProbabilityStatement_rhs_nonnegative`,
  `PaperH2LeaveOneOutGoodEventProbabilityStatement_bad_event_probability`,
  `paperH2LeaveOneOutGoodEventProbabilityProvider_h2_probability`,
  `paperH2LeaveOneOutProbabilityConsumerStatement_bad_event_measurable`,
  `paperH2LeaveOneOutProbabilityConsumerStatement_h2_probability`, and
  `paperH2LeaveOneOutProbabilityConsumerStatement_bad_event_probability`.
  This is the pure set/measure bridge from the existing lower-bad and
  resolvent-bad probability providers to the full leave-one-out bad event, using
  `paperH2LeaveOneOutBadEvent_subset_lowerBad_union_resolventBad`,
  `measure_union_le`, the `ENNReal.ofReal_add` normalization of the named
  combined Real RHS, and a provider-composition bridge back to the existing
  `PaperH2LeaveOneOutGoodEventProbabilityProvider`.  The lower-event variant
  additionally composes the deterministic empty-event lower-bad wrapper from a
  pointwise lower-singular-value event provider, while leaving the resolvent
  probability provider explicit; it still proves neither component tail
  estimate.  The lower-singular-value H2 provider shell also exposes direct
  field projections
  `paperH2LowerSingularValueProvider_eta_positive`,
  `paperH2LowerSingularValueProvider_rhs_nonnegative`,
  `paperH2LowerSingularValueProvider_bad_event_measurable`, and
  `paperH2LowerSingularValueProvider_bad_event_probability`.  The lower-bad and
  resolvent-bad probability provider shells also expose direct statement-field
  projections
  `paperH2LowerSingularValueBadEventProbabilityProvider_lower_bad_event_probability`
  and `paperH2ResolventBadEventProbabilityProvider_resolvent_bad_event_probability`,
  again without proving any probability estimate;
- paper-tail H2 union-bound/probability projection wrappers:
  `shrinkageTheorem1PaperTailH2UnionBoundStatement_of_providers`,
  `shrinkageTheorem1PaperTailH2UnionBound_badEventProbability_of_providers`,
  `shrinkageTheorem1PaperTailH2UnionBound_realRHS_badEventProbability_of_providers`,
  `shrinkageTheorem1PaperTailH2UnionBoundStatement_of_lowerEventProvider_and_resolventProbabilityProvider`,
  `shrinkageTheorem1PaperTailH2UnionBound_badEventProbability_of_lowerEventProvider_and_resolventProbabilityProvider`,
  `shrinkageTheorem1PaperTailH2UnionBound_realRHS_badEventProbability_of_lowerEventProvider_and_resolventProbabilityProvider`,
  `shrinkageTheorem1PaperTailH2Probability_of_unionBoundProbabilityProviders`,
  `shrinkageTheorem1PaperTailH2Probability_of_lowerEventProvider_and_resolventProbabilityProvider`,
  `shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_unionBoundProbabilityProviders`,
  `shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_lowerEventProvider_and_resolventProbabilityProvider`,
  `shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_lowerEventProvider_and_resolventPaperRHSBounds`,
  `shrinkageTheorem1PaperTailH2ProbabilityConsumer_of_unionBoundProbabilityProviders`,
  `shrinkageTheorem1PaperTailH2ProbabilityConsumer_of_lowerEventProvider_and_resolventProbabilityProvider`,
  `shrinkageTheorem1PaperTailH2ProbabilityConsumer_of_lowerEventProvider_and_resolventPaperRHSBounds`,
  `shrinkageTheorem1PaperTailH2ProbabilityConsumer_badEventProbability_of_unionBoundProbabilityProviders`,
  `shrinkageTheorem1PaperTailH2ProbabilityConsumer_badEventProbability_of_lowerEventProvider_and_resolventProbabilityProvider`,
  `shrinkageTheorem1PaperTailH2ProbabilityConsumer_badEventProbability_of_lowerEventProvider_and_resolventPaperRHSBounds`,
  `ShrinkageTheorem1PaperTailWithH2ResolventProbabilityStatement`,
  `shrinkageTheorem1PaperTailWithH2ResolventProbabilityStatement_of_provider`,
  `ShrinkageTheorem1PaperTailWithH2ConsumerStatement`, and
  `shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_unionBoundProbabilityProviders`,
  plus the lower-event entry
  `shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventProbabilityProvider`
  and its paper-RHS specialization
  `shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventPaperRHSBounds`
  and the direct resolvent-wrapper consumer
  `shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_resolventProbabilityStatement_and_lowerEventProvider`,
  plus the typed proof-readiness ledger
  `ShrinkageTheorem1ProofReadinessObligations`, its direct field projection
  surface (`shrinkageTheorem1ProofReadinessObligations_providers`,
  `shrinkageTheorem1ProofReadinessObligations_lambda_positive`,
  `shrinkageTheorem1ProofReadinessObligations_threshold_nonnegative`,
  `shrinkageTheorem1ProofReadinessObligations_paper_tail_bound`,
  `shrinkageTheorem1ProofReadinessObligations_h2_bad_event_measurability`,
  `shrinkageTheorem1ProofReadinessObligations_lower_rhs_nonnegative`,
  `shrinkageTheorem1ProofReadinessObligations_h2_union_rhs`,
  `shrinkageTheorem1ProofReadinessObligations_lower_singular_value_event`,
  and
  `shrinkageTheorem1ProofReadinessObligations_resolvent_bad_event_probability`),
  and its consumer bridge
  `shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_proofReadinessObligations`,
  plus the lower-event convenience constructor
  `shrinkageTheorem1ProofReadinessObligations_of_lowerEventProvider`, which
  derives the H2 bad-event measurability field from `providers.core` H1 and the
  lower singular-value event provider without proving a probability bound, and
  the direct consumer
  `shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventProbabilityProvider_fromH1`,
  which immediately feeds that constructed ledger into the theorem-facing H2
  consumer wrapper,
  and the paper-RHS-specialized ledger
  `ShrinkageTheorem1PaperRHSProofReadinessObligations` with direct field
  projection surface
  `shrinkageTheorem1PaperRHSProofReadinessObligations_providers`,
  `shrinkageTheorem1PaperRHSProofReadinessObligations_lambda_positive`,
  `shrinkageTheorem1PaperRHSProofReadinessObligations_threshold_nonnegative`,
  `shrinkageTheorem1PaperRHSProofReadinessObligations_paper_tail_bound`,
  `shrinkageTheorem1PaperRHSProofReadinessObligations_h2_bad_event_measurability`,
  `shrinkageTheorem1PaperRHSProofReadinessObligations_lower_rhs_nonnegative`,
  `shrinkageTheorem1PaperRHSProofReadinessObligations_lower_singular_value_event`,
  and the three prefactor plus three component-tail field projections, together
  with the consumer projection
  `shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_paperRHSProofReadinessObligations`,
  plus the lower-event convenience constructor
  `shrinkageTheorem1PaperRHSProofReadinessObligations_of_lowerEventProvider`,
  which fills only the H2 bad-event measurability field from the paper-tail H1
  provider and the lower singular-value event provider while leaving all
  paper-RHS component tail bounds explicit, and the direct theorem-facing
  consumer
  `shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1`,
  plus the ledger consumer/probability projections
  `shrinkageTheorem1PaperTailH2ProbabilityConsumer_of_paperRHSProofReadinessObligations`
  and
  `shrinkageTheorem1PaperTailH2ProbabilityConsumer_badEventProbability_of_paperRHSProofReadinessObligations`,
  and the compact final-bridge ledger
  `ShrinkageTheorem1PaperRHSFinalBridgeObligations` with consumer
  `shrinkageTheorem1TailStatement_of_paperRHSFinalBridgeObligations` and
  direct projection-only accessors
  `shrinkageTheorem1PaperRHSFinalBridgeObligations_paper_rhs_readiness` /
  `shrinkageTheorem1PaperRHSFinalBridgeObligations_final_tail_bound`,
  the typed final-event subset target
  `ShrinkageTheorem1FinalEventSubsetStatement`, the pure monotonicity bridges
  `shrinkageTheorem1TailBound_of_eventSubset_paperTailBound` /
  `shrinkageTheorem1TailBound_of_finalEventSubsetStatement`, the subset-driven
  final-readiness wrappers
  `shrinkageTheorem1PaperRHSFinalBridgeObligations_of_eventSubset` /
  `shrinkageTheorem1PaperRHSFinalBridgeObligations_of_finalEventSubsetStatement`,
  and the direct tail-statement consumers
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_eventSubset` /
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetStatement`,
  plus the pointwise deterministic comparison provider
  `ShrinkageTheorem1FinalEventSubsetComparisonProvider`, its projection-only
  accessors
  `shrinkageTheorem1FinalEventSubsetComparisonProvider_true_error_eq`,
  `shrinkageTheorem1FinalEventSubsetComparisonProvider_estimated_error_eq`, and
  `shrinkageTheorem1FinalEventSubsetComparisonProvider_paper_bias_le_final_bias`,
  its subset theorem
  `shrinkageTheorem1FinalEventSubsetStatement_of_comparisonProvider`, and the
  direct final theorem consumer
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetComparisonProvider`,
  together with the random-paper-error specialization
  `ShrinkageTheorem1FinalBiasDominanceStatement`,
  `ShrinkageTheorem1FinalBiasDominanceProvider`,
  `shrinkageTheorem1FinalBiasDominanceStatement_of_provider`,
  `shrinkageTheorem1FinalBiasDominance_bound_of_provider`,
  `shrinkageTheorem1FinalBiasDominanceProvider_of_statement`,
  `shrinkageTheorem1FinalBiasDominanceStatement_mono`,
  `shrinkageTheorem1FinalBiasDominanceProvider_mono`,
  `constantPaperShrinkageBias`,
  `paperTheorem1VarianceBiasComponent`,
  `paperTheorem1VariancePaperBias`,
  `paperTheorem1VarianceBiasComponent_nonnegative`,
  `paperShrinkageBiasTerm_constant`,
  `paperShrinkageBiasTerm_paperTheorem1VariancePaperBias`,
  `randomPaperShrinkageBiasTerm_constant`,
  `randomPaperShrinkageBiasTerm_paperTheorem1VariancePaperBias`,
  `addPaperShrinkageBias`,
  `paperShrinkageBiasTerm_add`,
  `randomPaperShrinkageBiasTerm_add`,
  `paperTheorem1VarianceBiasControlProvider`,
  `paperShrinkageBiasControlProvider_of_uniformNonneg`,
  `paperShrinkageBiasControlProvider_of_constantPaperBias`,
  `paperShrinkageBiasControlProvider_of_addPaperBias`,
  `PaperShrinkageBiasUpperBoundStatement`,
  `PaperShrinkageBiasUpperBoundProvider`,
  `paperShrinkageBiasUpperBoundStatement_of_provider`,
  `paperShrinkageBiasUpperBound_of_provider`,
  `paperShrinkageBiasUpperBoundProvider_of_statement`,
  `paperShrinkageBiasUpperBoundStatement_of_constantPaperBias`,
  `paperShrinkageBiasUpperBoundProvider_of_constantPaperBias`,
  `paperShrinkageBiasUpperBoundStatement_of_paperTheorem1VarianceBiasComponent`,
  `paperShrinkageBiasUpperBoundProvider_of_paperTheorem1VarianceBiasComponent`,
  `paperTheorem1ExponentialBiasComponent`,
  `paperTheorem1ExponentialPaperBias`,
  `paperTheorem1ExponentialBiasComponent_nonnegative`,
  `paperShrinkageBiasTerm_paperTheorem1ExponentialPaperBias`,
  `randomPaperShrinkageBiasTerm_paperTheorem1ExponentialPaperBias`,
  `paperTheorem1ExponentialBiasControlProvider`,
  `paperShrinkageBiasUpperBoundStatement_of_paperTheorem1ExponentialBiasComponent`,
  `paperShrinkageBiasUpperBoundProvider_of_paperTheorem1ExponentialBiasComponent`,
  `paperTheorem1VariancePlusExponentialBiasComponent`,
  `paperTheorem1VariancePlusExponentialPaperBias`,
  `paperShrinkageBiasTerm_paperTheorem1VariancePlusExponentialPaperBias`,
  `randomPaperShrinkageBiasTerm_paperTheorem1VariancePlusExponentialPaperBias`,
  `paperTheorem1VariancePlusExponentialBiasControlProvider`,
  `paperShrinkageBiasUpperBoundStatement_of_paperTheorem1VariancePlusExponentialBiasComponent`,
  `paperShrinkageBiasUpperBoundProvider_of_paperTheorem1VariancePlusExponentialBiasComponent`,
  `paperShrinkageBiasUpperBoundStatement_mono`,
  `paperShrinkageBiasUpperBoundProvider_mono`,
  `paperShrinkageBiasUpperBoundStatement_le_max_left`,
  `paperShrinkageBiasUpperBoundStatement_le_max_right`,
  `paperShrinkageBiasUpperBoundProvider_le_max_left`,
  `paperShrinkageBiasUpperBoundProvider_le_max_right`,
  `paperShrinkageBiasUpperBoundStatement_of_addPaperBias`,
  `paperShrinkageBiasUpperBoundProvider_of_addPaperBias`,
  `paperShrinkageBiasUpperBoundStatement_of_uniformBound`,
  `paperShrinkageBiasUpperBoundProvider_of_uniformBound`,
  `shrinkageTheorem1FinalBiasDominanceStatement_of_constantPaperBias`,
  `shrinkageTheorem1FinalBiasDominanceProvider_of_constantPaperBias`,
  `shrinkageTheorem1FinalBiasDominanceStatement_of_biasUpperBoundProvider`,
  `shrinkageTheorem1FinalBiasDominanceProvider_of_biasUpperBoundProvider`,
  `shrinkageTheorem1FinalBiasDominanceStatement_of_addPaperBiasUpperBounds`,
  `shrinkageTheorem1FinalBiasDominanceProvider_of_addPaperBiasUpperBounds`,
  `shrinkageTheorem1FinalBiasDominanceStatement_of_paperTheorem1VariancePlusExponentialBiasComponent`,
  `shrinkageTheorem1FinalBiasDominanceProvider_of_paperTheorem1VariancePlusExponentialBiasComponent`,
  `shrinkageTheorem1FinalBiasDominanceStatement_of_paperTheorem1DeltaBiasComponent`,
  `shrinkageTheorem1FinalBiasDominanceProvider_of_paperTheorem1DeltaBiasComponent`,
  `shrinkageTheorem1FinalBiasDominanceStatement_of_paperTheorem1DeltaBiasComponents`,
  `shrinkageTheorem1FinalBiasDominanceProvider_of_paperTheorem1DeltaBiasComponents`,
  `shrinkageTheorem1FinalBiasDominanceStatement_of_uniformPaperBiasBound`,
  `shrinkageTheorem1FinalBiasDominanceProvider_of_uniformPaperBiasBound`,
  `shrinkageTheorem1FinalEventSubsetComparisonProvider_of_randomPaperErrors`,
  `shrinkageTheorem1FinalEventSubsetStatement_of_randomPaperErrors`,
  `shrinkageTheorem1FinalEventSubsetComparisonProvider_of_addPaperBiasUpperBounds`,
  `shrinkageTheorem1FinalEventSubsetStatement_of_addPaperBiasUpperBounds`,
  `shrinkageTheorem1FinalEventSubsetComparisonProvider_of_paperTheorem1DeltaBiasComponents`,
  `shrinkageTheorem1FinalEventSubsetStatement_of_paperTheorem1DeltaBiasComponents`,
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors`,
  `shrinkageTheorem1TailStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_randomPaperErrors`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_randomPaperErrors`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_randomPaperErrors_error_measurable`,
  `shrinkageTheorem1TailStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_paperTheorem1DeltaBiasComponents`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_paperTheorem1DeltaBiasComponents`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_paperTheorem1DeltaBiasComponents_error_measurable`,
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_addPaperBiasUpperBounds`,
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1VariancePlusExponentialBiasComponent`,
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponent`,
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponents`,
  `shrinkageTheorem1PaperTailEvent_subset_left_of_addPaperBias_nonneg`,
  `shrinkageTheorem1PaperTailProviders_of_addPaperBias_left`,
  `shrinkageTheorem1PaperTailBound_of_addPaperBias_left`,
  `shrinkageTheorem1PaperRHSProofReadinessObligations_of_addPaperBias_left`,
  `shrinkageTheorem1PaperTailEvent_subset_right_of_addPaperBias_nonneg`,
  `shrinkageTheorem1PaperTailProviders_of_addPaperBias_right`,
  `shrinkageTheorem1PaperTailBound_of_addPaperBias_right`,
  `shrinkageTheorem1PaperRHSProofReadinessObligations_of_addPaperBias_right`,
  `shrinkageTheorem1PaperRHSProofReadinessObligations_of_paperTheorem1DeltaBias_left`,
  `shrinkageTheorem1PaperRHSProofReadinessObligations_of_paperTheorem1DeltaBias_right`,
  `shrinkageTheorem1PaperTailEvent_measurable_of_provider`,
  `shrinkageTheorem1PaperTailMeasurabilityProvider_of_measurable`,
  `paperTheorem1DeltaPaperTailEvent_measurable_of_provider`, and
  `paperTheorem1DeltaPaperTailMeasurabilityProvider_of_measurable`,
  `shrinkageTheorem1PaperTailMeasurabilityProvider_of_providers`,
  `shrinkageTheorem1PaperTailEvent_measurable_of_providers`,
  `paperTheorem1DeltaPaperTailMeasurabilityProvider_of_providers`, and
  `paperTheorem1DeltaPaperTailEvent_measurable_of_providers`,
  plus the statement-shaped tail consumer
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors_biasStatement`.
  The from-H1 random-paper-error route now has matching tail-statement and
  measurability-aware wrappers that construct the paper-RHS readiness ledger
  internally from explicit H1/lower-event/component-RHS assumptions.
  The minimal Theorem 1 provider bundle now exposes its H1/H2 fields through
  `shrinkageTheorem1Providers_h1` and `shrinkageTheorem1Providers_h2`, so
  downstream wrappers can avoid anonymous field access at the first provider
  boundary.  The paper-tail statement wrapper now also mirrors the base final-tail field
  projection surface via
  `shrinkageTheorem1PaperTailStatement_providers`,
  `shrinkageTheorem1PaperTailStatement_h1_provider`,
  `shrinkageTheorem1PaperTailStatement_h2_provider`,
  `shrinkageTheorem1PaperTailStatement_lambda_positive`,
  `shrinkageTheorem1PaperTailStatement_threshold_nonnegative`,
  `shrinkageTheorem1PaperTailStatement_tail_rhs_nonnegative`, and
  `shrinkageTheorem1PaperTailStatement_tail_bound`; the paper-tail provider
  bundle itself also exposes `shrinkageTheorem1PaperTailProviders_core`,
  `shrinkageTheorem1PaperTailProviders_rhs`,
  `shrinkageTheorem1PaperTailProviders_bias_control`, and
  `shrinkageTheorem1PaperTailProviders_measurability`.  The nested
  `ShrinkageTheorem1PaperTailRHSProvider` also has direct projections
  `shrinkageTheorem1PaperTailRHSProvider_rhs_identifies_tail` and
  `shrinkageTheorem1PaperTailRHSProvider_rhs_nonnegative`.  These are only
  direct field projections and do not add a new probability or concentration
  proof.
  These thread the same union-bound consumer and its combined-RHS probability
  provider bridge through `ShrinkageTheorem1PaperTailProviders`, then pair it
  with the paper-tail statement surface without changing the paper-tail bundle
  or proving Theorem 1.  The resolvent-probability wrapper records the
  resolvent-side probability obligation next to the paper-tail statement before
  any union-bound composition.  The direct resolvent-wrapper consumer projects
  that statement into the same H2 consumer path after adding only the explicit
  lower-event/measurability/RHS inputs.  The lower-event entry only replaces
  the lower-bad probability-provider input by the deterministic lower-event wrapper.
  The theorem-facing H2 wrapper and its resolvent-probability precursor now
  also expose their direct fields through
  `shrinkageTheorem1PaperTailWithH2ConsumerStatement_paper_tail`,
  `shrinkageTheorem1PaperTailWithH2ConsumerStatement_h2_consumer`,
  `shrinkageTheorem1PaperTailWithH2ResolventProbabilityStatement_paper_tail`,
  and
  `shrinkageTheorem1PaperTailWithH2ResolventProbabilityStatement_h2_resolvent_probability`.
  These are projection-only convenience wrappers.
  The paper-RHS resolvent consumer specializes this same path to the summed
  paper RHS produced by
  `paperH2ResolventBadEventProbabilityProvider_of_paperRHS_bounds`, using only
  the definitional lower-plus-resolvent H2 union RHS; its short alias and
  bad-event projection expose the same consumer/probability boundary without
  adding any new proof content.  The theorem-facing paper-RHS specialization
  pairs that same consumer with the existing paper-tail statement wrapper.
  The comparison provider is deliberately only pointwise algebra/API plumbing:
  it records equality of the final true/estimated error functions with the
  paper error vocabulary and domination of the paper bias by the final bias,
  exposes those fields through the three named projection theorems above, then
  derives the subset statement.  It does not prove concentration,
  determinant tails, denominator tails, lower singular-value probability, or
  Theorem 1.
  The random-paper-error specialization discharges those two equality fields by
  definitional unfolding of `randomPaperShrinkageError` and
  `randomPaperShrinkageEstimatedError`; its only remaining field is the
  pointwise bias-dominance provider.  The bias-dominance statement/projection
  layer restates that obligation as
  `randomPaperShrinkageBiasTerm X paperBias lam omega <= bias`, with provider
  round-trip wrappers only.  The bias-control constructors now also provide the
  paper-tail nonnegativity side condition from a deterministic uniform sample-level
  proof, from a nonnegative constant paper-bias slot, or by adding two already
  controlled paper-bias components.  The monotonicity wrappers state that once this
  pointwise bound is proved for `biasBase`, it also holds for any larger final
  scalar bias; the proof is just real inequality transitivity.  The constant
  paper-bias constructor and wrappers provide the deterministic special case where
  the paper-bias slot is already a scalar `c` and `c <= bias`; this is a scalar
  upper-bound consumer hook, not a proof of the paper's concrete bias formula.
  The first concrete paper formula component is now named as
  `paperTheorem1VarianceBiasComponent d n lam = 1 / (lam ^ 3 * n * d)` together
  with the sample-independent, `lambda`-dependent slot
  `paperTheorem1VariancePaperBias`.  Its current API proves only deterministic
  evaluation, nonnegativity under `0 < lam`, `0 < n`, and `0 < d`, and thin
  bias-control / scalar-upper-bound provider wrappers; it does not prove the
  full `Delta_X(lambda)` formula or any concentration estimate.
  The second concrete paper formula component is
  `paperTheorem1ExponentialBiasComponent n C2 cX = C2 * exp (-(cX * n))`,
  packaged as `paperTheorem1ExponentialPaperBias`.  Its current API proves only
  deterministic evaluation, nonnegativity from `0 <= C2`, and matching
  bias-control / scalar-upper-bound provider wrappers; it does not prove the
  paper's exponential tail estimate or any probability bound.
  The remaining paper scalar component currently needed from the displayed
  `Delta_X(lambda)` formula is now named as
  `paperTheorem1DeterministicEquivalentBiasComponent d n C1 sigmaX sigmaOp lambdaMinSigma eta`,
  representing the deterministic-equivalent-shaped term
  `C1 * sigmaX ^ 2 * sqrt d * sigmaOp ^ 3 / (n * lambdaMinSigma * eta ^ 6)`,
  and is packaged as `paperTheorem1DeterministicEquivalentPaperBias`.  Its API
  proves only deterministic evaluation, nonnegativity from nonnegative `C1`,
  `sigmaOp`, and `lambdaMinSigma`, plus scalar upper-bound/provider plumbing;
  it does not prove the spectral deterministic-equivalent estimate,
  concentration, or Theorem 1.
  The full displayed three-term scalar vocabulary is named as
  `paperTheorem1DeltaBiasComponent d n lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX`
  and packaged as `paperTheorem1DeltaPaperBias` by adding the
  deterministic-equivalent slot to the variance-plus-exponential slot.  Its
  API proves only deterministic evaluation, additive nonnegativity/provider
  plumbing, scalar upper-bound wrappers under either one explicit full-Delta
  comparison or three separately supplied component comparisons plus a sum
  comparison, theorem-facing final-bias dominance and final-event subset wrappers
  for the three-component consumer, tail-statement wrappers that consume either
  one explicit full-Delta comparison or three separately supplied component
  comparisons plus a sum comparison, and left/right
  proof-readiness wrappers that build the full `Delta_X(lambda)` ledger from
  either component ledger plus the opposite component's bias-control provider and
  explicitly supplied full-Delta tail-event measurability.  The generic and
  full-Delta paper-tail measurability projection/constructor wrappers only
  expose or package a supplied `MeasurableSet`, including the direct
  `shrinkageTheorem1PaperTailMeasurabilityProvider_tail_event_measurable`
  field projection; the matching bundle-level projections expose the same field
  from `ShrinkageTheorem1PaperTailProviders`.
  They do not prove primitive measurability, any component upper bound, spectral
  estimate, concentration, or Theorem 1.
  The partial variance-plus-exponential envelope remains named as
  `paperTheorem1VariancePlusExponentialBiasComponent d n lam C2 cX` and
  packaged through `paperTheorem1VariancePlusExponentialPaperBias` using the
  existing `addPaperShrinkageBias` vocabulary.  Its provider wrappers only
  compose deterministic evaluation, nonnegativity, and scalar upper-bound APIs;
  it remains a reusable partial envelope and does not compose in probability or
  Theorem 1.  The theorem-facing final-bias wrappers for this
  partial envelope consume only an explicit scalar comparison
  `paperTheorem1VariancePlusExponentialBiasComponent ... <= bias`, routing it
  through the existing scalar upper-bound provider into
  `ShrinkageTheorem1FinalBiasDominanceStatement` /
  `ShrinkageTheorem1FinalBiasDominanceProvider`.  The theorem-facing tail
  consumer
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1VariancePlusExponentialBiasComponent`
  combines that deterministic final-bias provider with an already supplied
  `ShrinkageTheorem1PaperRHSProofReadinessObligations` ledger for the same
  partial paper-bias slot; it proves no new paper-tail probability,
  concentration estimate, or Theorem 1.
  The separate `PaperShrinkageBiasUpperBoundStatement` /
  `PaperShrinkageBiasUpperBoundProvider` pair isolates the general base
  obligation `randomPaperShrinkageBiasTerm <= biasBound`, exposes statement /
  provider round trips, and composes it with `biasBound <= bias` to feed the
  final-bias dominance layer.  Its constant paper-bias wrappers prove the base
  upper-bound statement/provider when the bias slot is `constantPaperShrinkageBias c`
  and `c <= biasBound`, giving a deterministic template for later concrete
  `Delta_X(lambda)` upper-bound proofs.  The uniform-bound wrappers now lift any
  deterministic sample-level proof `forall X0, paperShrinkageBiasTerm ... X0 lam <=
  biasBound` into the random upper-bound provider and final-bias dominance route
  with a supplied `biasBound <= bias`; this is still only deterministic API
  plumbing, not the concrete formula proof.  The monotonicity, `max` weakening, and additive paper-bias wrappers let
  downstream decompositions reuse any proved scalar bound at a larger scalar,
  at either side of a `max` envelope, or as the sum of two independently
  bounded paper-bias components.  The final-bias additive wrappers consume
  those two component providers plus `(boundLeft + boundRight) <= bias` to feed
  the existing final-event comparison route; the final-event additive wrappers
  then close the random-paper-error comparison and subset-statement layer.
  The direct tail additive consumer also feeds the existing paper-RHS
  proof-readiness ledger with the additive paper-bias slot.  The additive-left
  and additive-right readiness wrappers reuse an already prepared component
  paper-tail route for `addPaperShrinkageBias biasLeft biasRight` when the
  opposite component has paper-tail nonnegativity control and the additive
  tail-event measurability is supplied; the full-Delta left/right wrappers are
  just these additive wrappers specialized to DeterministicEquivalent plus
  VariancePlusExponential.  The only probability step is `measure_mono` over the
  deterministic event inclusion.
  The proof-readiness ledger bundles exactly those remaining supplied obligations
  before this consumer step; it proves none of them.  The paper-RHS ledger
  version replaces the explicit resolvent-probability-provider obligation by
  the supplied shifted-determinant and Woodbury-denominator paper-RHS component
  bounds, then projects through the theorem-facing paper-RHS wrapper.  Its
  consumer and bad-event probability projections are field conveniences over
  that wrapper.  The final-bridge ledger keeps the already prepared paper-RHS
  route separate from the still-missing analytic bridge by making the final
  `shrinkageTheorem1TailEvent` bound an explicit field.  The final tail-event
  measurability shell now adds
  `ShrinkageTheorem1FinalTailMeasurabilityProvider`,
  `shrinkageTheorem1FinalTailMeasurabilityProvider_final_tail_event_measurable`,
  `shrinkageTheorem1TailEvent_measurable_of_provider`,
  `shrinkageTheorem1FinalTailMeasurabilityProvider_of_measurable`,
  `shrinkageTheorem1TailEvent_measurable_of_error_measurable`, and
  `shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable`,
  packaging either an explicit `MeasurableSet` or measurable true/estimated
  error functions. The theorem-facing final-tail consumer surface now also has
  `ShrinkageTheorem1TailWithMeasurabilityStatement`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_finalMeasurability`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_error_measurable`,
  `shrinkageTheorem1TailWithMeasurability_tailStatement`,
  `shrinkageTheorem1TailWithMeasurability_finalTailMeasurabilityProvider`,
  `shrinkageTheorem1TailWithMeasurability_finalTailEvent_measurable`, and
  `shrinkageTheorem1TailWithMeasurability_tail_bound`, plus the convenience
  projections `shrinkageTheorem1TailWithMeasurability_providers`,
  `shrinkageTheorem1TailWithMeasurability_h1_provider`,
  `shrinkageTheorem1TailWithMeasurability_h2_provider`,
  `shrinkageTheorem1TailWithMeasurability_lambda_positive`,
  `shrinkageTheorem1TailWithMeasurability_threshold_nonnegative`, and
  `shrinkageTheorem1TailWithMeasurability_tail_rhs_nonnegative`, which package
  the already supplied final tail statement with that measurability side
  condition.
  The lower-event/from-H1 paper-RHS route now also has the direct final
  tail-statement consumer
  `shrinkageTheorem1TailStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_finalEventSubsetStatement`;
  it constructs the existing paper-RHS readiness ledger from the paper-tail H1
  provider and lower singular-value event provider, then consumes the named
  `ShrinkageTheorem1FinalEventSubsetStatement` without discharging any
  component probability bound.  The same route has bundled final-tail
  measurability consumers
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_finalEventSubsetStatement`
  and
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_finalEventSubsetStatement_error_measurable`,
  which add either an explicit final-tail measurability provider or measurable
  true/estimated error functions to that direct final-tail statement.
  The paper-RHS proof-readiness route now also has direct bundled consumers
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSFinalBridgeObligations`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSFinalBridgeObligations_error_measurable`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_eventSubset`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_eventSubset_error_measurable`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetStatement`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetStatement_error_measurable`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetComparisonProvider`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetComparisonProvider_error_measurable`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors_error_measurable`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_randomPaperErrors`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_randomPaperErrors_error_measurable`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_paperTheorem1DeltaBiasComponents`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_paperTheorem1DeltaBiasComponents_error_measurable`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors_biasStatement`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors_biasStatement_error_measurable`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_addPaperBiasUpperBounds`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_addPaperBiasUpperBounds_error_measurable`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1VariancePlusExponentialBiasComponent`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1VariancePlusExponentialBiasComponent_error_measurable`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponent`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponent_error_measurable`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponents`,
  and
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponents_error_measurable`,
  which add either an explicit final-tail measurability provider or measurable
  true/estimated error functions to the existing compact final-bridge consumer,
  the raw event-subset consumer, the final-event-subset consumer,
  its pointwise comparison-provider route, the random-paper-error specialization,
  the statement-shaped final-bias-dominance route,
  the additive paper-bias upper-bound route, the variance-plus-exponential
  partial-bias route, or the one-shot/componentwise `Delta_X(lambda)` routes.
  The direct from-H1 full-Delta route builds the paper-RHS readiness
  obligations internally from H1, the lower-event provider, component
  paper-RHS bounds, the paper-tail bound, and component bias comparisons.
  These wrappers do not prove any probability or concentration bound;
- named H2 resolvent atomic-event vocabulary:
  `paperH2ShrinkageShiftedDetUnitEvent`,
  `paperH2LeaveOneOutShiftedDetUnitEvent`,
  `paperH2WoodburyDenominatorNonzeroEvent`, and the membership bridge
  `paperH2ResolventGoodEvent_mem_iff_atomic_events`.  The complementary
  atomic-bad side is now named by `paperH2ShrinkageShiftedDetBadEvent`,
  `paperH2LeaveOneOutShiftedDetBadEvent`,
  `paperH2WoodburyDenominatorBadEvent`, their complement rewrites
  `paperH2ShrinkageShiftedDetBadEvent_eq_compl`,
  `paperH2LeaveOneOutShiftedDetBadEvent_eq_compl`,
  `paperH2WoodburyDenominatorBadEvent_eq_compl`,
  `paperH2ResolventAtomicBadUnionEvent`, and the set-level bridge
  `paperH2ResolventBadEvent_mem_imp_atomic_bad` /
  `paperH2ResolventBadEvent_subset_atomicBadUnion`.  This is only a
  propositional cover of the resolvent bad event by named atomic bad events; it
  proves no atomic probability, determinant tail, denominator tail, or
  concentration estimate;
- H2 shifted-determinant bad-event probability provider vocabulary:
  `PaperH2ShrinkageShiftedDetTailEstimateStatement`,
  `PaperH2ShrinkageShiftedDetTailEstimateProvider`,
  `paperH2ShrinkageShiftedDetTailEstimateStatement_of_provider`,
  `paperH2ShrinkageShiftedDetTailEstimateProvider_of_statement`,
  `paperH2ShrinkageShiftedDetTailEstimate_bound_of_provider`,
  `paperH2ShrinkageShiftedDetTailEstimate_rhs_nonnegative_of_provider`,
  `paperH2ShrinkageShiftedDetTailEstimateStatement_of_bound`,
  `paperH2ShrinkageShiftedDetTailEstimateProvider_of_bound`,
  `PaperH2ShrinkageShiftedDetTailPaperParameters`,
  `paperH2ShrinkageShiftedDetTailPaperRHS`,
  `paperH2ShrinkageShiftedDetTailPaperRHS_nonnegative`,
  `paperH2ShrinkageShiftedDetTailEstimateStatement_of_paperRHS_bound`,
  `paperH2ShrinkageShiftedDetTailEstimateProvider_of_paperRHS_bound`,
  `PaperH2LeaveOneOutShiftedDetPointTailEstimateStatement`,
  `PaperH2LeaveOneOutShiftedDetPointTailEstimateProvider`,
  `paperH2LeaveOneOutShiftedDetPointTailEstimateStatement_of_provider`,
  `paperH2LeaveOneOutShiftedDetPointTailEstimateProvider_of_statement`,
  `paperH2LeaveOneOutShiftedDetPointTailEstimate_bound_of_provider`,
  `paperH2LeaveOneOutShiftedDetPointTailEstimate_rhs_nonnegative_of_provider`,
  `paperH2LeaveOneOutShiftedDetPointTailEstimateStatement_of_bound`,
  `paperH2LeaveOneOutShiftedDetPointTailEstimateProvider_of_bound`,
  `PaperH2LeaveOneOutShiftedDetPointTailPaperParameters`,
  `paperH2LeaveOneOutShiftedDetPointTailPaperRHS`,
  `paperH2LeaveOneOutShiftedDetPointTailPaperRHS_nonnegative`,
  `paperH2LeaveOneOutShiftedDetPointTailEstimateStatement_of_paperRHS_bound`,
  `paperH2LeaveOneOutShiftedDetPointTailEstimateProvider_of_paperRHS_bound`,
  `paperH2ShiftedDetBadEventProbabilityStatement_of_tailEstimateProviders`,
  `paperH2ShiftedDetBadEventProbabilityProvider_of_tailEstimateProviders`,
  `paperH2ShiftedDetBadEventProbabilityStatement_of_paperRHS_bounds`,
  `paperH2ShiftedDetBadEventProbabilityProvider_of_paperRHS_bounds`,
  `PaperH2ShiftedDetBadEventProbabilityStatement`,
  `PaperH2ShiftedDetBadEventProbabilityProvider`,
  `paperH2ShiftedDetBadEventProbabilityProvider_shifted_det_bad_event_probability`,
  `paperH2ShiftedDetBadEventProbabilityStatement_of_provider`,
  `paperH2ShiftedDetBadEventProbabilityProvider_of_statement`,
  `paperH2ShrinkageShiftedDetBadEventProbability_bound_of_provider`,
  `paperH2LeaveOneOutShiftedDetBadEventProbability_bound_of_provider`, and
  `paperH2ResolventAtomicBadEventProbabilityProvider_of_shiftedDetProvider_and_denominatorBounds`.
  These expose the full and pointwise leave-one-out shifted-determinant tail
  proof targets, include explicit full and pointwise shifted-determinant
  probability-bound and RHS-nonnegativity projections plus
  bound-to-statement/provider assumption wrappers.  The leave-one-out point-tail
  full shrinkage and leave-one-out point-tail sides now each have a
  paper-parameter exponential RHS vocabulary slot and
  `_of_paperRHS_bound` wrappers for later calibration.  The named
  `_of_paperRHS_bounds` shifted-determinant wrappers combine supplied full and
  leave-one-out paper-RHS bounds into the shifted-determinant provider.  These
  repackage the shifted-determinant inputs as a separate provider, and then combine that
  provider with explicit Woodbury-denominator failure bounds; they do not prove
  determinant tails or concentration.  The shifted-determinant bad-event provider
  also exposes direct field projection
  `paperH2ShiftedDetBadEventProbabilityProvider_shifted_det_bad_event_probability`;
- H2 Woodbury-denominator bad-event probability provider vocabulary:
  `PaperH2WoodburyDenominatorPointTailEstimateStatement`,
  `PaperH2WoodburyDenominatorPointTailEstimateProvider`,
  `paperH2WoodburyDenominatorPointTailEstimateStatement_of_provider`,
  `paperH2WoodburyDenominatorPointTailEstimateProvider_of_statement`,
  `paperH2WoodburyDenominatorPointTailEstimate_bound_of_provider`,
  `paperH2WoodburyDenominatorPointTailEstimate_rhs_nonnegative_of_provider`,
  `paperH2WoodburyDenominatorPointTailEstimateStatement_of_bound`,
  `paperH2WoodburyDenominatorPointTailEstimateProvider_of_bound`,
  `PaperH2WoodburyDenominatorPointTailPaperParameters`,
  `paperH2WoodburyDenominatorPointTailPaperRHS`,
  `paperH2WoodburyDenominatorPointTailPaperRHS_nonnegative`,
  `paperH2WoodburyDenominatorPointTailEstimateStatement_of_paperRHS_bound`,
  `paperH2WoodburyDenominatorPointTailEstimateProvider_of_paperRHS_bound`,
  `paperH2WoodburyDenominatorBadEventProbabilityStatement_of_pointTailEstimateProviders`,
  `paperH2WoodburyDenominatorBadEventProbabilityProvider_of_pointTailEstimateProviders`,
  `PaperH2WoodburyDenominatorBadEventProbabilityStatement`,
  `PaperH2WoodburyDenominatorBadEventProbabilityProvider`,
  `paperH2WoodburyDenominatorBadEventProbabilityProvider_woodbury_denominator_bad_event_probability`,
  `paperH2WoodburyDenominatorBadEventProbabilityStatement_of_provider`,
  `paperH2WoodburyDenominatorBadEventProbabilityProvider_of_statement`,
  `paperH2WoodburyDenominatorBadEventProbability_bound_of_provider`, and
  `paperH2ResolventAtomicBadEventProbabilityProvider_of_shiftedDetProvider_and_denominatorProvider`.
  These expose the pointwise denominator-tail proof target, add explicit
  RHS-nonnegativity projection, bound-to-statement/provider assumption wrappers,
  and one paper-parameter exponential RHS vocabulary slot for later calibration.
  The atomic-resolvent layer also has
  `paperH2ResolventAtomicBadEventProbabilityProvider_of_paperRHS_bounds`, which
  combines supplied shifted-determinant and Woodbury-denominator paper-RHS
  bounds into the atomic resolvent provider without proving any component tail.
  They repackage a family of such pointwise providers as the
  denominator-failure component before combining it with the shifted-determinant
  provider to build the existing atomic resolvent probability provider; they do
  not prove denominator tails or concentration.  The Woodbury-denominator
  bad-event provider also exposes direct field projection
  `paperH2WoodburyDenominatorBadEventProbabilityProvider_woodbury_denominator_bad_event_probability`;
- H2 resolvent atomic bad-event probability consumer vocabulary:
  `paperH2ResolventAtomicBadEventUnionBoundRHS`,
  `paperH2ResolventAtomicBadEventUnionBoundRHS_nonnegative`,
  `PaperH2ResolventAtomicTailRHSProvider`,
  `PaperH2ResolventAtomicTailRHSProvider_shrinkage_rhs_nonnegative`,
  `PaperH2ResolventAtomicTailRHSProvider_leave_one_out_rhs_nonnegative`,
  `PaperH2ResolventAtomicTailRHSProvider_denominator_rhs_nonnegative`,
  `paperH2ResolventAtomicBadEventUnionBoundRHS_nonnegative_of_rhsProvider`,
  `PaperH2ResolventAtomicPointTailEstimateProviders`,
  `paperH2ResolventAtomicTailRHSProvider_of_pointTailEstimateProviders`,
  `paperH2ResolventAtomicBadEventProbabilityProvider_of_pointTailEstimateProviders`,
  `PaperH2ResolventAtomicBadEventProbabilityProvider`,
  `PaperH2ResolventAtomicBadEventProbabilityProvider_shrinkage_rhs_nonnegative`,
  `PaperH2ResolventAtomicBadEventProbabilityProvider_leave_one_out_rhs_nonnegative`,
  `PaperH2ResolventAtomicBadEventProbabilityProvider_denominator_rhs_nonnegative`,
  `PaperH2ResolventAtomicBadEventProbabilityProvider_shrinkage_bad_event_probability`,
  `PaperH2ResolventAtomicBadEventProbabilityProvider_leave_one_out_bad_event_probability`,
  `PaperH2ResolventAtomicBadEventProbabilityProvider_denominator_bad_event_probability`,
  `PaperH2ResolventAtomicBadEventUnionBoundStatement`,
  `PaperH2ResolventAtomicBadEventUnionBoundStatement_atomic_bad_event_probability`,
  `PaperH2ResolventAtomicBadEventUnionBoundStatement_atomic_bad_union_probability`,
  `PaperH2ResolventAtomicBadEventUnionBoundStatement_resolvent_bad_event_probability`,
  `paperH2ResolventAtomicBadUnionEventProbability_bound_of_atomicProvider`,
  `paperH2ResolventAtomicBadEventUnionBoundStatement_of_atomicProvider`,
  `paperH2ResolventAtomicBadEventUnionBound_bound_of_atomicProvider`, and
  `paperH2ResolventBadEventProbabilityProvider_of_atomicProvider`.  These
  consume explicit atomic probability hypotheses for the full shifted
  determinant failure and each leave-one-out determinant/denominator failure,
  apply finite subadditivity plus the existing atomic-bad cover, and repackage
  the result as the existing resolvent bad-event probability provider.  They do
  not prove any atomic tail estimate;
- H2 resolvent paper-RHS consumer bridge:
  `paperH2ResolventBadEventProbabilityProvider_of_paperRHS_bounds` consumes
  supplied shifted-determinant and Woodbury-denominator paper-RHS component
  bounds through
  `paperH2ResolventAtomicBadEventProbabilityProvider_of_paperRHS_bounds`, then
  reuses the existing atomic union-bound consumer to build the resolvent
  bad-event probability provider.  This is still provider/API plumbing only:
  it proves no determinant tail, denominator tail, resolvent tail,
  concentration estimate, or Theorem 1 bound;
- bundled H2 resolvent atomic measurability provider vocabulary:
  `PaperH2ResolventAtomicMeasurabilityProvider`,
  `paperH2ResolventAtomicMeasurabilityProvider_shrinkage_shifted_det_unit_measurable`,
  `paperH2ResolventAtomicMeasurabilityProvider_leave_one_out_shifted_det_unit_measurable`,
  `paperH2ResolventAtomicMeasurabilityProvider_woodbury_denominator_nonzero_measurable`,
  `paperH2ResolventGoodEvent_measurable_of_atomic_provider`,
  `paperH2ResolventGoodEventMeasurabilityProvider_of_atomic_provider`,
  `paperH2ResolventBadEvent_measurable_of_atomic_provider`, and
  `paperH2ResolventBadEventMeasurabilityProvider_of_atomic_provider`;
- scalar determinant-unit and Woodbury-denominator nonzero event bridges:
  `paperH2ShrinkageShiftedDetUnitEvent_measurable_of_det_measurable`,
  `paperH2LeaveOneOutShiftedDetUnitEvent_measurable_of_det_measurable`,
  `paperH2WoodburyDenominatorNonzeroEvent_measurable_of_denominator_measurable`,
  `paperH2ResolventAtomicMeasurabilityProvider_of_denominator_measurable`, and
  `paperH2ResolventAtomicMeasurabilityProvider_of_det_and_denominator_measurable`;
- determinant-function measurability from entrywise shifted-matrix measurability:
  `squareMatrix_det_measurable_of_entry_measurable`, plus the H2 wrapper
  `paperH2ResolventAtomicMeasurabilityProvider_of_shifted_entry_and_denominator_measurable`;
- shifted-matrix entry measurability from random-data entry measurability:
  `shrinkageShiftedMatrix_entry_measurable_of_data_entry_measurable`,
  `leaveOneOutShiftedMatrix_entry_measurable_of_data_entry_measurable`, and
  `paperH2ResolventAtomicMeasurabilityProvider_of_data_entry_and_denominator_measurable`;
- Woodbury-denominator function measurability from measurable selected data
  columns and leave-one-out resolvent entries:
  `shrinkageLeaveOneOutWoodburyDenominator_measurable_of_resolvent_entry_measurable`,
  plus the H2 wrapper
  `paperH2ResolventAtomicMeasurabilityProvider_of_data_entry_and_resolvent_entry_measurable`;
- total matrix-inverse and leave-one-out resolvent entry measurability:
  `squareMatrix_inv_entry_measurable_of_entry_measurable`,
  `leaveOneOutShrinkageResolvent_entry_measurable_of_shifted_entry_measurable`,
  `leaveOneOutShrinkageResolvent_entry_measurable_of_data_entry_measurable`, and
  the direct H2 wrapper
  `paperH2ResolventAtomicMeasurabilityProvider_of_data_entry_measurable`;
- H1 observed-data measurability projection into the H2 resolvent atomic
  provider: `data_entry_measurable_of_isRandomMatrix`,
  `data_entry_measurable_of_h1_provider`, and
  `paperH2ResolventAtomicMeasurabilityProvider_of_h1_provider`;
- H1 plus an explicit lower-singular-value good- or bad-event measurability
  provider, or directly plus the eta-only pointwise lower event provider,
  now produces resolvent/good/bad H2 event measurability providers:
  `paperH2ResolventGoodEventMeasurabilityProvider_of_h1_provider`,
  `paperH2ResolventBadEventMeasurabilityProvider_of_h1_provider`,
  `paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lower_provider`,
  `paperH2LeaveOneOutBadEventMeasurabilityProvider_of_h1_and_lower_provider`,
  `paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lowerBad_provider`,
  `paperH2LeaveOneOutBadEventMeasurabilityProvider_of_h1_and_lowerBad_provider`,
  `paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lowerEventProvider`,
  and
  `paperH2LeaveOneOutBadEventMeasurabilityProvider_of_h1_and_lowerEventProvider`;
- a resolvent primitive-measurability statement plus finite-intersection
  consumer proof: `PaperH2ResolventGoodEventPrimitiveMeasurabilityStatement`
  and `paperH2ResolventGoodEventPrimitiveMeasurability` show that named
  atomic-event measurability assumptions imply
  `MeasurableSet (paperH2ResolventGoodEvent X lam)`, while leaving the
  primitive atomic events themselves as explicit later proof obligations;
  `PaperH2ResolventGoodEventPrimitiveMeasurabilityProvider` exposes the
  matching direct field projection
  `paperH2ResolventGoodEventPrimitiveMeasurabilityProvider_primitive_measurability`;
  the atomic provider only packages those assumptions;
- H1/H2 and Theorem 1 paper-tail provider-contract vocabulary with explicit
  fields for future measurability, probability, bias, and tail-bound inputs;
- example, test, and judge consumers for the deterministic covariance
  trace-expansion route.

Non-goals for this application layer:

- It does not prove paper H1/H2 from primitive distributional assumptions,
  concentration estimates, deterministic equivalents, probability bounds,
  closed-form tail RHS formulas, primitive measurability needed to construct H1,
  lower-singular-value measurability/probability, or PrecisionDA Theorem 1.
  These remain explicit future provider or assumption surfaces.
