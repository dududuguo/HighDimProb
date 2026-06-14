import HighDimProb.RandomMatrix.Assumptions

/-!
# Expectation operator-norm bound usage example

This examples-only file records two ways to control centered random matrices:
an explicit deterministic expectation bound, and the public expectation
operator-norm contraction theorem.

The core API proves both the triangle step
`||X(omega) - E X|| <= ||X(omega)|| + ||E X||` and the contraction
`||E X|| <= R` from pointwise operator-norm control, entrywise measurability,
entrywise integrability, and `0 <= R`.
-/

namespace HighDimProb.Examples.RandomMatrix.ExpectationOperatorNormBoundUsage

open MeasureTheory

noncomputable section

/-- Named predicate for an explicit deterministic expectation bound. -/
def MatrixExpectationOperatorNormBound {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {m n : Nat}
    (X : RandomMatrix Omega m n) (Rexp : Real) : Prop :=
  deterministicOperatorNorm (matrixExpect P X) <= Rexp

/-- Pointwise operator-norm control plus an expectation bound controls the
centered random matrix. -/
theorem centered_boundedOperatorNorm_of_expectation_bound
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {m n : Nat} (X : RandomMatrix Omega m n) (R Rexp : Real)
    (hX : BoundedOperatorNorm X R)
    (hExp : MatrixExpectationOperatorNormBound (P := P) X Rexp) :
    BoundedOperatorNorm (centeredRandomMatrix P X) (R + Rexp) := by
  exact BoundedOperatorNorm_centered_of_bound_expect_bound P X R Rexp hX hExp

/-- Family version used by Matrix Bernstein examples. -/
theorem centered_pointwiseOperatorNormBound_of_expectation_bound
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {I : Type*} {m n : Nat}
    (X : I -> RandomMatrix Omega m n) (R Rexp : Real)
    (hX : PointwiseOperatorNormBound X R)
    (hExp : forall i, MatrixExpectationOperatorNormBound (P := P) (X i) Rexp) :
    PointwiseOperatorNormBound
      (centeredRandomMatrixFamily P X) (R + Rexp) := by
  simpa [centeredRandomMatrixFamily] using
    PointwiseOperatorNormBound_centered_of_bound_expect_bound
      P X R Rexp hX hExp

/-- Same-radius wrapper: if the expectation has the same operator-norm bound
as the samples, the centered family has radius `R + R`. -/
theorem centered_pointwiseOperatorNormBound_same_radius
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {I : Type*} {m n : Nat}
    (X : I -> RandomMatrix Omega m n) (R : Real)
    (hX : PointwiseOperatorNormBound X R)
    (hExp : forall i, MatrixExpectationOperatorNormBound (P := P) (X i) R) :
    PointwiseOperatorNormBound
      (centeredRandomMatrixFamily P X) (R + R) := by
  simpa [centeredRandomMatrixFamily] using
    PointwiseOperatorNormBound_centered_of_bound_expect_bound_same
      P X R hX hExp

/-- The public expectation-contraction theorem supplies the named expectation
bound predicate for a family. -/
theorem expectationOperatorNormBound_of_pointwise_bound
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} {m n : Nat}
    (X : I -> RandomMatrix Omega m n) (R : Real)
    (hRandom : forall i, IsRandomMatrix P (X i))
    (hInt : forall i, IntegrableRandomMatrix P (X i))
    (hBound : PointwiseOperatorNormBound X R)
    (hR : 0 <= R) :
    forall i, MatrixExpectationOperatorNormBound (P := P) (X i) R := by
  exact expectationOperatorNormBound_of_pointwiseOperatorNormBound
    hRandom hInt hBound hR

/-- Local package for examples that want to document the public contraction
route explicitly. -/
structure ExpectationOperatorNormContractionAdapter {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*}
    {m n : Nat}
    (X : I -> RandomMatrix Omega m n) (R : Real) : Prop where
  randomMatrix : forall i, IsRandomMatrix P (X i)
  integrable : forall i, IntegrableRandomMatrix P (X i)
  pointwiseBound : PointwiseOperatorNormBound X R
  radiusNonneg : 0 <= R

/-- The contraction adapter produces the centered operator-norm assumption used
by centered rank-one covariance examples. -/
theorem centered_pointwiseOperatorNormBound_of_contraction_adapter
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} {m n : Nat}
    (X : I -> RandomMatrix Omega m n) (R : Real)
    (h : ExpectationOperatorNormContractionAdapter (P := P) X R) :
    PointwiseOperatorNormBound
      (centeredRandomMatrixFamily P X) (R + R) := by
  exact PointwiseOperatorNormBound_centered_of_pointwiseOperatorNormBound_same
    h.randomMatrix h.integrable h.pointwiseBound h.radiusNonneg

end

end HighDimProb.Examples.RandomMatrix.ExpectationOperatorNormBoundUsage
