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
#check rankOneMatrixSum
#check rankOneMatrix_quadraticForm_eq_inner_sq
#check rankOneMatrix_mulVec_eq_zero_iff_inner_eq_zero
#check rankOneSum_mulVec_eq_zero_of_forall_inner_eq_zero
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
#check matrixBernsteinSelfAdjointOptimizedStatement

example
    {Omega I : Type*} [MeasurableSpace Omega] [Nonempty Omega] [Fintype I]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (A : I -> RandomMatrix Omega n n) (sigmaSq R t : Real) : Prop :=
  matrixBernsteinSelfAdjointOptimizedStatement (P := P) A sigmaSq R t

#check matrixBernsteinLaplacePrerequisitesStatement
#check matrixExpScaledFamily
#check matrixExpScaledFamily_apply
#check matrixExpScaledFamily_negRandomMatrixFamily
#check integrableRandomMatrix_matrixExpScaledFamily_negRandomMatrixFamily
#check randomMatrixSum_negRandomMatrixFamily
#check traceExpIntegrand_randomMatrixSum_negRandomMatrixFamily
#check integrableRealRandomVariable_traceExpIntegrand_randomMatrixSum_negRandomMatrixFamily
#check matrixSecondMoment_negRandomMatrixFamily
#check matrixVarianceProxy_negRandomMatrixFamily
#check bernsteinSecondMomentComparisonFamily
#check bernsteinSecondMomentComparisonFamily_apply
#check bernsteinSecondMomentComparisonFamily_negRandomMatrixFamily
#check bernsteinMGFComparison_negRandomMatrixFamily
#check traceMGFBernsteinVarianceProxyBound_negRandomMatrixFamily
#check matrixBernsteinTraceMGFWithBernsteinCoeff_negRandomMatrixFamily
#check matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives
#check HighDimProb.matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge
#check HighDimProb.MatrixBernsteinConditioningTraceMGFTailAssumptions
#check HighDimProb.matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFTailAssumptions
#check matrixBernsteinTraceMGF_under_tropp
#check matrixBernsteinTraceMGFToLaplaceContract_statement
#check matrixBernsteinTraceMGFToLaplaceContract_under_primitives_statement
#check matrixBernsteinQuadraticFormUpperTailWithBernsteinCoeff_under_primitives
#check matrixBernsteinQuadTail_trace_under_tropp
#check traceMatrixExp_bernsteinMGFCoeff_matrixVarianceProxy_le_card_exp
#check matrixBernsteinQuadraticFormUpperTailScalarRHSWithBernsteinCoeff_under_primitives
#check matrixBernsteinQuadraticFormUpperTailScalarExpRHSWithBernsteinCoeff_under_primitives
#check matrixBernsteinQuadTail_scalar_under_tropp
#check matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
#check matrixBernsteinQuadTail_opt_under_tropp
#check matrixBernsteinOptimizedScalarTailRHS
#check matrixBernsteinTwoSidedOptimizedScalarTailRHS
#check matrixBernsteinTwoSidedOptimizedScalarTailRHS_sameParameters
#check one_le_matrixBernsteinTwoSidedOptimizedScalarTailRHS_zero
#check matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions
#check matrixBernsteinQuadTail_opt_of_tropp
#check matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
#check matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
#check matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_nonempty_under_primitives
#check matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_pos_under_primitives
#check MatrixBernsteinPositiveSideAssumptions
#check MatrixBernsteinNegativeSideAssumptions
#check MatrixBernsteinPositiveSideTroppAssumptions
#check MatrixBernsteinNegativeSideTroppAssumptions
#check MatrixBernsteinPositiveSideTroppAssumptions.toPositiveSideAssumptions
#check MatrixBernsteinNegativeSideTroppAssumptions.toNegativeSideAssumptions
#check matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions
#check matrixBernsteinQuadTail_twoSided_opt_of_tropp
#check matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_assumptions
#check matrixBernsteinOpNormTail_opt_of_tropp
#check sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum
#check sampleCovarianceCenteredRankOneRadius
#check sampleCovarianceCenteredRankOneVarianceProxyBound
#check sampleCovarianceCenteredRankOneVarianceProxyBound_pos
#check sampleCovarianceCenteredRankOneVarianceProxyBoundOfRows
#check sampleCovarianceCenteredRankOneVarianceProxyBoundOfRows_pos
#check MatrixVarianceProxyNormBound_centeredSampleCovarianceRowRankOneFamily_of_rowSqNorm_bound
#check sampleCovarianceTailTheta
#check sampleCovarianceTailThetaOfRows
#check sampleCovarianceQuadraticFormTailRHS
#check SampleCovarianceTailTarget
#check SampleCovarianceTailTarget.event
#check SampleCovarianceTailTarget.rhs
#check SampleCovarianceBoundedRowTroppAssumptions
#check sampleCovariance_tail_optimized_under_boundedRowTroppAssumptions
#check sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy
#check sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy_of_troppPrimitive
#check sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound
#check sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound_of_troppPrimitive
#check sampleCovariance_quadraticForm_tail_optimized_under_exactRowSqNorm_bound_of_troppPrimitive
#check sampleCovariance_quadraticForm_tail_optimized_under_exactRowSqNorm_bound_of_centeredSquareChain_of_troppPrimitive
#check SampleCovarianceExactRowCenteredSquareTroppAssumptions
#check sampleCovariance_quadTail_centeredSq_exactRow_of_tropp
#check sampleCovariance_selfAdjointOperatorNorm_tail_optimized_under_explicit_variance_proxy
#check sampleCovariance_selfAdjointOperatorNorm_tail_optimized_nonempty_under_explicit_variance_proxy
#check sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_explicit_variance_proxy
#check sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound
#check sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_adapters
#check sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_adapters_of_troppPrimitives
#check sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_square_adapters
#check sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_square_adapters_of_troppPrimitives
#check sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_exactRowSqNorm_bound_with_neg_square_adapters_of_troppPrimitives
#check sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_exactRowSqNorm_bound_with_neg_square_adapters_of_centeredSquareChain_of_troppPrimitives
#check SampleCovarianceExactRowCenteredSquareTwoSidedTroppAssumptions
#check sampleCovariance_opNormTail_centeredSq_exactRow_of_tropp
#check centeredSampleCovarianceRowRankOneFamilyNeg
#check centeredSampleCovarianceRowRankOneSumNeg
#check isRandomMatrix_negRandomMatrixFamily
#check integrableRandomMatrix_negRandomMatrixFamily
#check selfAdjointRandomMatrixFamily_negRandomMatrixFamily
#check centeredSelfAdjointRandomMatrixFamily_negRandomMatrixFamily
#check independentRandomMatrices_negRandomMatrixFamily
#check independentSelfAdjointRandomMatrices_negRandomMatrixFamily
#check PointwiseOperatorNormBound_negRandomMatrixFamily
#check randomMatrixSquare_negRandomMatrixFamily
#check integrableRandomMatrix_randomMatrixSquare_negRandomMatrixFamily
#check centeredSampleCovarianceRowRankOneFamilyNeg_integrable_of_memLp_two
#check centeredSampleCovarianceRowRankOneFamilyNeg_centeredSelfAdjoint_of_memLp_two
#check PointwiseOperatorNormBound_centeredSampleCovarianceRowRankOneFamilyNeg_of_rowSqNorm_bound
#check centeredSampleCovarianceRowRankOneFamilyNeg_squareIntegrable_of_squareIntegrable
#check centeredSampleCovarianceRowRankOneFamilyNeg_expIntegrable_of_expIntegrable_neg_theta
#check centeredSampleCovarianceRowRankOneSumNeg_traceExpIntegrable_of_traceExpIntegrable_neg_theta
#check centeredSampleCovarianceRowRankOneFamilyNeg_cfcPrimitive_of_cfcPrimitive_neg_theta
#check MatrixVarianceProxyNormBound_centeredSampleCovarianceRowRankOneFamilyNeg_of_exactRowSqNorm_bound_memLp_two
#check operatorNorm_eq_spectralRadius_of_selfAdjointStatement
#check HighProbabilityBound
#check highProbabilityBound
#check matrixBernsteinLogFactor
#check matrixBernsteinHighProbabilityThreshold
#check matrixBernsteinLogFactor_pos
#check matrixBernsteinHighProbabilityThreshold_nonneg
#check matrixBernsteinTwoSidedOptimizedScalarTailRHS_highProbabilityThreshold
#check matrixBernsteinSelfAdjointHighProbabilityStatement
#check matrixBernsteinSelfAdjointHighProbabilityStatement_of_optimizedStatement
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
#check (matrixExpScaledFamily_negRandomMatrixFamily B theta :
  forall i,
    matrixExpScaledFamily (negRandomMatrixFamily B) theta i =
      matrixExpScaledFamily B (-theta) i)
#check (integrableRandomMatrix_matrixExpScaledFamily_negRandomMatrixFamily
    (P := P) (A := B) (theta := theta) :
  (forall i, IntegrableRandomMatrix P (matrixExpScaledFamily B (-theta) i)) ->
    forall i,
      IntegrableRandomMatrix P
        (matrixExpScaledFamily (negRandomMatrixFamily B) theta i))
#check (randomMatrixSum_negRandomMatrixFamily B :
  randomMatrixSum (negRandomMatrixFamily B) =
    negRandomMatrix (randomMatrixSum B))
#check (traceExpIntegrand_randomMatrixSum_negRandomMatrixFamily B theta :
  traceExpIntegrand (randomMatrixSum (negRandomMatrixFamily B)) theta =
    traceExpIntegrand (randomMatrixSum B) (-theta))
#check (integrableRealRandomVariable_traceExpIntegrand_randomMatrixSum_negRandomMatrixFamily
    (P := P) (A := B) (theta := theta) :
  IntegrableRealRandomVariable P
      (traceExpIntegrand (randomMatrixSum B) (-theta)) ->
    IntegrableRealRandomVariable P
      (traceExpIntegrand (randomMatrixSum (negRandomMatrixFamily B)) theta))
#check (matrixSecondMoment_negRandomMatrixFamily (P := P) B :
  forall i,
    matrixSecondMoment P (negRandomMatrixFamily B i) =
      matrixSecondMoment P (B i))
#check (matrixVarianceProxy_negRandomMatrixFamily (P := P) B :
  matrixVarianceProxy P (negRandomMatrixFamily B) =
    matrixVarianceProxy P B)
#check (bernsteinSecondMomentComparisonFamily P B theta R :
  I -> Matrix (Fin n) (Fin n) Real)
#check (bernsteinSecondMomentComparisonFamily_negRandomMatrixFamily
    (P := P) B theta R :
  forall i,
    bernsteinSecondMomentComparisonFamily P (negRandomMatrixFamily B) theta R i =
      bernsteinSecondMomentComparisonFamily P B (-theta) R i)
#check (bernsteinMGFComparison_negRandomMatrixFamily
    (P := P) B theta R :
  (forall i,
    MatrixLE
      (matrixExpect P (matrixExpScaledFamily B (-theta) i))
      (matrixExp (bernsteinSecondMomentComparisonFamily P B (-theta) R i))) ->
    forall i,
      MatrixLE
        (matrixExpect P (matrixExpScaledFamily (negRandomMatrixFamily B) theta i))
        (matrixExp
          (bernsteinSecondMomentComparisonFamily P (negRandomMatrixFamily B) theta R i)))
#check (traceMGFBernsteinVarianceProxyBound_negRandomMatrixFamily
    (P := P) B M theta R :
  TraceMGFBernsteinVarianceProxyBound P (randomMatrixSum B) M (-theta) R ->
    TraceMGFBernsteinVarianceProxyBound P
      (randomMatrixSum (negRandomMatrixFamily B)) M theta R)
#check (matrixBernsteinTraceMGFWithBernsteinCoeff_negRandomMatrixFamily
    (P := P) B theta R :
  matrixBernsteinTraceMGFWithBernsteinCoeff_statement P B (-theta) R ->
    matrixBernsteinTraceMGFWithBernsteinCoeff_statement P
      (negRandomMatrixFamily B) theta R)
#check (sampleCovarianceCenteredRankOneRadius R : Real)
#check (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R : Real)
#check (sampleCovarianceCenteredRankOneVarianceProxyBoundOfRows m R : Real)
#check (sampleCovarianceTailTheta (m := m) R t sigma2 : Real)
#check (sampleCovarianceTailThetaOfRows m R t sigma2 : Real)
#check (sampleCovarianceQuadraticFormTailRHS (m := m) (n := n) R t sigma2 :
  ENNReal)
#check (operatorNorm_eq_spectralRadius_of_selfAdjointStatement M : Prop)
#check (HighProbabilityBound P (Set.univ : Set Omega) 1 : Prop)
#check (highProbabilityBound P (Set.univ : Set Omega) 1 : Prop)
#check (matrixHoeffdingStatement P B R c t : Prop)
#check (matrixChernoffStatement P B R c t : Prop)
#check (covarianceEstimationStatement P X K c t : Prop)
#check (sampleCovarianceOperatorNormStatement P X t bound : Prop)

section NonemptyMatrixBernsteinOperatorNormExample

variable (Ane : I -> RandomMatrix Omega (n + 1) (n + 1))
variable (Rneg sigmaSq sigmaSqNeg : Real)
variable
  (hCentered : CenteredSelfAdjointRandomMatrixFamily P Ane)
  (hIndepSA : IndependentSelfAdjointRandomMatrices P Ane)
  (hIntX : forall i, IntegrableRandomMatrix P (Ane i))
  (hIntSq : forall i, IntegrableRandomMatrix P (randomMatrixSquare (Ane i)))
  (hExpInt :
    forall i,
      IntegrableRandomMatrix P
        (matrixExpScaledFamily Ane (bernsteinThetaChoice t sigmaSq R) i))
  (hTraceInt :
    IntegrableRealRandomVariable P
      (traceExpIntegrand (randomMatrixSum Ane)
        (bernsteinThetaChoice t sigmaSq R)))
  (hBound : PointwiseOperatorNormBound Ane R)
  (hSigma : 0 < sigmaSq)
  (hR : 0 <= R)
  (ht : 0 < t)
  (hNorm : MatrixVarianceProxyNormBound P Ane sigmaSq)
  (hCFC :
    forall i omega,
      bernsteinMatrixExp_le_quadratic_statement (Ane i omega)
        (bernsteinThetaChoice t sigmaSq R) R)
  (hTropp :
    troppMasterTraceMGFFiniteFamily_statement
      (P := P) Ane
      (bernsteinSecondMomentComparisonFamily P Ane
        (bernsteinThetaChoice t sigmaSq R) R)
      (matrixVarianceProxy P Ane) (bernsteinThetaChoice t sigmaSq R) R)
  (hCenteredNeg :
    CenteredSelfAdjointRandomMatrixFamily P
      (negRandomMatrixFamily Ane))
  (hIndepSANeg :
    IndependentSelfAdjointRandomMatrices P
      (negRandomMatrixFamily Ane))
  (hIntXNeg :
    forall i,
      IntegrableRandomMatrix P
        ((negRandomMatrixFamily Ane) i))
  (hIntSqNeg :
    forall i,
      IntegrableRandomMatrix P
        (randomMatrixSquare
          ((negRandomMatrixFamily Ane) i)))
  (hExpIntNeg :
    forall i,
      IntegrableRandomMatrix P
        (matrixExpScaledFamily
          (negRandomMatrixFamily Ane)
          (bernsteinThetaChoice t sigmaSqNeg Rneg) i))
  (hTraceIntNeg :
    IntegrableRealRandomVariable P
      (traceExpIntegrand
        (randomMatrixSum
          (negRandomMatrixFamily Ane))
        (bernsteinThetaChoice t sigmaSqNeg Rneg)))
  (hBoundNeg :
    PointwiseOperatorNormBound
      (negRandomMatrixFamily Ane) Rneg)
  (hSigmaNeg : 0 < sigmaSqNeg)
  (hRNeg : 0 <= Rneg)
  (hNormNeg :
    MatrixVarianceProxyNormBound P
      (negRandomMatrixFamily Ane) sigmaSqNeg)
  (hCFCNeg :
    forall i omega,
      bernsteinMatrixExp_le_quadratic_statement
        ((negRandomMatrixFamily Ane) i omega)
        (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg)
  (hTroppNeg :
    troppMasterTraceMGFFiniteFamily_statement
      (P := P) (negRandomMatrixFamily Ane)
      (bernsteinSecondMomentComparisonFamily P
        (negRandomMatrixFamily Ane)
        (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg)
      (matrixVarianceProxy P
        (negRandomMatrixFamily Ane))
      (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg)

example :
    P (SelfAdjointOperatorNormTailEvent (randomMatrixSum Ane) t) <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        (n + 1) R Rneg t sigmaSq sigmaSqNeg := by
  simpa [matrixBernsteinTwoSidedOptimizedScalarTailRHS,
    matrixBernsteinOptimizedScalarTailRHS, Nat.cast_add, Nat.cast_one] using
    (matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_nonempty_under_primitives
      (P := P) (A := Ane) (R := R) (Rneg := Rneg) (t := t)
      (sigmaSq := sigmaSq) (sigmaSqNeg := sigmaSqNeg)
      hCentered hIndepSA hIntX hIntSq hExpInt hTraceInt hBound
      hSigma hR ht hNorm hCFC hTropp hCenteredNeg hIndepSANeg
      hIntXNeg hIntSqNeg hExpIntNeg hTraceIntNeg hBoundNeg hSigmaNeg
      hRNeg hNormNeg hCFCNeg hTroppNeg)

end NonemptyMatrixBernsteinOperatorNormExample

section NonemptySampleCovarianceOperatorNormExample

variable (Xne : RandomMatrix Omega m (n + 1))
variable (Rneg sigmaSq sigmaSqNeg : Real)
variable
  (hm : 0 < m)
  (hMeas : IsRandomMatrix P Xne)
  (hLp :
    forall k : Fin m, forall j : Fin (n + 1),
      MemLpRealRandomVariable P (matrixEntry Xne k j) 2)
  (hSq :
    forall k : Fin m, forall omega,
      vectorSqNorm (rowVector Xne k omega) <= R)
  (hIndep :
    IndependentRandomMatrices P
      (centeredSampleCovarianceRowRankOneFamily (P := P) Xne))
  (hIntSq :
    forall k : Fin m,
      IntegrableRandomMatrix P
        (randomMatrixSquare
          ((centeredSampleCovarianceRowRankOneFamily (P := P) Xne) k)))
  (hExpInt :
    forall k : Fin m,
      IntegrableRandomMatrix P
        (matrixExpScaledFamily
          (centeredSampleCovarianceRowRankOneFamily (P := P) Xne)
          (sampleCovarianceTailTheta (m := m) R t sigmaSq)
          k))
  (hTraceInt :
    IntegrableRealRandomVariable P
      (traceExpIntegrand
        (centeredSampleCovarianceRowRankOneSum (P := P) Xne)
        (sampleCovarianceTailTheta (m := m) R t sigmaSq)))
  (hSigma : 0 < sigmaSq)
  (hR : 0 <= R)
  (ht : 0 < t)
  (hNorm :
    MatrixVarianceProxyNormBound P
      (centeredSampleCovarianceRowRankOneFamily (P := P) Xne) sigmaSq)
  (hCFC :
    forall k : Fin m, forall omega,
      bernsteinMatrixExp_le_quadratic_statement
        ((centeredSampleCovarianceRowRankOneFamily (P := P) Xne) k omega)
        (sampleCovarianceTailTheta (m := m) R t sigmaSq)
        (sampleCovarianceCenteredRankOneRadius R))
  (hTropp :
    troppMasterTraceMGFFiniteFamily_statement
      (P := P)
      (centeredSampleCovarianceRowRankOneFamily (P := P) Xne)
      (bernsteinSecondMomentComparisonFamily P
        (centeredSampleCovarianceRowRankOneFamily (P := P) Xne)
        (sampleCovarianceTailTheta (m := m) R t sigmaSq)
        (sampleCovarianceCenteredRankOneRadius R))
      (matrixVarianceProxy P
        (centeredSampleCovarianceRowRankOneFamily (P := P) Xne))
      (sampleCovarianceTailTheta (m := m) R t sigmaSq)
      (sampleCovarianceCenteredRankOneRadius R))
  (hCenteredNeg :
    CenteredSelfAdjointRandomMatrixFamily P
      (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) Xne))
  (hIndepSANeg :
    IndependentSelfAdjointRandomMatrices P
      (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) Xne))
  (hIntXNeg :
    forall k : Fin m,
      IntegrableRandomMatrix P
        ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) Xne) k))
  (hIntSqNeg :
    forall k : Fin m,
      IntegrableRandomMatrix P
        (randomMatrixSquare
          ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) Xne) k)))
  (hExpIntNeg :
    forall k : Fin m,
      IntegrableRandomMatrix P
        (matrixExpScaledFamily
          (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) Xne)
          (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
          k))
  (hTraceIntNeg :
    IntegrableRealRandomVariable P
      (traceExpIntegrand
        (centeredSampleCovarianceRowRankOneSumNeg (P := P) Xne)
        (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)))
  (hBoundNeg :
    PointwiseOperatorNormBound
      (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) Xne)
      (sampleCovarianceCenteredRankOneRadius Rneg))
  (hSigmaNeg : 0 < sigmaSqNeg)
  (hRNeg : 0 <= Rneg)
  (hNormNeg :
    MatrixVarianceProxyNormBound P
      (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) Xne)
      sigmaSqNeg)
  (hCFCNeg :
    forall k : Fin m, forall omega,
      bernsteinMatrixExp_le_quadratic_statement
        ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) Xne)
          k omega)
        (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
        (sampleCovarianceCenteredRankOneRadius Rneg))
  (hTroppNeg :
    troppMasterTraceMGFFiniteFamily_statement
      (P := P)
      (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) Xne)
      (bernsteinSecondMomentComparisonFamily P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) Xne)
        (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
        (sampleCovarianceCenteredRankOneRadius Rneg))
      (matrixVarianceProxy P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) Xne))
      (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
      (sampleCovarianceCenteredRankOneRadius Rneg))

example :
    P (SelfAdjointOperatorNormTailEvent
        (centeredRandomMatrix P (sampleCovariance Xne)) t) <=
      sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n + 1) R t sigmaSq +
        sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n + 1) Rneg t sigmaSqNeg := by
  exact
    sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_explicit_variance_proxy
      (P := P) (A := Xne) (R := R) (Rneg := Rneg) (t := t)
      (sigmaSq := sigmaSq) (sigmaSqNeg := sigmaSqNeg)
      hm hMeas hLp hSq hIndep hIntSq hExpInt hTraceInt hSigma hR ht
      hNorm hCFC hTropp hCenteredNeg hIndepSANeg hIntXNeg hIntSqNeg
      hExpIntNeg hTraceIntNeg hBoundNeg hSigmaNeg hRNeg hNormNeg
      hCFCNeg hTroppNeg

end NonemptySampleCovarianceOperatorNormExample
