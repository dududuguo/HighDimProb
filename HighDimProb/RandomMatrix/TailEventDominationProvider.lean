import HighDimProb.RandomMatrix.Laplace

/-!
# Tail-event domination provider bridges

This module isolates the exact tail-event subset leaf used to enter the
matrix Laplace route from ordered top-eigenvalue and quadratic-form upper-tail
events.

It does not prove trace-MGF bounds, conditioning, variance-proxy
normalization, theta optimization, or Matrix Bernstein.
-/

namespace HighDimProb

open MeasureTheory
open scoped MatrixOrder Matrix.Norms.L2Operator Pointwise

noncomputable section

/-- Deterministic trace-exp lower bound at the ordered top eigenvalue.

This is the pointwise domination leaf behind the Laplace tail-event bridge. -/
theorem exp_mul_lambdaMaxOrdered_le_traceMatrixExp_smul
    {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) (theta : Real) (hTheta : 0 <= theta) :
    Real.exp (theta * lambdaMaxOrdered A hA) <=
      traceMatrixExp (SMul.smul theta A) := by
  simpa [TraceExpDominatesUpperBound] using
    lambdaMaxOrdered_traceExpDominatesUpperBound hA theta hTheta

/-- Self-adjoint ordered lambda-max upper-tail events are dominated by the
trace-exp threshold event used in the Laplace route. -/
theorem lambdaMaxOrderedUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : RandomMatrix Omega (n + 1) (n + 1))
    (theta t : Real)
    (hY : RandomSelfAdjointMatrix P Y) (hTheta : 0 <= theta) :
    lambdaMaxOrderedUpperTailEvent Y hY t ⊆ traceExpThresholdEvent Y theta t := by
  simpa [lambdaMaxOrderedUpperTailEvent_eq_matrixUpperBoundTailEvent] using
    matrixUpperBoundTailEvent_subset_traceExpThresholdEvent_of_traceExpDominatesUpperBound
      Y (fun omega => lambdaMaxOrdered (Y omega) (hY omega)) theta t hTheta
      (fun omega => lambdaMaxOrdered_traceExpDominatesUpperBound (hY omega) theta hTheta)

/-- Self-adjoint quadratic-form upper-tail events are dominated by the
trace-exp threshold event used in the Laplace route. -/
theorem quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : RandomMatrix Omega (n + 1) (n + 1))
    (theta t : Real)
    (hY : RandomSelfAdjointMatrix P Y) (hTheta : 0 <= theta) :
    quadraticFormUpperTailEvent Y t ⊆ traceExpThresholdEvent Y theta t := by
  exact Set.Subset.trans
    (quadraticFormUpperTailEvent_subset_lambdaMaxOrderedUpperTailEvent_of_matrixQuadraticForm_le_lambdaMaxOrdered
      Y t hY (fun omega => lambdaMaxOrdered_rayleighUpperBound (hY omega)))
    (lambdaMaxOrderedUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint
      Y theta t hY hTheta)

end

end HighDimProb
