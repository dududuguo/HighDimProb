# Status

Current version target: `v0.1-alpha`

This file is intentionally short. Old stage notes were collapsed into
[`archive.md`](archive.md); use git history for exact old wording. Detailed API
surfaces are tracked in the focused reference docs linked below.

## Current Focus

- Active branch: RandomMatrix / Matrix Bernstein experimental API.
- Active process/random-object API leaf: small `RandomFamily` vocabulary for process and sample surfaces.
- Stable import surface: [`HighDimProb`](../HighDimProb.lean).
- Experimental import surface: [`HighDimProb.Experimental`](../HighDimProb/Experimental.lean) and [`HighDimProb.Examples`](../HighDimProb/Examples.lean).
- Main active RandomMatrix files:
  [`TraceExp.lean`](../HighDimProb/RandomMatrix/TraceExp.lean),
  [`HardboneStatements.lean`](../HighDimProb/RandomMatrix/HardboneStatements.lean), and
  [`ConcentrationStatements.lean`](../HighDimProb/RandomMatrix/ConcentrationStatements.lean).

## Active API Pointers

- API overview: [`APIOverview.md`](APIOverview.md)
- RandomMatrix API index: [`RandomMatrixAPI.md`](RandomMatrixAPI.md)
- Term map / symbol index: [`TermMap.md`](TermMap.md)
- Theorem atlas: [`TheoremAtlas.md`](TheoremAtlas.md)
- Test plan: [`TestPlan.md`](TestPlan.md)
- Judge system: [`JudgeSystem.md`](JudgeSystem.md)
- Workflow: [`Workflow.md`](Workflow.md)

## Current PrecisionDA Application Entry Names

PrecisionDA application scaffolding is isolated under
`HighDimProb.Applications.PrecisionDA` and is intentionally application-facing.
Current stable entry points include deterministic column-sample covariance,
leave-one-out covariance, shrinkage resolvents, rank-one/Woodbury identities,
Frobenius trace-expansion wrappers, and explicit provider contracts for the H1,
H2, and Theorem 1 paper-tail statement boundaries. The H2 leave-one-out event
now has a deterministic factorization into the eta-only lower-singular-value
core and lambda-dependent resolvent/Woodbury side conditions. The complementary
event side now has `paperH2ResolventBadEvent` and the set-level bridge
`paperH2LeaveOneOutBadEvent_subset_lowerBad_union_resolventBad`, which prepares
a later union-bound consumer without proving a probability inequality. The
resolvent side now also names the shifted determinant-unit and Woodbury
denominator failures, packages them as `paperH2ResolventAtomicBadUnionEvent`,
and proves `paperH2ResolventBadEvent_subset_atomicBadUnion` as a pure
propositional cover for later atomic probability providers. It now also has
`PaperH2ShrinkageShiftedDetTailEstimateProvider`,
`PaperH2LeaveOneOutShiftedDetPointTailEstimateProvider`,
`PaperH2ShiftedDetBadEventProbabilityProvider`, and
`PaperH2WoodburyDenominatorPointTailEstimateProvider`,
`PaperH2WoodburyDenominatorBadEventProbabilityProvider`, plus the bridge theorems
`paperH2ShiftedDetBadEventProbabilityProvider_of_tailEstimateProviders`,
`paperH2WoodburyDenominatorBadEventProbabilityProvider_of_pointTailEstimateProviders`,
`paperH2ResolventAtomicBadEventProbabilityProvider_of_shiftedDetProvider_and_denominatorBounds`
and
`paperH2ResolventAtomicBadEventProbabilityProvider_of_shiftedDetProvider_and_denominatorProvider`,
which split the full/pointwise shifted determinant failure hypotheses from
pointwise Woodbury-denominator failure hypotheses and then reassemble them into
the atomic resolvent provider.
The Woodbury-denominator point-tail side now also has explicit
bound-to-statement/provider assumption wrappers, matching the shifted-determinant
point-tail vocabulary without proving denominator tails.
It also has a named paper-parameter exponential RHS vocabulary:
`PaperH2WoodburyDenominatorPointTailPaperParameters`,
`paperH2WoodburyDenominatorPointTailPaperRHS`,
`paperH2WoodburyDenominatorPointTailPaperRHS_nonnegative`, and the two
`_of_paperRHS_bound` wrappers, still only consuming a supplied probability
bound.
`PaperH2ResolventAtomicTailRHSProvider`,
`paperH2ResolventAtomicBadEventUnionBoundRHS_nonnegative_of_rhsProvider`,
`PaperH2ResolventAtomicPointTailEstimateProviders`,
`paperH2ResolventAtomicTailRHSProvider_of_pointTailEstimateProviders`, and
`paperH2ResolventAtomicBadEventProbabilityProvider_of_pointTailEstimateProviders`
now provide the paper-parameter RHS vocabulary and bundled point-tail provider
bridge into the same atomic resolvent provider without proving the pointwise
tails.
The full shrinkage shifted-determinant tail side also has explicit
`paperH2ShrinkageShiftedDetTailEstimateStatement_of_bound` and
`paperH2ShrinkageShiftedDetTailEstimateProvider_of_bound` assumption wrappers,
which turn a supplied nonnegative RHS and bad-event probability inequality into
the corresponding typed statement/provider without proving a determinant tail.
It also has a named paper-parameter exponential RHS vocabulary:
`PaperH2ShrinkageShiftedDetTailPaperParameters`,
`paperH2ShrinkageShiftedDetTailPaperRHS`,
`paperH2ShrinkageShiftedDetTailPaperRHS_nonnegative`, and the two
`_of_paperRHS_bound` wrappers, still only consuming a supplied probability
bound.
The leave-one-out shifted-determinant point-tail side has the analogous
`paperH2LeaveOneOutShiftedDetPointTailEstimateStatement_of_bound` and
`paperH2LeaveOneOutShiftedDetPointTailEstimateProvider_of_bound` wrappers.
It also has a named paper-parameter exponential RHS vocabulary:
`PaperH2LeaveOneOutShiftedDetPointTailPaperParameters`,
`paperH2LeaveOneOutShiftedDetPointTailPaperRHS`,
`paperH2LeaveOneOutShiftedDetPointTailPaperRHS_nonnegative`, and the two
`_of_paperRHS_bound` wrappers, still only consuming a supplied probability
bound.
The shifted-determinant layer now also has
`paperH2ShiftedDetBadEventProbabilityStatement_of_paperRHS_bounds` and
`paperH2ShiftedDetBadEventProbabilityProvider_of_paperRHS_bounds`, which only
assemble supplied full and leave-one-out paper-RHS bounds into the existing
shifted-determinant provider.
The atomic-resolvent layer now also has
`paperH2ResolventAtomicBadEventProbabilityProvider_of_paperRHS_bounds`, which
combines supplied shifted-determinant paper-RHS bounds with supplied
Woodbury-denominator paper-RHS bounds into the existing atomic resolvent
provider.
`paperH2ResolventBadEventProbabilityProvider_of_paperRHS_bounds` then consumes
that paper-RHS atomic provider through the existing union-bound bridge to expose
the resolvent bad-event probability provider with the summed paper RHS, still
without proving any component tail or concentration estimate.
The full shrinkage shifted-determinant, leave-one-out shifted-determinant, and
Woodbury-denominator point-tail providers now also expose named
`rhs_nonnegative_of_provider` projections, so later consumer code need not reach
through provider fields directly.
`PaperH2ResolventAtomicBadEventProbabilityProvider` and
`paperH2ResolventBadEventProbabilityProvider_of_atomicProvider` then consume
explicit atomic probability hypotheses and finite subadditivity to produce the
existing resolvent bad-event probability provider without proving those atomic
tails. It also
has explicit measurability provider shells for the lower-singular-value good/bad factors,
resolvent good/bad factors, full good event, and bad-event complement bridge. The
eta-only lower bad-event shell and lambda-dependent resolvent bad-event shell are
connected back to their good-event shells by complement wrappers around
`paperH2LowerSingularValueBadEvent_eq_compl` and
`paperH2ResolventBadEvent_eq_compl`.
The minimal Theorem 1 provider bundle now also has direct H1/H2 projection
wrappers `shrinkageTheorem1Providers_h1` and `shrinkageTheorem1Providers_h2`,
so downstream proof-readiness consumers can avoid unfolding the bundle.  The
paper-tail provider bundle now mirrors this with direct projections for its
core provider bundle, RHS provider, bias-control provider, and measurability
provider.  The nested paper-tail RHS provider now likewise exposes direct
identity and nonnegativity projections, so downstream theorem wrappers can use
the named RHS facts without unfolding provider fields.
The pointwise eta-only lower-singular-value statement/provider now also yields
direct projections for eta positivity, the pointwise lower good event, and the
provider's lower-singular-value statement field, plus
`paperH2LowerSingularValueEventProvider_eta_positive`,
`paperH2LowerSingularValueGoodEvent_eq_univ_of_statement`,
`paperH2LowerSingularValueGoodEvent_eq_univ_of_eventProvider`,
`paperH2LowerSingularValueGoodEvent_mem_of_eventProvider`,
`paperH2LeaveOneOutGoodEvent_of_lowerEventProvider_and_resolvent`,
`paperH2LeaveOneOutGoodEvent_eq_resolventGood_of_lowerEventProvider`,
`paperH2LowerSingularValueBadEvent_eq_empty_of_statement`, and provider-form
empty-event/zero-measure wrappers for the eta-only lower bad event. These two
leave-one-out wrappers reduce H2 good-event membership/equality to the
resolvent good event under the supplied lower provider, without constructing
that provider or proving any probability bound. The same reduction now has
measurability convenience wrappers
`paperH2LeaveOneOutGoodEvent_measurable_of_lowerEventProvider_and_resolventProvider`,
`paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_lowerEventProvider_and_resolventProvider`,
and
`paperH2LeaveOneOutBadEventMeasurabilityProvider_of_lowerEventProvider_and_resolventProvider`,
which consume an explicit resolvent-good measurability provider and prove no
primitive measurability or concentration estimate. The same pointwise provider
now also constructs the matching lower good/bad
measurability providers via the deterministic `Set.univ` / `∅` rewrites, without
proving primitive lower-singular-value measurability. That leaf
now also exposes `PaperH2LowerSingularValueBadEventProbabilityStatement`,
`PaperH2LowerSingularValueBadEventProbabilityProvider`, and event-provider
wrappers that turn the zero-measure consequence into an arbitrary nonnegative
RHS bound for the eta-only lower bad event. The lambda-dependent resolvent
bad event now also has a hypothesis-style probability statement/provider and
projection theorem, and the full leave-one-out bad event now has a typed
union-bound consumer that combines the lower-bad and resolvent-bad probability
providers through the existing set inclusion plus `measure_union_le`. The same
route now has the named combined Real RHS
`paperH2LeaveOneOutBadEventUnionBoundRHS`, its nonnegativity lemma, a
`realRHS` projection using `ENNReal.ofReal_add`, and an RHS provider bridge
`paperH2LeaveOneOutGoodEventProbabilityProvider_of_unionBoundProbabilityProviders`
that repackages the lower-plus-resolvent bound as the existing H2 probability
provider surface. The H2 leave-one-out bad-event union-bound statement now also
exposes direct projections for its stored lower-bad statement, resolvent-bad
statement, and combined bad-event probability field, all as field-access API
only. The pointwise lower-singular-value event provider now also
feeds this H2 probability surface through
`paperH2LeaveOneOutGoodEventProbabilityProvider_of_lowerEventProvider_and_resolventProbabilityProvider`,
which uses only the deterministic empty-event lower-bad wrapper and keeps the
resolvent bad-event probability provider explicit. The same lower-event bridge
now also has direct union-bound statement/projection wrappers, including the
combined-RHS form, before repackaging into the H2 good-event probability
surface. The pointwise H2 good-event statement/provider now exposes eta,
pointwise-good-event, and provider-statement projections; the H2 good-event
probability statement also exposes eta positivity, RHS nonnegativity, and the
stored bad-event probability inequality. The paper-tail layer now has matching H2 union-bound projection
wrappers, including lower-event/resolvent-probability variants and the
combined-RHS form, and paper-tail H2 probability-consumer wrappers that build
the consumer from the lower-bad/resolvent-bad union-bound providers. These now
include the matching lower-event/resolvent-probability intermediate wrappers
for the H2 probability provider, consumer statement, short consumer alias, and
bad-event probability projection. A theorem-facing resolvent-probability
wrapper now records the paper-tail statement alongside the explicit resolvent
bad-event probability obligation before any union-bound composition. The theorem-facing
`ShrinkageTheorem1PaperTailWithH2ConsumerStatement` now pairs that H2 consumer
with the existing paper-tail statement wrapper, including the lower-event
bridge
`shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventProbabilityProvider`.
The H2 consumer wrapper and the resolvent-probability precursor now also expose
direct field projections for the paper-tail side and the H2 consumer/resolvent
probability side, keeping the theorem-facing paired obligations usable without
structure unfolding.
The paper-tail statement wrapper now also exposes direct field projections for
its provider bundle, H1/H2 providers, lambda positivity, threshold/RHS
nonnegativity, and supplied tail bound, matching the base final-tail statement
projection surface while staying purely API/projection-level.
The early H2 measurability providers now also expose direct field projections
for the lower-singular-value good/bad events, resolvent good/bad events, and the
leave-one-out good/bad events, without adding primitive measurability proofs.
The resolvent wrapper now has a direct consumer bridge
`shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_resolventProbabilityStatement_and_lowerEventProvider`,
using `paperH2ResolventBadEventProbabilityProvider_of_statement` to normalize
the resolvent statement/provider boundary before adding the lower-event,
measurability, and RHS inputs.
The H2 consumer layer also has
`shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_lowerEventProvider_and_resolventPaperRHSBounds`,
which plugs the paper-RHS resolvent provider into the lower-event consumer path
with the definitional lower-plus-resolvent H2 union RHS, still without proving
any component probability tail. The H2 union-RHS provider also exposes the
direct field projection
`paperH2LeaveOneOutBadEventUnionBoundRHSProvider_rhs_eq`.
The base H2 probability provider and consumer wrappers now expose direct field
projections for their stored probability statement, measurability, and bad-event
bound fields, still without proving any new probability estimate.
The lower-singular-value H2 provider shell now likewise exposes direct field
projections for eta positivity, RHS nonnegativity, bad-event measurability, and
the supplied bad-event probability field. The lower-bad and resolvent-bad probability
provider shells now also expose direct statement projections for their stored
probability assumptions; the shifted-determinant and Woodbury-denominator bad-event
probability providers expose the same projection-only surface. The atomic resolvent
probability provider now also exposes direct projections for its three RHS
nonnegativity fields and three atomic probability fields, without proving any new
probability estimate. The atomic RHS provider itself also exposes direct
projections for its three nonnegativity fields, keeping the union-bound RHS
API available without adding probability or concentration content. The atomic
union-bound statement now exposes direct projections for its stored atomic
provider, atomic-union probability bound, and resolvent bad-event statement;
these projections add no new proof content beyond field access.
It now has the matching short alias
`shrinkageTheorem1PaperTailH2ProbabilityConsumer_of_lowerEventProvider_and_resolventPaperRHSBounds`
and bad-event projection
`shrinkageTheorem1PaperTailH2ProbabilityConsumer_badEventProbability_of_lowerEventProvider_and_resolventPaperRHSBounds`.
The theorem-facing wrapper now also has
`shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventPaperRHSBounds`,
which pairs that paper-RHS H2 consumer with the existing paper-tail statement
wrapper without proving any component probability tail.
`ShrinkageTheorem1ProofReadinessObligations` now bundles the same remaining
paper-tail, H2 measurability, lower-event, RHS, and resolvent-probability
obligations, and
`shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_proofReadinessObligations`
projects that ledger into the theorem-facing H2 consumer statement without
proving any new probability estimate.
The paper-RHS-specialized readiness layer now also has
`ShrinkageTheorem1PaperRHSProofReadinessObligations` and
`shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_paperRHSProofReadinessObligations`,
which replace the explicit resolvent-probability-provider obligation by the
supplied shifted-determinant and Woodbury-denominator paper-RHS component
bounds, then project into the same theorem-facing wrapper.
It also exposes lower-event convenience constructors
`shrinkageTheorem1ProofReadinessObligations_of_lowerEventProvider` and
`shrinkageTheorem1PaperRHSProofReadinessObligations_of_lowerEventProvider`,
which derive the H2 bad-event measurability ledger field from the paper-tail H1
provider plus the lower singular-value event provider while leaving probability
and component-tail bounds as explicit inputs. The matching direct consumers
`shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventProbabilityProvider_fromH1`
and
`shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1`
feed those constructed ledgers into the theorem-facing wrapper without adding
probability or concentration content.
The same from-H1 paper-RHS route now reaches the final tail statement directly
through
`shrinkageTheorem1TailStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_finalEventSubsetStatement`,
which combines the constructed paper-RHS readiness ledger with the named
`ShrinkageTheorem1FinalEventSubsetStatement` and keeps all component tail
bounds explicit. It also has bundled final-tail/measurability consumers
`shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_finalEventSubsetStatement`
and
`shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_finalEventSubsetStatement_error_measurable`,
so the same route can consume either an explicit final-tail measurability
provider or measurable true/estimated error functions.
It also exposes the corresponding H2 consumer and bad-event probability
projections
`shrinkageTheorem1PaperTailH2ProbabilityConsumer_of_paperRHSProofReadinessObligations`
and
`shrinkageTheorem1PaperTailH2ProbabilityConsumer_badEventProbability_of_paperRHSProofReadinessObligations`
as field conveniences over that wrapper.
The final theorem-readiness surface now has
`ShrinkageTheorem1PaperRHSFinalBridgeObligations` and
`shrinkageTheorem1TailStatement_of_paperRHSFinalBridgeObligations`; this keeps
the paper-RHS readiness ledger separate from the still-missing analytic bridge
by requiring the final `shrinkageTheorem1TailEvent` bound as an explicit field.
The same compact ledger now has projection-only accessors
`shrinkageTheorem1PaperRHSFinalBridgeObligations_paper_rhs_readiness` and
`shrinkageTheorem1PaperRHSFinalBridgeObligations_final_tail_bound`, exposing
those two stored fields without proving any new probability or concentration
claim.
The final tail-event measurability side condition now has a thin provider shell:
`ShrinkageTheorem1FinalTailMeasurabilityProvider`,
`shrinkageTheorem1FinalTailMeasurabilityProvider_final_tail_event_measurable`,
`shrinkageTheorem1TailEvent_measurable_of_provider`,
`shrinkageTheorem1FinalTailMeasurabilityProvider_of_measurable`,
`shrinkageTheorem1TailEvent_measurable_of_error_measurable`, and
`shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable`.
It only packages an explicit `MeasurableSet` or the elementary Borel-preimage
step from measurable true/estimated error functions; it proves no probability,
concentration, or paper-RHS estimate.
The final tail statement plus this side condition now has a thin bundled
consumer, `ShrinkageTheorem1TailWithMeasurabilityStatement`, with constructors
from either a final-tail measurability provider or measurable true/estimated
error functions and projections for the tail statement, final-tail-event
measurability provider, final-tail-event measurability, tail bound, theorem
providers, lambda positivity, threshold
nonnegativity, and tail-RHS nonnegativity. This is packaging only; it does not
prove a new tail estimate or enter concentration. The paper-RHS
proof-readiness route now
has matching direct bundled consumers from the compact final-bridge ledger, the
raw event-subset target, the named final-event subset target, the pointwise
comparison-provider route, the random-paper-error specialization, the
statement-shaped final-bias-dominance route, the additive paper-bias upper-bound
route, the variance-plus-exponential
partial-bias route, and the one-shot/componentwise `Delta_X(lambda)` routes:
each route has an explicit final-tail measurability-provider wrapper and a
measurable true/estimated-error wrapper.
The first explicit decomposition of the final tail bound is now
`shrinkageTheorem1TailBound_of_eventSubset_paperTailBound`, a pure
`measure_mono` bridge from a final-event subset obligation and the existing
paper-tail probability bound.  The named target `ShrinkageTheorem1FinalEventSubsetStatement`, its
statement-based tail-bound bridge
`shrinkageTheorem1TailBound_of_finalEventSubsetStatement`, the wrappers
`shrinkageTheorem1PaperRHSFinalBridgeObligations_of_eventSubset` /
`shrinkageTheorem1PaperRHSFinalBridgeObligations_of_finalEventSubsetStatement`,
and the direct consumers
`shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_eventSubset` /
`shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetStatement`
now thread that subset obligation into the final theorem statement surface; the
from-H1 lower-event route also has the direct final-event-subset consumer
`shrinkageTheorem1TailStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_finalEventSubsetStatement`
plus the matching bundled measurability and measurable-errors consumers.
The subset target also now has the pointwise deterministic comparison provider
`ShrinkageTheorem1FinalEventSubsetComparisonProvider`, the subset projection
`shrinkageTheorem1FinalEventSubsetStatement_of_comparisonProvider`, and the
direct consumer
`shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetComparisonProvider`.
This only records equality of the user-facing true/estimated error functions
with the paper shrinkage error vocabulary plus paper-bias domination by the
final bias; it does not prove a probability or concentration estimate.
The three stored comparison fields are also exposed by projection-only APIs
`shrinkageTheorem1FinalEventSubsetComparisonProvider_true_error_eq`,
`shrinkageTheorem1FinalEventSubsetComparisonProvider_estimated_error_eq`, and
`shrinkageTheorem1FinalEventSubsetComparisonProvider_paper_bias_le_final_bias`.
The random-paper-error specialization now adds
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
`paperTheorem1VariancePlusExponentialBiasComponent`,
`paperTheorem1VariancePlusExponentialPaperBias`,
`paperShrinkageBiasTerm_constant`,
`paperShrinkageBiasTerm_paperTheorem1VariancePaperBias`,
`paperShrinkageBiasTerm_paperTheorem1ExponentialPaperBias`,
`paperShrinkageBiasTerm_paperTheorem1VariancePlusExponentialPaperBias`,
`randomPaperShrinkageBiasTerm_constant`,
`randomPaperShrinkageBiasTerm_paperTheorem1VariancePaperBias`,
`randomPaperShrinkageBiasTerm_paperTheorem1ExponentialPaperBias`,
`randomPaperShrinkageBiasTerm_paperTheorem1VariancePlusExponentialPaperBias`,
`addPaperShrinkageBias`,
`paperShrinkageBiasTerm_add`,
`randomPaperShrinkageBiasTerm_add`,
`paperTheorem1VarianceBiasControlProvider`,
`paperTheorem1ExponentialBiasControlProvider`,
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
The full-Delta from-H1 wrappers bypass an explicit readiness-ledger argument once
H1, the lower-event provider, component paper-RHS bounds, the paper-tail bound,
and the deterministic component-bias comparisons are supplied.
`shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_addPaperBiasUpperBounds`,
`shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1VariancePlusExponentialBiasComponent`,
`shrinkageTheorem1PaperTailEvent_subset_left_of_addPaperBias_nonneg`,
`shrinkageTheorem1PaperTailProviders_of_addPaperBias_left`,
`shrinkageTheorem1PaperTailBound_of_addPaperBias_left`,
`shrinkageTheorem1PaperRHSProofReadinessObligations_of_addPaperBias_left`,
`shrinkageTheorem1PaperTailEvent_subset_right_of_addPaperBias_nonneg`,
`shrinkageTheorem1PaperTailProviders_of_addPaperBias_right`,
`shrinkageTheorem1PaperTailBound_of_addPaperBias_right`, and
`shrinkageTheorem1PaperRHSProofReadinessObligations_of_addPaperBias_right`,
with the statement-shaped consumer
`shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors_biasStatement`.
These wrappers close the true/estimated error equality fields definitionally
when the final theorem uses `randomPaperShrinkageError` and
`randomPaperShrinkageEstimatedError`, leaving only pointwise bias dominance as
the remaining deterministic obligation.  The direct from-H1 random-paper-error
wrappers now bypass the explicit proof-readiness ledger once H1, the lower-event
provider, the component RHS bounds, and final-bias dominance are supplied; they
remain packaging only and prove no new probability or concentration estimate.
That obligation is now also exposed as
the typed statement
`∀ omega, randomPaperShrinkageBiasTerm X paperBias lam omega <= bias`, plus
provider projection and statement-to-provider wrappers.  The monotonicity
wrappers also make this scalar final-bias slot upward-closed: a bound proved at
`biasBase` can be reused at any larger `bias`.
The paper-tail bias-control side condition now has deterministic constructors
from uniform sample-level nonnegativity, nonnegative constant paper-bias slots,
and additive composition of two controlled paper-bias components.
The constant paper-bias constructor covers the deterministic scalar special
case where the paper-bias slot is already `c` and `c <= bias`; it is a
scalar-upper-bound consumer hook, not an identification of the concrete
`Delta_X(lambda)` formula.
The first concrete paper-bias component is now the variance term
`paperTheorem1VarianceBiasComponent d n lam = 1 / (lam ^ 3 * n * d)` with the
sample-independent `paperTheorem1VariancePaperBias` slot.  Current support is
still deterministic only: evaluation wrappers, nonnegativity under positive
`lambda`, `n`, and `d`, and thin bias-control / scalar-upper-bound providers.
It does not prove the full `Delta_X(lambda)` bound, concentration, or Theorem 1.
The second concrete paper-bias component now names the scalar exponential term
`paperTheorem1ExponentialBiasComponent n C2 cX = C2 * exp (-(cX * n))` with
the sample-independent `paperTheorem1ExponentialPaperBias` slot. Current
support remains deterministic only: evaluation wrappers, nonnegativity from
`0 <= C2`, and thin bias-control / scalar-upper-bound providers. It does not
prove the paper exponential tail estimate, concentration, or Theorem 1.
The remaining displayed `Delta_X(lambda)` scalar component is now named by
`paperTheorem1DeterministicEquivalentBiasComponent d n C1 sigmaX sigmaOp lambdaMinSigma eta`
and packaged through `paperTheorem1DeterministicEquivalentPaperBias`.  Current
support is still deterministic API only: evaluation wrappers, nonnegativity
from nonnegative `C1`, `sigmaOp`, and `lambdaMinSigma`, plus thin bias-control /
scalar-upper-bound providers. It does not prove the spectral deterministic-equivalent
bound, concentration, or Theorem 1.
The full displayed three-term scalar vocabulary is now named by
`paperTheorem1DeltaBiasComponent d n lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX`
and packaged through `paperTheorem1DeltaPaperBias` as the sum of the
DeterministicEquivalent and VariancePlusExponential paper-bias slots.  Current
support is deterministic only: evaluation wrappers, additive nonnegativity via
existing providers, scalar-upper-bound wrappers under either one explicit
full-Delta comparison or three separately supplied component comparisons plus a
sum comparison, final-bias dominance and final-event subset wrappers that consume
the three-component upper-bound consumer, tail-statement wrappers that consume
either the explicit full-Delta comparison or the three-component upper-bound
consumer under an already supplied paper-RHS proof-readiness ledger, and
left/right proof-readiness wrappers that specialize
the additive ledger reuse path to DeterministicEquivalent plus
VariancePlusExponential.
It does not prove any component upper bound, spectral estimate, concentration,
or Theorem 1.
The partial variance-plus-exponential envelope remains named by
`paperTheorem1VariancePlusExponentialBiasComponent d n lam C2 cX` and packaged
through `paperTheorem1VariancePlusExponentialPaperBias` using the existing
`addPaperShrinkageBias` vocabulary. Its wrappers remain reusable deterministic
plumbing only.
Its theorem-facing final-bias wrappers now consume the explicit scalar
comparison `paperTheorem1VariancePlusExponentialBiasComponent ... <= bias` and
produce the matching `ShrinkageTheorem1FinalBiasDominanceStatement` / provider
without adding any probability estimate.  The same partial envelope now also has
a theorem-facing tail-statement consumer that threads an already supplied
`ShrinkageTheorem1PaperRHSProofReadinessObligations` ledger through that
final-bias provider; it remains a deterministic API wrapper and does not prove
the paper-tail probability, concentration, or Theorem 1.
The scalar upper-bound statement/provider pair separates the base deterministic
obligation `randomPaperShrinkageBiasTerm <= biasBound` from the final
comparison `biasBound <= bias`, with explicit statement/provider round trips so
later concrete bias formula work can plug into the same route without changing
the final theorem surface.
The constant paper-bias upper-bound wrappers now prove that route directly from
`c <= biasBound`, serving as a deterministic pattern for later non-constant
paper-bias formula bounds.  The uniform deterministic wrappers also turn any
sample-level bound `forall X0, paperShrinkageBiasTerm ... X0 lam <= biasBound`
into the random upper-bound provider and then into final-bias dominance once
`biasBound <= bias` is supplied; this does not identify or prove the concrete
`Delta_X(lambda)` formula.
The upper-bound layer is also upward-closed and has left/right `max` weakening
plus additive paper-bias wrappers, so independently proved component bounds can
be consumed under larger scalar envelopes or combined as `boundLeft + boundRight`
without changing the final theorem surface.  The additive final-bias wrappers
now bridge those component upper-bound providers directly into the final-bias
dominance provider when `(boundLeft + boundRight) <= bias` is supplied, and
the final-event additive wrappers reuse that provider to close the
random-paper-error comparison/subset layer; the direct tail additive consumer
then reuses the same proof-readiness ledger and supplied paper-tail bound for
the additive paper-bias slot. The additive-left/right readiness wrappers now
also reuse either component paper-tail route for an additive slot when the
opposite component is nonnegative and additive tail measurability is supplied;
the full-Delta left/right wrappers are the same route specialized to the paper's
DeterministicEquivalent plus VariancePlusExponential split. Generic and
full-Delta paper-tail measurability projection/constructor wrappers now expose
or package exactly a supplied `MeasurableSet` for that tail event, including the
direct `shrinkageTheorem1PaperTailMeasurabilityProvider_tail_event_measurable`
field projection, and the provider-bundle projections expose the same
measurability field from
`ShrinkageTheorem1PaperTailProviders`. The bound is only `measure_mono` over a
deterministic event subset.
Thus
`ShrinkageTheorem1PaperTailProviders` can carry that consumer without changing
its core fields. These are deterministic/provider surfaces only, not
concentration, lower-tail, resolvent-tail, or Theorem 1 bounds for H2.
These providers only package `MeasurableSet` assumptions and set-theoretic
intersection/complement bridges; they do not derive primitive measurability
from random-matrix assumptions. The resolvent primitive-measurability route
also has named
atomic determinant-unit and Woodbury-denominator events, a membership bridge, a
matching atomic-bad vocabulary with complement rewrites and a resolvent-bad
subset cover plus an atomic probability union-bound provider shell,
typed statement/provider shell with a direct primitive-provider field
projection, a bundled atomic measurability provider with
direct projections for the full shifted determinant-unit event, each
leave-one-out shifted determinant-unit event, and each Woodbury-denominator
nonzero event, scalar determinant-unit event bridges from determinant-function
measurability, a scalar Woodbury-denominator nonzero event bridge from denominator-function
measurability, and a finite-intersection proof from those atomic event
measurability assumptions. The determinant-function layer is now discharged from
entrywise measurability of the shifted matrices by
`squareMatrix_det_measurable_of_entry_measurable` and
`paperH2ResolventAtomicMeasurabilityProvider_of_shifted_entry_and_denominator_measurable`.
The shifted-entry layer is now discharged from random-data entry measurability by
`shrinkageShiftedMatrix_entry_measurable_of_data_entry_measurable`,
`leaveOneOutShiftedMatrix_entry_measurable_of_data_entry_measurable`, and
`paperH2ResolventAtomicMeasurabilityProvider_of_data_entry_and_denominator_measurable`.
The Woodbury denominator finite-algebra layer is now discharged from selected
data-column measurability and leave-one-out resolvent-entry measurability by
`shrinkageLeaveOneOutWoodburyDenominator_measurable_of_resolvent_entry_measurable`
and
`paperH2ResolventAtomicMeasurabilityProvider_of_data_entry_and_resolvent_entry_measurable`.
The total inverse/resolvent-entry layer is now discharged from matrix-entry
measurability by `squareMatrix_inv_entry_measurable_of_entry_measurable`,
`leaveOneOutShrinkageResolvent_entry_measurable_of_shifted_entry_measurable`,
`leaveOneOutShrinkageResolvent_entry_measurable_of_data_entry_measurable`, and
the direct wrapper `paperH2ResolventAtomicMeasurabilityProvider_of_data_entry_measurable`.
The H1 observed-data random-matrix field now projects into random-data entry
measurability and then into the H2 resolvent atomic provider via
`data_entry_measurable_of_isRandomMatrix`,
`data_entry_measurable_of_h1_provider`, and
`paperH2ResolventAtomicMeasurabilityProvider_of_h1_provider`.
H1 plus an explicit lower-singular-value good- or bad-event measurability
provider, or directly plus the eta-only pointwise lower event provider, now also
yields resolvent/good/bad H2 event measurability providers via
`paperH2ResolventGoodEventMeasurabilityProvider_of_h1_provider`,
`paperH2ResolventBadEventMeasurabilityProvider_of_h1_provider`,
`paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lower_provider`, and
`paperH2LeaveOneOutBadEventMeasurabilityProvider_of_h1_and_lower_provider`,
with the lower-bad route covered by
`paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lowerBad_provider`
and
`paperH2LeaveOneOutBadEventMeasurabilityProvider_of_h1_and_lowerBad_provider`,
and the direct pointwise-lower route covered by
`paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lowerEventProvider`
and
`paperH2LeaveOneOutBadEventMeasurabilityProvider_of_h1_and_lowerEventProvider`.
These entries do not prove primitive measurability needed to construct H1,
lower-singular-value measurability itself, paper concentration bounds,
deterministic equivalents, H1/H2 discharge, or PrecisionDA Theorem 1.

## Current Process / Random Object Entry Names

Random-family helpers:

- `RandomFamily`
- `RealRandomFamily`
- `IsRandomFamily`
- `IsRealRandomFamily`
- `familyAt`
- `mapRandomFamily`
- `isRandomFamily_map`
- `IsRandomProcess`
- `processAt`
- `isRandomVariable_processAt`
- `IsRandomSample`
- `sampleEvaluation`

## Current RandomMatrix Entry Names

Core Matrix Bernstein helpers:

- `matrixBernsteinOptimizedScalarTailRHS`
- `matrixBernsteinTwoSidedOptimizedScalarTailRHS`
- `rowSqNormVarianceProxyNormRHS`
- `MatrixBernsteinPositiveSideAssumptions`
- `MatrixBernsteinNegativeSideAssumptions`
- `MatrixBernsteinPositiveSideTroppAssumptions`
- `MatrixBernsteinNegativeSideTroppAssumptions`
- `matrixBernsteinTraceMGF_under_tropp`
- `matrixBernsteinQuadTail_trace_under_tropp`
- `matrixBernsteinQuadTail_scalar_under_tropp`
- `matrixBernsteinQuadTail_opt_under_tropp`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions`
- `matrixBernsteinQuadTail_opt_of_tropp`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge`
- `MatrixBernsteinConditioningTraceMGFTailAssumptions`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFTailAssumptions`
- `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions`
- `matrixBernsteinQuadTail_twoSided_opt_of_tropp`
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_assumptions`
- `matrixBernsteinOpNormTail_opt_of_tropp`

TraceExp / Tropp bookkeeping helpers:

- `troppTraceState`
- `troppStateHistory`
- `troppNaturalState_zero`
- `troppNaturalState_last`
- `troppNaturalState_left`
- `troppNaturalState_right`
- `troppHistoryStepIndependent_of_iIndepFun_of_measurable`
- `troppTraceExpFiniteFamilyIterationSkeleton_of_naturalStateConditionalSteps`
- `troppMasterTraceMGFFiniteFamily_of_naturalStateConditionalSteps`
- `traceMGFBernsteinVarianceProxyBound_of_naturalStateConditionalSteps`
- `traceMatrixExp_randomMatrixPrefixSum_last`
- `traceMatrixExp_comparisonMatrixPrefixSum_last`

Sample covariance wrappers:

- `SampleCovarianceTailTarget`
- `SampleCovarianceTailTarget.event`
- `SampleCovarianceTailTarget.rhs`
- `SampleCovarianceBoundedRowTroppAssumptions`
- `sampleCovariance_tail_optimized_under_boundedRowTroppAssumptions`
- lower-level positive-side wrappers, including
  `sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound_of_troppPrimitive`
  and `sampleCovariance_quadraticForm_tail_optimized_under_exactRowSqNorm_bound_of_troppPrimitive`
- bridge-layer exact-row centered-square wrappers and bundles, including
  `SampleCovarianceExactRowCenteredSquareTroppAssumptions`,
  `SampleCovarianceExactRowCenteredSquareTwoSidedTroppAssumptions`, and their
  `..._of_centeredSquareChain...` wrappers
- lower-level compatibility operator-norm wrappers remain available for explicit
  proof-boundary work, but the compact target/record route is the preferred
  reader-facing bounded-row surface.

Sample covariance negative-side provider-transfer adapters:

- `centeredSampleCovarianceRowRankOneFamilyNeg_expIntegrable_of_expIntegrable_neg_theta`
- `centeredSampleCovarianceRowRankOneSumNeg_traceExpIntegrable_of_traceExpIntegrable_neg_theta`
- `centeredSampleCovarianceRowRankOneFamilyNeg_cfcPrimitive_of_cfcPrimitive_neg_theta`

Hardbone proved leaves, deterministic bridges, statement targets, and thin consumers:

- `scalarBernsteinExpQuadraticInequality`
- `selfAdjointSpectrumBoundedByOperatorNorm`
- `bernsteinCFCExpressionNormalization`
- `cfcScalarInequalityToMatrixLE_bernsteinExpQuadratic`
- `bernsteinMatrixExp_le_quadratic_of_cfcLeaves`
- `bernsteinMatrixExp_le_quadratic`
- `traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider`
- `varianceProxyNormBound_of_centeredSquareChain`
- `matrixSquare_centeredRandomMatrix_expectation_expansion`
- `varianceProxyNormBound_of_centeredSquareChain_expansion`
- `matrixTrace_smul`
- `matrixTrace_le_of_matrixLE`
- `traceMatrixExp_le_trace_support_exp_lambdaMax_of_supportDomination`
- `traceMatrixExp_le_rank_exp_lambdaMax`
- `traceMatrixExp_le_supportDim_exp_lambdaMax`
- `traceMatrixExp_eq_sum_exp_eigenvalues`
- `traceMatrixExp_smul_le_card_add_trace_div_mul_exp_sub_one_of_psd_lambdaMax_le`
- `traceMatrixExp_effectiveRank_bound`
- `matrixTrace_le_card_mul_of_isPSD_lambdaMaxOrdered_le`
- `lambdaMinOrdered`
- `lambdaMinOrdered_is_least_eigenvalue_statement`
- `lambdaMinOrdered_is_least_eigenvalue`
- `lambdaMinOrdered_le_eigenvalues₀`
- `traceMatrixExp_effectiveRank_bound_of_ambientTraceCertificate`
- `matrixTrace_eq_rank_of_isStarProjection`
- `realMatrixToCStarStarAlgHom`
- `realMatrixToCStar_nonneg`
- `realMatrixToCStar_strictlyPositive`
- `realMatrixToCStar_matrixLE`
- `realMatrixToCStar_log`
- `matrixLE_of_realMatrixToCStar_matrixLE`
- `operatorLogMonotoneOnPositiveMatrices`
- `troppLogExpComparisonToK`
- `matrixExpLogDomainForSelfAdjoint`
- `isPSDMatrix_of_isStarProjection`
- `isPSDMatrix_of_posSemidef`
- `matrixLE_of_mathlib_le`
- `mathlib_le_of_matrixLE`
- `MatrixExpSupportDomination`
- `MatrixExpExcessSupportDomination`
- `matrixExpSupportDomination_identity_statement`
- `traceMatrixExp_excess_supportDim_exp_lambdaMax_statement`
- `traceMatrixExp_le_card_add_trace_support_mul_exp_sub_one_of_excessSupportDomination`
- `traceMatrixExp_excess_supportDim_exp_lambdaMax`

Hardbone matrix-exp/log normalization leaf:

- `matrixExpLogSelfAdjointNormalization`

Hardbone log/order bridge leaf:

- `matrixLog_le_of_le_matrixExp`
- `traceMatrixExp_mono_add_selfAdjoint`

Hardbone conditioning bridge leaf:

- `troppConditionalStep_of_iIndepFun`

Reader-facing example routes:

- `StatementRoutes`
- `SampleCovarianceTailUsage`
- `RankOneMatrixBernsteinPipelineUsage`
- `RandomFeatureKernelUsage`
- `NTKGramUsage`
- `GradientCovarianceUsage`
- `NaturalTroppPipelineUsage`

Low-level prefix/state, reindex, negative-family, nullspace/decomposition, exact adapter, and statement-atlas APIs remain covered by source, tests, and judge files; they are not all exposed as separate examples.
## Current Caveats

- The random-family layer is vocabulary only: it adds indexed aliases, endpoint/map wrappers, and pointwise measurability lemmas, but no filtrations, adaptedness, martingales, or conditioning providers.

- RandomMatrix / Matrix Bernstein remains experimental.
- The hardbone statement atlas names CFC, log/order, Tropp/Lieb,
  conditioning, integrability, variance-proxy, and dimension/rank blockers as
  typed statement targets. The trace-exp domination-provider consumer is proved as
  `traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider`, but it only
  consumes an explicit nonnegative integrable dominator and pointwise absolute
  domination. The centered-square expectation expansion is now proved as
  `matrixSquare_centeredRandomMatrix_expectation_expansion`, reusing
  `matrixSecondMoment_centeredRandomMatrix`. The centered rank-one second-moment
  comparison is proved as `centeredRankOneSquare_le_rankOneSecondMoment`, via
  the general covariance comparison
  `matrixSecondMoment_centeredRandomMatrix_le_matrixSecondMoment` and the
  deterministic order helper `matrixLE_sub_right_of_isPSD`. The
  sample-covariance hardbone consumer
  `sampleCovarianceVarianceProxy_sharp_of_rankOneSecondMoment` now supplies the
  rank-one comparison to the abstract sharp-variance chain, and
  `sampleCovarianceVarianceProxy_sharp_of_exactRowSecondMoment` removes the
  reflexive row second-moment comparison by choosing
  `V_i = matrixSecondMoment P (rankOneRandomMatrix (X i))`. The generic
  finite-sum norm-control bridge for such deterministic sums is exposed as
  `deterministicMatrixVarianceProxyNorm_sum_le_sum`. Row-specific exact
  rank-one second-moment norm providers are now exposed as
  `deterministicMatrixVarianceProxyNorm_matrixSecondMoment_rankOneRandomMatrix_le_sq_of_sqNorm_bound`
  and
  `deterministicMatrixVarianceProxyNorm_sum_matrixSecondMoment_rankOneRandomMatrix_le_sum_sq_of_sqNorm_bound`.
  Rank-one square-integrability can now be provided from explicit
  four-coordinate product integrability by
  `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_integrable_four_products`;
  the coordinate-`MemLp 4` provider is
  `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_memLp_four`;
  the bounded-row provider from coordinate `MemLp 2` plus pointwise
  `vectorSqNorm <= R` is
  `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_sqNorm_bound_memLp_two`.
  The row-specific exact-row sample-covariance hardbone consumer
  `sampleCovarianceVarianceProxy_sharp_of_exactRowSqNorm_bound_memLp_two`
  now combines this bounded-row square-integrability route with exact-row
  deterministic norm control to produce RHS `rowSqNormVarianceProxyNormRHS R`.
  The bridge layer also exposes the generic centered-square to exact-row
  sample-covariance adapter, the named negative-family exact-row variance-proxy
  transfer, and exact-row centered-square sample-covariance wrappers/bundles for
  positive and two-sided/operator-norm routes. These are proof-infrastructure
  providers only: the compact bounded-row sample-covariance target route remains
  the reader-facing surface. The variance-proxy provider-chain consumer is
  proved as `varianceProxyNormBound_of_centeredSquareChain`; the newer
  `varianceProxyNormBound_of_centeredSquareChain_of_normMono` proves the
  finite-sum Loewner bookkeeping under an explicit norm-monotonicity premise,
  and `deterministicMatrixVarianceProxyNorm_mono_of_matrixLE` discharges the
  PSD Loewner-to-operator-norm bridge. `varianceProxyNormBound_of_centeredSquareChain_expansion` removes the explicit
  centered-square expansion argument but still requires Loewner comparison and
  deterministic norm-control assumptions at the wrapper boundary. The rank/support trace-bound bridge is now proved through
  `traceMatrixExp_le_trace_support_exp_lambdaMax_of_supportDomination`
  and the `traceMatrixExp_le_rank_exp_lambdaMax` /
  `traceMatrixExp_le_supportDim_exp_lambdaMax` consumers. Explicit
  star-projection rank certificates are now consumed by
  `traceMatrixExp_le_rank_exp_lambdaMax_of_isStarProjection`, using
  `matrixTrace_eq_rank_of_isStarProjection` and
  `isPSDMatrix_of_isStarProjection`. This discharges the PSD premise from an
  explicit `IsStarProjection support`; the domination premise is now named
  `MatrixExpSupportDomination`, but providers for that certificate and support
  construction for applications remain separate. The ambient identity provider
  target is named by `matrixExpSupportDomination_identity_statement`. The
  corrected low-rank route is named separately by
  `MatrixExpExcessSupportDomination` and
  `traceMatrixExp_excess_supportDim_exp_lambdaMax_statement`; the trace bridge
  `traceMatrixExp_le_card_add_trace_support_mul_exp_sub_one_of_excessSupportDomination`
  and thin consumer `traceMatrixExp_excess_supportDim_exp_lambdaMax` are now
  proved under an explicit excess certificate, trace support-dimension bound,
  and nonnegative excess-coefficient premise. None of these provider
  targets gives a true effective-rank certificate. The
  ambient route only supplies the
  certificate with effective-rank parameter `(n + 1 : Real)`. The Bernstein
  CFC route is now proved through
  `bernsteinMatrixExp_le_quadratic`, reusing scalar Bernstein, spectrum
  localization, Bernstein-specific CFC order transfer, and CFC expression
  normalization. The local matrix-exp/log normalization leaf is now proved by
  `matrixExpLogSelfAdjointNormalization`; it is only the pointwise CFC
  normalization consumed by the Tropp/Lieb one-step chain. The matrix log/order
  bridge is now proved through `matrixLog_le_of_le_matrixExp`; the operator-log
  premise is supplied by `operatorLogMonotoneOnPositiveMatrices`, the
  trace-exponential monotonicity leaf is proved by
  `traceMatrixExp_mono_add_selfAdjoint`, and the deterministic log/order-to-`K`
  target is proved by `troppLogExpComparisonToK`. The
  conditioning chain now has the thin theorem witness
  `troppConditionalStep_of_iIndepFun`, which only forwards the explicit
  per-index conditional-expectation provider and does not prove history
  measurability or independence. The S10 wrapper
  `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge` threads
  the S9 trace-MGF consumer into the quadratic-form Laplace/tail route under an
  explicit tail-event subset assumption. The preferred optimized Matrix Bernstein
  assumption bundles are now `MatrixBernsteinPositiveSideTroppAssumptions` and
  `MatrixBernsteinNegativeSideTroppAssumptions`, which expose Tropp/Lieb
  primitives but not pointwise CFC fields. The older explicit-CFC bundles and
  `_under_primitives` wrappers remain compatibility surfaces.
- Tropp/Lieb, Golden-Thompson, trace-exp integrability, variance-proxy control,
  and full Matrix Bernstein are not claimed as complete unless a referenced
  theorem says so directly.
- Prefix/suffix/state bookkeeping now includes a natural `Fin m` trace-state
  route through the finite-family Tropp and trace-MGF provider surfaces. This
  does not discharge the analytic conditional-step, history measurability,
  independence, trace-exp integrability, log/K, CFC, or variance-proxy
  hypotheses.
- `StatementRoutes` is an examples-only route index; it groups representative example-level statement families without adding core API. Lower-level bridge and frontier checks belong in source, tests, and judge files rather than separate reader-facing examples.
- Positive-threshold operator-norm routes use `0 < t`; the zero-dimensional `t = 0` endpoint is not part of that route.
- Sample covariance wrappers remain conditional APIs, not unconditional concentration theorems. The positive-side quadratic-form route now has an exact-row variance-proxy wrapper, but two-sided and operator-norm exact-row wrappers still need a negative-side exact-row variance-proxy provider contract. The preferred sample-covariance and reader-facing Matrix Bernstein example routes now use Tropp-only wrappers that fill pointwise Bernstein CFC fields with `bernsteinMatrixExp_le_quadratic`; explicit-CFC wrappers remain compatibility surfaces.
- Negative-side provider-transfer adapters only move explicit opposite-parameter
  assumptions onto the named negative sample-covariance family; they do not
  prove exponential integrability, trace-exponential integrability, or CFC.
- Completed hardbone wrapper task: `RM-HB-sample-covariance-cfc-free-wrapper-contract`.
- Completed hardbone proof leaf:
  `RM-HB12-matrix-exp-log-selfadjoint-normalization-leaf`.
- Completed hardbone proof leaf:
  `RM-HB12-matrix-log-le-of-le-matrix-exp-bridge-leaf`.
- Completed hardbone proof leaf:
  `RM-HB12-trace-exp-rank-support-bound-leaf`.
- Completed hardbone proof leaf:
  `RM-HB12-tropp-conditional-step-of-iindepfun-bridge-leaf`.
- Completed hardbone proof leaf:
  `CG-B17-star-projection-rank-support-consumer-contract`.
- Completed hardbone proof leaf:
  `CG-B18-star-projection-psd-bridge-contract`, proving
  `isPSDMatrix_of_isStarProjection` and removing the explicit PSD premise from
  `traceMatrixExp_le_rank_exp_lambdaMax_of_isStarProjection`.
- Completed hardbone abstraction leaf:
  `CG-B19-support-domination-certificate-contract`, naming the support
  domination premise as `MatrixExpSupportDomination` without proving any
  provider for it.
- Completed hardbone abstraction leaf:
  `CG-B20-support-domination-provider-contract`, splitting the provider
  frontier into the ambient identity-support target
  `matrixExpSupportDomination_identity_statement` and the corrected excess
  support route `MatrixExpExcessSupportDomination` /
  `traceMatrixExp_excess_supportDim_exp_lambdaMax_statement`.
- Completed hardbone proof leaf:
  `CG-B21-excess-support-trace-bridge-contract`, proving the deterministic
  excess-support trace bridge and supportDim consumer while leaving support
  provider construction separate.
- Completed hardbone proof leaf:
  `RM-VP-deterministic-matrix-expectation-mul-bridge-contract`, proving
  deterministic left/right matrix multiplication through expectation, the
  centered-square expectation expansion, and a thin variance-proxy consumer that
  no longer asks users for the expansion premise.
- Completed hardbone proof leaf:
  `RM-VP-rank-one-second-moment-contract`, proving the centered rank-one
  second-moment / Loewner comparison and a thin sample-covariance hardbone
  consumer that supplies it.
- Completed hardbone proof leaf:
  `RM-VP-sample-covariance-row-second-moment-contract`, adding the exact
  row-second-moment hardbone consumer while leaving norm control explicit.
- Completed hardbone proof leaf:
  `RM-VP-exact-row-second-moment-norm-control-contract`, adding
  `deterministicMatrixVarianceProxyNorm_sum_le_sum` as the reusable
  finite-sum subadditivity bridge for deterministic variance-proxy norms.
- Completed hardbone proof leaf:
  `RM-VP-exact-row-second-moment-operator-norm-provider-contract`, adding
  single-row and row-specific finite-family norm providers for exact rank-one
  second moments under explicit rank-one square-integrability assumptions.
- Completed hardbone proof leaf:
  `RM-VP-rank-one-square-integrability-provider-contract`, adding
  `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_integrable_four_products`
  as a direct provider from explicit four-coordinate product integrability.
- Completed hardbone proof leaf:
  `RM-VP-rank-one-square-integrability-memlp4-provider-contract`, adding
  `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_memLp_four`
  by reusing Mathlib `MemLp.mul`, `MemLp.integrable_mul`, and an explicit
  `(4,4,2)` Holder triple.
- Completed hardbone proof leaf:
  `RM-VP-rank-one-square-integrability-bounded-row-provider-contract`, adding
  `coordinate_sq_le_vectorSqNorm` and
  `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_sqNorm_bound_memLp_two`.
  The provider discharges uncentered rank-one square-integrability from
  coordinate `MemLp 2` and pointwise `vectorSqNorm <= R`; it does not prove a
  variance-proxy norm bound by itself. Centered rank-one square-integrability is
  now supplied by
  `integrableRandomMatrix_randomMatrixSquare_centeredRankOneRandomMatrixFamily_of_memLp_four`
  and
  `integrableRandomMatrix_randomMatrixSquare_centeredRankOneRandomMatrixFamily_of_sqNorm_bound_memLp_two`;
  the bounded-row crude consumer
  `MatrixVarianceProxyNormBound_centeredRankOneRandomMatrixFamily_of_sqNorm_bound_memLp_two`
  removes the explicit centered square-integrability premise from that route.
- Completed hardbone proof leaf:
  `RM-VP-centered-rank-one-square-integrability-provider-contract`, adding centered rank-one square-integrability providers and the bounded-row crude variance-proxy consumer that supplies the centered square-integrability premise.
- Completed hardbone proof leaf:
  `RM-VP-sample-covariance-exact-row-variance-proxy-wrapper-contract`, adding
  `sampleCovarianceVarianceProxy_sharp_of_exactRowSqNorm_bound_memLp_two` as a
  row-specific exact-row variance-proxy consumer under explicit hardbone
  sharp-chain, coordinate `MemLp 2`, pointwise row squared-norm, and
  nonnegative radius assumptions.
- Completed hardbone proof leaf:
  `RM-VP-sample-covariance-tail-wrapper-with-exact-row-vp-contract`, adding
  `sampleCovariance_quadraticForm_tail_optimized_under_exactRowSqNorm_bound_of_troppPrimitive` as a positive-side quadratic-form wrapper with row-specific
  exact-row variance-proxy RHS and explicit hardbone sharp-chain premise.
- Integrated bridge-layer PR stack:
  exact-row centered-square sample-covariance wrappers/bundles, negative-side
  exact-row variance-proxy transfer, and
  `deterministicMatrixVarianceProxyNorm_mono_of_matrixLE`. These are kept as
  infrastructure for future provider compression rather than the preferred
  user-facing sample-covariance route.
- Completed hardbone proof leaf:
  `RM-LIEB-S3-operator-log-monotonicity-representation-bridge-contract`, with the reusable `MatrixOrder` bridges `isPSDMatrix_of_posSemidef`, `matrixLE_of_mathlib_le`, and `mathlib_le_of_matrixLE` now living below `Spectral`.
- Completed hardbone contract leaf:
  `RM-LIEB-S4-real-matrix-to-cstar-log-monotonicity-contract`, confirming Mathlib `CFC.log_le_log` on `CStarMatrix (Fin n) (Fin n) ℂ`; this is now consumed by the main operator-log witness.
- Completed hardbone proof leaf:
  `RM-LIEB-S6-real-to-cstar-transport-and-operator-log`, proving strict positivity/order/log-back transport through `CStarBridge` and the main witness `operatorLogMonotoneOnPositiveMatrices`.
- Completed hardbone proof leaf:
  `RM-LIEB-S8-direct-log-order-to-K-wrapper`, proving the deterministic `troppLogExpComparisonToK` wrapper from the already proved operator-log and trace-exp monotonicity leaves.
- Progress-first hardbone scaffold:
  `RM-LIEB-S9-conditional-step-assumption-composition-contract`, adding `traceMGFBernsteinVarianceProxyBound_of_conditioningBridge` as a finite-family trace-MGF consumer from explicit conditioning, natural-state, integrability, and variance-proxy assumptions. The hard assumptions consumed by the theorem are recorded in `docs/STATEMENTS.md`; this does not prove those assumptions.
- Progress-first hardbone scaffold:
  `RM-LIEB-S10-trace-mgf-to-tail-assumption-composition-contract`, adding
  `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge` as a
  trace-MGF-to-tail consumer under explicit tail-side assumptions. The hard
  assumptions consumed by the theorem are recorded in `docs/STATEMENTS.md`;
  this does not prove those assumptions or a full Matrix Bernstein theorem.

## Provider-Facing Lieb/Tropp Layer

Integrated `HighDimProb.RandomMatrix.LiebProvider` as a separate provider-facing
import layer. It now exposes the ambient matrix-exp Frechet derivative
primitives, the self-adjoint carrier restriction, and the reusable scalar
matrix-exp divided-difference coefficient layer:
`matrixExpDividedDifferenceSeries`, `matrixExpDividedDifferenceSeries_pos`,
`matrixExpDividedDifferenceSeries_ne_zero`, and the preferred trace-pairing
alias `MatrixExpFDeriv.conjDiagonalSymmTraceSum`. The longer theorem names
`matrixExpFDerivSelfAdjoint_diagonal_symm_entry_mul` and
`trace_mul_matrixExpFDerivSelfAdjoint_conj_diagonal_symm_eq_sum` remain available
as precise backing APIs for low-level proof work.

The strictly-positive carrier `CFC.log` first-derivative layer remains exposed
through `cfcLogSelfAdjoint`, `CFCLog.derivSAAt`, `CFCLog.lineDeriv`, and
`CFCLog.hasDerivAt_line`. The preferred spectral adapter aliases are
`CFCLog.diagonalDerivEntryMul`, `CFCLog.diagonalLineDerivEntryMul`, and
`CFCLog.diagonalLineDerivTraceSum`; the longer descriptive theorem names remain
available for exact proof matching. These are diagonal and trace-paired spectral
adapters at exponential self-adjoint diagonal base points; they are not the
conjugated-eigenbasis weighted resolvent-kernel adapter and do not prove the
Epstein sign theorem or Lieb concavity.

The resolvent side is split into two stable namespaces. The older short
derivative layer exposes inverse and trace-resolvent affine-line derivative
bookkeeping. The new `LogResolvent` namespace exposes finite-cutoff trace/CFC
log-resolvent identities and renormalized cutoff limits:
`LogResolvent.kernelFixedSum`, `LogResolvent.kernelCutoffSum`,
`LogResolvent.shiftedInvTraceSum`, `LogResolvent.identityCutoffSum`,
`LogResolvent.identityCutoffTraceLogSub`, `LogResolvent.weightedCutoffSum`,
`LogResolvent.weightedCutoffTraceLogSub`,
`LogResolvent.weightedTraceLogEqShiftSubCutoff`,
`LogResolvent.weightedShiftTraceLogSubScalarLog_tendsto_zero`,
`LogResolvent.weightedCutoffSubScalarLog_tendsto_negTraceLog`,
`LogResolvent.weightedShiftRemainderTendstoZero`, and
`LogResolvent.weightedCutoffRenormTendstoNegTraceLog`. It also exposes
`LogResolvent.SameEigenbasisDiagonal`, `LogResolvent.scalarSquareKernelIntegral`,
`LogResolvent.scalarSquareKernelRemainderTendstoZero`, and
`LogResolvent.sameEigenbasisCutoffRemainderTendstoZero` for the explicit
same-eigenbasis diagonal remainder. This removes that cutoff only in the
same-eigenbasis case; it is not the general two-index weighted cutoff limit.

The inverse-convexity positive-definite segment layer is upstream as
`inv_quadraticForm_affine_le_of_posDef`,
`inv_quadraticForm_iSup_affine_of_posDef`,
`convexCombo_posDef_of_posDef`,
`inv_quadraticForm_convex_combo_le_of_posDef`, and
`inv_matrixLE_convex_combo_le_of_posDef`. These are reusable quadratic-form and
`MatrixLE` segment identities; they do not prove full operator convexity of
inverse, relative-entropy joint convexity, or Lieb concavity.

The relative-entropy route now includes the scalar/diagonal Klein surface,
diagonal-matrix and same-basis `CFC.log` bookkeeping, common-eigenbasis and
overlap-weight spectral expansions, and the full finite-dimensional real matrix
Klein theorem under Hermitian strictly-positive hypotheses:
`RelativeEntropy.fullMatrixKlein_nonneg_of_isHermitian_of_strictlyPositive`,
`RelativeEntropy.kleinInequality_relativeEntropy_nonneg`, and the root alias
`kleinInequality_relativeEntropy_nonneg`. The bridge layer also exposes
`RelativeEntropyJointConvexity`, `GibbsKleinPremise`,
`gibbsVariationalUpperBoundPremise_of_fullMatrixKlein`, and the short facades
`RelativeEntropy.fullKlein_liebCarrierConcavity`, `RelativeEntropy.fullKlein_liebConcavity`, and
`RelativeEntropy.fullKlein_epsteinConcavity`.
This discharges the Gibbs upper-bound premise from full matrix Klein, but still
does not prove relative-entropy joint convexity, Epstein, Lieb, or Tropp.

Interface audit: these migrations give downstream proof agents concrete
finite-dimensional spectral, CFC-log, cutoff-resolvent, inverse-convexity
segment/`MatrixLE`, and full-matrix-Klein relative-entropy handles inside
the main repository. They still do not prove a weighted `CFCLog.lineDeriv` /
`CFCLog.derivSAAt` resolvent-kernel adapter, arbitrary-weight plain cutoff
removal without scalar-log renormalization, relative-entropy joint convexity,
the Epstein second-derivative sign, full Epstein/Lieb, Golden-Thompson,
conditional expectation, variance proxy, tail-event domination, or full
Matrix Bernstein.

The layer also continues to expose derivative-level Epstein consumer reductions,
the explicit `EpsteinAffineLineConcavity` conditional route, bounded
finite-measure integrability providers, natural-history measurability from
suffix-entry measurability, the `TroppNaturalHistory.*` short aliases,
strengthened history/current-step independence from `iIndepFun` plus summand
measurability, identity support domination, spectral endpoint monotonicity,
thin trace-MGF-to-Laplace contracts, and the S16 natural-state tail wrapper
`matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions`.
`CFCLog.DerivOp` remains pointwise derivative bookkeeping only; it is not a
stable second-level Frechet codomain.

## Verification

Run before pushing API or docs changes:

```bash
python .github/scripts/check_text_quality.py
python scripts/judge_policy_check.py
lake build
lake build HighDimProb.Examples
lake test
lake build HighDimProbJudge
```

Last verified locally on 2026-07-05 with the commands above.

## Archive

Completed stage logs, historical blockers, and old milestone notes were reduced
to a short summary in [`archive.md`](archive.md). Keep this file current-facing
only.

- The final-tail/measurability projection surface exposes the direct final-tail measurability provider and H1/H2 provider projections (`shrinkageTheorem1TailWithMeasurability_finalTailMeasurabilityProvider`, `shrinkageTheorem1TailWithMeasurability_h1_provider`, `shrinkageTheorem1TailWithMeasurability_h2_provider`) as deterministic proof-readiness API only.

- The base `ShrinkageTheorem1TailStatement` now mirrors that convenience surface with named projections for providers, H1/H2 providers, lambda positivity, threshold nonnegativity, tail-RHS nonnegativity, and tail bound.


- The theorem-facing `ShrinkageTheorem1ProofReadinessObligations` ledger now exposes named projection theorems for all nine stored obligations; this is deterministic/API plumbing only and adds no probability, concentration, or Theorem 1 proof.

- The paper-RHS-specialized `ShrinkageTheorem1PaperRHSProofReadinessObligations` ledger now mirrors the top-level proof-readiness projection surface with named projections for all stored obligations, including prefactor side conditions and component-tail bound families; this remains projection-only API plumbing.
