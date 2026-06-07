import HighDimProb.RandomMatrix.TraceExp

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega}
variable {n : Nat}
variable (A V : Matrix (Fin n) (Fin n) Real)
variable (B : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
variable (Y : RandomMatrix Omega n n)
variable (theta rhs : Real)
variable (rhsL : ENNReal)
variable (hA : IsSelfAdjointMatrix A)
variable (hB : IsSelfAdjointMatrix B)
variable (hY : RandomSelfAdjointMatrix P Y)
variable (hPSD : Matrix.PosSemidef A)
variable (hExpPSD : Matrix.PosSemidef (matrixExp A))
variable (hInt : IntegrableRealRandomVariable P (traceExpIntegrand Y theta))
variable (hNonneg : forall omega, 0 <= traceExpIntegrand Y theta omega)

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
#check traceExpIntegrand
#check traceExpMoment
#check traceExpMomentLIntegral
#check TraceMGFBound
#check TraceMGFBoundLIntegral
#check TraceMGFVarianceProxyBound
#check TraceMGFVarianceProxyBoundLIntegral
#check traceMatrixExp_nonneg_of_selfAdjoint_statement
#check traceMatrixExp_nonneg_of_selfAdjoint
#check lambdaMaxOrdered_matrixExp
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
#check (traceExpIntegrand Y theta : RealRandomVariable Omega)
#check (traceExpMoment P Y theta : Real)
#check (traceExpMomentLIntegral P Y theta : ENNReal)
#check (TraceMGFBound P Y theta rhs : Prop)
#check (TraceMGFBoundLIntegral P Y theta rhsL : Prop)
#check (TraceMGFVarianceProxyBound P Y V theta : Prop)
#check (TraceMGFVarianceProxyBoundLIntegral P Y V theta : Prop)
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

example : traceMatrixExp A = Matrix.trace (NormedSpace.exp A) := by
  rfl

example : Matrix.PosSemidef (matrixExp A) := by
  exact matrixExp_posSemidef_of_selfAdjoint hA

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

example : 0 <= traceExpMoment P Y theta := by
  exact traceExpMoment_nonneg_of_nonneg (P := P) Y theta hNonneg

example : 0 <= traceExpMoment P Y theta := by
  exact traceExpMoment_nonneg_of_randomSelfAdjoint Y theta hY

example : traceExpMomentLIntegral P Y theta =
    ENNReal.ofReal (traceExpMoment P Y theta) := by
  exact traceExpMomentLIntegral_eq_ofReal_traceExpMoment Y theta hInt hNonneg
