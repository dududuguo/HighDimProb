import HighDimProb.RandomMatrix.MatrixBernsteinProvider

open HighDimProb
open MeasureTheory

#check HighDimProb.traceExpIntegrable_randomMatrixSum_of_operatorNormBounds_finiteMeasure
#check HighDimProb.MatrixBernstein.operatorNormTail_of_primitives
#check HighDimProb.MatrixBernstein.operatorNormTail_of_primitives_nonneg
#check HighDimProb.MatrixBernstein.operatorNormUpperTail_of_primitives
#check HighDimProb.MatrixBernstein.optimized_of_primitives
#check HighDimProb.MatrixBernstein.CenteredRankOneInputs
#check HighDimProb.MatrixBernstein.CenteredRankOneExactRowInputs
#check HighDimProb.MatrixBernstein.centeredRankOne
#check HighDimProb.MatrixBernstein.centeredRankOneExactRow
#check HighDimProb.MatrixBernstein.CenteredRankOneInputs.ofIIndepFun
#check HighDimProb.MatrixBernstein.CenteredRankOneExactRowInputs.ofIIndepFun
#check HighDimProb.MatrixBernstein.sampleCovarianceExactRow
#check HighDimProb.MatrixBernstein.sampleCovarianceExactRowHighProbability
#check HighDimProb.MatrixBernstein.highProbability_of_primitives

example
    {Omega I : Type*} [MeasurableSpace Omega] [Nonempty Omega] [Fintype I]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : I -> RandomMatrix Omega n n) (sigmaSq R t : Real) :
    matrixBernsteinSelfAdjointOptimizedStatement (P := P) X sigmaSq R t := by
  exact
    MatrixBernstein.optimized_of_primitives
      (mOmega := inferInstance) (P := P) X sigmaSq R t

example
    {Omega I : Type*} [MeasurableSpace Omega] [Nonempty Omega] [Fintype I]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : I -> RandomMatrix Omega n n) (sigmaSq R delta : Real) :
    matrixBernsteinSelfAdjointHighProbabilityStatement
      (P := P) X sigmaSq R delta := by
  exact
    MatrixBernstein.highProbability_of_primitives
      (mOmega := inferInstance) (P := P) X sigmaSq R delta

/-- The vector-level independence constructor feeds the operator-norm tail
endpoint with no matrix-level independence hypothesis: the caller states only
`iIndepFun` of the underlying random vectors. -/
example
    {Omega I : Type*} [MeasurableSpace Omega] [Nonempty Omega] [Fintype I]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : I -> RandomVector Omega n) (R t : Real) (hn : 0 < n)
    (randomVector : forall i, IsRandomVector P (X i))
    (coordinateMemLpTwo :
      forall i, forall j : Fin n, MemLpRealRandomVariable P (coord (X i) j) 2)
    (sqNormBound : forall i omega, vectorSqNorm (X i omega) <= R)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (radiusNonneg : 0 <= R) (ht : 0 <= t) :
    upperTailProb P
        (operatorNorm
          (randomMatrixSum (centeredRankOneRandomMatrixFamily P X))) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        n (2 * R) (2 * R) t
        (centeredRankOneVarianceProxyNormRHS (I := I) R)
        (centeredRankOneVarianceProxyNormRHS (I := I) R) :=
  MatrixBernstein.centeredRankOne X R t hn
    (MatrixBernstein.CenteredRankOneInputs.ofIIndepFun randomVector
      coordinateMemLpTwo sqNormBound hIndep radiusNonneg) ht
