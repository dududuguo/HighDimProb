import HighDimProb.RandomMatrix.Concentration

open HighDimProb MeasureTheory
open MeasureTheory

set_option autoImplicit false

#check HighDimProb.MatrixBernstein.CenteredRankOneInputs.ofIIndepFun
#check HighDimProb.MatrixBernstein.CenteredRankOneExactRowInputs.ofIIndepFun
#check HighDimProb.upperTailProb_operatorNorm_smul_one_div_natCast
#check HighDimProb.iIndepFun_centeredRandomMatrix
#check HighDimProb.MatrixBernstein.CenteredSelfAdjointObservationInputs
#check HighDimProb.MatrixBernstein.CenteredSelfAdjointObservationInputs.ofIIndepFun
#check HighDimProb.MatrixBernstein.centeredSelfAdjointObservations
#check HighDimProb.MatrixBernstein.centeredSelfAdjointObservationsHighProbability

/-- Build exact-row centered rank-one inputs from vector-level independence. -/
example
    {Omega I : Type*} [MeasurableSpace Omega] [Nonempty Omega] [Fintype I]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : I -> RandomVector Omega n) (R t : Real) (Rvar : I -> Real) (hn : 0 < n)
    (randomVector : forall i, IsRandomVector P (X i))
    (coordinateMemLpTwo :
      forall i, forall j : Fin n, MemLpRealRandomVariable P (coord (X i) j) 2)
    (sqNormBound : forall i omega, vectorSqNorm (X i omega) <= R)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (radiusNonneg : 0 <= R)
    (varianceSqNormBound : forall i omega, vectorSqNorm (X i omega) <= Rvar i)
    (varianceRadiiNonneg : forall i, 0 <= Rvar i)
    (ht : 0 <= t) :
    upperTailProb P
        (operatorNorm
          (randomMatrixSum (centeredRankOneRandomMatrixFamily P X))) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        n (2 * R) (2 * R) t
        (rowSqNormVarianceProxyNormRHS Rvar)
        (rowSqNormVarianceProxyNormRHS Rvar) :=
  MatrixBernstein.centeredRankOneExactRow X R t Rvar hn
    (MatrixBernstein.CenteredRankOneExactRowInputs.ofIIndepFun
      randomVector coordinateMemLpTwo sqNormBound hIndep radiusNonneg
      varianceSqNormBound varianceRadiiNonneg) ht

/-- Build the generic centered self-adjoint route from observation independence. -/
example
    {Omega I : Type*} [MeasurableSpace Omega] [Nonempty Omega] [Fintype I]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : I -> RandomMatrix Omega n n) (R sigmaSq t : Real) (hn : 0 < n)
    (selfAdjoint : SelfAdjointRandomMatrixFamily P X)
    (integrable : forall i, IntegrableRandomMatrix P (X i))
    (centeredSquareIntegrable :
      forall i, IntegrableRandomMatrix P
        (randomMatrixSquare (centeredRandomMatrixFamily P X i)))
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (centeredOperatorNormBound :
      PointwiseOperatorNormBound (centeredRandomMatrixFamily P X) R)
    (centeredVarianceProxyBound :
      MatrixVarianceProxyNormBound P (centeredRandomMatrixFamily P X) sigmaSq)
    (radiusNonneg : 0 <= R) (varianceNonneg : 0 <= sigmaSq) (ht : 0 <= t) :
    upperTailProb P
        (operatorNorm (randomMatrixSum (centeredRandomMatrixFamily P X))) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS n R R t sigmaSq sigmaSq :=
  MatrixBernstein.centeredSelfAdjointObservations X R sigmaSq t hn
    (MatrixBernstein.CenteredSelfAdjointObservationInputs.ofIIndepFun
      selfAdjoint integrable centeredSquareIntegrable hIndep
      centeredOperatorNormBound centeredVarianceProxyBound radiusNonneg
      varianceNonneg) ht
