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
  Lieb/Jensen, Golden-Thompson, relative-entropy joint convexity, the Epstein
  sign theorem, conditional expectation, or full Matrix Bernstein unless a
  separate provider theorem proves it.

## Active PrecisionDA Application Work

- Keep `HighDimProb.Applications.PrecisionDA` as an application statement and
  deterministic algebra layer. Do not promote paper-specific objects into core
  RandomMatrix APIs unless a second consumer needs the same abstraction.
- Current deterministic event leaf: `paperH2ResolventGoodEvent`, its explicit
  alias `paperH2LeaveOneOutResolventGoodEvent`,
  `paperH2LeaveOneOutGoodEvent_mem_iff`,
  `paperH2LeaveOneOutGoodEvent_eq_inter`, and the lower/resolvent projection
  plus constructor theorems expose the H2 leave-one-out good event as the
  eta-only lower-singular-value event intersected with resolvent and Woodbury
  side conditions. The complementary preparation now names
  `paperH2ResolventBadEvent` and proves
  `paperH2LeaveOneOutBadEvent_subset_lowerBad_union_resolventBad`, a pure
  set-level bridge for later union-bound provider work. The lambda-dependent
  resolvent bad event is now further covered by the named atomic bad union
  `paperH2ResolventAtomicBadUnionEvent` through
  `paperH2ResolventBadEvent_mem_imp_atomic_bad` and
  `paperH2ResolventBadEvent_subset_atomicBadUnion`, using only the complement
  definitions for shifted determinant-unit and Woodbury-denominator nonzero
  failures. This is still propositional event algebra, not a probability or
  concentration result. The same boundary now has a probability-facing
  provider shell:
  `PaperH2ResolventAtomicBadEventProbabilityProvider` plus
  `paperH2ResolventBadEventProbabilityProvider_of_atomicProvider` consume
  explicit atomic bad-event probability hypotheses and finite subadditivity to
  produce the existing `PaperH2ResolventBadEventProbabilityProvider`; they do
  not prove the atomic hypotheses.
- Current H2 measurability provider leaf: explicit provider shells package
  `MeasurableSet` assumptions for the lower-singular-value good/bad factors,
  resolvent good/bad factors, full leave-one-out good event, and bad-event
  complement bridge. The eta-only lower bad-event provider and resolvent
  bad-event provider now have projection/complement wrappers back to their
  corresponding good-event providers. The
  pointwise eta-only lower-singular-value provider also has direct field
  projections for eta positivity, the pointwise lower good event, and the
  provider's lower-singular-value statement field, including
  `paperH2LowerSingularValueEventProvider_eta_positive`, plus deterministic
  good-event-as-univ, provider-form good-event membership,
  leave-one-out-good-event reduction to the resolvent good event via
  `paperH2LeaveOneOutGoodEvent_of_lowerEventProvider_and_resolvent` and
  `paperH2LeaveOneOutGoodEvent_eq_resolventGood_of_lowerEventProvider`,
  matching leave-one-out good/bad measurability wrappers from an explicit
  resolvent-good measurability provider,
  bad-event-as-empty, bad-event-zero-measure wrappers, and
  an eta-only lower-bad probability statement/provider that projects the
  zero-measure consequence into a nonnegative RHS bound. These shells do not
  prove primitive measurability from matrix entries, determinants, `IsUnit`,
  lower singular values, or Woodbury denominators, and the zero-measure/provider
  wrapper is only the empty-event consequence of a pointwise provider, not a
  concentration theorem or a full leave-one-out H2 probability bound. The
  lambda-dependent resolvent bad event now has a hypothesis-style probability
  statement/provider and projection theorem. The full leave-one-out bad event
  now also has a typed union-bound consumer and projection theorem combining the
  lower-bad and resolvent-bad provider inputs via the set inclusion and
  `measure_union_le`, without proving either component tail estimate. The same
  union-bound consumer is now threaded through the paper-tail provider bundle by
  thin projection wrappers, and the combined Real RHS is normalized by
  `paperH2LeaveOneOutBadEventUnionBoundRHS` plus the `realRHS` projection
  wrappers. The union-bound statement now also exposes direct projections for
  its stored lower-bad statement, resolvent-bad statement, and combined
  bad-event probability field. The named RHS provider then projects this
  lower-plus-resolvent bound back into `PaperH2LeaveOneOutGoodEventProbabilityProvider` via
  `paperH2LeaveOneOutGoodEventProbabilityProvider_of_unionBoundProbabilityProviders`.
  The pointwise H2 good-event statement/provider boundary now also exposes
  direct field projections for `eta_positive`, the pointwise good-event field,
  and the provider's `h2` statement.
  The H2 good-event probability statement itself now exposes direct field
  projections for `eta_positive`, RHS nonnegativity, and the stored bad-event
  probability inequality, so downstream proof-readiness consumers no longer
  need anonymous field access at this boundary.
  The lower component can now also start from the pointwise eta-only
  lower-singular-value event provider via
  `paperH2LeaveOneOutGoodEventProbabilityProvider_of_lowerEventProvider_and_resolventProbabilityProvider`,
  which inserts only the deterministic empty-event lower-bad wrapper and keeps
  the resolvent probability provider explicit. The lower-event route now also
  exposes direct union-bound statement/projection wrappers, including the
  combined-RHS projection, before it is repackaged into the H2 probability
  provider surface. That provider bridge is now threaded through paper-tail H2
  union-bound, probability, and consumer wrappers, including
  lower-event/resolvent-probability variants of the union-bound statement,
  union-bound projections, probability provider, consumer statement, short
  consumer alias, and bad-event probability projection, alongside the
  lower-bad/resolvent-bad inputs. The theorem-facing resolvent-probability
  wrapper `ShrinkageTheorem1PaperTailWithH2ResolventProbabilityStatement`
  records the paper-tail statement next to the explicit resolvent bad-event
  probability obligation before the lower-event union-bound composition.
  The theorem-facing wrapper `ShrinkageTheorem1PaperTailWithH2ConsumerStatement`
  now combines that H2 consumer with the existing
  `shrinkageTheorem1PaperTailStatement_of_providers` tail-bound surface, and
  has the matching lower-event/resolvent-probability entry
  `shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventProbabilityProvider`.
  The top-level `ShrinkageTheorem1ProofReadinessObligations` ledger also has
  direct named projections for all nine supplied fields (providers,
  lambda/threshold side conditions, paper-tail bound, H2 bad-event
  measurability, lower-RHS nonnegativity, union-RHS wiring, lower event
  provider, and resolvent probability provider), so downstream consumers do
  not need to unfold the structure.
  The theorem-facing H2 consumer wrapper and the resolvent-probability precursor
  now have direct paper-tail/H2 field projection wrappers, so downstream proof
  steps can consume the paired obligations without unfolding the structures.
  The minimal Theorem 1 provider bundle now has direct H1/H2 field projections
  `shrinkageTheorem1Providers_h1` and `shrinkageTheorem1Providers_h2`, and the
  paper-tail provider bundle now has direct projections for its core provider
  bundle, RHS provider, bias-control provider, and measurability provider.  The
  nested paper-tail RHS provider now also exposes direct identity and
  nonnegativity projections for downstream theorem-facing consumers.
  The paper-tail statement itself now has direct field projections for its
  provider bundle, H1/H2 providers, lambda/threshold/RHS nonnegativity, and
  explicit tail bound, matching the base final-tail projection API without
  proving any new probability estimate.
  The resolvent-probability wrapper is now also directly consumed by
  `shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_resolventProbabilityStatement_and_lowerEventProvider`,
  after `paperH2ResolventBadEventProbabilityProvider_of_statement` normalizes
  the statement/provider boundary. The H2 consumer layer now also has
  `shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_lowerEventProvider_and_resolventPaperRHSBounds`,
  which consumes the paper-RHS resolvent provider with the existing lower-event
  provider and definitional H2 union RHS, whose provider now exposes the direct
  `rhs_eq` field projection
  `paperH2LeaveOneOutBadEventUnionBoundRHSProvider_rhs_eq`, plus its short alias
  and bad-event probability projection. The theorem-facing wrapper now also has
  `shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventPaperRHSBounds`,
  which threads this paper-RHS consumer boundary into
  `ShrinkageTheorem1PaperTailWithH2ConsumerStatement` without proving
  concentration. The paper-RHS readiness layer now also has
  `ShrinkageTheorem1PaperRHSProofReadinessObligations` and
  `shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_paperRHSProofReadinessObligations`,
  which bundle the supplied paper-RHS component bounds and project into the
  same theorem-facing boundary. That paper-RHS ledger now also exposes direct
  named projections for all stored fields, including the three prefactor side
  conditions and three component-tail bound families, so later consumers do not
  need to unfold the structure. It also exposes the narrow H2 consumer and
  bad-event probability projections from that paper-RHS ledger. The compact
  final theorem-readiness surface now has
  `ShrinkageTheorem1PaperRHSFinalBridgeObligations` and
  `shrinkageTheorem1TailStatement_of_paperRHSFinalBridgeObligations`, which
  make the final `shrinkageTheorem1TailEvent` bound the explicit remaining
  analytic bridge. It also exposes projection-only accessors
  `shrinkageTheorem1PaperRHSFinalBridgeObligations_paper_rhs_readiness` and
  `shrinkageTheorem1PaperRHSFinalBridgeObligations_final_tail_bound`, so
  consumers can reuse the stored paper-RHS readiness ledger and final tail bound
  without unfolding the structure. The lower-event/from-H1 paper-RHS route now
  also has the direct final-event-subset consumer
  `shrinkageTheorem1TailStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_finalEventSubsetStatement`,
  which constructs the ledger from the paper-tail H1 provider plus lower-event
  provider and leaves all component probability bounds explicit. It now also
  has the paired bundled measurability consumers
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_finalEventSubsetStatement`
  and
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_finalEventSubsetStatement_error_measurable`.
  The final
  tail-event measurability shell now provides
  `ShrinkageTheorem1FinalTailMeasurabilityProvider`,
  `shrinkageTheorem1FinalTailMeasurabilityProvider_final_tail_event_measurable`,
  `shrinkageTheorem1TailEvent_measurable_of_provider`,
  `shrinkageTheorem1FinalTailMeasurabilityProvider_of_measurable`,
  `shrinkageTheorem1TailEvent_measurable_of_error_measurable`, and
  `shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable`,
  consuming only an explicit `MeasurableSet` or measurable true/estimated error
  functions. The final tail statement can now be paired with this side
  condition by `ShrinkageTheorem1TailWithMeasurabilityStatement` and its
  projection/constructor wrappers:
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_finalMeasurability`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_error_measurable`,
  `shrinkageTheorem1TailWithMeasurability_tailStatement`,
  `shrinkageTheorem1TailWithMeasurability_finalTailMeasurabilityProvider`,
  `shrinkageTheorem1TailWithMeasurability_finalTailEvent_measurable`, and
  `shrinkageTheorem1TailWithMeasurability_tail_bound`, with convenience
  projections for providers, lambda positivity, threshold nonnegativity, and
  tail-RHS nonnegativity. The paper-RHS
  proof-readiness route can now produce this bundled final-tail/measurability
  statement directly via
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSFinalBridgeObligations` /
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSFinalBridgeObligations_error_measurable`,
  the raw event-subset variants
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_eventSubset` /
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_eventSubset_error_measurable`,
  the named final-event-subset variants
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetStatement`,
  its measurable-errors variant
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetStatement_error_measurable`,
  the pointwise-comparison-provider variants
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetComparisonProvider` /
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetComparisonProvider_error_measurable`,
  the random-paper-error variants
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors` /
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors_error_measurable`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_randomPaperErrors` /
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_randomPaperErrors_error_measurable`,
  `shrinkageTheorem1TailStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_paperTheorem1DeltaBiasComponents`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_paperTheorem1DeltaBiasComponents`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_paperTheorem1DeltaBiasComponents_error_measurable`,
  the statement-shaped final-bias-dominance variants
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors_biasStatement` /
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors_biasStatement_error_measurable`,
  the additive paper-bias upper-bound variants
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_addPaperBiasUpperBounds` /
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_addPaperBiasUpperBounds_error_measurable`,
  the variance-plus-exponential partial-bias variants
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1VariancePlusExponentialBiasComponent` /
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1VariancePlusExponentialBiasComponent_error_measurable`,
  and the one-shot/componentwise `Delta_X(lambda)` variants
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponent`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponent_error_measurable`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponents`, and
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponents_error_measurable`.
  Next safe work is still deterministic/measurability bridge preparation; do
  not claim component tails or probability estimates.
- Current H2 primitive-measurability preparation: the resolvent route now has
  named atomic events `paperH2ShrinkageShiftedDetUnitEvent`,
  `paperH2LeaveOneOutShiftedDetUnitEvent`,
  `paperH2WoodburyDenominatorNonzeroEvent`, the membership bridge
  `paperH2ResolventGoodEvent_mem_iff_atomic_events`,
  `PaperH2ResolventGoodEventPrimitiveMeasurabilityStatement`, the finite
  intersection proof `paperH2ResolventGoodEventPrimitiveMeasurability`, the
  primitive provider direct field projection
  `paperH2ResolventGoodEventPrimitiveMeasurabilityProvider_primitive_measurability`,
  the
  bundled `PaperH2ResolventAtomicMeasurabilityProvider` with direct field
  projections
  `paperH2ResolventAtomicMeasurabilityProvider_shrinkage_shifted_det_unit_measurable`,
  `paperH2ResolventAtomicMeasurabilityProvider_leave_one_out_shifted_det_unit_measurable`,
  and
  `paperH2ResolventAtomicMeasurabilityProvider_woodbury_denominator_nonzero_measurable`,
  the scalar determinant-unit event bridges from determinant-function
  measurability, the scalar Woodbury-denominator nonzero event bridge from
  denominator-function measurability, atomic-event consumer/provider bridges,
  and the determinant bridge `squareMatrix_det_measurable_of_entry_measurable` with the H2 wrapper
  `paperH2ResolventAtomicMeasurabilityProvider_of_shifted_entry_and_denominator_measurable`.
  It also has shifted-entry measurability from random-data entry measurability:
  `shrinkageShiftedMatrix_entry_measurable_of_data_entry_measurable`,
  `leaveOneOutShiftedMatrix_entry_measurable_of_data_entry_measurable`, and
  `paperH2ResolventAtomicMeasurabilityProvider_of_data_entry_and_denominator_measurable`.
  It now discharges Woodbury denominator-function measurability from selected
  data-column measurability and leave-one-out resolvent-entry measurability via
  `shrinkageLeaveOneOutWoodburyDenominator_measurable_of_resolvent_entry_measurable`
  and
  `paperH2ResolventAtomicMeasurabilityProvider_of_data_entry_and_resolvent_entry_measurable`.
  It also discharges total inverse/resolvent-entry measurability from matrix-entry
  measurability via `squareMatrix_inv_entry_measurable_of_entry_measurable`,
  `leaveOneOutShrinkageResolvent_entry_measurable_of_shifted_entry_measurable`,
  `leaveOneOutShrinkageResolvent_entry_measurable_of_data_entry_measurable`, and
  `paperH2ResolventAtomicMeasurabilityProvider_of_data_entry_measurable`.
  Finally, H1 observed-data random-matrix measurability now projects into the
  same H2 atomic provider via `data_entry_measurable_of_isRandomMatrix`,
  `data_entry_measurable_of_h1_provider`, and
  `paperH2ResolventAtomicMeasurabilityProvider_of_h1_provider`.
  The early H2 measurability provider shells now also expose direct field
  projections for lower good/bad, resolvent good/bad, and leave-one-out good/bad
  events, so consumers can avoid unfolding the provider records.  H1 plus an
  explicit lower-singular-value good- or bad-event measurability provider now
  produces the resolvent/good/bad H2 event measurability providers via
  `paperH2ResolventGoodEventMeasurabilityProvider_of_h1_provider`,
  `paperH2ResolventBadEventMeasurabilityProvider_of_h1_provider`,
  `paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lower_provider`,
  `paperH2LeaveOneOutBadEventMeasurabilityProvider_of_h1_and_lower_provider`,
  `paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lowerBad_provider`,
  and
  `paperH2LeaveOneOutBadEventMeasurabilityProvider_of_h1_and_lowerBad_provider`.
  H1 plus the eta-only pointwise lower event provider can now also bypass the
  explicit lower-measurability provider argument via
  `paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lowerEventProvider`
  and
  `paperH2LeaveOneOutBadEventMeasurabilityProvider_of_h1_and_lowerEventProvider`.
  The eta-only pointwise lower provider now also directly constructs the lower
  good/bad measurability providers via
  `paperH2LowerSingularValueGoodEvent_measurable_of_statement`,
  `paperH2LowerSingularValueBadEvent_measurable_of_statement`,
  `paperH2LowerSingularValueGoodEventMeasurabilityProvider_of_eventProvider`,
  and
  `paperH2LowerSingularValueBadEventMeasurabilityProvider_of_eventProvider`;
  these are only `Set.univ` / `∅` consequences of the pointwise statement, not
  primitive lower-singular-value measurability.  The same provider now also
  gives the deterministic set-level reduction of
  `paperH2LeaveOneOutGoodEvent` to `paperH2ResolventGoodEvent` through
  `paperH2LeaveOneOutGoodEvent_of_lowerEventProvider_and_resolvent` and
  `paperH2LeaveOneOutGoodEvent_eq_resolventGood_of_lowerEventProvider`,
  plus the corresponding
  `paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_lowerEventProvider_and_resolventProvider`
  and
  `paperH2LeaveOneOutBadEventMeasurabilityProvider_of_lowerEventProvider_and_resolventProvider`,
  leaving the resolvent proof obligations explicit.
- PrecisionDA proof-readiness ledger at the current boundary:
  - deterministic and provider plumbing already has named entry points for the
    Frobenius/trace expansion, leave-one-out covariance update, Woodbury RHS,
    H2 event factorization, H2 measurability shells, H2 lower-plus-resolvent
    union bound with direct statement/lower-provider/probability provider/consumer field projections,
    including direct lower-bad/resolvent-bad, shifted-det/Woodbury-denominator,
    and atomic resolvent RHS/probability-provider/union-statement field projections,
    theorem-facing paper-tail/H2 consumer wrappers, and the
    typed `ShrinkageTheorem1ProofReadinessObligations` ledger;
  - remaining non-provider obligations before a real theorem proof are:
    construct or assume a usable `PaperH2LowerSingularValueEventProvider`
    from the paper's lower singular-value route, prove a real
    `PaperH2ResolventBadEventProbabilityStatement` for the lambda-dependent
    resolvent bad event by proving the atomic bad-component estimates consumed
    by `PaperH2ResolventAtomicBadEventProbabilityProvider`, and prove the
    actual paper-tail bound supplied as `paperTailBound` to
    `shrinkageTheorem1PaperTailStatement_of_providers`;
  - after those obligations are available, the current Lean API can consume
    them through either
    `shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_proofReadinessObligations`
    after building the ledger directly, through
    `shrinkageTheorem1ProofReadinessObligations_of_lowerEventProvider` /
    `shrinkageTheorem1PaperRHSProofReadinessObligations_of_lowerEventProvider`
    when H1 and the lower singular-value event provider are already available,
    or directly through
    `shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventProbabilityProvider_fromH1` /
    `shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1`,
    or the unbundled bridge
    `shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_resolventProbabilityStatement_and_lowerEventProvider`
    without introducing a new Theorem 1 provider bundle.
- Next PrecisionDA task: continue the genuine atomic-component proof-prep route.
  The shifted-determinant and Woodbury-denominator sides now both have
  point-tail statement/provider layers, family-to-provider bridges, a named
  atomic RHS provider bundle, and a bundled point-tail-to-atomic-provider
  bridge.  The full shrinkage shifted-determinant tail now also has explicit
  bound-to-statement and bound-to-provider assumption wrappers, and the
  leave-one-out shifted-determinant and Woodbury-denominator point-tail sides
  have the analogous wrappers. All three tail-provider layers now also expose
  named `rhs_nonnegative_of_provider` projection theorems. The proof-readiness
  ledger for the remaining non-provider obligations is now typed in Lean. The
  Woodbury-denominator point-tail side now has the first paper-parameter
  closed-form exponential RHS vocabulary and `_of_paperRHS_bound` wrappers.
  The leave-one-out shifted-determinant point-tail side now has the analogous
  paper-parameter RHS vocabulary and `_of_paperRHS_bound` wrappers, and the
  full shrinkage shifted-determinant tail side now has the analogous
  paper-parameter RHS vocabulary and `_of_paperRHS_bound` wrappers. The
  shifted-determinant layer now also has `_of_paperRHS_bounds` statement/provider
  wrappers that assemble separately supplied full and leave-one-out paper-RHS
  bounds into the shifted-determinant provider. The atomic-resolvent layer now
  has the analogous `_of_paperRHS_bounds` provider wrapper combining this
  shifted-det paper provider with the existing Woodbury-denominator paper-RHS
  point-tail provider, plus
  `paperH2ResolventBadEventProbabilityProvider_of_paperRHS_bounds`, which
  consumes that atomic provider through the existing union-bound bridge. The H2
  consumer statement layer now has the matching lower-event + resolvent
  paper-RHS wrapper plus short alias/probability projection, a theorem-facing
  consumer wrapper that consumes it, and a paper-RHS proof-readiness ledger
  projection plus consumer/probability field conveniences, a compact final
  theorem-readiness bridge ledger, the typed final-event subset target
  `ShrinkageTheorem1FinalEventSubsetStatement`, pure monotonicity bridges
  `shrinkageTheorem1TailBound_of_eventSubset_paperTailBound` /
  `shrinkageTheorem1TailBound_of_finalEventSubsetStatement`, and subset-driven
  wrappers/consumers
  `shrinkageTheorem1PaperRHSFinalBridgeObligations_of_eventSubset`,
  `shrinkageTheorem1PaperRHSFinalBridgeObligations_of_finalEventSubsetStatement`,
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_eventSubset`,
  and
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetStatement`,
  plus the pointwise comparison provider
  `ShrinkageTheorem1FinalEventSubsetComparisonProvider`, projection-only
  accessors
  `shrinkageTheorem1FinalEventSubsetComparisonProvider_true_error_eq`,
  `shrinkageTheorem1FinalEventSubsetComparisonProvider_estimated_error_eq`, and
  `shrinkageTheorem1FinalEventSubsetComparisonProvider_paper_bias_le_final_bias`,
  subset theorem
  `shrinkageTheorem1FinalEventSubsetStatement_of_comparisonProvider`, and final
  consumer
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetComparisonProvider`,
  plus the random-paper-error specialization
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
  `paperTheorem1ExponentialBiasComponent`,
  `paperTheorem1ExponentialPaperBias`,
  `paperTheorem1ExponentialBiasComponent_nonnegative`,
  `paperTheorem1DeterministicEquivalentBiasComponent`,
  `paperTheorem1DeterministicEquivalentPaperBias`,
  `paperTheorem1DeterministicEquivalentBiasComponent_nonnegative`,
  `paperTheorem1DeltaBiasComponent`,
  `paperTheorem1DeltaPaperBias`,
  `paperTheorem1VariancePlusExponentialBiasComponent`,
  `paperTheorem1VariancePlusExponentialPaperBias`,
  `paperShrinkageBiasTerm_constant`,
  `paperShrinkageBiasTerm_paperTheorem1VariancePaperBias`,
  `paperShrinkageBiasTerm_paperTheorem1ExponentialPaperBias`,
  `paperShrinkageBiasTerm_paperTheorem1DeterministicEquivalentPaperBias`,
  `paperShrinkageBiasTerm_paperTheorem1DeltaPaperBias`,
  `paperShrinkageBiasTerm_paperTheorem1VariancePlusExponentialPaperBias`,
  `randomPaperShrinkageBiasTerm_constant`,
  `randomPaperShrinkageBiasTerm_paperTheorem1VariancePaperBias`,
  `randomPaperShrinkageBiasTerm_paperTheorem1ExponentialPaperBias`,
  `randomPaperShrinkageBiasTerm_paperTheorem1DeterministicEquivalentPaperBias`,
  `randomPaperShrinkageBiasTerm_paperTheorem1DeltaPaperBias`,
  `randomPaperShrinkageBiasTerm_paperTheorem1VariancePlusExponentialPaperBias`,
  `addPaperShrinkageBias`,
  `paperShrinkageBiasTerm_add`,
  `randomPaperShrinkageBiasTerm_add`,
  `paperTheorem1VarianceBiasControlProvider`,
  `paperTheorem1ExponentialBiasControlProvider`,
  `paperTheorem1DeterministicEquivalentBiasControlProvider`,
  `paperTheorem1DeltaBiasControlProvider`,
  `paperTheorem1VariancePlusExponentialBiasControlProvider`,
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
  `paperShrinkageBiasUpperBoundStatement_of_paperTheorem1ExponentialBiasComponent`,
  `paperShrinkageBiasUpperBoundProvider_of_paperTheorem1ExponentialBiasComponent`,
  `paperShrinkageBiasUpperBoundStatement_of_paperTheorem1DeterministicEquivalentBiasComponent`,
  `paperShrinkageBiasUpperBoundProvider_of_paperTheorem1DeterministicEquivalentBiasComponent`,
  `paperShrinkageBiasUpperBoundStatement_of_paperTheorem1DeltaBiasComponent`,
  `paperShrinkageBiasUpperBoundProvider_of_paperTheorem1DeltaBiasComponent`,
  `paperShrinkageBiasUpperBoundStatement_of_paperTheorem1DeltaBiasComponents`,
  `paperShrinkageBiasUpperBoundProvider_of_paperTheorem1DeltaBiasComponents`,
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
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_addPaperBiasUpperBounds`,
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1VariancePlusExponentialBiasComponent`,
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponent`,
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponents`,
  `shrinkageTheorem1TailStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_paperTheorem1DeltaBiasComponents`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_paperTheorem1DeltaBiasComponents`,
  `shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_paperTheorem1DeltaBiasComponents_error_measurable`,
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
  `shrinkageTheorem1PaperTailMeasurabilityProvider_tail_event_measurable`,
  `shrinkageTheorem1PaperTailMeasurabilityProvider_of_measurable`,
  `paperTheorem1DeltaPaperTailEvent_measurable_of_provider`, and
  `paperTheorem1DeltaPaperTailMeasurabilityProvider_of_measurable`,
  `shrinkageTheorem1PaperTailMeasurabilityProvider_of_providers`,
  `shrinkageTheorem1PaperTailEvent_measurable_of_providers`,
  `paperTheorem1DeltaPaperTailMeasurabilityProvider_of_providers`, and
  `paperTheorem1DeltaPaperTailEvent_measurable_of_providers`,
  plus the statement-shaped consumer
  `shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors_biasStatement`;
  the constant paper-bias scalar-upper-bound wrappers now cover the special
  case `c <= bias`, and the scalar upper-bound statement/provider pair
  separates the base `paperBias <= biasBound` obligation from the final
  comparison `biasBound <= bias`; the constant paper-bias upper-bound wrappers
  now cover the definitional template case, and the monotonicity / `max` /
  additive wrappers support larger scalar envelopes and sums of independently
  bounded components, with final-bias and final-event wrappers consuming the
  summed bound once `(boundLeft + boundRight) <= bias` is supplied, including the
  direct tail-statement consumer from the paper-RHS proof-readiness ledger, the
  direct from-H1 random-paper-error tail/measurability consumers that build that
  ledger internally from explicit provider assumptions, and
  the additive-left/right readiness reuse wrappers from one component paper-tail
  route plus opposite-component nonnegativity and additive tail measurability.
  The uniform deterministic bound wrappers now consume a sample-level proof
  `forall X0, paperShrinkageBiasTerm ... X0 lam <= biasBound` and lift it into
  the random upper-bound/final-bias route.  Bias-control constructors now also
  discharge the paper-tail nonnegativity side condition from uniform nonnegativity,
  nonnegative constant paper-bias slots, additive composition of controlled
  components, the concrete variance component
  `1 / (lam ^ 3 * n * d)` under positive `lam`, `n`, and `d`, the concrete
  exponential component `C2 * exp (-(cX * n))` under `0 <= C2`, the displayed
  deterministic-equivalent scalar component
  `C1 * sigmaX ^ 2 * sqrt d * sigmaOp ^ 3 / (n * lambdaMinSigma * eta ^ 6)`
  under nonnegative `C1`, `sigmaOp`, and `lambdaMinSigma`, or the
  variance-plus-exponential deterministic additive partial envelope, or the full
  displayed `Delta_X(lambda)` paper-bias slot obtained by adding the
  deterministic-equivalent component to that partial envelope, including
  deterministic evaluation, nonnegativity, scalar upper-bound wrappers,
  a three-component upper-bound consumer, final-bias dominance and final-event
  subset wrappers from that consumer, tail-statement wrappers under an already
  supplied paper-RHS proof-readiness ledger or the lower-event/from-H1
  paper-RHS ledger constructor, including direct consumption of the
  three-component upper-bound consumer, left/right full-Delta proof-readiness
  wrappers from component ledgers plus additive measurability/nonnegativity
  providers, and generic plus full-Delta paper-tail measurability
  projection/constructor wrappers. The safest next targets are deterministic
  bridges that only repackage already supplied providers or primitive-measurability
  statement shells with explicit assumptions;
  do not prove or claim concentration, determinant tails, denominator tails,
  lower singular-value probability, primitive H1 construction, the
  deterministic-equivalent spectral estimate, concrete component upper bounds,
  or Theorem 1 without separate proofs.

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

- `ShrinkageTheorem1TailWithMeasurabilityStatement` exposes direct H1/H2 provider projections via `shrinkageTheorem1TailWithMeasurability_h1_provider` and `shrinkageTheorem1TailWithMeasurability_h2_provider`; this is API convenience only, not a probability proof.

- `ShrinkageTheorem1TailStatement` now has the same named projection convenience surface for theorem providers, H1/H2 providers, lambda positivity, threshold nonnegativity, tail-RHS nonnegativity, and the tail bound.
