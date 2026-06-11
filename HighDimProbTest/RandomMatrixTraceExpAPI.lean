import HighDimProb.RandomMatrix.TraceExp

open MeasureTheory
open HighDimProb
open scoped MatrixOrder Matrix.Norms.Operator

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega}
variable {n : Nat}
variable (A V : Matrix (Fin n) (Fin n) Real)
variable (B : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
variable (Y : RandomMatrix Omega n n)
variable {I : Type*} [Fintype I]
variable (Xfam : I -> RandomMatrix Omega n n)
variable (Kfam : I -> Matrix (Fin n) (Fin n) Real)
variable (theta rhs R : Real)
variable (rhsL : ENNReal)
variable (hA : IsSelfAdjointMatrix A)
variable (hB : IsSelfAdjointMatrix B)
variable (hY : RandomSelfAdjointMatrix P Y)
variable (hPSD : Matrix.PosSemidef A)
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
variable (hNonneg : forall omega, 0 <= traceExpIntegrand Y theta omega)
variable (hBernsteinRange : abs theta * R < 3)

#check matrixExp
#check matrixExp_apply
#check matrixTrace
#check matrixTrace_apply
#check traceMatrixExp
#check traceMatrixExp_apply
#check isSelfAdjointMatrix_smul
#check isSelfAdjointMatrix_neg
#check randomSelfAdjointMatrix_smul
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
#check troppMasterTraceMGFFiniteFamily_statement
#check bernsteinMGFCoeff
#check bernsteinCoefficient_nonneg
#check bernsteinMGFCoeff_nonneg
#check TraceMGFBernsteinVarianceProxyBound
#check TraceMGFBernsteinVarianceProxyBoundLIntegral
#check bernsteinMatrixExp_le_quadratic_statement
#check singleSummandMatrixMGFVarianceProxy_statement
#check singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic
#check traceMatrixExp_nonneg_of_selfAdjoint_statement
#check traceMatrixExp_nonneg_of_selfAdjoint
#check lambdaMaxOrdered_matrixExp
#check traceMatrixExp_smul_le_card_exp_of_lambdaMaxOrdered_le
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
#check traceMGFBernsteinVarianceProxyBoundLIntegral_of_traceMGFBernsteinVarianceProxyBound

#check (matrixExp A : Matrix (Fin n) (Fin n) Real)
#check (matrixTrace A : Real)
#check (traceMatrixExp A : Real)
#check (isSelfAdjointMatrix_smul theta hA :
  IsSelfAdjointMatrix (theta • A))
#check (isSelfAdjointMatrix_neg hA : IsSelfAdjointMatrix (-A))
#check (randomSelfAdjointMatrix_smul theta hY :
  RandomSelfAdjointMatrix P (fun omega => theta • Y omega))
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
#check (troppMasterTraceMGFStep_statement (P := P) A Y : Prop)
#check (troppMasterTraceMGFFiniteFamily_statement (P := P) Xfam Kfam V theta R :
  Prop)
#check (bernsteinCoefficient_nonneg hBernsteinRange :
  0 <= (theta ^ 2 / 2) / (1 - abs theta * R / 3))
#check (bernsteinMGFCoeff_nonneg hBernsteinRange :
  0 <= bernsteinMGFCoeff theta R)
#check (TraceMGFBernsteinVarianceProxyBound P Y V theta R : Prop)
#check (TraceMGFBernsteinVarianceProxyBoundLIntegral P Y V theta R : Prop)
#check (bernsteinMatrixExp_le_quadratic_statement A theta R : Prop)
#check (singleSummandMatrixMGFVarianceProxy_statement (P := P) Y V theta R :
  Prop)
#check (hTropp hA hY hTroppTraceInt hExpInt hExpMeanSA hExpMeanPos :
  expect P (fun omega => traceMatrixExp (A + Y omega)) <=
    traceMatrixExp
      (A + CFC.log (matrixExpect P (fun omega => matrixExp (Y omega)))))
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
