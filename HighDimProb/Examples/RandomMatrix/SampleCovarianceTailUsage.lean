import HighDimProb.RandomMatrix.ConcentrationStatements

/-!
# Sample covariance tail wrapper usage examples

This examples-only file shows the preferred public API for the conditional
sample-covariance quadratic-form and operator-norm tail bounds. It keeps the
variance proxy, independence, integrability, Tropp, Bernstein CFC, and
analytic primitive assumptions explicit, and uses the core wrappers instead of
manually composing the centered row rank-one sum bridge with the optimized
Matrix Bernstein theorem. Radius, theta, and RHS helpers come from the core
concentration API.
-/

namespace HighDimProb.Examples.RandomMatrix.SampleCovarianceTailUsage

open MeasureTheory

noncomputable section

/-- Assumptions needed by the public sample-covariance tail wrapper.

The structural centered rank-one assumptions and the centered operator-norm
bound are discharged by the S5D theorem from the row-level hypotheses. The
variance proxy and analytic Matrix Bernstein primitives remain explicit. -/
structure SampleCovarianceTailAssumptions {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {m n : Nat}
    (A : RandomMatrix Omega m (n + 1))
    (R t sigmaSq : Real) : Prop where
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
          (sampleCovarianceTailTheta (m := m) R t sigmaSq)
          k)
  traceExpIntegrable :
    IntegrableRealRandomVariable P
      (traceExpIntegrand
        (centeredSampleCovarianceRowRankOneSum (P := P) A)
        (sampleCovarianceTailTheta (m := m) R t sigmaSq))
  sigmaPositive : 0 < sigmaSq
  radiusNonneg : 0 <= R
  deviationPositive : 0 < t
  varianceProxyNormBound :
    MatrixVarianceProxyNormBound P
      (centeredSampleCovarianceRowRankOneFamily (P := P) A) sigmaSq
  cfcPrimitive :
    forall k : Fin m, forall omega,
      bernsteinMatrixExp_le_quadratic_statement
        ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k omega)
        (sampleCovarianceTailTheta (m := m) R t sigmaSq)
        (sampleCovarianceCenteredRankOneRadius R)
  troppPrimitive :
    troppMasterTraceMGFFiniteFamily_statement
      (P := P)
      (centeredSampleCovarianceRowRankOneFamily (P := P) A)
      (bernsteinSecondMomentComparisonFamily P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (sampleCovarianceTailTheta (m := m) R t sigmaSq)
        (sampleCovarianceCenteredRankOneRadius R))
      (matrixVarianceProxy P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A))
      (sampleCovarianceTailTheta (m := m) R t sigmaSq)
      (sampleCovarianceCenteredRankOneRadius R)

/-- Preferred example-level sample-covariance quadratic-form tail wrapper.

This is only a readability layer over
`sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy`;
all analytic assumptions remain visible in
`SampleCovarianceTailAssumptions`. -/
theorem sampleCovariance_quadraticForm_tail_usage
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m (n + 1))
    (R t sigmaSq : Real)
    (h : SampleCovarianceTailAssumptions (P := P) A R t sigmaSq) :
    P (quadraticFormUpperTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t) <=
      sampleCovarianceQuadraticFormTailRHS (m := m) (n := n) R t sigmaSq := by
  exact
    sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy
      (P := P) A R t sigmaSq
      h.sampleCountPositive h.randomMatrix h.coordinateMemLpTwo
      h.rowSqNormBound h.independentRows h.squareIntegrable h.expIntegrable
      h.traceExpIntegrable h.sigmaPositive h.radiusNonneg h.deviationPositive
      h.varianceProxyNormBound h.cfcPrimitive h.troppPrimitive

/-- Assumptions needed by the public conditional sample-covariance
operator-norm tail wrapper.

The positive-sign sample-covariance assumptions reuse
`SampleCovarianceTailAssumptions`. The negative-sign Matrix Bernstein
assumptions remain explicit, matching the core theorem exactly. The nonempty
core wrapper supplies the self-adjoint operator-norm spectral bridge
internally. -/
structure SampleCovarianceOperatorNormTailAssumptions {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {m n : Nat}
    (A : RandomMatrix Omega m (n + 1))
    (R Rneg t sigmaSq sigmaSqNeg : Real) : Prop where
  positive :
    SampleCovarianceTailAssumptions (P := P) A R t sigmaSq
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
          (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
          k)
  traceExpIntegrableNeg :
    IntegrableRealRandomVariable P
      (traceExpIntegrand
        (centeredSampleCovarianceRowRankOneSumNeg (P := P) A)
        (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg))
  operatorNormBoundNeg :
    PointwiseOperatorNormBound
      (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
      (sampleCovarianceCenteredRankOneRadius Rneg)
  sigmaPositiveNeg : 0 < sigmaSqNeg
  radiusNonnegNeg : 0 <= Rneg
  varianceProxyNormBoundNeg :
    MatrixVarianceProxyNormBound P
      (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
      sigmaSqNeg
  cfcPrimitiveNeg :
    forall k : Fin m, forall omega,
      bernsteinMatrixExp_le_quadratic_statement
        ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A) k omega)
        (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
        (sampleCovarianceCenteredRankOneRadius Rneg)
  troppPrimitiveNeg :
    troppMasterTraceMGFFiniteFamily_statement
      (P := P)
      (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
      (bernsteinSecondMomentComparisonFamily P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
        (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
        (sampleCovarianceCenteredRankOneRadius Rneg))
      (matrixVarianceProxy P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A))
      (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
      (sampleCovarianceCenteredRankOneRadius Rneg)

/-- Preferred example-level sample-covariance operator-norm tail wrapper.

This is only a readability layer over
`sampleCovariance_selfAdjointOperatorNorm_tail_optimized_nonempty_under_explicit_variance_proxy`;
all analytic assumptions remain visible in
`SampleCovarianceOperatorNormTailAssumptions`. -/
theorem sampleCovariance_operatorNorm_tail_usage
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m (n + 1))
    (R Rneg t sigmaSq sigmaSqNeg : Real)
    (h : SampleCovarianceOperatorNormTailAssumptions
      (P := P) A R Rneg t sigmaSq sigmaSqNeg) :
    P (SelfAdjointOperatorNormTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t) <=
      sampleCovarianceQuadraticFormTailRHS (m := m) (n := n) R t sigmaSq +
        sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n) Rneg t sigmaSqNeg := by
  exact
    sampleCovariance_selfAdjointOperatorNorm_tail_optimized_nonempty_under_explicit_variance_proxy
      (P := P) A R Rneg t sigmaSq sigmaSqNeg
      h.positive.sampleCountPositive
      h.positive.randomMatrix
      h.positive.coordinateMemLpTwo
      h.positive.rowSqNormBound
      h.positive.independentRows
      h.positive.squareIntegrable
      h.positive.expIntegrable
      h.positive.traceExpIntegrable
      h.positive.sigmaPositive
      h.positive.radiusNonneg
      h.positive.deviationPositive
      h.positive.varianceProxyNormBound
      h.positive.cfcPrimitive
      h.positive.troppPrimitive
      h.centeredNeg
      h.independentSelfAdjointNeg
      h.integrableNeg
      h.squareIntegrableNeg
      h.expIntegrableNeg
      h.traceExpIntegrableNeg
      h.operatorNormBoundNeg
      h.sigmaPositiveNeg
      h.radiusNonnegNeg
      h.varianceProxyNormBoundNeg
      h.cfcPrimitiveNeg
      h.troppPrimitiveNeg

end

end HighDimProb.Examples.RandomMatrix.SampleCovarianceTailUsage
