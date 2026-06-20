import HighDimProb.RandomMatrix.ConcentrationStatements

/-!
# Sample covariance tail wrapper usage examples

This examples-only file shows the compact bounded-row sample-covariance tail
route. The core record `SampleCovarianceBoundedRowTroppAssumptions` packages the
common row assumptions and the remaining sign-specific Tropp/integrability
providers. The target parameter chooses the quadratic-form or self-adjoint
operator-norm event without requiring a separate public theorem name for each
combination of route choices.
-/

namespace HighDimProb.Examples.RandomMatrix.SampleCovarianceTailUsage

open MeasureTheory

noncomputable section

/-- The quadratic-form specialization of the compact bounded-row route.

This example intentionally uses the same core route record as the operator-norm
example below. Users who only need the positive-side quadratic-form theorem with
fewer assumptions can still call the lower-level wrapper directly. -/
theorem sampleCovariance_quadraticForm_tail_usage
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m (n + 1))
    (R Rneg t : Real)
    (h : SampleCovarianceBoundedRowTroppAssumptions (P := P) A R Rneg t) :
    P (quadraticFormUpperTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t) <=
      sampleCovarianceQuadraticFormTailRHS
        (m := m) (n := n + 1) R t
        (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R) := by
  simpa [SampleCovarianceTailTarget.event, SampleCovarianceTailTarget.rhs] using
    sampleCovariance_tail_optimized_under_boundedRowTroppAssumptions
      (P := P) A R Rneg t SampleCovarianceTailTarget.quadraticFormUpper h

/-- The self-adjoint operator-norm specialization of the compact bounded-row route. -/
theorem sampleCovariance_operatorNorm_tail_usage
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m (n + 1))
    (R Rneg t : Real)
    (h : SampleCovarianceBoundedRowTroppAssumptions (P := P) A R Rneg t) :
    P (SelfAdjointOperatorNormTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t) <=
      sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n + 1) R t
          (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R) +
        sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n + 1) Rneg t
          (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) Rneg) := by
  simpa [SampleCovarianceTailTarget.event, SampleCovarianceTailTarget.rhs] using
    sampleCovariance_tail_optimized_under_boundedRowTroppAssumptions
      (P := P) A R Rneg t SampleCovarianceTailTarget.selfAdjointOperatorNorm h

end

end HighDimProb.Examples.RandomMatrix.SampleCovarianceTailUsage
