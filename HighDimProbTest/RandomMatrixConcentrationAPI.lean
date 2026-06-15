import HighDimProb.RandomMatrix.ConcentrationStatements
import HighDimProb.RandomMatrix.Laplace

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega}
variable [IsProbabilityMeasure P]
variable {I : Type*} [Fintype I]
variable {m n : Nat}
variable (A : RandomMatrix Omega n n)
variable (B : I -> RandomMatrix Omega n n)
variable (X : RandomMatrix Omega m n)
variable (V : RandomVector Omega n)
variable (M N : Matrix (Fin n) (Fin n) Real)
variable (x : Fin n -> Real)
variable (R theta sigma2 c c1 c2 t bound K : Real)

#check instMeasurableSpaceMatrix
#check IsSymmetricMatrix
#check IsSelfAdjointMatrix
#check RandomSymmetricMatrix
#check RandomSelfAdjointMatrix
#check isSymmetricMatrix_apply
#check randomSymmetricMatrix_apply
#check randomSelfAdjointMatrix_apply
#check matrixQuadraticForm
#check matrixQuadraticForm_sum
#check IsPSDMatrix
#check isPSDMatrix_sum
#check isPSDMatrix_rankOneMatrix
#check RandomPSDMatrix
#check randomPSDMatrix_rankOneRandomMatrix
#check MatrixLE
#check matrixQuadraticForm_apply
#check isPSDMatrix_quadraticForm_nonneg
#check randomPSDMatrix_apply
#check isSymmetricMatrix_sampleCovariance
#check isPSD_sampleCovariance
#check randomPSDMatrix_sampleCovariance
#check matrixExpect
#check IntegrableRandomMatrix
#check centeredRandomMatrix
#check centeredRandomMatrixFamily
#check rankOneRandomMatrixFamily
#check centeredRankOneRandomMatrix
#check centeredRankOneRandomMatrixFamily
#check matrixExpect_apply
#check centeredRandomMatrix_apply
#check centeredRandomMatrixFamily_apply
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
#check matrixQuadraticForm_matrixSquare_eq_matVecSqNorm_of_selfAdjoint
#check isPSD_matrixSquare_of_selfAdjoint
#check matrixQuadraticForm_matrixExpect
#check isPSD_matrixSecondMoment_of_selfAdjoint
#check isPSD_matrixVarianceProxy_of_selfAdjoint
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
#check twoSidedQuadraticFormTailEvent
#check selfAdjointOperatorNormTailViaQuadraticFormStatement
#check matrixLaplaceTransformStatement
#check matrixLaplaceTransformLIntegralStatement
#check matrixChernoffFromTraceExpStatement
#check matrixChernoffFromTraceExpLIntegralStatement
#check selfAdjointOperatorNormLaplaceStatement
#check selfAdjointOperatorNormLaplaceLIntegralStatement
#check matrixBernsteinStatement
#check matrixBernsteinSelfAdjointStatement
#check matrixBernsteinLaplacePrerequisitesStatement
#check matrixExpScaledFamily
#check matrixExpScaledFamily_apply
#check bernsteinSecondMomentComparisonFamily
#check bernsteinSecondMomentComparisonFamily_apply
#check matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives
#check matrixBernsteinTraceMGFToLaplaceContract_statement
#check matrixBernsteinTraceMGFToLaplaceContract_under_primitives_statement
#check matrixBernsteinQuadraticFormUpperTailWithBernsteinCoeff_under_primitives
#check traceMatrixExp_bernsteinMGFCoeff_matrixVarianceProxy_le_card_exp
#check matrixBernsteinQuadraticFormUpperTailScalarRHSWithBernsteinCoeff_under_primitives
#check matrixBernsteinQuadraticFormUpperTailScalarExpRHSWithBernsteinCoeff_under_primitives
#check matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
#check sampleCovarianceCenteredRankOneRadius
#check sampleCovarianceTailTheta
#check sampleCovarianceQuadraticFormTailRHS
#check sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy
#check operatorNorm_eq_spectralRadius_of_selfAdjointStatement
#check HighProbabilityBound
#check highProbabilityBound
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
#check (isPSDMatrix_rankOneMatrix x : IsPSDMatrix (rankOneMatrix x))
#check (randomPSDMatrix_rankOneRandomMatrix
  (P := P) (X := V) :
  RandomPSDMatrix P (rankOneRandomMatrix V))
#check (MatrixLE M N : Prop)
#check (matrixExpect P X : Matrix (Fin m) (Fin n) Real)
#check (IntegrableRandomMatrix P X : Prop)
#check (centeredRandomMatrix P X : RandomMatrix Omega m n)
#check (centeredRandomMatrixFamily P B : I -> RandomMatrix Omega n n)
#check (CenteredRandomSelfAdjointMatrices P B : Prop)
#check (IndependentRandomMatrices P B : Prop)
#check (SelfAdjointRandomMatrixFamily P B : Prop)
#check (IndependentSelfAdjointRandomMatrices P B : Prop)
#check (CenteredSelfAdjointRandomMatrixFamily P B : Prop)
#check (BoundedOperatorNorm A R : Prop)
#check (PointwiseOperatorNormBound B R : Prop)
#check (UniformOperatorNormBound B R : Prop)
#check (AeOperatorNormBound P B R : Prop)
#check (BoundedOperatorNorm_centered_of_bound_expect_bound
  (P := P) (X := A) (R := R) (Rexp := c) :
  BoundedOperatorNorm A R ->
  deterministicOperatorNorm (matrixExpect P A) <= c ->
  BoundedOperatorNorm (centeredRandomMatrix P A) (R + c))
#check (PointwiseOperatorNormBound_centered_of_bound_expect_bound
  (P := P) (X := B) (R := R) (Rexp := c) :
  PointwiseOperatorNormBound B R ->
  (forall i, deterministicOperatorNorm (matrixExpect P (B i)) <= c) ->
  PointwiseOperatorNormBound (centeredRandomMatrixFamily P B) (R + c))
#check (randomMatrixSum B : RandomMatrix Omega n n)
#check (MatrixVarianceProxy P B : Matrix (Fin n) (Fin n) Real)
#check (matrixVarianceProxy P B : Matrix (Fin n) (Fin n) Real)
#check (matrixVarianceProxyNorm P B : Real)
#check (MatrixVarianceProxyBound (MatrixVarianceProxy P B) sigma2 : Prop)
#check (matrixSquare M : Matrix (Fin n) (Fin n) Real)
#check (matrixQuadraticForm_matrixSquare_eq_matVecSqNorm_of_selfAdjoint :
  IsSelfAdjointMatrix M ->
    forall x : Fin n -> Real, matrixQuadraticForm (matrixSquare M) x = matVecSqNorm M x)
#check (isPSD_matrixSquare_of_selfAdjoint :
  IsSelfAdjointMatrix M -> IsPSDMatrix (matrixSquare M))
#check (matrixQuadraticForm_matrixExpect :
  IntegrableRandomMatrix P A ->
    forall x : Fin n -> Real,
      matrixQuadraticForm (matrixExpect P A) x =
        expect P (fun omega => matrixQuadraticForm (A omega) x))
#check (isPSD_matrixSecondMoment_of_selfAdjoint :
  RandomSelfAdjointMatrix P A ->
    IntegrableRandomMatrix P (randomMatrixSquare A) ->
      IsPSDMatrix (matrixSecondMoment P A))
#check (isPSD_matrixVarianceProxy_of_selfAdjoint P :
  (forall i, RandomSelfAdjointMatrix P (B i)) ->
    (forall i, IntegrableRandomMatrix P (randomMatrixSquare (B i))) ->
      IsPSDMatrix (matrixVarianceProxy P B))
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
#check (twoSidedQuadraticFormTailEvent A t : Set Omega)
#check (selfAdjointOperatorNormTailViaQuadraticFormStatement A t : Prop)
#check (matrixLaplaceTransformStatement P A c t : Prop)
#check (matrixLaplaceTransformLIntegralStatement P A c t : Prop)
#check (matrixChernoffFromTraceExpStatement P A c t bound : Prop)
#check (matrixChernoffFromTraceExpLIntegralStatement P A c t
  (ENNReal.ofReal bound) : Prop)
#check (selfAdjointOperatorNormLaplaceStatement P A c t : Prop)
#check (selfAdjointOperatorNormLaplaceLIntegralStatement P A c t : Prop)
#check (matrixBernsteinStatement P B sigma2 R c t : Prop)
#check (matrixBernsteinSelfAdjointStatement P B sigma2 R c1 c2 t : Prop)
#check (matrixBernsteinLaplacePrerequisitesStatement P A c t : Prop)
#check (matrixExpScaledFamily B theta : I -> RandomMatrix Omega n n)
#check (bernsteinSecondMomentComparisonFamily P B theta R :
  I -> Matrix (Fin n) (Fin n) Real)
#check (sampleCovarianceCenteredRankOneRadius R : Real)
#check (sampleCovarianceTailTheta (m := m) R t sigma2 : Real)
#check (sampleCovarianceQuadraticFormTailRHS (m := m) (n := n) R t sigma2 :
  ENNReal)
#check (operatorNorm_eq_spectralRadius_of_selfAdjointStatement M : Prop)
#check (HighProbabilityBound P (Set.univ : Set Omega) 1 : Prop)
#check (highProbabilityBound P (Set.univ : Set Omega) 1 : Prop)
#check (matrixHoeffdingStatement P B R c t : Prop)
#check (matrixChernoffStatement P B R c t : Prop)
#check (covarianceEstimationStatement P X K c t : Prop)
#check (sampleCovarianceOperatorNormStatement P X t bound : Prop)
