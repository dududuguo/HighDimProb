import HighDimProb.RandomMatrix.ConcentrationStatements

/-!
# Bounded-row sample covariance operator-norm usage

This example shows the high-level sample covariance wrapper whose positive-side
variance proxy is obtained from a row squared-norm bound. The caller supplies
random data rows, row boundedness, and the remaining analytic primitives; the
wrapper derives the positive-side crude variance proxy internally.
-/

namespace HighDimProb
namespace Examples
namespace RandomMatrix
namespace BoundedRowSampleCovarianceOperatorNormUsage

open MeasureTheory

noncomputable section

/--
Positive-side assumptions for the bounded-row sample covariance route.

There is intentionally no `MatrixVarianceProxyNormBound` field here: the current
wrapper derives it from `rowSqNormBound`.
-/
structure PositiveBoundedRowSampleCovarianceAssumptions
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m (n + 1)) (R t : Real) : Prop where
  sampleCountPositive : 0 < m
  randomMatrix : IsRandomMatrix P A
  coordinateMemLpTwo :
    forall k : Fin m, forall j : Fin (n + 1),
      MemLpRealRandomVariable P (matrixEntry A k j) 2
  rowSqNormBound :
    forall k : Fin m, forall omega,
      vectorSqNorm (rowVector A k omega) <= R
  independentCenteredRows :
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
  rowBoundPositive : 0 < R
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

/--
Negative-side assumptions that remain explicit for the same wrapper.

The negative family itself is the existing centered rank-one negation API. These
fields are deliberately narrow: they expose the assumptions still needed for the
lower-tail half without asking the user to provide the final theorem.
-/
structure NegativeBoundedRowSampleCovarianceAssumptions
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m (n + 1)) (Rneg t : Real) : Prop where
  centeredSelfAdjointNeg :
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
  rowBoundPositiveNeg : 0 < Rneg
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

/--
Usage of the bounded-row sample covariance operator-norm tail wrapper.

The positive side is driven by `rowSqNormBound`; the wrapper calls the existing
bounded-row variance-proxy control internally. The negative side and the
analytic CFC/Tropp primitives remain explicit.
-/
theorem boundedRowSampleCovariance_operatorNorm_tail_usage
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m (n + 1)) (R Rneg t : Real)
    (hPos : PositiveBoundedRowSampleCovarianceAssumptions (P := P) A R t)
    (hNeg : NegativeBoundedRowSampleCovarianceAssumptions (P := P) A Rneg t) :
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
      hPos.sampleCountPositive
      hPos.randomMatrix
      hPos.coordinateMemLpTwo
      hPos.rowSqNormBound
      hPos.independentCenteredRows
      hPos.squareIntegrable
      hPos.expIntegrable
      hPos.traceExpIntegrable
      hPos.rowBoundPositive
      hPos.deviationPositive
      hPos.cfcPrimitive
      hPos.troppPrimitive
      hNeg.centeredSelfAdjointNeg
      hNeg.independentSelfAdjointNeg
      hNeg.integrableNeg
      hNeg.squareIntegrableNeg
      hNeg.expIntegrableNeg
      hNeg.traceExpIntegrableNeg
      hNeg.operatorNormBoundNeg
      hNeg.rowBoundPositiveNeg
      hNeg.cfcPrimitiveNeg
      hNeg.troppPrimitiveNeg

end

end BoundedRowSampleCovarianceOperatorNormUsage
end RandomMatrix
end Examples
end HighDimProb
