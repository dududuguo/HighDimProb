import HighDimProb.RandomMatrix.VarianceProxy
import HighDimProb.RandomMatrix.Assumptions
import HighDimProb.RandomMatrix.Concentration

/-!
# Centered self-adjoint closure usage example

This examples-only file shows the deterministic closure step behind centered
random matrix summands. The public RandomMatrix API now proves that centering
preserves entrywise measurability, entrywise integrability, pointwise
self-adjointness, and zero entrywise expectation for integrable
self-adjoint families.
-/

namespace HighDimProb.Examples.RandomMatrix.CenteredSelfAdjointClosureUsage

open MeasureTheory

noncomputable section

/-- The public API supplies self-adjointness of centered summands. -/
theorem randomSelfAdjointMatrix_centeredRandomMatrix_example
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomMatrix Omega n n}
    (hX : RandomSelfAdjointMatrix P X) :
    RandomSelfAdjointMatrix P (centeredRandomMatrix P X) := by
  exact randomSelfAdjointMatrix_centeredRandomMatrix hX

/-- The public API supplies zero expectation of centered integrable summands. -/
theorem matrixExpect_centeredRandomMatrix_zero_example
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {n : Nat} {X : RandomMatrix Omega n n}
    (hInt : IntegrableRandomMatrix P X) :
    matrixExpect P (centeredRandomMatrix P X) = 0 := by
  exact matrixExpect_centeredRandomMatrix hInt

/-- Family version of the centered self-adjoint closure route. -/
theorem centeredRandomMatrix_family_centeredSelfAdjoint_example
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} {n : Nat}
    (X : I -> RandomMatrix Omega n n)
    (hSelfAdjoint : SelfAdjointRandomMatrixFamily P X)
    (hInt : forall i, IntegrableRandomMatrix P (X i)) :
    CenteredSelfAdjointRandomMatrixFamily P
      (centeredRandomMatrixFamily P X) := by
  exact centeredSelfAdjointRandomMatrixFamily_centeredRandomMatrixFamily
    hSelfAdjoint hInt

/-- Example-local assumption package for centered self-adjoint closure. -/
structure CenteredSelfAdjointClosureAssumptions {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} {n : Nat}
    (X : I -> RandomMatrix Omega n n) : Prop where
  selfAdjointFamily : SelfAdjointRandomMatrixFamily P X
  integrable : forall i, IntegrableRandomMatrix P (X i)

/-- The local assumption package supplies the Matrix Bernstein centered
self-adjoint family predicate for centered summands. -/
theorem centeredSelfAdjointFamily_of_closure_assumptions
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} {n : Nat}
    (X : I -> RandomMatrix Omega n n)
    (h : CenteredSelfAdjointClosureAssumptions (P := P) X) :
    CenteredSelfAdjointRandomMatrixFamily P
      (centeredRandomMatrixFamily P X) := by
  exact centeredSelfAdjointRandomMatrixFamily_centeredRandomMatrixFamily
    h.selfAdjointFamily h.integrable

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
