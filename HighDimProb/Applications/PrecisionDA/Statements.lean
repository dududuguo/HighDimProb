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
Direct projection of the eta positivity assumption from the eta-only H2
lower-singular-value statement.

This theorem is API glue only: it proves no singular-value or probability
estimate.
-/
theorem PaperH2LowerSingularValueStatement_eta_positive
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueStatement P X eta) :
    0 < eta :=
  h.eta_positive

/--
Direct projection of the pointwise good-event field from the eta-only H2
lower-singular-value statement.

This theorem is API glue only: it proves no singular-value or probability
estimate.
-/
theorem PaperH2LowerSingularValueStatement_good_event
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueStatement P X eta) :
    forall omega : Omega, omega ∈ paperH2LowerSingularValueGoodEvent X eta :=
  h.good_event

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
Project the eta-only H2 lower-singular-value statement from its event provider.

This theorem is API glue only: it proves no singular-value or probability
estimate.
-/
theorem paperH2LowerSingularValueEventProvider_h2_lower_singular_value
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueEventProvider P X eta) :
    PaperH2LowerSingularValueStatement P X eta :=
  h.h2_lower_singular_value

/--
Direct eta-positivity projection from the pointwise lower-singular-value event
provider.

This is provider-field API only; it proves no lower-singular-value estimate,
probability, or concentration bound.
-/
theorem paperH2LowerSingularValueEventProvider_eta_positive
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueEventProvider P X eta) :
    0 < eta :=
  PaperH2LowerSingularValueStatement_eta_positive P X eta
    (paperH2LowerSingularValueEventProvider_h2_lower_singular_value P X eta h)

/--
The pointwise eta-only lower-singular-value statement makes the good event the
whole sample space.

This is pure event algebra: it consumes the explicit statement field and proves
no probability or concentration estimate.
-/
theorem paperH2LowerSingularValueGoodEvent_eq_univ_of_statement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueStatement P X eta) :
    paperH2LowerSingularValueGoodEvent X eta = Set.univ := by
  ext omega
  constructor
  · intro _
    trivial
  · intro _
    exact h.good_event omega

/--
Project the event-provider version of the eta-only lower-singular-value good
event equality.

This is pure API glue: it proves no singular-value, probability, or
concentration estimate.
-/
theorem paperH2LowerSingularValueGoodEvent_eq_univ_of_eventProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueEventProvider P X eta) :
    paperH2LowerSingularValueGoodEvent X eta = Set.univ :=
  paperH2LowerSingularValueGoodEvent_eq_univ_of_statement P X eta
    (paperH2LowerSingularValueEventProvider_h2_lower_singular_value P X eta h)

/--
Project pointwise membership in the eta-only lower-singular-value good event
from the event provider.

This is pure API glue and does not prove the provider itself.
-/
theorem paperH2LowerSingularValueGoodEvent_mem_of_eventProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueEventProvider P X eta) (omega : Omega) :
    omega ∈ paperH2LowerSingularValueGoodEvent X eta :=
  (paperH2LowerSingularValueEventProvider_h2_lower_singular_value P X eta h).good_event omega

/--
The pointwise eta-only lower-singular-value statement makes the eta-only bad
event empty.

This is only the complement of
`paperH2LowerSingularValueGoodEvent_eq_univ_of_statement`.
-/
theorem paperH2LowerSingularValueBadEvent_eq_empty_of_statement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueStatement P X eta) :
    paperH2LowerSingularValueBadEvent X eta = ∅ := by
  rw [paperH2LowerSingularValueBadEvent_eq_compl X eta,
    paperH2LowerSingularValueGoodEvent_eq_univ_of_statement P X eta h]
  simp

/--
The eta-only lower-singular-value bad event has zero measure under the
pointwise lower-singular-value statement.

This is a deterministic empty-event consequence, not a concentration bound.
-/
theorem paperH2LowerSingularValueBadEvent_measure_eq_zero_of_statement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueStatement P X eta) :
    P (paperH2LowerSingularValueBadEvent X eta) = 0 := by
  rw [paperH2LowerSingularValueBadEvent_eq_empty_of_statement P X eta h]
  simp

/--
Provider-form empty-event wrapper for the eta-only lower-singular-value bad
event.
-/
theorem paperH2LowerSingularValueBadEvent_eq_empty_of_eventProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueEventProvider P X eta) :
    paperH2LowerSingularValueBadEvent X eta = ∅ :=
  paperH2LowerSingularValueBadEvent_eq_empty_of_statement
    P X eta h.h2_lower_singular_value

/--
Provider-form zero-measure wrapper for the eta-only lower-singular-value bad
event.
-/
theorem paperH2LowerSingularValueBadEvent_measure_eq_zero_of_eventProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueEventProvider P X eta) :
    P (paperH2LowerSingularValueBadEvent X eta) = 0 :=
  paperH2LowerSingularValueBadEvent_measure_eq_zero_of_statement
    P X eta h.h2_lower_singular_value

/--
Atomic H2 resolvent event: the full shrinkage shifted matrix determinant is a
unit.

This is named vocabulary only.  It does not prove that the event is measurable.
-/
def paperH2ShrinkageShiftedDetUnitEvent {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (lam : Real) :
    Set Omega :=
  {omega | IsUnit (shrinkageShiftedMatrix (X omega) lam).det}

/--
Atomic H2 resolvent event: the `k`-th leave-one-out shifted matrix determinant
is a unit.

This is named vocabulary only.  It does not prove that the event is measurable.
-/
def paperH2LeaveOneOutShiftedDetUnitEvent {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real) :
    Set Omega :=
  {omega | IsUnit (leaveOneOutShiftedMatrix (X omega) k lam).det}

/--
Atomic H2 resolvent bad event: the full shrinkage shifted matrix determinant is
not a unit.

This is only the complement vocabulary for the corresponding determinant-unit
event.  It proves no measurability or probability estimate.
-/
def paperH2ShrinkageShiftedDetBadEvent {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (lam : Real) :
    Set Omega :=
  {omega | omega ∉ paperH2ShrinkageShiftedDetUnitEvent X lam}

/--
Atomic H2 resolvent bad event: the `k`-th leave-one-out shifted determinant is
not a unit.

This is only the complement vocabulary for the corresponding determinant-unit
event.  It proves no measurability or probability estimate.
-/
def paperH2LeaveOneOutShiftedDetBadEvent {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real) :
    Set Omega :=
  {omega | omega ∉ paperH2LeaveOneOutShiftedDetUnitEvent X k lam}

/-- Set-level complement rewrite for the full shifted determinant bad event. -/
theorem paperH2ShrinkageShiftedDetBadEvent_eq_compl {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) :
    paperH2ShrinkageShiftedDetBadEvent X lam =
      (paperH2ShrinkageShiftedDetUnitEvent X lam)ᶜ := by
  rfl

/-- Set-level complement rewrite for a leave-one-out shifted determinant bad event. -/
theorem paperH2LeaveOneOutShiftedDetBadEvent_eq_compl {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real) :
    paperH2LeaveOneOutShiftedDetBadEvent X k lam =
      (paperH2LeaveOneOutShiftedDetUnitEvent X k lam)ᶜ := by
  rfl

/--
Measurability of the named full shrinkage shifted determinant-unit event from
measurability of its real-valued determinant.

This is the scalar `IsUnit ↔ det ≠ 0` Borel/preimage step only.  It does not
prove determinant measurability from random-matrix entry measurability.
-/
theorem paperH2ShrinkageShiftedDetUnitEvent_measurable_of_det_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (hDet :
      Measurable fun omega : Omega =>
        (shrinkageShiftedMatrix (X omega) lam).det) :
    MeasurableSet (paperH2ShrinkageShiftedDetUnitEvent X lam) := by
  have hzero :
      MeasurableSet
        ((fun omega : Omega =>
          (shrinkageShiftedMatrix (X omega) lam).det) ⁻¹'
            ({0} : Set Real)) :=
    hDet (isClosed_singleton.measurableSet : MeasurableSet ({0} : Set Real))
  have hzero' :
      MeasurableSet
        {omega : Omega | (shrinkageShiftedMatrix (X omega) lam).det = 0} := by
    simpa [Set.preimage, Set.mem_singleton_iff] using hzero
  simpa [paperH2ShrinkageShiftedDetUnitEvent, Set.compl_setOf, isUnit_iff_ne_zero]
    using hzero'.compl

/--
Measurability of the named leave-one-out shifted determinant-unit event from
measurability of its real-valued determinant.

This is the scalar `IsUnit ↔ det ≠ 0` Borel/preimage step only.  It does not
prove determinant measurability from random-matrix entry measurability.
-/
theorem paperH2LeaveOneOutShiftedDetUnitEvent_measurable_of_det_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (hDet :
      Measurable fun omega : Omega =>
        (leaveOneOutShiftedMatrix (X omega) k lam).det) :
    MeasurableSet (paperH2LeaveOneOutShiftedDetUnitEvent X k lam) := by
  have hzero :
      MeasurableSet
        ((fun omega : Omega =>
          (leaveOneOutShiftedMatrix (X omega) k lam).det) ⁻¹'
            ({0} : Set Real)) :=
    hDet (isClosed_singleton.measurableSet : MeasurableSet ({0} : Set Real))
  have hzero' :
      MeasurableSet
        {omega : Omega | (leaveOneOutShiftedMatrix (X omega) k lam).det = 0} := by
    simpa [Set.preimage, Set.mem_singleton_iff] using hzero
  simpa [paperH2LeaveOneOutShiftedDetUnitEvent, Set.compl_setOf, isUnit_iff_ne_zero]
    using hzero'.compl

/--
Measurability of a square-matrix determinant from entrywise measurability.

This is the generic finite-dimensional bridge used by H2 resolvent determinant
events.  It packages two product-measurability steps for the matrix-valued map
and then composes with continuity of `Matrix.det`.
-/
theorem squareMatrix_det_measurable_of_entry_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d : Nat}
    (A : Omega -> SquareMatrix d)
    (hA : ∀ i j : Fin d, Measurable fun omega : Omega => A omega i j) :
    Measurable fun omega : Omega => (A omega).det := by
  have hA_meas : Measurable A := by
    change Measurable fun omega => fun i : Fin d => fun j : Fin d => A omega i j
    exact measurable_pi_lambda (fun omega i => fun j : Fin d => A omega i j) fun i =>
      measurable_pi_lambda (fun omega j => A omega i j) fun j => hA i j
  have hdet_cont : Continuous fun M : SquareMatrix d => M.det := by
    simpa [SquareMatrix] using
      (Continuous.matrix_det (A := fun M : Matrix (Fin d) (Fin d) Real => M) continuous_id)
  exact hdet_cont.measurable.comp hA_meas

/--
Entrywise measurability of the total nonsingular-inverse operation for finite
real square matrices.

Mathlib's matrix inverse is the adjugate scaled by the reciprocal determinant,
and is defined as zero on singular matrices.  This theorem is therefore a pure
measurability bridge: it assumes only entrywise measurability of `A` and proves
entrywise measurability of `A⁻¹`; it does not prove any invertibility fact.
-/
theorem squareMatrix_inv_entry_measurable_of_entry_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d : Nat}
    (A : Omega -> SquareMatrix d)
    (hA : ∀ i j : Fin d, Measurable fun omega : Omega => A omega i j) :
    ∀ i j : Fin d,
      Measurable fun omega : Omega => (A omega)⁻¹ i j := by
  intro i j
  rw [show (fun omega : Omega => (A omega)⁻¹ i j) =
      fun omega : Omega => ((A omega).det)⁻¹ * (A omega).adjugate i j by
    funext omega
    simp [Matrix.inv_def, Ring.inverse_eq_inv]]
  exact (squareMatrix_det_measurable_of_entry_measurable A hA).inv.mul (by
    rw [show (fun omega : Omega => (A omega).adjugate i j) =
        fun omega : Omega => ((A omega).updateRow j (Pi.single i 1)).det by
      funext omega
      rw [Matrix.adjugate_apply]]
    exact squareMatrix_det_measurable_of_entry_measurable
      (fun omega : Omega => (A omega).updateRow j (Pi.single i 1))
      (fun r c => by
        change Measurable fun omega : Omega =>
          (A omega).updateRow j (Pi.single i 1) r c
        by_cases hr : r = j
        · subst hr
          simp
        · simpa [Matrix.updateRow, hr] using hA r c))

/--
Entrywise measurability of the full shrinkage shifted matrix from entrywise
measurability of the random data matrix.

This is a finite algebra/measurability bridge for the `C_X + λI` entries only;
it proves no determinant-unit, inverse, Woodbury-denominator, or probability
fact.
-/
theorem shrinkageShiftedMatrix_entry_measurable_of_data_entry_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (hX : ∀ i : Fin d, ∀ k : Fin n,
      Measurable fun omega : Omega => X omega i k) :
    ∀ i j : Fin d,
      Measurable fun omega : Omega => (shrinkageShiftedMatrix (X omega) lam) i j := by
  intro i j
  simp [shrinkageShiftedMatrix, shiftedMatrix, sampleCovariance, Matrix.mul_apply]
  exact (measurable_const.mul
    (Finset.measurable_sum _ fun k _ => (hX i k).mul (hX j k))).add measurable_const

/--
Entrywise measurability of each leave-one-out shifted matrix from entrywise
measurability of the random data matrix.

This is the finite-sum counterpart for `C_X^{(-k)} + λI`; it still leaves
inverse/resolvent and Woodbury-denominator measurability to later providers.
-/
theorem leaveOneOutShiftedMatrix_entry_measurable_of_data_entry_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (hX : ∀ i : Fin d, ∀ k : Fin n,
      Measurable fun omega : Omega => X omega i k) :
    ∀ i j : Fin d,
      Measurable fun omega : Omega =>
        (leaveOneOutShiftedMatrix (X omega) k lam) i j := by
  intro i j
  simp [leaveOneOutShiftedMatrix, shiftedMatrix, leaveOneOutSampleCovariance]
  exact (measurable_const.mul
    ((Finset.measurable_sum _ fun l _ => (hX i l).mul (hX j l)).sub
      ((hX i k).mul (hX j k)))).add measurable_const

/--
Entrywise measurability of a leave-one-out shrinkage resolvent from entrywise
measurability of its shifted matrix.

This consumes the total matrix-inverse measurability bridge only.  It proves no
invertibility or spectral lower-bound fact.
-/
theorem leaveOneOutShrinkageResolvent_entry_measurable_of_shifted_entry_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (hShifted :
      ∀ i j : Fin d,
        Measurable fun omega : Omega =>
          (leaveOneOutShiftedMatrix (X omega) k lam) i j) :
    ∀ i j : Fin d,
      Measurable fun omega : Omega =>
        (leaveOneOutShrinkageResolvent (X omega) k lam) i j := by
  intro i j
  simpa [leaveOneOutShrinkageResolvent, precisionResolvent, leaveOneOutShiftedMatrix]
    using squareMatrix_inv_entry_measurable_of_entry_measurable
      (fun omega : Omega => leaveOneOutShiftedMatrix (X omega) k lam)
      hShifted i j

/--
Entrywise measurability of a leave-one-out shrinkage resolvent from entrywise
measurability of the random data matrix.

This is still only a Borel/finite-algebra/inverse measurability bridge.  It
does not prove H2 lower singular value events, probability bounds, or
concentration estimates.
-/
theorem leaveOneOutShrinkageResolvent_entry_measurable_of_data_entry_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (hX : ∀ i : Fin d, ∀ k : Fin n,
      Measurable fun omega : Omega => X omega i k) :
    ∀ i j : Fin d,
      Measurable fun omega : Omega =>
        (leaveOneOutShrinkageResolvent (X omega) k lam) i j :=
  leaveOneOutShrinkageResolvent_entry_measurable_of_shifted_entry_measurable
    X k lam
    (leaveOneOutShiftedMatrix_entry_measurable_of_data_entry_measurable X k lam hX)

/--
Measurability of the scalar Woodbury denominator from measurable entries of the
selected data column and the leave-one-out resolvent.

This is only the finite algebraic composition layer for
`1 + n⁻¹ x_kᵀ R_{-k}(λ) x_k`; it assumes resolvent-entry measurability and does
not prove inverse, nonzero, probability, or concentration facts.
-/
theorem shrinkageLeaveOneOutWoodburyDenominator_measurable_of_resolvent_entry_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (hXColumn : ∀ i : Fin d,
      Measurable fun omega : Omega => X omega i k)
    (hResolvent :
      ∀ i j : Fin d,
        Measurable fun omega : Omega =>
          (leaveOneOutShrinkageResolvent (X omega) k lam) i j) :
    Measurable fun omega : Omega =>
      shrinkageLeaveOneOutWoodburyDenominator (X omega) k lam := by
  simp [shrinkageLeaveOneOutWoodburyDenominator, sampleQuadraticAction,
    sampleLeftAction]
  exact measurable_const.add
    (measurable_const.mul
      (Finset.measurable_sum _ fun i _ =>
        (hXColumn i).mul
          (Finset.measurable_sum _ fun l _ =>
            (hResolvent i l).mul (hXColumn l))))

/--
Atomic H2 resolvent event: the `k`-th Woodbury denominator is nonzero.

This is named vocabulary only.  It does not prove that the event is measurable.
-/
def paperH2WoodburyDenominatorNonzeroEvent {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real) :
    Set Omega :=
  {omega | shrinkageLeaveOneOutWoodburyDenominator (X omega) k lam ≠ 0}

/--
Atomic H2 resolvent bad event: the `k`-th Woodbury denominator is zero.

This is only the complement vocabulary for the denominator-nonzero event.  It
proves no measurability or probability estimate.
-/
def paperH2WoodburyDenominatorBadEvent {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real) :
    Set Omega :=
  {omega | omega ∉ paperH2WoodburyDenominatorNonzeroEvent X k lam}

/-- Set-level complement rewrite for a Woodbury denominator bad event. -/
theorem paperH2WoodburyDenominatorBadEvent_eq_compl {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real) :
    paperH2WoodburyDenominatorBadEvent X k lam =
      (paperH2WoodburyDenominatorNonzeroEvent X k lam)ᶜ := by
  rfl

/--
Measurability of the named Woodbury-denominator nonzero event from
measurability of the real-valued Woodbury denominator.

This is the scalar Borel/preimage step only.  It does not prove the denominator
function is measurable from random-matrix entry measurability.
-/
theorem paperH2WoodburyDenominatorNonzeroEvent_measurable_of_denominator_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (hDenominator :
      Measurable fun omega : Omega =>
        shrinkageLeaveOneOutWoodburyDenominator (X omega) k lam) :
    MeasurableSet (paperH2WoodburyDenominatorNonzeroEvent X k lam) := by
  have hzero :
      MeasurableSet
        ((fun omega : Omega =>
          shrinkageLeaveOneOutWoodburyDenominator (X omega) k lam) ⁻¹'
            ({0} : Set Real)) :=
    hDenominator
      (isClosed_singleton.measurableSet : MeasurableSet ({0} : Set Real))
  have hzero' :
      MeasurableSet
        {omega : Omega |
          shrinkageLeaveOneOutWoodburyDenominator (X omega) k lam = 0} := by
    simpa [Set.preimage, Set.mem_singleton_iff] using hzero
  simpa [paperH2WoodburyDenominatorNonzeroEvent, Set.compl_setOf]
    using hzero'.compl

/--
Lambda-dependent deterministic resolvent core event for paper H2.

This records only the leave-one-out invertibility and Woodbury-denominator side
conditions used by the deterministic resolvent backend.  It intentionally omits
the eta-only lower-singular-value condition, which remains in
`paperH2LowerSingularValueGoodEvent`.
-/
def paperH2ResolventGoodEvent {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (lam : Real) :
    Set Omega :=
  {omega |
    forall k : Fin n,
      IsUnit (shrinkageShiftedMatrix (X omega) lam).det /\
        IsUnit (leaveOneOutShiftedMatrix (X omega) k lam).det /\
          shrinkageLeaveOneOutWoodburyDenominator (X omega) k lam ≠ 0}

/--
Complement event for the lambda-dependent H2 resolvent/Woodbury side
conditions.

This is event vocabulary only.  It proves no measurability, probability,
invertibility, or Woodbury-denominator estimate.
-/
def paperH2ResolventBadEvent {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (lam : Real) :
    Set Omega :=
  {omega | omega ∉ paperH2ResolventGoodEvent X lam}

/-- Membership rewrite for the H2 resolvent bad event. -/
theorem paperH2ResolventBadEvent_mem_iff {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) (omega : Omega) :
    omega ∈ paperH2ResolventBadEvent X lam ↔
      omega ∉ paperH2ResolventGoodEvent X lam := by
  rfl

/-- Set-level complement rewrite for the H2 resolvent bad event. -/
theorem paperH2ResolventBadEvent_eq_compl {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) :
    paperH2ResolventBadEvent X lam = (paperH2ResolventGoodEvent X lam)ᶜ := by
  rfl

/--
Membership spelling of the H2 resolvent good event in terms of its named atomic
events.

This is a definitional API bridge only: it proves no measurability, probability,
or concentration fact.
-/
theorem paperH2ResolventGoodEvent_mem_iff_atomic_events {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) (omega : Omega) :
    omega ∈ paperH2ResolventGoodEvent X lam ↔
      ∀ k : Fin n,
        omega ∈ paperH2ShrinkageShiftedDetUnitEvent X lam ∧
          omega ∈ paperH2LeaveOneOutShiftedDetUnitEvent X k lam ∧
            omega ∈ paperH2WoodburyDenominatorNonzeroEvent X k lam := by
  rfl

/--
Named union of the atomic bad events that cover the H2 resolvent bad event.

This is only a deterministic event wrapper for future resolvent-probability
union-bound work.  It proves no measurability or probability estimate.
-/
def paperH2ResolventAtomicBadUnionEvent {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (lam : Real) :
    Set Omega :=
  paperH2ShrinkageShiftedDetBadEvent X lam ∪
    {omega | ∃ k : Fin n,
      omega ∈ paperH2LeaveOneOutShiftedDetBadEvent X k lam ∨
        omega ∈ paperH2WoodburyDenominatorBadEvent X k lam}

/--
Pointwise factorization of the H2 resolvent bad event into atomic bad events.

If the lambda-dependent resolvent good event fails, then either the full
shifted determinant-unit event fails or some leave-one-out determinant/denominator
atomic condition fails.  This is pure propositional logic from
`paperH2ResolventGoodEvent_mem_iff_atomic_events`.
-/
theorem paperH2ResolventBadEvent_mem_imp_atomic_bad {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) (omega : Omega) :
    omega ∈ paperH2ResolventBadEvent X lam →
      omega ∈ paperH2ShrinkageShiftedDetBadEvent X lam ∨
        ∃ k : Fin n,
          omega ∈ paperH2LeaveOneOutShiftedDetBadEvent X k lam ∨
            omega ∈ paperH2WoodburyDenominatorBadEvent X k lam := by
  classical
  intro hBad
  by_cases hFull : omega ∈ paperH2ShrinkageShiftedDetUnitEvent X lam
  · right
    by_contra hNoAtomic
    rw [paperH2ResolventBadEvent_mem_iff X lam omega,
      paperH2ResolventGoodEvent_mem_iff_atomic_events X lam omega] at hBad
    apply hBad
    intro k
    have hNotLeaveBad :
        omega ∉ paperH2LeaveOneOutShiftedDetBadEvent X k lam := by
      intro hLeaveBad
      exact hNoAtomic ⟨k, Or.inl hLeaveBad⟩
    have hLeave : omega ∈ paperH2LeaveOneOutShiftedDetUnitEvent X k lam := by
      by_contra hLeave
      exact hNotLeaveBad hLeave
    have hNotDenominatorBad :
        omega ∉ paperH2WoodburyDenominatorBadEvent X k lam := by
      intro hDenominatorBad
      exact hNoAtomic ⟨k, Or.inr hDenominatorBad⟩
    have hDenominator : omega ∈ paperH2WoodburyDenominatorNonzeroEvent X k lam := by
      by_contra hDenominator
      exact hNotDenominatorBad hDenominator
    exact ⟨hFull, hLeave, hDenominator⟩
  · left
    exact hFull

/--
Set-level atomic cover for the H2 resolvent bad event.

This is the deterministic inclusion that later probability work can combine
with finite-union bounds over the named atomic bad events.
-/
theorem paperH2ResolventBadEvent_subset_atomicBadUnion {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) :
    (paperH2ResolventBadEvent X lam).Subset
      (paperH2ResolventAtomicBadUnionEvent X lam) := by
  intro omega hBad
  exact paperH2ResolventBadEvent_mem_imp_atomic_bad X lam omega hBad

/--
Explicit leave-one-out spelling for the lambda-dependent H2 resolvent event.

This is a compatibility alias for `paperH2ResolventGoodEvent`; it adds no new
mathematical content and keeps the deterministic event factorization API
readable when non-leave-one-out resolvent events are introduced later.
-/
abbrev paperH2LeaveOneOutResolventGoodEvent {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (lam : Real) :
    Set Omega :=
  paperH2ResolventGoodEvent X lam

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
Membership factorization of the H2 leave-one-out good event.

This is a purely deterministic set/API rewrite: it separates the eta-only
lower-singular-value event from the lambda-dependent resolvent side conditions.
It proves no measurability, probability, concentration, or closed-form RHS.
-/
theorem paperH2LeaveOneOutGoodEvent_mem_iff {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real) (omega : Omega) :
    omega ∈ paperH2LeaveOneOutGoodEvent X eta lam ↔
      omega ∈ paperH2LowerSingularValueGoodEvent X eta ∧
        omega ∈ paperH2ResolventGoodEvent X lam := by
  constructor
  · intro h
    constructor
    · intro k
      exact (h k).1
    · intro k
      exact (h k).2
  · intro h k
    exact ⟨h.1 k, h.2 k⟩

/--
Set-level factorization of the H2 leave-one-out good event.

This exposes `paperH2LeaveOneOutGoodEvent` as the intersection of the eta-only
lower-singular-value core and the lambda-dependent deterministic resolvent core.
-/
theorem paperH2LeaveOneOutGoodEvent_eq_inter {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real) :
    paperH2LeaveOneOutGoodEvent X eta lam =
      paperH2LowerSingularValueGoodEvent X eta ∩ paperH2ResolventGoodEvent X lam := by
  ext omega
  exact paperH2LeaveOneOutGoodEvent_mem_iff X eta lam omega

/--
Projection from the H2 leave-one-out good event to its eta-only lower-singular
value component.

This is a deterministic consequence of the event factorization only.
-/
theorem paperH2LowerSingularValueGoodEvent_of_leaveOneOutGoodEvent {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real) (omega : Omega) :
    omega ∈ paperH2LeaveOneOutGoodEvent X eta lam →
      omega ∈ paperH2LowerSingularValueGoodEvent X eta := by
  intro h
  exact (paperH2LeaveOneOutGoodEvent_mem_iff X eta lam omega).1 h |>.1

/--
Projection from the H2 leave-one-out good event to its lambda-dependent
resolvent component.

This is a deterministic consequence of the event factorization only.
-/
theorem paperH2ResolventGoodEvent_of_leaveOneOutGoodEvent {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real) (omega : Omega) :
    omega ∈ paperH2LeaveOneOutGoodEvent X eta lam →
      omega ∈ paperH2ResolventGoodEvent X lam := by
  intro h
  exact (paperH2LeaveOneOutGoodEvent_mem_iff X eta lam omega).1 h |>.2

/--
Constructor for the H2 leave-one-out good event from its factored components.

This is only set-level deterministic packaging; it proves no probability,
measurability, concentration, or closed-form RHS.
-/
theorem paperH2LeaveOneOutGoodEvent_of_lowerSingularValue_and_resolvent
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real) (omega : Omega) :
    omega ∈ paperH2LowerSingularValueGoodEvent X eta →
      omega ∈ paperH2ResolventGoodEvent X lam →
        omega ∈ paperH2LeaveOneOutGoodEvent X eta lam := by
  intro hLower hResolvent
  exact (paperH2LeaveOneOutGoodEvent_mem_iff X eta lam omega).2
    ⟨hLower, hResolvent⟩

/--
Combine a lower-singular-value event provider with pointwise resolvent-good
membership to obtain the full leave-one-out H2 good event.

This is set-level deterministic API glue only; it proves no probability,
measurability, concentration, or resolvent estimate.
-/
theorem paperH2LeaveOneOutGoodEvent_of_lowerEventProvider_and_resolvent
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (omega : Omega) :
    omega ∈ paperH2ResolventGoodEvent X lam →
      omega ∈ paperH2LeaveOneOutGoodEvent X eta lam := by
  intro hResolvent
  exact paperH2LeaveOneOutGoodEvent_of_lowerSingularValue_and_resolvent
    X eta lam omega
    (paperH2LowerSingularValueGoodEvent_mem_of_eventProvider
      P X eta hLower omega)
    hResolvent

/--
Under a lower-singular-value event provider, the leave-one-out H2 good event is
definitionally reduced to the resolvent-good factor.

This wrapper isolates the remaining H2 proof obligation at the set level; it
does not prove the lower provider or any probability bound.
-/
theorem paperH2LeaveOneOutGoodEvent_eq_resolventGood_of_lowerEventProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta) :
    paperH2LeaveOneOutGoodEvent X eta lam =
      paperH2ResolventGoodEvent X lam := by
  ext omega
  constructor
  · intro hGood
    exact paperH2ResolventGoodEvent_of_leaveOneOutGoodEvent
      X eta lam omega hGood
  · intro hResolvent
    exact paperH2LeaveOneOutGoodEvent_of_lowerEventProvider_and_resolvent
      P X eta lam hLower omega hResolvent

/--
Measurability provider for the eta-only H2 lower-singular-value good event.

This is an explicit provider contract only.  It does not prove the event is
measurable from matrix-entry measurability or a singular-value API.
-/
structure PaperH2LowerSingularValueGoodEventMeasurabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real) : Prop where
  lower_singular_value_good_event_measurable :
    MeasurableSet (paperH2LowerSingularValueGoodEvent X eta)

/--
Measurability provider for the eta-only H2 lower-singular-value bad event.

This is the complement-side contract paired with
`PaperH2LowerSingularValueGoodEventMeasurabilityProvider`.  It is still only a
measurable-event provider and carries no probability or concentration content.
-/
structure PaperH2LowerSingularValueBadEventMeasurabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real) : Prop where
  lower_singular_value_bad_event_measurable :
    MeasurableSet (paperH2LowerSingularValueBadEvent X eta)

/--
Measurability provider for the lambda-dependent H2 resolvent good event.

This records only the explicit measurable-event side condition for the
deterministic leave-one-out resolvent and Woodbury side conditions.
-/
structure PaperH2ResolventGoodEventMeasurabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) : Prop where
  resolvent_good_event_measurable :
    MeasurableSet (paperH2ResolventGoodEvent X lam)

/--
Measurability provider for the lambda-dependent H2 resolvent bad event.

This is the complement-side contract paired with
`PaperH2ResolventGoodEventMeasurabilityProvider`.  It records only event
measurability and carries no probability or concentration content.
-/
structure PaperH2ResolventBadEventMeasurabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) : Prop where
  resolvent_bad_event_measurable :
    MeasurableSet (paperH2ResolventBadEvent X lam)

/--
Measurability provider for the full H2 leave-one-out good event.

The factorized constructor below can build this provider from lower-singular
value and resolvent measurability providers.  This structure itself remains an
explicit contract and proves no primitive measurability fact.
-/
structure PaperH2LeaveOneOutGoodEventMeasurabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real) : Prop where
  good_event_measurable : MeasurableSet (paperH2LeaveOneOutGoodEvent X eta lam)

/--
Project the lower-singular-value good-event measurability field from its
provider.

This is only a field projection; it proves no primitive measurability.
-/
theorem paperH2LowerSingularValueGoodEventMeasurabilityProvider_lower_singular_value_good_event_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueGoodEventMeasurabilityProvider X eta) :
    MeasurableSet (paperH2LowerSingularValueGoodEvent X eta) :=
  h.lower_singular_value_good_event_measurable

/--
Project the lower-singular-value bad-event measurability field from its
provider.

This is only a field projection; it proves no primitive measurability.
-/
theorem paperH2LowerSingularValueBadEventMeasurabilityProvider_lower_singular_value_bad_event_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueBadEventMeasurabilityProvider X eta) :
    MeasurableSet (paperH2LowerSingularValueBadEvent X eta) :=
  h.lower_singular_value_bad_event_measurable

/--
Project the resolvent good-event measurability field from its provider.

This is only a field projection; it proves no primitive measurability.
-/
theorem paperH2ResolventGoodEventMeasurabilityProvider_resolvent_good_event_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (h : PaperH2ResolventGoodEventMeasurabilityProvider X lam) :
    MeasurableSet (paperH2ResolventGoodEvent X lam) :=
  h.resolvent_good_event_measurable

/--
Project the resolvent bad-event measurability field from its provider.

This is only a field projection; it proves no primitive measurability.
-/
theorem paperH2ResolventBadEventMeasurabilityProvider_resolvent_bad_event_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (h : PaperH2ResolventBadEventMeasurabilityProvider X lam) :
    MeasurableSet (paperH2ResolventBadEvent X lam) :=
  h.resolvent_bad_event_measurable

/--
Project the leave-one-out good-event measurability field from its provider.

This is only a field projection; it proves no primitive measurability.
-/
theorem paperH2LeaveOneOutGoodEventMeasurabilityProvider_good_event_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (h : PaperH2LeaveOneOutGoodEventMeasurabilityProvider X eta lam) :
    MeasurableSet (paperH2LeaveOneOutGoodEvent X eta lam) :=
  h.good_event_measurable

/--
Projection theorem for the lower-singular-value good-event measurability
provider.
-/
theorem paperH2LowerSingularValueGoodEvent_measurable_of_provider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueGoodEventMeasurabilityProvider X eta) :
    MeasurableSet (paperH2LowerSingularValueGoodEvent X eta) :=
  h.lower_singular_value_good_event_measurable

/--
Projection theorem for the lower-singular-value bad-event measurability
provider.
-/
theorem paperH2LowerSingularValueBadEvent_measurable_of_provider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueBadEventMeasurabilityProvider X eta) :
    MeasurableSet (paperH2LowerSingularValueBadEvent X eta) :=
  h.lower_singular_value_bad_event_measurable

/--
Lower-singular-value good-event measurability from the pointwise H2 lower
statement.

This only rewrites the good event to `Set.univ`; it proves no primitive
lower-singular-value measurability, probability bound, or concentration
estimate.
-/
theorem paperH2LowerSingularValueGoodEvent_measurable_of_statement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueStatement P X eta) :
    MeasurableSet (paperH2LowerSingularValueGoodEvent X eta) := by
  rw [paperH2LowerSingularValueGoodEvent_eq_univ_of_statement P X eta h]
  exact MeasurableSet.univ

/--
Lower-singular-value bad-event measurability from the pointwise H2 lower
statement.

This only rewrites the bad event to `∅`; it proves no probability or
concentration estimate.
-/
theorem paperH2LowerSingularValueBadEvent_measurable_of_statement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueStatement P X eta) :
    MeasurableSet (paperH2LowerSingularValueBadEvent X eta) := by
  rw [paperH2LowerSingularValueBadEvent_eq_empty_of_statement P X eta h]
  exact MeasurableSet.empty

/--
Lower-singular-value good-event measurability provider from the pointwise H2
lower event provider.

This repackages the deterministic `Set.univ` consequence of the supplied
pointwise statement; it proves no primitive lower-singular-value measurability.
-/
theorem paperH2LowerSingularValueGoodEventMeasurabilityProvider_of_eventProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueEventProvider P X eta) :
    PaperH2LowerSingularValueGoodEventMeasurabilityProvider X eta where
  lower_singular_value_good_event_measurable :=
    paperH2LowerSingularValueGoodEvent_measurable_of_statement
      P X eta h.h2_lower_singular_value

/--
Lower-singular-value bad-event measurability provider from the pointwise H2
lower event provider.

This repackages the deterministic empty-event consequence of the supplied
pointwise statement; it proves no probability or concentration estimate.
-/
theorem paperH2LowerSingularValueBadEventMeasurabilityProvider_of_eventProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueEventProvider P X eta) :
    PaperH2LowerSingularValueBadEventMeasurabilityProvider X eta where
  lower_singular_value_bad_event_measurable :=
    paperH2LowerSingularValueBadEvent_measurable_of_statement
      P X eta h.h2_lower_singular_value

/--
Lower-singular-value good-event measurability from the bad-event complement
provider.

This uses only the set-level complement rewrite
`paperH2LowerSingularValueBadEvent_eq_compl`; it does not prove primitive
singular-value measurability.
-/
theorem paperH2LowerSingularValueGoodEvent_measurable_of_badEventProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueBadEventMeasurabilityProvider X eta) :
    MeasurableSet (paperH2LowerSingularValueGoodEvent X eta) := by
  have hCompl : MeasurableSet ((paperH2LowerSingularValueGoodEvent X eta)ᶜ) := by
    simpa [paperH2LowerSingularValueBadEvent_eq_compl X eta] using
      h.lower_singular_value_bad_event_measurable
  simpa using hCompl.compl

/--
Lower-singular-value good-event measurability provider from the bad-event
complement provider.
-/
theorem paperH2LowerSingularValueGoodEventMeasurabilityProvider_of_badEventProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueBadEventMeasurabilityProvider X eta) :
    PaperH2LowerSingularValueGoodEventMeasurabilityProvider X eta where
  lower_singular_value_good_event_measurable :=
    paperH2LowerSingularValueGoodEvent_measurable_of_badEventProvider X eta h

/--
Lower-singular-value bad-event measurability provider from the good-event
provider.

This is the reverse complement bridge and carries no probability content.
-/
theorem paperH2LowerSingularValueBadEventMeasurabilityProvider_of_goodEventProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (h : PaperH2LowerSingularValueGoodEventMeasurabilityProvider X eta) :
    PaperH2LowerSingularValueBadEventMeasurabilityProvider X eta where
  lower_singular_value_bad_event_measurable := by
    rw [paperH2LowerSingularValueBadEvent_eq_compl X eta]
    exact h.lower_singular_value_good_event_measurable.compl

/--
Projection theorem for the resolvent good-event measurability provider.
-/
theorem paperH2ResolventGoodEvent_measurable_of_provider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (h : PaperH2ResolventGoodEventMeasurabilityProvider X lam) :
    MeasurableSet (paperH2ResolventGoodEvent X lam) :=
  h.resolvent_good_event_measurable

/--
Projection theorem for the resolvent bad-event measurability provider.
-/
theorem paperH2ResolventBadEvent_measurable_of_provider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (h : PaperH2ResolventBadEventMeasurabilityProvider X lam) :
    MeasurableSet (paperH2ResolventBadEvent X lam) :=
  h.resolvent_bad_event_measurable

/--
Resolvent bad-event measurability provider from the good-event provider.

This is only the complement bridge through
`paperH2ResolventBadEvent_eq_compl`; it proves no primitive resolvent-event
measurability, probability bound, or concentration estimate.
-/
theorem paperH2ResolventBadEventMeasurabilityProvider_of_goodEventProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (h : PaperH2ResolventGoodEventMeasurabilityProvider X lam) :
    PaperH2ResolventBadEventMeasurabilityProvider X lam where
  resolvent_bad_event_measurable := by
    rw [paperH2ResolventBadEvent_eq_compl X lam]
    exact h.resolvent_good_event_measurable.compl

/--
Projection theorem for the full H2 leave-one-out good-event measurability
provider.
-/
theorem paperH2LeaveOneOutGoodEvent_measurable_of_provider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (h : PaperH2LeaveOneOutGoodEventMeasurabilityProvider X eta lam) :
    MeasurableSet (paperH2LeaveOneOutGoodEvent X eta lam) :=
  h.good_event_measurable

/--
Measurability of the full H2 leave-one-out good event from the factorized
lower-singular-value and resolvent event providers.

This only uses set intersection measurability plus
`paperH2LeaveOneOutGoodEvent_eq_inter`; it does not prove either component
event is measurable from primitive assumptions.
-/
theorem paperH2LeaveOneOutGoodEvent_measurable_of_factor_providers
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (hLower : PaperH2LowerSingularValueGoodEventMeasurabilityProvider X eta)
    (hResolvent : PaperH2ResolventGoodEventMeasurabilityProvider X lam) :
    MeasurableSet (paperH2LeaveOneOutGoodEvent X eta lam) := by
  rw [paperH2LeaveOneOutGoodEvent_eq_inter X eta lam]
  exact hLower.lower_singular_value_good_event_measurable.inter
    hResolvent.resolvent_good_event_measurable

/--
Provider constructor for the full H2 leave-one-out good-event measurability
contract from the factorized component providers.
-/
theorem paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_factor_providers
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (hLower : PaperH2LowerSingularValueGoodEventMeasurabilityProvider X eta)
    (hResolvent : PaperH2ResolventGoodEventMeasurabilityProvider X lam) :
    PaperH2LeaveOneOutGoodEventMeasurabilityProvider X eta lam where
  good_event_measurable :=
    paperH2LeaveOneOutGoodEvent_measurable_of_factor_providers
      X eta lam hLower hResolvent

/--
Typed primitive-measurability target for the H2 resolvent good event.

This is the future proof entry for the lambda-dependent resolvent core:
measurability of the shrinkage shifted determinant unit event, every
leave-one-out shifted determinant unit event, and every Woodbury-denominator
nonzero event should imply measurability of `paperH2ResolventGoodEvent`.

The statement is only a target/API shell here; it does not prove any primitive
measurability fact.
-/
def PaperH2ResolventGoodEventPrimitiveMeasurabilityStatement
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) : Prop :=
  MeasurableSet (paperH2ShrinkageShiftedDetUnitEvent X lam) →
    (∀ k : Fin n,
      MeasurableSet (paperH2LeaveOneOutShiftedDetUnitEvent X k lam)) →
      (∀ k : Fin n,
        MeasurableSet (paperH2WoodburyDenominatorNonzeroEvent X k lam)) →
        MeasurableSet (paperH2ResolventGoodEvent X lam)

/--
Provider bundle for the named atomic measurability assumptions used by the H2
resolvent good-event finite-intersection proof.

This is still a contract: it does not prove determinant-unit or
Woodbury-denominator events measurable from random-matrix entry measurability.
-/
structure PaperH2ResolventAtomicMeasurabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) : Prop where
  shrinkage_shifted_det_unit_measurable :
    MeasurableSet (paperH2ShrinkageShiftedDetUnitEvent X lam)
  leave_one_out_shifted_det_unit_measurable :
    ∀ k : Fin n, MeasurableSet (paperH2LeaveOneOutShiftedDetUnitEvent X k lam)
  woodbury_denominator_nonzero_measurable :
    ∀ k : Fin n, MeasurableSet (paperH2WoodburyDenominatorNonzeroEvent X k lam)

/--
Project the full shifted determinant-unit measurability field from the atomic
H2 resolvent measurability provider.

This is only a field projection; it does not prove primitive measurability.
-/
theorem paperH2ResolventAtomicMeasurabilityProvider_shrinkage_shifted_det_unit_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (h : PaperH2ResolventAtomicMeasurabilityProvider X lam) :
    MeasurableSet (paperH2ShrinkageShiftedDetUnitEvent X lam) :=
  h.shrinkage_shifted_det_unit_measurable

/--
Project the leave-one-out shifted determinant-unit measurability field from the
atomic H2 resolvent measurability provider.

This is only a field projection; it does not prove primitive measurability.
-/
theorem paperH2ResolventAtomicMeasurabilityProvider_leave_one_out_shifted_det_unit_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (h : PaperH2ResolventAtomicMeasurabilityProvider X lam) :
    ∀ k : Fin n, MeasurableSet (paperH2LeaveOneOutShiftedDetUnitEvent X k lam) :=
  h.leave_one_out_shifted_det_unit_measurable

/--
Project the Woodbury-denominator nonzero-event measurability field from the
atomic H2 resolvent measurability provider.

This is only a field projection; it does not prove primitive measurability.
-/
theorem paperH2ResolventAtomicMeasurabilityProvider_woodbury_denominator_nonzero_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (h : PaperH2ResolventAtomicMeasurabilityProvider X lam) :
    ∀ k : Fin n, MeasurableSet (paperH2WoodburyDenominatorNonzeroEvent X k lam) :=
  h.woodbury_denominator_nonzero_measurable

/--
Primitive finite-intersection measurability proof for the H2 resolvent good
event.

This closes only the set-theoretic/measurability-combinator layer: assuming the
three atomic determinant/denominator events are measurable, the finite
leave-one-out conjunction defining `paperH2ResolventGoodEvent` is measurable.
It does not prove the atomic measurability facts themselves.
-/
theorem paperH2ResolventGoodEventPrimitiveMeasurability
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) :
    PaperH2ResolventGoodEventPrimitiveMeasurabilityStatement X lam := by
  intro hShrinkageShiftedDetUnit hLeaveOneOutShiftedDetUnit
    hWoodburyDenominatorNonzero
  change
    MeasurableSet
      {omega : Omega |
        ∀ k : Fin n,
          IsUnit (shrinkageShiftedMatrix (X omega) lam).det ∧
            IsUnit (leaveOneOutShiftedMatrix (X omega) k lam).det ∧
              shrinkageLeaveOneOutWoodburyDenominator (X omega) k lam ≠ 0}
  rw [show
      {omega : Omega |
        ∀ k : Fin n,
          IsUnit (shrinkageShiftedMatrix (X omega) lam).det ∧
            IsUnit (leaveOneOutShiftedMatrix (X omega) k lam).det ∧
              shrinkageLeaveOneOutWoodburyDenominator (X omega) k lam ≠ 0} =
        ⋂ k : Fin n,
          {omega : Omega |
            IsUnit (shrinkageShiftedMatrix (X omega) lam).det ∧
              IsUnit (leaveOneOutShiftedMatrix (X omega) k lam).det ∧
                shrinkageLeaveOneOutWoodburyDenominator (X omega) k lam ≠ 0} by
    ext omega
    simp]
  exact MeasurableSet.iInter fun k =>
    hShrinkageShiftedDetUnit.inter
      ((hLeaveOneOutShiftedDetUnit k).inter (hWoodburyDenominatorNonzero k))

/--
Measurability of the H2 resolvent good event from atomic determinant and
Woodbury-denominator event measurability.

This is the direct consumer form of
`paperH2ResolventGoodEventPrimitiveMeasurability`; it still assumes, rather
than proves, the atomic event measurability facts.
-/
theorem paperH2ResolventGoodEvent_measurable_of_atomic_events
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (hShrinkageShiftedDetUnit :
      MeasurableSet (paperH2ShrinkageShiftedDetUnitEvent X lam))
    (hLeaveOneOutShiftedDetUnit :
      ∀ k : Fin n,
        MeasurableSet (paperH2LeaveOneOutShiftedDetUnitEvent X k lam))
    (hWoodburyDenominatorNonzero :
      ∀ k : Fin n,
        MeasurableSet (paperH2WoodburyDenominatorNonzeroEvent X k lam)) :
    MeasurableSet (paperH2ResolventGoodEvent X lam) :=
  paperH2ResolventGoodEventPrimitiveMeasurability X lam
    hShrinkageShiftedDetUnit hLeaveOneOutShiftedDetUnit hWoodburyDenominatorNonzero

/--
Build the H2 resolvent good-event measurability provider from atomic event
measurability assumptions.

This packages the finite-intersection consumer for downstream H2 provider
composition while leaving determinant/denominator measurability as explicit
inputs.
-/
theorem paperH2ResolventGoodEventMeasurabilityProvider_of_atomic_events
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (hShrinkageShiftedDetUnit :
      MeasurableSet (paperH2ShrinkageShiftedDetUnitEvent X lam))
    (hLeaveOneOutShiftedDetUnit :
      ∀ k : Fin n,
        MeasurableSet (paperH2LeaveOneOutShiftedDetUnitEvent X k lam))
    (hWoodburyDenominatorNonzero :
      ∀ k : Fin n,
        MeasurableSet (paperH2WoodburyDenominatorNonzeroEvent X k lam)) :
    PaperH2ResolventGoodEventMeasurabilityProvider X lam where
  resolvent_good_event_measurable :=
    paperH2ResolventGoodEvent_measurable_of_atomic_events X lam
      hShrinkageShiftedDetUnit hLeaveOneOutShiftedDetUnit hWoodburyDenominatorNonzero

/--
Measurability of the H2 resolvent good event from the bundled named atomic
measurability provider.

This only unpacks the provider and applies the finite-intersection consumer.
-/
theorem paperH2ResolventGoodEvent_measurable_of_atomic_provider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (h : PaperH2ResolventAtomicMeasurabilityProvider X lam) :
    MeasurableSet (paperH2ResolventGoodEvent X lam) :=
  paperH2ResolventGoodEvent_measurable_of_atomic_events X lam
    h.shrinkage_shifted_det_unit_measurable
    h.leave_one_out_shifted_det_unit_measurable
    h.woodbury_denominator_nonzero_measurable

/--
Build the H2 resolvent good-event measurability provider from the bundled named
atomic measurability provider.
-/
theorem paperH2ResolventGoodEventMeasurabilityProvider_of_atomic_provider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (h : PaperH2ResolventAtomicMeasurabilityProvider X lam) :
    PaperH2ResolventGoodEventMeasurabilityProvider X lam where
  resolvent_good_event_measurable :=
    paperH2ResolventGoodEvent_measurable_of_atomic_provider X lam h

/--
Resolvent bad-event measurability from the bundled atomic resolvent
measurability provider.

This only applies complement closure to the good-event measurability already
derived from the atomic provider.  It proves no probability or concentration
bound.
-/
theorem paperH2ResolventBadEvent_measurable_of_atomic_provider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (h : PaperH2ResolventAtomicMeasurabilityProvider X lam) :
    MeasurableSet (paperH2ResolventBadEvent X lam) := by
  rw [paperH2ResolventBadEvent_eq_compl X lam]
  exact (paperH2ResolventGoodEvent_measurable_of_atomic_provider X lam h).compl

/--
Resolvent bad-event measurability provider from the bundled atomic resolvent
measurability provider.
-/
theorem paperH2ResolventBadEventMeasurabilityProvider_of_atomic_provider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (h : PaperH2ResolventAtomicMeasurabilityProvider X lam) :
    PaperH2ResolventBadEventMeasurabilityProvider X lam where
  resolvent_bad_event_measurable :=
    paperH2ResolventBadEvent_measurable_of_atomic_provider X lam h

/--
Build the bundled H2 resolvent atomic measurability provider when the two
determinant-unit events are already measurable and each real-valued Woodbury
denominator is measurable.

This discharges only the scalar `f ≠ 0` event layer for Woodbury denominators.
-/
theorem paperH2ResolventAtomicMeasurabilityProvider_of_denominator_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (hShrinkageShiftedDetUnit :
      MeasurableSet (paperH2ShrinkageShiftedDetUnitEvent X lam))
    (hLeaveOneOutShiftedDetUnit :
      ∀ k : Fin n,
        MeasurableSet (paperH2LeaveOneOutShiftedDetUnitEvent X k lam))
    (hWoodburyDenominator :
      ∀ k : Fin n,
        Measurable fun omega : Omega =>
          shrinkageLeaveOneOutWoodburyDenominator (X omega) k lam) :
    PaperH2ResolventAtomicMeasurabilityProvider X lam where
  shrinkage_shifted_det_unit_measurable := hShrinkageShiftedDetUnit
  leave_one_out_shifted_det_unit_measurable := hLeaveOneOutShiftedDetUnit
  woodbury_denominator_nonzero_measurable := fun k =>
    paperH2WoodburyDenominatorNonzeroEvent_measurable_of_denominator_measurable
      X k lam (hWoodburyDenominator k)

/--
Build the bundled H2 resolvent atomic measurability provider from measurable
real-valued determinant functions and measurable Woodbury denominators.

This closes the scalar event layer for determinant-unit and denominator-nonzero
events.  It still does not prove the determinant or denominator functions are
measurable from random-matrix entry measurability.
-/
theorem paperH2ResolventAtomicMeasurabilityProvider_of_det_and_denominator_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (hShrinkageShiftedDet :
      Measurable fun omega : Omega =>
        (shrinkageShiftedMatrix (X omega) lam).det)
    (hLeaveOneOutShiftedDet :
      ∀ k : Fin n,
        Measurable fun omega : Omega =>
          (leaveOneOutShiftedMatrix (X omega) k lam).det)
    (hWoodburyDenominator :
      ∀ k : Fin n,
        Measurable fun omega : Omega =>
          shrinkageLeaveOneOutWoodburyDenominator (X omega) k lam) :
    PaperH2ResolventAtomicMeasurabilityProvider X lam :=
  paperH2ResolventAtomicMeasurabilityProvider_of_denominator_measurable X lam
    (paperH2ShrinkageShiftedDetUnitEvent_measurable_of_det_measurable
      X lam hShrinkageShiftedDet)
    (fun k =>
      paperH2LeaveOneOutShiftedDetUnitEvent_measurable_of_det_measurable
        X k lam (hLeaveOneOutShiftedDet k))
    hWoodburyDenominator

/--
Build the bundled H2 resolvent atomic measurability provider from entrywise
measurability of the two shifted matrices and measurable Woodbury denominators.

This closes the determinant-function layer by `squareMatrix_det_measurable_of_entry_measurable`.
It still does not prove the shifted-entry or denominator functions are
measurable from primitive random-data assumptions.
-/
theorem paperH2ResolventAtomicMeasurabilityProvider_of_shifted_entry_and_denominator_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (hShrinkageShiftedEntry :
      ∀ i j : Fin d,
        Measurable fun omega : Omega =>
          (shrinkageShiftedMatrix (X omega) lam) i j)
    (hLeaveOneOutShiftedEntry :
      ∀ k : Fin n, ∀ i j : Fin d,
        Measurable fun omega : Omega =>
          (leaveOneOutShiftedMatrix (X omega) k lam) i j)
    (hWoodburyDenominator :
      ∀ k : Fin n,
        Measurable fun omega : Omega =>
          shrinkageLeaveOneOutWoodburyDenominator (X omega) k lam) :
    PaperH2ResolventAtomicMeasurabilityProvider X lam :=
  paperH2ResolventAtomicMeasurabilityProvider_of_det_and_denominator_measurable X lam
    (squareMatrix_det_measurable_of_entry_measurable
      (fun omega : Omega => shrinkageShiftedMatrix (X omega) lam)
      hShrinkageShiftedEntry)
    (fun k =>
      squareMatrix_det_measurable_of_entry_measurable
        (fun omega : Omega => leaveOneOutShiftedMatrix (X omega) k lam)
        (hLeaveOneOutShiftedEntry k))
    hWoodburyDenominator

/--
Build the bundled H2 resolvent atomic measurability provider from entrywise
measurability of the random data matrix plus measurable Woodbury denominators.

This discharges the shifted-entry and determinant-function layers.  It still
keeps Woodbury-denominator measurability as an explicit input and proves no
probability or concentration bound.
-/
theorem paperH2ResolventAtomicMeasurabilityProvider_of_data_entry_and_denominator_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (hX : ∀ i : Fin d, ∀ k : Fin n,
      Measurable fun omega : Omega => X omega i k)
    (hWoodburyDenominator :
      ∀ k : Fin n,
        Measurable fun omega : Omega =>
          shrinkageLeaveOneOutWoodburyDenominator (X omega) k lam) :
    PaperH2ResolventAtomicMeasurabilityProvider X lam :=
  paperH2ResolventAtomicMeasurabilityProvider_of_shifted_entry_and_denominator_measurable
    X lam
    (shrinkageShiftedMatrix_entry_measurable_of_data_entry_measurable X lam hX)
    (fun k =>
      leaveOneOutShiftedMatrix_entry_measurable_of_data_entry_measurable X k lam hX)
    hWoodburyDenominator

/--
Build the bundled H2 resolvent atomic measurability provider from entrywise
measurability of the random data matrix plus entrywise measurability of every
leave-one-out resolvent.

This discharges the Woodbury-denominator finite algebraic layer.  It still keeps
resolvent-entry measurability as an explicit input and proves no inverse,
probability, or concentration fact.
-/
theorem paperH2ResolventAtomicMeasurabilityProvider_of_data_entry_and_resolvent_entry_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (hX : ∀ i : Fin d, ∀ k : Fin n,
      Measurable fun omega : Omega => X omega i k)
    (hLeaveOneOutResolvent :
      ∀ k : Fin n, ∀ i j : Fin d,
        Measurable fun omega : Omega =>
          (leaveOneOutShrinkageResolvent (X omega) k lam) i j) :
    PaperH2ResolventAtomicMeasurabilityProvider X lam :=
  paperH2ResolventAtomicMeasurabilityProvider_of_data_entry_and_denominator_measurable
    X lam hX
    (fun k =>
      shrinkageLeaveOneOutWoodburyDenominator_measurable_of_resolvent_entry_measurable
        X k lam (fun i => hX i k) (hLeaveOneOutResolvent k))

/--
Build the bundled H2 resolvent atomic measurability provider directly from
entrywise measurability of the random data matrix.

This closes the deterministic/Borel measurability chain for the resolvent-side
atomic events by using finite sums, determinant continuity, and total
matrix-inverse measurability.  It still proves no distributional measurability
from H1/H2 assumptions, no probability bound, and no concentration estimate.
-/
theorem paperH2ResolventAtomicMeasurabilityProvider_of_data_entry_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (hX : ∀ i : Fin d, ∀ k : Fin n,
      Measurable fun omega : Omega => X omega i k) :
    PaperH2ResolventAtomicMeasurabilityProvider X lam :=
  paperH2ResolventAtomicMeasurabilityProvider_of_data_entry_and_resolvent_entry_measurable
    X lam hX
    (fun k =>
      leaveOneOutShrinkageResolvent_entry_measurable_of_data_entry_measurable
        X k lam hX)

/--
Entrywise measurability of a PrecisionDA random data matrix from the generic
`IsRandomMatrix` contract.

This only unfolds the repository's random-matrix vocabulary; it adds no
probability or independence content.
-/
theorem data_entry_measurable_of_isRandomMatrix
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    {P : Measure Omega} {X : RandomDataMatrix Omega d n}
    (hX : IsRandomMatrix P X) :
    ∀ i : Fin d, ∀ k : Fin n,
      Measurable fun omega : Omega => X omega i k := by
  intro i k
  simpa [matrixEntry] using hX i k

/--
Entrywise measurability of the observed data matrix projected from the paper H1
provider.

This is a provider-projection convenience theorem only.  It consumes the H1
`random_data` field and proves no H2 event, probability bound, concentration
estimate, or Theorem 1 tail statement.
-/
theorem data_entry_measurable_of_h1_provider
    {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX : Real)
    (h1Provider : PaperH1SubGaussianModelProvider P X Z Sigma SigmaSqrt sigmaX) :
    ∀ i : Fin d, ∀ k : Fin n,
      Measurable fun omega : Omega => X omega i k :=
  data_entry_measurable_of_isRandomMatrix h1Provider.h1.random_data

/--
Build the bundled H2 resolvent atomic measurability provider directly from the
paper H1 provider's observed-data random-matrix field.

This closes only the deterministic/measurability plumbing from H1 data
measurability to the resolvent-side atomic measurability provider.  It does not
prove the H2 lower-singular-value event, any probability estimate, or Theorem 1.
-/
theorem paperH2ResolventAtomicMeasurabilityProvider_of_h1_provider
    {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX lam : Real)
    (h1Provider : PaperH1SubGaussianModelProvider P X Z Sigma SigmaSqrt sigmaX) :
    PaperH2ResolventAtomicMeasurabilityProvider X lam :=
  paperH2ResolventAtomicMeasurabilityProvider_of_data_entry_measurable
    X lam
    (data_entry_measurable_of_h1_provider
      P X Z Sigma SigmaSqrt sigmaX h1Provider)

/--
Provider wrapper for the primitive-measurability target of the H2 resolvent
good event.

It records a proof-entry statement only; primitive measurability of determinants,
`IsUnit`, and Woodbury denominators remains a later proof task.
-/
structure PaperH2ResolventGoodEventPrimitiveMeasurabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) : Prop where
  primitive_measurability :
    PaperH2ResolventGoodEventPrimitiveMeasurabilityStatement X lam

/-- Projection theorem for the H2 resolvent primitive-measurability provider. -/
theorem paperH2ResolventGoodEventPrimitiveMeasurabilityStatement_of_provider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (h : PaperH2ResolventGoodEventPrimitiveMeasurabilityProvider X lam) :
    PaperH2ResolventGoodEventPrimitiveMeasurabilityStatement X lam :=
  h.primitive_measurability

/--
Project the primitive-measurability statement field from the H2 resolvent
primitive-measurability provider.

This is only a field projection; it does not prove primitive measurability.
-/
theorem paperH2ResolventGoodEventPrimitiveMeasurabilityProvider_primitive_measurability
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (h : PaperH2ResolventGoodEventPrimitiveMeasurabilityProvider X lam) :
    PaperH2ResolventGoodEventPrimitiveMeasurabilityStatement X lam :=
  h.primitive_measurability

/--
Consumer theorem for the H2 resolvent primitive-measurability provider.

This only applies the supplied primitive-measurability statement to explicit
atomic-event measurability assumptions.  It does not prove those assumptions.
-/
theorem paperH2ResolventGoodEvent_measurable_of_primitive_provider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (h : PaperH2ResolventGoodEventPrimitiveMeasurabilityProvider X lam)
    (hShrinkageShiftedDetUnit :
      MeasurableSet (paperH2ShrinkageShiftedDetUnitEvent X lam))
    (hLeaveOneOutShiftedDetUnit :
      ∀ k : Fin n,
        MeasurableSet (paperH2LeaveOneOutShiftedDetUnitEvent X k lam))
    (hWoodburyDenominatorNonzero :
      ∀ k : Fin n,
        MeasurableSet (paperH2WoodburyDenominatorNonzeroEvent X k lam)) :
    MeasurableSet (paperH2ResolventGoodEvent X lam) :=
  h.primitive_measurability
    hShrinkageShiftedDetUnit hLeaveOneOutShiftedDetUnit hWoodburyDenominatorNonzero

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

/--
Direct projection of the positivity assumption from the H2 leave-one-out
good-event statement.

This theorem is API glue only: it proves no lower-singular-value or resolvent
event fact.
-/
theorem PaperH2LeaveOneOutGoodEventStatement_eta_positive
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (h : PaperH2LeaveOneOutGoodEventStatement P X eta lam) :
    0 < eta :=
  h.eta_positive

/--
Direct projection of the pointwise H2 leave-one-out good-event field.

This theorem is API glue only: it proves no lower-singular-value or resolvent
event fact.
-/
theorem PaperH2LeaveOneOutGoodEventStatement_good_event
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (h : PaperH2LeaveOneOutGoodEventStatement P X eta lam) :
    forall omega : Omega, omega ∈ paperH2LeaveOneOutGoodEvent X eta lam :=
  h.good_event

/-- Provider wrapper for the H2 leave-one-out good-event statement. -/
structure PaperH2LeaveOneOutGoodEventProvider {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real) : Prop where
  h2 : PaperH2LeaveOneOutGoodEventStatement P X eta lam

/--
Project the H2 leave-one-out good-event statement from its provider.

This theorem is API glue only: it proves no lower-singular-value or resolvent
event fact.
-/
theorem paperH2LeaveOneOutGoodEventProvider_h2
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (h : PaperH2LeaveOneOutGoodEventProvider P X eta lam) :
    PaperH2LeaveOneOutGoodEventStatement P X eta lam :=
  h.h2

/--
Paper H2 good-event probability RHS placeholder.

This is the scalar right-hand side for a future bound on the complement of the
H2 leave-one-out good event.  The paper's closed-form concentration expression
and its proof are deliberately outside this typed API surface.
-/
abbrev PaperH2GoodEventProbabilityRHS : Type := Real

/--
Real-valued combined RHS for the H2 leave-one-out bad-event union-bound route.

This is only vocabulary for the sum of the lower-singular-value bad-event RHS
and the resolvent bad-event RHS.  It does not prove either component estimate.
-/
def paperH2LeaveOneOutBadEventUnionBoundRHS
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS) :
    PaperH2GoodEventProbabilityRHS :=
  lowerRHS + resolventRHS

/--
Nonnegativity of the combined H2 bad-event union-bound RHS from the component
RHS nonnegativity hypotheses.
-/
theorem paperH2LeaveOneOutBadEventUnionBoundRHS_nonnegative
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS)
    (hLower : 0 <= lowerRHS) (hResolvent : 0 <= resolventRHS) :
    0 <= paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS resolventRHS := by
  dsimp [paperH2LeaveOneOutBadEventUnionBoundRHS]
  exact add_nonneg hLower hResolvent

/--
Typed eta-only lower-singular-value bad-event probability statement.

This is deliberately scoped to `paperH2LowerSingularValueBadEvent`, not the
full leave-one-out H2 bad event.  It records only a scalar upper bound for the
eta-only lower bad event and is meant as a deterministic/probability interface
leaf for later factorization work.
-/
structure PaperH2LowerSingularValueBadEventProbabilityStatement {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (rhs : PaperH2GoodEventProbabilityRHS) : Prop where
  eta_positive : 0 < eta
  rhs_nonnegative : 0 <= rhs
  bad_event_probability :
    P (paperH2LowerSingularValueBadEvent X eta) <= ENNReal.ofReal rhs

/--
Provider wrapper for the eta-only lower-singular-value bad-event probability
statement.

This does not prove a lower-singular-value tail estimate.  It only packages a
statement that later consumers can project.
-/
structure PaperH2LowerSingularValueBadEventProbabilityProvider {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (rhs : PaperH2GoodEventProbabilityRHS) : Prop where
  lower_bad_event_probability :
    PaperH2LowerSingularValueBadEventProbabilityStatement P X eta rhs

/--
Direct field projection for the lower-singular-value bad-event probability
provider.  This only exposes a supplied provider field; it proves no
lower-tail or concentration estimate.
-/
theorem paperH2LowerSingularValueBadEventProbabilityProvider_lower_bad_event_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LowerSingularValueBadEventProbabilityProvider P X eta rhs) :
    PaperH2LowerSingularValueBadEventProbabilityStatement P X eta rhs :=
  h.lower_bad_event_probability

/--
Build the eta-only lower-singular-value bad-event probability statement from a
pointwise eta-only lower-singular-value statement.

The bound is only the empty-event consequence
`P (paperH2LowerSingularValueBadEvent X eta) = 0`; no concentration or
lower-tail estimate is proved.
-/
theorem paperH2LowerSingularValueBadEventProbabilityStatement_of_statement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (rhs : PaperH2GoodEventProbabilityRHS) (hrhs : 0 <= rhs)
    (h : PaperH2LowerSingularValueStatement P X eta) :
    PaperH2LowerSingularValueBadEventProbabilityStatement P X eta rhs where
  eta_positive := h.eta_positive
  rhs_nonnegative := hrhs
  bad_event_probability := by
    rw [paperH2LowerSingularValueBadEvent_measure_eq_zero_of_statement
      P X eta h]
    exact zero_le _

/--
Provider-form wrapper for the eta-only lower-singular-value bad-event
probability statement from the pointwise eta-only provider.
-/
theorem paperH2LowerSingularValueBadEventProbabilityProvider_of_eventProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (rhs : PaperH2GoodEventProbabilityRHS) (hrhs : 0 <= rhs)
    (h : PaperH2LowerSingularValueEventProvider P X eta) :
    PaperH2LowerSingularValueBadEventProbabilityProvider P X eta rhs where
  lower_bad_event_probability :=
    paperH2LowerSingularValueBadEventProbabilityStatement_of_statement
      P X eta rhs hrhs h.h2_lower_singular_value

/--
Projection of the eta-only lower-singular-value bad-event probability bound
from the pointwise eta-only provider.

This is still only the deterministic empty-event bound.
-/
theorem paperH2LowerSingularValueBadEventProbability_bound_of_eventProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta : Real)
    (rhs : PaperH2GoodEventProbabilityRHS) (hrhs : 0 <= rhs)
    (h : PaperH2LowerSingularValueEventProvider P X eta) :
    P (paperH2LowerSingularValueBadEvent X eta) <= ENNReal.ofReal rhs :=
  (paperH2LowerSingularValueBadEventProbabilityProvider_of_eventProvider
    P X eta rhs hrhs h).lower_bad_event_probability.bad_event_probability

/--
Typed lambda-dependent resolvent bad-event probability statement.

This is deliberately a hypothesis/provider surface for
`paperH2ResolventBadEvent`, not a proof of a Woodbury-denominator or resolvent
tail estimate.  It records only a scalar upper bound for the resolvent bad
event so later union-bound consumers can name the input explicitly.
-/
structure PaperH2ResolventBadEventProbabilityStatement {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS) : Prop where
  rhs_nonnegative : 0 <= rhs
  bad_event_probability :
    P (paperH2ResolventBadEvent X lam) <= ENNReal.ofReal rhs

/--
Provider wrapper for the lambda-dependent resolvent bad-event probability
statement.

This packages an explicit probability-bound hypothesis and proves no
probability, concentration, determinant, or Woodbury denominator estimate.
-/
structure PaperH2ResolventBadEventProbabilityProvider {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS) : Prop where
  resolvent_bad_event_probability :
    PaperH2ResolventBadEventProbabilityStatement P X lam rhs

/--
Direct field projection for the resolvent bad-event probability provider.
This only exposes a supplied provider field; it proves no probability,
determinant-tail, denominator-tail, or concentration estimate.
-/
theorem paperH2ResolventBadEventProbabilityProvider_resolvent_bad_event_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventBadEventProbabilityProvider P X lam rhs) :
    PaperH2ResolventBadEventProbabilityStatement P X lam rhs :=
  h.resolvent_bad_event_probability

/--
Projection theorem for the resolvent bad-event probability provider.
-/
theorem paperH2ResolventBadEventProbabilityStatement_of_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventBadEventProbabilityProvider P X lam rhs) :
    PaperH2ResolventBadEventProbabilityStatement P X lam rhs :=
  h.resolvent_bad_event_probability

/--
Provider constructor for an already stated resolvent bad-event probability
obligation.

This is only statement/provider vocabulary normalization.  It does not prove
the resolvent probability estimate.
-/
theorem paperH2ResolventBadEventProbabilityProvider_of_statement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventBadEventProbabilityStatement P X lam rhs) :
    PaperH2ResolventBadEventProbabilityProvider P X lam rhs where
  resolvent_bad_event_probability := h

/--
Projection of the resolvent bad-event probability bound from its provider.
-/
theorem paperH2ResolventBadEventProbability_bound_of_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventBadEventProbabilityProvider P X lam rhs) :
    P (paperH2ResolventBadEvent X lam) <= ENNReal.ofReal rhs :=
  h.resolvent_bad_event_probability.bad_event_probability

/--
Typed tail-estimate statement for the full shrinkage shifted-determinant atomic
bad event.

This is the full-matrix counterpart to the leave-one-out shifted-determinant
point targets.  It is only a proof target and proves no determinant-tail or
concentration estimate.
-/
structure PaperH2ShrinkageShiftedDetTailEstimateStatement {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS) : Prop where
  rhs_nonnegative : 0 <= rhs
  bad_event_probability :
    P (paperH2ShrinkageShiftedDetBadEvent X lam) <= ENNReal.ofReal rhs

/-- Provider wrapper for the full shrinkage shifted-determinant tail target. -/
structure PaperH2ShrinkageShiftedDetTailEstimateProvider {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS) : Prop where
  shrinkage_shifted_det_tail_estimate :
    PaperH2ShrinkageShiftedDetTailEstimateStatement P X lam rhs

/-- Projection theorem for the full shrinkage shifted-determinant tail provider. -/
theorem paperH2ShrinkageShiftedDetTailEstimateStatement_of_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ShrinkageShiftedDetTailEstimateProvider P X lam rhs) :
    PaperH2ShrinkageShiftedDetTailEstimateStatement P X lam rhs :=
  h.shrinkage_shifted_det_tail_estimate

/--
Provider constructor for an already stated full shrinkage shifted-determinant
tail obligation.
-/
theorem paperH2ShrinkageShiftedDetTailEstimateProvider_of_statement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ShrinkageShiftedDetTailEstimateStatement P X lam rhs) :
    PaperH2ShrinkageShiftedDetTailEstimateProvider P X lam rhs where
  shrinkage_shifted_det_tail_estimate := h

/-- Projection of the full shrinkage shifted-determinant bad-event probability bound. -/
theorem paperH2ShrinkageShiftedDetTailEstimate_bound_of_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ShrinkageShiftedDetTailEstimateProvider P X lam rhs) :
    P (paperH2ShrinkageShiftedDetBadEvent X lam) <= ENNReal.ofReal rhs :=
  h.shrinkage_shifted_det_tail_estimate.bad_event_probability

/-- Projection of the full shrinkage shifted-determinant RHS nonnegativity. -/
theorem paperH2ShrinkageShiftedDetTailEstimate_rhs_nonnegative_of_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ShrinkageShiftedDetTailEstimateProvider P X lam rhs) :
    0 <= rhs :=
  h.shrinkage_shifted_det_tail_estimate.rhs_nonnegative

/--
Build the full shrinkage shifted-determinant tail statement from explicit
nonnegativity and bad-event probability assumptions.

This is an assumption wrapper only; it proves no determinant tail or
concentration estimate.
-/
theorem paperH2ShrinkageShiftedDetTailEstimateStatement_of_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (hRHS : 0 <= rhs)
    (hBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <= ENNReal.ofReal rhs) :
    PaperH2ShrinkageShiftedDetTailEstimateStatement P X lam rhs where
  rhs_nonnegative := hRHS
  bad_event_probability := hBound

/--
Build the full shrinkage shifted-determinant tail provider from explicit
nonnegativity and bad-event probability assumptions.

This is only provider plumbing for a future tail proof.
-/
theorem paperH2ShrinkageShiftedDetTailEstimateProvider_of_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (hRHS : 0 <= rhs)
    (hBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <= ENNReal.ofReal rhs) :
    PaperH2ShrinkageShiftedDetTailEstimateProvider P X lam rhs :=
  paperH2ShrinkageShiftedDetTailEstimateProvider_of_statement
    P X lam rhs
    (paperH2ShrinkageShiftedDetTailEstimateStatement_of_bound
      P X lam rhs hRHS hBound)

/--
Paper-parameter vocabulary for the full shrinkage shifted-determinant tail RHS.

This is a closed-form RHS slot for later calibration against the paper.  It
does not assert or prove a determinant-tail probability estimate.
-/
structure PaperH2ShrinkageShiftedDetTailPaperParameters where
  prefactor : Real
  rateConstant : Real
  sigmaX : Real
  eta : Real
  threshold : Real

/--
Paper-parameter exponential RHS for the full shrinkage shifted-determinant
tail target.

The named expression is
`prefactor * exp (-(rateConstant * sigmaX^2 * n * d * (eta + lam)^3 *
threshold^2))`.
-/
def paperH2ShrinkageShiftedDetTailPaperRHS {d n : Nat}
    (params : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (lam : Real) : PaperH2GoodEventProbabilityRHS :=
  params.prefactor *
    Real.exp
      (-(params.rateConstant * params.sigmaX ^ 2 * (n : Real) *
        (d : Real) * (params.eta + lam) ^ 3 * params.threshold ^ 2))

/--
Nonnegativity of the named full shrinkage shifted-determinant paper RHS from a
nonnegative prefactor.  The exponential factor is always nonnegative.
-/
theorem paperH2ShrinkageShiftedDetTailPaperRHS_nonnegative {d n : Nat}
    (params : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (lam : Real) (hPrefactor : 0 <= params.prefactor) :
    0 <= paperH2ShrinkageShiftedDetTailPaperRHS
      (d := d) (n := n) params lam := by
  dsimp [paperH2ShrinkageShiftedDetTailPaperRHS]
  exact mul_nonneg hPrefactor (Real.exp_nonneg _)

/--
Build the full shrinkage shifted-determinant tail statement from a supplied
bound against the named paper-parameter RHS.

This is an assumption wrapper only; it proves no determinant tail or
concentration estimate.
-/
theorem paperH2ShrinkageShiftedDetTailEstimateStatement_of_paperRHS_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (params : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (hPrefactor : 0 <= params.prefactor)
    (hBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) params lam)) :
    PaperH2ShrinkageShiftedDetTailEstimateStatement P X lam
      (paperH2ShrinkageShiftedDetTailPaperRHS
        (d := d) (n := n) params lam) :=
  paperH2ShrinkageShiftedDetTailEstimateStatement_of_bound
    P X lam
    (paperH2ShrinkageShiftedDetTailPaperRHS
      (d := d) (n := n) params lam)
    (paperH2ShrinkageShiftedDetTailPaperRHS_nonnegative
      (d := d) (n := n) params lam hPrefactor)
    hBound

/--
Build the full shrinkage shifted-determinant tail provider from a supplied
bound against the named paper-parameter RHS.

This is provider plumbing for a future determinant-tail proof.
-/
theorem paperH2ShrinkageShiftedDetTailEstimateProvider_of_paperRHS_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (params : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (hPrefactor : 0 <= params.prefactor)
    (hBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) params lam)) :
    PaperH2ShrinkageShiftedDetTailEstimateProvider P X lam
      (paperH2ShrinkageShiftedDetTailPaperRHS
        (d := d) (n := n) params lam) :=
  paperH2ShrinkageShiftedDetTailEstimateProvider_of_statement
    P X lam
    (paperH2ShrinkageShiftedDetTailPaperRHS
      (d := d) (n := n) params lam)
    (paperH2ShrinkageShiftedDetTailEstimateStatement_of_paperRHS_bound
      P X lam params hPrefactor hBound)

/--
Pointwise typed tail-estimate statement for one leave-one-out
shifted-determinant atomic bad event.

This is the smallest proof target for the leave-one-out determinant side of the
H2 resolvent cover.  It proves no determinant-tail or concentration estimate by
itself.
-/
structure PaperH2LeaveOneOutShiftedDetPointTailEstimateStatement {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS) : Prop where
  rhs_nonnegative : 0 <= rhs
  bad_event_probability :
    P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <= ENNReal.ofReal rhs

/-- Provider wrapper for one leave-one-out shifted-determinant tail target. -/
structure PaperH2LeaveOneOutShiftedDetPointTailEstimateProvider {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS) : Prop where
  leave_one_out_shifted_det_point_tail_estimate :
    PaperH2LeaveOneOutShiftedDetPointTailEstimateStatement P X k lam rhs

/-- Projection theorem for one leave-one-out shifted-determinant tail provider. -/
theorem paperH2LeaveOneOutShiftedDetPointTailEstimateStatement_of_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LeaveOneOutShiftedDetPointTailEstimateProvider P X k lam rhs) :
    PaperH2LeaveOneOutShiftedDetPointTailEstimateStatement P X k lam rhs :=
  h.leave_one_out_shifted_det_point_tail_estimate

/--
Provider constructor for an already stated leave-one-out shifted-determinant
tail obligation.
-/
theorem paperH2LeaveOneOutShiftedDetPointTailEstimateProvider_of_statement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h :
      PaperH2LeaveOneOutShiftedDetPointTailEstimateStatement P X k lam rhs) :
    PaperH2LeaveOneOutShiftedDetPointTailEstimateProvider P X k lam rhs where
  leave_one_out_shifted_det_point_tail_estimate := h

/--
Projection of one leave-one-out shifted-determinant bad-event probability
bound.
-/
theorem paperH2LeaveOneOutShiftedDetPointTailEstimate_bound_of_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LeaveOneOutShiftedDetPointTailEstimateProvider P X k lam rhs) :
    P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <= ENNReal.ofReal rhs :=
  h.leave_one_out_shifted_det_point_tail_estimate.bad_event_probability

/--
Projection of one leave-one-out shifted-determinant RHS nonnegativity.
-/
theorem paperH2LeaveOneOutShiftedDetPointTailEstimate_rhs_nonnegative_of_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LeaveOneOutShiftedDetPointTailEstimateProvider P X k lam rhs) :
    0 <= rhs :=
  h.leave_one_out_shifted_det_point_tail_estimate.rhs_nonnegative

/--
Build one leave-one-out shifted-determinant point-tail statement from explicit
nonnegativity and bad-event probability assumptions.

This is an assumption wrapper only; it proves no determinant tail or
concentration estimate.
-/
theorem paperH2LeaveOneOutShiftedDetPointTailEstimateStatement_of_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (hRHS : 0 <= rhs)
    (hBound :
      P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <= ENNReal.ofReal rhs) :
    PaperH2LeaveOneOutShiftedDetPointTailEstimateStatement P X k lam rhs where
  rhs_nonnegative := hRHS
  bad_event_probability := hBound

/--
Build one leave-one-out shifted-determinant point-tail provider from explicit
nonnegativity and bad-event probability assumptions.

This is provider plumbing for a future determinant-tail proof.
-/
theorem paperH2LeaveOneOutShiftedDetPointTailEstimateProvider_of_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (hRHS : 0 <= rhs)
    (hBound :
      P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <= ENNReal.ofReal rhs) :
    PaperH2LeaveOneOutShiftedDetPointTailEstimateProvider P X k lam rhs :=
  paperH2LeaveOneOutShiftedDetPointTailEstimateProvider_of_statement
    P X k lam rhs
    (paperH2LeaveOneOutShiftedDetPointTailEstimateStatement_of_bound
      P X k lam rhs hRHS hBound)

/--
Paper-parameter vocabulary for one leave-one-out shifted-determinant point-tail
RHS.

This is a closed-form RHS slot for later calibration against the paper.  It
does not assert or prove a determinant-tail probability estimate.
-/
structure PaperH2LeaveOneOutShiftedDetPointTailPaperParameters where
  prefactor : Real
  rateConstant : Real
  sigmaX : Real
  eta : Real
  threshold : Real

/--
Paper-parameter exponential RHS for one leave-one-out shifted-determinant
point-tail target.

The named expression is
`prefactor * exp (-(rateConstant * sigmaX^2 * n * d * (eta + lam)^3 *
threshold^2))`.
-/
def paperH2LeaveOneOutShiftedDetPointTailPaperRHS {d n : Nat}
    (params : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (lam : Real) : PaperH2GoodEventProbabilityRHS :=
  params.prefactor *
    Real.exp
      (-(params.rateConstant * params.sigmaX ^ 2 * (n : Real) *
        (d : Real) * (params.eta + lam) ^ 3 * params.threshold ^ 2))

/--
Nonnegativity of the named leave-one-out shifted-determinant paper RHS from a
nonnegative prefactor.  The exponential factor is always nonnegative.
-/
theorem paperH2LeaveOneOutShiftedDetPointTailPaperRHS_nonnegative {d n : Nat}
    (params : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (lam : Real) (hPrefactor : 0 <= params.prefactor) :
    0 <= paperH2LeaveOneOutShiftedDetPointTailPaperRHS
      (d := d) (n := n) params lam := by
  dsimp [paperH2LeaveOneOutShiftedDetPointTailPaperRHS]
  exact mul_nonneg hPrefactor (Real.exp_nonneg _)

/--
Build one leave-one-out shifted-determinant point-tail statement from a
supplied bound against the named paper-parameter RHS.

This is an assumption wrapper only; it proves no determinant tail or
concentration estimate.
-/
theorem paperH2LeaveOneOutShiftedDetPointTailEstimateStatement_of_paperRHS_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (params : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (hPrefactor : 0 <= params.prefactor)
    (hBound :
      P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
        ENNReal.ofReal
          (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
            (d := d) (n := n) params lam)) :
    PaperH2LeaveOneOutShiftedDetPointTailEstimateStatement P X k lam
      (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
        (d := d) (n := n) params lam) :=
  paperH2LeaveOneOutShiftedDetPointTailEstimateStatement_of_bound
    P X k lam
    (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
      (d := d) (n := n) params lam)
    (paperH2LeaveOneOutShiftedDetPointTailPaperRHS_nonnegative
      (d := d) (n := n) params lam hPrefactor)
    hBound

/--
Build one leave-one-out shifted-determinant point-tail provider from a supplied
bound against the named paper-parameter RHS.

This is provider plumbing for a future determinant-tail proof.
-/
theorem paperH2LeaveOneOutShiftedDetPointTailEstimateProvider_of_paperRHS_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (params : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (hPrefactor : 0 <= params.prefactor)
    (hBound :
      P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
        ENNReal.ofReal
          (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
            (d := d) (n := n) params lam)) :
    PaperH2LeaveOneOutShiftedDetPointTailEstimateProvider P X k lam
      (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
        (d := d) (n := n) params lam) :=
  paperH2LeaveOneOutShiftedDetPointTailEstimateProvider_of_statement
    P X k lam
    (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
      (d := d) (n := n) params lam)
    (paperH2LeaveOneOutShiftedDetPointTailEstimateStatement_of_paperRHS_bound
      P X k lam params hPrefactor hBound)

/--
Typed probability statement for the shifted-determinant atomic bad events in
H2's resolvent cover.

This packages the full shrinkage shifted-determinant failure and the family of
leave-one-out shifted-determinant failures.  It is only a hypothesis surface for
later determinant-tail work; it proves no probability or concentration bound.
-/
structure PaperH2ShiftedDetBadEventProbabilityStatement {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS : Fin n -> PaperH2GoodEventProbabilityRHS) : Prop where
  shrinkage_rhs_nonnegative : 0 <= shrinkageRHS
  leave_one_out_rhs_nonnegative : ∀ k : Fin n, 0 <= leaveOneOutRHS k
  shrinkage_bad_event_probability :
    P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
      ENNReal.ofReal shrinkageRHS
  leave_one_out_bad_event_probability :
    ∀ k : Fin n,
      P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
        ENNReal.ofReal (leaveOneOutRHS k)

/--
Provider wrapper for shifted-determinant atomic bad-event probability inputs.

The provider exists so the later H2 atomic union-bound route can consume the
determinant-failure estimates separately from the Woodbury-denominator failure
estimates.  It proves no determinant-tail or concentration estimate.
-/
structure PaperH2ShiftedDetBadEventProbabilityProvider {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS : Fin n -> PaperH2GoodEventProbabilityRHS) : Prop where
  shifted_det_bad_event_probability :
    PaperH2ShiftedDetBadEventProbabilityStatement
      P X lam shrinkageRHS leaveOneOutRHS

/--
Direct field projection for the shifted-determinant bad-event probability
provider.  This only exposes a supplied provider field; it proves no
determinant-tail or concentration estimate.
-/
theorem paperH2ShiftedDetBadEventProbabilityProvider_shifted_det_bad_event_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ShiftedDetBadEventProbabilityProvider P X lam shrinkageRHS leaveOneOutRHS) :
    PaperH2ShiftedDetBadEventProbabilityStatement
      P X lam shrinkageRHS leaveOneOutRHS :=
  h.shifted_det_bad_event_probability

/-- Projection theorem for the shifted-determinant bad-event provider. -/
theorem paperH2ShiftedDetBadEventProbabilityStatement_of_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ShiftedDetBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS) :
    PaperH2ShiftedDetBadEventProbabilityStatement
      P X lam shrinkageRHS leaveOneOutRHS :=
  h.shifted_det_bad_event_probability

/--
Provider constructor for an already stated shifted-determinant bad-event
probability obligation.
-/
theorem paperH2ShiftedDetBadEventProbabilityProvider_of_statement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ShiftedDetBadEventProbabilityStatement
      P X lam shrinkageRHS leaveOneOutRHS) :
    PaperH2ShiftedDetBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS where
  shifted_det_bad_event_probability := h

/-- Projection of the full shrinkage shifted-determinant bad-event bound. -/
theorem paperH2ShrinkageShiftedDetBadEventProbability_bound_of_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ShiftedDetBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS) :
    P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
      ENNReal.ofReal shrinkageRHS :=
  h.shifted_det_bad_event_probability.shrinkage_bad_event_probability

/-- Projection of a leave-one-out shifted-determinant bad-event bound. -/
theorem paperH2LeaveOneOutShiftedDetBadEventProbability_bound_of_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ShiftedDetBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS) (k : Fin n) :
    P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
      ENNReal.ofReal (leaveOneOutRHS k) :=
  h.shifted_det_bad_event_probability.leave_one_out_bad_event_probability k

/--
Repackage full and pointwise shifted-determinant tail-estimate providers into
the family-level shifted-determinant bad-event probability statement.

This is deterministic provider plumbing only.  It does not prove determinant
tail estimates.
-/
theorem paperH2ShiftedDetBadEventProbabilityStatement_of_tailEstimateProviders
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (hShrinkage :
      PaperH2ShrinkageShiftedDetTailEstimateProvider
        P X lam shrinkageRHS)
    (hLeaveOneOut :
      ∀ k : Fin n,
        PaperH2LeaveOneOutShiftedDetPointTailEstimateProvider
          P X k lam (leaveOneOutRHS k)) :
    PaperH2ShiftedDetBadEventProbabilityStatement
      P X lam shrinkageRHS leaveOneOutRHS where
  shrinkage_rhs_nonnegative :=
    hShrinkage.shrinkage_shifted_det_tail_estimate.rhs_nonnegative
  leave_one_out_rhs_nonnegative := fun k =>
    (hLeaveOneOut k).leave_one_out_shifted_det_point_tail_estimate.rhs_nonnegative
  shrinkage_bad_event_probability :=
    hShrinkage.shrinkage_shifted_det_tail_estimate.bad_event_probability
  leave_one_out_bad_event_probability := fun k =>
    (hLeaveOneOut k).leave_one_out_shifted_det_point_tail_estimate.bad_event_probability

/--
Repackage full and pointwise shifted-determinant tail-estimate providers into
the family-level shifted-determinant bad-event probability provider.
-/
theorem paperH2ShiftedDetBadEventProbabilityProvider_of_tailEstimateProviders
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (hShrinkage :
      PaperH2ShrinkageShiftedDetTailEstimateProvider
        P X lam shrinkageRHS)
    (hLeaveOneOut :
      ∀ k : Fin n,
        PaperH2LeaveOneOutShiftedDetPointTailEstimateProvider
          P X k lam (leaveOneOutRHS k)) :
    PaperH2ShiftedDetBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS where
  shifted_det_bad_event_probability :=
    paperH2ShiftedDetBadEventProbabilityStatement_of_tailEstimateProviders
      P X lam shrinkageRHS leaveOneOutRHS hShrinkage hLeaveOneOut

/--
Build the shifted-determinant bad-event probability statement from supplied
full and leave-one-out bounds against their named paper-parameter RHS slots.

This only assembles already supplied bounds; it proves no determinant-tail or
concentration estimate.
-/
theorem paperH2ShiftedDetBadEventProbabilityStatement_of_paperRHS_bounds
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam)) :
    PaperH2ShiftedDetBadEventProbabilityStatement P X lam
      (paperH2ShrinkageShiftedDetTailPaperRHS
        (d := d) (n := n) shrinkageParams lam)
      (fun _ =>
        paperH2LeaveOneOutShiftedDetPointTailPaperRHS
          (d := d) (n := n) leaveOneOutParams lam) :=
  paperH2ShiftedDetBadEventProbabilityStatement_of_tailEstimateProviders
    P X lam
    (paperH2ShrinkageShiftedDetTailPaperRHS
      (d := d) (n := n) shrinkageParams lam)
    (fun _ =>
      paperH2LeaveOneOutShiftedDetPointTailPaperRHS
        (d := d) (n := n) leaveOneOutParams lam)
    (paperH2ShrinkageShiftedDetTailEstimateProvider_of_paperRHS_bound
      P X lam shrinkageParams hShrinkagePrefactor hShrinkageBound)
    (fun k =>
      paperH2LeaveOneOutShiftedDetPointTailEstimateProvider_of_paperRHS_bound
        P X k lam leaveOneOutParams hLeaveOneOutPrefactor
        (hLeaveOneOutBounds k))

/--
Build the shifted-determinant bad-event probability provider from supplied full
and leave-one-out bounds against their named paper-parameter RHS slots.

This is provider plumbing for future determinant-tail proofs.
-/
theorem paperH2ShiftedDetBadEventProbabilityProvider_of_paperRHS_bounds
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam)) :
    PaperH2ShiftedDetBadEventProbabilityProvider P X lam
      (paperH2ShrinkageShiftedDetTailPaperRHS
        (d := d) (n := n) shrinkageParams lam)
      (fun _ =>
        paperH2LeaveOneOutShiftedDetPointTailPaperRHS
          (d := d) (n := n) leaveOneOutParams lam) :=
  paperH2ShiftedDetBadEventProbabilityProvider_of_statement
    P X lam
    (paperH2ShrinkageShiftedDetTailPaperRHS
      (d := d) (n := n) shrinkageParams lam)
    (fun _ =>
      paperH2LeaveOneOutShiftedDetPointTailPaperRHS
        (d := d) (n := n) leaveOneOutParams lam)
    (paperH2ShiftedDetBadEventProbabilityStatement_of_paperRHS_bounds
      P X lam shrinkageParams leaveOneOutParams hShrinkagePrefactor
      hLeaveOneOutPrefactor hShrinkageBound hLeaveOneOutBounds)

/--
Pointwise typed tail-estimate statement for one Woodbury-denominator atomic
bad event.

This is the smallest proof target for the denominator side of the H2 resolvent
cover: a future probabilistic argument may prove this statement for each
leave-one-out index `k`, and the family can then be repackaged into the existing
Woodbury-denominator bad-event probability provider.  It proves no
concentration or denominator-tail estimate by itself.
-/
structure PaperH2WoodburyDenominatorPointTailEstimateStatement {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS) : Prop where
  rhs_nonnegative : 0 <= rhs
  bad_event_probability :
    P (paperH2WoodburyDenominatorBadEvent X k lam) <= ENNReal.ofReal rhs

/--
Provider wrapper for one pointwise Woodbury-denominator tail-estimate statement.
-/
structure PaperH2WoodburyDenominatorPointTailEstimateProvider {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS) : Prop where
  woodbury_denominator_point_tail_estimate :
    PaperH2WoodburyDenominatorPointTailEstimateStatement P X k lam rhs

/-- Projection theorem for one pointwise Woodbury-denominator tail provider. -/
theorem paperH2WoodburyDenominatorPointTailEstimateStatement_of_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2WoodburyDenominatorPointTailEstimateProvider P X k lam rhs) :
    PaperH2WoodburyDenominatorPointTailEstimateStatement P X k lam rhs :=
  h.woodbury_denominator_point_tail_estimate

/--
Provider constructor for an already stated pointwise Woodbury-denominator tail
obligation.
-/
theorem paperH2WoodburyDenominatorPointTailEstimateProvider_of_statement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2WoodburyDenominatorPointTailEstimateStatement P X k lam rhs) :
    PaperH2WoodburyDenominatorPointTailEstimateProvider P X k lam rhs where
  woodbury_denominator_point_tail_estimate := h

/-- Projection of one pointwise Woodbury-denominator bad-event probability bound. -/
theorem paperH2WoodburyDenominatorPointTailEstimate_bound_of_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2WoodburyDenominatorPointTailEstimateProvider P X k lam rhs) :
    P (paperH2WoodburyDenominatorBadEvent X k lam) <= ENNReal.ofReal rhs :=
  h.woodbury_denominator_point_tail_estimate.bad_event_probability

/-- Projection of one Woodbury-denominator RHS nonnegativity. -/
theorem paperH2WoodburyDenominatorPointTailEstimate_rhs_nonnegative_of_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2WoodburyDenominatorPointTailEstimateProvider P X k lam rhs) :
    0 <= rhs :=
  h.woodbury_denominator_point_tail_estimate.rhs_nonnegative

/--
Build one Woodbury-denominator point-tail statement from explicit
nonnegativity and bad-event probability assumptions.

This is an assumption wrapper only; it proves no denominator tail or
concentration estimate.
-/
theorem paperH2WoodburyDenominatorPointTailEstimateStatement_of_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (hRHS : 0 <= rhs)
    (hBound :
      P (paperH2WoodburyDenominatorBadEvent X k lam) <= ENNReal.ofReal rhs) :
    PaperH2WoodburyDenominatorPointTailEstimateStatement P X k lam rhs where
  rhs_nonnegative := hRHS
  bad_event_probability := hBound

/--
Build one Woodbury-denominator point-tail provider from explicit
nonnegativity and bad-event probability assumptions.

This is provider plumbing for a future denominator-tail proof.
-/
theorem paperH2WoodburyDenominatorPointTailEstimateProvider_of_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (hRHS : 0 <= rhs)
    (hBound :
      P (paperH2WoodburyDenominatorBadEvent X k lam) <= ENNReal.ofReal rhs) :
    PaperH2WoodburyDenominatorPointTailEstimateProvider P X k lam rhs :=
  paperH2WoodburyDenominatorPointTailEstimateProvider_of_statement
    P X k lam rhs
    (paperH2WoodburyDenominatorPointTailEstimateStatement_of_bound
      P X k lam rhs hRHS hBound)

/--
Paper-parameter vocabulary for one Woodbury-denominator point-tail RHS.

This is a closed-form RHS slot for later calibration against the paper.  It
does not assert or prove a denominator-tail probability estimate.
-/
structure PaperH2WoodburyDenominatorPointTailPaperParameters where
  prefactor : Real
  rateConstant : Real
  sigmaX : Real
  eta : Real
  threshold : Real

/--
Paper-parameter exponential RHS for one Woodbury-denominator point-tail target.

The named expression is
`prefactor * exp (-(rateConstant * sigmaX^2 * n * d * (eta + lam)^3 *
threshold^2))`.
-/
def paperH2WoodburyDenominatorPointTailPaperRHS {d n : Nat}
    (params : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (lam : Real) : PaperH2GoodEventProbabilityRHS :=
  params.prefactor *
    Real.exp
      (-(params.rateConstant * params.sigmaX ^ 2 * (n : Real) *
        (d : Real) * (params.eta + lam) ^ 3 * params.threshold ^ 2))

/--
Nonnegativity of the named Woodbury-denominator paper RHS from a
nonnegative prefactor.  The exponential factor is always nonnegative.
-/
theorem paperH2WoodburyDenominatorPointTailPaperRHS_nonnegative {d n : Nat}
    (params : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (lam : Real) (hPrefactor : 0 <= params.prefactor) :
    0 <= paperH2WoodburyDenominatorPointTailPaperRHS
      (d := d) (n := n) params lam := by
  dsimp [paperH2WoodburyDenominatorPointTailPaperRHS]
  exact mul_nonneg hPrefactor (Real.exp_nonneg _)

/--
Build one Woodbury-denominator point-tail statement from a supplied bound
against the named paper-parameter RHS.

This is an assumption wrapper only; it proves no denominator tail or
concentration estimate.
-/
theorem paperH2WoodburyDenominatorPointTailEstimateStatement_of_paperRHS_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (params : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (hPrefactor : 0 <= params.prefactor)
    (hBound :
      P (paperH2WoodburyDenominatorBadEvent X k lam) <=
        ENNReal.ofReal
          (paperH2WoodburyDenominatorPointTailPaperRHS
            (d := d) (n := n) params lam)) :
    PaperH2WoodburyDenominatorPointTailEstimateStatement P X k lam
      (paperH2WoodburyDenominatorPointTailPaperRHS
        (d := d) (n := n) params lam) :=
  paperH2WoodburyDenominatorPointTailEstimateStatement_of_bound
    P X k lam
    (paperH2WoodburyDenominatorPointTailPaperRHS
      (d := d) (n := n) params lam)
    (paperH2WoodburyDenominatorPointTailPaperRHS_nonnegative
      (d := d) (n := n) params lam hPrefactor)
    hBound

/--
Build one Woodbury-denominator point-tail provider from a supplied bound
against the named paper-parameter RHS.

This is provider plumbing for a future denominator-tail proof.
-/
theorem paperH2WoodburyDenominatorPointTailEstimateProvider_of_paperRHS_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (k : Fin n) (lam : Real)
    (params : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (hPrefactor : 0 <= params.prefactor)
    (hBound :
      P (paperH2WoodburyDenominatorBadEvent X k lam) <=
        ENNReal.ofReal
          (paperH2WoodburyDenominatorPointTailPaperRHS
            (d := d) (n := n) params lam)) :
    PaperH2WoodburyDenominatorPointTailEstimateProvider P X k lam
      (paperH2WoodburyDenominatorPointTailPaperRHS
        (d := d) (n := n) params lam) :=
  paperH2WoodburyDenominatorPointTailEstimateProvider_of_statement
    P X k lam
    (paperH2WoodburyDenominatorPointTailPaperRHS
      (d := d) (n := n) params lam)
    (paperH2WoodburyDenominatorPointTailEstimateStatement_of_paperRHS_bound
      P X k lam params hPrefactor hBound)

/--
Typed probability statement for the Woodbury-denominator atomic bad events in
H2's resolvent cover.

This packages the family of Woodbury-denominator failure probabilities only.
It is a hypothesis surface for later denominator-tail work and proves no
probability, denominator nonzero, or concentration estimate.
-/
structure PaperH2WoodburyDenominatorBadEventProbabilityStatement {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS) : Prop where
  denominator_rhs_nonnegative : ∀ k : Fin n, 0 <= denominatorRHS k
  denominator_bad_event_probability :
    ∀ k : Fin n,
      P (paperH2WoodburyDenominatorBadEvent X k lam) <=
        ENNReal.ofReal (denominatorRHS k)

/--
Provider wrapper for Woodbury-denominator atomic bad-event probability inputs.

It separates denominator-failure hypotheses from shifted determinant-failure
hypotheses so the two atomic components can be developed independently.
-/
structure PaperH2WoodburyDenominatorBadEventProbabilityProvider {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS) : Prop where
  woodbury_denominator_bad_event_probability :
    PaperH2WoodburyDenominatorBadEventProbabilityStatement
      P X lam denominatorRHS

/--
Direct field projection for the Woodbury-denominator bad-event probability
provider.  This only exposes a supplied provider field; it proves no
denominator-tail or concentration estimate.
-/
theorem paperH2WoodburyDenominatorBadEventProbabilityProvider_woodbury_denominator_bad_event_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2WoodburyDenominatorBadEventProbabilityProvider P X lam denominatorRHS) :
    PaperH2WoodburyDenominatorBadEventProbabilityStatement
      P X lam denominatorRHS :=
  h.woodbury_denominator_bad_event_probability

/-- Projection theorem for the Woodbury-denominator bad-event provider. -/
theorem paperH2WoodburyDenominatorBadEventProbabilityStatement_of_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2WoodburyDenominatorBadEventProbabilityProvider
      P X lam denominatorRHS) :
    PaperH2WoodburyDenominatorBadEventProbabilityStatement
      P X lam denominatorRHS :=
  h.woodbury_denominator_bad_event_probability

/--
Provider constructor for an already stated Woodbury-denominator bad-event
probability obligation.
-/
theorem paperH2WoodburyDenominatorBadEventProbabilityProvider_of_statement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2WoodburyDenominatorBadEventProbabilityStatement
      P X lam denominatorRHS) :
    PaperH2WoodburyDenominatorBadEventProbabilityProvider
      P X lam denominatorRHS where
  woodbury_denominator_bad_event_probability := h

/-- Projection of a Woodbury-denominator bad-event bound. -/
theorem paperH2WoodburyDenominatorBadEventProbability_bound_of_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2WoodburyDenominatorBadEventProbabilityProvider
      P X lam denominatorRHS) (k : Fin n) :
    P (paperH2WoodburyDenominatorBadEvent X k lam) <=
      ENNReal.ofReal (denominatorRHS k) :=
  h.woodbury_denominator_bad_event_probability.denominator_bad_event_probability k

/--
Repackage pointwise Woodbury-denominator tail-estimate providers into the
family-level bad-event probability statement.

This is a deterministic provider bridge only.  It does not prove the pointwise
tail estimates.
-/
theorem paperH2WoodburyDenominatorBadEventProbabilityStatement_of_pointTailEstimateProviders
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h :
      ∀ k : Fin n,
        PaperH2WoodburyDenominatorPointTailEstimateProvider
          P X k lam (denominatorRHS k)) :
    PaperH2WoodburyDenominatorBadEventProbabilityStatement
      P X lam denominatorRHS where
  denominator_rhs_nonnegative := fun k =>
    (h k).woodbury_denominator_point_tail_estimate.rhs_nonnegative
  denominator_bad_event_probability := fun k =>
    (h k).woodbury_denominator_point_tail_estimate.bad_event_probability

/--
Repackage pointwise Woodbury-denominator tail-estimate providers into the
family-level bad-event probability provider.
-/
theorem paperH2WoodburyDenominatorBadEventProbabilityProvider_of_pointTailEstimateProviders
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h :
      ∀ k : Fin n,
        PaperH2WoodburyDenominatorPointTailEstimateProvider
          P X k lam (denominatorRHS k)) :
    PaperH2WoodburyDenominatorBadEventProbabilityProvider
      P X lam denominatorRHS where
  woodbury_denominator_bad_event_probability :=
    paperH2WoodburyDenominatorBadEventProbabilityStatement_of_pointTailEstimateProviders
      P X lam denominatorRHS h

/--
Real-valued RHS for the H2 resolvent atomic bad-event union-bound route.

This is only vocabulary for the sum of the shifted determinant bad-event RHS
and the finite family of leave-one-out determinant/denominator bad-event RHSs.
It proves no determinant, denominator, resolvent, or concentration estimate.
-/
def paperH2ResolventAtomicBadEventUnionBoundRHS {n : Nat}
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS) :
    PaperH2GoodEventProbabilityRHS :=
  shrinkageRHS + ∑ k : Fin n, (leaveOneOutRHS k + denominatorRHS k)

/--
Nonnegativity of the H2 resolvent atomic bad-event union-bound RHS from
component RHS nonnegativity hypotheses.
-/
theorem paperH2ResolventAtomicBadEventUnionBoundRHS_nonnegative {n : Nat}
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (hShrinkage : 0 <= shrinkageRHS)
    (hLeaveOneOut : ∀ k : Fin n, 0 <= leaveOneOutRHS k)
    (hDenominator : ∀ k : Fin n, 0 <= denominatorRHS k) :
    0 <= paperH2ResolventAtomicBadEventUnionBoundRHS
      shrinkageRHS leaveOneOutRHS denominatorRHS := by
  dsimp [paperH2ResolventAtomicBadEventUnionBoundRHS]
  exact add_nonneg hShrinkage
    (Finset.sum_nonneg fun k _ =>
      add_nonneg (hLeaveOneOut k) (hDenominator k))

/--
RHS-side vocabulary for the H2 resolvent atomic point-tail route.

This packages only nonnegativity assumptions for the full shifted-determinant
RHS and the pointwise leave-one-out shifted-determinant/Woodbury-denominator
RHS families.  It proves no probability estimate.
-/
structure PaperH2ResolventAtomicTailRHSProvider {n : Nat}
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS) :
    Prop where
  shrinkage_rhs_nonnegative : 0 <= shrinkageRHS
  leave_one_out_rhs_nonnegative : ∀ k : Fin n, 0 <= leaveOneOutRHS k
  denominator_rhs_nonnegative : ∀ k : Fin n, 0 <= denominatorRHS k

/--
Direct projection of the shrinkage shifted-determinant RHS nonnegativity field.

This theorem is API glue only: it does not prove any probability estimate.
-/
theorem PaperH2ResolventAtomicTailRHSProvider_shrinkage_rhs_nonnegative
    {n : Nat}
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicTailRHSProvider
      shrinkageRHS leaveOneOutRHS denominatorRHS) :
    0 <= shrinkageRHS :=
  h.shrinkage_rhs_nonnegative

/--
Direct projection of the leave-one-out shifted-determinant RHS nonnegativity field.

This theorem is API glue only: it does not prove any probability estimate.
-/
theorem PaperH2ResolventAtomicTailRHSProvider_leave_one_out_rhs_nonnegative
    {n : Nat}
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicTailRHSProvider
      shrinkageRHS leaveOneOutRHS denominatorRHS) (k : Fin n) :
    0 <= leaveOneOutRHS k :=
  h.leave_one_out_rhs_nonnegative k

/--
Direct projection of the Woodbury-denominator RHS nonnegativity field.

This theorem is API glue only: it does not prove any probability estimate.
-/
theorem PaperH2ResolventAtomicTailRHSProvider_denominator_rhs_nonnegative
    {n : Nat}
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicTailRHSProvider
      shrinkageRHS leaveOneOutRHS denominatorRHS) (k : Fin n) :
    0 <= denominatorRHS k :=
  h.denominator_rhs_nonnegative k

/--
Nonnegativity of the atomic union-bound RHS from the named RHS provider.
-/
theorem paperH2ResolventAtomicBadEventUnionBoundRHS_nonnegative_of_rhsProvider
    {n : Nat}
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicTailRHSProvider
      shrinkageRHS leaveOneOutRHS denominatorRHS) :
    0 <= paperH2ResolventAtomicBadEventUnionBoundRHS
      shrinkageRHS leaveOneOutRHS denominatorRHS :=
  paperH2ResolventAtomicBadEventUnionBoundRHS_nonnegative
    shrinkageRHS leaveOneOutRHS denominatorRHS
    h.shrinkage_rhs_nonnegative h.leave_one_out_rhs_nonnegative
    h.denominator_rhs_nonnegative

/--
Provider bundle for the atomic point-tail hypotheses that feed the H2
resolvent bad-event union-bound route.

The fields are explicit tail-estimate providers only; this structure does not
prove determinant tails, denominator tails, or concentration estimates.
-/
structure PaperH2ResolventAtomicPointTailEstimateProviders {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS) :
    Prop where
  shrinkage_shifted_det_tail_estimate :
    PaperH2ShrinkageShiftedDetTailEstimateProvider P X lam shrinkageRHS
  leave_one_out_shifted_det_point_tail_estimate :
    ∀ k : Fin n,
      PaperH2LeaveOneOutShiftedDetPointTailEstimateProvider
        P X k lam (leaveOneOutRHS k)
  woodbury_denominator_point_tail_estimate :
    ∀ k : Fin n,
      PaperH2WoodburyDenominatorPointTailEstimateProvider
        P X k lam (denominatorRHS k)

/--
Extract the named RHS provider from the atomic point-tail provider bundle.
-/
theorem paperH2ResolventAtomicTailRHSProvider_of_pointTailEstimateProviders
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicPointTailEstimateProviders
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS) :
    PaperH2ResolventAtomicTailRHSProvider
      shrinkageRHS leaveOneOutRHS denominatorRHS where
  shrinkage_rhs_nonnegative :=
    h.shrinkage_shifted_det_tail_estimate
      |>.shrinkage_shifted_det_tail_estimate
      |>.rhs_nonnegative
  leave_one_out_rhs_nonnegative := fun k =>
    (h.leave_one_out_shifted_det_point_tail_estimate k)
      |>.leave_one_out_shifted_det_point_tail_estimate
      |>.rhs_nonnegative
  denominator_rhs_nonnegative := fun k =>
    (h.woodbury_denominator_point_tail_estimate k)
      |>.woodbury_denominator_point_tail_estimate
      |>.rhs_nonnegative

/--
Probability provider for the named atomic bad events covering the H2 resolvent
bad event.

This packages explicit probability hypotheses for the full shifted determinant
failure and each leave-one-out determinant/denominator failure.  It does not
prove any of those atomic estimates.
-/
structure PaperH2ResolventAtomicBadEventProbabilityProvider {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS) :
    Prop where
  shrinkage_rhs_nonnegative : 0 <= shrinkageRHS
  leave_one_out_rhs_nonnegative : ∀ k : Fin n, 0 <= leaveOneOutRHS k
  denominator_rhs_nonnegative : ∀ k : Fin n, 0 <= denominatorRHS k
  shrinkage_bad_event_probability :
    P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
      ENNReal.ofReal shrinkageRHS
  leave_one_out_bad_event_probability :
    ∀ k : Fin n,
      P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
        ENNReal.ofReal (leaveOneOutRHS k)
  denominator_bad_event_probability :
    ∀ k : Fin n,
      P (paperH2WoodburyDenominatorBadEvent X k lam) <=
        ENNReal.ofReal (denominatorRHS k)

/--
Direct field projection for the shrinkage shifted-determinant RHS
nonnegativity stored in an atomic resolvent bad-event probability provider.
This exposes a supplied field only; it proves no tail estimate.
-/
theorem PaperH2ResolventAtomicBadEventProbabilityProvider_shrinkage_rhs_nonnegative
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS) :
    0 <= shrinkageRHS :=
  h.shrinkage_rhs_nonnegative

/--
Direct field projection for the leave-one-out shifted-determinant RHS
nonnegativity stored in an atomic resolvent bad-event probability provider.
This exposes supplied fields only; it proves no tail estimate.
-/
theorem PaperH2ResolventAtomicBadEventProbabilityProvider_leave_one_out_rhs_nonnegative
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS) (k : Fin n) :
    0 <= leaveOneOutRHS k :=
  h.leave_one_out_rhs_nonnegative k

/--
Direct field projection for the Woodbury-denominator RHS nonnegativity stored
in an atomic resolvent bad-event probability provider.  This exposes supplied
fields only; it proves no tail estimate.
-/
theorem PaperH2ResolventAtomicBadEventProbabilityProvider_denominator_rhs_nonnegative
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS) (k : Fin n) :
    0 <= denominatorRHS k :=
  h.denominator_rhs_nonnegative k

/--
Direct field projection for the supplied shrinkage shifted-determinant bad-event
probability bound stored in an atomic resolvent provider.  This proves no
determinant-tail or concentration estimate.
-/
theorem PaperH2ResolventAtomicBadEventProbabilityProvider_shrinkage_bad_event_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS) :
    P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
      ENNReal.ofReal shrinkageRHS :=
  h.shrinkage_bad_event_probability

/--
Direct field projection for the supplied leave-one-out shifted-determinant
bad-event probability bounds stored in an atomic resolvent provider.  This
proves no determinant-tail or concentration estimate.
-/
theorem PaperH2ResolventAtomicBadEventProbabilityProvider_leave_one_out_bad_event_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS) (k : Fin n) :
    P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
      ENNReal.ofReal (leaveOneOutRHS k) :=
  h.leave_one_out_bad_event_probability k

/--
Direct field projection for the supplied Woodbury-denominator bad-event
probability bounds stored in an atomic resolvent provider.  This proves no
denominator-tail or concentration estimate.
-/
theorem PaperH2ResolventAtomicBadEventProbabilityProvider_denominator_bad_event_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS) (k : Fin n) :
    P (paperH2WoodburyDenominatorBadEvent X k lam) <=
      ENNReal.ofReal (denominatorRHS k) :=
  h.denominator_bad_event_probability k

/--
Build the full atomic resolvent bad-event probability provider from a
shifted-determinant provider plus explicit Woodbury-denominator failure bounds.

This is only provider plumbing: it combines already-supplied atomic component
probability hypotheses and proves no determinant or denominator tail estimate.
-/
theorem paperH2ResolventAtomicBadEventProbabilityProvider_of_shiftedDetProvider_and_denominatorBounds
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (hShifted : PaperH2ShiftedDetBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS)
    (hDenominatorNonnegative : ∀ k : Fin n, 0 <= denominatorRHS k)
    (hDenominatorProbability :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal (denominatorRHS k)) :
    PaperH2ResolventAtomicBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS where
  shrinkage_rhs_nonnegative :=
    hShifted.shifted_det_bad_event_probability.shrinkage_rhs_nonnegative
  leave_one_out_rhs_nonnegative :=
    hShifted.shifted_det_bad_event_probability.leave_one_out_rhs_nonnegative
  denominator_rhs_nonnegative := hDenominatorNonnegative
  shrinkage_bad_event_probability :=
    hShifted.shifted_det_bad_event_probability.shrinkage_bad_event_probability
  leave_one_out_bad_event_probability :=
    hShifted.shifted_det_bad_event_probability.leave_one_out_bad_event_probability
  denominator_bad_event_probability := hDenominatorProbability

/--
Build the full atomic resolvent bad-event probability provider from separate
shifted-determinant and Woodbury-denominator providers.

This is provider plumbing only: both atomic component estimates remain explicit
inputs.
-/
theorem paperH2ResolventAtomicBadEventProbabilityProvider_of_shiftedDetProvider_and_denominatorProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (hShifted : PaperH2ShiftedDetBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS)
    (hDenominator : PaperH2WoodburyDenominatorBadEventProbabilityProvider
      P X lam denominatorRHS) :
    PaperH2ResolventAtomicBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS :=
  paperH2ResolventAtomicBadEventProbabilityProvider_of_shiftedDetProvider_and_denominatorBounds
    P X lam shrinkageRHS leaveOneOutRHS denominatorRHS hShifted
    hDenominator.woodbury_denominator_bad_event_probability.denominator_rhs_nonnegative
    hDenominator.woodbury_denominator_bad_event_probability.denominator_bad_event_probability

/--
Build the atomic resolvent bad-event probability provider from the bundled
point-tail providers.

This is only provider plumbing: the shifted-determinant and
Woodbury-denominator point-tail estimates remain explicit inputs.
-/
theorem paperH2ResolventAtomicBadEventProbabilityProvider_of_pointTailEstimateProviders
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicPointTailEstimateProviders
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS) :
    PaperH2ResolventAtomicBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS :=
  paperH2ResolventAtomicBadEventProbabilityProvider_of_shiftedDetProvider_and_denominatorProvider
    P X lam shrinkageRHS leaveOneOutRHS denominatorRHS
    (paperH2ShiftedDetBadEventProbabilityProvider_of_tailEstimateProviders
      P X lam shrinkageRHS leaveOneOutRHS
      h.shrinkage_shifted_det_tail_estimate
      h.leave_one_out_shifted_det_point_tail_estimate)
    (paperH2WoodburyDenominatorBadEventProbabilityProvider_of_pointTailEstimateProviders
      P X lam denominatorRHS h.woodbury_denominator_point_tail_estimate)

/--
Build the atomic resolvent bad-event probability provider from supplied
paper-RHS bounds for the shifted-determinant and Woodbury-denominator atomic
components.

This is only provider plumbing: the supplied component bounds remain explicit
inputs, and this proves no determinant tail, denominator tail, resolvent tail,
or concentration estimate.
-/
theorem paperH2ResolventAtomicBadEventProbabilityProvider_of_paperRHS_bounds
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hDenominatorPrefactor : 0 <= denominatorParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam))
    (hDenominatorBounds :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam)) :
    PaperH2ResolventAtomicBadEventProbabilityProvider P X lam
      (paperH2ShrinkageShiftedDetTailPaperRHS
        (d := d) (n := n) shrinkageParams lam)
      (fun _ =>
        paperH2LeaveOneOutShiftedDetPointTailPaperRHS
          (d := d) (n := n) leaveOneOutParams lam)
      (fun _ =>
        paperH2WoodburyDenominatorPointTailPaperRHS
          (d := d) (n := n) denominatorParams lam) :=
  paperH2ResolventAtomicBadEventProbabilityProvider_of_shiftedDetProvider_and_denominatorProvider
    P X lam
    (paperH2ShrinkageShiftedDetTailPaperRHS
      (d := d) (n := n) shrinkageParams lam)
    (fun _ =>
      paperH2LeaveOneOutShiftedDetPointTailPaperRHS
        (d := d) (n := n) leaveOneOutParams lam)
    (fun _ =>
      paperH2WoodburyDenominatorPointTailPaperRHS
        (d := d) (n := n) denominatorParams lam)
    (paperH2ShiftedDetBadEventProbabilityProvider_of_paperRHS_bounds
      P X lam shrinkageParams leaveOneOutParams hShrinkagePrefactor
      hLeaveOneOutPrefactor hShrinkageBound hLeaveOneOutBounds)
    (paperH2WoodburyDenominatorBadEventProbabilityProvider_of_pointTailEstimateProviders
      P X lam
      (fun _ =>
        paperH2WoodburyDenominatorPointTailPaperRHS
          (d := d) (n := n) denominatorParams lam)
      (fun k =>
        paperH2WoodburyDenominatorPointTailEstimateProvider_of_paperRHS_bound
          P X k lam denominatorParams hDenominatorPrefactor
          (hDenominatorBounds k)))

/--
Typed union-bound consumer for the H2 resolvent atomic bad-event cover.

The statement combines explicit atomic bad-event probability hypotheses with
the set-level cover `paperH2ResolventBadEvent_subset_atomicBadUnion`.  The only
proof content is finite subadditivity and `ENNReal.ofReal` normalization; the
atomic probability estimates remain provider inputs.
-/
structure PaperH2ResolventAtomicBadEventUnionBoundStatement {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS) :
    Prop where
  atomic_bad_event_probability :
    PaperH2ResolventAtomicBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS
  atomic_bad_union_probability :
    P (paperH2ResolventAtomicBadUnionEvent X lam) <=
      ENNReal.ofReal
        (paperH2ResolventAtomicBadEventUnionBoundRHS
          shrinkageRHS leaveOneOutRHS denominatorRHS)
  resolvent_bad_event_probability :
    PaperH2ResolventBadEventProbabilityStatement P X lam
      (paperH2ResolventAtomicBadEventUnionBoundRHS
        shrinkageRHS leaveOneOutRHS denominatorRHS)

/--
Direct projection of the atomic probability-provider field from the atomic
union-bound statement.

This theorem is API glue only: it does not prove any new probability estimate.
-/
theorem PaperH2ResolventAtomicBadEventUnionBoundStatement_atomic_bad_event_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicBadEventUnionBoundStatement
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS) :
    PaperH2ResolventAtomicBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS :=
  h.atomic_bad_event_probability

/--
Direct projection of the atomic bad-union probability field from the atomic
union-bound statement.

This theorem is API glue only: it does not prove any new probability estimate.
-/
theorem PaperH2ResolventAtomicBadEventUnionBoundStatement_atomic_bad_union_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicBadEventUnionBoundStatement
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS) :
    P (paperH2ResolventAtomicBadUnionEvent X lam) <=
      ENNReal.ofReal
        (paperH2ResolventAtomicBadEventUnionBoundRHS
          shrinkageRHS leaveOneOutRHS denominatorRHS) :=
  h.atomic_bad_union_probability

/--
Direct projection of the resolvent bad-event probability statement field from
the atomic union-bound statement.

This theorem is API glue only: it does not prove any new probability estimate.
-/
theorem PaperH2ResolventAtomicBadEventUnionBoundStatement_resolvent_bad_event_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicBadEventUnionBoundStatement
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS) :
    PaperH2ResolventBadEventProbabilityStatement P X lam
      (paperH2ResolventAtomicBadEventUnionBoundRHS
        shrinkageRHS leaveOneOutRHS denominatorRHS) :=
  h.resolvent_bad_event_probability

/--
Probability bound for the H2 resolvent atomic bad-event union from explicit
atomic probability hypotheses.

This is a finite union-bound over the named atomic bad events only.  It proves
no determinant, Woodbury denominator, or concentration estimate.
-/
theorem paperH2ResolventAtomicBadUnionEventProbability_bound_of_atomicProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS) :
    P (paperH2ResolventAtomicBadUnionEvent X lam) <=
      ENNReal.ofReal
        (paperH2ResolventAtomicBadEventUnionBoundRHS
          shrinkageRHS leaveOneOutRHS denominatorRHS) := by
  let indexedBad : Set Omega :=
    {omega | ∃ k : Fin n,
      omega ∈ paperH2LeaveOneOutShiftedDetBadEvent X k lam ∨
        omega ∈ paperH2WoodburyDenominatorBadEvent X k lam}
  have hIndexedSet :
      indexedBad =
        ⋃ k ∈ (Finset.univ : Finset (Fin n)),
          (paperH2LeaveOneOutShiftedDetBadEvent X k lam ∪
            paperH2WoodburyDenominatorBadEvent X k lam) := by
    ext omega
    simp [indexedBad]
  have hIndexedMeasure :
      P indexedBad <=
        ∑ k : Fin n,
          (P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) +
            P (paperH2WoodburyDenominatorBadEvent X k lam)) := by
    calc
      P indexedBad =
          P (⋃ k ∈ (Finset.univ : Finset (Fin n)),
            (paperH2LeaveOneOutShiftedDetBadEvent X k lam ∪
              paperH2WoodburyDenominatorBadEvent X k lam)) := by
        rw [hIndexedSet]
      _ <= ∑ k ∈ (Finset.univ : Finset (Fin n)),
          P (paperH2LeaveOneOutShiftedDetBadEvent X k lam ∪
            paperH2WoodburyDenominatorBadEvent X k lam) :=
        HighDimProb.measure_biUnion_le P (Finset.univ : Finset (Fin n))
          (fun k =>
            paperH2LeaveOneOutShiftedDetBadEvent X k lam ∪
              paperH2WoodburyDenominatorBadEvent X k lam)
      _ <= ∑ k ∈ (Finset.univ : Finset (Fin n)),
          (P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) +
            P (paperH2WoodburyDenominatorBadEvent X k lam)) :=
        Finset.sum_le_sum fun k _ =>
          measure_union_le
            (paperH2LeaveOneOutShiftedDetBadEvent X k lam)
            (paperH2WoodburyDenominatorBadEvent X k lam)
      _ = ∑ k : Fin n,
          (P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) +
            P (paperH2WoodburyDenominatorBadEvent X k lam)) := by
        simp
  have hAtomicBound :
      P (paperH2ResolventAtomicBadUnionEvent X lam) <=
        ENNReal.ofReal shrinkageRHS +
          ∑ k : Fin n,
            (ENNReal.ofReal (leaveOneOutRHS k) +
              ENNReal.ofReal (denominatorRHS k)) := by
    calc
      P (paperH2ResolventAtomicBadUnionEvent X lam)
          <= P (paperH2ShrinkageShiftedDetBadEvent X lam) + P indexedBad := by
        dsimp [paperH2ResolventAtomicBadUnionEvent, indexedBad]
        exact measure_union_le _ _
      _ <= P (paperH2ShrinkageShiftedDetBadEvent X lam) +
          ∑ k : Fin n,
            (P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) +
              P (paperH2WoodburyDenominatorBadEvent X k lam)) := by
        exact add_le_add_right hIndexedMeasure _
      _ <= ENNReal.ofReal shrinkageRHS +
          ∑ k : Fin n,
            (ENNReal.ofReal (leaveOneOutRHS k) +
              ENNReal.ofReal (denominatorRHS k)) := by
        exact add_le_add h.shrinkage_bad_event_probability
          (Finset.sum_le_sum fun k _ =>
            add_le_add
              (h.leave_one_out_bad_event_probability k)
              (h.denominator_bad_event_probability k))
  calc
    P (paperH2ResolventAtomicBadUnionEvent X lam)
        <= ENNReal.ofReal shrinkageRHS +
          ∑ k : Fin n,
            (ENNReal.ofReal (leaveOneOutRHS k) +
              ENNReal.ofReal (denominatorRHS k)) := hAtomicBound
    _ = ENNReal.ofReal
        (paperH2ResolventAtomicBadEventUnionBoundRHS
          shrinkageRHS leaveOneOutRHS denominatorRHS) := by
      dsimp [paperH2ResolventAtomicBadEventUnionBoundRHS]
      have hSumNonnegative :
          0 <= ∑ k : Fin n, (leaveOneOutRHS k + denominatorRHS k) :=
        Finset.sum_nonneg fun k _ =>
          add_nonneg (h.leave_one_out_rhs_nonnegative k)
            (h.denominator_rhs_nonnegative k)
      rw [ENNReal.ofReal_add h.shrinkage_rhs_nonnegative hSumNonnegative]
      have hOfRealSum :
          ENNReal.ofReal
              (∑ k : Fin n, (leaveOneOutRHS k + denominatorRHS k)) =
            ∑ k : Fin n,
              ENNReal.ofReal (leaveOneOutRHS k + denominatorRHS k) := by
        exact ENNReal.ofReal_sum_of_nonneg fun k _ =>
          add_nonneg (h.leave_one_out_rhs_nonnegative k)
            (h.denominator_rhs_nonnegative k)
      rw [hOfRealSum]
      congr 1
      apply Finset.sum_congr rfl
      intro k _
      exact (ENNReal.ofReal_add
        (h.leave_one_out_rhs_nonnegative k)
        (h.denominator_rhs_nonnegative k)).symm

/--
Build the H2 resolvent atomic union-bound statement from atomic bad-event
probability hypotheses.
-/
theorem paperH2ResolventAtomicBadEventUnionBoundStatement_of_atomicProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS) :
    PaperH2ResolventAtomicBadEventUnionBoundStatement
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS where
  atomic_bad_event_probability := h
  atomic_bad_union_probability :=
    paperH2ResolventAtomicBadUnionEventProbability_bound_of_atomicProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS h
  resolvent_bad_event_probability := by
    refine ⟨?_, ?_⟩
    · exact paperH2ResolventAtomicBadEventUnionBoundRHS_nonnegative
        shrinkageRHS leaveOneOutRHS denominatorRHS
        h.shrinkage_rhs_nonnegative h.leave_one_out_rhs_nonnegative
        h.denominator_rhs_nonnegative
    · calc
        P (paperH2ResolventBadEvent X lam)
            <= P (paperH2ResolventAtomicBadUnionEvent X lam) :=
          measure_mono (paperH2ResolventBadEvent_subset_atomicBadUnion X lam)
        _ <= ENNReal.ofReal
            (paperH2ResolventAtomicBadEventUnionBoundRHS
              shrinkageRHS leaveOneOutRHS denominatorRHS) :=
          paperH2ResolventAtomicBadUnionEventProbability_bound_of_atomicProvider
            P X lam shrinkageRHS leaveOneOutRHS denominatorRHS h

/--
Projection of the H2 resolvent bad-event probability bound from atomic
bad-event probability hypotheses.
-/
theorem paperH2ResolventAtomicBadEventUnionBound_bound_of_atomicProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS) :
    P (paperH2ResolventBadEvent X lam) <=
      ENNReal.ofReal
        (paperH2ResolventAtomicBadEventUnionBoundRHS
          shrinkageRHS leaveOneOutRHS denominatorRHS) := by
  let s :=
    paperH2ResolventAtomicBadEventUnionBoundStatement_of_atomicProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS h
  exact s.resolvent_bad_event_probability.bad_event_probability

/--
Provider-form bridge from atomic resolvent bad-event probability hypotheses to
the existing resolvent bad-event probability provider surface.
-/
theorem paperH2ResolventBadEventProbabilityProvider_of_atomicProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageRHS : PaperH2GoodEventProbabilityRHS)
    (leaveOneOutRHS denominatorRHS : Fin n -> PaperH2GoodEventProbabilityRHS)
    (h : PaperH2ResolventAtomicBadEventProbabilityProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS) :
    PaperH2ResolventBadEventProbabilityProvider P X lam
      (paperH2ResolventAtomicBadEventUnionBoundRHS
        shrinkageRHS leaveOneOutRHS denominatorRHS) where
  resolvent_bad_event_probability :=
    (paperH2ResolventAtomicBadEventUnionBoundStatement_of_atomicProvider
      P X lam shrinkageRHS leaveOneOutRHS denominatorRHS h).resolvent_bad_event_probability

/--
Paper-RHS bridge from supplied component bounds to the resolvent bad-event
probability provider.

This is only provider plumbing: it combines the paper-RHS atomic bad-event
provider with the existing atomic union-bound consumer.  It proves no shifted
determinant tail, denominator tail, resolvent tail, concentration estimate, or
Theorem 1 bound.
-/
theorem paperH2ResolventBadEventProbabilityProvider_of_paperRHS_bounds
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hDenominatorPrefactor : 0 <= denominatorParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam))
    (hDenominatorBounds :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam)) :
    PaperH2ResolventBadEventProbabilityProvider P X lam
      (paperH2ResolventAtomicBadEventUnionBoundRHS
        (paperH2ShrinkageShiftedDetTailPaperRHS
          (d := d) (n := n) shrinkageParams lam)
        (fun _ : Fin n =>
          paperH2LeaveOneOutShiftedDetPointTailPaperRHS
            (d := d) (n := n) leaveOneOutParams lam)
        (fun _ : Fin n =>
          paperH2WoodburyDenominatorPointTailPaperRHS
            (d := d) (n := n) denominatorParams lam)) :=
  paperH2ResolventBadEventProbabilityProvider_of_atomicProvider
    P X lam
    (paperH2ShrinkageShiftedDetTailPaperRHS
      (d := d) (n := n) shrinkageParams lam)
    (fun _ : Fin n =>
      paperH2LeaveOneOutShiftedDetPointTailPaperRHS
        (d := d) (n := n) leaveOneOutParams lam)
    (fun _ : Fin n =>
      paperH2WoodburyDenominatorPointTailPaperRHS
        (d := d) (n := n) denominatorParams lam)
    (paperH2ResolventAtomicBadEventProbabilityProvider_of_paperRHS_bounds
      P X lam shrinkageParams leaveOneOutParams denominatorParams
      hShrinkagePrefactor hLeaveOneOutPrefactor hDenominatorPrefactor
      hShrinkageBound hLeaveOneOutBounds hDenominatorBounds)

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
Pointwise full-bad-event factorization for the H2 leave-one-out event.

If the full H2 leave-one-out good event fails, then either the eta-only
lower-singular-value good event fails or the lambda-dependent resolvent side
fails.  This is only propositional/set algebra from the existing good-event
factorization.
-/
theorem paperH2LeaveOneOutBadEvent_mem_imp_lowerBad_or_resolventBad
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real) (omega : Omega) :
    omega ∈ paperH2LeaveOneOutBadEvent X eta lam →
      omega ∈ paperH2LowerSingularValueBadEvent X eta ∨
        omega ∈ paperH2ResolventBadEvent X lam := by
  intro hBad
  by_cases hLower : omega ∈ paperH2LowerSingularValueGoodEvent X eta
  · right
    show omega ∉ paperH2ResolventGoodEvent X lam
    intro hResolvent
    exact hBad
      (paperH2LeaveOneOutGoodEvent_of_lowerSingularValue_and_resolvent
        X eta lam omega hLower hResolvent)
  · left
    exact hLower

/--
Set-level full-bad-event factorization for the H2 leave-one-out event.

This is the deterministic union upper event used by later probability-union
bound provider work.  It proves no measurability or probability inequality.
-/
theorem paperH2LeaveOneOutBadEvent_subset_lowerBad_union_resolventBad
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real) :
    (paperH2LeaveOneOutBadEvent X eta lam).Subset
      (paperH2LowerSingularValueBadEvent X eta ∪ paperH2ResolventBadEvent X lam) := by
  intro omega hBad
  exact paperH2LeaveOneOutBadEvent_mem_imp_lowerBad_or_resolventBad
    X eta lam omega hBad

/--
Typed union-bound consumer for the H2 leave-one-out bad event.

This statement packages the already-named lower-bad and resolvent-bad
probability inputs, plus the pure measure-theoretic union-bound consequence for
the full leave-one-out bad event.  It does not prove either component
probability estimate.
-/
structure PaperH2LeaveOneOutBadEventUnionBoundStatement {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS) : Prop where
  lower_bad_event_probability :
    PaperH2LowerSingularValueBadEventProbabilityStatement P X eta lowerRHS
  resolvent_bad_event_probability :
    PaperH2ResolventBadEventProbabilityStatement P X lam resolventRHS
  bad_event_probability :
    P (paperH2LeaveOneOutBadEvent X eta lam) <=
      ENNReal.ofReal lowerRHS + ENNReal.ofReal resolventRHS

/--
Direct projection of the lower-bad probability statement field from the H2
leave-one-out bad-event union-bound statement.

This theorem is API glue only: it does not prove a component probability bound.
-/
theorem PaperH2LeaveOneOutBadEventUnionBoundStatement_lower_bad_event_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LeaveOneOutBadEventUnionBoundStatement
      P X eta lam lowerRHS resolventRHS) :
    PaperH2LowerSingularValueBadEventProbabilityStatement P X eta lowerRHS :=
  h.lower_bad_event_probability

/--
Direct projection of the resolvent-bad probability statement field from the H2
leave-one-out bad-event union-bound statement.

This theorem is API glue only: it does not prove a component probability bound.
-/
theorem PaperH2LeaveOneOutBadEventUnionBoundStatement_resolvent_bad_event_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LeaveOneOutBadEventUnionBoundStatement
      P X eta lam lowerRHS resolventRHS) :
    PaperH2ResolventBadEventProbabilityStatement P X lam resolventRHS :=
  h.resolvent_bad_event_probability

/--
Direct projection of the H2 leave-one-out bad-event union-bound field.

This theorem is API glue only: it does not prove a component probability bound.
-/
theorem PaperH2LeaveOneOutBadEventUnionBoundStatement_bad_event_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LeaveOneOutBadEventUnionBoundStatement
      P X eta lam lowerRHS resolventRHS) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <=
      ENNReal.ofReal lowerRHS + ENNReal.ofReal resolventRHS :=
  h.bad_event_probability

/--
Build the H2 leave-one-out bad-event union-bound statement from the two
component bad-event probability providers.

The only proof here is the deterministic set inclusion followed by
`measure_union_le`; the lower-bad and resolvent-bad probability estimates remain
explicit provider inputs.
-/
theorem paperH2LeaveOneOutBadEventUnionBoundStatement_of_probabilityProviders
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS)
    (hLower : PaperH2LowerSingularValueBadEventProbabilityProvider
      P X eta lowerRHS)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    PaperH2LeaveOneOutBadEventUnionBoundStatement
      P X eta lam lowerRHS resolventRHS where
  lower_bad_event_probability := hLower.lower_bad_event_probability
  resolvent_bad_event_probability := hResolvent.resolvent_bad_event_probability
  bad_event_probability := by
    calc
      P (paperH2LeaveOneOutBadEvent X eta lam)
          <= P (paperH2LowerSingularValueBadEvent X eta ∪
              paperH2ResolventBadEvent X lam) :=
        measure_mono
          (paperH2LeaveOneOutBadEvent_subset_lowerBad_union_resolventBad
            X eta lam)
      _ <= P (paperH2LowerSingularValueBadEvent X eta) +
          P (paperH2ResolventBadEvent X lam) :=
        measure_union_le _ _
      _ <= ENNReal.ofReal lowerRHS + ENNReal.ofReal resolventRHS :=
        add_le_add
          hLower.lower_bad_event_probability.bad_event_probability
          hResolvent.resolvent_bad_event_probability.bad_event_probability

/--
Projection of the H2 leave-one-out bad-event union-bound consequence from the
two component bad-event probability providers.
-/
theorem paperH2LeaveOneOutBadEventUnionBound_bound_of_probabilityProviders
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS)
    (hLower : PaperH2LowerSingularValueBadEventProbabilityProvider
      P X eta lowerRHS)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <=
      ENNReal.ofReal lowerRHS + ENNReal.ofReal resolventRHS :=
  (paperH2LeaveOneOutBadEventUnionBoundStatement_of_probabilityProviders
    P X eta lam lowerRHS resolventRHS hLower hResolvent).bad_event_probability

/--
Projection of the H2 leave-one-out bad-event union-bound consequence using the
named combined Real RHS.

The only additional proof step is `ENNReal.ofReal_add` under the component
provider nonnegativity fields; no component probability estimate is proved.
-/
theorem paperH2LeaveOneOutBadEventUnionBound_bound_of_probabilityProviders_realRHS
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS)
    (hLower : PaperH2LowerSingularValueBadEventProbabilityProvider
      P X eta lowerRHS)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <=
      ENNReal.ofReal
        (paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS resolventRHS) := by
  calc
    P (paperH2LeaveOneOutBadEvent X eta lam)
        <= ENNReal.ofReal lowerRHS + ENNReal.ofReal resolventRHS :=
      paperH2LeaveOneOutBadEventUnionBound_bound_of_probabilityProviders
        P X eta lam lowerRHS resolventRHS hLower hResolvent
    _ = ENNReal.ofReal
        (paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS resolventRHS) := by
      rw [paperH2LeaveOneOutBadEventUnionBoundRHS]
      exact (ENNReal.ofReal_add
        hLower.lower_bad_event_probability.rhs_nonnegative
        hResolvent.resolvent_bad_event_probability.rhs_nonnegative).symm

/--
H2 bad-event union-bound statement from the deterministic lower-event provider
and an explicit resolvent bad-event probability provider.

This wrapper only converts the lower-event provider into the existing
eta-only lower-bad probability provider, then reuses the union-bound consumer.
It proves no lower-tail, resolvent-tail, concentration, or Theorem 1 estimate.
-/
theorem paperH2LeaveOneOutBadEventUnionBoundStatement_of_lowerEventProvider_and_resolventProbabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    PaperH2LeaveOneOutBadEventUnionBoundStatement
      P X eta lam lowerRHS resolventRHS :=
  paperH2LeaveOneOutBadEventUnionBoundStatement_of_probabilityProviders
    P X eta lam lowerRHS resolventRHS
      (paperH2LowerSingularValueBadEventProbabilityProvider_of_eventProvider
        P X eta lowerRHS lowerRHS_nonnegative hLower)
      hResolvent

/--
Projection of the H2 bad-event union-bound probability consequence from the
lower-event provider and the explicit resolvent bad-event probability provider.
-/
theorem paperH2LeaveOneOutBadEventUnionBound_bound_of_lowerEventProvider_and_resolventProbabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <=
      ENNReal.ofReal lowerRHS + ENNReal.ofReal resolventRHS :=
  (paperH2LeaveOneOutBadEventUnionBoundStatement_of_lowerEventProvider_and_resolventProbabilityProvider
    P X eta lam lowerRHS resolventRHS lowerRHS_nonnegative hLower
      hResolvent).bad_event_probability

/--
Projection of the H2 bad-event union-bound probability consequence using the
named combined Real RHS, with the lower-bad side supplied by the deterministic
lower-event provider.
-/
theorem paperH2LeaveOneOutBadEventUnionBound_bound_of_lowerEventProvider_and_resolventProbabilityProvider_realRHS
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <=
      ENNReal.ofReal
        (paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS resolventRHS) :=
  paperH2LeaveOneOutBadEventUnionBound_bound_of_probabilityProviders_realRHS
    P X eta lam lowerRHS resolventRHS
      (paperH2LowerSingularValueBadEventProbabilityProvider_of_eventProvider
        P X eta lowerRHS lowerRHS_nonnegative hLower)
      hResolvent

/--
Provider identifying a reader-facing H2 bad-event RHS with the lower-plus-
resolvent union-bound RHS.

This is bookkeeping only: it records the chosen scalar RHS name and proves no
component tail estimate.
-/
structure PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
    (lowerRHS resolventRHS rhs : PaperH2GoodEventProbabilityRHS) : Prop where
  rhs_eq :
    rhs = paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS resolventRHS

/--
Project the RHS equality field from the H2 leave-one-out bad-event union-bound
RHS provider.

This is bookkeeping only; it proves no component tail estimate.
-/
theorem paperH2LeaveOneOutBadEventUnionBoundRHSProvider_rhs_eq
    (lowerRHS resolventRHS rhs : PaperH2GoodEventProbabilityRHS)
    (hRHS : PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS rhs) :
    rhs = paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS resolventRHS :=
  hRHS.rhs_eq

/-- Canonical provider for the definitional lower-plus-resolvent RHS. -/
theorem paperH2LeaveOneOutBadEventUnionBoundRHSProvider_self
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS) :
    PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS
      (paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS resolventRHS) where
  rhs_eq := rfl

/--
Nonnegativity projection for a named H2 union-bound RHS provider.
-/
theorem paperH2LeaveOneOutBadEventUnionBoundRHSProvider_nonnegative
    (lowerRHS resolventRHS rhs : PaperH2GoodEventProbabilityRHS)
    (hRHS : PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS rhs)
    (hLower : 0 <= lowerRHS) (hResolvent : 0 <= resolventRHS) :
    0 <= rhs := by
  rw [hRHS.rhs_eq]
  exact paperH2LeaveOneOutBadEventUnionBoundRHS_nonnegative
    lowerRHS resolventRHS hLower hResolvent

/--
H2 bad-event union-bound projection using a named RHS provider.

This repackages the combined Real RHS projection under an arbitrary RHS name
identified by `PaperH2LeaveOneOutBadEventUnionBoundRHSProvider`.
-/
theorem paperH2LeaveOneOutBadEventUnionBound_bound_of_probabilityProviders_rhsProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (lowerRHS resolventRHS rhs : PaperH2GoodEventProbabilityRHS)
    (hRHS : PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS rhs)
    (hLower : PaperH2LowerSingularValueBadEventProbabilityProvider
      P X eta lowerRHS)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <= ENNReal.ofReal rhs := by
  rw [hRHS.rhs_eq]
  exact paperH2LeaveOneOutBadEventUnionBound_bound_of_probabilityProviders_realRHS
    P X eta lam lowerRHS resolventRHS hLower hResolvent

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
Project the H2 leave-one-out bad-event measurability field from its provider.

This is only a field projection; it proves no primitive measurability.
-/
theorem paperH2LeaveOneOutBadEventMeasurabilityProvider_bad_event_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (h : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam) :
    MeasurableSet (paperH2LeaveOneOutBadEvent X eta lam) :=
  h.bad_event_measurable

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
Bad-event measurability provider from full H2 good-event measurability.

This uses only the definitional complement rewrite for
`paperH2LeaveOneOutBadEvent`; it does not prove the good event is measurable
from primitive assumptions.
-/
theorem paperH2LeaveOneOutBadEventMeasurabilityProvider_of_goodEventProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (h : PaperH2LeaveOneOutGoodEventMeasurabilityProvider X eta lam) :
    PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam where
  bad_event_measurable := by
    rw [paperH2LeaveOneOutBadEvent_eq_compl X eta lam]
    exact h.good_event_measurable.compl

/--
Bad-event measurability provider from the factorized H2 good-event component
providers.

This composes the lower/resolvent intersection provider with the complement
bridge.  It proves no primitive measurability fact.
-/
theorem paperH2LeaveOneOutBadEventMeasurabilityProvider_of_factor_providers
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (hLower : PaperH2LowerSingularValueGoodEventMeasurabilityProvider X eta)
    (hResolvent : PaperH2ResolventGoodEventMeasurabilityProvider X lam) :
    PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam :=
  paperH2LeaveOneOutBadEventMeasurabilityProvider_of_goodEventProvider X eta lam
    (paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_factor_providers
      X eta lam hLower hResolvent)

/--
Measurability of the full leave-one-out H2 good event from a pointwise
lower-singular-value event provider and a resolvent-good measurability
provider.

This only rewrites the full good event to the resolvent good event under the
supplied lower provider; it proves no primitive measurability, probability, or
concentration estimate.
-/
theorem paperH2LeaveOneOutGoodEvent_measurable_of_lowerEventProvider_and_resolventProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hResolvent : PaperH2ResolventGoodEventMeasurabilityProvider X lam) :
    MeasurableSet (paperH2LeaveOneOutGoodEvent X eta lam) := by
  rw [paperH2LeaveOneOutGoodEvent_eq_resolventGood_of_lowerEventProvider
    P X eta lam hLower]
  exact hResolvent.resolvent_good_event_measurable

/--
Provider form of
`paperH2LeaveOneOutGoodEvent_measurable_of_lowerEventProvider_and_resolventProvider`.
-/
theorem paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_lowerEventProvider_and_resolventProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hResolvent : PaperH2ResolventGoodEventMeasurabilityProvider X lam) :
    PaperH2LeaveOneOutGoodEventMeasurabilityProvider X eta lam where
  good_event_measurable :=
    paperH2LeaveOneOutGoodEvent_measurable_of_lowerEventProvider_and_resolventProvider
      P X eta lam hLower hResolvent

/--
Bad-event measurability provider from a pointwise lower-singular-value event
provider and a resolvent-good measurability provider.

This composes the deterministic good-event reduction with the existing
good-to-bad complement bridge; it proves no probability or concentration
estimate.
-/
theorem paperH2LeaveOneOutBadEventMeasurabilityProvider_of_lowerEventProvider_and_resolventProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hResolvent : PaperH2ResolventGoodEventMeasurabilityProvider X lam) :
    PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam :=
  paperH2LeaveOneOutBadEventMeasurabilityProvider_of_goodEventProvider
    X eta lam
    (paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_lowerEventProvider_and_resolventProvider
      P X eta lam hLower hResolvent)

/--
Build the H2 resolvent good-event measurability provider from the paper H1
provider's observed-data random-matrix field.

This is only the deterministic/measurability composition of the H1 data-entry
projection with the resolvent atomic provider.  It proves no lower-singular
value measurability, probability bound, concentration estimate, or Theorem 1.
-/
theorem paperH2ResolventGoodEventMeasurabilityProvider_of_h1_provider
    {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX lam : Real)
    (h1Provider : PaperH1SubGaussianModelProvider P X Z Sigma SigmaSqrt sigmaX) :
    PaperH2ResolventGoodEventMeasurabilityProvider X lam :=
  paperH2ResolventGoodEventMeasurabilityProvider_of_atomic_provider
    X lam
    (paperH2ResolventAtomicMeasurabilityProvider_of_h1_provider
      P X Z Sigma SigmaSqrt sigmaX lam h1Provider)

/--
Build the H2 resolvent bad-event measurability provider from the paper H1
provider's observed-data random-matrix field.

This composes the H1-to-atomic resolvent measurability wrapper with the
resolvent good-to-bad complement bridge.  It carries no lower-singular-value,
probability, concentration, or Theorem 1 content.
-/
theorem paperH2ResolventBadEventMeasurabilityProvider_of_h1_provider
    {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX lam : Real)
    (h1Provider : PaperH1SubGaussianModelProvider P X Z Sigma SigmaSqrt sigmaX) :
    PaperH2ResolventBadEventMeasurabilityProvider X lam :=
  paperH2ResolventBadEventMeasurabilityProvider_of_goodEventProvider
    X lam
    (paperH2ResolventGoodEventMeasurabilityProvider_of_h1_provider
      P X Z Sigma SigmaSqrt sigmaX lam h1Provider)

/--
Build the full H2 leave-one-out good-event measurability provider from H1 and
an explicit lower-singular-value good-event measurability provider.

This composes already-proved provider plumbing only; the lower-singular-value
measurability theorem itself remains a separate future proof task.
-/
theorem paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lower_provider
    {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real)
    (h1Provider : PaperH1SubGaussianModelProvider P X Z Sigma SigmaSqrt sigmaX)
    (hLower : PaperH2LowerSingularValueGoodEventMeasurabilityProvider X eta) :
    PaperH2LeaveOneOutGoodEventMeasurabilityProvider X eta lam :=
  paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_factor_providers
    X eta lam hLower
    (paperH2ResolventGoodEventMeasurabilityProvider_of_h1_provider
      P X Z Sigma SigmaSqrt sigmaX lam h1Provider)

/--
Build the H2 leave-one-out bad-event measurability provider from H1 and an
explicit lower-singular-value good-event measurability provider.

This adds only the complement bridge on top of the factorized good-event
measurability provider; it proves no probability estimate.
-/
theorem paperH2LeaveOneOutBadEventMeasurabilityProvider_of_h1_and_lower_provider
    {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real)
    (h1Provider : PaperH1SubGaussianModelProvider P X Z Sigma SigmaSqrt sigmaX)
    (hLower : PaperH2LowerSingularValueGoodEventMeasurabilityProvider X eta) :
    PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam :=
  paperH2LeaveOneOutBadEventMeasurabilityProvider_of_factor_providers
    X eta lam hLower
    (paperH2ResolventGoodEventMeasurabilityProvider_of_h1_provider
      P X Z Sigma SigmaSqrt sigmaX lam h1Provider)

/--
Build the full H2 leave-one-out good-event measurability provider from H1 and
an explicit lower-singular-value bad-event measurability provider.

This first converts the eta-only lower bad-event provider to the eta-only lower
good-event provider by complement and then reuses the factorized H2 bridge.  It
proves no primitive lower-singular-value measurability or probability estimate.
-/
theorem paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lowerBad_provider
    {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real)
    (h1Provider : PaperH1SubGaussianModelProvider P X Z Sigma SigmaSqrt sigmaX)
    (hLowerBad : PaperH2LowerSingularValueBadEventMeasurabilityProvider X eta) :
    PaperH2LeaveOneOutGoodEventMeasurabilityProvider X eta lam :=
  paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lower_provider
    P X Z Sigma SigmaSqrt sigmaX eta lam h1Provider
    (paperH2LowerSingularValueGoodEventMeasurabilityProvider_of_badEventProvider
      X eta hLowerBad)

/--
Build the full H2 leave-one-out bad-event measurability provider from H1 and an
explicit lower-singular-value bad-event measurability provider.

This is the complement-side consumer counterpart of
`paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lowerBad_provider`;
it proves no probability estimate.
-/
theorem paperH2LeaveOneOutBadEventMeasurabilityProvider_of_h1_and_lowerBad_provider
    {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real)
    (h1Provider : PaperH1SubGaussianModelProvider P X Z Sigma SigmaSqrt sigmaX)
    (hLowerBad : PaperH2LowerSingularValueBadEventMeasurabilityProvider X eta) :
    PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam :=
  paperH2LeaveOneOutBadEventMeasurabilityProvider_of_goodEventProvider X eta lam
    (paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lowerBad_provider
      P X Z Sigma SigmaSqrt sigmaX eta lam h1Provider hLowerBad)

/--
Build the full H2 leave-one-out good-event measurability provider from H1 and
the eta-only pointwise lower-singular-value event provider.

This is deterministic/provider plumbing only: the lower event provider rewrites
the eta-only lower good event to `Set.univ`, while H1 supplies the resolvent
measurability provider.  It proves no primitive lower-singular-value
measurability or probability estimate.
-/
theorem paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lowerEventProvider
    {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real)
    (h1Provider : PaperH1SubGaussianModelProvider P X Z Sigma SigmaSqrt sigmaX)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta) :
    PaperH2LeaveOneOutGoodEventMeasurabilityProvider X eta lam :=
  paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lower_provider
    P X Z Sigma SigmaSqrt sigmaX eta lam h1Provider
    (paperH2LowerSingularValueGoodEventMeasurabilityProvider_of_eventProvider
      P X eta hLower)

/--
Build the full H2 leave-one-out bad-event measurability provider from H1 and the
eta-only pointwise lower-singular-value event provider.

This adds only the leave-one-out complement bridge on top of
`paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lowerEventProvider`;
it proves no probability or concentration estimate.
-/
theorem paperH2LeaveOneOutBadEventMeasurabilityProvider_of_h1_and_lowerEventProvider
    {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real)
    (h1Provider : PaperH1SubGaussianModelProvider P X Z Sigma SigmaSqrt sigmaX)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta) :
    PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam :=
  paperH2LeaveOneOutBadEventMeasurabilityProvider_of_goodEventProvider X eta lam
    (paperH2LeaveOneOutGoodEventMeasurabilityProvider_of_h1_and_lowerEventProvider
      P X Z Sigma SigmaSqrt sigmaX eta lam h1Provider hLower)

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
Direct projection of the positivity assumption from the H2 leave-one-out
good-event probability statement.

This theorem is API glue only: it proves no probabilistic estimate.
-/
theorem PaperH2LeaveOneOutGoodEventProbabilityStatement_eta_positive
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LeaveOneOutGoodEventProbabilityStatement P X eta lam rhs) :
    0 < eta :=
  h.eta_positive

/--
Direct projection of the RHS nonnegativity assumption from the H2 leave-one-out
good-event probability statement.

This theorem is API glue only: it proves no probabilistic estimate.
-/
theorem PaperH2LeaveOneOutGoodEventProbabilityStatement_rhs_nonnegative
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LeaveOneOutGoodEventProbabilityStatement P X eta lam rhs) :
    0 <= rhs :=
  h.rhs_nonnegative

/--
Direct projection of the bad-event probability field from the H2 leave-one-out
good-event probability statement.

This theorem is API glue only: it proves no probability bound.
-/
theorem PaperH2LeaveOneOutGoodEventProbabilityStatement_bad_event_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LeaveOneOutGoodEventProbabilityStatement P X eta lam rhs) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <= ENNReal.ofReal rhs :=
  h.bad_event_probability

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
Project the H2 leave-one-out good-event probability statement from its provider.

This is only a field projection; it proves no probability estimate.
-/
theorem paperH2LeaveOneOutGoodEventProbabilityProvider_h2_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LeaveOneOutGoodEventProbabilityProvider P X eta lam rhs) :
    PaperH2LeaveOneOutGoodEventProbabilityStatement P X eta lam rhs :=
  h.h2_probability

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
Build the existing H2 good-event probability provider from lower-bad and
resolvent-bad probability providers plus a named lower-plus-resolvent RHS.

This is a provider-composition theorem only: it consumes the two component
probability providers and the RHS bookkeeping provider, then reuses the
union-bound bridge.  It proves no primitive concentration estimate.
-/
theorem paperH2LeaveOneOutGoodEventProbabilityProvider_of_unionBoundProbabilityProviders
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (lowerRHS resolventRHS rhs : PaperH2GoodEventProbabilityRHS)
    (hRHS : PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS rhs)
    (hLower : PaperH2LowerSingularValueBadEventProbabilityProvider
      P X eta lowerRHS)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    PaperH2LeaveOneOutGoodEventProbabilityProvider P X eta lam rhs where
  h2_probability := {
    eta_positive := hLower.lower_bad_event_probability.eta_positive
    rhs_nonnegative :=
      paperH2LeaveOneOutBadEventUnionBoundRHSProvider_nonnegative
        lowerRHS resolventRHS rhs hRHS
        hLower.lower_bad_event_probability.rhs_nonnegative
        hResolvent.resolvent_bad_event_probability.rhs_nonnegative
    bad_event_probability :=
      paperH2LeaveOneOutBadEventUnionBound_bound_of_probabilityProviders_rhsProvider
        P X eta lam lowerRHS resolventRHS rhs hRHS hLower hResolvent }

/--
Build the full H2 good-event probability provider from the pointwise
lower-singular-value event provider and an explicit resolvent bad-event
probability provider.

The lower component is discharged only by the deterministic empty-event wrapper
`paperH2LowerSingularValueBadEventProbabilityProvider_of_eventProvider`; the
resolvent component and RHS bookkeeping remain explicit.  No lower-tail,
resolvent-tail, or concentration estimate is proved here.
-/
theorem paperH2LeaveOneOutGoodEventProbabilityProvider_of_lowerEventProvider_and_resolventProbabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (lowerRHS resolventRHS rhs : PaperH2GoodEventProbabilityRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hRHS : PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS rhs)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    PaperH2LeaveOneOutGoodEventProbabilityProvider P X eta lam rhs :=
  paperH2LeaveOneOutGoodEventProbabilityProvider_of_unionBoundProbabilityProviders
    P X eta lam lowerRHS resolventRHS rhs hRHS
      (paperH2LowerSingularValueBadEventProbabilityProvider_of_eventProvider
        P X eta lowerRHS lowerRHS_nonnegative hLower)
      hResolvent

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
Project the H2 leave-one-out probability consumer's measurability field.

This is only a field projection; it proves no measurability fact.
-/
theorem paperH2LeaveOneOutProbabilityConsumerStatement_bad_event_measurable
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LeaveOneOutProbabilityConsumerStatement P X eta lam rhs) :
    MeasurableSet (paperH2LeaveOneOutBadEvent X eta lam) :=
  h.bad_event_measurable

/--
Project the H2 leave-one-out probability statement from its consumer wrapper.

This is only a field projection; it proves no probability estimate.
-/
theorem paperH2LeaveOneOutProbabilityConsumerStatement_h2_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LeaveOneOutProbabilityConsumerStatement P X eta lam rhs) :
    PaperH2LeaveOneOutGoodEventProbabilityStatement P X eta lam rhs :=
  h.h2_probability

/--
Project the H2 leave-one-out probability consumer's bad-event bound field.

This is only a field projection; it proves no probability estimate.
-/
theorem paperH2LeaveOneOutProbabilityConsumerStatement_bad_event_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LeaveOneOutProbabilityConsumerStatement P X eta lam rhs) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <= ENNReal.ofReal rhs :=
  h.bad_event_probability

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
Project the eta-positivity field from the lower-singular-value H2 provider.

This is only a field projection; it proves no lower-singular-value estimate.
-/
theorem paperH2LowerSingularValueProvider_eta_positive
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LowerSingularValueProvider P X eta lam rhs) :
    0 < eta :=
  h.eta_positive

/--
Project the RHS nonnegativity field from the lower-singular-value H2 provider.

This is only a field projection; it proves no lower-singular-value estimate.
-/
theorem paperH2LowerSingularValueProvider_rhs_nonnegative
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LowerSingularValueProvider P X eta lam rhs) :
    0 <= rhs :=
  h.rhs_nonnegative

/--
Project the bad-event measurability field from the lower-singular-value H2
provider.

This is only a field projection; it proves no measurability fact.
-/
theorem paperH2LowerSingularValueProvider_bad_event_measurable
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LowerSingularValueProvider P X eta lam rhs) :
    MeasurableSet (paperH2LeaveOneOutBadEvent X eta lam) :=
  h.bad_event_measurable

/--
Project the bad-event probability field from the lower-singular-value H2
provider.

This is only a field projection; it proves no probability estimate.
-/
theorem paperH2LowerSingularValueProvider_bad_event_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (eta lam : Real)
    (rhs : PaperH2GoodEventProbabilityRHS)
    (h : PaperH2LowerSingularValueProvider P X eta lam rhs) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <= ENNReal.ofReal rhs :=
  h.bad_event_probability

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
Project the H1 provider from the minimal Theorem 1 provider bundle.

This theorem is API glue only: it unfolds no H1 assumptions and proves no
sub-Gaussian or covariance fact.
-/
theorem shrinkageTheorem1Providers_h1
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real)
    (h : ShrinkageTheorem1Providers P X Z Sigma SigmaSqrt sigmaX eta lam) :
    PaperH1SubGaussianModelProvider P X Z Sigma SigmaSqrt sigmaX :=
  h.h1

/--
Project the H2 provider from the minimal Theorem 1 provider bundle.

This theorem is API glue only: it unfolds no H2 event/probability assumptions
and proves no lower-singular-value, resolvent, or concentration fact.
-/
theorem shrinkageTheorem1Providers_h2
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real)
    (h : ShrinkageTheorem1Providers P X Z Sigma SigmaSqrt sigmaX eta lam) :
    PaperH2LeaveOneOutGoodEventProvider P X eta lam :=
  h.h2

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
Project the paper-tail RHS identity from the RHS provider.

This is API glue only: it exposes a stored field and proves no probability,
concentration, or deterministic-equivalent estimate.
-/
theorem shrinkageTheorem1PaperTailRHSProvider_rhs_identifies_tail
    {d n : Nat} (rhs : PaperShrinkageTailRHS d n)
    (lambdaMinSigma sigmaX eta t : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h : ShrinkageTheorem1PaperTailRHSProvider
      rhs lambdaMinSigma sigmaX eta t tailRHS) :
    tailRHS = paperShrinkageTailRHS rhs lambdaMinSigma sigmaX eta t :=
  h.rhs_identifies_tail

/--
Project nonnegativity of the paper-tail RHS from the RHS provider.

This is API glue only: it exposes a stored field and proves no probability,
concentration, or deterministic-equivalent estimate.
-/
theorem shrinkageTheorem1PaperTailRHSProvider_rhs_nonnegative
    {d n : Nat} (rhs : PaperShrinkageTailRHS d n)
    (lambdaMinSigma sigmaX eta t : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h : ShrinkageTheorem1PaperTailRHSProvider
      rhs lambdaMinSigma sigmaX eta t tailRHS) :
    0 <= tailRHS :=
  h.rhs_nonnegative

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

/--
Constant paper-bias slot.

This is deterministic vocabulary for later scalar upper-bound consumers.  It
does not identify the paper's concrete bias formula.
-/
def constantPaperShrinkageBias {d n : Nat}
    (c : ShrinkageTheorem1BiasTerm) : PaperShrinkageBias d n :=
  fun _ _ => c

/-- Evaluate a paper shrinkage estimator `hat E_X(lambda)`. -/
def paperShrinkageEstimatedError {d n : Nat} (estimator : PaperShrinkageEstimator d n)
    (X : DataMatrix d n) (lam : Real) : Real :=
  estimator X lam

/-- Evaluate the paper bias placeholder `Delta_X(lambda)`. -/
def paperShrinkageBiasTerm {d n : Nat} (bias : PaperShrinkageBias d n)
    (X : DataMatrix d n) (lam : Real) : ShrinkageTheorem1BiasTerm :=
  bias X lam

/--
Add two paper-bias slots pointwise.

This is deterministic vocabulary for later decompositions of the paper's
`Delta_X(lambda)` term.  It only records an additive slot shape and proves no
probability or concentration estimate.
-/
def addPaperShrinkageBias {d n : Nat}
    (biasLeft biasRight : PaperShrinkageBias d n) : PaperShrinkageBias d n :=
  fun X lam => paperShrinkageBiasTerm biasLeft X lam +
    paperShrinkageBiasTerm biasRight X lam

/--
Paper Theorem 1 scalar variance-bias component `1 / (lambda^3 n d)`.

This names the explicit deterministic scalar term appearing in the paper's
`Delta_X(lambda)` bound.  It is only a pointwise algebraic component: no
probability, concentration, or full Theorem 1 bound is proved here.
-/
def paperTheorem1VarianceBiasComponent (d n : Nat) (lam : Real) :
    ShrinkageTheorem1BiasTerm :=
  1 / (lam ^ 3 * (n : Real) * (d : Real))

/--
Paper-bias slot for the Theorem 1 variance component.

The slot is sample-independent but `lambda`-dependent, so it is not represented
as a constant paper-bias slot.
-/
def paperTheorem1VariancePaperBias (d n : Nat) : PaperShrinkageBias d n :=
  fun _ lam => paperTheorem1VarianceBiasComponent d n lam

/--
Paper Theorem 1 scalar exponential-bias component `C₂ * exp(-c_X n)`.

This names the deterministic scalar exponential term appearing in the paper's
`Delta_X(lambda)` bound.  It is only a scalar component and carries no
probability, concentration, or tail-estimate proof.
-/
def paperTheorem1ExponentialBiasComponent (n : Nat) (C2 cX : Real) :
    ShrinkageTheorem1BiasTerm :=
  C2 * Real.exp (-(cX * (n : Real)))

/--
Paper-bias slot for the Theorem 1 exponential component.

The slot is sample- and `lambda`-independent once the scalar constants are fixed,
but it is named separately from `constantPaperShrinkageBias` to preserve the
paper formula component boundary.
-/
def paperTheorem1ExponentialPaperBias (d n : Nat) (C2 cX : Real) :
    PaperShrinkageBias d n :=
  fun _ _ => paperTheorem1ExponentialBiasComponent n C2 cX

/--
Paper Theorem 1 deterministic-equivalent scalar bias component
`C₁ σ_X² √d ‖Σ_X‖op³ / (n λ_d(Σ_X) η⁶)`.

This names the remaining explicit scalar term in the paper's `Delta_X(lambda)`
bound using theorem-facing scalar parameters.  It is deterministic vocabulary
only: the theorem does not prove that these parameters satisfy the paper's
spectral hypotheses or that the component bounds an estimator error.
-/
def paperTheorem1DeterministicEquivalentBiasComponent
    (d n : Nat) (C1 sigmaX sigmaOp lambdaMinSigma eta : Real) :
    ShrinkageTheorem1BiasTerm :=
  C1 * sigmaX ^ 2 * Real.sqrt (d : Real) * sigmaOp ^ 3 /
    ((n : Real) * lambdaMinSigma * eta ^ 6)

/--
Paper-bias slot for the Theorem 1 deterministic-equivalent component.

The slot is sample- and `lambda`-independent once the scalar paper parameters
are fixed, but it remains named separately to preserve the paper formula
boundary for later proof plumbing.
-/
def paperTheorem1DeterministicEquivalentPaperBias
    (d n : Nat) (C1 sigmaX sigmaOp lambdaMinSigma eta : Real) :
    PaperShrinkageBias d n :=
  fun _ _ =>
    paperTheorem1DeterministicEquivalentBiasComponent
      d n C1 sigmaX sigmaOp lambdaMinSigma eta

/--
Paper Theorem 1 scalar bias component obtained by adding the named variance and
exponential components.

This is deterministic vocabulary for the partial `Delta_X(lambda)` envelope. It
does not identify or prove the remaining paper bias terms.
-/
def paperTheorem1VariancePlusExponentialBiasComponent
    (d n : Nat) (lam C2 cX : Real) : ShrinkageTheorem1BiasTerm :=
  paperTheorem1VarianceBiasComponent d n lam +
    paperTheorem1ExponentialBiasComponent n C2 cX

/--
Paper-bias slot for the variance-plus-exponential partial envelope.

The definition intentionally uses `addPaperShrinkageBias` so downstream users
can reuse the existing additive bias-control and upper-bound infrastructure.
-/
def paperTheorem1VariancePlusExponentialPaperBias
    (d n : Nat) (C2 cX : Real) : PaperShrinkageBias d n :=
  addPaperShrinkageBias (paperTheorem1VariancePaperBias d n)
    (paperTheorem1ExponentialPaperBias d n C2 cX)

/--
Paper Theorem 1 full displayed `Delta_X(lambda)` scalar bias component.

This is only the syntactic sum of the three named scalar components currently
extracted from the paper display: deterministic-equivalent, exponential, and
variance.  It proves no spectral deterministic-equivalent estimate, exponential
tail estimate, concentration input, or Theorem 1 probability bound.
-/
def paperTheorem1DeltaBiasComponent
    (d n : Nat) (lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX : Real) :
    ShrinkageTheorem1BiasTerm :=
  paperTheorem1DeterministicEquivalentBiasComponent
      d n C1 sigmaX sigmaOp lambdaMinSigma eta +
    paperTheorem1VariancePlusExponentialBiasComponent d n lam C2 cX

/--
Paper-bias slot for the displayed three-term `Delta_X(lambda)` scalar formula.

The definition is expressed through `addPaperShrinkageBias` to reuse the
existing additive nonnegativity and scalar upper-bound provider infrastructure.
-/
def paperTheorem1DeltaPaperBias
    (d n : Nat) (C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX : Real) :
    PaperShrinkageBias d n :=
  addPaperShrinkageBias
    (paperTheorem1DeterministicEquivalentPaperBias
      d n C1 sigmaX sigmaOp lambdaMinSigma eta)
    (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX)

/-- The scalar variance-bias component is nonnegative under positive dimensions
and positive regularization. -/
theorem paperTheorem1VarianceBiasComponent_nonnegative {d n : Nat} (lam : Real)
    (hLam : 0 < lam) (hn : 0 < n) (hd : 0 < d) :
    0 <= paperTheorem1VarianceBiasComponent d n lam := by
  unfold paperTheorem1VarianceBiasComponent
  positivity

/-- The scalar exponential-bias component is nonnegative when its prefactor is
nonnegative. -/
theorem paperTheorem1ExponentialBiasComponent_nonnegative {n : Nat}
    (C2 cX : Real) (hC2 : 0 <= C2) :
    0 <= paperTheorem1ExponentialBiasComponent n C2 cX := by
  unfold paperTheorem1ExponentialBiasComponent
  positivity

/--
The deterministic-equivalent scalar component is nonnegative when the paper
constant, operator-norm surrogate, and minimum eigenvalue surrogate are
nonnegative.
-/
theorem paperTheorem1DeterministicEquivalentBiasComponent_nonnegative
    {d n : Nat} (C1 sigmaX sigmaOp lambdaMinSigma eta : Real)
    (hC1 : 0 <= C1) (hsigmaOp : 0 <= sigmaOp)
    (hlambdaMinSigma : 0 <= lambdaMinSigma) :
    0 <= paperTheorem1DeterministicEquivalentBiasComponent
      d n C1 sigmaX sigmaOp lambdaMinSigma eta := by
  unfold paperTheorem1DeterministicEquivalentBiasComponent
  positivity

/-- Evaluating a constant paper-bias slot returns its scalar value. -/
theorem paperShrinkageBiasTerm_constant {d n : Nat}
    (X : DataMatrix d n) (lam : Real) (c : ShrinkageTheorem1BiasTerm) :
    paperShrinkageBiasTerm (constantPaperShrinkageBias (d := d) (n := n) c)
      X lam = c := by
  rfl

/-- Evaluating an additive paper-bias slot splits into the two component terms. -/
theorem paperShrinkageBiasTerm_add {d n : Nat}
    (biasLeft biasRight : PaperShrinkageBias d n) (X : DataMatrix d n) (lam : Real) :
    paperShrinkageBiasTerm (addPaperShrinkageBias biasLeft biasRight) X lam =
      paperShrinkageBiasTerm biasLeft X lam + paperShrinkageBiasTerm biasRight X lam := by
  rfl

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

/-- Randomly evaluating a constant paper-bias slot returns its scalar value. -/
theorem randomPaperShrinkageBiasTerm_constant {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (lam : Real)
    (c : ShrinkageTheorem1BiasTerm) (omega : Omega) :
    randomPaperShrinkageBiasTerm X
      (constantPaperShrinkageBias (d := d) (n := n) c) lam omega = c := by
  rfl

/-- Randomly evaluating an additive paper-bias slot splits pointwise. -/
theorem randomPaperShrinkageBiasTerm_add {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (lam : Real) (omega : Omega) :
    randomPaperShrinkageBiasTerm X (addPaperShrinkageBias biasLeft biasRight) lam omega =
      randomPaperShrinkageBiasTerm X biasLeft lam omega +
        randomPaperShrinkageBiasTerm X biasRight lam omega := by
  rfl

/-- Evaluating the variance-component paper-bias slot returns its scalar value. -/
theorem paperShrinkageBiasTerm_paperTheorem1VariancePaperBias {d n : Nat}
    (X : DataMatrix d n) (lam : Real) :
    paperShrinkageBiasTerm (paperTheorem1VariancePaperBias d n) X lam =
      paperTheorem1VarianceBiasComponent d n lam := by
  rfl

/-- Randomly evaluating the variance-component paper-bias slot returns its scalar value. -/
theorem randomPaperShrinkageBiasTerm_paperTheorem1VariancePaperBias
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) (omega : Omega) :
    randomPaperShrinkageBiasTerm X (paperTheorem1VariancePaperBias d n) lam omega =
      paperTheorem1VarianceBiasComponent d n lam := by
  rfl

/-- Evaluating the exponential-component paper-bias slot returns its scalar value. -/
theorem paperShrinkageBiasTerm_paperTheorem1ExponentialPaperBias {d n : Nat}
    (X : DataMatrix d n) (lam : Real) (C2 cX : Real) :
    paperShrinkageBiasTerm (paperTheorem1ExponentialPaperBias d n C2 cX) X lam =
      paperTheorem1ExponentialBiasComponent n C2 cX := by
  rfl

/-- Randomly evaluating the exponential-component paper-bias slot returns its scalar value. -/
theorem randomPaperShrinkageBiasTerm_paperTheorem1ExponentialPaperBias
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) (omega : Omega) (C2 cX : Real) :
    randomPaperShrinkageBiasTerm X (paperTheorem1ExponentialPaperBias d n C2 cX)
        lam omega =
      paperTheorem1ExponentialBiasComponent n C2 cX := by
  rfl

/--
Evaluating the deterministic-equivalent paper-bias slot returns its scalar
component.
-/
theorem paperShrinkageBiasTerm_paperTheorem1DeterministicEquivalentPaperBias
    {d n : Nat} (X : DataMatrix d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta : Real) :
    paperShrinkageBiasTerm
        (paperTheorem1DeterministicEquivalentPaperBias
          d n C1 sigmaX sigmaOp lambdaMinSigma eta)
        X lam =
      paperTheorem1DeterministicEquivalentBiasComponent
        d n C1 sigmaX sigmaOp lambdaMinSigma eta := by
  rfl

/--
Randomly evaluating the deterministic-equivalent paper-bias slot returns its
scalar component.
-/
theorem randomPaperShrinkageBiasTerm_paperTheorem1DeterministicEquivalentPaperBias
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) (omega : Omega)
    (C1 sigmaX sigmaOp lambdaMinSigma eta : Real) :
    randomPaperShrinkageBiasTerm X
        (paperTheorem1DeterministicEquivalentPaperBias
          d n C1 sigmaX sigmaOp lambdaMinSigma eta)
        lam omega =
      paperTheorem1DeterministicEquivalentBiasComponent
        d n C1 sigmaX sigmaOp lambdaMinSigma eta := by
  rfl

/-- Evaluating the variance-plus-exponential paper-bias slot returns its scalar component. -/
theorem paperShrinkageBiasTerm_paperTheorem1VariancePlusExponentialPaperBias
    {d n : Nat} (X : DataMatrix d n) (lam : Real) (C2 cX : Real) :
    paperShrinkageBiasTerm
        (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX) X lam =
      paperTheorem1VariancePlusExponentialBiasComponent d n lam C2 cX := by
  rfl

/--
Randomly evaluating the variance-plus-exponential paper-bias slot returns its
scalar component.
-/
theorem randomPaperShrinkageBiasTerm_paperTheorem1VariancePlusExponentialPaperBias
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) (omega : Omega) (C2 cX : Real) :
    randomPaperShrinkageBiasTerm X
        (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX) lam omega =
      paperTheorem1VariancePlusExponentialBiasComponent d n lam C2 cX := by
  rfl

/-- Evaluating the displayed `Delta_X(lambda)` paper-bias slot returns its
three-term scalar component. -/
theorem paperShrinkageBiasTerm_paperTheorem1DeltaPaperBias
    {d n : Nat} (X : DataMatrix d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX : Real) :
    paperShrinkageBiasTerm
        (paperTheorem1DeltaPaperBias
          d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
        X lam =
      paperTheorem1DeltaBiasComponent
        d n lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX := by
  rfl

/-- Randomly evaluating the displayed `Delta_X(lambda)` paper-bias slot returns
its three-term scalar component. -/
theorem randomPaperShrinkageBiasTerm_paperTheorem1DeltaPaperBias
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) (omega : Omega)
    (C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX : Real) :
    randomPaperShrinkageBiasTerm X
        (paperTheorem1DeltaPaperBias
          d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
        lam omega =
      paperTheorem1DeltaBiasComponent
        d n lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX := by
  rfl

/--
Pointwise scalar upper-bound provider for the paper bias placeholder.

This separates the deterministic task “`Delta_X(lambda)` is bounded by scalar
`c` for every outcome” from the final theorem's possibly larger bias slot.
-/
def PaperShrinkageBiasUpperBoundStatement {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n)
    (bias : PaperShrinkageBias d n) (lam : Real)
    (biasBound : ShrinkageTheorem1BiasTerm) : Prop :=
  ∀ omega : Omega, randomPaperShrinkageBiasTerm X bias lam omega <= biasBound

/--
Provider form of `PaperShrinkageBiasUpperBoundStatement`.

This keeps the scalar upper-bound obligation available as a named provider for
later consumers while preserving the theorem-shaped statement API.
-/
structure PaperShrinkageBiasUpperBoundProvider {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n)
    (bias : PaperShrinkageBias d n) (lam : Real)
    (biasBound : ShrinkageTheorem1BiasTerm) : Prop where
  pointwise_le_bound :
    ∀ omega : Omega, randomPaperShrinkageBiasTerm X bias lam omega <= biasBound

/-- Project the typed scalar upper-bound statement from its provider. -/
theorem paperShrinkageBiasUpperBoundStatement_of_provider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (bias : PaperShrinkageBias d n)
    (lam : Real) (biasBound : ShrinkageTheorem1BiasTerm)
    (h : PaperShrinkageBiasUpperBoundProvider X bias lam biasBound) :
    PaperShrinkageBiasUpperBoundStatement X bias lam biasBound :=
  h.pointwise_le_bound

/-- Project the pointwise scalar upper-bound from its provider. -/
theorem paperShrinkageBiasUpperBound_of_provider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (bias : PaperShrinkageBias d n)
    (lam : Real) (biasBound : ShrinkageTheorem1BiasTerm)
    (h : PaperShrinkageBiasUpperBoundProvider X bias lam biasBound) :
    ∀ omega : Omega, randomPaperShrinkageBiasTerm X bias lam omega <= biasBound :=
  paperShrinkageBiasUpperBoundStatement_of_provider X bias lam biasBound h

/-- Build the scalar upper-bound provider from the typed statement. -/
theorem paperShrinkageBiasUpperBoundProvider_of_statement
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (bias : PaperShrinkageBias d n)
    (lam : Real) (biasBound : ShrinkageTheorem1BiasTerm)
    (h : PaperShrinkageBiasUpperBoundStatement X bias lam biasBound) :
    PaperShrinkageBiasUpperBoundProvider X bias lam biasBound where
  pointwise_le_bound := h


/--
Lift a deterministic uniform paper-bias bound to the random upper-bound
statement for any random data matrix.

This turns a sample-level bound on the paper's `Delta_X(lambda)` vocabulary into
an outcomewise random-provider statement.  It proves no probability estimate and
assumes the deterministic bound explicitly.
-/
theorem paperShrinkageBiasUpperBoundStatement_of_uniformBound
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (bias : PaperShrinkageBias d n)
    (lam : Real) (biasBound : ShrinkageTheorem1BiasTerm)
    (h : ∀ X0 : DataMatrix d n, paperShrinkageBiasTerm bias X0 lam <= biasBound) :
    PaperShrinkageBiasUpperBoundStatement X bias lam biasBound := by
  intro omega
  exact h (X omega)

/-- Provider form of a deterministic uniform paper-bias bound. -/
theorem paperShrinkageBiasUpperBoundProvider_of_uniformBound
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (bias : PaperShrinkageBias d n)
    (lam : Real) (biasBound : ShrinkageTheorem1BiasTerm)
    (h : ∀ X0 : DataMatrix d n, paperShrinkageBiasTerm bias X0 lam <= biasBound) :
    PaperShrinkageBiasUpperBoundProvider X bias lam biasBound :=
  paperShrinkageBiasUpperBoundProvider_of_statement X bias lam biasBound
    (paperShrinkageBiasUpperBoundStatement_of_uniformBound X bias lam biasBound h)

/--
Scalar upper-bound statement for a constant paper-bias slot.

If the constant value `c` is bounded by `biasBound`, then the corresponding
paper-bias random field is pointwise bounded by `biasBound`.
-/
theorem paperShrinkageBiasUpperBoundStatement_of_constantPaperBias
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (c biasBound : ShrinkageTheorem1BiasTerm) (hc : c <= biasBound) :
    PaperShrinkageBiasUpperBoundStatement X
      (constantPaperShrinkageBias (d := d) (n := n) c) lam biasBound := by
  intro omega
  simpa [PaperShrinkageBiasUpperBoundStatement,
    randomPaperShrinkageBiasTerm, paperShrinkageBiasTerm,
    constantPaperShrinkageBias] using hc

/--
Provider form of the scalar upper-bound statement for a constant paper-bias
slot.
-/
theorem paperShrinkageBiasUpperBoundProvider_of_constantPaperBias
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (c biasBound : ShrinkageTheorem1BiasTerm) (hc : c <= biasBound) :
    PaperShrinkageBiasUpperBoundProvider X
      (constantPaperShrinkageBias (d := d) (n := n) c) lam biasBound :=
  paperShrinkageBiasUpperBoundProvider_of_statement X
    (constantPaperShrinkageBias (d := d) (n := n) c) lam biasBound
    (paperShrinkageBiasUpperBoundStatement_of_constantPaperBias X lam c biasBound hc)

/--
Scalar upper-bound statement for the paper Theorem 1 variance-bias component.

The only assumption is the deterministic scalar comparison against
`biasBound`; no probability or concentration estimate is introduced.
-/
theorem paperShrinkageBiasUpperBoundStatement_of_paperTheorem1VarianceBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (biasBound : ShrinkageTheorem1BiasTerm)
    (hBias : paperTheorem1VarianceBiasComponent d n lam <= biasBound) :
    PaperShrinkageBiasUpperBoundStatement X
      (paperTheorem1VariancePaperBias d n) lam biasBound := by
  intro omega
  simpa [PaperShrinkageBiasUpperBoundStatement,
    randomPaperShrinkageBiasTerm, paperShrinkageBiasTerm,
    paperTheorem1VariancePaperBias] using hBias

/-- Provider form of the variance-component scalar upper-bound statement. -/
theorem paperShrinkageBiasUpperBoundProvider_of_paperTheorem1VarianceBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (biasBound : ShrinkageTheorem1BiasTerm)
    (hBias : paperTheorem1VarianceBiasComponent d n lam <= biasBound) :
    PaperShrinkageBiasUpperBoundProvider X
      (paperTheorem1VariancePaperBias d n) lam biasBound :=
  paperShrinkageBiasUpperBoundProvider_of_statement X
    (paperTheorem1VariancePaperBias d n) lam biasBound
    (paperShrinkageBiasUpperBoundStatement_of_paperTheorem1VarianceBiasComponent
      X lam biasBound hBias)

/--
Scalar upper-bound statement for the paper Theorem 1 exponential-bias component.

The only assumption is the deterministic scalar comparison against
`biasBound`; no probability or concentration estimate is introduced.
-/
theorem paperShrinkageBiasUpperBoundStatement_of_paperTheorem1ExponentialBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) (C2 cX : Real)
    (biasBound : ShrinkageTheorem1BiasTerm)
    (hBias : paperTheorem1ExponentialBiasComponent n C2 cX <= biasBound) :
    PaperShrinkageBiasUpperBoundStatement X
      (paperTheorem1ExponentialPaperBias d n C2 cX) lam biasBound := by
  intro omega
  simpa [PaperShrinkageBiasUpperBoundStatement,
    randomPaperShrinkageBiasTerm, paperShrinkageBiasTerm,
    paperTheorem1ExponentialPaperBias] using hBias

/-- Provider form of the exponential-component scalar upper-bound statement. -/
theorem paperShrinkageBiasUpperBoundProvider_of_paperTheorem1ExponentialBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) (C2 cX : Real)
    (biasBound : ShrinkageTheorem1BiasTerm)
    (hBias : paperTheorem1ExponentialBiasComponent n C2 cX <= biasBound) :
    PaperShrinkageBiasUpperBoundProvider X
      (paperTheorem1ExponentialPaperBias d n C2 cX) lam biasBound :=
  paperShrinkageBiasUpperBoundProvider_of_statement X
    (paperTheorem1ExponentialPaperBias d n C2 cX) lam biasBound
    (paperShrinkageBiasUpperBoundStatement_of_paperTheorem1ExponentialBiasComponent
      X lam C2 cX biasBound hBias)

/--
Scalar upper-bound statement for the paper Theorem 1 deterministic-equivalent
bias component.

The only assumption is the deterministic scalar comparison against
`biasBound`; no probability, spectral estimate, or concentration estimate is
introduced.
-/
theorem paperShrinkageBiasUpperBoundStatement_of_paperTheorem1DeterministicEquivalentBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta : Real)
    (biasBound : ShrinkageTheorem1BiasTerm)
    (hBias :
      paperTheorem1DeterministicEquivalentBiasComponent
        d n C1 sigmaX sigmaOp lambdaMinSigma eta <= biasBound) :
    PaperShrinkageBiasUpperBoundStatement X
      (paperTheorem1DeterministicEquivalentPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta)
      lam biasBound := by
  intro omega
  simpa [PaperShrinkageBiasUpperBoundStatement,
    randomPaperShrinkageBiasTerm, paperShrinkageBiasTerm,
    paperTheorem1DeterministicEquivalentPaperBias] using hBias

/--
Provider form of the deterministic-equivalent component scalar upper-bound
statement.
-/
theorem paperShrinkageBiasUpperBoundProvider_of_paperTheorem1DeterministicEquivalentBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta : Real)
    (biasBound : ShrinkageTheorem1BiasTerm)
    (hBias :
      paperTheorem1DeterministicEquivalentBiasComponent
        d n C1 sigmaX sigmaOp lambdaMinSigma eta <= biasBound) :
    PaperShrinkageBiasUpperBoundProvider X
      (paperTheorem1DeterministicEquivalentPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta)
      lam biasBound :=
  paperShrinkageBiasUpperBoundProvider_of_statement X
    (paperTheorem1DeterministicEquivalentPaperBias
      d n C1 sigmaX sigmaOp lambdaMinSigma eta)
    lam biasBound
    (paperShrinkageBiasUpperBoundStatement_of_paperTheorem1DeterministicEquivalentBiasComponent
      X lam C1 sigmaX sigmaOp lambdaMinSigma eta biasBound hBias)

/--
Scalar upper-bound statement for the variance-plus-exponential partial
paper-bias component.

The only assumption is the deterministic scalar comparison against
`biasBound`; no probability or concentration estimate is introduced.
-/
theorem paperShrinkageBiasUpperBoundStatement_of_paperTheorem1VariancePlusExponentialBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) (C2 cX : Real)
    (biasBound : ShrinkageTheorem1BiasTerm)
    (hBias :
      paperTheorem1VariancePlusExponentialBiasComponent d n lam C2 cX <= biasBound) :
    PaperShrinkageBiasUpperBoundStatement X
      (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX)
      lam biasBound := by
  intro omega
  simpa [PaperShrinkageBiasUpperBoundStatement,
    randomPaperShrinkageBiasTerm, paperShrinkageBiasTerm,
    paperTheorem1VariancePlusExponentialPaperBias,
    paperTheorem1VariancePlusExponentialBiasComponent,
    addPaperShrinkageBias, paperTheorem1VariancePaperBias,
    paperTheorem1ExponentialPaperBias] using hBias

/--
Provider form of the variance-plus-exponential component scalar upper-bound
statement.
-/
theorem paperShrinkageBiasUpperBoundProvider_of_paperTheorem1VariancePlusExponentialBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) (C2 cX : Real)
    (biasBound : ShrinkageTheorem1BiasTerm)
    (hBias :
      paperTheorem1VariancePlusExponentialBiasComponent d n lam C2 cX <= biasBound) :
    PaperShrinkageBiasUpperBoundProvider X
      (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX)
      lam biasBound :=
  paperShrinkageBiasUpperBoundProvider_of_statement X
    (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX)
    lam biasBound
    (paperShrinkageBiasUpperBoundStatement_of_paperTheorem1VariancePlusExponentialBiasComponent
      X lam C2 cX biasBound hBias)

/--
Scalar upper-bound statement for the displayed three-term `Delta_X(lambda)`
component.

The only assumption is the deterministic scalar comparison against
`biasBound`; no probability, spectral estimate, or concentration estimate is
introduced.
-/
theorem paperShrinkageBiasUpperBoundStatement_of_paperTheorem1DeltaBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX : Real)
    (biasBound : ShrinkageTheorem1BiasTerm)
    (hBias :
      paperTheorem1DeltaBiasComponent
        d n lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX <= biasBound) :
    PaperShrinkageBiasUpperBoundStatement X
      (paperTheorem1DeltaPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
      lam biasBound := by
  intro omega
  simpa [PaperShrinkageBiasUpperBoundStatement,
    randomPaperShrinkageBiasTerm, paperShrinkageBiasTerm,
    paperTheorem1DeltaPaperBias, paperTheorem1DeltaBiasComponent,
    addPaperShrinkageBias, paperTheorem1DeterministicEquivalentPaperBias,
    paperTheorem1VariancePlusExponentialPaperBias,
    paperTheorem1VariancePaperBias, paperTheorem1ExponentialPaperBias] using hBias

/-- Provider form of the displayed `Delta_X(lambda)` scalar upper-bound
statement. -/
theorem paperShrinkageBiasUpperBoundProvider_of_paperTheorem1DeltaBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX : Real)
    (biasBound : ShrinkageTheorem1BiasTerm)
    (hBias :
      paperTheorem1DeltaBiasComponent
        d n lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX <= biasBound) :
    PaperShrinkageBiasUpperBoundProvider X
      (paperTheorem1DeltaPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
      lam biasBound :=
  paperShrinkageBiasUpperBoundProvider_of_statement X
    (paperTheorem1DeltaPaperBias
      d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
    lam biasBound
    (paperShrinkageBiasUpperBoundStatement_of_paperTheorem1DeltaBiasComponent
      X lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX biasBound hBias)

/--
Monotonicity of the scalar paper-bias upper-bound statement in the scalar bound.

Once a paper-bias random field is bounded by `biasBase`, it is bounded by any
larger scalar `bias`.
-/
theorem paperShrinkageBiasUpperBoundStatement_mono
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (biasBase bias : ShrinkageTheorem1BiasTerm)
    (h : PaperShrinkageBiasUpperBoundStatement X paperBias lam biasBase)
    (hBias : biasBase <= bias) :
    PaperShrinkageBiasUpperBoundStatement X paperBias lam bias := by
  intro omega
  exact le_trans (h omega) hBias

/-- Provider-form monotonicity for scalar paper-bias upper bounds. -/
theorem paperShrinkageBiasUpperBoundProvider_mono
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (biasBase bias : ShrinkageTheorem1BiasTerm)
    (h : PaperShrinkageBiasUpperBoundProvider X paperBias lam biasBase)
    (hBias : biasBase <= bias) :
    PaperShrinkageBiasUpperBoundProvider X paperBias lam bias :=
  paperShrinkageBiasUpperBoundProvider_of_statement X paperBias lam bias
    (paperShrinkageBiasUpperBoundStatement_mono X paperBias lam biasBase bias
      (paperShrinkageBiasUpperBoundStatement_of_provider X paperBias lam biasBase h)
      hBias)

/-- Weaken a scalar paper-bias upper-bound statement to the left side of `max`. -/
theorem paperShrinkageBiasUpperBoundStatement_le_max_left
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (biasLeft biasRight : ShrinkageTheorem1BiasTerm)
    (h : PaperShrinkageBiasUpperBoundStatement X paperBias lam biasLeft) :
    PaperShrinkageBiasUpperBoundStatement X paperBias lam (max biasLeft biasRight) :=
  paperShrinkageBiasUpperBoundStatement_mono X paperBias lam biasLeft
    (max biasLeft biasRight) h (le_max_left biasLeft biasRight)

/-- Weaken a scalar paper-bias upper-bound statement to the right side of `max`. -/
theorem paperShrinkageBiasUpperBoundStatement_le_max_right
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (biasLeft biasRight : ShrinkageTheorem1BiasTerm)
    (h : PaperShrinkageBiasUpperBoundStatement X paperBias lam biasRight) :
    PaperShrinkageBiasUpperBoundStatement X paperBias lam (max biasLeft biasRight) :=
  paperShrinkageBiasUpperBoundStatement_mono X paperBias lam biasRight
    (max biasLeft biasRight) h (le_max_right biasLeft biasRight)

/-- Provider-form left-`max` weakening for scalar paper-bias upper bounds. -/
theorem paperShrinkageBiasUpperBoundProvider_le_max_left
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (biasLeft biasRight : ShrinkageTheorem1BiasTerm)
    (h : PaperShrinkageBiasUpperBoundProvider X paperBias lam biasLeft) :
    PaperShrinkageBiasUpperBoundProvider X paperBias lam (max biasLeft biasRight) :=
  paperShrinkageBiasUpperBoundProvider_mono X paperBias lam biasLeft
    (max biasLeft biasRight) h (le_max_left biasLeft biasRight)

/-- Provider-form right-`max` weakening for scalar paper-bias upper bounds. -/
theorem paperShrinkageBiasUpperBoundProvider_le_max_right
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (biasLeft biasRight : ShrinkageTheorem1BiasTerm)
    (h : PaperShrinkageBiasUpperBoundProvider X paperBias lam biasRight) :
    PaperShrinkageBiasUpperBoundProvider X paperBias lam (max biasLeft biasRight) :=
  paperShrinkageBiasUpperBoundProvider_mono X paperBias lam biasRight
    (max biasLeft biasRight) h (le_max_right biasLeft biasRight)

/--
Additive decomposition of scalar paper-bias upper bounds.

If two paper-bias slots are bounded pointwise by `boundLeft` and `boundRight`,
then their additive slot is bounded pointwise by `boundLeft + boundRight`.
This is purely deterministic order algebra.
-/
theorem paperShrinkageBiasUpperBoundStatement_of_addPaperBias
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (lam : Real)
    (boundLeft boundRight : ShrinkageTheorem1BiasTerm)
    (hLeft : PaperShrinkageBiasUpperBoundStatement X biasLeft lam boundLeft)
    (hRight : PaperShrinkageBiasUpperBoundStatement X biasRight lam boundRight) :
    PaperShrinkageBiasUpperBoundStatement X
      (addPaperShrinkageBias biasLeft biasRight) lam (boundLeft + boundRight) := by
  intro omega
  simpa [PaperShrinkageBiasUpperBoundStatement, randomPaperShrinkageBiasTerm,
    paperShrinkageBiasTerm, addPaperShrinkageBias] using
      add_le_add (hLeft omega) (hRight omega)

/-- Provider form of additive scalar paper-bias upper bounds. -/
theorem paperShrinkageBiasUpperBoundProvider_of_addPaperBias
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (lam : Real)
    (boundLeft boundRight : ShrinkageTheorem1BiasTerm)
    (hLeft : PaperShrinkageBiasUpperBoundProvider X biasLeft lam boundLeft)
    (hRight : PaperShrinkageBiasUpperBoundProvider X biasRight lam boundRight) :
    PaperShrinkageBiasUpperBoundProvider X
      (addPaperShrinkageBias biasLeft biasRight) lam (boundLeft + boundRight) :=
  paperShrinkageBiasUpperBoundProvider_of_statement X
    (addPaperShrinkageBias biasLeft biasRight) lam (boundLeft + boundRight)
    (paperShrinkageBiasUpperBoundStatement_of_addPaperBias X biasLeft biasRight lam
      boundLeft boundRight
      (paperShrinkageBiasUpperBoundStatement_of_provider X biasLeft lam boundLeft hLeft)
      (paperShrinkageBiasUpperBoundStatement_of_provider X biasRight lam boundRight hRight))

/--
Build a displayed `Delta_X(lambda)` scalar upper-bound statement from separate
upper bounds for its three named components.

The assumptions are only deterministic scalar comparisons for the
deterministic-equivalent, variance, and exponential components, plus a final
sum comparison into `biasBound`.  This theorem does not prove any of those
component estimates.
-/
theorem paperShrinkageBiasUpperBoundStatement_of_paperTheorem1DeltaBiasComponents
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX : Real)
    (detBound varianceBound exponentialBound biasBound : ShrinkageTheorem1BiasTerm)
    (hDet :
      paperTheorem1DeterministicEquivalentBiasComponent
        d n C1 sigmaX sigmaOp lambdaMinSigma eta <= detBound)
    (hVariance : paperTheorem1VarianceBiasComponent d n lam <= varianceBound)
    (hExponential : paperTheorem1ExponentialBiasComponent n C2 cX <= exponentialBound)
    (hSum : detBound + (varianceBound + exponentialBound) <= biasBound) :
    PaperShrinkageBiasUpperBoundStatement X
      (paperTheorem1DeltaPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
      lam biasBound :=
  paperShrinkageBiasUpperBoundStatement_mono X
    (paperTheorem1DeltaPaperBias
      d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
    lam (detBound + (varianceBound + exponentialBound)) biasBound
    (paperShrinkageBiasUpperBoundStatement_of_addPaperBias X
      (paperTheorem1DeterministicEquivalentPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta)
      (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX)
      lam detBound (varianceBound + exponentialBound)
      (paperShrinkageBiasUpperBoundStatement_of_paperTheorem1DeterministicEquivalentBiasComponent
        X lam C1 sigmaX sigmaOp lambdaMinSigma eta detBound hDet)
      (paperShrinkageBiasUpperBoundStatement_of_addPaperBias X
        (paperTheorem1VariancePaperBias d n)
        (paperTheorem1ExponentialPaperBias d n C2 cX)
        lam varianceBound exponentialBound
        (paperShrinkageBiasUpperBoundStatement_of_paperTheorem1VarianceBiasComponent
          X lam varianceBound hVariance)
        (paperShrinkageBiasUpperBoundStatement_of_paperTheorem1ExponentialBiasComponent
          X lam C2 cX exponentialBound hExponential)))
    hSum

/--
Provider form of the three-component displayed `Delta_X(lambda)` scalar
upper-bound consumer.
-/
theorem paperShrinkageBiasUpperBoundProvider_of_paperTheorem1DeltaBiasComponents
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX : Real)
    (detBound varianceBound exponentialBound biasBound : ShrinkageTheorem1BiasTerm)
    (hDet :
      paperTheorem1DeterministicEquivalentBiasComponent
        d n C1 sigmaX sigmaOp lambdaMinSigma eta <= detBound)
    (hVariance : paperTheorem1VarianceBiasComponent d n lam <= varianceBound)
    (hExponential : paperTheorem1ExponentialBiasComponent n C2 cX <= exponentialBound)
    (hSum : detBound + (varianceBound + exponentialBound) <= biasBound) :
    PaperShrinkageBiasUpperBoundProvider X
      (paperTheorem1DeltaPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
      lam biasBound :=
  paperShrinkageBiasUpperBoundProvider_of_statement X
    (paperTheorem1DeltaPaperBias
      d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
    lam biasBound
    (paperShrinkageBiasUpperBoundStatement_of_paperTheorem1DeltaBiasComponents
      X lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX
      detBound varianceBound exponentialBound biasBound
      hDet hVariance hExponential hSum)

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
Build paper-bias nonnegativity control from a deterministic uniform sample-level
nonnegativity proof.

This is only deterministic plumbing from a `DataMatrix`-level proof to the
random provider field.  It does not identify the paper's concrete bias formula
or prove any probability estimate.
-/
theorem paperShrinkageBiasControlProvider_of_uniformNonneg
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (bias : PaperShrinkageBias d n)
    (lam : Real)
    (h : ∀ X0 : DataMatrix d n, 0 <= paperShrinkageBiasTerm bias X0 lam) :
    PaperShrinkageBiasControlProvider X lam bias where
  pointwise_nonneg := by
    intro omega
    exact h (X omega)

/-- Constant paper-bias slots are controlled by scalar nonnegativity. -/
theorem paperShrinkageBiasControlProvider_of_constantPaperBias
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (c : ShrinkageTheorem1BiasTerm) (hc : 0 <= c) :
    PaperShrinkageBiasControlProvider X lam
      (constantPaperShrinkageBias (d := d) (n := n) c) where
  pointwise_nonneg := by
    intro omega
    simpa [paperShrinkageBiasTerm, constantPaperShrinkageBias] using hc

/--
The paper Theorem 1 variance-bias component supplies the pointwise
nonnegativity control needed by additive paper-tail reuse.
-/
theorem paperTheorem1VarianceBiasControlProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (hLam : 0 < lam) (hn : 0 < n) (hd : 0 < d) :
    PaperShrinkageBiasControlProvider X lam (paperTheorem1VariancePaperBias d n) where
  pointwise_nonneg := by
    intro omega
    simpa [paperShrinkageBiasTerm, paperTheorem1VariancePaperBias] using
      paperTheorem1VarianceBiasComponent_nonnegative (d := d) (n := n) lam hLam hn hd

/--
The paper Theorem 1 exponential-bias component supplies pointwise
nonnegativity control from nonnegativity of its scalar prefactor.
-/
theorem paperTheorem1ExponentialBiasControlProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) (C2 cX : Real)
    (hC2 : 0 <= C2) :
    PaperShrinkageBiasControlProvider X lam
      (paperTheorem1ExponentialPaperBias d n C2 cX) where
  pointwise_nonneg := by
    intro omega
    simpa [paperShrinkageBiasTerm, paperTheorem1ExponentialPaperBias] using
      paperTheorem1ExponentialBiasComponent_nonnegative (n := n) C2 cX hC2

/--
The deterministic-equivalent paper-bias component supplies pointwise
nonnegativity control from nonnegativity of its scalar paper parameters.
-/
theorem paperTheorem1DeterministicEquivalentBiasControlProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta : Real)
    (hC1 : 0 <= C1) (hsigmaOp : 0 <= sigmaOp)
    (hlambdaMinSigma : 0 <= lambdaMinSigma) :
    PaperShrinkageBiasControlProvider X lam
      (paperTheorem1DeterministicEquivalentPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta) where
  pointwise_nonneg := by
    intro omega
    simpa [paperShrinkageBiasTerm,
      paperTheorem1DeterministicEquivalentPaperBias] using
      paperTheorem1DeterministicEquivalentBiasComponent_nonnegative
        (d := d) (n := n) C1 sigmaX sigmaOp lambdaMinSigma eta
        hC1 hsigmaOp hlambdaMinSigma

/--
The variance-plus-exponential partial paper-bias slot supplies pointwise
nonnegativity by composing the two named deterministic component providers.
-/
theorem paperTheorem1VariancePlusExponentialBiasControlProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) (C2 cX : Real)
    (hLam : 0 < lam) (hn : 0 < n) (hd : 0 < d) (hC2 : 0 <= C2) :
    PaperShrinkageBiasControlProvider X lam
      (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX) where
  pointwise_nonneg := by
    intro omega
    dsimp [paperShrinkageBiasTerm, paperTheorem1VariancePlusExponentialPaperBias,
      addPaperShrinkageBias, paperTheorem1VariancePaperBias,
      paperTheorem1ExponentialPaperBias]
    exact add_nonneg
      (paperTheorem1VarianceBiasComponent_nonnegative (d := d) (n := n) lam hLam hn hd)
      (paperTheorem1ExponentialBiasComponent_nonnegative (n := n) C2 cX hC2)

/-- Additive paper-bias slots preserve pointwise nonnegativity control. -/
theorem paperShrinkageBiasControlProvider_of_addPaperBias
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (lam : Real)
    (hLeft : PaperShrinkageBiasControlProvider X lam biasLeft)
    (hRight : PaperShrinkageBiasControlProvider X lam biasRight) :
    PaperShrinkageBiasControlProvider X lam
      (addPaperShrinkageBias biasLeft biasRight) where
  pointwise_nonneg := by
    intro omega
    simpa [paperShrinkageBiasTerm, addPaperShrinkageBias] using
      add_nonneg (hLeft.pointwise_nonneg omega) (hRight.pointwise_nonneg omega)

/--
The displayed three-term `Delta_X(lambda)` paper-bias slot supplies pointwise
nonnegativity by composing the deterministic-equivalent component with the
variance-plus-exponential partial envelope.
-/
theorem paperTheorem1DeltaBiasControlProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX : Real)
    (hLam : 0 < lam) (hn : 0 < n) (hd : 0 < d)
    (hC1 : 0 <= C1) (hsigmaOp : 0 <= sigmaOp)
    (hlambdaMinSigma : 0 <= lambdaMinSigma) (hC2 : 0 <= C2) :
    PaperShrinkageBiasControlProvider X lam
      (paperTheorem1DeltaPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) :=
  paperShrinkageBiasControlProvider_of_addPaperBias X
    (paperTheorem1DeterministicEquivalentPaperBias
      d n C1 sigmaX sigmaOp lambdaMinSigma eta)
    (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX) lam
    (paperTheorem1DeterministicEquivalentBiasControlProvider
      X lam C1 sigmaX sigmaOp lambdaMinSigma eta hC1 hsigmaOp hlambdaMinSigma)
    (paperTheorem1VariancePlusExponentialBiasControlProvider
      X lam C2 cX hLam hn hd hC2)

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
Direct field projection for the paper-tail event measurability provider.

This is only an API convenience around the stored `MeasurableSet` field; it
does not prove primitive measurability of the estimator or bias function.
-/
theorem shrinkageTheorem1PaperTailMeasurabilityProvider_tail_event_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (lam t : Real)
    (h :
      ShrinkageTheorem1PaperTailMeasurabilityProvider
        X SigmaInv estimator bias lam t) :
    MeasurableSet (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) :=
  h.tail_event_measurable

/-- Projection theorem for the paper-tail event measurability provider.

This only exposes the supplied provider field; it does not prove primitive
measurability of the estimator or bias function.
-/
theorem shrinkageTheorem1PaperTailEvent_measurable_of_provider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (lam t : Real)
    (h : ShrinkageTheorem1PaperTailMeasurabilityProvider
      X SigmaInv estimator bias lam t) :
    MeasurableSet (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) :=
  h.tail_event_measurable

/-- Provider constructor from an explicitly supplied paper-tail event
measurability proof.

This is a typed assumption shell only; it does not derive measurability from
random-matrix, estimator, or bias measurability hypotheses.
-/
theorem shrinkageTheorem1PaperTailMeasurabilityProvider_of_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (lam t : Real)
    (h : MeasurableSet
      (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t)) :
    ShrinkageTheorem1PaperTailMeasurabilityProvider X SigmaInv estimator bias lam t where
  tail_event_measurable := h

/-- Projection theorem for the full displayed `Delta_X(lambda)` paper-tail event
measurability provider.

This is the specialization of
`shrinkageTheorem1PaperTailEvent_measurable_of_provider` to
`paperTheorem1DeltaPaperBias`; it proves no primitive measurability,
probability bound, concentration estimate, or Theorem 1.
-/
theorem paperTheorem1DeltaPaperTailEvent_measurable_of_provider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX : Real) (t : Real)
    (h : ShrinkageTheorem1PaperTailMeasurabilityProvider X SigmaInv estimator
      (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
      lam t) :
    MeasurableSet
      (shrinkageTheorem1PaperTailEvent X SigmaInv estimator
        (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
        lam t) :=
  shrinkageTheorem1PaperTailEvent_measurable_of_provider X SigmaInv estimator
    (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
    lam t h

/-- Provider constructor for the full displayed `Delta_X(lambda)` paper-tail
event from an explicitly supplied measurability proof.

This is a typed assumption shell only.  It does not construct primitive
measurability for the estimator or displayed `Delta_X(lambda)` bias slot.
-/
theorem paperTheorem1DeltaPaperTailMeasurabilityProvider_of_measurable
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX : Real) (t : Real)
    (h : MeasurableSet
      (shrinkageTheorem1PaperTailEvent X SigmaInv estimator
        (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
        lam t)) :
    ShrinkageTheorem1PaperTailMeasurabilityProvider X SigmaInv estimator
      (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
      lam t :=
  shrinkageTheorem1PaperTailMeasurabilityProvider_of_measurable X SigmaInv estimator
    (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
    lam t h

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
Project the core H1/H2 provider bundle from the full paper-tail provider bundle.

This theorem is API glue only: it proves no probability bound, concentration
estimate, bias control, or primitive measurability fact.
-/
theorem shrinkageTheorem1PaperTailProviders_core
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (bias : PaperShrinkageBias d n) (t : Real)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS) :
    ShrinkageTheorem1Providers P X Z Sigma SigmaSqrt sigmaX eta lam :=
  h.core

/--
Project the paper-tail RHS provider from the full paper-tail provider bundle.

This theorem is API glue only: it proves no RHS identity, nonnegativity, or
probability estimate.
-/
theorem shrinkageTheorem1PaperTailProviders_rhs
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (bias : PaperShrinkageBias d n) (t : Real)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS) :
    ShrinkageTheorem1PaperTailRHSProvider paperTailRHS lambdaMinSigma sigmaX eta t
      tailRHS :=
  h.rhs

/--
Project the paper-bias control provider from the full paper-tail provider bundle.

This theorem is API glue only: it proves no pointwise bias nonnegativity or
paper-tail event inclusion.
-/
theorem shrinkageTheorem1PaperTailProviders_bias_control
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (bias : PaperShrinkageBias d n) (t : Real)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS) :
    PaperShrinkageBiasControlProvider X lam bias :=
  h.bias_control

/--
Project the paper-tail measurability provider from the full paper-tail provider
bundle.

This theorem is API glue only: it proves no primitive measurability fact.
-/
theorem shrinkageTheorem1PaperTailProviders_measurability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (bias : PaperShrinkageBias d n) (t : Real)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS) :
    ShrinkageTheorem1PaperTailMeasurabilityProvider X SigmaInv estimator bias lam t :=
  h.measurability

/--
Projection of the paper-tail measurability field from the full paper-tail
provider bundle.

This is only provider plumbing; it does not construct primitive measurability or
prove a probability bound.
-/
theorem shrinkageTheorem1PaperTailMeasurabilityProvider_of_providers
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (bias : PaperShrinkageBias d n) (t : Real)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h : ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
      sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS) :
    ShrinkageTheorem1PaperTailMeasurabilityProvider X SigmaInv estimator bias lam t :=
  h.measurability

/--
Measurability projection for the paper-tail event from the full paper-tail
provider bundle.

This only composes the bundle field projection with
`shrinkageTheorem1PaperTailEvent_measurable_of_provider`.
-/
theorem shrinkageTheorem1PaperTailEvent_measurable_of_providers
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (bias : PaperShrinkageBias d n) (t : Real)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h : ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
      sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS) :
    MeasurableSet (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) :=
  shrinkageTheorem1PaperTailEvent_measurable_of_provider X SigmaInv estimator
    bias lam t
    (shrinkageTheorem1PaperTailMeasurabilityProvider_of_providers
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      paperTailRHS lambdaMinSigma tailRHS h)

/--
Full `Delta_X(lambda)` specialization of the paper-tail measurability bundle
projection.

This is only a typed convenience wrapper around the generic provider-bundle
projection.
-/
theorem paperTheorem1DeltaPaperTailMeasurabilityProvider_of_providers
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (C1 sigmaOp C2 cX : Real) (t : Real)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h : ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
      sigmaX eta lam estimator
      (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
      t paperTailRHS lambdaMinSigma tailRHS) :
    ShrinkageTheorem1PaperTailMeasurabilityProvider X SigmaInv estimator
      (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
      lam t :=
  shrinkageTheorem1PaperTailMeasurabilityProvider_of_providers P X Z SigmaInv
    Sigma SigmaSqrt sigmaX eta lam estimator
    (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
    t paperTailRHS lambdaMinSigma tailRHS h

/--
Full `Delta_X(lambda)` specialization of the paper-tail event measurability
projection from the full provider bundle.
-/
theorem paperTheorem1DeltaPaperTailEvent_measurable_of_providers
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (C1 sigmaOp C2 cX : Real) (t : Real)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h : ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
      sigmaX eta lam estimator
      (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
      t paperTailRHS lambdaMinSigma tailRHS) :
    MeasurableSet
      (shrinkageTheorem1PaperTailEvent X SigmaInv estimator
        (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
        lam t) :=
  shrinkageTheorem1PaperTailEvent_measurable_of_providers P X Z SigmaInv Sigma
    SigmaSqrt sigmaX eta lam estimator
    (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
    t paperTailRHS lambdaMinSigma tailRHS h

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
Paper-tail projection for the H2 probability provider built from lower-bad and
resolvent-bad union-bound providers.

This only threads the already-proved union-bound provider composition through
the paper-tail bundle. It proves no lower-tail, resolvent-tail, concentration,
or Theorem 1 probability estimate.
-/
theorem shrinkageTheorem1PaperTailH2Probability_of_unionBoundProbabilityProviders
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (_providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (hRHS : PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS h2ProbabilityRHS)
    (hLower : PaperH2LowerSingularValueBadEventProbabilityProvider
      P X eta lowerRHS)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    PaperH2LeaveOneOutGoodEventProbabilityProvider P X eta lam h2ProbabilityRHS :=
  paperH2LeaveOneOutGoodEventProbabilityProvider_of_unionBoundProbabilityProviders
    P X eta lam lowerRHS resolventRHS h2ProbabilityRHS hRHS hLower hResolvent

/--
Paper-tail projection for the H2 probability provider when the lower component
starts from the pointwise lower-singular-value event provider.

This only inserts the deterministic empty-event lower-bad wrapper and then
uses the existing lower/resolvent RHS provider bridge.  The resolvent
probability provider remains explicit; no concentration estimate is proved.
-/
theorem shrinkageTheorem1PaperTailH2Probability_of_lowerEventProvider_and_resolventProbabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (_providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hRHS : PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS h2ProbabilityRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    PaperH2LeaveOneOutGoodEventProbabilityProvider P X eta lam h2ProbabilityRHS :=
  paperH2LeaveOneOutGoodEventProbabilityProvider_of_lowerEventProvider_and_resolventProbabilityProvider
    P X eta lam lowerRHS resolventRHS h2ProbabilityRHS lowerRHS_nonnegative
    hRHS hLower hResolvent

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
Paper-tail H2 probability consumer built from lower-bad and resolvent-bad
union-bound providers plus a named combined RHS provider.

This is a thin composition wrapper only; it does not prove primitive
measurability or any concentration estimate.
-/
theorem shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_unionBoundProbabilityProviders
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (hRHS : PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS h2ProbabilityRHS)
    (hLower : PaperH2LowerSingularValueBadEventProbabilityProvider
      P X eta lowerRHS)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    PaperH2LeaveOneOutProbabilityConsumerStatement P X eta lam h2ProbabilityRHS :=
  shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_providers
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      h2ProbabilityRHS paperTailRHS lambdaMinSigma tailRHS providers hMeas
      (shrinkageTheorem1PaperTailH2Probability_of_unionBoundProbabilityProviders
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
          lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
          tailRHS providers hRHS hLower hResolvent)

/--
Paper-tail H2 probability consumer whose lower component is supplied as the
pointwise lower-singular-value event provider.

This is a provider-composition wrapper only.  It packages explicit
measurability with the lower-event/resolvent-probability bridge and proves no
primitive measurability or concentration estimate.
-/
theorem shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_lowerEventProvider_and_resolventProbabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hRHS : PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS h2ProbabilityRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    PaperH2LeaveOneOutProbabilityConsumerStatement P X eta lam h2ProbabilityRHS :=
  shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_providers
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      h2ProbabilityRHS paperTailRHS lambdaMinSigma tailRHS providers hMeas
      (shrinkageTheorem1PaperTailH2Probability_of_lowerEventProvider_and_resolventProbabilityProvider
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
          lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
          tailRHS providers lowerRHS_nonnegative hRHS hLower hResolvent)

/--
Paper-RHS specialization of the H2 probability consumer statement wrapper.

This consumes the paper-RHS resolvent bad-event provider together with an
existing lower-singular-value event provider, using the definitional
lower-plus-resolvent H2 union RHS.  It proves no lower-singular-value tail,
determinant tail, denominator tail, resolvent tail, concentration estimate, or
Theorem 1 bound.
-/
theorem shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_lowerEventProvider_and_resolventPaperRHSBounds
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hDenominatorPrefactor : 0 <= denominatorParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam))
    (hDenominatorBounds :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam)) :
    PaperH2LeaveOneOutProbabilityConsumerStatement P X eta lam
      (paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS
        (paperH2ResolventAtomicBadEventUnionBoundRHS
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam)
          (fun _ : Fin n =>
            paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam)
          (fun _ : Fin n =>
            paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam))) :=
  shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_lowerEventProvider_and_resolventProbabilityProvider
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
    lowerRHS
    (paperH2ResolventAtomicBadEventUnionBoundRHS
      (paperH2ShrinkageShiftedDetTailPaperRHS
        (d := d) (n := n) shrinkageParams lam)
      (fun _ : Fin n =>
        paperH2LeaveOneOutShiftedDetPointTailPaperRHS
          (d := d) (n := n) leaveOneOutParams lam)
      (fun _ : Fin n =>
        paperH2WoodburyDenominatorPointTailPaperRHS
          (d := d) (n := n) denominatorParams lam))
    (paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS
      (paperH2ResolventAtomicBadEventUnionBoundRHS
        (paperH2ShrinkageShiftedDetTailPaperRHS
          (d := d) (n := n) shrinkageParams lam)
        (fun _ : Fin n =>
          paperH2LeaveOneOutShiftedDetPointTailPaperRHS
            (d := d) (n := n) leaveOneOutParams lam)
        (fun _ : Fin n =>
          paperH2WoodburyDenominatorPointTailPaperRHS
            (d := d) (n := n) denominatorParams lam)))
    paperTailRHS lambdaMinSigma tailRHS providers hMeas lowerRHS_nonnegative
    (paperH2LeaveOneOutBadEventUnionBoundRHSProvider_self lowerRHS
      (paperH2ResolventAtomicBadEventUnionBoundRHS
        (paperH2ShrinkageShiftedDetTailPaperRHS
          (d := d) (n := n) shrinkageParams lam)
        (fun _ : Fin n =>
          paperH2LeaveOneOutShiftedDetPointTailPaperRHS
            (d := d) (n := n) leaveOneOutParams lam)
        (fun _ : Fin n =>
          paperH2WoodburyDenominatorPointTailPaperRHS
            (d := d) (n := n) denominatorParams lam)))
    hLower
    (paperH2ResolventBadEventProbabilityProvider_of_paperRHS_bounds
      P X lam shrinkageParams leaveOneOutParams denominatorParams
      hShrinkagePrefactor hLeaveOneOutPrefactor hDenominatorPrefactor
      hShrinkageBound hLeaveOneOutBounds hDenominatorBounds)

/--
Short-name alias for the paper-RHS H2 probability consumer built from a
lower-event provider and supplied paper-RHS resolvent component bounds.
-/
theorem shrinkageTheorem1PaperTailH2ProbabilityConsumer_of_lowerEventProvider_and_resolventPaperRHSBounds
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hDenominatorPrefactor : 0 <= denominatorParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam))
    (hDenominatorBounds :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam)) :
    PaperH2LeaveOneOutProbabilityConsumerStatement P X eta lam
      (paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS
        (paperH2ResolventAtomicBadEventUnionBoundRHS
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam)
          (fun _ : Fin n =>
            paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam)
          (fun _ : Fin n =>
            paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam))) :=
  shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_lowerEventProvider_and_resolventPaperRHSBounds
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS providers hMeas
    lowerRHS_nonnegative hLower shrinkageParams leaveOneOutParams
    denominatorParams hShrinkagePrefactor hLeaveOneOutPrefactor
    hDenominatorPrefactor hShrinkageBound hLeaveOneOutBounds
    hDenominatorBounds

/--
Projection of the bad-event probability bound from the paper-RHS H2 consumer.

This only exposes the `bad_event_probability` field after threading the
paper-RHS resolvent provider with the lower-event provider.  It proves no
component tail estimate, concentration theorem, or Theorem 1 bound.
-/
theorem shrinkageTheorem1PaperTailH2ProbabilityConsumer_badEventProbability_of_lowerEventProvider_and_resolventPaperRHSBounds
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hDenominatorPrefactor : 0 <= denominatorParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam))
    (hDenominatorBounds :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam)) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <=
      ENNReal.ofReal
        (paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS
          (paperH2ResolventAtomicBadEventUnionBoundRHS
            (paperH2ShrinkageShiftedDetTailPaperRHS
              (d := d) (n := n) shrinkageParams lam)
            (fun _ : Fin n =>
              paperH2LeaveOneOutShiftedDetPointTailPaperRHS
                (d := d) (n := n) leaveOneOutParams lam)
            (fun _ : Fin n =>
              paperH2WoodburyDenominatorPointTailPaperRHS
                (d := d) (n := n) denominatorParams lam))) :=
  (shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_lowerEventProvider_and_resolventPaperRHSBounds
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS providers hMeas
    lowerRHS_nonnegative hLower shrinkageParams leaveOneOutParams
    denominatorParams hShrinkagePrefactor hLeaveOneOutPrefactor
    hDenominatorPrefactor hShrinkageBound hLeaveOneOutBounds
    hDenominatorBounds).bad_event_probability

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
Short-name alias for the paper-tail H2 probability consumer built from
union-bound probability providers.
-/
theorem shrinkageTheorem1PaperTailH2ProbabilityConsumer_of_unionBoundProbabilityProviders
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (hRHS : PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS h2ProbabilityRHS)
    (hLower : PaperH2LowerSingularValueBadEventProbabilityProvider
      P X eta lowerRHS)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    PaperH2LeaveOneOutProbabilityConsumerStatement P X eta lam h2ProbabilityRHS :=
  shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_unionBoundProbabilityProviders
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma tailRHS
      providers hMeas hRHS hLower hResolvent

/--
Short-name alias for the paper-tail H2 probability consumer built from a
lower-event provider and an explicit resolvent probability provider.
-/
theorem shrinkageTheorem1PaperTailH2ProbabilityConsumer_of_lowerEventProvider_and_resolventProbabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hRHS : PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS h2ProbabilityRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    PaperH2LeaveOneOutProbabilityConsumerStatement P X eta lam h2ProbabilityRHS :=
  shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_lowerEventProvider_and_resolventProbabilityProvider
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma tailRHS
      providers hMeas lowerRHS_nonnegative hRHS hLower hResolvent

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
Projection of the bad-event probability bound from the paper-tail H2 consumer
built from lower-bad and resolvent-bad union-bound providers.
-/
theorem shrinkageTheorem1PaperTailH2ProbabilityConsumer_badEventProbability_of_unionBoundProbabilityProviders
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (hRHS : PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS h2ProbabilityRHS)
    (hLower : PaperH2LowerSingularValueBadEventProbabilityProvider
      P X eta lowerRHS)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <= ENNReal.ofReal h2ProbabilityRHS :=
  (shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_unionBoundProbabilityProviders
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma tailRHS
      providers hMeas hRHS hLower hResolvent).bad_event_probability

/--
Projection of the bad-event probability bound from the lower-event/resolvent
paper-tail H2 consumer.
-/
theorem shrinkageTheorem1PaperTailH2ProbabilityConsumer_badEventProbability_of_lowerEventProvider_and_resolventProbabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hRHS : PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS h2ProbabilityRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <= ENNReal.ofReal h2ProbabilityRHS :=
  (shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_lowerEventProvider_and_resolventProbabilityProvider
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma tailRHS
      providers hMeas lowerRHS_nonnegative hRHS hLower hResolvent).bad_event_probability

/--
Thin paper-tail projection for the H2 bad-event union-bound consumer.

This threads the lower-bad and resolvent-bad probability providers alongside
the existing paper-tail provider bundle, then packages them into
`PaperH2LeaveOneOutBadEventUnionBoundStatement`.  It preserves the paper-tail
bundle shape and proves no component tail estimate, concentration theorem, or
closed-form RHS formula.
-/
theorem shrinkageTheorem1PaperTailH2UnionBoundStatement_of_providers
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (_providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (hLower : PaperH2LowerSingularValueBadEventProbabilityProvider
      P X eta lowerRHS)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    PaperH2LeaveOneOutBadEventUnionBoundStatement
      P X eta lam lowerRHS resolventRHS :=
  paperH2LeaveOneOutBadEventUnionBoundStatement_of_probabilityProviders
    P X eta lam lowerRHS resolventRHS hLower hResolvent

/--
Projection of the H2 bad-event union-bound probability consequence after
threading the paper-tail provider bundle.

The only bound used here is the already proved union-bound consumer; no H2
component probability estimate or Theorem 1 probability bound is proved.
-/
theorem shrinkageTheorem1PaperTailH2UnionBound_badEventProbability_of_providers
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (hLower : PaperH2LowerSingularValueBadEventProbabilityProvider
      P X eta lowerRHS)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <=
      ENNReal.ofReal lowerRHS + ENNReal.ofReal resolventRHS :=
  (shrinkageTheorem1PaperTailH2UnionBoundStatement_of_providers
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      lowerRHS resolventRHS paperTailRHS lambdaMinSigma tailRHS providers
      hLower hResolvent).bad_event_probability

/--
Paper-tail projection of the H2 bad-event union-bound probability consequence
using the named combined Real RHS.

This only normalizes the RHS shape after threading the paper-tail provider
bundle; it does not prove lower-tail, resolvent-tail, concentration, or
Theorem 1.
-/
theorem shrinkageTheorem1PaperTailH2UnionBound_realRHS_badEventProbability_of_providers
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (_providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (hLower : PaperH2LowerSingularValueBadEventProbabilityProvider
      P X eta lowerRHS)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <=
      ENNReal.ofReal
        (paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS resolventRHS) :=
  paperH2LeaveOneOutBadEventUnionBound_bound_of_probabilityProviders_realRHS
    P X eta lam lowerRHS resolventRHS hLower hResolvent

/--
Paper-tail H2 union-bound statement wrapper from a deterministic lower-event
provider and an explicit resolvent bad-event probability provider.

This fills the paper-tail API slot without changing the probability boundary:
the lower-event provider is only converted to the existing eta-only lower-bad
probability provider, and the resolvent probability remains an input.
-/
theorem shrinkageTheorem1PaperTailH2UnionBoundStatement_of_lowerEventProvider_and_resolventProbabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    PaperH2LeaveOneOutBadEventUnionBoundStatement
      P X eta lam lowerRHS resolventRHS :=
  shrinkageTheorem1PaperTailH2UnionBoundStatement_of_providers
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      lowerRHS resolventRHS paperTailRHS lambdaMinSigma tailRHS providers
      (paperH2LowerSingularValueBadEventProbabilityProvider_of_eventProvider
        P X eta lowerRHS lowerRHS_nonnegative hLower)
      hResolvent

/--
Paper-tail projection of the H2 bad-event union-bound probability consequence
from lower-event and resolvent-probability provider inputs.
-/
theorem shrinkageTheorem1PaperTailH2UnionBound_badEventProbability_of_lowerEventProvider_and_resolventProbabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <=
      ENNReal.ofReal lowerRHS + ENNReal.ofReal resolventRHS :=
  (shrinkageTheorem1PaperTailH2UnionBoundStatement_of_lowerEventProvider_and_resolventProbabilityProvider
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      lowerRHS resolventRHS paperTailRHS lambdaMinSigma tailRHS providers
      lowerRHS_nonnegative hLower hResolvent).bad_event_probability

/--
Paper-tail projection of the H2 bad-event union-bound probability consequence
using the named combined Real RHS, with lower-bad supplied by the deterministic
lower-event provider.
-/
theorem shrinkageTheorem1PaperTailH2UnionBound_realRHS_badEventProbability_of_lowerEventProvider_and_resolventProbabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (_providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <=
      ENNReal.ofReal
        (paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS resolventRHS) :=
  paperH2LeaveOneOutBadEventUnionBound_bound_of_lowerEventProvider_and_resolventProbabilityProvider_realRHS
    P X eta lam lowerRHS resolventRHS lowerRHS_nonnegative hLower
      hResolvent

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

/-- Project the bundled H1/H2 providers from a paper-tail statement. -/
theorem shrinkageTheorem1PaperTailStatement_providers {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (bias : PaperShrinkageBias d n) (t : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1PaperTailStatement P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam
        estimator bias t tailRHS) :
    ShrinkageTheorem1Providers P X Z Sigma SigmaSqrt sigmaX eta lam :=
  h.providers

/-- Project the paper H1 provider from a paper-tail statement. -/
theorem shrinkageTheorem1PaperTailStatement_h1_provider {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (bias : PaperShrinkageBias d n) (t : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1PaperTailStatement P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam
        estimator bias t tailRHS) :
    PaperH1SubGaussianModelProvider P X Z Sigma SigmaSqrt sigmaX :=
  h.providers.h1

/-- Project the paper H2 provider from a paper-tail statement. -/
theorem shrinkageTheorem1PaperTailStatement_h2_provider {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (bias : PaperShrinkageBias d n) (t : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1PaperTailStatement P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam
        estimator bias t tailRHS) :
    PaperH2LeaveOneOutGoodEventProvider P X eta lam :=
  h.providers.h2

/-- Project the regularization positivity hypothesis from a paper-tail statement. -/
theorem shrinkageTheorem1PaperTailStatement_lambda_positive {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (bias : PaperShrinkageBias d n) (t : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1PaperTailStatement P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam
        estimator bias t tailRHS) :
    0 < lam :=
  h.lambda_positive

/-- Project the nonnegative threshold hypothesis from a paper-tail statement. -/
theorem shrinkageTheorem1PaperTailStatement_threshold_nonnegative {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (bias : PaperShrinkageBias d n) (t : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1PaperTailStatement P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam
        estimator bias t tailRHS) :
    0 <= t :=
  h.threshold_nonnegative

/-- Project RHS nonnegativity from a paper-tail statement. -/
theorem shrinkageTheorem1PaperTailStatement_tail_rhs_nonnegative {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (bias : PaperShrinkageBias d n) (t : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1PaperTailStatement P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam
        estimator bias t tailRHS) :
    0 <= tailRHS :=
  h.tail_rhs_nonnegative

/-- Project the explicit paper-tail probability bound from a paper-tail statement. -/
theorem shrinkageTheorem1PaperTailStatement_tail_bound {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (SigmaInv Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (estimator : PaperShrinkageEstimator d n)
    (bias : PaperShrinkageBias d n) (t : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1PaperTailStatement P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam
        estimator bias t tailRHS) :
    P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) <=
      ENNReal.ofReal tailRHS :=
  h.tail_bound

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
Theorem-facing wrapper pairing the paper-tail statement with the H2
probability-consumer statement.

This is only a typed API bundle for the next proof step: it keeps the paper
tail bound and the H2 bad-event measurability/probability consumer side by
side.  It does not prove a concentration estimate, primitive measurability, or
Theorem 1.
-/
structure ShrinkageTheorem1PaperTailWithH2ConsumerStatement {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (tailRHS : ShrinkageTheorem1TailRHS) : Prop where
  paper_tail :
    ShrinkageTheorem1PaperTailStatement P X Z SigmaInv Sigma SigmaSqrt
      sigmaX eta lam estimator bias t tailRHS
  h2_consumer :
    PaperH2LeaveOneOutProbabilityConsumerStatement P X eta lam h2ProbabilityRHS

/-- Project the paper-tail statement from a theorem-facing H2-consumer wrapper. -/
theorem shrinkageTheorem1PaperTailWithH2ConsumerStatement_paper_tail
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1PaperTailWithH2ConsumerStatement P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t h2ProbabilityRHS tailRHS) :
    ShrinkageTheorem1PaperTailStatement P X Z SigmaInv Sigma SigmaSqrt
      sigmaX eta lam estimator bias t tailRHS :=
  h.paper_tail

/-- Project the H2 probability consumer from a theorem-facing H2-consumer wrapper. -/
theorem shrinkageTheorem1PaperTailWithH2ConsumerStatement_h2_consumer
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1PaperTailWithH2ConsumerStatement P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t h2ProbabilityRHS tailRHS) :
    PaperH2LeaveOneOutProbabilityConsumerStatement P X eta lam h2ProbabilityRHS :=
  h.h2_consumer

/--
Theorem-facing wrapper pairing the paper-tail statement with the resolvent-side
H2 bad-event probability statement.

This names the explicit resolvent probability obligation before it is combined
with lower-event/lower-bad inputs by the union-bound layer.  It does not prove
a resolvent-tail, concentration, primitive measurability, or Theorem 1 bound.
-/
structure ShrinkageTheorem1PaperTailWithH2ResolventProbabilityStatement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (resolventRHS : PaperH2GoodEventProbabilityRHS)
    (tailRHS : ShrinkageTheorem1TailRHS) : Prop where
  paper_tail :
    ShrinkageTheorem1PaperTailStatement P X Z SigmaInv Sigma SigmaSqrt
      sigmaX eta lam estimator bias t tailRHS
  h2_resolvent_probability :
    PaperH2ResolventBadEventProbabilityStatement P X lam resolventRHS

/-- Project the paper-tail statement from a theorem-facing resolvent-probability wrapper. -/
theorem shrinkageTheorem1PaperTailWithH2ResolventProbabilityStatement_paper_tail
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (resolventRHS : PaperH2GoodEventProbabilityRHS)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1PaperTailWithH2ResolventProbabilityStatement
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        resolventRHS tailRHS) :
    ShrinkageTheorem1PaperTailStatement P X Z SigmaInv Sigma SigmaSqrt
      sigmaX eta lam estimator bias t tailRHS :=
  h.paper_tail

/-- Project the H2 resolvent probability statement from its theorem-facing wrapper. -/
theorem shrinkageTheorem1PaperTailWithH2ResolventProbabilityStatement_h2_resolvent_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (resolventRHS : PaperH2GoodEventProbabilityRHS)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1PaperTailWithH2ResolventProbabilityStatement
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        resolventRHS tailRHS) :
    PaperH2ResolventBadEventProbabilityStatement P X lam resolventRHS :=
  h.h2_resolvent_probability

/--
Build the theorem-facing paper-tail/resolvent-probability wrapper from existing
paper-tail providers and a resolvent probability provider.

The result keeps the paper-tail bound next to the explicit resolvent-side H2
probability obligation.  It does not combine with the lower event or prove a
new probability estimate.
-/
theorem shrinkageTheorem1PaperTailWithH2ResolventProbabilityStatement_of_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (resolventRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (lambdaPositive : 0 < lam) (thresholdNonnegative : 0 <= t)
    (paperTailBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) <=
        ENNReal.ofReal tailRHS)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    ShrinkageTheorem1PaperTailWithH2ResolventProbabilityStatement
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      resolventRHS tailRHS where
  paper_tail :=
    shrinkageTheorem1PaperTailStatement_of_providers
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      paperTailRHS lambdaMinSigma tailRHS providers lambdaPositive
      thresholdNonnegative paperTailBound
  h2_resolvent_probability :=
    paperH2ResolventBadEventProbabilityStatement_of_provider
      P X lam resolventRHS hResolvent

/--
Consume the theorem-facing paper-tail/resolvent-probability wrapper together
with the deterministic lower-event provider to build the theorem-facing H2
consumer wrapper.

This is the final thin bridge before proving a real H2 probability estimate:
the paper-tail statement is projected from the resolvent wrapper, the lower
side is discharged only by the deterministic empty-event provider, and the
resolvent probability remains the explicit statement already carried by the
wrapper.  No concentration, lower-tail, resolvent-tail, or Theorem 1 bound is
proved here.
-/
theorem shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_resolventProbabilityStatement_and_lowerEventProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (hTailResolvent :
      ShrinkageTheorem1PaperTailWithH2ResolventProbabilityStatement
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        resolventRHS tailRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hRHS : PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS h2ProbabilityRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta) :
    ShrinkageTheorem1PaperTailWithH2ConsumerStatement
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      h2ProbabilityRHS tailRHS where
  paper_tail := hTailResolvent.paper_tail
  h2_consumer :=
    paperH2LeaveOneOutProbabilityConsumerStatement_of_providers
      P X eta lam h2ProbabilityRHS hMeas
      (paperH2LeaveOneOutGoodEventProbabilityProvider_of_lowerEventProvider_and_resolventProbabilityProvider
        P X eta lam lowerRHS resolventRHS h2ProbabilityRHS
        lowerRHS_nonnegative hRHS hLower
        (paperH2ResolventBadEventProbabilityProvider_of_statement
          P X lam resolventRHS hTailResolvent.h2_resolvent_probability))

/--
Build the theorem-facing paper-tail/H2-consumer wrapper from existing
paper-tail providers and lower-bad/resolvent-bad H2 union-bound providers.

The `paper_tail` field is the existing paper-tail statement wrapper with an
explicit tail bound.  The `h2_consumer` field is the existing H2 union-bound
consumer wrapper.  No probability/concentration theorem is proved here.
-/
theorem shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_unionBoundProbabilityProviders
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (lambdaPositive : 0 < lam) (thresholdNonnegative : 0 <= t)
    (paperTailBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) <=
        ENNReal.ofReal tailRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (hRHS : PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS h2ProbabilityRHS)
    (hLower : PaperH2LowerSingularValueBadEventProbabilityProvider
      P X eta lowerRHS)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    ShrinkageTheorem1PaperTailWithH2ConsumerStatement
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      h2ProbabilityRHS tailRHS where
  paper_tail :=
    shrinkageTheorem1PaperTailStatement_of_providers
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      paperTailRHS lambdaMinSigma tailRHS providers lambdaPositive
      thresholdNonnegative paperTailBound
  h2_consumer :=
    shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_unionBoundProbabilityProviders
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
      tailRHS providers hMeas hRHS hLower hResolvent

/--
Paper-tail theorem-facing wrapper whose lower H2 component is supplied by the
pointwise lower-singular-value event provider.

This only composes the deterministic lower-bad empty-event provider with the
existing lower/resolvent union-bound consumer.  The resolvent bad-event
probability provider and full bad-event measurability provider remain explicit
assumptions; no concentration estimate is proved.
-/
theorem shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventProbabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (lambdaPositive : 0 < lam) (thresholdNonnegative : 0 <= t)
    (paperTailBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) <=
        ENNReal.ofReal tailRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hRHS : PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS h2ProbabilityRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hResolvent : PaperH2ResolventBadEventProbabilityProvider
      P X lam resolventRHS) :
    ShrinkageTheorem1PaperTailWithH2ConsumerStatement
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      h2ProbabilityRHS tailRHS :=
  shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_unionBoundProbabilityProviders
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
    lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
    tailRHS providers lambdaPositive thresholdNonnegative paperTailBound hMeas
    hRHS
      (paperH2LowerSingularValueBadEventProbabilityProvider_of_eventProvider
        P X eta lowerRHS lowerRHS_nonnegative hLower)
      hResolvent

/--
Build the theorem-facing paper-tail/H2-consumer wrapper from a lower-event
provider and supplied paper-RHS resolvent component bounds.

This specializes the existing lower-event/resolvent-probability bridge to the
paper-RHS resolvent provider and the definitional lower-plus-resolvent H2 union
RHS.  It proves no lower-singular-value tail, determinant tail, denominator
tail, resolvent tail, concentration estimate, or Theorem 1 bound.
-/
theorem shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventPaperRHSBounds
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (lambdaPositive : 0 < lam) (thresholdNonnegative : 0 <= t)
    (paperTailBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) <=
        ENNReal.ofReal tailRHS)
    (hMeas : PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hDenominatorPrefactor : 0 <= denominatorParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam))
    (hDenominatorBounds :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam)) :
    ShrinkageTheorem1PaperTailWithH2ConsumerStatement
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      (paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS
        (paperH2ResolventAtomicBadEventUnionBoundRHS
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam)
          (fun _ : Fin n =>
            paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam)
          (fun _ : Fin n =>
            paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam)))
      tailRHS where
  paper_tail :=
    shrinkageTheorem1PaperTailStatement_of_providers
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      paperTailRHS lambdaMinSigma tailRHS providers lambdaPositive
      thresholdNonnegative paperTailBound
  h2_consumer :=
    shrinkageTheorem1PaperTailH2ProbabilityConsumer_of_lowerEventProvider_and_resolventPaperRHSBounds
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS providers hMeas
      lowerRHS_nonnegative hLower shrinkageParams leaveOneOutParams
      denominatorParams hShrinkagePrefactor hLeaveOneOutPrefactor
      hDenominatorPrefactor hShrinkageBound hLeaveOneOutBounds
      hDenominatorBounds

/--
Typed proof-readiness ledger for the current shrinkage Theorem 1 boundary.

The fields are exactly the remaining non-provider/theorem-facing inputs needed
by the existing paper-tail/H2 consumer bridge: paper-tail providers plus the
explicit paper-tail bound, H2 bad-event measurability, the lower/resolvent
union-bound RHS wiring, the lower singular-value event provider, and the
resolvent bad-event probability provider.

This structure records obligations only.  It does not prove primitive H1/H2
measurability, lower singular-value probability, resolvent probability,
concentration, the paper-tail estimate, or Theorem 1.
-/
structure ShrinkageTheorem1ProofReadinessObligations {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS) : Prop where
  providers :
    ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
      sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS
  lambda_positive : 0 < lam
  threshold_nonnegative : 0 <= t
  paper_tail_bound :
    P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) <=
      ENNReal.ofReal tailRHS
  h2_bad_event_measurability :
    PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam
  lower_rhs_nonnegative : 0 <= lowerRHS
  h2_union_rhs :
    PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS h2ProbabilityRHS
  lower_singular_value_event :
    PaperH2LowerSingularValueEventProvider P X eta
  resolvent_bad_event_probability :
    PaperH2ResolventBadEventProbabilityProvider P X lam resolventRHS

/-- Project paper-tail providers from the proof-readiness ledger. -/
theorem shrinkageTheorem1ProofReadinessObligations_providers
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1ProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
        tailRHS) :
    ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
      sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS :=
  h.providers

/-- Project positivity of the regularization parameter from the ledger. -/
theorem shrinkageTheorem1ProofReadinessObligations_lambda_positive
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1ProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
        tailRHS) :
    0 < lam :=
  h.lambda_positive

/-- Project nonnegativity of the paper-tail threshold from the ledger. -/
theorem shrinkageTheorem1ProofReadinessObligations_threshold_nonnegative
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1ProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
        tailRHS) :
    0 <= t :=
  h.threshold_nonnegative

/-- Project the supplied paper-tail bound from the ledger. -/
theorem shrinkageTheorem1ProofReadinessObligations_paper_tail_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1ProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
        tailRHS) :
    P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) <=
      ENNReal.ofReal tailRHS :=
  h.paper_tail_bound

/-- Project H2 bad-event measurability from the proof-readiness ledger. -/
theorem shrinkageTheorem1ProofReadinessObligations_h2_bad_event_measurability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1ProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
        tailRHS) :
    PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam :=
  h.h2_bad_event_measurability

/-- Project nonnegativity of the lower-event RHS from the ledger. -/
theorem shrinkageTheorem1ProofReadinessObligations_lower_rhs_nonnegative
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1ProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
        tailRHS) :
    0 <= lowerRHS :=
  h.lower_rhs_nonnegative

/-- Project H2 bad-event union RHS wiring from the ledger. -/
theorem shrinkageTheorem1ProofReadinessObligations_h2_union_rhs
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1ProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
        tailRHS) :
    PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
      lowerRHS resolventRHS h2ProbabilityRHS :=
  h.h2_union_rhs

/-- Project the lower singular-value event provider from the ledger. -/
theorem shrinkageTheorem1ProofReadinessObligations_lower_singular_value_event
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1ProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
        tailRHS) :
    PaperH2LowerSingularValueEventProvider P X eta :=
  h.lower_singular_value_event

/-- Project the resolvent bad-event probability provider from the ledger. -/
theorem shrinkageTheorem1ProofReadinessObligations_resolvent_bad_event_probability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1ProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
        tailRHS) :
    PaperH2ResolventBadEventProbabilityProvider P X lam resolventRHS :=
  h.resolvent_bad_event_probability

/--
Build the theorem-facing proof-readiness ledger while deriving H2 bad-event
measurability from the supplied paper-tail providers and eta-only lower event
provider.

This fills only the measurability field using H1 plus the deterministic
lower-event bridge; it proves no probability, concentration, or tail estimate.
-/
theorem shrinkageTheorem1ProofReadinessObligations_of_lowerEventProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (lambdaPositive : 0 < lam)
    (thresholdNonnegative : 0 <= t)
    (paperTailBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) <=
        ENNReal.ofReal tailRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (h2UnionRHS :
      PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
        lowerRHS resolventRHS h2ProbabilityRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hResolvent :
      PaperH2ResolventBadEventProbabilityProvider P X lam resolventRHS) :
    ShrinkageTheorem1ProofReadinessObligations
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
      tailRHS where
  providers := providers
  lambda_positive := lambdaPositive
  threshold_nonnegative := thresholdNonnegative
  paper_tail_bound := paperTailBound
  h2_bad_event_measurability :=
    paperH2LeaveOneOutBadEventMeasurabilityProvider_of_h1_and_lowerEventProvider
      P X Z Sigma SigmaSqrt sigmaX eta lam
      (shrinkageTheorem1Providers_h1
        P X Z Sigma SigmaSqrt sigmaX eta lam providers.core)
      hLower
  lower_rhs_nonnegative := lowerRHS_nonnegative
  h2_union_rhs := h2UnionRHS
  lower_singular_value_event := hLower
  resolvent_bad_event_probability := hResolvent

/--
Consume the proof-readiness ledger into the theorem-facing paper-tail/H2
consumer statement.

This is only a bundling/projection theorem over already supplied obligations;
no new probability, measurability, concentration, or Theorem 1 result is
proved.
-/
theorem shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_proofReadinessObligations
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1ProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
        tailRHS) :
    ShrinkageTheorem1PaperTailWithH2ConsumerStatement
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      h2ProbabilityRHS tailRHS :=
  shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventProbabilityProvider
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
    lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
    tailRHS h.providers h.lambda_positive h.threshold_nonnegative
    h.paper_tail_bound h.h2_bad_event_measurability h.lower_rhs_nonnegative
    h.h2_union_rhs h.lower_singular_value_event
    h.resolvent_bad_event_probability

/--
Direct theorem-facing consumer wrapper that derives H2 bad-event measurability
from the paper-tail H1 provider and the lower singular-value event provider.

This is just the lower-event proof-readiness constructor followed by the
existing proof-readiness consumer.  Probability, concentration, and tail bounds
remain explicit inputs.
-/
theorem shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventProbabilityProvider_fromH1
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS resolventRHS h2ProbabilityRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (lambdaPositive : 0 < lam)
    (thresholdNonnegative : 0 <= t)
    (paperTailBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) <=
        ENNReal.ofReal tailRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (h2UnionRHS :
      PaperH2LeaveOneOutBadEventUnionBoundRHSProvider
        lowerRHS resolventRHS h2ProbabilityRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hResolvent :
      PaperH2ResolventBadEventProbabilityProvider P X lam resolventRHS) :
    ShrinkageTheorem1PaperTailWithH2ConsumerStatement
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      h2ProbabilityRHS tailRHS :=
  shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_proofReadinessObligations
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
    lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
    tailRHS
    (shrinkageTheorem1ProofReadinessObligations_of_lowerEventProvider
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      lowerRHS resolventRHS h2ProbabilityRHS paperTailRHS lambdaMinSigma
      tailRHS providers lambdaPositive thresholdNonnegative paperTailBound
      lowerRHS_nonnegative h2UnionRHS hLower hResolvent)

/--
Paper-RHS-specialized proof-readiness ledger for the theorem-facing
paper-tail/H2-consumer boundary.

This structure records only supplied obligations: the paper-tail statement
inputs, H2 bad-event measurability, the lower-event provider, and the paper-RHS
component bounds needed by the resolvent provider.  It proves no determinant
tail, denominator tail, lower singular-value tail, concentration estimate, or
Theorem 1 bound.
-/
structure ShrinkageTheorem1PaperRHSProofReadinessObligations {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters) :
    Prop where
  providers :
    ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
      sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS
  lambda_positive : 0 < lam
  threshold_nonnegative : 0 <= t
  paper_tail_bound :
    P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) <=
      ENNReal.ofReal tailRHS
  h2_bad_event_measurability :
    PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam
  lower_rhs_nonnegative : 0 <= lowerRHS
  lower_singular_value_event :
    PaperH2LowerSingularValueEventProvider P X eta
  shrinkage_shifted_det_prefactor_nonnegative :
    0 <= shrinkageParams.prefactor
  leave_one_out_shifted_det_prefactor_nonnegative :
    0 <= leaveOneOutParams.prefactor
  woodbury_denominator_prefactor_nonnegative :
    0 <= denominatorParams.prefactor
  shrinkage_shifted_det_tail_bound :
    P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
      ENNReal.ofReal
        (paperH2ShrinkageShiftedDetTailPaperRHS
          (d := d) (n := n) shrinkageParams lam)
  leave_one_out_shifted_det_point_tail_bounds :
    ∀ k : Fin n,
      P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
        ENNReal.ofReal
          (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
            (d := d) (n := n) leaveOneOutParams lam)
  woodbury_denominator_point_tail_bounds :
    ∀ k : Fin n,
      P (paperH2WoodburyDenominatorBadEvent X k lam) <=
        ENNReal.ofReal
          (paperH2WoodburyDenominatorPointTailPaperRHS
            (d := d) (n := n) denominatorParams lam)


/-- Project paper-tail providers from the paper-RHS proof-readiness ledger. -/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_providers
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams) :
    ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
      sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS :=
  h.providers

/-- Project positivity of the regularization parameter from the paper-RHS ledger. -/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_lambda_positive
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams) :
    0 < lam :=
  h.lambda_positive

/-- Project nonnegativity of the paper-tail threshold from the paper-RHS ledger. -/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_threshold_nonnegative
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams) :
    0 <= t :=
  h.threshold_nonnegative

/-- Project the supplied paper-tail bound from the paper-RHS ledger. -/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_paper_tail_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams) :
    P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) <=
      ENNReal.ofReal tailRHS :=
  h.paper_tail_bound

/-- Project H2 bad-event measurability from the paper-RHS ledger. -/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_h2_bad_event_measurability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams) :
    PaperH2LeaveOneOutBadEventMeasurabilityProvider X eta lam :=
  h.h2_bad_event_measurability

/-- Project lower-RHS nonnegativity from the paper-RHS ledger. -/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_lower_rhs_nonnegative
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams) :
    0 <= lowerRHS :=
  h.lower_rhs_nonnegative

/-- Project the lower singular-value event provider from the paper-RHS ledger. -/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_lower_singular_value_event
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams) :
    PaperH2LowerSingularValueEventProvider P X eta :=
  h.lower_singular_value_event

/-- Project the shrinkage shifted-determinant prefactor side condition. -/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_shrinkage_shifted_det_prefactor_nonnegative
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams) :
    0 <= shrinkageParams.prefactor :=
  h.shrinkage_shifted_det_prefactor_nonnegative

/-- Project the leave-one-out shifted-determinant prefactor side condition. -/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_leave_one_out_shifted_det_prefactor_nonnegative
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams) :
    0 <= leaveOneOutParams.prefactor :=
  h.leave_one_out_shifted_det_prefactor_nonnegative

/-- Project the Woodbury-denominator prefactor side condition. -/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_woodbury_denominator_prefactor_nonnegative
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams) :
    0 <= denominatorParams.prefactor :=
  h.woodbury_denominator_prefactor_nonnegative

/-- Project the shrinkage shifted-determinant paper-RHS tail bound. -/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_shrinkage_shifted_det_tail_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams) :
    P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
      ENNReal.ofReal
        (paperH2ShrinkageShiftedDetTailPaperRHS
          (d := d) (n := n) shrinkageParams lam) :=
  h.shrinkage_shifted_det_tail_bound

/-- Project the leave-one-out shifted-determinant pointwise paper-RHS tail bounds. -/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_leave_one_out_shifted_det_point_tail_bounds
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams) :
    ∀ k : Fin n,
      P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
        ENNReal.ofReal
          (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
            (d := d) (n := n) leaveOneOutParams lam) :=
  h.leave_one_out_shifted_det_point_tail_bounds

/-- Project the Woodbury-denominator pointwise paper-RHS tail bounds. -/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_woodbury_denominator_point_tail_bounds
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams) :
    ∀ k : Fin n,
      P (paperH2WoodburyDenominatorBadEvent X k lam) <=
        ENNReal.ofReal
          (paperH2WoodburyDenominatorPointTailPaperRHS
            (d := d) (n := n) denominatorParams lam) :=
  h.woodbury_denominator_point_tail_bounds

/--
Build the paper-RHS-specialized proof-readiness ledger while deriving H2
bad-event measurability from the supplied paper-tail providers and eta-only
lower event provider.

This is a field-packaging convenience only: the paper-RHS component tail bounds
remain explicit inputs, and no probability, concentration, or Theorem 1 result
is proved.
-/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_of_lowerEventProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (lambdaPositive : 0 < lam)
    (thresholdNonnegative : 0 <= t)
    (paperTailBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) <=
        ENNReal.ofReal tailRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hDenominatorPrefactor : 0 <= denominatorParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam))
    (hDenominatorBounds :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam)) :
    ShrinkageTheorem1PaperRHSProofReadinessObligations
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams where
  providers := providers
  lambda_positive := lambdaPositive
  threshold_nonnegative := thresholdNonnegative
  paper_tail_bound := paperTailBound
  h2_bad_event_measurability :=
    paperH2LeaveOneOutBadEventMeasurabilityProvider_of_h1_and_lowerEventProvider
      P X Z Sigma SigmaSqrt sigmaX eta lam
      (shrinkageTheorem1Providers_h1
        P X Z Sigma SigmaSqrt sigmaX eta lam providers.core)
      hLower
  lower_rhs_nonnegative := lowerRHS_nonnegative
  lower_singular_value_event := hLower
  shrinkage_shifted_det_prefactor_nonnegative := hShrinkagePrefactor
  leave_one_out_shifted_det_prefactor_nonnegative := hLeaveOneOutPrefactor
  woodbury_denominator_prefactor_nonnegative := hDenominatorPrefactor
  shrinkage_shifted_det_tail_bound := hShrinkageBound
  leave_one_out_shifted_det_point_tail_bounds := hLeaveOneOutBounds
  woodbury_denominator_point_tail_bounds := hDenominatorBounds


/--
The additive paper-tail event is contained in the left component's paper-tail
event when the right bias component is pointwise nonnegative.

This is deterministic event algebra: the additive bias raises the threshold by a
nonnegative term.  It proves no paper-tail probability estimate or concentration
bound.
-/
theorem shrinkageTheorem1PaperTailEvent_subset_left_of_addPaperBias_nonneg
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (lam t : Real)
    (hRight : PaperShrinkageBiasControlProvider X lam biasRight) :
    Set.Subset
      (shrinkageTheorem1PaperTailEvent X SigmaInv estimator
        (addPaperShrinkageBias biasLeft biasRight) lam t)
      (shrinkageTheorem1PaperTailEvent X SigmaInv estimator biasLeft lam t) := by
  intro omega homega
  dsimp [shrinkageTheorem1PaperTailEvent] at homega
  dsimp [shrinkageTheorem1PaperTailEvent]
  have hnonneg := hRight.pointwise_nonneg omega
  simp [paperShrinkageBiasTerm] at hnonneg
  simp [paperShrinkageBiasTerm, addPaperShrinkageBias] at homega
  simp [paperShrinkageBiasTerm]
  linarith

/--
Reuse a left paper-tail provider bundle for an additive paper-bias slot.

The right component contributes only the nonnegativity control needed by the
subset lemma; measurability of the additive paper-tail event remains an explicit
provider input.
-/
theorem shrinkageTheorem1PaperTailProviders_of_addPaperBias_left
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (t : Real)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (hLeft : ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
      sigmaX eta lam estimator biasLeft t paperTailRHS lambdaMinSigma tailRHS)
    (hRight : PaperShrinkageBiasControlProvider X lam biasRight)
    (hMeas : ShrinkageTheorem1PaperTailMeasurabilityProvider X SigmaInv estimator
      (addPaperShrinkageBias biasLeft biasRight) lam t) :
    ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
      sigmaX eta lam estimator (addPaperShrinkageBias biasLeft biasRight) t
      paperTailRHS lambdaMinSigma tailRHS where
  core := hLeft.core
  rhs := hLeft.rhs
  bias_control := paperShrinkageBiasControlProvider_of_addPaperBias
    X biasLeft biasRight lam hLeft.bias_control hRight
  measurability := hMeas

/--
Reuse a left paper-tail probability bound for an additive paper-bias slot.

This is only `measure_mono` applied to
`shrinkageTheorem1PaperTailEvent_subset_left_of_addPaperBias_nonneg`.
-/
theorem shrinkageTheorem1PaperTailBound_of_addPaperBias_left
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (lam t : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (hLeftBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator biasLeft lam t) <=
        ENNReal.ofReal tailRHS)
    (hRight : PaperShrinkageBiasControlProvider X lam biasRight) :
    P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator
        (addPaperShrinkageBias biasLeft biasRight) lam t) <=
      ENNReal.ofReal tailRHS :=
  le_trans
    (measure_mono
      (shrinkageTheorem1PaperTailEvent_subset_left_of_addPaperBias_nonneg
        X SigmaInv estimator biasLeft biasRight lam t hRight))
    hLeftBound

/--
Build paper-RHS proof-readiness for an additive paper-bias slot from the left
paper-RHS proof-readiness ledger.

The right component is consumed only through pointwise nonnegativity, so the
left paper-tail bound remains valid by event inclusion.  Additive tail-event
measurability is still supplied explicitly.  No new concentration or component
probability estimate is proved.
-/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_of_addPaperBias_left
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (hLeft : ShrinkageTheorem1PaperRHSProofReadinessObligations
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator biasLeft t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams leaveOneOutParams
      denominatorParams)
    (hRight : PaperShrinkageBiasControlProvider X lam biasRight)
    (hMeas : ShrinkageTheorem1PaperTailMeasurabilityProvider X SigmaInv estimator
      (addPaperShrinkageBias biasLeft biasRight) lam t) :
    ShrinkageTheorem1PaperRHSProofReadinessObligations
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
      (addPaperShrinkageBias biasLeft biasRight) t lowerRHS paperTailRHS
      lambdaMinSigma tailRHS shrinkageParams leaveOneOutParams denominatorParams where
  providers := shrinkageTheorem1PaperTailProviders_of_addPaperBias_left
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
    biasLeft biasRight t paperTailRHS lambdaMinSigma tailRHS hLeft.providers hRight hMeas
  lambda_positive := hLeft.lambda_positive
  threshold_nonnegative := hLeft.threshold_nonnegative
  paper_tail_bound := shrinkageTheorem1PaperTailBound_of_addPaperBias_left
    P X SigmaInv estimator biasLeft biasRight lam t tailRHS hLeft.paper_tail_bound hRight
  h2_bad_event_measurability := hLeft.h2_bad_event_measurability
  lower_rhs_nonnegative := hLeft.lower_rhs_nonnegative
  lower_singular_value_event := hLeft.lower_singular_value_event
  shrinkage_shifted_det_prefactor_nonnegative :=
    hLeft.shrinkage_shifted_det_prefactor_nonnegative
  leave_one_out_shifted_det_prefactor_nonnegative :=
    hLeft.leave_one_out_shifted_det_prefactor_nonnegative
  woodbury_denominator_prefactor_nonnegative :=
    hLeft.woodbury_denominator_prefactor_nonnegative
  shrinkage_shifted_det_tail_bound := hLeft.shrinkage_shifted_det_tail_bound
  leave_one_out_shifted_det_point_tail_bounds :=
    hLeft.leave_one_out_shifted_det_point_tail_bounds
  woodbury_denominator_point_tail_bounds :=
    hLeft.woodbury_denominator_point_tail_bounds


/--
The additive paper-tail event is contained in the right component's paper-tail
event when the left bias component is pointwise nonnegative.

This is the symmetric deterministic companion to
`shrinkageTheorem1PaperTailEvent_subset_left_of_addPaperBias_nonneg`; it proves
no paper-tail probability estimate or concentration bound.
-/
theorem shrinkageTheorem1PaperTailEvent_subset_right_of_addPaperBias_nonneg
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (lam t : Real)
    (hLeft : PaperShrinkageBiasControlProvider X lam biasLeft) :
    Set.Subset
      (shrinkageTheorem1PaperTailEvent X SigmaInv estimator
        (addPaperShrinkageBias biasLeft biasRight) lam t)
      (shrinkageTheorem1PaperTailEvent X SigmaInv estimator biasRight lam t) := by
  intro omega homega
  dsimp [shrinkageTheorem1PaperTailEvent] at homega
  dsimp [shrinkageTheorem1PaperTailEvent]
  have hnonneg := hLeft.pointwise_nonneg omega
  simp [paperShrinkageBiasTerm] at hnonneg
  simp [paperShrinkageBiasTerm, addPaperShrinkageBias] at homega
  simp [paperShrinkageBiasTerm]
  linarith

/--
Reuse a right paper-tail provider bundle for an additive paper-bias slot.

The left component contributes only the nonnegativity control needed by the
subset lemma; measurability of the additive paper-tail event remains an explicit
provider input.
-/
theorem shrinkageTheorem1PaperTailProviders_of_addPaperBias_right
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (t : Real)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (hRight : ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
      sigmaX eta lam estimator biasRight t paperTailRHS lambdaMinSigma tailRHS)
    (hLeft : PaperShrinkageBiasControlProvider X lam biasLeft)
    (hMeas : ShrinkageTheorem1PaperTailMeasurabilityProvider X SigmaInv estimator
      (addPaperShrinkageBias biasLeft biasRight) lam t) :
    ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
      sigmaX eta lam estimator (addPaperShrinkageBias biasLeft biasRight) t
      paperTailRHS lambdaMinSigma tailRHS where
  core := hRight.core
  rhs := hRight.rhs
  bias_control := paperShrinkageBiasControlProvider_of_addPaperBias
    X biasLeft biasRight lam hLeft hRight.bias_control
  measurability := hMeas

/--
Reuse a right paper-tail probability bound for an additive paper-bias slot.

This is only `measure_mono` applied to
`shrinkageTheorem1PaperTailEvent_subset_right_of_addPaperBias_nonneg`.
-/
theorem shrinkageTheorem1PaperTailBound_of_addPaperBias_right
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (lam t : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (hRightBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator biasRight lam t) <=
        ENNReal.ofReal tailRHS)
    (hLeft : PaperShrinkageBiasControlProvider X lam biasLeft) :
    P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator
        (addPaperShrinkageBias biasLeft biasRight) lam t) <=
      ENNReal.ofReal tailRHS :=
  le_trans
    (measure_mono
      (shrinkageTheorem1PaperTailEvent_subset_right_of_addPaperBias_nonneg
        X SigmaInv estimator biasLeft biasRight lam t hLeft))
    hRightBound

/--
Build paper-RHS proof-readiness for an additive paper-bias slot from the right
paper-RHS proof-readiness ledger.

The left component is consumed only through pointwise nonnegativity, so the
right paper-tail bound remains valid by event inclusion. Additive tail-event
measurability is still supplied explicitly. No new concentration or component
probability estimate is proved.
-/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_of_addPaperBias_right
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (hRight : ShrinkageTheorem1PaperRHSProofReadinessObligations
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator biasRight t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams leaveOneOutParams
      denominatorParams)
    (hLeft : PaperShrinkageBiasControlProvider X lam biasLeft)
    (hMeas : ShrinkageTheorem1PaperTailMeasurabilityProvider X SigmaInv estimator
      (addPaperShrinkageBias biasLeft biasRight) lam t) :
    ShrinkageTheorem1PaperRHSProofReadinessObligations
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
      (addPaperShrinkageBias biasLeft biasRight) t lowerRHS paperTailRHS
      lambdaMinSigma tailRHS shrinkageParams leaveOneOutParams denominatorParams where
  providers := shrinkageTheorem1PaperTailProviders_of_addPaperBias_right
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
    biasLeft biasRight t paperTailRHS lambdaMinSigma tailRHS hRight.providers hLeft hMeas
  lambda_positive := hRight.lambda_positive
  threshold_nonnegative := hRight.threshold_nonnegative
  paper_tail_bound := shrinkageTheorem1PaperTailBound_of_addPaperBias_right
    P X SigmaInv estimator biasLeft biasRight lam t tailRHS hRight.paper_tail_bound hLeft
  h2_bad_event_measurability := hRight.h2_bad_event_measurability
  lower_rhs_nonnegative := hRight.lower_rhs_nonnegative
  lower_singular_value_event := hRight.lower_singular_value_event
  shrinkage_shifted_det_prefactor_nonnegative :=
    hRight.shrinkage_shifted_det_prefactor_nonnegative
  leave_one_out_shifted_det_prefactor_nonnegative :=
    hRight.leave_one_out_shifted_det_prefactor_nonnegative
  woodbury_denominator_prefactor_nonnegative :=
    hRight.woodbury_denominator_prefactor_nonnegative
  shrinkage_shifted_det_tail_bound := hRight.shrinkage_shifted_det_tail_bound
  leave_one_out_shifted_det_point_tail_bounds :=
    hRight.leave_one_out_shifted_det_point_tail_bounds
  woodbury_denominator_point_tail_bounds :=
    hRight.woodbury_denominator_point_tail_bounds

/--
Specialize the additive proof-readiness wrapper to the displayed
`Delta_X(lambda)` paper-bias decomposition, consuming a readiness ledger for the
deterministic-equivalent component and only pointwise nonnegativity for the
variance-plus-exponential component.

The full `Delta_X(lambda)` tail-event measurability is still supplied
explicitly.  This proves no component estimate, probability bound,
concentration input, or Theorem 1.
-/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_of_paperTheorem1DeltaBias_left
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (C1 sigmaOp C2 cX : Real) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (hLeft : ShrinkageTheorem1PaperRHSProofReadinessObligations
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
      (paperTheorem1DeterministicEquivalentPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta) t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams leaveOneOutParams
      denominatorParams)
    (hRight : PaperShrinkageBiasControlProvider X lam
      (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX))
    (hMeas : ShrinkageTheorem1PaperTailMeasurabilityProvider X SigmaInv estimator
      (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
      lam t) :
    ShrinkageTheorem1PaperRHSProofReadinessObligations
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
      (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams leaveOneOutParams
      denominatorParams := by
  simpa [paperTheorem1DeltaPaperBias] using
    (shrinkageTheorem1PaperRHSProofReadinessObligations_of_addPaperBias_left
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
      (paperTheorem1DeterministicEquivalentPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta)
      (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX) t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams leaveOneOutParams
      denominatorParams hLeft hRight hMeas)

/--
Symmetric specialization of the additive proof-readiness wrapper to the
displayed `Delta_X(lambda)` paper-bias decomposition, consuming a readiness
ledger for the variance-plus-exponential component and only pointwise
nonnegativity for the deterministic-equivalent component.

The full `Delta_X(lambda)` tail-event measurability is still supplied
explicitly.  This proves no component estimate, probability bound,
concentration input, or Theorem 1.
-/
theorem shrinkageTheorem1PaperRHSProofReadinessObligations_of_paperTheorem1DeltaBias_right
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (C1 sigmaOp C2 cX : Real) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (hRight : ShrinkageTheorem1PaperRHSProofReadinessObligations
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
      (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX) t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams leaveOneOutParams
      denominatorParams)
    (hLeft : PaperShrinkageBiasControlProvider X lam
      (paperTheorem1DeterministicEquivalentPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta))
    (hMeas : ShrinkageTheorem1PaperTailMeasurabilityProvider X SigmaInv estimator
      (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
      lam t) :
    ShrinkageTheorem1PaperRHSProofReadinessObligations
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
      (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams leaveOneOutParams
      denominatorParams := by
  simpa [paperTheorem1DeltaPaperBias] using
    (shrinkageTheorem1PaperRHSProofReadinessObligations_of_addPaperBias_right
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
      (paperTheorem1DeterministicEquivalentPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta)
      (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX) t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams leaveOneOutParams
      denominatorParams hRight hLeft hMeas)

/--
Consume the paper-RHS proof-readiness ledger into the theorem-facing
paper-tail/H2-consumer statement.

This is only a bundling/projection theorem over already supplied obligations;
it proves no component probability tail, concentration estimate, or Theorem 1
bound.
-/
theorem shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_paperRHSProofReadinessObligations
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams) :
    ShrinkageTheorem1PaperTailWithH2ConsumerStatement
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      (paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS
        (paperH2ResolventAtomicBadEventUnionBoundRHS
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam)
          (fun _ : Fin n =>
            paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam)
          (fun _ : Fin n =>
            paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam)))
      tailRHS :=
  shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventPaperRHSBounds
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t lowerRHS
    paperTailRHS lambdaMinSigma tailRHS h.providers h.lambda_positive
    h.threshold_nonnegative h.paper_tail_bound h.h2_bad_event_measurability
    h.lower_rhs_nonnegative h.lower_singular_value_event shrinkageParams
    leaveOneOutParams denominatorParams
    h.shrinkage_shifted_det_prefactor_nonnegative
    h.leave_one_out_shifted_det_prefactor_nonnegative
    h.woodbury_denominator_prefactor_nonnegative
    h.shrinkage_shifted_det_tail_bound
    h.leave_one_out_shifted_det_point_tail_bounds
    h.woodbury_denominator_point_tail_bounds

/--
Direct paper-RHS theorem-facing consumer wrapper that derives H2 bad-event
measurability from the paper-tail H1 provider and the lower singular-value
event provider.

This is just the paper-RHS lower-event proof-readiness constructor followed by
the existing paper-RHS proof-readiness consumer.  All component probability
bounds remain explicit inputs.
-/
theorem shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real) (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator bias t paperTailRHS lambdaMinSigma tailRHS)
    (lambdaPositive : 0 < lam)
    (thresholdNonnegative : 0 <= t)
    (paperTailBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator bias lam t) <=
        ENNReal.ofReal tailRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hDenominatorPrefactor : 0 <= denominatorParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam))
    (hDenominatorBounds :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam)) :
    ShrinkageTheorem1PaperTailWithH2ConsumerStatement
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      (paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS
        (paperH2ResolventAtomicBadEventUnionBoundRHS
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam)
          (fun _ : Fin n =>
            paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam)
          (fun _ : Fin n =>
            paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam)))
      tailRHS :=
  shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_paperRHSProofReadinessObligations
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t lowerRHS
    paperTailRHS lambdaMinSigma tailRHS shrinkageParams leaveOneOutParams
    denominatorParams
    (shrinkageTheorem1PaperRHSProofReadinessObligations_of_lowerEventProvider
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams providers lambdaPositive
      thresholdNonnegative paperTailBound lowerRHS_nonnegative hLower
      hShrinkagePrefactor hLeaveOneOutPrefactor hDenominatorPrefactor
      hShrinkageBound hLeaveOneOutBounds hDenominatorBounds)

/--
Project the H2 probability consumer from the paper-RHS proof-readiness ledger.

This is a field/projection convenience over
`shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_paperRHSProofReadinessObligations`;
it proves no component probability tail, concentration estimate, or Theorem 1
bound.
-/
theorem shrinkageTheorem1PaperTailH2ProbabilityConsumer_of_paperRHSProofReadinessObligations
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams) :
    PaperH2LeaveOneOutProbabilityConsumerStatement P X eta lam
      (paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS
        (paperH2ResolventAtomicBadEventUnionBoundRHS
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam)
          (fun _ : Fin n =>
            paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam)
          (fun _ : Fin n =>
            paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam))) :=
  (shrinkageTheorem1PaperTailWithH2ConsumerStatement_of_paperRHSProofReadinessObligations
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t lowerRHS
    paperTailRHS lambdaMinSigma tailRHS shrinkageParams leaveOneOutParams
    denominatorParams h).h2_consumer

/--
Project the H2 bad-event probability bound from the paper-RHS proof-readiness
ledger.

This only exposes the consumer's `bad_event_probability` field; it proves no
component probability tail, concentration estimate, or Theorem 1 bound.
-/
theorem shrinkageTheorem1PaperTailH2ProbabilityConsumer_badEventProbability_of_paperRHSProofReadinessObligations
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (bias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams) :
    P (paperH2LeaveOneOutBadEvent X eta lam) <=
      ENNReal.ofReal
        (paperH2LeaveOneOutBadEventUnionBoundRHS lowerRHS
          (paperH2ResolventAtomicBadEventUnionBoundRHS
            (paperH2ShrinkageShiftedDetTailPaperRHS
              (d := d) (n := n) shrinkageParams lam)
            (fun _ : Fin n =>
              paperH2LeaveOneOutShiftedDetPointTailPaperRHS
                (d := d) (n := n) leaveOneOutParams lam)
            (fun _ : Fin n =>
              paperH2WoodburyDenominatorPointTailPaperRHS
                (d := d) (n := n) denominatorParams lam))) :=
  (shrinkageTheorem1PaperTailH2ProbabilityConsumer_of_paperRHSProofReadinessObligations
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator bias t lowerRHS
    paperTailRHS lambdaMinSigma tailRHS shrinkageParams leaveOneOutParams
    denominatorParams h).bad_event_probability

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
Measurability provider for the final Theorem 1 tail event.

This records only the explicit measurable-event side condition for
`shrinkageTheorem1TailEvent`.  It does not prove any tail probability bound,
concentration estimate, paper RHS, or deterministic-equivalent estimate.
-/
structure ShrinkageTheorem1FinalTailMeasurabilityProvider {Omega : Type*}
    [MeasurableSpace Omega] (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm) (t : Real) : Prop where
  final_tail_event_measurable :
    MeasurableSet (shrinkageTheorem1TailEvent trueError estimatedError bias t)

/--
Direct field projection for the final tail-event measurability provider.

This is only an API convenience around the stored `MeasurableSet` field; it
does not prove primitive measurability, probability, or concentration.
-/
theorem shrinkageTheorem1FinalTailMeasurabilityProvider_final_tail_event_measurable
    {Omega : Type*} [MeasurableSpace Omega]
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm) (t : Real)
    (h :
      ShrinkageTheorem1FinalTailMeasurabilityProvider
        trueError estimatedError bias t) :
    MeasurableSet (shrinkageTheorem1TailEvent trueError estimatedError bias t) :=
  h.final_tail_event_measurable

/--
Projection theorem for the final tail-event measurability provider.

This only exposes the provider field; it does not prove probability,
concentration, or identify the concrete paper errors.
-/
theorem shrinkageTheorem1TailEvent_measurable_of_provider {Omega : Type*}
    [MeasurableSpace Omega] (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm) (t : Real)
    (h :
      ShrinkageTheorem1FinalTailMeasurabilityProvider
        trueError estimatedError bias t) :
    MeasurableSet (shrinkageTheorem1TailEvent trueError estimatedError bias t) :=
  h.final_tail_event_measurable

/--
Constructor for the final tail-event measurability provider from an explicit
`MeasurableSet` assumption.

This is only packaging; it intentionally does not derive measurability from the
paper model or prove a probability estimate.
-/
theorem shrinkageTheorem1FinalTailMeasurabilityProvider_of_measurable
    {Omega : Type*} [MeasurableSpace Omega]
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm) (t : Real)
    (h : MeasurableSet (shrinkageTheorem1TailEvent trueError estimatedError bias t)) :
    ShrinkageTheorem1FinalTailMeasurabilityProvider trueError estimatedError bias t where
  final_tail_event_measurable := h

/--
Measurability of the final tail event from measurable true and estimated error
functions.

This is the elementary Borel preimage step for
`{omega | t + bias <= |trueError omega - estimatedError omega|}`.  It does not
prove that the paper's concrete `E_X(lambda)` or estimator is measurable.
-/
theorem shrinkageTheorem1TailEvent_measurable_of_error_measurable
    {Omega : Type*} [MeasurableSpace Omega]
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm) (t : Real)
    (hTrue : Measurable trueError) (hEstimated : Measurable estimatedError) :
    MeasurableSet (shrinkageTheorem1TailEvent trueError estimatedError bias t) := by
  simpa [shrinkageTheorem1TailEvent, Set.preimage, ge_iff_le] using
    ((continuous_abs.measurable.comp (hTrue.sub hEstimated)) measurableSet_Ici :
      MeasurableSet
        ((fun omega : Omega => |trueError omega - estimatedError omega|) ⁻¹'
          Set.Ici (t + bias)))

/--
Provider constructor for final tail-event measurability from measurable true
and estimated error functions.

This packages only the elementary Borel preimage step and remains independent of
probability or concentration arguments.
-/
theorem shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable
    {Omega : Type*} [MeasurableSpace Omega]
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm) (t : Real)
    (hTrue : Measurable trueError) (hEstimated : Measurable estimatedError) :
    ShrinkageTheorem1FinalTailMeasurabilityProvider trueError estimatedError bias t :=
  shrinkageTheorem1FinalTailMeasurabilityProvider_of_measurable
    trueError estimatedError bias t
    (shrinkageTheorem1TailEvent_measurable_of_error_measurable
      trueError estimatedError bias t hTrue hEstimated)

/--
Named proof target for the final deterministic/event bridge in the Theorem 1
route.

The statement says that the final theorem event is contained in the
paper-facing tail event.  It is deliberately only a typed proposition: proving
it is the remaining deterministic comparison work between the paper's
`E_X(lambda)`, estimator, and bias objects and the paper-tail event.
-/
def ShrinkageTheorem1FinalEventSubsetStatement {Omega : Type*} [MeasurableSpace Omega]
    {d n : Nat} (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm) (t : Real) : Prop :=
  shrinkageTheorem1TailEvent trueError estimatedError bias t ⊆
    shrinkageTheorem1PaperTailEvent X SigmaInv estimator paperBias lam t

/--
Pointwise deterministic comparison provider for the final-event subset target.

The fields identify the final theorem's abstract error/estimator objects with
the paper-tail event's concrete paper-facing expressions and require the
paper-facing bias term to be bounded by the final bias placeholder.  This is a
pure deterministic interface; it proves no concentration or probability bound.
-/
structure ShrinkageTheorem1FinalEventSubsetComparisonProvider {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm) : Prop where
  true_error_eq :
    ∀ omega : Omega, trueError omega = paperShrinkageError (X omega) SigmaInv lam
  estimated_error_eq :
    ∀ omega : Omega,
      estimatedError omega = paperShrinkageEstimatedError estimator (X omega) lam
  paper_bias_le_final_bias :
    ∀ omega : Omega, paperShrinkageBiasTerm paperBias (X omega) lam <= bias

/-- Project the true-error identification from the final-event comparison provider. -/
theorem shrinkageTheorem1FinalEventSubsetComparisonProvider_true_error_eq
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1FinalEventSubsetComparisonProvider
        X SigmaInv estimator paperBias lam trueError estimatedError bias) :
    ∀ omega : Omega, trueError omega = paperShrinkageError (X omega) SigmaInv lam :=
  h.true_error_eq

/-- Project the estimated-error identification from the final-event comparison provider. -/
theorem shrinkageTheorem1FinalEventSubsetComparisonProvider_estimated_error_eq
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1FinalEventSubsetComparisonProvider
        X SigmaInv estimator paperBias lam trueError estimatedError bias) :
    ∀ omega : Omega,
      estimatedError omega = paperShrinkageEstimatedError estimator (X omega) lam :=
  h.estimated_error_eq

/-- Project the paper-bias dominance field from the final-event comparison provider. -/
theorem shrinkageTheorem1FinalEventSubsetComparisonProvider_paper_bias_le_final_bias
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1FinalEventSubsetComparisonProvider
        X SigmaInv estimator paperBias lam trueError estimatedError bias) :
    ∀ omega : Omega, paperShrinkageBiasTerm paperBias (X omega) lam <= bias :=
  h.paper_bias_le_final_bias

/--
Typed statement for the remaining final-bias dominance obligation.

It uses the random lift of the paper bias vocabulary so consumers can state the
obligation as a direct pointwise bound by the scalar final-bias placeholder.
This is pure deterministic vocabulary; it proves no bias formula or probability
bound.
-/
def ShrinkageTheorem1FinalBiasDominanceStatement {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (bias : ShrinkageTheorem1BiasTerm) : Prop :=
  ∀ omega : Omega, randomPaperShrinkageBiasTerm X paperBias lam omega <= bias

/--
Remaining deterministic bias-domination obligation for the final-event subset
comparison when the final error functions use the random paper vocabulary.

The random lifts discharge the true-error and estimated-error equality fields by
definition; this provider isolates the only non-definitional pointwise
comparison still needed at this layer.
-/
structure ShrinkageTheorem1FinalBiasDominanceProvider {Omega : Type*}
    [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (bias : ShrinkageTheorem1BiasTerm) : Prop where
  paper_bias_le_final_bias :
    ∀ omega : Omega, paperShrinkageBiasTerm paperBias (X omega) lam <= bias

/-- Project the typed final-bias dominance statement from its provider. -/
theorem shrinkageTheorem1FinalBiasDominanceStatement_of_provider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (bias : ShrinkageTheorem1BiasTerm)
    (h : ShrinkageTheorem1FinalBiasDominanceProvider X paperBias lam bias) :
    ShrinkageTheorem1FinalBiasDominanceStatement X paperBias lam bias := by
  intro omega
  simpa [ShrinkageTheorem1FinalBiasDominanceStatement,
    randomPaperShrinkageBiasTerm] using h.paper_bias_le_final_bias omega

/-- Project the pointwise random-paper-bias bound from its provider. -/
theorem shrinkageTheorem1FinalBiasDominance_bound_of_provider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (bias : ShrinkageTheorem1BiasTerm)
    (h : ShrinkageTheorem1FinalBiasDominanceProvider X paperBias lam bias) :
    ∀ omega : Omega, randomPaperShrinkageBiasTerm X paperBias lam omega <= bias :=
  shrinkageTheorem1FinalBiasDominanceStatement_of_provider X paperBias lam bias h

/-- Build the final-bias dominance provider from the typed pointwise statement. -/
theorem shrinkageTheorem1FinalBiasDominanceProvider_of_statement
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (bias : ShrinkageTheorem1BiasTerm)
    (h : ShrinkageTheorem1FinalBiasDominanceStatement X paperBias lam bias) :
    ShrinkageTheorem1FinalBiasDominanceProvider X paperBias lam bias where
  paper_bias_le_final_bias := by
    intro omega
    simpa [ShrinkageTheorem1FinalBiasDominanceStatement,
      randomPaperShrinkageBiasTerm] using h omega

/--
Monotonicity of the final-bias dominance statement in the scalar final-bias
placeholder.

Once a paper-bias random field is bounded by `biasBase`, it is also bounded by
any larger final bias.  This is only transitivity of real inequalities.
-/
theorem shrinkageTheorem1FinalBiasDominanceStatement_mono
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (biasBase bias : ShrinkageTheorem1BiasTerm)
    (h : ShrinkageTheorem1FinalBiasDominanceStatement X paperBias lam biasBase)
    (hBias : biasBase <= bias) :
    ShrinkageTheorem1FinalBiasDominanceStatement X paperBias lam bias := by
  intro omega
  exact le_trans (h omega) hBias

/--
Provider-form monotonicity for final-bias dominance.

This packages `shrinkageTheorem1FinalBiasDominanceStatement_mono` for downstream
provider consumers.
-/
theorem shrinkageTheorem1FinalBiasDominanceProvider_mono
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (biasBase bias : ShrinkageTheorem1BiasTerm)
    (h : ShrinkageTheorem1FinalBiasDominanceProvider X paperBias lam biasBase)
    (hBias : biasBase <= bias) :
    ShrinkageTheorem1FinalBiasDominanceProvider X paperBias lam bias :=
  shrinkageTheorem1FinalBiasDominanceProvider_of_statement X paperBias lam bias
    (shrinkageTheorem1FinalBiasDominanceStatement_mono
      X paperBias lam biasBase bias
      (shrinkageTheorem1FinalBiasDominanceStatement_of_provider
        X paperBias lam biasBase h)
      hBias)

/--
Final-bias dominance for a constant paper-bias slot.

If the constant paper bias is bounded by the final bias, the typed pointwise
dominance statement follows by definitional evaluation.
-/
theorem shrinkageTheorem1FinalBiasDominanceStatement_of_constantPaperBias
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (c bias : ShrinkageTheorem1BiasTerm) (hc : c <= bias) :
    ShrinkageTheorem1FinalBiasDominanceStatement X
      (constantPaperShrinkageBias (d := d) (n := n) c) lam bias := by
  intro omega
  simpa [ShrinkageTheorem1FinalBiasDominanceStatement,
    randomPaperShrinkageBiasTerm, paperShrinkageBiasTerm,
    constantPaperShrinkageBias] using hc

/--
Provider form of final-bias dominance for a constant paper-bias slot.

This is deterministic API plumbing for scalar upper-bound consumers; it does
not assert that the paper's concrete `Delta_X(lambda)` is constant.
-/
theorem shrinkageTheorem1FinalBiasDominanceProvider_of_constantPaperBias
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (c bias : ShrinkageTheorem1BiasTerm) (hc : c <= bias) :
    ShrinkageTheorem1FinalBiasDominanceProvider X
      (constantPaperShrinkageBias (d := d) (n := n) c) lam bias :=
  shrinkageTheorem1FinalBiasDominanceProvider_of_statement X
    (constantPaperShrinkageBias (d := d) (n := n) c) lam bias
    (shrinkageTheorem1FinalBiasDominanceStatement_of_constantPaperBias
      X lam c bias hc)

/--
Build final-bias dominance from a scalar upper-bound provider for the paper
bias and a comparison from that scalar bound to the final theorem's bias slot.
-/
theorem shrinkageTheorem1FinalBiasDominanceStatement_of_biasUpperBoundProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (biasBound bias : ShrinkageTheorem1BiasTerm)
    (hBound : PaperShrinkageBiasUpperBoundProvider X paperBias lam biasBound)
    (hBias : biasBound <= bias) :
    ShrinkageTheorem1FinalBiasDominanceStatement X paperBias lam bias := by
  intro omega
  exact le_trans
    (paperShrinkageBiasUpperBound_of_provider
      X paperBias lam biasBound hBound omega)
    hBias

/--
Provider form of the scalar upper-bound route into final-bias dominance.

This is deterministic proof plumbing only; concrete upper bounds for the paper
bias remain separate provider tasks.
-/
theorem shrinkageTheorem1FinalBiasDominanceProvider_of_biasUpperBoundProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (biasBound bias : ShrinkageTheorem1BiasTerm)
    (hBound : PaperShrinkageBiasUpperBoundProvider X paperBias lam biasBound)
    (hBias : biasBound <= bias) :
    ShrinkageTheorem1FinalBiasDominanceProvider X paperBias lam bias :=
  shrinkageTheorem1FinalBiasDominanceProvider_of_statement X paperBias lam bias
    (shrinkageTheorem1FinalBiasDominanceStatement_of_biasUpperBoundProvider
      X paperBias lam biasBound bias hBound hBias)


/--
Final-bias dominance for the variance-plus-exponential partial paper-bias
envelope.

The only assumption is the deterministic scalar comparison from the named
partial envelope into the final bias.  This is theorem-facing proof plumbing
only; it does not prove the remaining paper bias terms, concentration, or
Theorem 1.
-/
theorem shrinkageTheorem1FinalBiasDominanceStatement_of_paperTheorem1VariancePlusExponentialBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) (C2 cX : Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (hBias :
      paperTheorem1VariancePlusExponentialBiasComponent d n lam C2 cX <= bias) :
    ShrinkageTheorem1FinalBiasDominanceStatement X
      (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX) lam bias :=
  shrinkageTheorem1FinalBiasDominanceStatement_of_biasUpperBoundProvider X
    (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX) lam bias bias
    (paperShrinkageBiasUpperBoundProvider_of_paperTheorem1VariancePlusExponentialBiasComponent
      X lam C2 cX bias hBias)
    le_rfl

/--
Provider form of final-bias dominance for the variance-plus-exponential partial
paper-bias envelope.
-/
theorem shrinkageTheorem1FinalBiasDominanceProvider_of_paperTheorem1VariancePlusExponentialBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real) (C2 cX : Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (hBias :
      paperTheorem1VariancePlusExponentialBiasComponent d n lam C2 cX <= bias) :
    ShrinkageTheorem1FinalBiasDominanceProvider X
      (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX) lam bias :=
  shrinkageTheorem1FinalBiasDominanceProvider_of_statement X
    (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX) lam bias
    (shrinkageTheorem1FinalBiasDominanceStatement_of_paperTheorem1VariancePlusExponentialBiasComponent
      X lam C2 cX bias hBias)

/--
Final-bias dominance for the displayed three-term `Delta_X(lambda)` paper-bias
slot.

The only assumption is the deterministic scalar comparison from the named
`Delta_X(lambda)` component into the final bias.  This is theorem-facing proof
plumbing only; it does not prove any component upper bound, concentration, or
Theorem 1.
-/
theorem shrinkageTheorem1FinalBiasDominanceStatement_of_paperTheorem1DeltaBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX : Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (hBias :
      paperTheorem1DeltaBiasComponent
        d n lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX <= bias) :
    ShrinkageTheorem1FinalBiasDominanceStatement X
      (paperTheorem1DeltaPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) lam bias :=
  shrinkageTheorem1FinalBiasDominanceStatement_of_biasUpperBoundProvider X
    (paperTheorem1DeltaPaperBias
      d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) lam bias bias
    (paperShrinkageBiasUpperBoundProvider_of_paperTheorem1DeltaBiasComponent
      X lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX bias hBias)
    le_rfl

/-- Provider form of final-bias dominance for the displayed three-term
`Delta_X(lambda)` paper-bias slot. -/
theorem shrinkageTheorem1FinalBiasDominanceProvider_of_paperTheorem1DeltaBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX : Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (hBias :
      paperTheorem1DeltaBiasComponent
        d n lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX <= bias) :
    ShrinkageTheorem1FinalBiasDominanceProvider X
      (paperTheorem1DeltaPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) lam bias :=
  shrinkageTheorem1FinalBiasDominanceProvider_of_statement X
    (paperTheorem1DeltaPaperBias
      d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) lam bias
    (shrinkageTheorem1FinalBiasDominanceStatement_of_paperTheorem1DeltaBiasComponent
      X lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX bias hBias)

/--
Final-bias dominance for the displayed three-term `Delta_X(lambda)` paper-bias
slot from separate component bounds.

This only routes the three supplied scalar comparisons through the existing
`paperTheorem1DeltaBiasComponents` upper-bound provider.  It proves no
component estimate, probability bound, concentration input, or Theorem 1.
-/
theorem shrinkageTheorem1FinalBiasDominanceStatement_of_paperTheorem1DeltaBiasComponents
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX : Real)
    (detBound varianceBound exponentialBound bias : ShrinkageTheorem1BiasTerm)
    (hDet :
      paperTheorem1DeterministicEquivalentBiasComponent
        d n C1 sigmaX sigmaOp lambdaMinSigma eta <= detBound)
    (hVariance : paperTheorem1VarianceBiasComponent d n lam <= varianceBound)
    (hExponential : paperTheorem1ExponentialBiasComponent n C2 cX <= exponentialBound)
    (hSum : detBound + (varianceBound + exponentialBound) <= bias) :
    ShrinkageTheorem1FinalBiasDominanceStatement X
      (paperTheorem1DeltaPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) lam bias :=
  shrinkageTheorem1FinalBiasDominanceStatement_of_biasUpperBoundProvider X
    (paperTheorem1DeltaPaperBias
      d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) lam bias bias
    (paperShrinkageBiasUpperBoundProvider_of_paperTheorem1DeltaBiasComponents
      X lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX
      detBound varianceBound exponentialBound bias hDet hVariance hExponential hSum)
    le_rfl

/-- Provider form of final-bias dominance for `Delta_X(lambda)` from separate
component bounds. -/
theorem shrinkageTheorem1FinalBiasDominanceProvider_of_paperTheorem1DeltaBiasComponents
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX : Real)
    (detBound varianceBound exponentialBound bias : ShrinkageTheorem1BiasTerm)
    (hDet :
      paperTheorem1DeterministicEquivalentBiasComponent
        d n C1 sigmaX sigmaOp lambdaMinSigma eta <= detBound)
    (hVariance : paperTheorem1VarianceBiasComponent d n lam <= varianceBound)
    (hExponential : paperTheorem1ExponentialBiasComponent n C2 cX <= exponentialBound)
    (hSum : detBound + (varianceBound + exponentialBound) <= bias) :
    ShrinkageTheorem1FinalBiasDominanceProvider X
      (paperTheorem1DeltaPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) lam bias :=
  shrinkageTheorem1FinalBiasDominanceProvider_of_statement X
    (paperTheorem1DeltaPaperBias
      d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) lam bias
    (shrinkageTheorem1FinalBiasDominanceStatement_of_paperTheorem1DeltaBiasComponents
      X lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX
      detBound varianceBound exponentialBound bias hDet hVariance hExponential hSum)

/--
Final-bias dominance from a deterministic uniform paper-bias bound and a scalar
comparison.

This is proof plumbing from a deterministic `Delta_X(lambda)`-style bound into
the final theorem's random-bias dominance slot; it proves no concentration or
closed-form paper-bias estimate.
-/
theorem shrinkageTheorem1FinalBiasDominanceStatement_of_uniformPaperBiasBound
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (biasBound bias : ShrinkageTheorem1BiasTerm)
    (hBound : ∀ X0 : DataMatrix d n, paperShrinkageBiasTerm paperBias X0 lam <= biasBound)
    (hBias : biasBound <= bias) :
    ShrinkageTheorem1FinalBiasDominanceStatement X paperBias lam bias :=
  shrinkageTheorem1FinalBiasDominanceStatement_of_biasUpperBoundProvider
    X paperBias lam biasBound bias
    (paperShrinkageBiasUpperBoundProvider_of_uniformBound X paperBias lam biasBound hBound)
    hBias

/-- Provider form of uniform deterministic paper-bias final dominance. -/
theorem shrinkageTheorem1FinalBiasDominanceProvider_of_uniformPaperBiasBound
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (biasBound bias : ShrinkageTheorem1BiasTerm)
    (hBound : ∀ X0 : DataMatrix d n, paperShrinkageBiasTerm paperBias X0 lam <= biasBound)
    (hBias : biasBound <= bias) :
    ShrinkageTheorem1FinalBiasDominanceProvider X paperBias lam bias :=
  shrinkageTheorem1FinalBiasDominanceProvider_of_statement X paperBias lam bias
    (shrinkageTheorem1FinalBiasDominanceStatement_of_uniformPaperBiasBound
      X paperBias lam biasBound bias hBound hBias)

/--
Final-bias dominance for an additive paper-bias slot.

This combines two already supplied scalar upper-bound providers and a final
comparison `(boundLeft + boundRight) <= bias`.  It remains deterministic proof
plumbing and proves no concrete paper-bias or probability estimate.
-/
theorem shrinkageTheorem1FinalBiasDominanceStatement_of_addPaperBiasUpperBounds
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (lam : Real)
    (boundLeft boundRight bias : ShrinkageTheorem1BiasTerm)
    (hLeft : PaperShrinkageBiasUpperBoundProvider X biasLeft lam boundLeft)
    (hRight : PaperShrinkageBiasUpperBoundProvider X biasRight lam boundRight)
    (hBias : boundLeft + boundRight <= bias) :
    ShrinkageTheorem1FinalBiasDominanceStatement X
      (addPaperShrinkageBias biasLeft biasRight) lam bias :=
  shrinkageTheorem1FinalBiasDominanceStatement_of_biasUpperBoundProvider X
    (addPaperShrinkageBias biasLeft biasRight) lam (boundLeft + boundRight) bias
    (paperShrinkageBiasUpperBoundProvider_of_addPaperBias
      X biasLeft biasRight lam boundLeft boundRight hLeft hRight)
    hBias

/-- Provider form of additive paper-bias final dominance. -/
theorem shrinkageTheorem1FinalBiasDominanceProvider_of_addPaperBiasUpperBounds
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (lam : Real)
    (boundLeft boundRight bias : ShrinkageTheorem1BiasTerm)
    (hLeft : PaperShrinkageBiasUpperBoundProvider X biasLeft lam boundLeft)
    (hRight : PaperShrinkageBiasUpperBoundProvider X biasRight lam boundRight)
    (hBias : boundLeft + boundRight <= bias) :
    ShrinkageTheorem1FinalBiasDominanceProvider X
      (addPaperShrinkageBias biasLeft biasRight) lam bias :=
  shrinkageTheorem1FinalBiasDominanceProvider_of_statement X
    (addPaperShrinkageBias biasLeft biasRight) lam bias
    (shrinkageTheorem1FinalBiasDominanceStatement_of_addPaperBiasUpperBounds
      X biasLeft biasRight lam boundLeft boundRight bias hLeft hRight hBias)

/--
Build the final-event comparison provider when the final theorem uses the
paper-facing random error and estimator-error vocabulary.

This closes the two equality fields by reflexivity and leaves only the explicit
pointwise bias-domination provider.
-/
theorem shrinkageTheorem1FinalEventSubsetComparisonProvider_of_randomPaperErrors
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (bias : ShrinkageTheorem1BiasTerm)
    (hBias : ShrinkageTheorem1FinalBiasDominanceProvider X paperBias lam bias) :
    ShrinkageTheorem1FinalEventSubsetComparisonProvider
      X SigmaInv estimator paperBias lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) bias := by
  refine ⟨?_, ?_, ?_⟩
  · intro omega
    rfl
  · intro omega
    rfl
  · exact hBias.paper_bias_le_final_bias

/--
Prove the named final-event subset statement from pointwise deterministic
comparison fields.

If the abstract final error and estimator agree with the paper-facing ones and
the paper-facing bias is no larger than the final bias placeholder, membership
in the final tail event implies membership in the paper-tail event.
-/
theorem shrinkageTheorem1FinalEventSubsetStatement_of_comparisonProvider
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm) (t : Real)
    (h :
      ShrinkageTheorem1FinalEventSubsetComparisonProvider
        X SigmaInv estimator paperBias lam trueError estimatedError bias) :
    ShrinkageTheorem1FinalEventSubsetStatement
      X SigmaInv estimator paperBias lam trueError estimatedError bias t := by
  intro omega hFinal
  dsimp [ShrinkageTheorem1FinalEventSubsetStatement, shrinkageTheorem1TailEvent,
    shrinkageTheorem1PaperTailEvent] at hFinal ⊢
  have hThreshold :
      t + paperShrinkageBiasTerm paperBias (X omega) lam <= t + bias :=
    add_le_add_right (h.paper_bias_le_final_bias omega) t
  calc
    |paperShrinkageError (X omega) SigmaInv lam -
        paperShrinkageEstimatedError estimator (X omega) lam|
        = |trueError omega - estimatedError omega| := by
          rw [h.true_error_eq omega, h.estimated_error_eq omega]
    _ >= t + bias := hFinal
    _ >= t + paperShrinkageBiasTerm paperBias (X omega) lam := hThreshold

/--
Final-event subset statement for the random paper error vocabulary.

This is the deterministic specialization of
`shrinkageTheorem1FinalEventSubsetStatement_of_comparisonProvider`; it proves no
probability or concentration statement.
-/
theorem shrinkageTheorem1FinalEventSubsetStatement_of_randomPaperErrors
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (bias : ShrinkageTheorem1BiasTerm) (t : Real)
    (hBias : ShrinkageTheorem1FinalBiasDominanceProvider X paperBias lam bias) :
    ShrinkageTheorem1FinalEventSubsetStatement
      X SigmaInv estimator paperBias lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) bias t :=
  shrinkageTheorem1FinalEventSubsetStatement_of_comparisonProvider
    X SigmaInv estimator paperBias lam
    (randomPaperShrinkageError X SigmaInv lam)
    (randomPaperShrinkageEstimatedError X estimator lam) bias t
    (shrinkageTheorem1FinalEventSubsetComparisonProvider_of_randomPaperErrors
      X SigmaInv estimator paperBias lam bias hBias)

/--
Final-event comparison provider for an additive paper-bias slot.

The two component scalar upper-bound providers are combined by the deterministic
additive final-bias wrapper, then consumed by the existing random-paper-error
comparison route.  This proves no probability or concentration estimate.
-/
theorem shrinkageTheorem1FinalEventSubsetComparisonProvider_of_addPaperBiasUpperBounds
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (lam : Real)
    (boundLeft boundRight bias : ShrinkageTheorem1BiasTerm)
    (hLeft : PaperShrinkageBiasUpperBoundProvider X biasLeft lam boundLeft)
    (hRight : PaperShrinkageBiasUpperBoundProvider X biasRight lam boundRight)
    (hBias : boundLeft + boundRight <= bias) :
    ShrinkageTheorem1FinalEventSubsetComparisonProvider
      X SigmaInv estimator (addPaperShrinkageBias biasLeft biasRight) lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) bias :=
  shrinkageTheorem1FinalEventSubsetComparisonProvider_of_randomPaperErrors
    X SigmaInv estimator (addPaperShrinkageBias biasLeft biasRight) lam bias
    (shrinkageTheorem1FinalBiasDominanceProvider_of_addPaperBiasUpperBounds
      X biasLeft biasRight lam boundLeft boundRight bias hLeft hRight hBias)

/-- Final-event subset statement for an additive paper-bias slot. -/
theorem shrinkageTheorem1FinalEventSubsetStatement_of_addPaperBiasUpperBounds
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (lam : Real)
    (boundLeft boundRight bias : ShrinkageTheorem1BiasTerm) (t : Real)
    (hLeft : PaperShrinkageBiasUpperBoundProvider X biasLeft lam boundLeft)
    (hRight : PaperShrinkageBiasUpperBoundProvider X biasRight lam boundRight)
    (hBias : boundLeft + boundRight <= bias) :
    ShrinkageTheorem1FinalEventSubsetStatement
      X SigmaInv estimator (addPaperShrinkageBias biasLeft biasRight) lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) bias t :=
  shrinkageTheorem1FinalEventSubsetStatement_of_randomPaperErrors
    X SigmaInv estimator (addPaperShrinkageBias biasLeft biasRight) lam bias t
    (shrinkageTheorem1FinalBiasDominanceProvider_of_addPaperBiasUpperBounds
      X biasLeft biasRight lam boundLeft boundRight bias hLeft hRight hBias)

/--
Final-event comparison provider for the displayed `Delta_X(lambda)` paper-bias
slot from separate component bounds.

This only combines already supplied scalar component comparisons and then
reuses the random-paper-error comparison route.  It proves no probability,
concentration, or component upper-bound estimate.
-/
theorem shrinkageTheorem1FinalEventSubsetComparisonProvider_of_paperTheorem1DeltaBiasComponents
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX : Real)
    (detBound varianceBound exponentialBound bias : ShrinkageTheorem1BiasTerm)
    (hDet :
      paperTheorem1DeterministicEquivalentBiasComponent
        d n C1 sigmaX sigmaOp lambdaMinSigma eta <= detBound)
    (hVariance : paperTheorem1VarianceBiasComponent d n lam <= varianceBound)
    (hExponential : paperTheorem1ExponentialBiasComponent n C2 cX <= exponentialBound)
    (hSum : detBound + (varianceBound + exponentialBound) <= bias) :
    ShrinkageTheorem1FinalEventSubsetComparisonProvider
      X SigmaInv estimator
      (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
      lam (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) bias :=
  shrinkageTheorem1FinalEventSubsetComparisonProvider_of_randomPaperErrors
    X SigmaInv estimator
    (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
    lam bias
    (shrinkageTheorem1FinalBiasDominanceProvider_of_paperTheorem1DeltaBiasComponents
      X lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX
      detBound varianceBound exponentialBound bias hDet hVariance hExponential hSum)

/-- Final-event subset statement for `Delta_X(lambda)` from separate component
bounds. -/
theorem shrinkageTheorem1FinalEventSubsetStatement_of_paperTheorem1DeltaBiasComponents
    {Omega : Type*} [MeasurableSpace Omega] {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (lam : Real)
    (C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX : Real) (t : Real)
    (detBound varianceBound exponentialBound bias : ShrinkageTheorem1BiasTerm)
    (hDet :
      paperTheorem1DeterministicEquivalentBiasComponent
        d n C1 sigmaX sigmaOp lambdaMinSigma eta <= detBound)
    (hVariance : paperTheorem1VarianceBiasComponent d n lam <= varianceBound)
    (hExponential : paperTheorem1ExponentialBiasComponent n C2 cX <= exponentialBound)
    (hSum : detBound + (varianceBound + exponentialBound) <= bias) :
    ShrinkageTheorem1FinalEventSubsetStatement
      X SigmaInv estimator
      (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
      lam (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) bias t :=
  shrinkageTheorem1FinalEventSubsetStatement_of_randomPaperErrors
    X SigmaInv estimator
    (paperTheorem1DeltaPaperBias d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
    lam bias t
    (shrinkageTheorem1FinalBiasDominanceProvider_of_paperTheorem1DeltaBiasComponents
      X lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX
      detBound varianceBound exponentialBound bias hDet hVariance hExponential hSum)

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

/-- Project theorem providers from the final tail statement. -/
theorem shrinkageTheorem1TailStatement_providers
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h : ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      trueError estimatedError t bias tailRHS) :
    ShrinkageTheorem1Providers P X Z Sigma SigmaSqrt sigmaX eta lam :=
  h.providers

/-- Project the H1 provider from the final tail statement. -/
theorem shrinkageTheorem1TailStatement_h1_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h : ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      trueError estimatedError t bias tailRHS) :
    PaperH1SubGaussianModelProvider P X Z Sigma SigmaSqrt sigmaX :=
  h.providers.h1

/-- Project the H2 provider from the final tail statement. -/
theorem shrinkageTheorem1TailStatement_h2_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h : ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      trueError estimatedError t bias tailRHS) :
    PaperH2LeaveOneOutGoodEventProvider P X eta lam :=
  h.providers.h2

/-- Project lambda positivity from the final tail statement. -/
theorem shrinkageTheorem1TailStatement_lambda_positive
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h : ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      trueError estimatedError t bias tailRHS) :
    0 < lam :=
  h.lambda_positive

/-- Project threshold nonnegativity from the final tail statement. -/
theorem shrinkageTheorem1TailStatement_threshold_nonnegative
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h : ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      trueError estimatedError t bias tailRHS) :
    0 <= t :=
  h.threshold_nonnegative

/-- Project tail-RHS nonnegativity from the final tail statement. -/
theorem shrinkageTheorem1TailStatement_tail_rhs_nonnegative
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h : ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      trueError estimatedError t bias tailRHS) :
    0 <= tailRHS :=
  h.tail_rhs_nonnegative

/-- Project the final tail probability bound from the final tail statement. -/
theorem shrinkageTheorem1TailStatement_tail_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h : ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      trueError estimatedError t bias tailRHS) :
    P (shrinkageTheorem1TailEvent trueError estimatedError bias t) <= ENNReal.ofReal tailRHS :=
  h.tail_bound

/--
Final-tail statement bundled with the explicit measurability side condition for
the final tail event.

This is only proof-readiness vocabulary: it combines the already packaged tail
bound statement with the final tail-event measurability provider.  It does not
prove a probability estimate, concentration inequality, deterministic
comparison, or concrete measurability of the paper errors.
-/
structure ShrinkageTheorem1TailWithMeasurabilityStatement {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS) : Prop where
  tail_statement :
    ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      trueError estimatedError t bias tailRHS
  final_tail_measurability :
    ShrinkageTheorem1FinalTailMeasurabilityProvider
      trueError estimatedError bias t

/-- Project the tail statement from the final-tail/measurability bundle. -/
theorem shrinkageTheorem1TailWithMeasurability_tailStatement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1TailWithMeasurabilityStatement
        P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS) :
    ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      trueError estimatedError t bias tailRHS :=
  h.tail_statement

/-- Project the final tail-event measurability provider from the bundled statement. -/
theorem shrinkageTheorem1TailWithMeasurability_finalTailMeasurabilityProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1TailWithMeasurabilityStatement
        P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS) :
    ShrinkageTheorem1FinalTailMeasurabilityProvider trueError estimatedError bias t :=
  h.final_tail_measurability

/-- Project final tail-event measurability from the bundled statement. -/
theorem shrinkageTheorem1TailWithMeasurability_finalTailEvent_measurable
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1TailWithMeasurabilityStatement
        P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS) :
    MeasurableSet (shrinkageTheorem1TailEvent trueError estimatedError bias t) :=
  shrinkageTheorem1TailEvent_measurable_of_provider
    trueError estimatedError bias t h.final_tail_measurability

/-- Project the final tail probability bound from the bundled statement. -/
theorem shrinkageTheorem1TailWithMeasurability_tail_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1TailWithMeasurabilityStatement
        P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS) :
    P (shrinkageTheorem1TailEvent trueError estimatedError bias t) <= ENNReal.ofReal tailRHS :=
  h.tail_statement.tail_bound

/-- Project theorem providers from the bundled final-tail/measurability statement. -/
theorem shrinkageTheorem1TailWithMeasurability_providers
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1TailWithMeasurabilityStatement
        P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS) :
    ShrinkageTheorem1Providers P X Z Sigma SigmaSqrt sigmaX eta lam :=
  h.tail_statement.providers

/-- Project the H1 provider from the bundled final-tail/measurability statement. -/
theorem shrinkageTheorem1TailWithMeasurability_h1_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1TailWithMeasurabilityStatement
        P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS) :
    PaperH1SubGaussianModelProvider P X Z Sigma SigmaSqrt sigmaX :=
  h.tail_statement.providers.h1

/-- Project the H2 provider from the bundled final-tail/measurability statement. -/
theorem shrinkageTheorem1TailWithMeasurability_h2_provider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1TailWithMeasurabilityStatement
        P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS) :
    PaperH2LeaveOneOutGoodEventProvider P X eta lam :=
  h.tail_statement.providers.h2

/-- Project lambda positivity from the bundled final-tail/measurability statement. -/
theorem shrinkageTheorem1TailWithMeasurability_lambda_positive
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1TailWithMeasurabilityStatement
        P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS) :
    0 < lam :=
  h.tail_statement.lambda_positive

/-- Project threshold nonnegativity from the bundled final-tail/measurability statement. -/
theorem shrinkageTheorem1TailWithMeasurability_threshold_nonnegative
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1TailWithMeasurabilityStatement
        P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS) :
    0 <= t :=
  h.tail_statement.threshold_nonnegative

/-- Project tail-RHS nonnegativity from the bundled final-tail/measurability statement. -/
theorem shrinkageTheorem1TailWithMeasurability_tail_rhs_nonnegative
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (h :
      ShrinkageTheorem1TailWithMeasurabilityStatement
        P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS) :
    0 <= tailRHS :=
  h.tail_statement.tail_rhs_nonnegative

/--
Constructor for the final-tail/measurability bundle from already packaged
tail-bound and final-tail measurability providers.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_finalMeasurability
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (hTail :
      ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
        trueError estimatedError t bias tailRHS)
    (hMeas :
      ShrinkageTheorem1FinalTailMeasurabilityProvider
        trueError estimatedError bias t) :
    ShrinkageTheorem1TailWithMeasurabilityStatement
      P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS where
  tail_statement := hTail
  final_tail_measurability := hMeas

/--
Constructor for the final-tail/measurability bundle from measurable abstract
error functions.

This only invokes the elementary final-tail measurability provider constructor;
it does not identify the errors with paper quantities or prove the tail bound.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_error_measurable
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n) (Sigma SigmaSqrt : SquareMatrix d)
    (sigmaX eta lam : Real) (trueError estimatedError : Omega -> Real)
    (t : Real) (bias : ShrinkageTheorem1BiasTerm)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (hTail :
      ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
        trueError estimatedError t bias tailRHS)
    (hTrue : Measurable trueError) (hEstimated : Measurable estimatedError) :
    ShrinkageTheorem1TailWithMeasurabilityStatement
      P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_finalMeasurability
    P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS hTail
    (shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable
      trueError estimatedError bias t hTrue hEstimated)

/--
Pure set/measure bridge for the final Theorem 1 tail event.

If the final theorem event is contained in the paper-facing tail event, then
the existing paper-facing probability bound can be reused as the final tail
bound.  This theorem proves only the monotonicity step; it does not construct
the set inclusion, any concentration estimate, or the paper RHS.
-/
theorem shrinkageTheorem1TailBound_of_eventSubset_paperTailBound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm) (t : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (event_subset :
      shrinkageTheorem1TailEvent trueError estimatedError bias t ⊆
        shrinkageTheorem1PaperTailEvent X SigmaInv estimator paperBias lam t)
    (paper_tail_bound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator paperBias lam t) <=
        ENNReal.ofReal tailRHS) :
    P (shrinkageTheorem1TailEvent trueError estimatedError bias t) <=
      ENNReal.ofReal tailRHS := by
  exact le_trans (measure_mono event_subset) paper_tail_bound

/--
Statement-based variant of
`shrinkageTheorem1TailBound_of_eventSubset_paperTailBound`.

This keeps the remaining final-event subset proof obligation behind a named
typed statement while reusing the same pure `measure_mono` bridge.
-/
theorem shrinkageTheorem1TailBound_of_finalEventSubsetStatement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X : RandomDataMatrix Omega d n) (SigmaInv : SquareMatrix d)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (lam : Real) (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm) (t : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (event_subset :
      ShrinkageTheorem1FinalEventSubsetStatement
        X SigmaInv estimator paperBias lam trueError estimatedError bias t)
    (paper_tail_bound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator paperBias lam t) <=
        ENNReal.ofReal tailRHS) :
    P (shrinkageTheorem1TailEvent trueError estimatedError bias t) <=
      ENNReal.ofReal tailRHS :=
  shrinkageTheorem1TailBound_of_eventSubset_paperTailBound
    P X SigmaInv estimator paperBias lam trueError estimatedError bias t tailRHS
    event_subset paper_tail_bound

/--
Compact final bridge-readiness ledger for the paper-RHS route to Theorem 1.

The `paper_rhs_readiness` field records all currently prepared provider/API
obligations on the paper-RHS route.  The `final_tail_bound` field is the single
remaining analytic bridge from those paper-facing/H2-consumer objects to the
final `shrinkageTheorem1TailEvent`.  This structure does not prove that bridge,
any component tail, concentration estimate, deterministic comparison, or
Theorem 1.
-/
structure ShrinkageTheorem1PaperRHSFinalBridgeObligations {Omega : Type*}
    [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm) : Prop where
  paper_rhs_readiness :
    ShrinkageTheorem1PaperRHSProofReadinessObligations
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams
  final_tail_bound :
    P (shrinkageTheorem1TailEvent trueError estimatedError bias t) <=
      ENNReal.ofReal tailRHS

/-- Project the paper-RHS readiness ledger from the compact final bridge ledger. -/
theorem shrinkageTheorem1PaperRHSFinalBridgeObligations_paper_rhs_readiness
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSFinalBridgeObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams trueError estimatedError bias) :
    ShrinkageTheorem1PaperRHSProofReadinessObligations
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams :=
  h.paper_rhs_readiness

/-- Project the supplied final tail bound from the compact final bridge ledger. -/
theorem shrinkageTheorem1PaperRHSFinalBridgeObligations_final_tail_bound
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSFinalBridgeObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams trueError estimatedError bias) :
    P (shrinkageTheorem1TailEvent trueError estimatedError bias t) <=
      ENNReal.ofReal tailRHS :=
  h.final_tail_bound

/--
Build the compact final bridge-readiness ledger from the paper-RHS readiness
ledger plus the remaining final-event subset obligation.

This wrapper only applies the pure `measure_mono` bridge
`shrinkageTheorem1TailBound_of_eventSubset_paperTailBound` to the paper-tail
bound already stored in `h`.  It does not prove the subset obligation,
concentration estimates, deterministic comparisons, component tails, or
Theorem 1.
-/
theorem shrinkageTheorem1PaperRHSFinalBridgeObligations_of_eventSubset
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (event_subset :
      shrinkageTheorem1TailEvent trueError estimatedError bias t ⊆
        shrinkageTheorem1PaperTailEvent X SigmaInv estimator paperBias lam t) :
    ShrinkageTheorem1PaperRHSFinalBridgeObligations
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams trueError estimatedError bias where
  paper_rhs_readiness := h
  final_tail_bound :=
    shrinkageTheorem1TailBound_of_eventSubset_paperTailBound
      P X SigmaInv estimator paperBias lam trueError estimatedError bias t tailRHS
      event_subset h.paper_tail_bound

/--
Statement-based final bridge-readiness wrapper.

This is the same bridge as
`shrinkageTheorem1PaperRHSFinalBridgeObligations_of_eventSubset`, but the
remaining set inclusion is passed through the named proof target
`ShrinkageTheorem1FinalEventSubsetStatement`.
-/
theorem shrinkageTheorem1PaperRHSFinalBridgeObligations_of_finalEventSubsetStatement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (event_subset :
      ShrinkageTheorem1FinalEventSubsetStatement
        X SigmaInv estimator paperBias lam trueError estimatedError bias t) :
    ShrinkageTheorem1PaperRHSFinalBridgeObligations
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams trueError estimatedError bias where
  paper_rhs_readiness := h
  final_tail_bound :=
    shrinkageTheorem1TailBound_of_finalEventSubsetStatement
      P X SigmaInv estimator paperBias lam trueError estimatedError bias t tailRHS
      event_subset h.paper_tail_bound

/--
Consume the compact final bridge-readiness ledger into the final theorem
statement shape.

This theorem only repackages already supplied fields.  In particular,
`final_tail_bound` remains an explicit input, so no analytic bridge,
concentration estimate, component tail, deterministic comparison, or Theorem 1
proof is produced here.
-/
theorem shrinkageTheorem1TailStatement_of_paperRHSFinalBridgeObligations
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSFinalBridgeObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams trueError estimatedError bias) :
    ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      trueError estimatedError t bias tailRHS where
  providers := h.paper_rhs_readiness.providers.core
  lambda_positive := h.paper_rhs_readiness.lambda_positive
  threshold_nonnegative := h.paper_rhs_readiness.threshold_nonnegative
  tail_rhs_nonnegative :=
    (shrinkageTheorem1PaperTailStatement_of_providers
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
      paperTailRHS lambdaMinSigma tailRHS h.paper_rhs_readiness.providers
      h.paper_rhs_readiness.lambda_positive
      h.paper_rhs_readiness.threshold_nonnegative
      h.paper_rhs_readiness.paper_tail_bound).tail_rhs_nonnegative
  tail_bound := h.final_tail_bound

/--
Bundled final tail-statement consumer from the compact final bridge-readiness
ledger plus final tail-event measurability.

This is only packaging around
`shrinkageTheorem1TailStatement_of_paperRHSFinalBridgeObligations` and the
generic tail/measurability bundle.  It proves no probability estimate,
concentration bound, deterministic comparison, subset lemma, or primitive
measurability result.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSFinalBridgeObligations
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSFinalBridgeObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams trueError estimatedError bias)
    (hMeas :
      ShrinkageTheorem1FinalTailMeasurabilityProvider
        trueError estimatedError bias t) :
    ShrinkageTheorem1TailWithMeasurabilityStatement
      P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_finalMeasurability
    P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS
    (shrinkageTheorem1TailStatement_of_paperRHSFinalBridgeObligations
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams trueError estimatedError bias h)
    hMeas

/--
Variant of the compact final bridge-readiness bundled consumer that constructs
the final-tail measurability provider from measurable abstract error functions.

This remains a deterministic/API wrapper and does not prove probability,
concentration, subset, or paper-quantity identification facts.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSFinalBridgeObligations_error_measurable
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSFinalBridgeObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams trueError estimatedError bias)
    (hTrue : Measurable trueError) (hEstimated : Measurable estimatedError) :
    ShrinkageTheorem1TailWithMeasurabilityStatement
      P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSFinalBridgeObligations
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
    leaveOneOutParams denominatorParams trueError estimatedError bias h
    (shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable
      trueError estimatedError bias t hTrue hEstimated)

/--
Direct final tail-statement consumer for the paper-RHS readiness route when the
remaining final-event subset obligation is supplied.

This theorem is just the composition of
`shrinkageTheorem1PaperRHSFinalBridgeObligations_of_eventSubset` and
`shrinkageTheorem1TailStatement_of_paperRHSFinalBridgeObligations`; it proves no
probability, concentration, deterministic comparison, or subset lemma.
-/
theorem shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_eventSubset
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (event_subset :
      shrinkageTheorem1TailEvent trueError estimatedError bias t ⊆
        shrinkageTheorem1PaperTailEvent X SigmaInv estimator paperBias lam t) :
    ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      trueError estimatedError t bias tailRHS :=
  shrinkageTheorem1TailStatement_of_paperRHSFinalBridgeObligations
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
    leaveOneOutParams denominatorParams trueError estimatedError bias
    (shrinkageTheorem1PaperRHSFinalBridgeObligations_of_eventSubset
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams trueError estimatedError bias h event_subset)

/--
Bundled final tail-statement consumer for the paper-RHS readiness route when
the remaining final-event subset obligation and final tail-event measurability
are supplied separately.

This is pure packaging around the existing event-subset tail consumer and the
generic tail/measurability bundle.  It proves no probability estimate,
concentration bound, deterministic comparison, subset lemma, or primitive
measurability result.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_eventSubset
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (event_subset :
      shrinkageTheorem1TailEvent trueError estimatedError bias t ⊆
        shrinkageTheorem1PaperTailEvent X SigmaInv estimator paperBias lam t)
    (hMeas :
      ShrinkageTheorem1FinalTailMeasurabilityProvider
        trueError estimatedError bias t) :
    ShrinkageTheorem1TailWithMeasurabilityStatement
      P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_finalMeasurability
    P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS
    (shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_eventSubset
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams trueError estimatedError bias h event_subset)
    hMeas

/--
Variant of the event-subset bundled consumer that constructs the final-tail
measurability provider from measurable abstract error functions.

This remains a deterministic/API wrapper and does not prove probability,
concentration, subset, or primitive measurability facts.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_eventSubset_error_measurable
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (event_subset :
      shrinkageTheorem1TailEvent trueError estimatedError bias t ⊆
        shrinkageTheorem1PaperTailEvent X SigmaInv estimator paperBias lam t)
    (hTrue : Measurable trueError) (hEstimated : Measurable estimatedError) :
    ShrinkageTheorem1TailWithMeasurabilityStatement
      P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_eventSubset
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
    leaveOneOutParams denominatorParams trueError estimatedError bias h event_subset
    (shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable
      trueError estimatedError bias t hTrue hEstimated)

/--
Statement-based direct final tail-statement consumer for the paper-RHS readiness
route.

The only remaining theorem-specific proof input is the named
`ShrinkageTheorem1FinalEventSubsetStatement`.
-/
theorem shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetStatement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (event_subset :
      ShrinkageTheorem1FinalEventSubsetStatement
        X SigmaInv estimator paperBias lam trueError estimatedError bias t) :
    ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      trueError estimatedError t bias tailRHS :=
  shrinkageTheorem1TailStatement_of_paperRHSFinalBridgeObligations
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
    leaveOneOutParams denominatorParams trueError estimatedError bias
    (shrinkageTheorem1PaperRHSFinalBridgeObligations_of_finalEventSubsetStatement
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams trueError estimatedError bias h event_subset)

/--
Direct final tail-statement consumer for the lower-event/from-H1 paper-RHS
readiness route and the named final-event subset target.

This is a thin composition wrapper: it constructs the existing paper-RHS
proof-readiness ledger from the paper-tail H1 provider and lower singular-value
event provider, then feeds that ledger to the final-event subset consumer.  The
paper-RHS component tail bounds remain explicit assumptions, and no probability,
concentration, deterministic-equivalent estimate, or Theorem 1 proof is added.
-/
theorem shrinkageTheorem1TailStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_finalEventSubsetStatement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator paperBias t paperTailRHS lambdaMinSigma tailRHS)
    (lambdaPositive : 0 < lam)
    (thresholdNonnegative : 0 <= t)
    (paperTailBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator paperBias lam t) <=
        ENNReal.ofReal tailRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hDenominatorPrefactor : 0 <= denominatorParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam))
    (hDenominatorBounds :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam))
    (event_subset :
      ShrinkageTheorem1FinalEventSubsetStatement
        X SigmaInv estimator paperBias lam trueError estimatedError bias t) :
    ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      trueError estimatedError t bias tailRHS :=
  shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetStatement
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
    leaveOneOutParams denominatorParams trueError estimatedError bias
    (shrinkageTheorem1PaperRHSProofReadinessObligations_of_lowerEventProvider
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams providers lambdaPositive
      thresholdNonnegative paperTailBound lowerRHS_nonnegative hLower
      hShrinkagePrefactor hLeaveOneOutPrefactor hDenominatorPrefactor
      hShrinkageBound hLeaveOneOutBounds hDenominatorBounds)
    event_subset

/--
Bundled final tail-statement consumer from the paper-RHS proof-readiness ledger,
the named final-event subset target, and final tail-event measurability.

This is pure packaging around the existing tail-statement consumer and the
final-tail/measurability bundle.  It proves no new probability estimate,
concentration bound, deterministic-equivalent estimate, or primitive
measurability result.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetStatement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (event_subset :
      ShrinkageTheorem1FinalEventSubsetStatement
        X SigmaInv estimator paperBias lam trueError estimatedError bias t)
    (hMeas :
      ShrinkageTheorem1FinalTailMeasurabilityProvider
        trueError estimatedError bias t) :
    ShrinkageTheorem1TailWithMeasurabilityStatement
      P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_finalMeasurability
    P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS
    (shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetStatement
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams trueError estimatedError bias h event_subset)
    hMeas

/--
Bundled final tail-statement consumer for the lower-event/from-H1 paper-RHS
readiness route, the named final-event subset target, and final tail-event
measurability.

This is pure composition around the direct from-H1 tail-statement wrapper and
the existing final-tail/measurability bundle.  It keeps all paper-RHS component
tail bounds explicit and proves no probability, concentration,
deterministic-equivalent estimate, primitive measurability result, or Theorem 1.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_finalEventSubsetStatement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator paperBias t paperTailRHS lambdaMinSigma tailRHS)
    (lambdaPositive : 0 < lam)
    (thresholdNonnegative : 0 <= t)
    (paperTailBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator paperBias lam t) <=
        ENNReal.ofReal tailRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hDenominatorPrefactor : 0 <= denominatorParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam))
    (hDenominatorBounds :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam))
    (event_subset :
      ShrinkageTheorem1FinalEventSubsetStatement
        X SigmaInv estimator paperBias lam trueError estimatedError bias t)
    (hMeas :
      ShrinkageTheorem1FinalTailMeasurabilityProvider
        trueError estimatedError bias t) :
    ShrinkageTheorem1TailWithMeasurabilityStatement
      P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_finalMeasurability
    P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS
    (shrinkageTheorem1TailStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_finalEventSubsetStatement
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams trueError estimatedError bias
      providers lambdaPositive thresholdNonnegative paperTailBound
      lowerRHS_nonnegative hLower hShrinkagePrefactor hLeaveOneOutPrefactor
      hDenominatorPrefactor hShrinkageBound hLeaveOneOutBounds
      hDenominatorBounds event_subset)
    hMeas

/--
Bundled final tail-statement consumer when the abstract true and estimated
error functions are already measurable.

This only feeds the elementary final-tail measurability constructor into the
bundled proof-readiness consumer; it does not identify the errors with paper
quantities or prove a probability/concentration estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetStatement_error_measurable
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (event_subset :
      ShrinkageTheorem1FinalEventSubsetStatement
        X SigmaInv estimator paperBias lam trueError estimatedError bias t)
    (hTrue : Measurable trueError) (hEstimated : Measurable estimatedError) :
    ShrinkageTheorem1TailWithMeasurabilityStatement
      P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetStatement
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
    leaveOneOutParams denominatorParams trueError estimatedError bias h event_subset
    (shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable
      trueError estimatedError bias t hTrue hEstimated)

/--
Bundled from-H1 final tail-statement consumer when the abstract true and
estimated error functions are already measurable.

This only feeds the elementary final-tail measurability constructor into the
from-H1 bundled consumer; it does not identify the errors with paper quantities
or prove a probability/concentration estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_finalEventSubsetStatement_error_measurable
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator paperBias t paperTailRHS lambdaMinSigma tailRHS)
    (lambdaPositive : 0 < lam)
    (thresholdNonnegative : 0 <= t)
    (paperTailBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator paperBias lam t) <=
        ENNReal.ofReal tailRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hDenominatorPrefactor : 0 <= denominatorParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam))
    (hDenominatorBounds :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam))
    (event_subset :
      ShrinkageTheorem1FinalEventSubsetStatement
        X SigmaInv estimator paperBias lam trueError estimatedError bias t)
    (hTrue : Measurable trueError) (hEstimated : Measurable estimatedError) :
    ShrinkageTheorem1TailWithMeasurabilityStatement
      P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_finalEventSubsetStatement
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
    leaveOneOutParams denominatorParams trueError estimatedError bias
    providers lambdaPositive thresholdNonnegative paperTailBound
    lowerRHS_nonnegative hLower hShrinkagePrefactor hLeaveOneOutPrefactor
    hDenominatorPrefactor hShrinkageBound hLeaveOneOutBounds
    hDenominatorBounds event_subset
    (shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable
      trueError estimatedError bias t hTrue hEstimated)

/--
Direct final tail-statement consumer from pointwise deterministic comparison
fields.

This composes the comparison provider with the named final-event subset target
and the existing statement-based paper-RHS readiness consumer.  It remains a
deterministic/event bridge and proves no component probability or concentration
estimate.
-/
theorem shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetComparisonProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (comparison :
      ShrinkageTheorem1FinalEventSubsetComparisonProvider
        X SigmaInv estimator paperBias lam trueError estimatedError bias) :
    ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      trueError estimatedError t bias tailRHS :=
  shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetStatement
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
    leaveOneOutParams denominatorParams trueError estimatedError bias h
    (shrinkageTheorem1FinalEventSubsetStatement_of_comparisonProvider
      X SigmaInv estimator paperBias lam trueError estimatedError bias t comparison)

/--
Bundled final tail-statement consumer from pointwise deterministic comparison
fields and final tail-event measurability.

This is only the measurability-aware packaging of
`shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetComparisonProvider`;
it proves no component probability, concentration, or primitive measurability
estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetComparisonProvider
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (comparison :
      ShrinkageTheorem1FinalEventSubsetComparisonProvider
        X SigmaInv estimator paperBias lam trueError estimatedError bias)
    (hMeas :
      ShrinkageTheorem1FinalTailMeasurabilityProvider
        trueError estimatedError bias t) :
    ShrinkageTheorem1TailWithMeasurabilityStatement
      P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_finalMeasurability
    P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS
    (shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetComparisonProvider
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams trueError estimatedError bias h comparison)
    hMeas

/--
Bundled comparison-provider consumer when the abstract true and estimated
error functions are already measurable.

This only constructs the final-tail measurability provider from the two
measurable error functions and reuses the comparison-provider bridge; it proves
no probability or concentration estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetComparisonProvider_error_measurable
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (trueError estimatedError : Omega -> Real)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (comparison :
      ShrinkageTheorem1FinalEventSubsetComparisonProvider
        X SigmaInv estimator paperBias lam trueError estimatedError bias)
    (hTrue : Measurable trueError) (hEstimated : Measurable estimatedError) :
    ShrinkageTheorem1TailWithMeasurabilityStatement
      P X Z Sigma SigmaSqrt sigmaX eta lam trueError estimatedError t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetComparisonProvider
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
    leaveOneOutParams denominatorParams trueError estimatedError bias h comparison
    (shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable
      trueError estimatedError bias t hTrue hEstimated)

/--
Direct final tail-statement consumer for the random paper error vocabulary.

The true/estimated error comparison fields are definitional for the random
paper lifts, so this wrapper exposes the remaining deterministic obligation as
only a pointwise final-bias dominance provider.  It still consumes the existing
paper-RHS proof-readiness ledger and proves no new probability or concentration
estimate.
-/
theorem shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hBias : ShrinkageTheorem1FinalBiasDominanceProvider X paperBias lam bias) :
    ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_finalEventSubsetComparisonProvider
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
    leaveOneOutParams denominatorParams
    (randomPaperShrinkageError X SigmaInv lam)
    (randomPaperShrinkageEstimatedError X estimator lam) bias h
    (shrinkageTheorem1FinalEventSubsetComparisonProvider_of_randomPaperErrors
      X SigmaInv estimator paperBias lam bias hBias)

/--
Bundled final tail-statement consumer for the random paper error vocabulary.

This packages the existing random-paper-error tail-statement consumer with an
explicit final tail-event measurability provider.  It proves no primitive
measurability, probability, or concentration estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hBias : ShrinkageTheorem1FinalBiasDominanceProvider X paperBias lam bias)
    (hMeas :
      ShrinkageTheorem1FinalTailMeasurabilityProvider
        (randomPaperShrinkageError X SigmaInv lam)
        (randomPaperShrinkageEstimatedError X estimator lam) bias t) :
    ShrinkageTheorem1TailWithMeasurabilityStatement P X Z Sigma SigmaSqrt
      sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_finalMeasurability
    P X Z Sigma SigmaSqrt sigmaX eta lam
    (randomPaperShrinkageError X SigmaInv lam)
    (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS
    (shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams bias h hBias)
    hMeas

/--
Bundled random-paper-error consumer when the paper true and estimated error
functions are already measurable.

This only constructs the final-tail measurability provider from the two
measurable random-paper error functions and reuses the random-paper-error
tail-statement consumer.  It proves no probability or concentration estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors_error_measurable
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hBias : ShrinkageTheorem1FinalBiasDominanceProvider X paperBias lam bias)
    (hTrue : Measurable (randomPaperShrinkageError X SigmaInv lam))
    (hEstimated : Measurable (randomPaperShrinkageEstimatedError X estimator lam)) :
    ShrinkageTheorem1TailWithMeasurabilityStatement P X Z Sigma SigmaSqrt
      sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
    leaveOneOutParams denominatorParams bias h hBias
    (shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) bias t hTrue hEstimated)

/--
Direct random-paper-error tail-statement consumer from H1 plus explicit paper
RHS component bounds.

This is pure packaging: it first constructs the paper-RHS proof-readiness
ledger from the paper-tail H1 provider, lower singular-value provider, and
component RHS bounds, then feeds that ledger to the random-paper-error
consumer.  It proves no lower singular-value estimate, resolvent probability,
component concentration bound, primitive measurability result, or Theorem 1.
-/
theorem shrinkageTheorem1TailStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_randomPaperErrors
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (bias : ShrinkageTheorem1BiasTerm)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator paperBias t paperTailRHS lambdaMinSigma tailRHS)
    (lambdaPositive : 0 < lam)
    (thresholdNonnegative : 0 <= t)
    (paperTailBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator paperBias lam t) <=
        ENNReal.ofReal tailRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hDenominatorPrefactor : 0 <= denominatorParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam))
    (hDenominatorBounds :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam))
    (hBias : ShrinkageTheorem1FinalBiasDominanceProvider X paperBias lam bias) :
    ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
    leaveOneOutParams denominatorParams bias
    (shrinkageTheorem1PaperRHSProofReadinessObligations_of_lowerEventProvider
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams providers lambdaPositive
      thresholdNonnegative paperTailBound lowerRHS_nonnegative hLower
      hShrinkagePrefactor hLeaveOneOutPrefactor hDenominatorPrefactor
      hShrinkageBound hLeaveOneOutBounds hDenominatorBounds)
    hBias

/--
Measurability-aware random-paper-error consumer from H1 plus explicit paper RHS
component bounds.

This only combines the from-H1 tail-statement wrapper with an already supplied
final tail-event measurability provider.  It proves no primitive measurability
or probability/concentration estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_randomPaperErrors
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (bias : ShrinkageTheorem1BiasTerm)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator paperBias t paperTailRHS lambdaMinSigma tailRHS)
    (lambdaPositive : 0 < lam)
    (thresholdNonnegative : 0 <= t)
    (paperTailBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator paperBias lam t) <=
        ENNReal.ofReal tailRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hDenominatorPrefactor : 0 <= denominatorParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam))
    (hDenominatorBounds :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam))
    (hBias : ShrinkageTheorem1FinalBiasDominanceProvider X paperBias lam bias)
    (hMeas :
      ShrinkageTheorem1FinalTailMeasurabilityProvider
        (randomPaperShrinkageError X SigmaInv lam)
        (randomPaperShrinkageEstimatedError X estimator lam) bias t) :
    ShrinkageTheorem1TailWithMeasurabilityStatement P X Z Sigma SigmaSqrt
      sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_finalMeasurability
    P X Z Sigma SigmaSqrt sigmaX eta lam
    (randomPaperShrinkageError X SigmaInv lam)
    (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS
    (shrinkageTheorem1TailStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_randomPaperErrors
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams bias providers lambdaPositive
      thresholdNonnegative paperTailBound lowerRHS_nonnegative hLower
      hShrinkagePrefactor hLeaveOneOutPrefactor hDenominatorPrefactor
      hShrinkageBound hLeaveOneOutBounds hDenominatorBounds hBias)
    hMeas

/--
Measurability-aware random-paper-error consumer from H1 when the concrete paper
error functions are already measurable.

This only constructs the final-tail measurability provider from explicit
measurability assumptions and reuses the from-H1 random-paper-error wrapper.
It proves no primitive measurability or probability/concentration estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_randomPaperErrors_error_measurable
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (bias : ShrinkageTheorem1BiasTerm)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator paperBias t paperTailRHS lambdaMinSigma tailRHS)
    (lambdaPositive : 0 < lam)
    (thresholdNonnegative : 0 <= t)
    (paperTailBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator paperBias lam t) <=
        ENNReal.ofReal tailRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hDenominatorPrefactor : 0 <= denominatorParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam))
    (hDenominatorBounds :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam))
    (hBias : ShrinkageTheorem1FinalBiasDominanceProvider X paperBias lam bias)
    (hTrue : Measurable (randomPaperShrinkageError X SigmaInv lam))
    (hEstimated : Measurable (randomPaperShrinkageEstimatedError X estimator lam)) :
    ShrinkageTheorem1TailWithMeasurabilityStatement P X Z Sigma SigmaSqrt
      sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_randomPaperErrors
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
    leaveOneOutParams denominatorParams bias providers lambdaPositive
    thresholdNonnegative paperTailBound lowerRHS_nonnegative hLower
    hShrinkagePrefactor hLeaveOneOutPrefactor hDenominatorPrefactor
    hShrinkageBound hLeaveOneOutBounds hDenominatorBounds hBias
    (shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) bias t hTrue hEstimated)

/--
Direct final tail-statement consumer from the typed final-bias dominance
statement.

This is the fully statement-shaped random-paper-error entry point: the paper
error and estimated-error equalities are definitional, and the only remaining
deterministic comparison assumption is the pointwise random-paper-bias bound.
-/
theorem shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors_biasStatement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hBias :
      ShrinkageTheorem1FinalBiasDominanceStatement X paperBias lam bias) :
    ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
    leaveOneOutParams denominatorParams bias h
    (shrinkageTheorem1FinalBiasDominanceProvider_of_statement
      X paperBias lam bias hBias)

/--
Bundled final tail-statement consumer from the typed final-bias dominance
statement.

This packages the statement-shaped random-paper-error tail consumer with an
explicit final tail-event measurability provider.  It proves no primitive
measurability, probability, concentration, or bias upper-bound estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors_biasStatement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hBias :
      ShrinkageTheorem1FinalBiasDominanceStatement X paperBias lam bias)
    (hMeas :
      ShrinkageTheorem1FinalTailMeasurabilityProvider
        (randomPaperShrinkageError X SigmaInv lam)
        (randomPaperShrinkageEstimatedError X estimator lam) bias t) :
    ShrinkageTheorem1TailWithMeasurabilityStatement P X Z Sigma SigmaSqrt
      sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_finalMeasurability
    P X Z Sigma SigmaSqrt sigmaX eta lam
    (randomPaperShrinkageError X SigmaInv lam)
    (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS
    (shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors_biasStatement
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams bias h hBias)
    hMeas

/--
Bundled statement-shaped random-paper-error consumer when the random-paper
error functions are already measurable.

This only builds the final-tail measurability provider from the two measurable
random-paper error functions and reuses the statement-shaped tail consumer.  It
proves no probability, concentration, or bias upper-bound estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors_biasStatement_error_measurable
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (paperBias : PaperShrinkageBias d n)
    (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hBias :
      ShrinkageTheorem1FinalBiasDominanceStatement X paperBias lam bias)
    (hTrue : Measurable (randomPaperShrinkageError X SigmaInv lam))
    (hEstimated : Measurable (randomPaperShrinkageEstimatedError X estimator lam)) :
    ShrinkageTheorem1TailWithMeasurabilityStatement P X Z Sigma SigmaSqrt
      sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors_biasStatement
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator paperBias t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
    leaveOneOutParams denominatorParams bias h hBias
    (shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) bias t hTrue hEstimated)

/--
Direct final tail-statement consumer for an additive paper-bias slot.

This is a deterministic composition layer: the paper-RHS proof-readiness ledger
still supplies the paper-tail probability bound, while the two scalar component
bias upper-bound providers and `(boundLeft + boundRight) <= bias` discharge the
final random-paper-bias dominance obligation.
-/
theorem shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_addPaperBiasUpperBounds
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (boundLeft boundRight bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
        (addPaperShrinkageBias biasLeft biasRight) t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hLeft : PaperShrinkageBiasUpperBoundProvider X biasLeft lam boundLeft)
    (hRight : PaperShrinkageBiasUpperBoundProvider X biasRight lam boundRight)
    (hBias : boundLeft + boundRight <= bias) :
    ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
    (addPaperShrinkageBias biasLeft biasRight) t lowerRHS paperTailRHS
    lambdaMinSigma tailRHS shrinkageParams leaveOneOutParams denominatorParams bias h
    (shrinkageTheorem1FinalBiasDominanceProvider_of_addPaperBiasUpperBounds
      X biasLeft biasRight lam boundLeft boundRight bias hLeft hRight hBias)

/--
Bundled final tail-statement consumer for additive paper-bias upper bounds.

This only combines the already prepared additive-bias tail-statement consumer
with an explicit final tail-event measurability provider.  It proves no
primitive measurability, probability, concentration, or component upper-bound
estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_addPaperBiasUpperBounds
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (boundLeft boundRight bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
        (addPaperShrinkageBias biasLeft biasRight) t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hLeft : PaperShrinkageBiasUpperBoundProvider X biasLeft lam boundLeft)
    (hRight : PaperShrinkageBiasUpperBoundProvider X biasRight lam boundRight)
    (hBias : boundLeft + boundRight <= bias)
    (hMeas :
      ShrinkageTheorem1FinalTailMeasurabilityProvider
        (randomPaperShrinkageError X SigmaInv lam)
        (randomPaperShrinkageEstimatedError X estimator lam) bias t) :
    ShrinkageTheorem1TailWithMeasurabilityStatement P X Z Sigma SigmaSqrt
      sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_finalMeasurability
    P X Z Sigma SigmaSqrt sigmaX eta lam
    (randomPaperShrinkageError X SigmaInv lam)
    (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS
    (shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_addPaperBiasUpperBounds
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator biasLeft biasRight t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams boundLeft boundRight bias h hLeft hRight hBias)
    hMeas

/--
Bundled additive-bias consumer when the random-paper error functions are
already measurable.

This only builds the final-tail measurability provider from the two measurable
random-paper error functions and reuses the additive-bias tail-statement
consumer.  It proves no probability, concentration, or component upper-bound
estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_addPaperBiasUpperBounds_error_measurable
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (biasLeft biasRight : PaperShrinkageBias d n) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (boundLeft boundRight bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
        (addPaperShrinkageBias biasLeft biasRight) t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hLeft : PaperShrinkageBiasUpperBoundProvider X biasLeft lam boundLeft)
    (hRight : PaperShrinkageBiasUpperBoundProvider X biasRight lam boundRight)
    (hBias : boundLeft + boundRight <= bias)
    (hTrue : Measurable (randomPaperShrinkageError X SigmaInv lam))
    (hEstimated : Measurable (randomPaperShrinkageEstimatedError X estimator lam)) :
    ShrinkageTheorem1TailWithMeasurabilityStatement P X Z Sigma SigmaSqrt
      sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_addPaperBiasUpperBounds
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator biasLeft biasRight t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
    leaveOneOutParams denominatorParams boundLeft boundRight bias h hLeft hRight hBias
    (shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) bias t hTrue hEstimated)

/--
Final tail-statement consumer for the variance-plus-exponential partial
paper-bias envelope.

The paper-RHS proof-readiness ledger still supplies all event, measurability,
and paper-tail probability inputs.  This wrapper only discharges the final
random-paper-bias dominance obligation from the named deterministic scalar
comparison
`paperTheorem1VariancePlusExponentialBiasComponent d n lam C2 cX <= bias`.
-/
theorem shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1VariancePlusExponentialBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (C2 cX : Real) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
        (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX) t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hBias :
      paperTheorem1VariancePlusExponentialBiasComponent d n lam C2 cX <= bias) :
    ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
    (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX) t lowerRHS paperTailRHS
    lambdaMinSigma tailRHS shrinkageParams leaveOneOutParams denominatorParams bias h
    (shrinkageTheorem1FinalBiasDominanceProvider_of_paperTheorem1VariancePlusExponentialBiasComponent
      X lam C2 cX bias hBias)

/--
Bundled final tail-statement consumer for the variance-plus-exponential partial
paper-bias envelope.

This packages the existing tail-statement consumer with an explicit final
tail-event measurability provider.  It proves no primitive measurability,
probability, concentration, or component upper-bound estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1VariancePlusExponentialBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (C2 cX : Real) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
        (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX) t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hBias :
      paperTheorem1VariancePlusExponentialBiasComponent d n lam C2 cX <= bias)
    (hMeas :
      ShrinkageTheorem1FinalTailMeasurabilityProvider
        (randomPaperShrinkageError X SigmaInv lam)
        (randomPaperShrinkageEstimatedError X estimator lam) bias t) :
    ShrinkageTheorem1TailWithMeasurabilityStatement P X Z Sigma SigmaSqrt
      sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_finalMeasurability
    P X Z Sigma SigmaSqrt sigmaX eta lam
    (randomPaperShrinkageError X SigmaInv lam)
    (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS
    (shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1VariancePlusExponentialBiasComponent
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator C2 cX t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams bias h hBias)
    hMeas

/--
Bundled variance-plus-exponential consumer when the random-paper error
functions are already measurable.

This only builds the final-tail measurability provider from the two measurable
random-paper error functions and reuses the variance-plus-exponential
tail-statement consumer.  It proves no probability, concentration, or component
upper-bound estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1VariancePlusExponentialBiasComponent_error_measurable
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n) (C2 cX : Real) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
        (paperTheorem1VariancePlusExponentialPaperBias d n C2 cX) t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hBias :
      paperTheorem1VariancePlusExponentialBiasComponent d n lam C2 cX <= bias)
    (hTrue : Measurable (randomPaperShrinkageError X SigmaInv lam))
    (hEstimated : Measurable (randomPaperShrinkageEstimatedError X estimator lam)) :
    ShrinkageTheorem1TailWithMeasurabilityStatement P X Z Sigma SigmaSqrt
      sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1VariancePlusExponentialBiasComponent
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator C2 cX t
    lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
    leaveOneOutParams denominatorParams bias h hBias
    (shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) bias t hTrue hEstimated)

/--
Theorem-facing tail-statement wrapper for the displayed three-term
`Delta_X(lambda)` paper-bias slot.

The paper-RHS proof-readiness ledger still supplies all event, measurability,
and paper-tail probability inputs.  This wrapper only discharges the final
random-paper-bias dominance obligation from the named deterministic scalar
comparison
`paperTheorem1DeltaBiasComponent ... <= bias`.
-/
theorem shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (C1 sigmaOp C2 cX : Real) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
        (paperTheorem1DeltaPaperBias
          d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hBias :
      paperTheorem1DeltaBiasComponent
        d n lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX <= bias) :
    ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
    (paperTheorem1DeltaPaperBias
      d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) t lowerRHS paperTailRHS
    lambdaMinSigma tailRHS shrinkageParams leaveOneOutParams denominatorParams bias h
    (shrinkageTheorem1FinalBiasDominanceProvider_of_paperTheorem1DeltaBiasComponent
      X lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX bias hBias)

/--
Final tail-statement consumer for the displayed `Delta_X(lambda)` paper-bias
slot from separately supplied component upper-bound comparisons.

The paper-RHS proof-readiness ledger still supplies all event, measurability,
and paper-tail probability inputs.  This wrapper only routes the three scalar
component comparisons through the existing `Delta_X(lambda)` upper-bound
consumer to discharge final random-paper-bias dominance; it proves no component
upper bound, probability estimate, concentration input, or Theorem 1.
-/
theorem shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponents
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (C1 sigmaOp C2 cX : Real) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (detBound varianceBound exponentialBound bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
        (paperTheorem1DeltaPaperBias
          d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hDet :
      paperTheorem1DeterministicEquivalentBiasComponent
        d n C1 sigmaX sigmaOp lambdaMinSigma eta <= detBound)
    (hVariance : paperTheorem1VarianceBiasComponent d n lam <= varianceBound)
    (hExponential : paperTheorem1ExponentialBiasComponent n C2 cX <= exponentialBound)
    (hSum : detBound + (varianceBound + exponentialBound) <= bias) :
    ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_randomPaperErrors
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
    (paperTheorem1DeltaPaperBias
      d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) t lowerRHS paperTailRHS
    lambdaMinSigma tailRHS shrinkageParams leaveOneOutParams denominatorParams bias h
    (shrinkageTheorem1FinalBiasDominanceProvider_of_biasUpperBoundProvider
      X
      (paperTheorem1DeltaPaperBias
        d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX)
      lam bias bias
      (paperShrinkageBiasUpperBoundProvider_of_paperTheorem1DeltaBiasComponents
        X lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX
        detBound varianceBound exponentialBound bias hDet hVariance hExponential hSum)
      le_rfl)


/--
Bundled final tail-statement consumer for the displayed `Delta_X(lambda)`
paper-bias slot.

This packages the existing one-shot `Delta_X(lambda)` tail-statement consumer
with an explicit final tail-event measurability provider.  It proves no
primitive measurability, probability, concentration, or component upper-bound
estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponent
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (C1 sigmaOp C2 cX : Real) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
        (paperTheorem1DeltaPaperBias
          d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hBias :
      paperTheorem1DeltaBiasComponent
        d n lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX <= bias)
    (hMeas :
      ShrinkageTheorem1FinalTailMeasurabilityProvider
        (randomPaperShrinkageError X SigmaInv lam)
        (randomPaperShrinkageEstimatedError X estimator lam) bias t) :
    ShrinkageTheorem1TailWithMeasurabilityStatement P X Z Sigma SigmaSqrt
      sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_finalMeasurability
    P X Z Sigma SigmaSqrt sigmaX eta lam
    (randomPaperShrinkageError X SigmaInv lam)
    (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS
    (shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponent
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
      C1 sigmaOp C2 cX t lowerRHS paperTailRHS lambdaMinSigma tailRHS
      shrinkageParams leaveOneOutParams denominatorParams bias h hBias)
    hMeas

/--
Bundled `Delta_X(lambda)` one-shot consumer when the random-paper error
functions are already measurable.

This only builds the final-tail measurability provider from the two measurable
random-paper error functions and reuses the one-shot `Delta_X(lambda)`
tail-statement consumer.  It proves no probability, concentration, or component
upper-bound estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponent_error_measurable
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (C1 sigmaOp C2 cX : Real) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
        (paperTheorem1DeltaPaperBias
          d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hBias :
      paperTheorem1DeltaBiasComponent
        d n lam C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX <= bias)
    (hTrue : Measurable (randomPaperShrinkageError X SigmaInv lam))
    (hEstimated : Measurable (randomPaperShrinkageEstimatedError X estimator lam)) :
    ShrinkageTheorem1TailWithMeasurabilityStatement P X Z Sigma SigmaSqrt
      sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponent
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
    C1 sigmaOp C2 cX t lowerRHS paperTailRHS lambdaMinSigma tailRHS
    shrinkageParams leaveOneOutParams denominatorParams bias h hBias
    (shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) bias t hTrue hEstimated)

/--
Bundled final tail-statement consumer for the displayed `Delta_X(lambda)` route
from separately supplied component upper-bound comparisons.

This packages the existing componentwise `Delta_X(lambda)` tail-statement
consumer with an explicit final tail-event measurability provider.  It proves
no primitive measurability, probability, concentration, or component
upper-bound estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponents
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (C1 sigmaOp C2 cX : Real) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (detBound varianceBound exponentialBound bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
        (paperTheorem1DeltaPaperBias
          d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hDet :
      paperTheorem1DeterministicEquivalentBiasComponent
        d n C1 sigmaX sigmaOp lambdaMinSigma eta <= detBound)
    (hVariance : paperTheorem1VarianceBiasComponent d n lam <= varianceBound)
    (hExponential : paperTheorem1ExponentialBiasComponent n C2 cX <= exponentialBound)
    (hSum : detBound + (varianceBound + exponentialBound) <= bias)
    (hMeas :
      ShrinkageTheorem1FinalTailMeasurabilityProvider
        (randomPaperShrinkageError X SigmaInv lam)
        (randomPaperShrinkageEstimatedError X estimator lam) bias t) :
    ShrinkageTheorem1TailWithMeasurabilityStatement P X Z Sigma SigmaSqrt
      sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_finalMeasurability
    P X Z Sigma SigmaSqrt sigmaX eta lam
    (randomPaperShrinkageError X SigmaInv lam)
    (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS
    (shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponents
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
      C1 sigmaOp C2 cX t lowerRHS paperTailRHS lambdaMinSigma tailRHS
      shrinkageParams leaveOneOutParams denominatorParams
      detBound varianceBound exponentialBound bias h hDet hVariance hExponential hSum)
    hMeas

/--
Bundled componentwise `Delta_X(lambda)` consumer when the random-paper error
functions are already measurable.

This only builds the final-tail measurability provider from the two measurable
random-paper error functions and reuses the componentwise `Delta_X(lambda)`
tail-statement consumer.  It proves no probability, concentration, or component
upper-bound estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponents_error_measurable
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (C1 sigmaOp C2 cX : Real) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (detBound varianceBound exponentialBound bias : ShrinkageTheorem1BiasTerm)
    (h :
      ShrinkageTheorem1PaperRHSProofReadinessObligations
        P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
        (paperTheorem1DeltaPaperBias
          d n C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) t
        lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
        leaveOneOutParams denominatorParams)
    (hDet :
      paperTheorem1DeterministicEquivalentBiasComponent
        d n C1 sigmaX sigmaOp lambdaMinSigma eta <= detBound)
    (hVariance : paperTheorem1VarianceBiasComponent d n lam <= varianceBound)
    (hExponential : paperTheorem1ExponentialBiasComponent n C2 cX <= exponentialBound)
    (hSum : detBound + (varianceBound + exponentialBound) <= bias)
    (hTrue : Measurable (randomPaperShrinkageError X SigmaInv lam))
    (hEstimated : Measurable (randomPaperShrinkageEstimatedError X estimator lam)) :
    ShrinkageTheorem1TailWithMeasurabilityStatement P X Z Sigma SigmaSqrt
      sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponents
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
    C1 sigmaOp C2 cX t lowerRHS paperTailRHS lambdaMinSigma tailRHS
    shrinkageParams leaveOneOutParams denominatorParams
    detBound varianceBound exponentialBound bias h hDet hVariance hExponential hSum
    (shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) bias t hTrue hEstimated)

/--
Direct componentwise `Delta_X(lambda)` final tail-statement consumer from H1
plus explicit paper RHS component bounds.

This constructs the paper-RHS proof-readiness ledger internally from the
paper-tail H1 provider, lower singular-value provider, and supplied component
RHS bounds, then reuses the existing componentwise `Delta_X(lambda)` consumer.
It proves no lower singular-value estimate, resolvent probability, component
concentration bound, bias component upper bound, primitive measurability result,
or Theorem 1.
-/
theorem shrinkageTheorem1TailStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_paperTheorem1DeltaBiasComponents
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (C1 sigmaOp C2 cX : Real) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (detBound varianceBound exponentialBound bias : ShrinkageTheorem1BiasTerm)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator
        (paperTheorem1DeltaPaperBias d n
          C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) t paperTailRHS
        lambdaMinSigma tailRHS)
    (lambdaPositive : 0 < lam)
    (thresholdNonnegative : 0 <= t)
    (paperTailBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator
          (paperTheorem1DeltaPaperBias d n
            C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) lam t) <=
        ENNReal.ofReal tailRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hDenominatorPrefactor : 0 <= denominatorParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam))
    (hDenominatorBounds :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam))
    (hDet :
      paperTheorem1DeterministicEquivalentBiasComponent
        d n C1 sigmaX sigmaOp lambdaMinSigma eta <= detBound)
    (hVariance : paperTheorem1VarianceBiasComponent d n lam <= varianceBound)
    (hExponential : paperTheorem1ExponentialBiasComponent n C2 cX <= exponentialBound)
    (hSum : detBound + (varianceBound + exponentialBound) <= bias) :
    ShrinkageTheorem1TailStatement P X Z Sigma SigmaSqrt sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailStatement_of_paperRHSProofReadinessObligations_and_paperTheorem1DeltaBiasComponents
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
    C1 sigmaOp C2 cX t lowerRHS paperTailRHS lambdaMinSigma tailRHS
    shrinkageParams leaveOneOutParams denominatorParams
    detBound varianceBound exponentialBound bias
    (shrinkageTheorem1PaperRHSProofReadinessObligations_of_lowerEventProvider
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
      (paperTheorem1DeltaPaperBias d n
        C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) t
      lowerRHS paperTailRHS lambdaMinSigma tailRHS shrinkageParams
      leaveOneOutParams denominatorParams providers lambdaPositive
      thresholdNonnegative paperTailBound lowerRHS_nonnegative hLower
      hShrinkagePrefactor hLeaveOneOutPrefactor hDenominatorPrefactor
      hShrinkageBound hLeaveOneOutBounds hDenominatorBounds)
    hDet hVariance hExponential hSum

/--
Measurability-aware componentwise `Delta_X(lambda)` consumer from H1 plus
explicit paper RHS component bounds.

This only combines the direct from-H1 componentwise tail statement with an
already supplied final tail-event measurability provider.  It proves no
primitive measurability or probability/concentration estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_paperTheorem1DeltaBiasComponents
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (C1 sigmaOp C2 cX : Real) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (detBound varianceBound exponentialBound bias : ShrinkageTheorem1BiasTerm)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator
        (paperTheorem1DeltaPaperBias d n
          C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) t paperTailRHS
        lambdaMinSigma tailRHS)
    (lambdaPositive : 0 < lam)
    (thresholdNonnegative : 0 <= t)
    (paperTailBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator
          (paperTheorem1DeltaPaperBias d n
            C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) lam t) <=
        ENNReal.ofReal tailRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hDenominatorPrefactor : 0 <= denominatorParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam))
    (hDenominatorBounds :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam))
    (hDet :
      paperTheorem1DeterministicEquivalentBiasComponent
        d n C1 sigmaX sigmaOp lambdaMinSigma eta <= detBound)
    (hVariance : paperTheorem1VarianceBiasComponent d n lam <= varianceBound)
    (hExponential : paperTheorem1ExponentialBiasComponent n C2 cX <= exponentialBound)
    (hSum : detBound + (varianceBound + exponentialBound) <= bias)
    (hMeas :
      ShrinkageTheorem1FinalTailMeasurabilityProvider
        (randomPaperShrinkageError X SigmaInv lam)
        (randomPaperShrinkageEstimatedError X estimator lam) bias t) :
    ShrinkageTheorem1TailWithMeasurabilityStatement P X Z Sigma SigmaSqrt
      sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_tailStatement_and_finalMeasurability
    P X Z Sigma SigmaSqrt sigmaX eta lam
    (randomPaperShrinkageError X SigmaInv lam)
    (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS
    (shrinkageTheorem1TailStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_paperTheorem1DeltaBiasComponents
      P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
      C1 sigmaOp C2 cX t lowerRHS paperTailRHS lambdaMinSigma tailRHS
      shrinkageParams leaveOneOutParams denominatorParams
      detBound varianceBound exponentialBound bias providers lambdaPositive
      thresholdNonnegative paperTailBound lowerRHS_nonnegative hLower
      hShrinkagePrefactor hLeaveOneOutPrefactor hDenominatorPrefactor
      hShrinkageBound hLeaveOneOutBounds hDenominatorBounds
      hDet hVariance hExponential hSum)
    hMeas

/--
Measurability-aware componentwise `Delta_X(lambda)` consumer from H1 when the
random-paper error functions are already measurable.

This only constructs the final-tail measurability provider from explicit
measurability assumptions and reuses the from-H1 componentwise wrapper.  It
proves no primitive measurability or probability/concentration estimate.
-/
theorem shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_paperTheorem1DeltaBiasComponents_error_measurable
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega) {d n : Nat}
    (X Z : RandomDataMatrix Omega d n)
    (SigmaInv Sigma SigmaSqrt : SquareMatrix d) (sigmaX eta lam : Real)
    (estimator : PaperShrinkageEstimator d n)
    (C1 sigmaOp C2 cX : Real) (t : Real)
    (lowerRHS : PaperH2GoodEventProbabilityRHS)
    (paperTailRHS : PaperShrinkageTailRHS d n) (lambdaMinSigma : Real)
    (tailRHS : ShrinkageTheorem1TailRHS)
    (shrinkageParams : PaperH2ShrinkageShiftedDetTailPaperParameters)
    (leaveOneOutParams : PaperH2LeaveOneOutShiftedDetPointTailPaperParameters)
    (denominatorParams : PaperH2WoodburyDenominatorPointTailPaperParameters)
    (detBound varianceBound exponentialBound bias : ShrinkageTheorem1BiasTerm)
    (providers :
      ShrinkageTheorem1PaperTailProviders P X Z SigmaInv Sigma SigmaSqrt
        sigmaX eta lam estimator
        (paperTheorem1DeltaPaperBias d n
          C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) t paperTailRHS
        lambdaMinSigma tailRHS)
    (lambdaPositive : 0 < lam)
    (thresholdNonnegative : 0 <= t)
    (paperTailBound :
      P (shrinkageTheorem1PaperTailEvent X SigmaInv estimator
          (paperTheorem1DeltaPaperBias d n
            C1 sigmaX sigmaOp lambdaMinSigma eta C2 cX) lam t) <=
        ENNReal.ofReal tailRHS)
    (lowerRHS_nonnegative : 0 <= lowerRHS)
    (hLower : PaperH2LowerSingularValueEventProvider P X eta)
    (hShrinkagePrefactor : 0 <= shrinkageParams.prefactor)
    (hLeaveOneOutPrefactor : 0 <= leaveOneOutParams.prefactor)
    (hDenominatorPrefactor : 0 <= denominatorParams.prefactor)
    (hShrinkageBound :
      P (paperH2ShrinkageShiftedDetBadEvent X lam) <=
        ENNReal.ofReal
          (paperH2ShrinkageShiftedDetTailPaperRHS
            (d := d) (n := n) shrinkageParams lam))
    (hLeaveOneOutBounds :
      ∀ k : Fin n,
        P (paperH2LeaveOneOutShiftedDetBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2LeaveOneOutShiftedDetPointTailPaperRHS
              (d := d) (n := n) leaveOneOutParams lam))
    (hDenominatorBounds :
      ∀ k : Fin n,
        P (paperH2WoodburyDenominatorBadEvent X k lam) <=
          ENNReal.ofReal
            (paperH2WoodburyDenominatorPointTailPaperRHS
              (d := d) (n := n) denominatorParams lam))
    (hDet :
      paperTheorem1DeterministicEquivalentBiasComponent
        d n C1 sigmaX sigmaOp lambdaMinSigma eta <= detBound)
    (hVariance : paperTheorem1VarianceBiasComponent d n lam <= varianceBound)
    (hExponential : paperTheorem1ExponentialBiasComponent n C2 cX <= exponentialBound)
    (hSum : detBound + (varianceBound + exponentialBound) <= bias)
    (hTrue : Measurable (randomPaperShrinkageError X SigmaInv lam))
    (hEstimated : Measurable (randomPaperShrinkageEstimatedError X estimator lam)) :
    ShrinkageTheorem1TailWithMeasurabilityStatement P X Z Sigma SigmaSqrt
      sigmaX eta lam
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) t bias tailRHS :=
  shrinkageTheorem1TailWithMeasurabilityStatement_of_lowerEventProvider_and_resolventPaperRHSBounds_fromH1_and_paperTheorem1DeltaBiasComponents
    P X Z SigmaInv Sigma SigmaSqrt sigmaX eta lam estimator
    C1 sigmaOp C2 cX t lowerRHS paperTailRHS lambdaMinSigma tailRHS
    shrinkageParams leaveOneOutParams denominatorParams
    detBound varianceBound exponentialBound bias providers lambdaPositive
    thresholdNonnegative paperTailBound lowerRHS_nonnegative hLower
    hShrinkagePrefactor hLeaveOneOutPrefactor hDenominatorPrefactor
    hShrinkageBound hLeaveOneOutBounds hDenominatorBounds
    hDet hVariance hExponential hSum
    (shrinkageTheorem1FinalTailMeasurabilityProvider_of_error_measurable
      (randomPaperShrinkageError X SigmaInv lam)
      (randomPaperShrinkageEstimatedError X estimator lam) bias t hTrue hEstimated)

end

end PrecisionDA
end HighDimProb
