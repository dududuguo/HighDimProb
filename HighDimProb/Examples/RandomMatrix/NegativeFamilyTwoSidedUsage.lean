import HighDimProb.RandomMatrix.ConcentrationStatements

/-!
# Negative-family two-sided Matrix Bernstein usage

This examples-only file records the current public route for two-sided
quadratic-form and self-adjoint operator-norm Matrix Bernstein wrappers.  The
positive side reuses one assumption package for `A`; the negative side uses the
core package for the existing `negRandomMatrixFamily A`.
-/

namespace HighDimProb.Examples.RandomMatrix.NegativeFamilyTwoSidedUsage

open MeasureTheory

noncomputable section

/-- Positive-side assumptions shared by the two-sided and operator-norm routes.

This examples-only alias keeps the usage theorem short while pointing users to
the reusable core Matrix Bernstein assumption bundle. -/
abbrev PositiveFamilyAssumptions {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega (n + 1) (n + 1))
    (R t sigmaSq : Real) : Prop :=
  MatrixBernsteinPositiveSideAssumptions (P := P) A R t sigmaSq

/-- Negative-side assumptions for the existing `negRandomMatrixFamily A`.

This examples-only alias is intentionally honest: it does not prove any
positive-to-negative transfer, but it avoids duplicating the core negative-side
assumption structure in each usage file. -/
abbrev NegativeFamilyAssumptions {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega (n + 1) (n + 1))
    (Rneg t sigmaSqNeg : Real) : Prop :=
  MatrixBernsteinNegativeSideAssumptions (P := P) A Rneg t sigmaSqNeg

/-- High-level two-sided quadratic-form usage.

The positive- and negative-side hypotheses are both packaged by the core Matrix
Bernstein API. -/
theorem negativeFamily_twoSided_quadraticForm_tail_usage
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega (n + 1) (n + 1))
    (R Rneg t sigmaSq sigmaSqNeg : Real)
    (hPos : PositiveFamilyAssumptions (P := P) A R t sigmaSq)
    (hNeg : NegativeFamilyAssumptions (P := P) A Rneg t sigmaSqNeg) :
    P (twoSidedQuadraticFormTailEvent (randomMatrixSum A) t) <=
      ENNReal.ofReal
        ((n + 1 : Real) *
          Real.exp (-(t ^ 2 / (2 * sigmaSq + (2 / 3) * R * t)))) +
        ENNReal.ofReal
          ((n + 1 : Real) *
            Real.exp (-(t ^ 2 / (2 * sigmaSqNeg + (2 / 3) * Rneg * t)))) := by
  exact
    matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions
      (P := P) (A := A) (R := R) (Rneg := Rneg) (t := t)
      (sigmaSq := sigmaSq) (sigmaSqNeg := sigmaSqNeg)
      hPos hNeg

/-- High-level self-adjoint operator-norm usage.

This calls the current arbitrary-dimensional positive-threshold wrapper through
the core assumption-bundle API. -/
theorem negativeFamily_selfAdjoint_operatorNorm_tail_usage
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega (n + 1) (n + 1))
    (R Rneg t sigmaSq sigmaSqNeg : Real)
    (hPos : PositiveFamilyAssumptions (P := P) A R t sigmaSq)
    (hNeg : NegativeFamilyAssumptions (P := P) A Rneg t sigmaSqNeg) :
    P (SelfAdjointOperatorNormTailEvent (randomMatrixSum A) t) <=
      ENNReal.ofReal
        ((n + 1 : Real) *
          Real.exp (-(t ^ 2 / (2 * sigmaSq + (2 / 3) * R * t)))) +
        ENNReal.ofReal
          ((n + 1 : Real) *
            Real.exp (-(t ^ 2 / (2 * sigmaSqNeg + (2 / 3) * Rneg * t)))) := by
  simpa using
    (matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_assumptions
      (P := P) (A := A) (R := R) (Rneg := Rneg) (t := t)
      (sigmaSq := sigmaSq) (sigmaSqNeg := sigmaSqNeg)
      hPos hNeg)

end

end HighDimProb.Examples.RandomMatrix.NegativeFamilyTwoSidedUsage
