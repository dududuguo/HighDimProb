import HighDimProb.RandomMatrix.ConcentrationStatements

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega}
variable {I : Type*} [Fintype I]
variable {m n : Nat}
variable (A : RandomMatrix Omega n n)
variable (B : I -> RandomMatrix Omega n n)
variable (X : RandomMatrix Omega m n)
variable (M N : Matrix (Fin n) (Fin n) Real)
variable (x : Fin n -> Real)
variable (R sigma2 c t bound K : Real)

#check instMeasurableSpaceMatrix
#check IsSymmetricMatrix
#check IsSelfAdjointMatrix
#check RandomSymmetricMatrix
#check RandomSelfAdjointMatrix
#check isSymmetricMatrix_apply
#check randomSymmetricMatrix_apply
#check randomSelfAdjointMatrix_apply
#check matrixQuadraticForm
#check IsPSDMatrix
#check RandomPSDMatrix
#check MatrixLE
#check matrixQuadraticForm_apply
#check isPSDMatrix_quadraticForm_nonneg
#check randomPSDMatrix_apply
#check isSymmetricMatrix_sampleCovariance
#check isPSD_sampleCovariance
#check randomPSDMatrix_sampleCovariance
#check matrixExpect
#check centeredRandomMatrix
#check matrixExpect_apply
#check centeredRandomMatrix_apply
#check CenteredRandomSelfAdjointMatrices
#check IndependentRandomMatrices
#check SelfAdjointRandomMatrixFamily
#check IndependentSelfAdjointRandomMatrices
#check CenteredSelfAdjointRandomMatrixFamily
#check BoundedOperatorNorm
#check PointwiseOperatorNormBound
#check UniformOperatorNormBound
#check AeOperatorNormBound
#check randomMatrixSum
#check randomMatrixSum_apply
#check isRandomMatrix_sum
#check MatrixVarianceProxy
#check matrixVarianceProxy
#check matrixVarianceProxyNorm
#check MatrixVarianceProxyBound
#check matrixSquare
#check randomMatrixSquare
#check matrixSecondMoment
#check matrixVarianceProxyBound
#check deterministicMatrixVarianceProxyNorm
#check isSelfAdjointMatrix_matrixSquare_of_isSelfAdjointMatrix
#check sampleCovarianceMinusIdentity
#check IsUnitVector
#check unitSphere
#check OperatorNormBoundSq
#check operatorNormBoundSq_of_operatorNorm_le
#check operatorNorm_le_of_operatorNormBoundSq
#check isRealRandomVariable_operatorNorm
#check operatorNormMeasurabilityStatement
#check quadraticForm_le_of_matrixLE
#check sampleCovarianceQuadraticFormDeviation
#check sampleCovarianceOperatorNormViaUnitSphereStatement
#check matrixBernsteinStatement
#check matrixHoeffdingStatement
#check matrixChernoffStatement
#check covarianceEstimationStatement
#check sampleCovarianceOperatorNormStatement

#check (IsSymmetricMatrix M : Prop)
#check (IsSelfAdjointMatrix M : Prop)
#check (RandomSymmetricMatrix P A : Prop)
#check (RandomSelfAdjointMatrix P A : Prop)
#check (matrixQuadraticForm M x : Real)
#check (IsPSDMatrix M : Prop)
#check (RandomPSDMatrix P A : Prop)
#check (MatrixLE M N : Prop)
#check (matrixExpect P X : Matrix (Fin m) (Fin n) Real)
#check (centeredRandomMatrix P X : RandomMatrix Omega m n)
#check (CenteredRandomSelfAdjointMatrices P B : Prop)
#check (IndependentRandomMatrices P B : Prop)
#check (SelfAdjointRandomMatrixFamily P B : Prop)
#check (IndependentSelfAdjointRandomMatrices P B : Prop)
#check (CenteredSelfAdjointRandomMatrixFamily P B : Prop)
#check (BoundedOperatorNorm A R : Prop)
#check (PointwiseOperatorNormBound B R : Prop)
#check (UniformOperatorNormBound B R : Prop)
#check (AeOperatorNormBound P B R : Prop)
#check (randomMatrixSum B : RandomMatrix Omega n n)
#check (MatrixVarianceProxy P B : Matrix (Fin n) (Fin n) Real)
#check (matrixVarianceProxy P B : Matrix (Fin n) (Fin n) Real)
#check (matrixVarianceProxyNorm P B : Real)
#check (MatrixVarianceProxyBound (MatrixVarianceProxy P B) sigma2 : Prop)
#check (matrixSquare M : Matrix (Fin n) (Fin n) Real)
#check (randomMatrixSquare A : RandomMatrix Omega n n)
#check (matrixSecondMoment P A : Matrix (Fin n) (Fin n) Real)
#check (deterministicMatrixVarianceProxyNorm M : Real)
#check (sampleCovarianceMinusIdentity X : RandomMatrix Omega n n)
#check (IsUnitVector x : Prop)
#check (unitSphere n : Set (Fin n -> Real))
#check (OperatorNormBoundSq M R : Prop)
#check (operatorNormBoundSq_of_operatorNorm_le (A := M) (L := R) :
  0 <= R -> deterministicOperatorNorm M <= R -> OperatorNormBoundSq M R)
#check (operatorNorm_le_of_operatorNormBoundSq (A := M) (L := R) :
  OperatorNormBoundSq M R -> deterministicOperatorNorm M <= R)
#check (operatorNormMeasurabilityStatement P X : Prop)
#check (sampleCovarianceQuadraticFormDeviation X x : RealRandomVariable Omega)
#check (sampleCovarianceOperatorNormViaUnitSphereStatement P X t bound : Prop)
#check (matrixBernsteinStatement P B sigma2 R c t : Prop)
#check (matrixHoeffdingStatement P B R c t : Prop)
#check (matrixChernoffStatement P B R c t : Prop)
#check (covarianceEstimationStatement P X K c t : Prop)
#check (sampleCovarianceOperatorNormStatement P X t bound : Prop)
