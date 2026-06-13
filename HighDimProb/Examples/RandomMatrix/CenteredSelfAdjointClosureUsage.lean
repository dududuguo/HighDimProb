import HighDimProb.RandomMatrix.VarianceProxy
import HighDimProb.RandomMatrix.Assumptions

/-!
# Centered self-adjoint closure usage example

This examples-only file shows the deterministic closure step behind centered
random matrix summands: if `X(omega)` is self-adjoint and the entrywise
expectation `E X` is self-adjoint, then `X - E X` is self-adjoint pointwise.

The remaining analytic bridge, proving self-adjointness of `matrixExpect P X`
from pointwise self-adjointness and integrability, is kept as an explicit
example-local assumption.
-/

namespace HighDimProb.Examples.RandomMatrix.CenteredSelfAdjointClosureUsage

open MeasureTheory

noncomputable section

/-- Centering preserves entrywise random-matrix measurability. -/
theorem isRandomMatrix_centeredRandomMatrix {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomMatrix Omega n n}
    (hX : IsRandomMatrix P X) :
    IsRandomMatrix P (centeredRandomMatrix P X) := by
  intro i j
  exact (hX i j).sub measurable_const

/-- Centering by entrywise expectation has zero entrywise matrix expectation. -/
theorem matrixExpect_centeredRandomMatrix_zero {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {n : Nat} {X : RandomMatrix Omega n n}
    (hInt : IntegrableRandomMatrix P X) :
    matrixExpect P (centeredRandomMatrix P X) = 0 := by
  have hConstInt :
      IntegrableRandomMatrix P (fun _omega => matrixExpect P X) :=
    integrableRandomMatrix_const (P := P) (matrixExpect P X)
  have hSub :
      matrixExpect P (centeredRandomMatrix P X) =
        matrixExpect P X -
          matrixExpect P (fun _omega => matrixExpect P X) := by
    simpa [centeredRandomMatrix] using
      matrixExpect_sub (P := P) (A := fun _omega => matrixExpect P X)
        (B := X) hConstInt hInt
  rw [hSub]
  rw [matrixExpect_const_of_isProbabilityMeasure (P := P) (A := matrixExpect P X)]
  ext i j
  change matrixExpect P X i j - matrixExpect P X i j = 0
  ring

/-- If the expectation is self-adjoint, centering preserves random
self-adjointness. -/
theorem randomSelfAdjointMatrix_centeredRandomMatrix_of_expect
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomMatrix Omega n n}
    (hX : RandomSelfAdjointMatrix P X)
    (hExpect : IsSelfAdjointMatrix (matrixExpect P X)) :
    RandomSelfAdjointMatrix P (centeredRandomMatrix P X) := by
  intro omega
  change IsSelfAdjointMatrix (X omega - matrixExpect P X)
  exact (hX omega).sub hExpect

/-- Family version of the centered self-adjoint closure route. -/
theorem centeredRandomMatrix_family_centeredSelfAdjoint
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} {n : Nat}
    (X : I -> RandomMatrix Omega n n)
    (hRandom : forall i, IsRandomMatrix P (X i))
    (hSelfAdjoint : forall i, RandomSelfAdjointMatrix P (X i))
    (hExpect : forall i, IsSelfAdjointMatrix (matrixExpect P (X i)))
    (hInt : forall i, IntegrableRandomMatrix P (X i)) :
    CenteredSelfAdjointRandomMatrixFamily P
      (centeredRandomMatrixFamily P X) := by
  change CenteredSelfAdjointRandomMatrixFamily P
    (fun i => centeredRandomMatrix P (X i))
  exact And.intro
    (And.intro
      (fun i => isRandomMatrix_centeredRandomMatrix (P := P) (hRandom i))
      (fun i =>
        randomSelfAdjointMatrix_centeredRandomMatrix_of_expect
          (P := P) (hSelfAdjoint i) (hExpect i)))
    (fun i => matrixExpect_centeredRandomMatrix_zero (P := P) (hInt i))

/-- Example-local assumption package for the missing expectation
self-adjointness bridge. -/
structure CenteredSelfAdjointClosureAssumptions {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} {n : Nat}
    (X : I -> RandomMatrix Omega n n) : Prop where
  randomMatrix : forall i, IsRandomMatrix P (X i)
  randomSelfAdjoint : forall i, RandomSelfAdjointMatrix P (X i)
  expectationSelfAdjoint : forall i, IsSelfAdjointMatrix (matrixExpect P (X i))
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
  exact centeredRandomMatrix_family_centeredSelfAdjoint
    (P := P) X h.randomMatrix h.randomSelfAdjoint
    h.expectationSelfAdjoint h.integrable

end

end HighDimProb.Examples.RandomMatrix.CenteredSelfAdjointClosureUsage
