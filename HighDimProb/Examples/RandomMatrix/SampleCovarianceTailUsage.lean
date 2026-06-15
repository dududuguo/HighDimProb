import HighDimProb.RandomMatrix.ConcentrationStatements

/-!
# Sample covariance tail wrapper usage examples

This examples-only file shows the preferred public API for the conditional
sample-covariance quadratic-form and operator-norm tail bounds. It keeps the
independence, integrability, Tropp, Bernstein CFC, and analytic primitive
assumptions explicit, while the crude bounded-row variance-proxy norm bound is
supplied by the core wrappers. Radius, theta, variance-proxy RHS, and tail RHS
helpers come from the core concentration API. The RHS helper takes the actual
column dimension; the nonempty examples below therefore pass `n + 1`.
-/

namespace HighDimProb.Examples.RandomMatrix.SampleCovarianceTailUsage

open MeasureTheory

noncomputable section

/-- Assumptions needed by the public sample-covariance tail wrapper.

The structural centered rank-one assumptions and the centered operator-norm
bound are discharged by the core theorem from the row-level hypotheses. The
crude variance-proxy norm bound is derived from the row squared-norm bound;
the analytic Matrix Bernstein primitives remain explicit. -/
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
  cfcPrimitive :
    forall k : Fin m, forall omega,
      bernsteinMatrixExp_le_quadratic_statement
        ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k omega)
        (sampleCovarianceTailTheta (m := m) R t
          (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R))
        (sampleCovarianceCenteredRankOneRadius R)
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
`sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound`;
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
    sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound
      (P := P) A R t
      h.sampleCountPositive h.randomMatrix h.coordinateMemLpTwo
      h.rowSqNormBound h.independentRows h.squareIntegrable h.expIntegrable
      h.traceExpIntegrable h.radiusPositive h.deviationPositive
      h.cfcPrimitive h.troppPrimitive

/-- Assumptions needed by the public conditional sample-covariance
operator-norm tail wrapper.

The positive-sign sample-covariance assumptions reuse
`SampleCovarianceTailAssumptions`. The negative-sign Matrix Bernstein
assumptions remain explicit except for the variance-proxy norm bound, which is
derived from the negative-family operator-norm bound. The arbitrary core wrapper
supplies the self-adjoint operator-norm spectral bridge internally under the
explicit positive-threshold assumption. -/
structure SampleCovarianceOperatorNormTailAssumptions {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {m n : Nat}
    (A : RandomMatrix Omega m (n + 1))
    (R Rneg t : Real) : Prop where
  positive :
    SampleCovarianceTailAssumptions (P := P) A R t
  centeredNeg :
    CenteredSelfAdjointRandomMatrixFamily P
      (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
  independentSelfAdjointNeg :
    IndependentSelfAdjointRandomMatrices P
      (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
  integrableNeg :
    forall k : Fin m,
      IntegrableRandomMatrix P
        ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A) k)
  squareIntegrableNeg :
    forall k : Fin m,
      IntegrableRandomMatrix P
        (randomMatrixSquare
          ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A) k))
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
  operatorNormBoundNeg :
    PointwiseOperatorNormBound
      (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
      (sampleCovarianceCenteredRankOneRadius Rneg)
  radiusPositiveNeg : 0 < Rneg
  cfcPrimitiveNeg :
    forall k : Fin m, forall omega,
      bernsteinMatrixExp_le_quadratic_statement
        ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A) k omega)
        (sampleCovarianceTailTheta (m := m) Rneg t
          (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) Rneg))
        (sampleCovarianceCenteredRankOneRadius Rneg)
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
`sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound`;
all analytic assumptions remain visible in
`SampleCovarianceOperatorNormTailAssumptions`. -/
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
    sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound
      (P := P) A R Rneg t
      h.positive.sampleCountPositive
      h.positive.randomMatrix
      h.positive.coordinateMemLpTwo
      h.positive.rowSqNormBound
      h.positive.independentRows
      h.positive.squareIntegrable
      h.positive.expIntegrable
      h.positive.traceExpIntegrable
      h.positive.radiusPositive
      h.positive.deviationPositive
      h.positive.cfcPrimitive
      h.positive.troppPrimitive
      h.centeredNeg
      h.independentSelfAdjointNeg
      h.integrableNeg
      h.squareIntegrableNeg
      h.expIntegrableNeg
      h.traceExpIntegrableNeg
      h.operatorNormBoundNeg
      h.radiusPositiveNeg
      h.cfcPrimitiveNeg
      h.troppPrimitiveNeg

end

end HighDimProb.Examples.RandomMatrix.SampleCovarianceTailUsage
