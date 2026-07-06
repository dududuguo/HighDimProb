import HighDimProb.RandomMatrix.TailEventDominationProvider

open MeasureTheory
open HighDimProb
open scoped MatrixOrder Matrix.Norms.L2Operator Pointwise

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega}
variable {n : Nat}
variable (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
variable (Y : RandomMatrix Omega (n + 1) (n + 1))
variable (theta t : Real)
variable (hA : IsSelfAdjointMatrix A)
variable (hY : RandomSelfAdjointMatrix P Y)
variable (hTheta : 0 <= theta)

#check exp_mul_lambdaMaxOrdered_le_traceMatrixExp_smul
#check lambdaMaxOrderedUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint
#check quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint

#check (exp_mul_lambdaMaxOrdered_le_traceMatrixExp_smul hA theta hTheta :
  Real.exp (theta * lambdaMaxOrdered A hA) <= traceMatrixExp (theta • A))
#check (lambdaMaxOrderedUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint
  Y theta t hY hTheta :
    lambdaMaxOrderedUpperTailEvent Y hY t ⊆ traceExpThresholdEvent Y theta t)
#check (quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint
  Y theta t hY hTheta :
    quadraticFormUpperTailEvent Y t ⊆ traceExpThresholdEvent Y theta t)

example :
    Real.exp (theta * lambdaMaxOrdered A hA) <= traceMatrixExp (theta • A) := by
  exact exp_mul_lambdaMaxOrdered_le_traceMatrixExp_smul hA theta hTheta

example :
    lambdaMaxOrderedUpperTailEvent Y hY t ⊆ traceExpThresholdEvent Y theta t := by
  exact
    lambdaMaxOrderedUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint
      Y theta t hY hTheta

example :
    quadraticFormUpperTailEvent Y t ⊆ traceExpThresholdEvent Y theta t := by
  exact
    quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint
      Y theta t hY hTheta

example {I : Type*} [Fintype I]
    (X : I -> RandomMatrix Omega (n + 1) (n + 1))
    (hX : forall i, RandomSelfAdjointMatrix P (X i)) :
    quadraticFormUpperTailEvent (randomMatrixSum X) t ⊆
      traceExpThresholdEvent (randomMatrixSum X) theta t := by
  exact
    quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint
      (randomMatrixSum X) theta t (randomSelfAdjointMatrix_sum hX) hTheta
