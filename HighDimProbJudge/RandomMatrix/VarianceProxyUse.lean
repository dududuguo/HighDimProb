import HighDimProb.RandomMatrix

#check HighDimProb.matrixSquare
#check HighDimProb.randomMatrixSquare
#check HighDimProb.isRandomMatrix_matrixSquare
#check HighDimProb.matrixSecondMoment
#check HighDimProb.matrixVarianceProxy
#check HighDimProb.MatrixVarianceProxy
#check HighDimProb.matrixVarianceProxyBound
#check HighDimProb.MatrixVarianceProxyBound
#check HighDimProb.MatrixVarianceProxyUpperBound
#check HighDimProb.deterministicMatrixVarianceProxyNorm
#check HighDimProb.matrixVarianceProxyNorm
#check HighDimProb.MatrixVarianceProxyNormBound
#check HighDimProb.matrixQuadraticForm_sum
#check HighDimProb.isPSDMatrix_sum
#check HighDimProb.isSelfAdjointMatrix_matrixSquare_of_isSelfAdjointMatrix
#check HighDimProb.matrixQuadraticForm_matrixSquare_eq_matVecSqNorm_of_selfAdjoint
#check HighDimProb.isPSD_matrixSquare_of_selfAdjoint
#check HighDimProb.matrixQuadraticForm_matrixExpect
#check HighDimProb.isSelfAdjointMatrix_matrixSecondMoment
#check HighDimProb.isPSD_matrixSecondMoment_of_selfAdjoint
#check HighDimProb.isSelfAdjointMatrix_matrixVarianceProxy
#check HighDimProb.isPSD_matrixVarianceProxy_of_selfAdjoint
#check HighDimProb.isPSD_matrixSquare_of_selfAdjoint_statement
#check HighDimProb.isPSD_matrixSecondMoment_of_selfAdjoint_statement
#check HighDimProb.isPSD_matrixVarianceProxy_of_selfAdjoint_statement
#check HighDimProb.matrixBernsteinStatement
#check HighDimProb.matrixBernsteinTraceMGF_statement

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} {n : Nat}
    {A : HighDimProb.RandomMatrix Omega n n}
    (hA : HighDimProb.RandomSelfAdjointMatrix P A) :
    HighDimProb.IsSelfAdjointMatrix
      (HighDimProb.matrixSecondMoment P A) := by
  exact HighDimProb.isSelfAdjointMatrix_matrixSecondMoment hA

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} {n : Nat}
    {A : HighDimProb.RandomMatrix Omega n n}
    (hA : HighDimProb.RandomSelfAdjointMatrix P A)
    (hInt : HighDimProb.IntegrableRandomMatrix P (HighDimProb.randomMatrixSquare A)) :
    HighDimProb.IsPSDMatrix
      (HighDimProb.matrixSecondMoment P A) := by
  exact HighDimProb.isPSD_matrixSecondMoment_of_selfAdjoint hA hInt

example {n : Nat} {M : Matrix (Fin n) (Fin n) Real}
    (hM : HighDimProb.IsSelfAdjointMatrix M) :
    HighDimProb.IsPSDMatrix (HighDimProb.matrixSquare M) := by
  exact HighDimProb.isPSD_matrixSquare_of_selfAdjoint hM

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {P : MeasureTheory.Measure Omega} {n : Nat}
    {A : I -> HighDimProb.RandomMatrix Omega n n}
    (hA : forall i, HighDimProb.RandomSelfAdjointMatrix P (A i)) :
    HighDimProb.IsSelfAdjointMatrix
      (HighDimProb.matrixVarianceProxy P A) := by
  exact HighDimProb.isSelfAdjointMatrix_matrixVarianceProxy P hA

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {P : MeasureTheory.Measure Omega} {n : Nat}
    {A : I -> HighDimProb.RandomMatrix Omega n n}
    (hA : forall i, HighDimProb.RandomSelfAdjointMatrix P (A i))
    (hInt : forall i, HighDimProb.IntegrableRandomMatrix P
      (HighDimProb.randomMatrixSquare (A i))) :
    HighDimProb.IsPSDMatrix
      (HighDimProb.matrixVarianceProxy P A) := by
  exact HighDimProb.isPSD_matrixVarianceProxy_of_selfAdjoint P hA hInt

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {P : MeasureTheory.Measure Omega} {n : Nat}
    (A : I -> HighDimProb.RandomMatrix Omega n n)
    (V : Matrix (Fin n) (Fin n) Real) : Prop :=
  HighDimProb.MatrixVarianceProxyUpperBound P A V

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {P : MeasureTheory.Measure Omega} {n : Nat}
    (A : I -> HighDimProb.RandomMatrix Omega n n)
    (sigma2 : Real) : Prop :=
  HighDimProb.MatrixVarianceProxyNormBound P A sigma2
