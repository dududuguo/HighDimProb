import HighDimProb.RandomMatrix.TailEventDominationProvider

open MeasureTheory
open scoped MatrixOrder Matrix.Norms.L2Operator Pointwise

#check HighDimProb.exp_mul_lambdaMaxOrdered_le_traceMatrixExp_smul
#check HighDimProb.lambdaMaxOrderedUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint
#check HighDimProb.quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint

example {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (theta : Real) (hTheta : 0 <= theta)
    (hA : HighDimProb.IsSelfAdjointMatrix A) :
    Real.exp (theta * HighDimProb.lambdaMaxOrdered A hA) <=
      HighDimProb.traceMatrixExp (theta • A) := by
  exact
    HighDimProb.exp_mul_lambdaMaxOrdered_le_traceMatrixExp_smul hA theta hTheta

example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : HighDimProb.RandomMatrix Omega (n + 1) (n + 1))
    (theta t : Real)
    (hTheta : 0 <= theta)
    (hY : HighDimProb.RandomSelfAdjointMatrix P Y) :
    HighDimProb.lambdaMaxOrderedUpperTailEvent Y hY t ⊆
      HighDimProb.traceExpThresholdEvent Y theta t := by
  exact
    HighDimProb.lambdaMaxOrderedUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint
      Y theta t hY hTheta

example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : HighDimProb.RandomMatrix Omega (n + 1) (n + 1))
    (theta t : Real)
    (hTheta : 0 <= theta)
    (hY : HighDimProb.RandomSelfAdjointMatrix P Y) :
    HighDimProb.quadraticFormUpperTailEvent Y t ⊆
      HighDimProb.traceExpThresholdEvent Y theta t := by
  exact
    HighDimProb.quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint
      Y theta t hY hTheta

example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {m n : Nat}
    (X : Fin m -> HighDimProb.RandomMatrix Omega (n + 1) (n + 1))
    (theta t : Real)
    (hTheta : 0 <= theta)
    (hX : forall i, HighDimProb.RandomSelfAdjointMatrix P (X i)) :
    HighDimProb.quadraticFormUpperTailEvent (HighDimProb.randomMatrixSum X) t ⊆
      HighDimProb.traceExpThresholdEvent (HighDimProb.randomMatrixSum X) theta t := by
  exact
    HighDimProb.quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint
      (HighDimProb.randomMatrixSum X) theta t
      (HighDimProb.randomSelfAdjointMatrix_sum hX) hTheta
