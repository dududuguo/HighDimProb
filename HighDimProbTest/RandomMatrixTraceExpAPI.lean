import HighDimProb.RandomMatrix.TraceExp

open MeasureTheory
open HighDimProb
open scoped MatrixOrder Matrix.Norms.Operator

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega}
variable {n : Nat}
variable (A V K : Matrix (Fin n) (Fin n) Real)
variable (B : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
variable (Y : RandomMatrix Omega n n)
variable {I : Type*} [Fintype I]
variable (Xfam : I -> RandomMatrix Omega n n)
variable (Kfam : I -> Matrix (Fin n) (Fin n) Real)
variable (theta rhs R t sigmaSq : Real)
variable (rhsL : ENNReal)
variable (hA : IsSelfAdjointMatrix A)
variable (hK : IsSelfAdjointMatrix K)
variable (hB : IsSelfAdjointMatrix B)
variable (hY : RandomSelfAdjointMatrix P Y)
variable (hPSD : Matrix.PosSemidef A)
variable (hSupportProj : IsStarProjection A)
variable (hExpPSD : Matrix.PosSemidef (matrixExp A))
variable (hInt : IntegrableRealRandomVariable P (traceExpIntegrand Y theta))
variable (hTroppTraceInt :
  IntegrableRealRandomVariable P (fun omega => traceMatrixExp (A + Y omega)))
variable (hExpInt : IntegrableRandomMatrix P (fun omega => matrixExp (Y omega)))
variable (hExpMeanSA :
  IsSelfAdjointMatrix (matrixExpect P (fun omega => matrixExp (Y omega))))
variable (hExpMeanPos :
  IsStrictlyPositive (matrixExpect P (fun omega => matrixExp (Y omega))))
variable (hTropp : troppMasterTraceMGFStep_statement (P := P) A Y)
variable (hTroppLogBridge :
  troppLogExpComparisonToK_statement A
    (matrixExpect P (fun omega => matrixExp (Y omega))) K)
variable (hTroppMGFToK :
  MatrixLE (matrixExpect P (fun omega => matrixExp (Y omega)))
    (matrixExp K))
variable (hNonneg : forall omega, 0 <= traceExpIntegrand Y theta omega)
variable (hBernsteinRange : abs theta * R < 3)

#check matrixExp
#check matrixExp_apply
#check matrixTrace
#check matrixTrace_apply
#check matrixTrace_eq_rank_of_isStarProjection
#check (matrixTrace_eq_rank_of_isStarProjection hSupportProj :
  matrixTrace A = (Matrix.rank A : Real))
#check traceMatrixExp
#check traceMatrixExp_apply
#check isSelfAdjointMatrix_smul
#check isSelfAdjointMatrix_neg
#check randomSelfAdjointMatrix_smul
#check randomSelfAdjointMatrix_scaledRandomMatrix
#check randomSelfAdjointMatrix_neg
#check isSelfAdjointMatrix_matrixExp
#check matrixTrace_nonneg_of_posSemidef
#check traceMatrixExp_nonneg_of_matrixExp_posSemidef
#check matrixExp_posSemidef_of_selfAdjoint_statement
#check matrixExp_posSemidef_of_selfAdjoint
#check matrixLE_one_add_self_le_matrixExp_of_selfAdjoint
#check matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint
#check traceExpIntegrand
#check traceExpMoment
#check traceExpMomentLIntegral
#check TraceMGFBound
#check TraceMGFBoundLIntegral
#check TraceMGFVarianceProxyBound
#check TraceMGFVarianceProxyBoundLIntegral
#check troppMasterTraceMGFStep_statement
#check troppLogExpComparisonToK_statement
#check troppMasterTraceMGFStep_trace_bound_of_logExpComparisonToK
#check isRandomMatrix_of_sub_measurable_entries
#check troppMasterTraceMGFConditionalStep_statement
#check troppMasterTraceMGFConditionalStep_apply_of_histEntryMeasurable
#check troppMasterTraceMGFConditionalStep_expect_bound
#check troppTraceExpFiniteFamilyIterationSkeleton_of_conditionalSteps
#check troppTraceExpFiniteFamilyIterationSkeleton_of_naturalStateConditionalSteps
#check troppMasterTraceMGFFiniteFamily_statement
#check troppMasterTraceMGFFiniteFamily_statement_of_reindexedFin
#check troppMasterTraceMGFFiniteFamily_of_conditionalSteps
#check troppMasterTraceMGFFiniteFamily_of_naturalStateConditionalSteps
#check comparisonMatrixPrefixSum
#check comparisonMatrixSuffixSum
#check randomMatrixPrefixSum
#check randomMatrixSuffixSum
#check comparisonMatrixPrefixSum_zero
#check comparisonMatrixPrefixSum_succ
#check comparisonMatrixPrefixSum_last
#check comparisonMatrixSuffixSum_zero
#check comparisonMatrixSuffixSum_succ
#check comparisonMatrixSuffixSum_last
#check randomMatrixPrefixSum_zero
#check randomMatrixPrefixSum_succ
#check randomMatrixPrefixSum_last
#check randomMatrixSuffixSum_zero
#check randomMatrixSuffixSum_succ
#check randomMatrixSuffixSum_last
#check randomMatrixSum_eq_prefixSum_last
#check traceMatrixExp_randomMatrixPrefixSum_last
#check traceMatrixExp_comparisonMatrixPrefixSum_last
#check troppRandomHistory
#check troppComparisonHistory
#check troppCurrentRandomStep
#check troppCurrentComparisonStep
#check troppStateHistory
#check troppTraceState
#check troppStateLeft
#check troppStateRight
#check troppNaturalState_zero
#check troppNaturalState_last
#check troppNaturalState_left
#check troppNaturalState_right
#check scaledRandomMatrixFamily
#check bernsteinMGFCoeff
#check bernsteinThetaChoice
#check bernsteinThetaChoice_den_pos
#check bernsteinThetaChoice_nonneg
#check bernsteinThetaChoice_pos
#check bernsteinThetaChoice_range
#check bernsteinThetaChoice_exponent_eq
#check bernsteinCoefficient_nonneg
#check bernsteinMGFCoeff_neg
#check bernsteinMGFCoeff_nonneg
#check TraceMGFBernsteinVarianceProxyBound
#check TraceMGFBernsteinVarianceProxyBoundLIntegral
#check bernsteinMatrixExp_le_quadratic_statement
#check bernsteinMatrixExp_le_quadratic_neg_of_neg_theta
#check singleSummandMatrixMGFVarianceProxy_statement
#check singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic
#check traceMatrixExp_nonneg_of_selfAdjoint_statement
#check traceMatrixExp_nonneg_of_selfAdjoint
#check lambdaMaxOrdered_matrixExp
#check traceMatrixExp_smul_le_card_exp_of_lambdaMaxOrdered_le
#check traceMatrixExp_smul_le_card_add_trace_div_mul_exp_sub_one_of_psd_lambdaMax_le
#check matrixTrace_le_card_mul_of_isPSD_lambdaMaxOrdered_le
#check traceMatrixExp_eq_sum_exp_eigenvalues
#check (traceMatrixExp_eq_sum_exp_eigenvalues hB :
  traceMatrixExp B = Finset.univ.sum fun i => Real.exp (hB.eigenvalues i))
#check traceExpMoment_nonneg_statement
#check traceExpMoment_nonneg_of_nonneg
#check traceExpIntegrand_nonneg_of_randomSelfAdjoint
#check traceExpMoment_nonneg_of_randomSelfAdjoint
#check traceExpMomentLIntegral_nonneg
#check traceExpMomentLIntegral_eq_ofReal_statement
#check traceExpMomentLIntegral_eq_ofReal_traceExpMoment
#check traceExpMomentBoundStatement
#check traceExpVarianceProxyBoundStatement
#check traceMGFBound_statement
#check traceMGFBoundLIntegral_statement
#check traceMGFVarianceProxyBound_statement
#check traceMGFBernsteinVarianceProxyBound_statement
#check traceMGFBernsteinVarianceProxyBoundLIntegral_of_real_statement
#check traceMGFBernsteinVarianceProxyBound_of_troppMasterTraceMGFFiniteFamily
#check traceMGFBernsteinVarianceProxyBound_of_troppConditionalSteps
#check traceMGFBernsteinVarianceProxyBound_of_naturalStateConditionalSteps
#check traceMGFBernsteinVarianceProxyBoundLIntegral_of_traceMGFBernsteinVarianceProxyBound

#check (matrixExp A : Matrix (Fin n) (Fin n) Real)
#check (matrixTrace A : Real)
#check (traceMatrixExp A : Real)
#check (isSelfAdjointMatrix_smul theta hA :
  IsSelfAdjointMatrix (theta • A))
#check (isSelfAdjointMatrix_neg hA : IsSelfAdjointMatrix (-A))
#check (randomSelfAdjointMatrix_smul theta hY :
  RandomSelfAdjointMatrix P (fun omega => theta • Y omega))
#check (randomSelfAdjointMatrix_scaledRandomMatrix theta hY :
  RandomSelfAdjointMatrix P (scaledRandomMatrix theta Y))
#check (randomSelfAdjointMatrix_neg hY :
  RandomSelfAdjointMatrix P (fun omega => -Y omega))
#check (isSelfAdjointMatrix_matrixExp hA : IsSelfAdjointMatrix (matrixExp A))
#check (matrixTrace_nonneg_of_posSemidef hPSD : 0 <= matrixTrace A)
#check (traceMatrixExp_nonneg_of_matrixExp_posSemidef hExpPSD :
  0 <= traceMatrixExp A)
#check (matrixExp_posSemidef_of_selfAdjoint_statement A : Prop)
#check (matrixExp_posSemidef_of_selfAdjoint hA :
  Matrix.PosSemidef (matrixExp A))
#check (matrixLE_one_add_self_le_matrixExp_of_selfAdjoint hA :
  MatrixLE ((1 : Matrix (Fin n) (Fin n) Real) + A) (matrixExp A))
#check (matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint theta hA :
  MatrixLE ((1 : Matrix (Fin n) (Fin n) Real) + SMul.smul theta A)
    (matrixExp (SMul.smul theta A)))
#check (traceExpIntegrand Y theta : RealRandomVariable Omega)
#check (traceExpMoment P Y theta : Real)
#check (traceExpMomentLIntegral P Y theta : ENNReal)
#check (TraceMGFBound P Y theta rhs : Prop)
#check (TraceMGFBoundLIntegral P Y theta rhsL : Prop)
#check (TraceMGFVarianceProxyBound P Y V theta : Prop)
#check (TraceMGFVarianceProxyBoundLIntegral P Y V theta : Prop)
#check (bernsteinMGFCoeff theta R : Real)
#check (bernsteinThetaChoice t sigmaSq R : Real)
#check (bernsteinThetaChoice_den_pos (t := t) (sigmaSq := sigmaSq) (R := R) :
  0 < sigmaSq -> 0 <= R -> 0 <= t -> 0 < sigmaSq + R * t / 3)
#check (bernsteinThetaChoice_nonneg (t := t) (sigmaSq := sigmaSq) (R := R) :
  0 <= t -> 0 < sigmaSq + R * t / 3 ->
    0 <= bernsteinThetaChoice t sigmaSq R)
#check (bernsteinThetaChoice_pos (t := t) (sigmaSq := sigmaSq) (R := R) :
  0 < t -> 0 < sigmaSq + R * t / 3 ->
    0 < bernsteinThetaChoice t sigmaSq R)
#check (bernsteinThetaChoice_range (t := t) (sigmaSq := sigmaSq) (R := R) :
  0 < sigmaSq -> 0 <= R -> 0 <= t ->
    abs (bernsteinThetaChoice t sigmaSq R) * R < 3)
#check (bernsteinThetaChoice_exponent_eq (t := t) (sigmaSq := sigmaSq) (R := R) :
  0 < sigmaSq -> 0 <= R -> 0 <= t ->
    -(bernsteinThetaChoice t sigmaSq R * t) +
        bernsteinMGFCoeff (bernsteinThetaChoice t sigmaSq R) R * sigmaSq =
      -(t ^ 2 / (2 * sigmaSq + (2 / 3) * R * t)))
#check (troppMasterTraceMGFStep_statement (P := P) A Y : Prop)
#check (troppLogExpComparisonToK_statement A V K : Prop)
#check (troppMasterTraceMGFFiniteFamily_statement (P := P) Xfam Kfam V theta R :
  Prop)
#check (scaledRandomMatrixFamily theta Xfam :
  I -> RandomMatrix Omega n n)

section PrefixSuffixBookkeeping

variable {m : Nat}
variable (Xfin : Fin m -> RandomMatrix Omega n n)
variable (Kfin : Fin m -> Matrix (Fin n) (Fin n) Real)

#check (comparisonMatrixPrefixSum Kfin :
  Fin (m + 1) -> Matrix (Fin n) (Fin n) Real)
#check (comparisonMatrixSuffixSum Kfin :
  Fin (m + 1) -> Matrix (Fin n) (Fin n) Real)
#check (randomMatrixPrefixSum Xfin :
  Fin (m + 1) -> RandomMatrix Omega n n)
#check (randomMatrixSuffixSum Xfin :
  Fin (m + 1) -> RandomMatrix Omega n n)
#check (troppRandomHistory theta Xfin :
  Fin m -> RandomMatrix Omega n n)
#check (troppComparisonHistory Kfin :
  Fin m -> Matrix (Fin n) (Fin n) Real)
#check (troppCurrentRandomStep theta Xfin :
  Fin m -> RandomMatrix Omega n n)
#check (troppCurrentComparisonStep Kfin :
  Fin m -> Matrix (Fin n) (Fin n) Real)
#check (troppStateHistory theta Xfin Kfin :
  Fin m -> RandomMatrix Omega n n)
#check (troppTraceState theta Xfin Kfin :
  Fin (m + 1) -> RealRandomVariable Omega)
#check (troppStateLeft theta Xfin Kfin :
  Fin m -> RealRandomVariable Omega)
#check (troppStateRight theta Xfin Kfin :
  Fin m -> RealRandomVariable Omega)

example (i : Fin m) :
    comparisonMatrixPrefixSum Kfin i.succ =
      comparisonMatrixPrefixSum Kfin i.castSucc + Kfin i := by
  exact comparisonMatrixPrefixSum_succ Kfin i

example (i : Fin m) :
    comparisonMatrixSuffixSum Kfin i.castSucc =
      Kfin i + comparisonMatrixSuffixSum Kfin i.succ := by
  exact comparisonMatrixSuffixSum_succ Kfin i

example :
    randomMatrixSum Xfin =
      randomMatrixPrefixSum Xfin (Fin.last m) := by
  exact randomMatrixSum_eq_prefixSum_last Xfin

example :
    (fun omega => traceMatrixExp (randomMatrixPrefixSum Xfin (Fin.last m) omega)) =
      fun omega => traceMatrixExp (randomMatrixSum Xfin omega) := by
  exact traceMatrixExp_randomMatrixPrefixSum_last Xfin

example :
    (fun _omega : Omega =>
      traceMatrixExp (comparisonMatrixPrefixSum Kfin (Fin.last m))) =
      fun _omega : Omega =>
        traceMatrixExp (Finset.univ.sum fun i : Fin m => Kfin i) := by
  exact traceMatrixExp_comparisonMatrixPrefixSum_last Kfin

example :
    troppTraceState theta Xfin Kfin 0 =
      fun omega =>
        traceMatrixExp
          (randomMatrixSum (scaledRandomMatrixFamily theta Xfin) omega) := by
  exact troppNaturalState_zero theta Xfin Kfin

example :
    troppTraceState theta Xfin Kfin (Fin.last m) =
      fun _omega : Omega =>
        traceMatrixExp (Finset.univ.sum fun i : Fin m => Kfin i) := by
  exact troppNaturalState_last theta Xfin Kfin

example (i : Fin m) :
    troppStateLeft theta Xfin Kfin i =
      fun omega =>
        traceMatrixExp
          (troppStateHistory theta Xfin Kfin i omega +
            troppCurrentRandomStep theta Xfin i omega) := by
  exact troppNaturalState_left theta Xfin Kfin i

example (i : Fin m) :
    troppStateRight theta Xfin Kfin i =
      fun omega =>
        traceMatrixExp
          (troppStateHistory theta Xfin Kfin i omega +
            troppCurrentComparisonStep Kfin i) := by
  exact troppNaturalState_right theta Xfin Kfin i

end PrefixSuffixBookkeeping

#check (bernsteinCoefficient_nonneg hBernsteinRange :
  0 <= (theta ^ 2 / 2) / (1 - abs theta * R / 3))
#check (bernsteinMGFCoeff_neg theta R :
  bernsteinMGFCoeff (-theta) R = bernsteinMGFCoeff theta R)
#check (bernsteinMGFCoeff_nonneg hBernsteinRange :
  0 <= bernsteinMGFCoeff theta R)
#check (TraceMGFBernsteinVarianceProxyBound P Y V theta R : Prop)
#check (TraceMGFBernsteinVarianceProxyBoundLIntegral P Y V theta R : Prop)
#check (bernsteinMatrixExp_le_quadratic_statement A theta R : Prop)
#check (bernsteinMatrixExp_le_quadratic_neg_of_neg_theta A theta R :
  bernsteinMatrixExp_le_quadratic_statement A (-theta) R ->
    bernsteinMatrixExp_le_quadratic_statement (-A) theta R)
#check (singleSummandMatrixMGFVarianceProxy_statement (P := P) Y V theta R :
  Prop)
#check (hTropp hA hY hTroppTraceInt hExpInt hExpMeanSA hExpMeanPos :
  expect P (fun omega => traceMatrixExp (A + Y omega)) <=
    traceMatrixExp
      (A + CFC.log (matrixExpect P (fun omega => matrixExp (Y omega)))))
#check (troppMasterTraceMGFStep_trace_bound_of_logExpComparisonToK
  A K Y hTropp hTroppLogBridge hA hY hTroppTraceInt hExpInt hExpMeanSA
    hExpMeanPos hK hTroppMGFToK :
  expect P (fun omega => traceMatrixExp (A + Y omega)) <=
    traceMatrixExp (A + K))
#check (traceMatrixExp_nonneg_of_selfAdjoint_statement A : Prop)
#check (traceMatrixExp_nonneg_of_selfAdjoint hA :
  0 <= traceMatrixExp A)
#check (lambdaMaxOrdered_matrixExp hB :
  lambdaMaxOrdered (matrixExp B) (isSelfAdjointMatrix_matrixExp hB) =
    Real.exp (lambdaMaxOrdered B hB))
#check (traceExpMoment_nonneg_statement P Y theta : Prop)
#check (traceExpMoment_nonneg_of_nonneg (P := P) Y theta hNonneg :
  0 <= traceExpMoment P Y theta)
#check (traceExpIntegrand_nonneg_of_randomSelfAdjoint theta hY :
  forall omega, 0 <= traceExpIntegrand Y theta omega)
#check (traceExpMoment_nonneg_of_randomSelfAdjoint Y theta hY :
  0 <= traceExpMoment P Y theta)
#check (traceExpMomentLIntegral_nonneg (P := P) Y theta :
  0 <= traceExpMomentLIntegral P Y theta)
#check (traceExpMomentLIntegral_eq_ofReal_statement P Y theta : Prop)
#check (traceExpMomentLIntegral_eq_ofReal_traceExpMoment Y theta hInt hNonneg :
  traceExpMomentLIntegral P Y theta = ENNReal.ofReal (traceExpMoment P Y theta))
#check (traceExpMomentBoundStatement P Y theta rhs : Prop)
#check (traceExpVarianceProxyBoundStatement P Y V theta : Prop)
#check (traceMGFBound_statement P Y theta rhs : Prop)
#check (traceMGFBoundLIntegral_statement P Y theta rhsL : Prop)
#check (traceMGFVarianceProxyBound_statement P Y V theta : Prop)
#check (traceMGFBernsteinVarianceProxyBound_statement P Y V theta R : Prop)
#check (traceMGFBernsteinVarianceProxyBoundLIntegral_of_real_statement
  P Y V theta R : Prop)

example : traceMatrixExp A = Matrix.trace (NormedSpace.exp A) := by
  rfl

example : Matrix.PosSemidef (matrixExp A) := by
  exact matrixExp_posSemidef_of_selfAdjoint hA

example : MatrixLE ((1 : Matrix (Fin n) (Fin n) Real) + A) (matrixExp A) := by
  exact matrixLE_one_add_self_le_matrixExp_of_selfAdjoint hA

example :
    MatrixLE ((1 : Matrix (Fin n) (Fin n) Real) + SMul.smul theta A)
      (matrixExp (SMul.smul theta A)) := by
  exact matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint theta hA

example : 0 <= traceMatrixExp A := by
  exact traceMatrixExp_nonneg_of_selfAdjoint hA

example :
    lambdaMaxOrdered (matrixExp B) (isSelfAdjointMatrix_matrixExp hB) =
      Real.exp (lambdaMaxOrdered B hB) := by
  exact lambdaMaxOrdered_matrixExp hB

example :
    traceMatrixExp B = Finset.univ.sum fun i => Real.exp (hB.eigenvalues i) := by
  exact traceMatrixExp_eq_sum_exp_eigenvalues hB

example : IsSelfAdjointMatrix (theta • A) := by
  exact isSelfAdjointMatrix_smul theta hA

example : RandomSelfAdjointMatrix P (fun omega => theta • Y omega) := by
  exact randomSelfAdjointMatrix_smul theta hY

example : traceExpMomentLIntegral P Y theta =
    ∫⁻ omega, ENNReal.ofReal (traceExpIntegrand Y theta omega) ∂P := by
  rfl

example :
    TraceMGFBound P Y theta rhs =
      (traceExpMoment P Y theta <= rhs) := by
  rfl

example :
    TraceMGFBoundLIntegral P Y theta rhsL =
      (traceExpMomentLIntegral P Y theta <= rhsL) := by
  rfl

example :
    TraceMGFVarianceProxyBound P Y V theta =
      TraceMGFBound P Y theta
        (traceMatrixExp (SMul.smul (theta ^ 2 / 2) V)) := by
  rfl

example :
    TraceMGFVarianceProxyBoundLIntegral P Y V theta =
      TraceMGFBoundLIntegral P Y theta
        (ENNReal.ofReal
          (traceMatrixExp (SMul.smul (theta ^ 2 / 2) V))) := by
  rfl

example :
    TraceMGFBernsteinVarianceProxyBound P Y V theta R =
      TraceMGFBound P Y theta
        (traceMatrixExp (SMul.smul (bernsteinMGFCoeff theta R) V)) := by
  rfl

example :
    TraceMGFBernsteinVarianceProxyBoundLIntegral P Y V theta R =
      TraceMGFBoundLIntegral P Y theta
        (ENNReal.ofReal
          (traceMatrixExp (SMul.smul (bernsteinMGFCoeff theta R) V))) := by
  rfl

example :
    traceMGFBernsteinVarianceProxyBoundLIntegral_of_real_statement
        P Y V theta R =
      (IntegrableRealRandomVariable P (traceExpIntegrand Y theta) ->
        (forall omega, 0 <= traceExpIntegrand Y theta omega) ->
          TraceMGFBernsteinVarianceProxyBound P Y V theta R ->
            TraceMGFBernsteinVarianceProxyBoundLIntegral P Y V theta R) := by
  rfl

example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {n : Nat}
    (X : RandomMatrix Omega n n)
    (V : Matrix (Fin n) (Fin n) Real) (theta R : Real)
    (hCFC : forall omega,
      bernsteinMatrixExp_le_quadratic_statement (X omega) theta R)
    (hRand : IsRandomMatrix P X)
    (hSA : RandomSelfAdjointMatrix P X)
    (hIntX : IntegrableRandomMatrix P X)
    (hIntSq : IntegrableRandomMatrix P (randomMatrixSquare X))
    (hIntExp :
      IntegrableRandomMatrix P
        (fun omega => matrixExp (SMul.smul theta (X omega))))
    (hMeanZero : matrixExpect P X = 0)
    (hBound : forall omega, operatorNorm X omega <= R)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3)
    (hVSA : IsSelfAdjointMatrix V)
    (hVPSD : IsPSDMatrix V)
    (hSecond : MatrixLE (matrixSecondMoment P X) V) :
    MatrixLE
      (matrixExpect P
        (fun omega => matrixExp (SMul.smul theta (X omega))))
      (matrixExp
        (SMul.smul
          ((theta ^ 2 / 2) / (1 - abs theta * R / 3)) V)) := by
  exact singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic
    X V theta R hCFC hRand hSA hIntX hIntSq hIntExp hMeanZero hBound hR
    hRange hVSA hVPSD hSecond

example :
    expect P (fun omega => traceMatrixExp (A + Y omega)) <=
      traceMatrixExp
        (A + CFC.log (matrixExpect P (fun omega => matrixExp (Y omega)))) := by
  exact hTropp hA hY hTroppTraceInt hExpInt hExpMeanSA hExpMeanPos

example : 0 <= traceExpMoment P Y theta := by
  exact traceExpMoment_nonneg_of_nonneg (P := P) Y theta hNonneg

example : 0 <= traceExpMoment P Y theta := by
  exact traceExpMoment_nonneg_of_randomSelfAdjoint Y theta hY

example : traceExpMomentLIntegral P Y theta =
    ENNReal.ofReal (traceExpMoment P Y theta) := by
  exact traceExpMomentLIntegral_eq_ofReal_traceExpMoment Y theta hInt hNonneg

section TroppConditionalStep

variable {OmegaC : Type*} [mOmegaC : MeasurableSpace OmegaC]
variable {P : Measure OmegaC}
variable {n : Nat}
variable (mHist : MeasurableSpace OmegaC)
variable (H Z : RandomMatrix OmegaC n n)
variable (K : Matrix (Fin n) (Fin n) Real)
variable (hCond :
  @troppMasterTraceMGFConditionalStep_statement
    OmegaC mOmegaC P n mHist H Z K)
variable (hHistSub : mHist ≤ mOmegaC)
variable (hHistRand : @IsRandomMatrix OmegaC mOmegaC n n P H)
variable (hZRand : @IsRandomMatrix OmegaC mOmegaC n n P Z)
variable (hHistMeas :
  forall i j,
    @Measurable OmegaC Real mHist inferInstance
      (fun omega => H omega i j))
variable (hHistSA : forall omega, IsSelfAdjointMatrix (H omega))
variable (hZSA : @RandomSelfAdjointMatrix OmegaC mOmegaC n P Z)
variable (hIndep :
  @ProbabilityTheory.IndepFun OmegaC _ _ mOmegaC _ _ H Z P)
variable (hCondTraceInt :
  @IntegrableRealRandomVariable OmegaC mOmegaC P
    (fun omega => traceMatrixExp (H omega + Z omega)))
variable (hExpInt :
  @IntegrableRandomMatrix OmegaC mOmegaC n n P
    (fun omega => matrixExp (Z omega)))
variable (hExpMeanSA :
  IsSelfAdjointMatrix
    (@matrixExpect OmegaC mOmegaC n n P
      (fun omega => matrixExp (Z omega))))
variable (hExpMeanPos :
  IsStrictlyPositive
    (@matrixExpect OmegaC mOmegaC n n P
      (fun omega => matrixExp (Z omega))))
variable (hKSA : IsSelfAdjointMatrix K)
variable (hMGFToK :
  MatrixLE
    (@matrixExpect OmegaC mOmegaC n n P
      (fun omega => matrixExp (Z omega)))
    (matrixExp K))
variable (hSigma : SigmaFinite (P.trim hHistSub))
variable (hRhsInt :
  @IntegrableRealRandomVariable OmegaC mOmegaC P
    (fun omega => traceMatrixExp (H omega + K)))

#check (@troppMasterTraceMGFConditionalStep_statement
  OmegaC mOmegaC P n mHist H Z K : Prop)
#check (@troppMasterTraceMGFConditionalStep_expect_bound
  OmegaC mOmegaC P n mHist H Z K hCond hHistSub hHistRand hZRand
    hHistMeas hHistSA hZSA hIndep hCondTraceInt hExpInt hExpMeanSA
    hExpMeanPos hKSA hMGFToK hSigma hRhsInt)
#check (@troppMasterTraceMGFConditionalStep_apply_of_histEntryMeasurable
  OmegaC mOmegaC P n mHist H Z K hCond hHistSub hZRand hHistMeas
    hHistSA hZSA hIndep hCondTraceInt hExpInt hExpMeanSA hExpMeanPos
    hKSA hMGFToK)
#check (@troppTraceExpFiniteFamilyIterationSkeleton_of_conditionalSteps)

example :
    ∀ᵐ omega ∂P,
      MeasureTheory.condExp (m := mHist) P
          (fun omega' => traceMatrixExp (H omega' + Z omega')) omega <=
        traceMatrixExp (H omega + K) := by
  exact hCond hHistSub hHistRand hZRand hHistMeas hHistSA hZSA hIndep
    hCondTraceInt hExpInt hExpMeanSA hExpMeanPos hKSA hMGFToK

example :
    @expect OmegaC mOmegaC P
        (fun omega => traceMatrixExp (H omega + Z omega)) <=
      @expect OmegaC mOmegaC P
        (fun omega => traceMatrixExp (H omega + K)) := by
  exact @troppMasterTraceMGFConditionalStep_expect_bound
    OmegaC mOmegaC P n mHist H Z K hCond hHistSub hHistRand hZRand
    hHistMeas hHistSA hZSA hIndep hCondTraceInt hExpInt hExpMeanSA
    hExpMeanPos hKSA hMGFToK hSigma hRhsInt

example :
    Filter.EventuallyLE (MeasureTheory.ae P)
      (fun omega =>
        MeasureTheory.condExp (m := mHist) P
          (fun omega' => traceMatrixExp (H omega' + Z omega')) omega)
      (fun omega => traceMatrixExp (H omega + K)) := by
  exact @troppMasterTraceMGFConditionalStep_apply_of_histEntryMeasurable
    OmegaC mOmegaC P n mHist H Z K hCond hHistSub hZRand hHistMeas
    hHistSA hZSA hIndep hCondTraceInt hExpInt hExpMeanSA hExpMeanPos
    hKSA hMGFToK

end TroppConditionalStep
