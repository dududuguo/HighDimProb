import HighDimProb.RandomMatrix.MatrixBernsteinProvider

open HighDimProb
open MeasureTheory

#check HighDimProb.traceExpIntegrable_randomMatrixSum_of_operatorNormBounds_finiteMeasure
#check HighDimProb.MatrixBernstein.operatorNormTail_of_primitives
#check HighDimProb.MatrixBernstein.operatorNormTail_of_primitives_nonneg
#check HighDimProb.MatrixBernstein.operatorNormUpperTail_of_primitives
#check HighDimProb.MatrixBernstein.optimized_of_primitives
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
