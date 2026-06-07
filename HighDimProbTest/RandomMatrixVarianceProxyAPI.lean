import HighDimProb.RandomMatrix.ConcentrationStatements

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega}
variable {I : Type*} [Fintype I]
variable {m n : Nat}
variable (A : I -> RandomMatrix Omega n n)
variable (X : RandomMatrix Omega n n)
variable (Y : RandomMatrix Omega m n)
variable (M V : Matrix (Fin n) (Fin n) Real)
variable (i : I)
variable (omega : Omega)
variable (r cidx : Fin n)
variable (R sigma2 c theta t : Real)
variable (hA : forall i, IsRandomMatrix P (A i))
variable (hX : IsRandomMatrix P X)
variable (hSA : forall i, RandomSelfAdjointMatrix P (A i))
variable (hM : IsSelfAdjointMatrix M)
variable (hXSA : RandomSelfAdjointMatrix P X)
variable (hXsqInt : IntegrableRandomMatrix P (randomMatrixSquare X))
variable (hAsqInt : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i)))

#check randomMatrixSum
#check randomMatrixSum_apply
#check randomMatrixSum_entry
#check isRandomMatrix_sum
#check isSelfAdjointMatrix_sum
#check randomSelfAdjointMatrix_sum
#check IndependentRandomMatrices
#check SelfAdjointRandomMatrixFamily
#check IndependentSelfAdjointRandomMatrices
#check CenteredSelfAdjointRandomMatrixFamily
#check CenteredRandomSelfAdjointMatrices
#check IntegrableRandomMatrix
#check BoundedOperatorNorm
#check PointwiseOperatorNormBound
#check UniformOperatorNormBound
#check AeOperatorNormBound
#check matrixSquare
#check matrixSquare_apply
#check matrixQuadraticForm_sum
#check isPSDMatrix_sum
#check randomMatrixSquare
#check randomMatrixSquare_apply
#check isRandomMatrix_matrixSquare
#check matrixQuadraticForm_matrixExpect
#check matrixSecondMoment
#check matrixSecondMoment_apply
#check matrixVarianceProxy
#check matrixVarianceProxy_apply
#check MatrixVarianceProxy
#check matrixVarianceProxyBound
#check MatrixVarianceProxyBound
#check MatrixVarianceProxyUpperBound
#check deterministicMatrixVarianceProxyNorm
#check deterministicMatrixVarianceProxyNorm_apply
#check matrixVarianceProxyNorm
#check matrixVarianceProxyNorm_apply
#check MatrixVarianceProxyNormBound
#check isSelfAdjointMatrix_matrixSquare_of_isSelfAdjointMatrix
#check matrixQuadraticForm_matrixSquare_eq_matVecSqNorm_of_selfAdjoint
#check isPSD_matrixSquare_of_selfAdjoint
#check isPSD_matrixSquare_of_selfAdjoint_statement
#check isSelfAdjointMatrix_matrixSecondMoment
#check isPSD_matrixSecondMoment_of_selfAdjoint
#check isPSD_matrixSecondMoment_of_selfAdjoint_statement
#check isSelfAdjointMatrix_matrixVarianceProxy
#check isPSD_matrixVarianceProxy_of_selfAdjoint
#check isPSD_matrixVarianceProxy_of_selfAdjoint_statement
#check matrixBernsteinStatement
#check matrixBernsteinTraceMGF_statement

#check (randomMatrixSum A : RandomMatrix Omega n n)
#check (randomMatrixSum A omega : Matrix (Fin n) (Fin n) Real)
#check (randomMatrixSum_entry A omega r cidx :
  randomMatrixSum A omega r cidx = Finset.univ.sum fun i : I => A i omega r cidx)
#check (isRandomMatrix_sum (A := A) hA :
  IsRandomMatrix P (randomMatrixSum A))
#check (randomSelfAdjointMatrix_sum (A := A) hSA :
  RandomSelfAdjointMatrix P (randomMatrixSum A))
#check (IndependentRandomMatrices P A : Prop)
#check (SelfAdjointRandomMatrixFamily P A : Prop)
#check (IndependentSelfAdjointRandomMatrices P A : Prop)
#check (CenteredSelfAdjointRandomMatrixFamily P A : Prop)
#check (CenteredRandomSelfAdjointMatrices P A : Prop)
#check (IntegrableRandomMatrix P X : Prop)
#check (BoundedOperatorNorm X R : Prop)
#check (PointwiseOperatorNormBound A R : Prop)
#check (UniformOperatorNormBound A R : Prop)
#check (AeOperatorNormBound P A R : Prop)
#check (matrixSquare M : Matrix (Fin n) (Fin n) Real)
#check (randomMatrixSquare X : RandomMatrix Omega n n)
#check (isRandomMatrix_matrixSquare hX :
  IsRandomMatrix P (randomMatrixSquare X))
#check (matrixSecondMoment P X : Matrix (Fin n) (Fin n) Real)
#check (matrixVarianceProxy P A : Matrix (Fin n) (Fin n) Real)
#check (MatrixVarianceProxy P A : Matrix (Fin n) (Fin n) Real)
#check (matrixVarianceProxyBound V sigma2 : Prop)
#check (MatrixVarianceProxyBound V sigma2 : Prop)
#check (MatrixVarianceProxyUpperBound P A V : Prop)
#check (deterministicMatrixVarianceProxyNorm V : Real)
#check (matrixVarianceProxyNorm P A : Real)
#check (MatrixVarianceProxyNormBound P A sigma2 : Prop)
#check (isSelfAdjointMatrix_matrixSquare_of_isSelfAdjointMatrix hM :
  IsSelfAdjointMatrix (matrixSquare M))
#check (matrixQuadraticForm_matrixSquare_eq_matVecSqNorm_of_selfAdjoint hM :
  forall x : Fin n -> Real, matrixQuadraticForm (matrixSquare M) x = matVecSqNorm M x)
#check (isPSD_matrixSquare_of_selfAdjoint hM :
  IsPSDMatrix (matrixSquare M))
#check (isPSD_matrixSquare_of_selfAdjoint_statement hM : Prop)
#check (matrixQuadraticForm_matrixExpect hXsqInt :
  forall x : Fin n -> Real,
    matrixQuadraticForm (matrixExpect P (randomMatrixSquare X)) x =
      expect P (fun omega => matrixQuadraticForm (randomMatrixSquare X omega) x))
#check (isPSD_matrixSecondMoment_of_selfAdjoint hXSA hXsqInt :
  IsPSDMatrix (matrixSecondMoment P X))
#check (isPSD_matrixVarianceProxy_of_selfAdjoint P hSA hAsqInt :
  IsPSDMatrix (matrixVarianceProxy P A))
#check (matrixBernsteinStatement P A sigma2 R c t : Prop)
#check (matrixBernsteinTraceMGF_statement P A theta : Prop)

example : MatrixVarianceProxyUpperBound P A V =
    MatrixLE (matrixVarianceProxy P A) V := by
  rfl

example : MatrixVarianceProxyNormBound P A sigma2 =
    (matrixVarianceProxyNorm P A <= sigma2) := by
  rfl
