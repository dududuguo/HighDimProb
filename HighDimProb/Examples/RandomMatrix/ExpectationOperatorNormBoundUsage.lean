import HighDimProb.RandomMatrix.Assumptions

/-!
# Expectation operator-norm bound usage example

This examples-only file isolates the API gap between pointwise operator-norm
bounds and bounds on entrywise matrix expectations.

The current core API already proves the triangle step for centered matrices:
`||X(omega) - E X|| <= ||X(omega)|| + ||E X||`. This file keeps the
contraction-style fact `||E X|| <= R` as a named local assumption.
-/

namespace HighDimProb.Examples.RandomMatrix.ExpectationOperatorNormBoundUsage

open MeasureTheory

noncomputable section

/-- Named local assumption for the missing expectation contraction bridge. -/
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

/-- Local package for examples that want to document the intended contraction
without proving Jensen or Bochner integration facts in the examples layer. -/
structure ExpectationOperatorNormContractionAdapter {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {I : Type*}
    {m n : Nat}
    (X : I -> RandomMatrix Omega m n) (R : Real) : Prop where
  pointwiseBound : PointwiseOperatorNormBound X R
  expectationBound : forall i, MatrixExpectationOperatorNormBound (P := P) (X i) R

/-- The contraction adapter produces the centered operator-norm assumption used
by centered rank-one covariance examples. -/
theorem centered_pointwiseOperatorNormBound_of_contraction_adapter
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {I : Type*} {m n : Nat}
    (X : I -> RandomMatrix Omega m n) (R : Real)
    (h : ExpectationOperatorNormContractionAdapter (P := P) X R) :
    PointwiseOperatorNormBound
      (centeredRandomMatrixFamily P X) (R + R) := by
  exact centered_pointwiseOperatorNormBound_same_radius
    (P := P) X R h.pointwiseBound h.expectationBound

end

end HighDimProb.Examples.RandomMatrix.ExpectationOperatorNormBoundUsage
