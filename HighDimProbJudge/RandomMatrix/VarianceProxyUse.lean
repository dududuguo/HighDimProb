import HighDimProb.RandomMatrix

#check HighDimProb.matrixSquare
#check HighDimProb.randomMatrixSquare
#check HighDimProb.isRandomMatrix_matrixSquare
#check HighDimProb.matrixSecondMoment
#check HighDimProb.matrixVarianceProxy
#check HighDimProb.MatrixVarianceProxy
#check HighDimProb.matrixVarianceProxyBound
#check HighDimProb.MatrixVarianceProxyBound
#check HighDimProb.deterministicMatrixVarianceProxyNorm
#check HighDimProb.matrixVarianceProxyNorm
#check HighDimProb.isSelfAdjointMatrix_matrixSquare_of_isSelfAdjointMatrix
#check HighDimProb.isSelfAdjointMatrix_matrixSecondMoment
#check HighDimProb.isSelfAdjointMatrix_matrixVarianceProxy
#check HighDimProb.isPSD_matrixSquare_of_selfAdjoint_statement
#check HighDimProb.isPSD_matrixSecondMoment_of_selfAdjoint_statement
#check HighDimProb.isPSD_matrixVarianceProxy_of_selfAdjoint_statement
#check HighDimProb.matrixBernsteinStatement

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} {n : Nat}
    {A : HighDimProb.RandomMatrix Omega n n}
    (hA : HighDimProb.RandomSelfAdjointMatrix P A) :
    HighDimProb.IsSelfAdjointMatrix
      (HighDimProb.matrixSecondMoment P A) := by
  exact HighDimProb.isSelfAdjointMatrix_matrixSecondMoment hA

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {P : MeasureTheory.Measure Omega} {n : Nat}
    {A : I -> HighDimProb.RandomMatrix Omega n n}
    (hA : forall i, HighDimProb.RandomSelfAdjointMatrix P (A i)) :
    HighDimProb.IsSelfAdjointMatrix
      (HighDimProb.matrixVarianceProxy P A) := by
  exact HighDimProb.isSelfAdjointMatrix_matrixVarianceProxy P hA
