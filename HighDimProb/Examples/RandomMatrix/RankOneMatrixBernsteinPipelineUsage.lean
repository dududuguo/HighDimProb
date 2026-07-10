import HighDimProb.RandomMatrix.MatrixBernsteinProvider

/-!
# Rank-one Matrix Bernstein pipeline usage example

This examples-only file exposes the generic centered rank-one Matrix Bernstein
endpoint under an application-facing name. Random-vector measurability,
coordinate second moments, a pointwise squared-norm bound, and matrix-family
independence are the only inputs retained here; the core provider generates
integrability, centeredness, radius, and variance-proxy obligations.
-/

namespace HighDimProb.Examples.RandomMatrix.RankOneMatrixBernsteinPipelineUsage

open MeasureTheory

noncomputable section

/-- The centered rank-one covariance family used as Matrix Bernstein summands. -/
abbrev centeredRankOnePipelineSummands {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {I : Type*} {n : Nat}
    (X : I -> RandomVector Omega (n + 1)) :
    I -> RandomMatrix Omega (n + 1) (n + 1) :=
  centeredRankOneRandomMatrixFamily P X

/-- Application-facing alias for the reusable centered rank-one inputs. -/
abbrev RankOneBernsteinInputs {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    (X : I -> RandomVector Omega (n + 1)) (R : Real) : Prop :=
  MatrixBernstein.CenteredRankOneInputs (P := P) X R

/-- Optimized operator-norm upper tail for centered rank-one covariance sums.

The centered radius is `2 * R`; the variance parameter is generated from the
same squared-vector-norm bound.
-/
theorem rankOne_operatorNormTail
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    [StandardBorelSpace (Matrix (Fin (n + 1)) (Fin (n + 1)) Real)]
    (X : I -> RandomVector Omega (n + 1)) (R t : Real)
    (h : RankOneBernsteinInputs (P := P) X R) (ht : 0 <= t) :
    upperTailProb P
        (operatorNorm
          (randomMatrixSum (centeredRankOnePipelineSummands (P := P) X))) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        (n + 1) (2 * R) (2 * R) t
        (centeredRankOneVarianceProxyNormRHS (I := I) R)
        (centeredRankOneVarianceProxyNormRHS (I := I) R) := by
  simpa using
    MatrixBernstein.centeredRankOne
      (mOmega := mOmega) (P := P) X R t (Nat.succ_pos n) h ht

end

end HighDimProb.Examples.RandomMatrix.RankOneMatrixBernsteinPipelineUsage
