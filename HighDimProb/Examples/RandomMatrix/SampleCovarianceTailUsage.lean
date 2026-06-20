import HighDimProb.RandomMatrix.ConcentrationStatements

/-!
# Sample covariance tail wrapper usage examples

This examples-only file shows the preferred public API for the conditional
sample-covariance quadratic-form and operator-norm tail bounds. It keeps the
independence, integrability, Tropp, and analytic primitive
assumptions explicit, while the crude bounded-row variance-proxy norm bound is
supplied by the core wrappers. Radius, theta, variance-proxy RHS, and tail RHS
helpers come from the core concentration API. The RHS helper takes the actual
column dimension; the nonempty examples below therefore pass `n + 1`. The
row-specific exact-row variance-proxy wrapper is currently a lower-level
positive-side API; this example keeps the uniform-radius route until matching
negative-side and two-sided exact-row wrappers are available.
-/

namespace HighDimProb.Examples.RandomMatrix.SampleCovarianceTailUsage

open MeasureTheory

noncomputable section

/-- Assumptions needed by the public sample-covariance tail wrapper.

The structural centered rank-one assumptions and the centered operator-norm
bound are discharged by the core theorem from the row-level hypotheses. The
crude variance-proxy norm bound is derived from the row squared-norm bound;
the remaining Tropp/Lieb Matrix Bernstein primitive remains explicit. -/
structure SampleCovarianceTailAssumptions {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {m n : Nat}
    (A : RandomMatrix Omega m (n + 1))
    (R t : Real) : Prop where
  sampleCountPositive : 0 < m
  randomMatrix : IsRandomMatrix P A
  coordinateMemLpTwo :
    forall k : Fin m, forall j : Fin (n + 1),
      MemLpRealRandomVariable P (matrixEntry A k j) 2
  rowSqNormBound :
    forall k : Fin m, forall omega,
      vectorSqNorm (rowVector A k omega) <= R
  independentRows :
    IndependentRandomMatrices P
      (centeredSampleCovarianceRowRankOneFamily (P := P) A)
  squareIntegrable :
    forall k : Fin m,
      IntegrableRandomMatrix P
        (randomMatrixSquare
          ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k))
  expIntegrable :
    forall k : Fin m,
      IntegrableRandomMatrix P
        (matrixExpScaledFamily
          (centeredSampleCovarianceRowRankOneFamily (P := P) A)
          (sampleCovarianceTailTheta (m := m) R t
            (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R))
          k)
  traceExpIntegrable :
    IntegrableRealRandomVariable P
      (traceExpIntegrand
        (centeredSampleCovarianceRowRankOneSum (P := P) A)
        (sampleCovarianceTailTheta (m := m) R t
          (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R)))
  radiusPositive : 0 < R
  deviationPositive : 0 < t
  troppPrimitive :
    troppMasterTraceMGFFiniteFamily_statement
      (P := P)
      (centeredSampleCovarianceRowRankOneFamily (P := P) A)
      (bernsteinSecondMomentComparisonFamily P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (sampleCovarianceTailTheta (m := m) R t
          (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R))
        (sampleCovarianceCenteredRankOneRadius R))
      (matrixVarianceProxy P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A))
      (sampleCovarianceTailTheta (m := m) R t
        (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R))
      (sampleCovarianceCenteredRankOneRadius R)

/-- Preferred example-level sample-covariance quadratic-form tail wrapper.

This is only a readability layer over
`sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound_of_troppPrimitive`;
all analytic assumptions remain visible in
`SampleCovarianceTailAssumptions`. -/
theorem sampleCovariance_quadraticForm_tail_usage
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m (n + 1))
    (R t : Real)
    (h : SampleCovarianceTailAssumptions (P := P) A R t) :
    P (quadraticFormUpperTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t) <=
      sampleCovarianceQuadraticFormTailRHS
        (m := m) (n := n + 1) R t
        (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R) := by
  exact
    sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound_of_troppPrimitive
      (P := P) A R t
      h.sampleCountPositive h.randomMatrix h.coordinateMemLpTwo
      h.rowSqNormBound h.independentRows h.squareIntegrable h.expIntegrable
      h.traceExpIntegrable h.radiusPositive h.deviationPositive
      h.troppPrimitive


/-- Example-level exact-row centered-square-chain quadratic-form tail usage.

This demonstrates the core assumption bundle
`SampleCovarianceExactRowCenteredSquareTroppAssumptions` directly, rather than
copying its long field list into an example-local structure. The generic
centered-square chain, Tropp primitive, and analytic assumptions remain fields
of that core bundle. -/
theorem sampleCovariance_exactRow_centeredSquare_quadraticForm_tail_usage
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m (n + 1))
    (R t : Real)
    (Rvar : Fin m -> Real)
    (h : SampleCovarianceExactRowCenteredSquareTroppAssumptions
      (P := P) A R t Rvar) :
    P (quadraticFormUpperTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t) <=
      sampleCovarianceQuadraticFormTailRHS
        (m := m) (n := n + 1) R t
        (rowSqNormVarianceProxyNormRHS Rvar) := by
  exact
    sampleCovariance_quadraticForm_tail_optimized_under_exactRowSqNorm_bound_of_centeredSquareChain_of_troppAssumptions
      (P := P) A R t Rvar h

/-- Assumptions needed by the public conditional sample-covariance
operator-norm tail wrapper.

The positive-sign sample-covariance assumptions reuse
`SampleCovarianceTailAssumptions`. Negative-sign structure, entrywise
integrability, independence, square-integrability, and pointwise operator-norm
bounds are supplied by named row/negation adapters from the row `MemLp 2`,
positive square-integrability, and row squared-norm assumptions. Negative
matrix-exponential integrability, trace-integrability, and Tropp
primitives remain explicit. -/
structure SampleCovarianceOperatorNormTailAssumptions {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {m n : Nat}
    (A : RandomMatrix Omega m (n + 1))
    (R Rneg t : Real) : Prop where
  positiveSide :
    SampleCovarianceTailAssumptions (P := P) A R t
  rowSqNormBoundNeg :
    forall k : Fin m, forall omega,
      vectorSqNorm (rowVector A k omega) <= Rneg
  expIntegrableNeg :
    forall k : Fin m,
      IntegrableRandomMatrix P
        (matrixExpScaledFamily
          (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
          (sampleCovarianceTailTheta (m := m) Rneg t
            (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) Rneg))
          k)
  traceExpIntegrableNeg :
    IntegrableRealRandomVariable P
      (traceExpIntegrand
        (centeredSampleCovarianceRowRankOneSumNeg (P := P) A)
        (sampleCovarianceTailTheta (m := m) Rneg t
          (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) Rneg)))
  negativeRadiusPositive : 0 < Rneg
  troppPrimitiveNeg :
    troppMasterTraceMGFFiniteFamily_statement
      (P := P)
      (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
      (bernsteinSecondMomentComparisonFamily P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
        (sampleCovarianceTailTheta (m := m) Rneg t
          (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) Rneg))
        (sampleCovarianceCenteredRankOneRadius Rneg))
      (matrixVarianceProxy P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A))
      (sampleCovarianceTailTheta (m := m) Rneg t
        (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) Rneg))
      (sampleCovarianceCenteredRankOneRadius Rneg)

/-- Preferred example-level sample-covariance operator-norm tail wrapper.

This is only a readability layer over
`sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_square_adapters_of_troppPrimitives`;
all analytic assumptions that are not discharged by named row/negation adapters
remain visible in `SampleCovarianceOperatorNormTailAssumptions`. -/
theorem sampleCovariance_operatorNorm_tail_usage
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m (n + 1))
    (R Rneg t : Real)
    (h : SampleCovarianceOperatorNormTailAssumptions
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
    sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_square_adapters_of_troppPrimitives
      (P := P) A R Rneg t
      h.positiveSide.sampleCountPositive
      h.positiveSide.randomMatrix
      h.positiveSide.coordinateMemLpTwo
      h.positiveSide.rowSqNormBound
      h.rowSqNormBoundNeg
      h.positiveSide.independentRows
      h.positiveSide.squareIntegrable
      h.positiveSide.expIntegrable
      h.positiveSide.traceExpIntegrable
      h.positiveSide.radiusPositive
      h.positiveSide.deviationPositive
      h.positiveSide.troppPrimitive
      h.expIntegrableNeg
      h.traceExpIntegrableNeg
      h.negativeRadiusPositive
      h.troppPrimitiveNeg


/-- Example-level exact-row centered-square-chain operator-norm tail usage.

This demonstrates the two-sided core bundle
`SampleCovarianceExactRowCenteredSquareTwoSidedTroppAssumptions`. It adds no
new mathematics; it only routes the bundled assumptions to the public core
wrapper. -/
theorem sampleCovariance_exactRow_centeredSquare_operatorNorm_tail_usage
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m (n + 1))
    (R Rneg t : Real)
    (Rvar RvarNeg : Fin m -> Real)
    (h : SampleCovarianceExactRowCenteredSquareTwoSidedTroppAssumptions
      (P := P) A R Rneg t Rvar RvarNeg) :
    P (SelfAdjointOperatorNormTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t) <=
      sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n + 1) R t (rowSqNormVarianceProxyNormRHS Rvar) +
        sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n + 1) Rneg t
          (rowSqNormVarianceProxyNormRHS RvarNeg) := by
  exact
    sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_exactRowSqNorm_bound_with_neg_square_adapters_of_centeredSquareChain_of_troppAssumptions
      (P := P) A R Rneg t Rvar RvarNeg h

end

end HighDimProb.Examples.RandomMatrix.SampleCovarianceTailUsage
