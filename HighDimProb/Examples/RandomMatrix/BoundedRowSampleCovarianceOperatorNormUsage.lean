import HighDimProb.Examples.RandomMatrix.SampleCovarianceTailUsage

/-!
# Bounded-row sample covariance operator-norm usage

This example keeps a domain-labeled entry point for the bounded-row sample
covariance operator-norm route, but reuses the canonical sample-covariance
operator-norm assumption bundle from `SampleCovarianceTailUsage`. This avoids
parallel positive/negative assumption structures for the same wrapper while
leaving the analytic Matrix Bernstein primitives explicit.
-/

namespace HighDimProb
namespace Examples
namespace RandomMatrix
namespace BoundedRowSampleCovarianceOperatorNormUsage

open MeasureTheory

noncomputable section

/--
Usage of the bounded-row sample covariance operator-norm tail wrapper.

The assumptions are exactly the canonical sample-covariance operator-norm usage
assumptions. They keep the positive bounded-row route visible through
`SampleCovarianceTailAssumptions`, derive negative structural and
square-integrability obligations via named adapters, and leave negative
exponential/trace integrability plus CFC/Tropp primitives explicit.
-/
theorem boundedRowSampleCovariance_operatorNorm_tail_usage
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m (n + 1)) (R Rneg t : Real)
    (h : SampleCovarianceTailUsage.SampleCovarianceOperatorNormTailAssumptions
      (P := P) A R Rneg t) :
    P (SelfAdjointOperatorNormTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t) <=
      sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n + 1) R t
          (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R) +
        sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n + 1) Rneg t
          (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) Rneg) := by
  exact
    SampleCovarianceTailUsage.sampleCovariance_operatorNorm_tail_usage
      (P := P) A R Rneg t h

end

end BoundedRowSampleCovarianceOperatorNormUsage
end RandomMatrix
end Examples
end HighDimProb
