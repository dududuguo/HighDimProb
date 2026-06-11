import HighDimProb.RandomMatrix

noncomputable section

open scoped MatrixOrder Matrix.Norms.Operator

#check HighDimProb.matrixExp
#check HighDimProb.matrixTrace
#check HighDimProb.traceMatrixExp
#check HighDimProb.isSelfAdjointMatrix_smul
#check HighDimProb.isSelfAdjointMatrix_neg
#check HighDimProb.randomSelfAdjointMatrix_smul
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
#check HighDimProb.troppMasterTraceMGFFiniteFamily_statement
#check HighDimProb.bernsteinMGFCoeff
#check HighDimProb.bernsteinCoefficient_nonneg
#check HighDimProb.bernsteinMGFCoeff_nonneg
#check HighDimProb.TraceMGFBernsteinVarianceProxyBound
#check HighDimProb.TraceMGFBernsteinVarianceProxyBoundLIntegral
#check HighDimProb.bernsteinMatrixExp_le_quadratic_statement
#check HighDimProb.singleSummandMatrixMGFVarianceProxy_statement
#check HighDimProb.singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic
#check HighDimProb.traceMatrixExp_nonneg_of_selfAdjoint_statement
#check HighDimProb.traceMatrixExp_nonneg_of_selfAdjoint
#check HighDimProb.lambdaMaxOrdered_matrixExp
#check HighDimProb.traceMatrixExp_smul_le_card_exp_of_lambdaMaxOrdered_le
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

example {n : Nat} (A : Matrix (Fin n) (Fin n) Real)
    (theta R : Real) : Prop :=
  HighDimProb.bernsteinMatrixExp_le_quadratic_statement A theta R

example {theta R : Real} (hRange : abs theta * R < 3) :
    0 <= (theta ^ 2 / 2) / (1 - abs theta * R / 3) := by
  exact HighDimProb.bernsteinCoefficient_nonneg hRange

example {theta R : Real} (hRange : abs theta * R < 3) :
    0 <= HighDimProb.bernsteinMGFCoeff theta R := by
  exact HighDimProb.bernsteinMGFCoeff_nonneg hRange

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (X : HighDimProb.RandomMatrix Omega n n)
    (V : Matrix (Fin n) (Fin n) Real) (theta R : Real) : Prop :=
  HighDimProb.singleSummandMatrixMGFVarianceProxy_statement
    (P := P) X V theta R

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
        (fun omega => HighDimProb.matrixExp (Z omega)))) :
    HighDimProb.expect P
        (fun omega => HighDimProb.traceMatrixExp (H + Z omega)) <=
      HighDimProb.traceMatrixExp
        (H + CFC.log
          (HighDimProb.matrixExpect P
            (fun omega => HighDimProb.matrixExp (Z omega)))) := by
  exact hStep hH hZ hTraceInt hExpInt hExpMeanSA hExpMeanPos

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
