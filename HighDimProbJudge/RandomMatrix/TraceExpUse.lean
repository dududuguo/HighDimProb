import HighDimProb.RandomMatrix

noncomputable section

open scoped MatrixOrder Matrix.Norms.Operator

#check HighDimProb.matrixExp
#check HighDimProb.matrixTrace
#check HighDimProb.matrixTrace_eq_rank_of_isStarProjection
#check HighDimProb.traceMatrixExp
#check HighDimProb.isSelfAdjointMatrix_smul
#check HighDimProb.isSelfAdjointMatrix_neg
#check HighDimProb.randomSelfAdjointMatrix_smul
#check HighDimProb.randomSelfAdjointMatrix_scaledRandomMatrix
#check HighDimProb.randomSelfAdjointMatrix_neg
#check HighDimProb.isSelfAdjointMatrix_matrixExp
#check HighDimProb.matrixTrace_nonneg_of_posSemidef
#check HighDimProb.traceMatrixExp_nonneg_of_matrixExp_posSemidef
#check HighDimProb.matrixExp_posSemidef_of_selfAdjoint_statement
#check HighDimProb.matrixExp_posSemidef_of_selfAdjoint
#check HighDimProb.matrixLE_one_add_self_le_matrixExp_of_selfAdjoint
#check HighDimProb.matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint
#check HighDimProb.traceExpIntegrand
#check HighDimProb.traceExpMoment
#check HighDimProb.traceExpMomentLIntegral
#check HighDimProb.TraceMGFBound
#check HighDimProb.TraceMGFBoundLIntegral
#check HighDimProb.TraceMGFVarianceProxyBound
#check HighDimProb.TraceMGFVarianceProxyBoundLIntegral
#check HighDimProb.troppMasterTraceMGFStep_statement
#check HighDimProb.troppLogExpComparisonToK_statement
#check HighDimProb.troppMasterTraceMGFStep_trace_bound_of_logExpComparisonToK
#check HighDimProb.isRandomMatrix_of_sub_measurable_entries
#check HighDimProb.troppMasterTraceMGFConditionalStep_statement
#check HighDimProb.troppMasterTraceMGFConditionalStep_apply_of_histEntryMeasurable
#check HighDimProb.troppMasterTraceMGFConditionalStep_expect_bound
#check HighDimProb.troppTraceExpFiniteFamilyIterationSkeleton_of_conditionalSteps
#check HighDimProb.troppTraceExpFiniteFamilyIterationSkeleton_of_naturalStateConditionalSteps
#check HighDimProb.troppMasterTraceMGFFiniteFamily_statement
#check HighDimProb.troppMasterTraceMGFFiniteFamily_statement_of_reindexedFin
#check HighDimProb.troppMasterTraceMGFFiniteFamily_of_conditionalSteps
#check HighDimProb.troppMasterTraceMGFFiniteFamily_of_naturalStateConditionalSteps
#check HighDimProb.troppRandomHistory
#check HighDimProb.troppComparisonHistory
#check HighDimProb.troppCurrentRandomStep
#check HighDimProb.troppCurrentComparisonStep
#check HighDimProb.troppStateHistory
#check HighDimProb.troppTraceState
#check HighDimProb.troppStateLeft
#check HighDimProb.troppStateRight
#check HighDimProb.troppNaturalState_zero
#check HighDimProb.troppNaturalState_last
#check HighDimProb.troppNaturalState_left
#check HighDimProb.troppNaturalState_right
#check HighDimProb.comparisonMatrixPrefixSum
#check HighDimProb.comparisonMatrixSuffixSum
#check HighDimProb.randomMatrixPrefixSum
#check HighDimProb.randomMatrixSuffixSum
#check HighDimProb.comparisonMatrixPrefixSum_zero
#check HighDimProb.comparisonMatrixPrefixSum_succ
#check HighDimProb.comparisonMatrixPrefixSum_last
#check HighDimProb.comparisonMatrixSuffixSum_zero
#check HighDimProb.comparisonMatrixSuffixSum_succ
#check HighDimProb.comparisonMatrixSuffixSum_last
#check HighDimProb.randomMatrixPrefixSum_zero
#check HighDimProb.randomMatrixPrefixSum_succ
#check HighDimProb.randomMatrixPrefixSum_last
#check HighDimProb.randomMatrixSuffixSum_zero
#check HighDimProb.randomMatrixSuffixSum_succ
#check HighDimProb.randomMatrixSuffixSum_last
#check HighDimProb.randomMatrixSum_eq_prefixSum_last
#check HighDimProb.traceMatrixExp_randomMatrixPrefixSum_last
#check HighDimProb.traceMatrixExp_comparisonMatrixPrefixSum_last
#check HighDimProb.scaledRandomMatrix
#check HighDimProb.scaledRandomMatrixFamily
#check HighDimProb.bernsteinMGFCoeff
#check HighDimProb.bernsteinThetaChoice
#check HighDimProb.bernsteinThetaChoice_den_pos
#check HighDimProb.bernsteinThetaChoice_nonneg
#check HighDimProb.bernsteinThetaChoice_pos
#check HighDimProb.bernsteinThetaChoice_range
#check HighDimProb.bernsteinThetaChoice_exponent_eq
#check HighDimProb.bernsteinCoefficient_nonneg
#check HighDimProb.bernsteinMGFCoeff_neg
#check HighDimProb.bernsteinMGFCoeff_nonneg
#check HighDimProb.TraceMGFBernsteinVarianceProxyBound
#check HighDimProb.TraceMGFBernsteinVarianceProxyBoundLIntegral
#check HighDimProb.bernsteinMatrixExp_le_quadratic_statement
#check HighDimProb.scalarBernsteinExpQuadraticInequality_statement
#check HighDimProb.selfAdjointSpectrumBoundedByOperatorNorm_statement
#check HighDimProb.cfcScalarInequalityToMatrixLE_statement
#check HighDimProb.bernsteinCFCExpressionNormalization_statement
#check HighDimProb.bernsteinMatrixExp_le_quadratic_of_cfcChain_statement
#check HighDimProb.operatorLogMonotoneOnPositiveMatrices_statement
#check HighDimProb.matrixExpLogDomainForSelfAdjoint_statement
#check HighDimProb.matrixLog_le_of_le_matrixExp_statement
#check HighDimProb.matrixLog_le_of_le_matrixExp
#check HighDimProb.traceMatrixExp_mono_add_selfAdjoint_statement
#check HighDimProb.troppLogExpComparisonToK_of_logOrderKChain_statement
#check HighDimProb.liebTraceExpConcavity_statement
#check HighDimProb.liebJensenTraceExp_statement
#check HighDimProb.goldenThompsonTraceExp_statement
#check HighDimProb.matrixExpLogSelfAdjointNormalization_statement
#check HighDimProb.matrixExpLogSelfAdjointNormalization
#check HighDimProb.troppMasterTraceMGFStep_of_liebJensen_statement
#check HighDimProb.troppNaturalHistoryMeasurable_statement
#check HighDimProb.troppHistoryStepIndependent_of_iIndepFun_statement
#check HighDimProb.condExp_traceExp_history_add_independent_step_statement
#check HighDimProb.troppConditionalStep_of_iIndepFun_statement
#check HighDimProb.matrixExpScaledIntegrable_of_provider_statement
#check HighDimProb.traceExpIntegrable_troppStateHistory_add_step_statement
#check HighDimProb.traceExpIntegrable_troppStateHistory_add_K_statement
#check HighDimProb.traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider_statement
#check HighDimProb.matrixSquare_centeredRandomMatrix_expectation_expansion_statement
#check HighDimProb.centeredRankOneSquare_le_rankOneSecondMoment_statement
#check HighDimProb.sampleCovarianceVarianceProxy_sharp_statement
#check HighDimProb.varianceProxyNormBound_of_centeredSquareChain_statement
#check HighDimProb.varianceProxyNormBound_of_centeredSquareChain
#check HighDimProb.traceMatrixExp_le_rank_exp_lambdaMax_statement
#check HighDimProb.traceMatrixExp_le_supportDim_exp_lambdaMax_statement
#check HighDimProb.traceMatrixExp_effectiveRank_bound_statement
#check HighDimProb.traceMatrixExp_effectiveRank_bound_of_ambientTraceCertificate
#check HighDimProb.matrixTrace_smul
#check HighDimProb.matrixTrace_le_of_matrixLE
#check HighDimProb.traceMatrixExp_le_trace_support_exp_lambdaMax_of_matrixExp_le_smul_support
#check HighDimProb.traceMatrixExp_le_rank_exp_lambdaMax
#check HighDimProb.traceMatrixExp_le_supportDim_exp_lambdaMax
#check HighDimProb.bernsteinMatrixExp_le_quadratic_of_cfcChain
#check HighDimProb.selfAdjointSpectrumBoundedByOperatorNorm
#check HighDimProb.bernsteinCFCExpressionNormalization
#check HighDimProb.cfcScalarInequalityToMatrixLE_bernsteinExpQuadratic
#check HighDimProb.bernsteinMatrixExp_le_quadratic_of_cfcLeaves
#check HighDimProb.bernsteinMatrixExp_le_quadratic
#check HighDimProb.bernsteinMatrixExp_le_quadratic_of_spectrum_cfcOrder
#check HighDimProb.bernsteinMatrixExp_le_quadratic_of_cfcChain_spectrum
#check HighDimProb.troppLogExpComparisonToK_of_logMonotone_traceExpMono
#check HighDimProb.troppMasterTraceMGFStep_of_liebJensen
#check HighDimProb.troppMasterTraceMGFConditionalStep_of_conditioningBridge
#check HighDimProb.traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider
#check HighDimProb.bernsteinMatrixExp_le_quadratic_neg_of_neg_theta
#check HighDimProb.singleSummandMatrixMGFVarianceProxy_statement
#check HighDimProb.singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic
#check HighDimProb.traceMatrixExp_nonneg_of_selfAdjoint_statement
#check HighDimProb.traceMatrixExp_nonneg_of_selfAdjoint
#check HighDimProb.lambdaMaxOrdered_matrixExp
#check HighDimProb.traceMatrixExp_smul_le_card_exp_of_lambdaMaxOrdered_le
#check HighDimProb.traceMatrixExp_smul_le_card_add_trace_div_mul_exp_sub_one_of_psd_lambdaMax_le
#check HighDimProb.matrixTrace_le_card_mul_of_isPSD_lambdaMaxOrdered_le
#check HighDimProb.traceMatrixExp_eq_sum_exp_eigenvalues
#check HighDimProb.traceExpMoment_nonneg_statement
#check HighDimProb.traceExpMoment_nonneg_of_nonneg
#check HighDimProb.traceExpIntegrand_nonneg_of_randomSelfAdjoint
#check HighDimProb.traceExpMoment_nonneg_of_randomSelfAdjoint
#check HighDimProb.traceExpMomentLIntegral_nonneg
#check HighDimProb.traceExpMomentLIntegral_eq_ofReal_statement
#check HighDimProb.traceExpMomentLIntegral_eq_ofReal_traceExpMoment
#check HighDimProb.traceExpMomentBoundStatement
#check HighDimProb.traceExpVarianceProxyBoundStatement
#check HighDimProb.traceMGFBound_statement
#check HighDimProb.traceMGFBoundLIntegral_statement
#check HighDimProb.traceMGFVarianceProxyBound_statement
#check HighDimProb.traceMGFBernsteinVarianceProxyBound_statement
#check HighDimProb.traceMGFBernsteinVarianceProxyBound_of_troppMasterTraceMGFFiniteFamily
#check HighDimProb.traceMGFBernsteinVarianceProxyBound_of_troppConditionalSteps
#check HighDimProb.traceMGFBernsteinVarianceProxyBound_of_naturalStateConditionalSteps
#check HighDimProb.traceMGFBernsteinVarianceProxyBoundLIntegral_of_traceMGFBernsteinVarianceProxyBound

example {n : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    HighDimProb.traceMatrixExp A =
      Matrix.trace (NormedSpace.exp A) := by
  rfl

example {n : Nat} (A : Matrix (Fin n) (Fin n) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A) :
    Matrix.PosSemidef (HighDimProb.matrixExp A) := by
  exact HighDimProb.matrixExp_posSemidef_of_selfAdjoint hA

example {n : Nat} (A : Matrix (Fin n) (Fin n) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A) :
    HighDimProb.MatrixLE
      ((1 : Matrix (Fin n) (Fin n) Real) + A)
      (HighDimProb.matrixExp A) := by
  exact HighDimProb.matrixLE_one_add_self_le_matrixExp_of_selfAdjoint hA

example {n : Nat} (A : Matrix (Fin n) (Fin n) Real) (theta : Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A) :
    HighDimProb.MatrixLE
      ((1 : Matrix (Fin n) (Fin n) Real) + SMul.smul theta A)
      (HighDimProb.matrixExp (SMul.smul theta A)) := by
  exact HighDimProb.matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint
    theta hA

example {n : Nat} (A : Matrix (Fin n) (Fin n) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A) :
    0 <= HighDimProb.traceMatrixExp A := by
  exact HighDimProb.traceMatrixExp_nonneg_of_selfAdjoint hA

example {n : Nat} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A) :
    HighDimProb.lambdaMaxOrdered (HighDimProb.matrixExp A)
      (HighDimProb.isSelfAdjointMatrix_matrixExp hA) =
        Real.exp (HighDimProb.lambdaMaxOrdered A hA) := by
  exact HighDimProb.lambdaMaxOrdered_matrixExp hA

example {n : Nat} (A : Matrix (Fin n) (Fin n) Real) (theta : Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A) :
    HighDimProb.IsSelfAdjointMatrix (theta • A) := by
  exact HighDimProb.isSelfAdjointMatrix_smul theta hA

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta : Real) : Real :=
  HighDimProb.traceExpMoment P Y theta

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta : Real) : ENNReal :=
  HighDimProb.traceExpMomentLIntegral P Y theta

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta rhs : Real) : Prop :=
  HighDimProb.TraceMGFBound P Y theta rhs

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta : Real)
    (rhs : ENNReal) : Prop :=
  HighDimProb.TraceMGFBoundLIntegral P Y theta rhs

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n)
    (V : Matrix (Fin n) (Fin n) Real) (theta : Real) : Prop :=
  HighDimProb.TraceMGFVarianceProxyBound P Y V theta

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n)
    (V : Matrix (Fin n) (Fin n) Real) (theta R : Real) : Prop :=
  HighDimProb.TraceMGFBernsteinVarianceProxyBound P Y V theta R

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (H : Matrix (Fin n) (Fin n) Real)
    (Z : HighDimProb.RandomMatrix Omega n n) : Prop :=
  HighDimProb.troppMasterTraceMGFStep_statement (P := P) H Z

example {n : Nat}
    (H M K : Matrix (Fin n) (Fin n) Real) : Prop :=
  HighDimProb.troppLogExpComparisonToK_statement H M K

example {n : Nat} (A : Matrix (Fin n) (Fin n) Real)
    (theta R : Real) : Prop :=
  HighDimProb.bernsteinMatrixExp_le_quadratic_statement A theta R

example {theta R : Real} (hRange : abs theta * R < 3) :
    0 <= (theta ^ 2 / 2) / (1 - abs theta * R / 3) := by
  exact HighDimProb.bernsteinCoefficient_nonneg hRange

example {theta R : Real} (hRange : abs theta * R < 3) :
    0 <= HighDimProb.bernsteinMGFCoeff theta R := by
  exact HighDimProb.bernsteinMGFCoeff_nonneg hRange

-- Proved scalar Bernstein leaf consumed as a theorem (no longer typed-only).
example (theta R x : Real) (hx : abs x <= R) (hR : 0 <= R)
    (hRange : abs theta * R < 3) :
    Real.exp (theta * x) <=
      1 + theta * x + HighDimProb.bernsteinMGFCoeff theta R * x ^ 2 :=
  HighDimProb.scalarBernsteinExpQuadraticInequality theta R x hx hR hRange

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (X : HighDimProb.RandomMatrix Omega n n)
    (V : Matrix (Fin n) (Fin n) Real) (theta R : Real) : Prop :=
  HighDimProb.singleSummandMatrixMGFVarianceProxy_statement
    (P := P) X V theta R

example {m n : Nat}
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (i : Fin m) :
    HighDimProb.comparisonMatrixPrefixSum K i.succ =
      HighDimProb.comparisonMatrixPrefixSum K i.castSucc + K i :=
  HighDimProb.comparisonMatrixPrefixSum_succ K i

example {m n : Nat}
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (i : Fin m) :
    HighDimProb.comparisonMatrixSuffixSum K i.castSucc =
      K i + HighDimProb.comparisonMatrixSuffixSum K i.succ :=
  HighDimProb.comparisonMatrixSuffixSum_succ K i

example {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (X : Fin m -> HighDimProb.RandomMatrix Omega n n) :
    HighDimProb.randomMatrixSum X =
      HighDimProb.randomMatrixPrefixSum X (Fin.last m) :=
  HighDimProb.randomMatrixSum_eq_prefixSum_last X

example {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (theta : Real)
    (X : Fin m -> HighDimProb.RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real) :
    HighDimProb.troppTraceState theta X K 0 =
      fun omega => HighDimProb.traceMatrixExp
        (HighDimProb.randomMatrixSum
          (HighDimProb.scaledRandomMatrixFamily theta X) omega) := by
  exact HighDimProb.troppNaturalState_zero theta X K

example {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (theta : Real)
    (X : Fin m -> HighDimProb.RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real) :
    HighDimProb.troppTraceState theta X K (Fin.last m) =
      fun _omega => HighDimProb.traceMatrixExp (Finset.univ.sum K) := by
  exact HighDimProb.troppNaturalState_last theta X K

example {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (theta : Real)
    (X : Fin m -> HighDimProb.RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real) (i : Fin m) :
    HighDimProb.troppStateLeft theta X K i =
      fun omega => HighDimProb.traceMatrixExp
        (HighDimProb.troppStateHistory theta X K i omega +
          HighDimProb.troppCurrentRandomStep theta X i omega) := by
  exact HighDimProb.troppNaturalState_left theta X K i

example {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (theta : Real)
    (X : Fin m -> HighDimProb.RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real) (i : Fin m) :
    HighDimProb.troppStateRight theta X K i =
      fun omega => HighDimProb.traceMatrixExp
        (HighDimProb.troppStateHistory theta X K i omega +
          HighDimProb.troppCurrentComparisonStep K i) := by
  exact HighDimProb.troppNaturalState_right theta X K i

example {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (X : Fin m -> HighDimProb.RandomMatrix Omega n n) :
    (fun omega => HighDimProb.traceMatrixExp
      (HighDimProb.randomMatrixPrefixSum X (Fin.last m) omega)) =
      fun omega => HighDimProb.traceMatrixExp
        (HighDimProb.randomMatrixSum X omega) :=
  HighDimProb.traceMatrixExp_randomMatrixPrefixSum_last X

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {n : Nat}
    (X : HighDimProb.RandomMatrix Omega n n)
    (V : Matrix (Fin n) (Fin n) Real) (theta R : Real)
    (hCFC : forall omega,
      HighDimProb.bernsteinMatrixExp_le_quadratic_statement
        (X omega) theta R)
    (hRand : HighDimProb.IsRandomMatrix P X)
    (hSA : HighDimProb.RandomSelfAdjointMatrix P X)
    (hIntX : HighDimProb.IntegrableRandomMatrix P X)
    (hIntSq : HighDimProb.IntegrableRandomMatrix P
      (HighDimProb.randomMatrixSquare X))
    (hIntExp :
      HighDimProb.IntegrableRandomMatrix P
        (fun omega => HighDimProb.matrixExp (SMul.smul theta (X omega))))
    (hMeanZero : HighDimProb.matrixExpect P X = 0)
    (hBound : forall omega, HighDimProb.operatorNorm X omega <= R)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3)
    (hVSA : HighDimProb.IsSelfAdjointMatrix V)
    (hVPSD : HighDimProb.IsPSDMatrix V)
    (hSecond : HighDimProb.MatrixLE (HighDimProb.matrixSecondMoment P X) V) :
    HighDimProb.MatrixLE
      (HighDimProb.matrixExpect P
        (fun omega => HighDimProb.matrixExp (SMul.smul theta (X omega))))
      (HighDimProb.matrixExp
        (SMul.smul
          ((theta ^ 2 / 2) / (1 - abs theta * R / 3)) V)) := by
  exact
    HighDimProb.singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic
      X V theta R hCFC hRand hSA hIntX hIntSq hIntExp hMeanZero hBound
      hR hRange hVSA hVPSD hSecond

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (H : Matrix (Fin n) (Fin n) Real)
    (Z : HighDimProb.RandomMatrix Omega n n)
    (hStep : HighDimProb.troppMasterTraceMGFStep_statement (P := P) H Z)
    (K : Matrix (Fin n) (Fin n) Real)
    (hBridge : HighDimProb.troppLogExpComparisonToK_statement H
      (HighDimProb.matrixExpect P
        (fun omega => HighDimProb.matrixExp (Z omega))) K)
    (hH : HighDimProb.IsSelfAdjointMatrix H)
    (hZ : HighDimProb.RandomSelfAdjointMatrix P Z)
    (hTraceInt : HighDimProb.IntegrableRealRandomVariable P
      (fun omega => HighDimProb.traceMatrixExp (H + Z omega)))
    (hExpInt : HighDimProb.IntegrableRandomMatrix P
      (fun omega => HighDimProb.matrixExp (Z omega)))
    (hExpMeanSA : HighDimProb.IsSelfAdjointMatrix
      (HighDimProb.matrixExpect P
        (fun omega => HighDimProb.matrixExp (Z omega))))
    (hExpMeanPos : IsStrictlyPositive
      (HighDimProb.matrixExpect P
        (fun omega => HighDimProb.matrixExp (Z omega))))
    (hKSA : HighDimProb.IsSelfAdjointMatrix K)
    (hMGFToK : HighDimProb.MatrixLE
      (HighDimProb.matrixExpect P
        (fun omega => HighDimProb.matrixExp (Z omega)))
      (HighDimProb.matrixExp K)) :
    HighDimProb.expect P
        (fun omega => HighDimProb.traceMatrixExp (H + Z omega)) <=
      HighDimProb.traceMatrixExp (H + K) := by
  exact
    HighDimProb.troppMasterTraceMGFStep_trace_bound_of_logExpComparisonToK
      H K Z hStep hBridge hH hZ hTraceInt hExpInt hExpMeanSA hExpMeanPos
      hKSA hMGFToK

example {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} {n : Nat}
    (mHist : MeasurableSpace Omega)
    (H Z : HighDimProb.RandomMatrix Omega n n)
    (K : Matrix (Fin n) (Fin n) Real)
    (hCond :
      @HighDimProb.troppMasterTraceMGFConditionalStep_statement
        Omega mOmega P n mHist H Z K)
    (hHistSub : mHist ≤ mOmega)
    (hHistRand : @HighDimProb.IsRandomMatrix Omega mOmega n n P H)
    (hZRand : @HighDimProb.IsRandomMatrix Omega mOmega n n P Z)
    (hHistMeas :
      forall i j,
        @Measurable Omega Real mHist inferInstance
          (fun omega => H omega i j))
    (hHistSA : forall omega, HighDimProb.IsSelfAdjointMatrix (H omega))
    (hZSA : @HighDimProb.RandomSelfAdjointMatrix Omega mOmega n P Z)
    (hIndep :
      @ProbabilityTheory.IndepFun Omega _ _ mOmega _ _ H Z P)
    (hCondTraceInt :
      @HighDimProb.IntegrableRealRandomVariable Omega mOmega P
        (fun omega => HighDimProb.traceMatrixExp (H omega + Z omega)))
    (hExpInt :
      @HighDimProb.IntegrableRandomMatrix Omega mOmega n n P
        (fun omega => HighDimProb.matrixExp (Z omega)))
    (hExpMeanSA : HighDimProb.IsSelfAdjointMatrix
      (@HighDimProb.matrixExpect Omega mOmega n n P
        (fun omega => HighDimProb.matrixExp (Z omega))))
    (hExpMeanPos : IsStrictlyPositive
      (@HighDimProb.matrixExpect Omega mOmega n n P
        (fun omega => HighDimProb.matrixExp (Z omega))))
    (hKSA : HighDimProb.IsSelfAdjointMatrix K)
    (hMGFToK : HighDimProb.MatrixLE
      (@HighDimProb.matrixExpect Omega mOmega n n P
        (fun omega => HighDimProb.matrixExp (Z omega)))
      (HighDimProb.matrixExp K)) :
    ∀ᵐ omega ∂P,
      MeasureTheory.condExp (m := mHist) P
          (fun omega' => HighDimProb.traceMatrixExp (H omega' + Z omega'))
            omega <=
        HighDimProb.traceMatrixExp (H omega + K) := by
  exact hCond hHistSub hHistRand hZRand hHistMeas hHistSA hZSA hIndep
    hCondTraceInt hExpInt hExpMeanSA hExpMeanPos hKSA hMGFToK

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta : Real)
    (hY : HighDimProb.RandomSelfAdjointMatrix P Y) :
    0 <= HighDimProb.traceExpMoment P Y theta := by
  exact HighDimProb.traceExpMoment_nonneg_of_randomSelfAdjoint Y theta hY

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta : Real)
    (hNonneg : forall omega,
      0 <= HighDimProb.traceExpIntegrand Y theta omega) :
    0 <= HighDimProb.traceExpMoment P Y theta := by
  exact HighDimProb.traceExpMoment_nonneg_of_nonneg (P := P) Y theta hNonneg

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta : Real)
    (hInt : HighDimProb.IntegrableRealRandomVariable P
      (HighDimProb.traceExpIntegrand Y theta))
    (hNonneg : forall omega,
      0 <= HighDimProb.traceExpIntegrand Y theta omega) :
    HighDimProb.traceExpMomentLIntegral P Y theta =
      ENNReal.ofReal (HighDimProb.traceExpMoment P Y theta) := by
  exact HighDimProb.traceExpMomentLIntegral_eq_ofReal_traceExpMoment
    Y theta hInt hNonneg

end
