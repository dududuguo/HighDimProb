import HighDimProb.RandomMatrix.ConcentrationStatements
import HighDimProb.Examples.RandomMatrix.SampleCovarianceTailUsage

/-!
# RM-S7D sample-covariance operator-norm tail contract probe

This validation-only probe checks the current route from the centered sample
covariance deviation to the conditional self-adjoint operator-norm Matrix
Bernstein wrapper. It intentionally records the remaining event bridge as a
typed candidate rather than adding a core theorem.
-/

namespace HighDimProb

open MeasureTheory

noncomputable section

#check centeredRandomMatrix
#check sampleCovariance
#check centeredSampleCovarianceRowRankOneFamily
#check centeredSampleCovarianceRowRankOneSum
#check normalizedCenteredSampleCovarianceRowRankOneSum
#check sampleCovariance_deviation_eq_normalized_centered_rowRankOne_sum

#check centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two
#check centeredRankOneRandomMatrix_integrable_of_memLp_two
#check PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound

#check sampleCovarianceCenteredRankOneRadius
#check sampleCovarianceTailTheta
#check sampleCovarianceQuadraticFormTailRHS
#check sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy
#check HighDimProb.Examples.RandomMatrix.SampleCovarianceTailUsage.SampleCovarianceTailAssumptions
#check HighDimProb.Examples.RandomMatrix.SampleCovarianceTailUsage.sampleCovariance_quadraticForm_tail_usage

#check SelfAdjointOperatorNormTailEvent
#check twoSidedQuadraticFormTailEvent
#check selfAdjointOperatorNormTailViaQuadraticFormStatement
#check matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
#check matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives

/-- Candidate missing bridge from the normalized centered covariance deviation
event to the unnormalized centered row-rank-one sum event consumed by RM-S7C. -/
abbrev rmS7D_sampleCovarianceOperatorNormNormalizationBridge
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {m n : Nat}
    (A : RandomMatrix Omega m (n + 1)) (t : Real) : Prop :=
  0 < m ->
    SelfAdjointOperatorNormTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t <=
      SelfAdjointOperatorNormTailEvent
        (centeredSampleCovarianceRowRankOneSum (P := P) A)
        ((m : Real) * t)

/-- RHS shape obtained by applying RM-S7C to the unnormalized centered
row-rank-one sum at threshold `(m : Real) * t`. -/
abbrev rmS7D_sampleCovarianceOperatorNormTailRHS {m n : Nat}
    (R Rneg t sigmaSq sigmaSqNeg : Real) : ENNReal :=
  ENNReal.ofReal
      ((n + 1 : Real) *
        Real.exp (-(((m : Real) * t) ^ 2 /
          (2 * sigmaSq + (2 / 3) *
            sampleCovarianceCenteredRankOneRadius R * ((m : Real) * t))))) +
    ENNReal.ofReal
      ((n + 1 : Real) *
        Real.exp (-(((m : Real) * t) ^ 2 /
          (2 * sigmaSqNeg + (2 / 3) * Rneg * ((m : Real) * t)))))

/-- S0-S5 already discharge the positive-sign centered self-adjoint structure,
ordinary summand integrability, and pointwise operator-norm bound for the
centered row-rank-one sample-covariance family. -/
example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m (n + 1)) (R : Real)
    (hMeas : IsRandomMatrix P A)
    (hLp :
      forall k : Fin m, forall j : Fin (n + 1),
        MemLpRealRandomVariable P (matrixEntry A k j) 2)
    (hSq :
      forall k : Fin m, forall omega,
        vectorSqNorm (rowVector A k omega) <= R)
    (hR : 0 <= R) :
    (CenteredSelfAdjointRandomMatrixFamily P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A)) /\
      (forall k : Fin m,
        IntegrableRandomMatrix P
          ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k)) /\
      PointwiseOperatorNormBound
        (centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (sampleCovarianceCenteredRankOneRadius R) := by
  have hRowsRandom :
      forall k : Fin m, IsRandomVector P (rowVector A k) := by
    intro k
    exact isRandomVector_rowVector hMeas k
  have hRowsLp :
      forall k : Fin m, forall j : Fin (n + 1),
        MemLpRealRandomVariable P (coord (rowVector A k) j) 2 := by
    intro k j
    change MemLpRealRandomVariable P (matrixEntry A k j) 2
    exact hLp k j
  exact And.intro
    (centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two
      (P := P) (X := rowVector A) hRowsRandom hRowsLp)
    (And.intro
      (by
        intro k
        change IntegrableRandomMatrix P
          (centeredRankOneRandomMatrix P (rowVector A k))
        exact centeredRankOneRandomMatrix_integrable_of_memLp_two
          (P := P) (X := rowVector A k) (hRowsLp k))
      (PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound
        (P := P) (X := rowVector A) hRowsRandom hRowsLp hSq hR))

#check rmS7D_sampleCovarianceOperatorNormNormalizationBridge
#check rmS7D_sampleCovarianceOperatorNormTailRHS

end

end HighDimProb
