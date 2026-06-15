import HighDimProb.RandomMatrix.Spectral

/-!
# RM-S7A lambda-max tail bridge probe

Validation-only probe for the ordered lambda-max upper-tail bridge into the
existing explicit quadratic-form upper-tail event.
-/

namespace HighDimProb

open MeasureTheory

noncomputable section

#check lambdaMaxOrdered
#check lambdaMaxOrderedUpperTailEvent
#check quadraticFormUpperTailEvent
#check matrixUpperBoundTailEvent
#check lambdaMaxOrdered_spectralUpperBound
#check lambdaMaxOrdered_rayleighUpperBound
#check lambdaMaxOrderedUpperTailEvent_subset_quadraticFormUpperTailEvent

example
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega (n + 1) (n + 1))
    (hA : forall omega, IsSelfAdjointMatrix (A omega)) (t : Real) :
    lambdaMaxOrderedUpperTailEvent A hA t <=
      quadraticFormUpperTailEvent A t := by
  exact lambdaMaxOrderedUpperTailEvent_subset_quadraticFormUpperTailEvent A hA t

end

end HighDimProb
