import HighDimProb.RandomMatrix.CStarBridge
import HighDimProb.RandomMatrix.HardboneStatements

open MeasureTheory
open HighDimProb
open scoped ComplexOrder MatrixOrder Matrix.Norms.Operator

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega}
variable [MeasureTheory.IsProbabilityMeasure P]
variable {m n : Nat}
variable (A H M K : Matrix (Fin n) (Fin n) Real)
variable (B S : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
variable (Y : RandomMatrix Omega n n)
variable (D : RealRandomVariable Omega)
variable (theta R sigmaSq effectiveRank : Real)
variable (rankBound supportDim : Nat)
variable (X : Fin m -> RandomMatrix Omega n n)
variable (Kfam : Fin m -> Matrix (Fin n) (Fin n) Real)
variable (mHist : Fin m -> MeasurableSpace Omega)

#check scalarBernsteinExpQuadraticInequality_statement
#check selfAdjointSpectrumBoundedByOperatorNorm_statement
#check cfcScalarInequalityToMatrixLE_statement
#check bernsteinCFCExpressionNormalization_statement
#check bernsteinMatrixExp_le_quadratic_of_cfcChain_statement
#check operatorLogMonotoneOnPositiveMatrices_statement
#check matrixExpLogDomainForSelfAdjoint_statement
#check matrixLog_le_of_le_matrixExp_statement
#check matrixLog_le_of_le_matrixExp
#check realMatrixToCStarMatrix
#check realMatrixToCStarMatrix_apply
#check realMatrixToCStarMatrix_add
#check realMatrixToCStarMatrix_sub
#check isSelfAdjoint_realMatrixToCStarMatrix
#check realMatrixToCStarStrictlyPositive_statement
#check realMatrixToCStarMatrixLE_statement
#check realMatrixToCStarLogBack_statement
#check realMatrixToCStarMatrix_nonneg_of_complexified_nonneg
#check realMatrixToCStarMatrixLE_of_complexified_le
#check realMatrixToCStarStrictlyPositive_of_complexified
#check realMatrixToCStarLogBack_of_transport
#check traceMatrixExp_mono_add_selfAdjoint_statement
#check troppLogExpComparisonToK_of_logOrderKChain_statement
#check liebTraceExpConcavity_statement
#check liebJensenTraceExp_statement
#check goldenThompsonTraceExp_statement
#check matrixExpLogSelfAdjointNormalization_statement
#check troppMasterTraceMGFStep_of_liebJensen_statement
#check troppNaturalHistoryMeasurable_statement
#check troppHistoryStepIndependent_of_iIndepFun_statement
#check condExp_traceExp_history_add_independent_step_statement
#check troppConditionalStep_of_iIndepFun_statement
#check @troppConditionalStep_of_iIndepFun
#check matrixExpScaledIntegrable_of_provider_statement
#check traceExpIntegrable_troppStateHistory_add_step_statement
#check traceExpIntegrable_troppStateHistory_add_K_statement
#check traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider_statement
#check matrixSquare_centeredRandomMatrix_expectation_expansion_statement
#check matrixSquare_centeredRandomMatrix_expectation_expansion
#check centeredRankOneSquare_le_rankOneSecondMoment_statement
#check centeredRankOneSquare_le_rankOneSecondMoment
#check sampleCovarianceVarianceProxy_sharp_statement
#check sampleCovarianceVarianceProxy_sharp_of_rankOneSecondMoment
#check sampleCovarianceVarianceProxy_sharp_of_exactRowSecondMoment
#check sampleCovarianceVarianceProxy_sharp_of_exactRowSqNorm_bound_memLp_two
#check sampleCovarianceVarianceProxy_sharp_statement_of_centeredSquareChain_exactRowSqNorm_bound_memLp_two
#check sampleCovarianceVarianceProxy_sharp_of_exactRowSqNorm_bound_memLp_two_of_centeredSquareChain
#check varianceProxyNormBound_of_centeredSquareChain_statement
#check deterministicMatrixVarianceProxyNorm_mono_of_matrixLE_statement
#check varianceProxyNormBound_of_centeredSquareChain_of_normMono
#check deterministicMatrixVarianceProxyNorm_mono_of_matrixLE
#check traceMatrixExp_le_rank_exp_lambdaMax_statement
#check traceMatrixExp_le_supportDim_exp_lambdaMax_statement
#check matrixExpSupportDomination_identity_statement
#check traceMatrixExp_excess_supportDim_exp_lambdaMax_statement
#check traceMatrixExp_excess_supportDim_exp_lambdaMax
#check traceMatrixExp_effectiveRank_bound_statement
#check traceMatrixExp_effectiveRank_bound
#check traceMatrixExp_effectiveRank_bound_of_ambientTraceCertificate
#check bernsteinMatrixExp_le_quadratic_of_cfcChain
#check selfAdjointSpectrumBoundedByOperatorNorm
#check bernsteinCFCExpressionNormalization
#check cfcScalarInequalityToMatrixLE_bernsteinExpQuadratic
#check bernsteinMatrixExp_le_quadratic_of_cfcLeaves
#check bernsteinMatrixExp_le_quadratic
#check bernsteinMatrixExp_le_quadratic_of_spectrum_cfcOrder
#check bernsteinMatrixExp_le_quadratic_of_cfcChain_spectrum
#check troppLogExpComparisonToK_of_logMonotone_traceExpMono
#check matrixExpLogSelfAdjointNormalization
#check troppMasterTraceMGFStep_of_liebJensen
#check troppMasterTraceMGFStep_trace_bound_of_liebJensen_logOrder
#check troppMasterTraceMGFConditionalStep_of_conditioningBridge
#check traceMGFBernsteinVarianceProxyBound_of_conditioningBridge
#check traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider
#check varianceProxyNormBound_of_centeredSquareChain
#check varianceProxyNormBound_of_centeredSquareChain_expansion
#check matrixTrace_smul
#check matrixTrace_le_of_matrixLE
#check traceMatrixExp_le_trace_support_exp_lambdaMax_of_matrixExp_le_smul_support
#check traceMatrixExp_le_trace_support_exp_lambdaMax_of_supportDomination
#check traceMatrixExp_le_card_add_trace_support_mul_exp_sub_one_of_excessSupportDomination
#check traceMatrixExp_le_rank_exp_lambdaMax
#check traceMatrixExp_le_rank_exp_lambdaMax_of_isStarProjection
#check traceMatrixExp_le_supportDim_exp_lambdaMax

example : Prop :=
  scalarBernsteinExpQuadraticInequality_statement theta R

example : Prop :=
  bernsteinMatrixExp_le_quadratic_of_cfcChain_statement A theta R

example : Prop :=
  troppLogExpComparisonToK_of_logOrderKChain_statement H M K

example :
    matrixLog_le_of_le_matrixExp_statement M K :=
  matrixLog_le_of_le_matrixExp M K
example (hA : IsSelfAdjointMatrix A) :
    IsSelfAdjoint (realMatrixToCStarMatrix A) :=
  isSelfAdjoint_realMatrixToCStarMatrix hA

example : Prop :=
  realMatrixToCStarMatrixLE_statement M K

example : Prop :=
  realMatrixToCStarLogBack_statement A

example
    (hA : 0 <= A.map (algebraMap Real Complex)) :
    0 <= realMatrixToCStarMatrix A :=
  realMatrixToCStarMatrix_nonneg_of_complexified_nonneg A hA

example
    (hAB : M.map (algebraMap Real Complex) <= K.map (algebraMap Real Complex)) :
    realMatrixToCStarMatrix M <= realMatrixToCStarMatrix K :=
  realMatrixToCStarMatrixLE_of_complexified_le M K hAB

example
    (hA : IsStrictlyPositive (A.map (algebraMap Real Complex))) :
    IsStrictlyPositive (realMatrixToCStarMatrix A) :=
  realMatrixToCStarStrictlyPositive_of_complexified A hA

example
    (hlog : CFC.log (realMatrixToCStarMatrix A) =
      realMatrixToCStarMatrix (CFC.log A)) :
    realMatrixToCStarLogBack_statement A :=
  realMatrixToCStarLogBack_of_transport A hlog

example : Prop :=
  troppMasterTraceMGFStep_of_liebJensen_statement (P := P) H Y

example
    (hStepChain : troppMasterTraceMGFStep_of_liebJensen_statement (P := P) H Y)
    (hJensen :
      liebJensenTraceExp_statement (P := P) H
        (fun omega => matrixExp (Y omega)))
    (hNormalize :
      forall omega, matrixExpLogSelfAdjointNormalization_statement (Y omega))
    (hLogChain :
      troppLogExpComparisonToK_of_logOrderKChain_statement H
        (matrixExpect P (fun omega => matrixExp (Y omega))) K)
    (hLog : matrixLog_le_of_le_matrixExp_statement
      (matrixExpect P (fun omega => matrixExp (Y omega))) K)
    (hTrace : traceMatrixExp_mono_add_selfAdjoint_statement H
      (CFC.log (matrixExpect P (fun omega => matrixExp (Y omega)))) K)
    (hH : IsSelfAdjointMatrix H)
    (hY : RandomSelfAdjointMatrix P Y)
    (hTraceInt :
      IntegrableRealRandomVariable P
        (fun omega => traceMatrixExp (H + Y omega)))
    (hExpInt : IntegrableRandomMatrix P (fun omega => matrixExp (Y omega)))
    (hExpMeanSA :
      IsSelfAdjointMatrix
        (matrixExpect P (fun omega => matrixExp (Y omega))))
    (hExpMeanPos :
      IsStrictlyPositive
        (matrixExpect P (fun omega => matrixExp (Y omega))))
    (hKSA : IsSelfAdjointMatrix K)
    (hMGF :
      MatrixLE
        (matrixExpect P (fun omega => matrixExp (Y omega)))
        (matrixExp K)) :
    expect P (fun omega => traceMatrixExp (H + Y omega)) <=
      traceMatrixExp (H + K) :=
  troppMasterTraceMGFStep_trace_bound_of_liebJensen_logOrder
    H K Y hStepChain hJensen hNormalize hLogChain hLog hTrace
    hH hY hTraceInt hExpInt hExpMeanSA hExpMeanPos hKSA hMGF

example : Prop :=
  troppConditionalStep_of_iIndepFun_statement (P := P) theta X Kfam mHist

example :
    troppConditionalStep_of_iIndepFun_statement (P := P) theta X Kfam mHist :=
  troppConditionalStep_of_iIndepFun theta X Kfam mHist

example
    (hChain : troppConditionalStep_of_iIndepFun_statement (P := P) theta X Kfam mHist)
    (hHist : troppNaturalHistoryMeasurable_statement theta X Kfam mHist)
    (hHistIndep : troppHistoryStepIndependent_of_iIndepFun_statement (P := P) theta X Kfam)
    (hCondExp : forall i,
      @condExp_traceExp_history_add_independent_step_statement
        Omega (inferInstance : MeasurableSpace Omega) P n
        (mHist i)
        (@troppStateHistory Omega (inferInstance : MeasurableSpace Omega) m n theta X Kfam i)
        (@troppCurrentRandomStep Omega (inferInstance : MeasurableSpace Omega) m n theta X i)
        (Kfam i))
    (hHistSub : forall i, mHist i <= (inferInstance : MeasurableSpace Omega))
    (hHistRand : forall i,
      @IsRandomMatrix Omega (inferInstance : MeasurableSpace Omega) n n P
        (troppStateHistory theta X Kfam i))
    (hZRand : forall i,
      @IsRandomMatrix Omega (inferInstance : MeasurableSpace Omega) n n P
        (troppCurrentRandomStep theta X i))
    (hHistSA : forall i omega, IsSelfAdjointMatrix (troppStateHistory theta X Kfam i omega))
    (hZSA : forall i,
      @RandomSelfAdjointMatrix Omega (inferInstance : MeasurableSpace Omega) n P
        (troppCurrentRandomStep theta X i))
    (hCondTraceInt : forall i,
      @IntegrableRealRandomVariable Omega (inferInstance : MeasurableSpace Omega) P
        (fun omega => traceMatrixExp
          (troppStateHistory theta X Kfam i omega +
            troppCurrentRandomStep theta X i omega)))
    (hExpIntStep : forall i,
      @IntegrableRandomMatrix Omega (inferInstance : MeasurableSpace Omega) n n P
        (fun omega => matrixExp (troppCurrentRandomStep theta X i omega)))
    (hExpMeanSA : forall i,
      IsSelfAdjointMatrix
        (@matrixExpect Omega (inferInstance : MeasurableSpace Omega) n n P
          (fun omega => matrixExp (troppCurrentRandomStep theta X i omega))))
    (hExpMeanPos : forall i,
      IsStrictlyPositive
        (@matrixExpect Omega (inferInstance : MeasurableSpace Omega) n n P
          (fun omega => matrixExp (troppCurrentRandomStep theta X i omega))))
    (hSigma : forall i, MeasureTheory.SigmaFinite (P.trim (hHistSub i)))
    (hRhsInt : forall i,
      @IntegrableRealRandomVariable Omega (inferInstance : MeasurableSpace Omega) P
        (fun omega => traceMatrixExp (troppStateHistory theta X Kfam i omega + Kfam i)))
    (hRand : forall i, IsRandomMatrix P (X i))
    (hSA : forall i, RandomSelfAdjointMatrix P (X i))
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hExpInt : forall i,
      IntegrableRandomMatrix P
        (fun omega => matrixExp (SMul.smul theta (X i omega))))
    (hTraceInt : IntegrableRealRandomVariable P (traceExpIntegrand (randomMatrixSum X) theta))
    (hKSA : forall i, IsSelfAdjointMatrix (Kfam i))
    (hVSA : IsSelfAdjointMatrix M)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3)
    (hMGF : forall i,
      MatrixLE
        (matrixExpect P (fun omega => matrixExp (SMul.smul theta (X i omega))))
        (matrixExp (Kfam i)))
    (hNorm : Finset.univ.sum (fun i : Fin m => Kfam i) =
      SMul.smul (bernsteinMGFCoeff theta R) M) :
    TraceMGFBernsteinVarianceProxyBound P (randomMatrixSum X) M theta R :=
  traceMGFBernsteinVarianceProxyBound_of_conditioningBridge
    X Kfam M theta R mHist hChain hHist hHistIndep hCondExp hHistSub
    hHistRand hZRand hHistSA hZSA hCondTraceInt hExpIntStep hExpMeanSA
    hExpMeanPos hSigma hRhsInt hRand hSA hIndep hExpInt hTraceInt hKSA
    hVSA hR hRange hMGF hNorm

example : Prop :=
  traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider_statement
    (P := P) theta X D

example
    (hChain :
      traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider_statement
        (P := P) theta X D)
    (hD : IntegrableRealRandomVariable P D)
    (hD_nonneg : forall omega, 0 <= D omega)
    (hDom : forall omega,
      abs (traceExpIntegrand (randomMatrixSum X) theta omega) <= D omega) :
    IntegrableRealRandomVariable P (traceExpIntegrand (randomMatrixSum X) theta) :=
  traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider
    theta X D hChain hD hD_nonneg hDom

example
    (hChain :
      varianceProxyNormBound_of_centeredSquareChain_statement (P := P) X Kfam sigmaSq)
    (hExpansion : forall i,
      matrixSquare_centeredRandomMatrix_expectation_expansion_statement
        (P := P) (X i))
    (hLE : forall i,
      MatrixLE (matrixSecondMoment P (centeredRandomMatrix P (X i))) (Kfam i))
    (hNorm : deterministicMatrixVarianceProxyNorm (Finset.univ.sum fun i => Kfam i) <=
      sigmaSq) :
    MatrixVarianceProxyNormBound P (centeredRandomMatrixFamily P X) sigmaSq :=
  varianceProxyNormBound_of_centeredSquareChain
    X Kfam sigmaSq hChain hExpansion hLE hNorm

example : Prop :=
  traceMatrixExp_le_rank_exp_lambdaMax_statement B S rankBound

example : Prop :=
  traceMatrixExp_le_supportDim_exp_lambdaMax_statement B S supportDim

example : Prop :=
  traceMatrixExp_effectiveRank_bound_statement B theta sigmaSq effectiveRank

example
    (hc : 0 <= theta) (hsigma : 0 < sigmaSq)
    (hEff : 0 <= effectiveRank)
    (hPSD : IsPSDMatrix B)
    (hTrace : matrixTrace B <= effectiveRank * sigmaSq)
    (hB : IsSelfAdjointMatrix B)
    (hSpec : lambdaMaxOrdered B hB <= sigmaSq) :
    traceMatrixExp (theta •B) <=
      ((n + 1 : Nat) : Real) +
        effectiveRank * (Real.exp (theta * sigmaSq) - 1) := by
  have hStmt := traceMatrixExp_effectiveRank_bound B theta sigmaSq effectiveRank
  exact hStmt hc hsigma hEff hPSD hTrace hB hSpec

example
    (hc : 0 <= theta) (hsigma : 0 < sigmaSq)
    (hPSD : IsPSDMatrix B)
    (hB : IsSelfAdjointMatrix B)
    (hSpec : lambdaMaxOrdered B hB <= sigmaSq) :
    traceMatrixExp (theta •B) <=
      ((n + 1 : Nat) : Real) +
        ((n + 1 : Nat) : Real) * (Real.exp (theta * sigmaSq) - 1) :=
  traceMatrixExp_effectiveRank_bound_of_ambientTraceCertificate
    B theta sigmaSq hc hsigma hPSD hB hSpec

example :
    traceMatrixExp_le_rank_exp_lambdaMax_statement B S rankBound :=
  traceMatrixExp_le_rank_exp_lambdaMax B S rankBound

example
    (hProj : IsStarProjection S)
    (hRank : Matrix.rank S <= rankBound) :
    0 < rankBound ->
      rankBound <= n + 1 ->
        forall hB : IsSelfAdjointMatrix B,
          MatrixExpSupportDomination B S hB ->
            traceMatrixExp B <=
                (rankBound : Real) * Real.exp (lambdaMaxOrdered B hB) :=
  traceMatrixExp_le_rank_exp_lambdaMax_of_isStarProjection
    B S rankBound hProj hRank

example :
    traceMatrixExp_le_supportDim_exp_lambdaMax_statement B S supportDim :=
  traceMatrixExp_le_supportDim_exp_lambdaMax B S supportDim

-- Proved scalar Bernstein leaf: the typed statement is now a proved theorem.
#check @scalarBernsteinExpQuadraticInequality

example :
    scalarBernsteinExpQuadraticInequality_statement theta R :=
  scalarBernsteinExpQuadraticInequality theta R

example :
    bernsteinCFCExpressionNormalization_statement A theta R :=
  bernsteinCFCExpressionNormalization A theta R

example :
    cfcScalarInequalityToMatrixLE_statement
      (fun x : Real => Real.exp (theta * x))
      (fun x : Real =>
        1 + theta * x + bernsteinMGFCoeff theta R * x ^ 2)
      A :=
  cfcScalarInequalityToMatrixLE_bernsteinExpQuadratic A theta R

example :
    selfAdjointSpectrumBoundedByOperatorNorm_statement A R :=
  selfAdjointSpectrumBoundedByOperatorNorm A R

example :
    bernsteinMatrixExp_le_quadratic_statement A theta R :=
  bernsteinMatrixExp_le_quadratic A theta R

example :
    matrixExpLogSelfAdjointNormalization_statement A :=
  matrixExpLogSelfAdjointNormalization A
