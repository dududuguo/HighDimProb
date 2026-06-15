import HighDimProb.RandomMatrix.ConcentrationStatements

namespace HighDimProb

open MeasureTheory

noncomputable section

#check SelfAdjointOperatorNormTailEvent
#check twoSidedQuadraticFormTailEvent
#check selfAdjointOperatorNormTailViaQuadraticFormStatement
#check randomSelfAdjointMatrix_sum
#check matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
#check matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives

example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega (n + 1) (n + 1)) (t : Real)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P A)
    (ht : 0 < t)
    (hBridge :
      selfAdjointOperatorNormTailViaQuadraticFormStatement
        (randomMatrixSum A) t) :
    SelfAdjointOperatorNormTailEvent (randomMatrixSum A) t <=
      twoSidedQuadraticFormTailEvent (randomMatrixSum A) t := by
  exact hBridge
    (randomSelfAdjointMatrix_sum (P := P) (A := A) hCentered.1.2)
    ht.le

end

end HighDimProb
