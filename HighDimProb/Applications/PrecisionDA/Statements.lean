import HighDimProb.Applications.PrecisionDA.Basic
import HighDimProb.Covariance
import HighDimProb.RandomMatrix.Assumptions
import HighDimProb.RandomMatrix.Spectral

/-!
# PrecisionDA paper-facing stochastic statement vocabulary

This file is a thin statement/provider layer for the stochastic hypotheses used
later in the non-asymptotic data-augmentation route.  It intentionally records
typed assumptions only: no concentration estimate, deterministic equivalent, or
probabilistic proof is introduced here.
-/

namespace HighDimProb
namespace PrecisionDA

open MeasureTheory

noncomputable section

/-- Random version of the paper-oriented `d × n` data matrix. -/
abbrev RandomDataMatrix (Omega : Type*) [MeasurableSpace Omega] (d n : Nat) :=
  RandomMatrix Omega d n

/--
Entrywise independence for a random `d × n` matrix.

For the latent matrix `Z` in paper hypothesis H1 this is the direct Lean
vocabulary for "the entries of `Z` are independent".
-/
def IndependentMatrixEntries {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (P : Measure Omega) (Z : RandomDataMatrix Omega d n) : Prop :=
  ProbabilityTheory.iIndepFun (fun ij : Fin d × Fin n => matrixEntry Z ij.1 ij.2) P

/--
Column/sample independence for a random data matrix.

Columns are the paper's observations `X₁, …, Xₙ`.
-/
def IndependentSampleColumns {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (P : Measure Omega) (X : RandomDataMatrix Omega d n) : Prop :=
  ProbabilityTheory.iIndepFun (fun k : Fin n => colVector X k) P

/-- Columnwise Orlicz subGaussian assumption with common scale `K`. -/
def SubGaussianColumnsOrlicz {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (P : Measure Omega) (X : RandomDataMatrix Omega d n) (K : Real) : Prop :=
  forall k : Fin n, SubGaussianVectorOrlicz P (colVector X k) K

/-- Coordinatewise centeredness of every sample column. -/
def CenteredSampleColumns {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (P : Measure Omega) (X : RandomDataMatrix Omega d n) : Prop :=
  forall k : Fin n, CenteredVector P (colVector X k)

/-- Every sample column has covariance matrix `Sigma`. -/
def SampleColumnCovarianceEquals {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (P : Measure Omega) (X : RandomDataMatrix Omega d n) (Sigma : SquareMatrix d) :
    Prop :=
  forall k : Fin n, covarianceMatrix P (colVector X k) = Sigma

/--
Typed statement wrapper for the paper H1 subGaussian model:
`X = SigmaSqrt * Z`, where `Z` has independent subGaussian entries, and the
observable sample columns of `X` are centered independent columns with
covariance `Sigma`.

This is deliberately a provider contract.  Later probabilistic theorems may
consume the fields they need without unfolding anonymous assumptions.
-/
structure PaperH1SubGaussianModelStatement {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX : Real) : Prop where
  random_data : IsRandomMatrix P X
  latent_random : IsRandomMatrix P Z
  sigma_positive : 0 < sigmaX
  covariance_symmetric : Sigma.IsSymm
  covariance_square_root : SigmaSqrt * SigmaSqrt.transpose = Sigma
  factorization : forall omega : Omega, X omega = SigmaSqrt * Z omega
  latent_centered_entries : CenteredEntries P Z
  latent_independent_entries : IndependentMatrixEntries P Z
  latent_subGaussian_entries : SubGaussianEntriesOrlicz P Z sigmaX
  sample_columns_independent : IndependentSampleColumns P X
  sample_columns_centered : CenteredSampleColumns P X
  sample_column_covariance : SampleColumnCovarianceEquals P X Sigma

/--
Provider wrapper for H1.  This mirrors the provider-contract style used by the
matrix concentration statement layer: downstream results request the provider,
then project its named `h1` field.
-/
structure PaperH1SubGaussianModelProvider {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX : Real) : Prop where
  h1 : PaperH1SubGaussianModelStatement P X Z Sigma SigmaSqrt sigmaX

/--
Semantic lower-bound vocabulary for the leave-one-out sample covariance.

The paper writes the leave-one-out good event as
`lambda_d(C_X^-) >= eta`.  At this layer we use the equivalent Loewner-style
typed predicate `eta I <= C_X^-`, represented as positive semidefiniteness of
`C_X^- - eta I`; no spectral probability estimate is proved here.
-/
def leaveOneOutCovarianceLowerBound {d n : Nat} (X : DataMatrix d n)
    (k : Fin n) (eta : Real) : Prop :=
  (leaveOneOutSampleCovariance X k - eta • (1 : SquareMatrix d)).PosSemidef

/--
Pointwise lower-singular-value core event for paper H2.

This eta-only event records the leave-one-out covariance lower bound before
lambda-dependent resolvent invertibility conditions are added by
`paperH2LeaveOneOutGoodEvent`.
-/
def paperH2LowerSingularValueGoodEvent {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (eta : Real) :
    Set Omega :=
  {omega | forall k : Fin n, leaveOneOutCovarianceLowerBound (X omega) k eta}

/--
Complement event for the eta-only lower-singular-value core of H2.

This is only set vocabulary; it proves no measurability, concentration, or
probability estimate.
-/
def paperH2LowerSingularValueBadEvent {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (eta : Real) :
    Set Omega :=
  {omega | omega ∉ paperH2LowerSingularValueGoodEvent X eta}

/-- Membership rewrite for the eta-only H2 lower-singular-value bad event. -/
theorem paperH2LowerSingularValueBadEvent_mem_iff {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real) (omega : Omega) :
    omega ∈ paperH2LowerSingularValueBadEvent X eta ↔
      omega ∉ paperH2LowerSingularValueGoodEvent X eta := by
  rfl

/-- Set-level complement rewrite for the eta-only H2 lower-singular-value bad event. -/
theorem paperH2LowerSingularValueBadEvent_eq_compl {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real) :
    paperH2LowerSingularValueBadEvent X eta =
      (paperH2LowerSingularValueGoodEvent X eta)ᶜ := by
  rfl

/--
Typed statement wrapper for the eta-only lower-singular-value core of H2.

The probability control of this event remains a later task.
-/
structure PaperH2LowerSingularValueStatement {Omega : Type*}
    [MeasurableSpace Omega] (_P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real) : Prop where
  eta_positive : 0 < eta
  good_event : forall omega : Omega, omega ∈ paperH2LowerSingularValueGoodEvent X eta

/--
Provider wrapper for the eta-only lower-singular-value core event.

The name intentionally differs from `PaperH2LowerSingularValueProvider`, which is
a probability proof-entry shell carrying the H2 bad-event probability fields.
-/
structure PaperH2LowerSingularValueEventProvider {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real) : Prop where
  h2_lower_singular_value : PaperH2LowerSingularValueStatement P X eta

/--
Pointwise H2 good-event set for the PrecisionDA leave-one-out route.

This is the typed `A_eta` vocabulary plus the deterministic invertibility
providers consumed by the already-proved resolvent/Woodbury backend.  The
probability bound `P(A_etaᶜ) <= ...` is intentionally not part of this object.
-/
def paperH2LeaveOneOutGoodEvent {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (eta lam : Real) :
    Set Omega :=
  {omega |
    forall k : Fin n,
      leaveOneOutCovarianceLowerBound (X omega) k eta /\
        IsUnit (shrinkageShiftedMatrix (X omega) lam).det /\
          IsUnit (leaveOneOutShiftedMatrix (X omega) k lam).det /\
            shrinkageLeaveOneOutWoodburyDenominator (X omega) k lam ≠ 0}

/--
Typed statement wrapper for H2's leave-one-out good event.

It records positivity of the threshold `eta` and assumes the pointwise event
for every sample outcome.  High-probability control of this event is a later
provider task and is not proved or stated here.
-/
structure PaperH2LeaveOneOutGoodEventStatement {Omega : Type*}
    [MeasurableSpace Omega] (_P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real) : Prop where
  eta_positive : 0 < eta
  good_event : forall omega : Omega, omega ∈ paperH2LeaveOneOutGoodEvent X eta lam

/-- Provider wrapper for the H2 leave-one-out good-event statement. -/
structure PaperH2LeaveOneOutGoodEventProvider {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real) : Prop where
  h2 : PaperH2LeaveOneOutGoodEventStatement P X eta lam

/--
Paper H2 good-event probability RHS placeholder.

This is the scalar right-hand side for a future bound on the complement of the
H2 leave-one-out good event.  The paper's closed-form concentration expression
and its proof are deliberately outside this typed API surface.
-/
abbrev PaperH2GoodEventProbabilityRHS : Type := Real

/--
Complement event for the H2 leave-one-out good event.

This is only the event vocabulary consumed by future probability-provider
contracts.  No measurability or probability estimate is proved here.
-/
def paperH2LeaveOneOutBadEvent {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (eta lam : Real) :
    Set Omega :=
  {omega | omega ∉ paperH2LeaveOneOutGoodEvent X eta lam}

/--
Membership rewrite for the H2 leave-one-out bad event.

This is only the definitional complement of `paperH2LeaveOneOutGoodEvent`;
it does not prove measurability or any probability estimate.
-/
theorem paperH2LeaveOneOutBadEvent_mem_iff {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real) (omega : Omega) :
    omega ∈ paperH2LeaveOneOutBadEvent X eta lam ↔
      omega ∉ paperH2LeaveOneOutGoodEvent X eta lam := by
  rfl

/--
Set-level complement rewrite for the H2 leave-one-out bad event.

This is only the definitional complement of `paperH2LeaveOneOutGoodEvent`;
it does not prove measurability or any probability estimate.
-/
theorem paperH2LeaveOneOutBadEvent_eq_compl {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real) :
    paperH2LeaveOneOutBadEvent X eta lam =
      (paperH2LeaveOneOutGoodEvent X eta lam)ᶜ := by
  rfl

/--
Measurability provider for the H2 leave-one-out bad event.

This records only the explicit measurable-event side condition for
`paperH2LeaveOneOutBadEvent`.  It does not prove measurability or provide a
probability estimate.
-/
structure PaperH2LeaveOneOutBadEventMeasurabilityProvider {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real) : Prop where
  bad_event_measurable : MeasurableSet (paperH2LeaveOneOutBadEvent X eta lam)

/--
Projection theorem for the H2 bad-event measurability provider.

This only exposes the provider field as a theorem; it does not prove
measurability from primitive assumptions.
-/
theorem paperH2LeaveOneOutBadEvent_measurable_of_provider {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (h : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam) :
    MeasurableSet (paperH2LeaveOneOutBadEvent X eta lam) :=
  h.bad_event_measurable

/--
Typed statement wrapper for a future H2 good-event probability estimate.

It records only the proof-entry contract: positive `eta`, a nonnegative scalar
RHS, and an explicit probability inequality for the bad event.  The inequality
is a field supplied by downstream probabilistic work; it is not derived from
H1, H2, concentration, or deterministic equivalents in this file.
-/
structure PaperH2LeaveOneOutGoodEventProbabilityStatement {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS) : Prop where
  eta_positive : 0 < eta
  rhs_nonnegative : 0 <= rhs
  bad_event_probability :
    P (paperH2LeaveOneOutBadEvent X eta lam) <= ENNReal.ofReal rhs

/--
Provider wrapper for the H2 good-event probability statement.

This keeps probability discharge as a named provider contract while preserving
the existing pointwise H2 good-event provider as a separate assumption surface.
-/
structure PaperH2LeaveOneOutGoodEventProbabilityProvider {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS) : Prop where
  h2_probability : PaperH2LeaveOneOutGoodEventProbabilityStatement P X eta lam rhs

/--
Projection theorem for the H2 good-event probability provider.

This only exposes the provider field as a theorem; it does not prove the
probability estimate or identify the scalar RHS.
-/
theorem paperH2LeaveOneOutGoodEventProbabilityStatement_of_provider {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LeaveOneOutGoodEventProbabilityProvider P X eta lam rhs) :
    PaperH2LeaveOneOutGoodEventProbabilityStatement P X eta lam rhs :=
  h.h2_probability

/--
Projection theorem for the H2 bad-event probability bound.

This only threads the already supplied probability provider field; it does not
prove a probability bound, concentration inequality, or closed-form RHS.
-/
theorem paperH2LeaveOneOutGoodEventProbability_bound_of_provider {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LeaveOneOutGoodEventProbabilityProvider P X eta lam rhs) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <= ENNReal.ofReal rhs :=
  h.h2_probability.bad_event_probability

/--
Downstream consumer statement for the H2 bad-event probability surface.

This combines the separately supplied bad-event measurability provider and H2
probability provider into one consumer-facing statement.  Its fields are only
projections of explicit provider assumptions; it does not prove measurability,
the probability estimate, concentration, Theorem 1, or a closed-form RHS.
-/
structure PaperH2LeaveOneOutProbabilityConsumerStatement {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS) : Prop where
  bad_event_measurable : MeasurableSet (paperH2LeaveOneOutBadEvent X eta lam)
  h2_probability : PaperH2LeaveOneOutGoodEventProbabilityStatement P X eta lam rhs
  bad_event_probability :
    P (paperH2LeaveOneOutBadEvent X eta lam) <= ENNReal.ofReal rhs

/--
Provider-to-consumer projection for the H2 bad-event probability surface.

This only packages fields from the explicit measurability and probability
providers into a downstream consumer statement.
-/
theorem paperH2LeaveOneOutProbabilityConsumerStatement_of_providers {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (hProb : PaperH2LeaveOneOutGoodEventProbabilityProvider P X eta lam rhs) :
    PaperH2LeaveOneOutProbabilityConsumerStatement P X eta lam rhs where
  bad_event_measurable := hMeas.bad_event_measurable
  h2_probability := hProb.h2_probability
  bad_event_probability := hProb.h2_probability.bad_event_probability

/--
Projection theorem for the H2 probability consumer's bound field.

This exposes the already supplied probability-provider field after pairing it
with bad-event measurability. It does not prove a probability estimate.
-/
theorem paperH2LeaveOneOutProbabilityConsumer_bound_of_providers {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (hProb : PaperH2LeaveOneOutGoodEventProbabilityProvider P X eta lam rhs) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <= ENNReal.ofReal rhs :=
  (paperH2LeaveOneOutProbabilityConsumerStatement_of_providers
    P X eta lam rhs hMeas hProb).bad_event_probability

/--
Minimal proof-entry provider for a future lower-singular-value discharge of H2.

The intended downstream theorem will eventually derive these fields from
lower-singular-value/concentration inputs.  At this layer the fields are only
explicit assumptions: bad-event measurability, positivity/nonnegativity side
conditions, and the H2 bad-event probability bound.  No singular-value theorem,
concentration estimate, or measurability proof is introduced here.
-/
structure PaperH2LowerSingularValueProvider {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS) : Prop where
  eta_positive : 0 < eta
  rhs_nonnegative : 0 <= rhs
  bad_event_measurable : MeasurableSet (paperH2LeaveOneOutBadEvent X eta lam)
  bad_event_probability :
    P (paperH2LeaveOneOutBadEvent X eta lam) <= ENNReal.ofReal rhs

/--
Projection from the lower-singular-value H2 provider shell to the existing
bad-event measurability provider.

This only repackages an explicit field; it does not prove measurability.
-/
theorem paperH2LeaveOneOutBadEventMeasurabilityProvider_of_lowerSingularValueProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LowerSingularValueProvider P X eta lam rhs) :
    PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam where
  bad_event_measurable := h.bad_event_measurable

/--
Projection from the lower-singular-value H2 provider shell to the existing
H2 good-event probability provider.

This only repackages explicit fields; it does not prove the probability bound
from lower-singular-value or concentration arguments.
-/
theorem paperH2LeaveOneOutGoodEventProbabilityProvider_of_lowerSingularValueProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LowerSingularValueProvider P X eta lam rhs) :
    PaperH2LeaveOneOutGoodEventProbabilityProvider P X eta lam rhs where
  h2_probability := {
    eta_positive := h.eta_positive
    rhs_nonnegative := h.rhs_nonnegative
    bad_event_probability := h.bad_event_probability }

/--
Consumer statement built from the lower-singular-value H2 provider shell.

This threads the shell through the already existing H2 measurability and
probability provider projections.  It proves no lower-singular-value,
concentration, measurability, or probability estimate.
-/
theorem paperH2LeaveOneOutProbabilityConsumerStatement_of_lowerSingularValueProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LowerSingularValueProvider P X eta lam rhs) :
    PaperH2LeaveOneOutProbabilityConsumerStatement P X eta lam rhs :=
  paperH2LeaveOneOutProbabilityConsumerStatement_of_providers
    P X eta lam rhs
      (paperH2LeaveOneOutBadEventMeasurabilityProvider_of_lowerSingularValueProvider
        P X eta lam rhs h)
      (paperH2LeaveOneOutGoodEventProbabilityProvider_of_lowerSingularValueProvider
        P X eta lam rhs h)

/--
Minimal provider bundle for the paper's shrinkage Theorem 1 route.

This only ties together the already-typed H1 and H2 provider contracts.  It
does not state or prove the theorem's probability bound, concentration input,
or deterministic-equivalent estimate.
-/
structure ShrinkageTheorem1Providers {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) : Prop where
  h1 : PaperH1SubGaussianModelProvider P X Z Sigma SigmaSqrt sigmaX
  h2 : PaperH2LeaveOneOutGoodEventProvider P X eta lam

/--
Paper Theorem 1 additive bias placeholder.

The paper denotes this term by `Delta_X(lambda)`.  At this statement layer it
is only a named real parameter, not a proved deterministic-equivalent bound.
-/
abbrev ShrinkageTheorem1BiasTerm : Type := Real

/--
Paper Theorem 1 tail RHS placeholder.

This is the scalar right-hand side of the probability bound.  The exponential
form and its constants are later provider work, so the statement skeleton keeps
it as an explicit real parameter.
-/
abbrev ShrinkageTheorem1TailRHS : Type := Real

/--
Paper-facing tail RHS vocabulary for shrinkage Theorem 1.

The paper's displayed RHS depends on model-spectrum/tail parameters.  At
this layer it is only a named evaluator slot; no exponential formula, constants,
or probability estimate are proved here.
-/
abbrev PaperShrinkageTailRHS (_d _n : Nat) : Type :=
  Real -> Real -> Real -> Real -> ShrinkageTheorem1TailRHS

/-- Evaluate a paper-side shrinkage Theorem 1 RHS slot. -/
def paperShrinkageTailRHS {d n : Nat} (rhs : PaperShrinkageTailRHS d n)
    (lambdaMinSigma sigmaX eta t : Real) : ShrinkageTheorem1TailRHS :=
  rhs lambdaMinSigma sigmaX eta t

/--
Provider placeholder connecting a named paper RHS evaluator to the scalar RHS
used by the tail statement.

This records only identification and nonnegativity of the RHS value.  It does
not prove the paper's probability inequality, construct the closed-form RHS, or
derive concentration/deterministic-equivalent estimates.
-/
structure ShrinkageTheorem1PaperTailRHSProvider {d n : Nat}
    (rhs : PaperShrinkageTailRHS d n) (lambdaMinSigma sigmaX eta t : Real)
    (tailRHS : ShrinkageTheorem1TailRHS) : Prop where
  rhs_identifies_tail : tailRHS = paperShrinkageTailRHS rhs lambdaMinSigma sigmaX eta t
  rhs_nonnegative : 0 <= tailRHS

/--
Paper-facing name for the true shrinkage precision error `E_X(lambda)`.

This reuses the deterministic Frobenius error already defined in the algebraic
layer.  It is only a naming bridge for the paper statement vocabulary.
-/
def paperShrinkageError {d n : Nat} (X : DataMatrix d n)
    (SigmaInv : SquareMatrix d) (lam : Real) : Real :=
  shrinkageQuadraticError X SigmaInv lam

/-- Random lift of `paperShrinkageError`, pointwise in the sample outcome. -/
def randomPaperShrinkageError {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n)
    (SigmaInv : SquareMatrix d) (lam : Real) : Omega -> Real :=
  fun omega => paperShrinkageError (X omega) SigmaInv lam

/--
Paper-facing estimator vocabulary for `hat E_X(lambda)`.

The paper formula is intentionally not encoded at this layer.  This type names a
data-computable estimator slot that later deterministic-equivalent/provider work
can instantiate.
-/
abbrev PaperShrinkageEstimator (d n : Nat) : Type :=
  DataMatrix d n -> Real -> Real

/--
Paper-facing bias vocabulary for `Delta_X(lambda)`.

This is a data/lambda dependent real-valued slot.  Bounds or formula
identification for this slot are later provider tasks.
-/
abbrev PaperShrinkageBias (d n : Nat) : Type :=
  DataMatrix d n -> Real -> Real

/-- Evaluate a paper shrinkage estimator `hat E_X(lambda)`. -/
def paperShrinkageEstimatedError {d n : Nat} (estimator : PaperShrinkageEstimator d n)
    (X : DataMatrix d n) (lam : Real) : Real :=
  estimator X lam

/-- Evaluate the paper bias placeholder `Delta_X(lambda)`. -/
def paperShrinkageBiasTerm {d n : Nat} (bias : PaperShrinkageBias d n)
    (X : DataMatrix d n) (lam : Real) : ShrinkageTheorem1BiasTerm :=
  bias X lam

/-- Random lift of `paperShrinkageEstimatedError`, pointwise in the sample outcome. -/
def randomPaperShrinkageEstimatedError {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n)
    (estimator : PaperShrinkageEstimator d n) (lam : Real) : Omega -> Real :=
  fun omega => paperShrinkageEstimatedError estimator (X omega) lam

/-- Random lift of `paperShrinkageBiasTerm`, pointwise in the sample outcome. -/
def randomPaperShrinkageBiasTerm {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n)
    (bias : PaperShrinkageBias d n) (lam : Real) : Omega -> ShrinkageTheorem1BiasTerm :=
  fun omega => paperShrinkageBiasTerm bias (X omega) lam

/--
Pointwise control provider for the paper bias/slack `Delta_X(lambda)`.

The bias function is a parameter of the provider so this remains a `Prop`-valued
assumption with proof projections only.  It records the minimal pointwise
nonnegativity needed by the additive tail-event threshold; it does not identify
or bound the bias formula.
-/
structure PaperShrinkageBiasControlProvider {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (lam : Real)
    (bias : PaperShrinkageBias d n) : Prop where
  pointwise_nonneg :
    forall omega : Omega, 0 <= paperShrinkageBiasTerm bias (X omega) lam

/--
Paper-facing tail event using the named `E_X(lambda)`, `hat E_X(lambda)`, and
`Delta_X(lambda)` vocabulary.

The bias/slack is evaluated pointwise from the supplied `PaperShrinkageBias`
slot.  This wrapper only records the event shape; it proves no probability or
concentration estimate.
-/
def shrinkageTheorem1PaperTailEvent {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (lam t : Real) : Set Omega :=
  {omega |
    |paperShrinkageError (X omega) SigmaInv lam -
        paperShrinkageEstimatedError estimator (X omega) lam| >=
      t + paperShrinkageBiasTerm bias (X omega) lam}

/--
Measurability provider for the paper-facing shrinkage Theorem 1 tail event.

This is only a typed assumption for the event
`shrinkageTheorem1PaperTailEvent`; it does not prove measurability, construct
measurable estimator/bias functions, or supply any probability bound.
-/
structure ShrinkageTheorem1PaperTailMeasurabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (lam t : Real) : Prop where
  tail_event_measurable :
    MeasurableSet (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t)

/--
Bundled provider surface for the paper-facing shrinkage Theorem 1 tail route.

This collects the already separate H1/H2 core provider, paper RHS provider,
pointwise bias-control provider, and tail-event measurability provider.  It does
not prove the probability bound or any of the provider fields.
-/
structure ShrinkageTheorem1PaperTailProviders
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (bias : PaperShrinkageBias d n) (t : Real)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS) : Prop where
  core : ShrinkageTheorem1Providers P X Z Sigma SigmaSqrt sigmaX eta lam
  rhs :
    ShrinkageTheorem1PaperTailRHSProvider paperTailRHS lambdaMinSigma sigmaX eta t
      tailRHS
  bias_control : PaperShrinkageBiasControlProvider X lam bias
  measurability :
    ShrinkageTheorem1PaperTailMeasurabilityProvider X SigmaInv estimator bias lam t

/--
Thin paper-tail consumer projection for the H2 good-event probability provider.

This threads an explicitly supplied H2 probability provider alongside the
existing paper-tail provider bundle. It preserves the bundle shape and does not
prove the H2 probability estimate, bad-event measurability, concentration,
Theorem 1, or a closed-form RHS.
-/
theorem shrinkageTheorem1PaperTailH2Probability_of_providers {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (_providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (h2_probability :
      PaperH2LeaveOneOutGoodEventProbabilityProvider P X eta lam h2ProbabilityRHS) :
    PaperH2LeaveOneOutGoodEventProbabilityProvider P X eta lam h2ProbabilityRHS :=
  h2_probability

/--
Thin paper-tail projection for the H2 probability consumer statement.

This threads explicit H2 bad-event measurability and probability providers
alongside the existing paper-tail provider bundle, then packages them into the
combined `PaperH2LeaveOneOutProbabilityConsumerStatement`. It preserves the
paper-tail bundle shape and does not prove measurability, the H2 probability
estimate, concentration, Theorem 1, or a closed-form RHS.
-/
theorem shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_providers
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (_providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (hProb : PaperH2LeaveOneOutGoodEventProbabilityProvider P X eta lam h2ProbabilityRHS) :
    PaperH2LeaveOneOutProbabilityConsumerStatement P X eta lam h2ProbabilityRHS :=
  paperH2LeaveOneOutProbabilityConsumerStatement_of_providers
    P X eta lam h2ProbabilityRHS hMeas hProb

/--
Short-name alias for the paper-tail H2 probability consumer statement wrapper.
-/
theorem shrinkageTheorem1PaperTailH2ProbabilityConsumer_of_providers {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (hProb : PaperH2LeaveOneOutGoodEventProbabilityProvider P X eta lam h2ProbabilityRHS) :
    PaperH2LeaveOneOutProbabilityConsumerStatement P X eta lam h2ProbabilityRHS :=
  shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_providers
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      h2ProbabilityRHS paperTailRHS lambdaMinSigma tailRHS providers hMeas hProb

/--
Projection of the bad-event probability bound from the paper-tail H2 consumer.

This only exposes the `bad_event_probability` field after threading the
paper-tail provider bundle together with explicit H2 measurability and
probability providers. It proves no probability estimate or measurability fact.
-/
theorem shrinkageTheorem1PaperTailH2ProbabilityConsumer_badEventProbability_of_providers
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (hProb : PaperH2LeaveOneOutGoodEventProbabilityProvider P X eta lam h2ProbabilityRHS) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <= ENNReal.ofReal h2ProbabilityRHS :=
  (shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_providers
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      h2ProbabilityRHS paperTailRHS lambdaMinSigma tailRHS providers hMeas hProb).bad_event_probability

/--
Paper-facing shrinkage Theorem 1 tail statement wrapper.

This is the named-vocabulary version of `ShrinkageTheorem1TailStatement`: it
threads the paper error, estimator, and bias/slack slots into a tail event while
keeping the H1/H2 provider bundle and probability-bound conclusion explicit. It
is not a proof of Theorem 1 and does not construct the estimator, bias/slack, or
RHS bound.
-/
structure ShrinkageTheorem1PaperTailStatement {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (bias : PaperShrinkageBias d n) (t : Real)
    (tailRHS : ShrinkageTheorem1TailRHS) : Prop where
  providers : ShrinkageTheorem1Providers P X Z Sigma SigmaSqrt sigmaX eta lam
  lambda_positive : 0 < lam
  threshold_nonnegative : 0 <= t
  tail_rhs_nonnegative : 0 <= tailRHS
  tail_bound :
    P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) <=
      ENNReal.ofReal tailRHS

/--
Thin deterministic/API bridge from the bundled paper-tail provider surface to
the paper-facing statement wrapper.

The actual probability estimate remains an explicit `tail_bound` input.  This
theorem only threads provider fields and reuses the RHS provider's
nonnegativity field.
-/
theorem shrinkageTheorem1PaperTailStatement_of_providers {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (bias : PaperShrinkageBias d n) (t : Real)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam
        estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (lambda_positive : 0 < lam) (threshold_nonnegative : 0 <= t)
    (tail_bound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) <=
        ENNReal.ofReal tailRHS) :
    ShrinkageTheorem1PaperTailStatement P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam
      estimator bias t tailRHS where
  providers := providers.core
  lambda_positive := lambda_positive
  threshold_nonnegative := threshold_nonnegative
  tail_rhs_nonnegative := providers.rhs.rhs_nonnegative
  tail_bound := tail_bound

/--
The paper-facing tail event shape for shrinkage Theorem 1.

`trueError` represents the paper's `E_X(lambda)`, `estimatedError` represents
the data-computable estimator, and `bias` is the additive `Delta_X(lambda)`
placeholder.  This object only records the event shape.
-/
def shrinkageTheorem1TailEvent {Omega : Type*} (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm) (t : Real) : Set Omega :=
  {omega | |trueError omega - estimatedError omega| >= t + bias}

/--
Typed statement skeleton for the paper's shrinkage Theorem 1 tail route.

The statement consumes the minimal H1/H2 provider bundle and records the shape
of the probability tail conclusion with explicit bias/RHS placeholders.  It is
not a proof of the theorem and does not construct the RHS, bias term,
concentration estimate, or deterministic equivalent.
-/
structure ShrinkageTheorem1TailStatement {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS) : Prop where
  providers : ShrinkageTheorem1Providers P X Z Sigma SigmaSqrt sigmaX eta lam
  lambda_positive : 0 < lam
  threshold_nonnegative : 0 <= t
  tail_rhs_nonnegative : 0 <= tailRHS
  tail_bound :
    P (shrinkageTheorem1TailEvent trueError estimatedError bias t) <= ENNReal.ofReal tailRHS

end

end PrecisionDA
end HighDimProb
