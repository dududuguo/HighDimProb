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
variable (R sigma2 c t : Real)
variable (hA : forall i, IsRandomMatrix P (A i))
variable (hX : IsRandomMatrix P X)
variable (hSA : forall i, RandomSelfAdjointMatrix P (A i))
variable (hM : IsSelfAdjointMatrix M)

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
#check BoundedOperatorNorm
#check PointwiseOperatorNormBound
#check UniformOperatorNormBound
#check AeOperatorNormBound
#check matrixSquare
#check matrixSquare_apply
#check randomMatrixSquare
#check randomMatrixSquare_apply
#check isRandomMatrix_matrixSquare
#check matrixSecondMoment
#check matrixSecondMoment_apply
#check matrixVarianceProxy
#check matrixVarianceProxy_apply
#check MatrixVarianceProxy
#check matrixVarianceProxyBound
#check MatrixVarianceProxyBound
#check deterministicMatrixVarianceProxyNorm
#check deterministicMatrixVarianceProxyNorm_apply
#check matrixVarianceProxyNorm
#check matrixVarianceProxyNorm_apply
#check isSelfAdjointMatrix_matrixSquare_of_isSelfAdjointMatrix
#check matrixBernsteinStatement

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
#check (deterministicMatrixVarianceProxyNorm V : Real)
#check (matrixVarianceProxyNorm P A : Real)
#check (isSelfAdjointMatrix_matrixSquare_of_isSelfAdjointMatrix hM :
  IsSelfAdjointMatrix (matrixSquare M))
#check (matrixBernsteinStatement P A sigma2 R c t : Prop)
