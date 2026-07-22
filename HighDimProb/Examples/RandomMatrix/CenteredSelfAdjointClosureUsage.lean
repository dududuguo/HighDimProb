import HighDimProb.RandomMatrix.VarianceProxy
import HighDimProb.RandomMatrix.Assumptions
import HighDimProb.RandomMatrix.Concentration

/-!
# Centered self-adjoint observation deviation and spectral sandwich

This examples-only file models a finite batch of random matrix observations
(e.g., Hessian approximations or kernel slices) under explicit self-adjointness
hypotheses, and proves
that the empirical-mean deviation from the population mean is a centered
self-adjoint random matrix whose operator norm controls a Loewner spectral
sandwich.

The pipeline demonstrates why centered self-adjoint closure is the *enabling
step* for downstream concentration:

1. Define the observation batch, empirical mean, and population mean.
2. Prove the deviation identity: empirical − population =
   `(1 / batch) Σ centeredᵢ`.
3. Prove the deviation is pointwise self-adjoint (from closure).
4. Prove each centered summand has zero expectation (from closure).
5. Prove the centered second-moment Loewner comparison.
6. Derive the Loewner spectral sandwich from operator-norm control.

Unlike the rank-one covariance examples, this file works with *general*
self-adjoint random matrices and does not assume rank-one structure.
The modelling layer keeps operator-norm control explicit for the deterministic
spectral sandwich; the final thin consumers separately invoke the shared
Matrix Bernstein observation endpoints under their full input bundle.

The algebraic definitions are total at `batch = 0`, where Lean's division
convention makes the normalized sums zero. Their statistical empirical-mean
interpretation, and the tail-rescaling theorem below, require `0 < batch`.
-/

namespace HighDimProb.Examples.RandomMatrix.CenteredSelfAdjointClosureUsage

open MeasureTheory
open scoped BigOperators Matrix.Norms.L2Operator MatrixOrder

noncomputable section

/-! ## Domain objects: self-adjoint observation model -/

/-- A finite batch of random matrix observations in dimension `n + 1`.
Self-adjointness is supplied explicitly by the theorems that require it. -/
abbrev ObservationBatch (Omega : Type*) [MeasurableSpace Omega]
    (batch n : Nat) :=
  Fin batch -> RandomMatrix Omega (n + 1) (n + 1)

/-- The empirical mean of a finite observation batch at a sample point. -/
def observationEmpiricalMean {Omega : Type*} [MeasurableSpace Omega]
    {batch n : Nat}
    (X : ObservationBatch Omega batch n) (omega : Omega) :
    Matrix (Fin (n + 1)) (Fin (n + 1)) Real :=
  (1 / (batch : Real)) •
    ∑ i : Fin batch, X i omega

/-- The population mean of a finite observation batch. -/
def observationPopulationMean {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {batch n : Nat}
    (X : ObservationBatch Omega batch n) :
    Matrix (Fin (n + 1)) (Fin (n + 1)) Real :=
  (1 / (batch : Real)) •
    ∑ i : Fin batch, matrixExpect P (X i)

/-- The centered observation summand family: `Xᵢ - E[Xᵢ]`. -/
def centeredObservationFamily {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {batch n : Nat}
    (X : ObservationBatch Omega batch n) :
    Fin batch -> RandomMatrix Omega (n + 1) (n + 1) :=
  centeredRandomMatrixFamily P X

/-- The normalized centered deviation: empirical mean minus population mean. -/
def observationDeviation {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {batch n : Nat}
    (X : ObservationBatch Omega batch n) :
    RandomMatrix Omega (n + 1) (n + 1) :=
  fun omega =>
    (1 / (batch : Real)) •
      randomMatrixSum (centeredObservationFamily (P := P) X) omega

/-! ## Structural identity: deviation = empirical − population -/

/-- The normalized centered deviation equals empirical mean minus population
mean. This is the key algebraic identity that connects the centered summand
representation to the statistical deviation. -/
theorem observationDeviation_eq_empirical_sub_population
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {batch n : Nat}
    (X : ObservationBatch Omega batch n)
    (omega : Omega) :
    observationDeviation (P := P) X omega =
      observationEmpiricalMean X omega -
        observationPopulationMean (P := P) X := by
  change
    (1 / (batch : Real)) •
        (∑ i, centeredRandomMatrixFamily P X i omega) =
      (1 / (batch : Real)) • (∑ i, X i omega) -
        (1 / (batch : Real)) • (∑ i, matrixExpect P (X i))
  rw [← smul_sub, ← Finset.sum_sub_distrib]
  congr 1

/-! ## Self-adjointness of the deviation (from closure) -/

/-- Each centered observation summand is pointwise self-adjoint, because
centering preserves self-adjointness. -/
theorem centeredObservation_selfAdjoint
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {batch n : Nat}
    (X : ObservationBatch Omega batch n)
    (hSA : SelfAdjointRandomMatrixFamily P X)
    (i : Fin batch) :
    RandomSelfAdjointMatrix P (centeredObservationFamily (P := P) X i) := by
  have hFamily :=
    selfAdjointRandomMatrixFamily_centeredRandomMatrixFamily
      (P := P) hSA
  exact hFamily.2 i

/-- The normalized deviation is pointwise self-adjoint. This follows because
a scalar multiple of a sum of self-adjoint matrices is self-adjoint. -/
theorem observationDeviation_selfAdjoint
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {batch n : Nat}
    (X : ObservationBatch Omega batch n)
    (hSA : SelfAdjointRandomMatrixFamily P X)
    (omega : Omega) :
    IsSelfAdjointMatrix (observationDeviation (P := P) X omega) := by
  apply isSelfAdjointMatrix_smul
  apply isSelfAdjointMatrix_sum
  intro i
  exact centeredObservation_selfAdjoint (P := P) X hSA i omega

/-! ## Zero expectation (from closure) -/

/-- Each centered observation summand has zero expectation. -/
theorem centeredObservation_zeroExpect
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {batch n : Nat}
    (X : ObservationBatch Omega batch n)
    (hInt : forall i, IntegrableRandomMatrix P (X i))
    (i : Fin batch) :
    matrixExpect P (centeredObservationFamily (P := P) X i) = 0 := by
  exact matrixExpect_centeredRandomMatrix (hInt i)

/-- The full centered family satisfies the `CenteredSelfAdjointRandomMatrixFamily`
predicate, packaging both self-adjointness and zero expectation. This is the
predicate consumed by the Matrix Bernstein infrastructure. -/
theorem observationFamily_centeredSelfAdjoint
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {batch n : Nat}
    (X : ObservationBatch Omega batch n)
    (hSA : SelfAdjointRandomMatrixFamily P X)
    (hInt : forall i, IntegrableRandomMatrix P (X i)) :
    CenteredSelfAdjointRandomMatrixFamily P
      (centeredObservationFamily (P := P) X) := by
  exact centeredSelfAdjointRandomMatrixFamily_centeredRandomMatrixFamily
    hSA hInt

/-! ## Second-moment Loewner comparison -/

/-- For each self-adjoint integrable observation, the centered second moment
is Loewner-dominated by the uncentered one. This is the key monotonicity that
allows variance-proxy bounds to use the (often easier to bound) uncentered
second moment. -/
theorem centeredObservation_secondMoment_le
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {batch n : Nat}
    (X : ObservationBatch Omega batch n)
    (hSA : SelfAdjointRandomMatrixFamily P X)
    (hInt : forall i, IntegrableRandomMatrix P (X i))
    (hSq : forall i, IntegrableRandomMatrix P (randomMatrixSquare (X i)))
    (i : Fin batch) :
    MatrixLE
      (matrixSecondMoment P (centeredObservationFamily (P := P) X i))
      (matrixSecondMoment P (X i)) := by
  exact matrixSecondMoment_centeredRandomMatrix_le_matrixSecondMoment
    (hInt i) (hSq i) (hSA.2 i)

/-- The centered second-moment identity: `E[Yᵢ²] = E[Xᵢ²] - (E[Xᵢ])²`.
This is the matrix variance decomposition for each observation. -/
theorem centeredObservation_secondMoment_identity
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {batch n : Nat}
    (X : ObservationBatch Omega batch n)
    (hInt : forall i, IntegrableRandomMatrix P (X i))
    (hSq : forall i, IntegrableRandomMatrix P (randomMatrixSquare (X i)))
    (i : Fin batch) :
    matrixSecondMoment P (centeredObservationFamily (P := P) X i) =
      matrixSecondMoment P (X i) -
        matrixSquare (matrixExpect P (X i)) := by
  exact matrixSecondMoment_centeredRandomMatrix (hInt i) (hSq i)

/-! ## Loewner spectral sandwich from operator-norm control -/

/-- If the operator norm of the deviation is at most `ε`, then the empirical
mean is sandwiched between `population - εI` and `population + εI` in the
Loewner order. This is the spectral consequence of concentration. -/
theorem observationDeviation_matrixLESandwich
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {batch n : Nat}
    (X : ObservationBatch Omega batch n)
    (hSA : SelfAdjointRandomMatrixFamily P X)
    (omega : Omega) (epsilon : Real)
    (hNorm :
      deterministicOperatorNorm
        (observationDeviation (P := P) X omega) <= epsilon) :
    MatrixLE
        (observationPopulationMean (P := P) X -
          epsilon • (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real))
        (observationEmpiricalMean X omega) /\
      MatrixLE
        (observationEmpiricalMean X omega)
        (observationPopulationMean (P := P) X +
          epsilon • (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)) := by
  have hSelfAdj :=
    observationDeviation_selfAdjoint (P := P) X hSA omega
  have hSandwich :=
    matrixLESandwich_of_selfAdjoint_operatorNorm_le hSelfAdj hNorm
  have hDev :=
    observationDeviation_eq_empirical_sub_population (P := P) X omega
  constructor
  · have hLower := hSandwich.1
    rw [MatrixLE] at hLower ⊢
    have hEq :
        observationEmpiricalMean X omega -
            (observationPopulationMean (P := P) X -
              epsilon • (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)) =
          observationDeviation (P := P) X omega +
            epsilon • (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) := by
      rw [hDev]
      abel
    rw [hEq]
    simpa using hLower
  · have hUpper := hSandwich.2
    rw [MatrixLE] at hUpper ⊢
    have hEq :
        (observationPopulationMean (P := P) X +
            epsilon • (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)) -
          observationEmpiricalMean X omega =
          epsilon • (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) -
            observationDeviation (P := P) X omega := by
      rw [hDev]
      abel
    rw [hEq]
    exact hUpper

/-! ## Tail-probability scaling -/

/-- Scaling the deviation by the batch size scales the operator-norm
upper-tail threshold by the same factor. This connects the normalized
deviation tail to the raw centered-sum tail used by Matrix Bernstein. -/
theorem observationDeviation_upperTailProb_scale
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {batch n : Nat}
    (X : ObservationBatch Omega batch n)
    (epsilon : Real) (hbatch : 0 < batch) :
    upperTailProb P
        (operatorNorm (observationDeviation (P := P) X)) epsilon =
      upperTailProb P
        (operatorNorm
          (randomMatrixSum
            (centeredObservationFamily (P := P) X)))
        ((batch : Real) * epsilon) := by
  have hbatchReal : 0 < (batch : Real) := by exact_mod_cast hbatch
  unfold upperTailProb upperTailEvent
  congr 1
  ext omega
  change
    epsilon <=
        ‖(1 / (batch : Real)) •
          randomMatrixSum
            (centeredObservationFamily (P := P) X) omega‖ ↔
      (batch : Real) * epsilon <=
        ‖randomMatrixSum
          (centeredObservationFamily (P := P) X) omega‖
  rw [norm_smul, Real.norm_eq_abs,
    abs_of_pos (one_div_pos.mpr hbatchReal)]
  rw [one_div, inv_mul_eq_div]
  simpa only [mul_comm] using
    (le_div_iff₀ hbatchReal :
      epsilon <=
          ‖randomMatrixSum
            (centeredObservationFamily (P := P) X) omega‖ /
            (batch : Real) ↔
        epsilon * (batch : Real) <=
          ‖randomMatrixSum
            (centeredObservationFamily (P := P) X) omega‖)

/-! ## End-to-end centered self-adjoint observation concentration

These thin consumers map a self-adjoint observation family through the core
`MatrixBernstein.CenteredSelfAdjointObservationInputs` interface to the optimized
operator-norm tail, its high-probability specialization, and the deterministic
Loewner spectral sandwich. No new mathematical facts are proved here; the
observation abstraction and its concentration live in core. -/

/-- Thin consumer: centered self-adjoint observation inputs yield the optimized
operator-norm tail through `MatrixBernstein.centeredSelfAdjointObservations`. -/
theorem observationSum_operatorNormTail_example
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {I : Type*} [Fintype I]
    {n : Nat} [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : I -> RandomMatrix Omega n n) (R sigmaSq t : Real) (hn : 0 < n)
    (h : MatrixBernstein.CenteredSelfAdjointObservationInputs
      (P := P) X R sigmaSq)
    (ht : 0 <= t) :
    upperTailProb P
        (operatorNorm (randomMatrixSum (centeredRandomMatrixFamily P X))) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS n R R t sigmaSq sigmaSq :=
  MatrixBernstein.centeredSelfAdjointObservations X R sigmaSq t hn h ht

/-- Thin consumer: the normalized high-probability observation endpoint. -/
theorem observationSum_highProbability_example
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {I : Type*} [Fintype I]
    {n : Nat} [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : I -> RandomMatrix Omega n n) (R sigmaSq delta : Real) (hn : 0 < n)
    (h : MatrixBernstein.CenteredSelfAdjointObservationInputs
      (P := P) X R sigmaSq)
    (hNondegenerate : Or (0 < sigmaSq) (0 < R))
    (hDelta : 0 < delta) (hDeltaOne : delta <= 1) :
    upperTailProb P
        (operatorNorm (randomMatrixSum (centeredRandomMatrixFamily P X)))
        (matrixBernsteinHighProbabilityThreshold n sigmaSq R delta) <=
      ENNReal.ofReal delta :=
  MatrixBernstein.centeredSelfAdjointObservationsHighProbability
    X R sigmaSq delta hn h hNondegenerate hDelta hDeltaOne

/-- The centered observation sum is self-adjoint at each sample. -/
theorem observationSum_selfAdjoint_example
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (X : I -> RandomMatrix Omega n n) (R sigmaSq : Real)
    (h : MatrixBernstein.CenteredSelfAdjointObservationInputs
      (P := P) X R sigmaSq)
    (omega : Omega) :
    IsSelfAdjointMatrix
      (randomMatrixSum (centeredRandomMatrixFamily P X) omega) := by
  have hCentered :
      CenteredSelfAdjointRandomMatrixFamily P
        (centeredRandomMatrixFamily P X) :=
    centeredSelfAdjointRandomMatrixFamily_centeredRandomMatrixFamily
      h.selfAdjoint h.integrable
  apply isSelfAdjointMatrix_sum
  intro i
  exact hCentered.1.2 i omega

/-- Operator-norm control gives the two-sided Loewner sandwich of the centered
observation sum around zero, the spectral good-event consequence. -/
theorem observationSum_matrixLESandwich_example
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (X : I -> RandomMatrix Omega (n + 1) (n + 1)) (R sigmaSq epsilon : Real)
    (h : MatrixBernstein.CenteredSelfAdjointObservationInputs
      (P := P) X R sigmaSq)
    (omega : Omega)
    (hNorm :
      deterministicOperatorNorm
        (randomMatrixSum (centeredRandomMatrixFamily P X) omega) <= epsilon) :
    MatrixLE ((-epsilon) • (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real))
        (randomMatrixSum (centeredRandomMatrixFamily P X) omega) /\
      MatrixLE (randomMatrixSum (centeredRandomMatrixFamily P X) omega)
        (epsilon • (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)) :=
  matrixLESandwich_of_selfAdjoint_operatorNorm_le
    (observationSum_selfAdjoint_example X R sigmaSq h omega) hNorm

end

end HighDimProb.Examples.RandomMatrix.CenteredSelfAdjointClosureUsage
