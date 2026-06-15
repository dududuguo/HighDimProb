import HighDimProb.RandomMatrix.ConcentrationStatements

namespace HighDimProb

open MeasureTheory

noncomputable section

#check twoSidedQuadraticFormTailEvent
#check quadraticFormUpperTailEvent
#check quadraticFormLowerTailEvent
#check quadraticFormLowerTailEvent_subset_quadraticFormUpperTailEvent_neg
#check matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
#check matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega n n) (t : Real) :
    quadraticFormLowerTailEvent A (-t) ⊆
      quadraticFormUpperTailEvent (fun omega => -(A omega)) t := by
  exact quadraticFormLowerTailEvent_subset_quadraticFormUpperTailEvent_neg A t

end

end HighDimProb
