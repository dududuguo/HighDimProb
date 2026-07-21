import HighDimProb.RandomMatrix.FeatureGramOperator

open MeasureTheory
open HighDimProb
open scoped BigOperators Matrix.Norms.L2Operator MatrixOrder

#check FeatureGramOperator.Inputs
#check FeatureGramOperator.Inputs.ofIIndepFun
#check FeatureGramOperator.centeredSummands
#check FeatureGramOperator.empirical
#check FeatureGramOperator.population
#check FeatureGramOperator.deviation
#check FeatureGramOperator.empirical_sub_population
#check FeatureGramOperator.normalizedTail
#check FeatureGramOperator.radius
#check FeatureGramOperator.highProbability
#check FeatureGramOperator.deviation_selfAdjoint
#check FeatureGramOperator.matrixLESandwich

example {Omega I : Type*} [MeasurableSpace Omega] [Nonempty Omega] [Fintype I]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    [StandardBorelSpace (Matrix (Fin (n + 1)) (Fin (n + 1)) Real)]
    (X : I -> RandomVector Omega (n + 1)) (R t : Real)
    (Rvar : I -> Real)
    (h : FeatureGramOperator.Inputs (P := P) X R Rvar) (ht : 0 <= t) :
    upperTailProb P
        (operatorNorm
          (randomMatrixSum
            (FeatureGramOperator.centeredSummands (P := P) X))) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        (n + 1) (2 * R) (2 * R) t
        (rowSqNormVarianceProxyNormRHS Rvar)
        (rowSqNormVarianceProxyNormRHS Rvar) :=
  FeatureGramOperator.operatorNormTail X R t Rvar h ht

example {Omega I : Type*} [MeasurableSpace Omega] [Nonempty Omega] [Fintype I]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    [StandardBorelSpace (Matrix (Fin (n + 1)) (Fin (n + 1)) Real)]
    (X : I -> RandomVector Omega (n + 1)) (R delta : Real)
    (Rvar : I -> Real)
    (h : FeatureGramOperator.Inputs (P := P) X R Rvar)
    (hCard : 0 < Fintype.card I)
    (hNondegenerate :
      Or (0 < rowSqNormVarianceProxyNormRHS Rvar) (0 < 2 * R))
    (hdelta : 0 < delta) (hdeltaOne : delta <= 1) :
    upperTailProb P
        (operatorNorm (FeatureGramOperator.deviation (P := P) X))
        (FeatureGramOperator.radius Rvar R delta n) <= ENNReal.ofReal delta :=
  FeatureGramOperator.highProbability X R delta Rvar h hCard hNondegenerate
    hdelta hdeltaOne
