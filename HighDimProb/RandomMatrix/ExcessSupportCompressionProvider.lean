import HighDimProb.RandomMatrix.SupportProvider

/-!
# Excess-support compression provider bridges

This module proves the reusable algebraic bridge behind the ambient identity
excess-support fallback: if `matrixExp A` is support-dominated by `support` and
the support itself is bounded above by the identity, then the excess part
`matrixExp A - 1` is dominated by
`(exp (lambdaMaxOrdered A hA) - 1) 闂?support`.

It does not construct smaller support projections, prove effective-rank bounds,
or prove any Lieb or Matrix Bernstein fact.
-/

namespace HighDimProb

noncomputable section

open scoped MatrixOrder Matrix.Norms.Operator

/-- Compress a support-domination certificate into an excess-support
certificate whenever the support is bounded above by the ambient identity.

This is the reusable algebraic bridge behind the identity excess-support
fallback: the hard spectral work remains in `MatrixExpSupportDomination`, while
`support <= 1` lets us replace `-1` by `-support` on the right-hand side and
rewrite the result as
`(exp (lambdaMaxOrdered A hA) - 1) 闂?support`. -/
theorem matrixExpExcessSupportDomination_of_supportDomination_of_support_le_one
    {n : Nat}
    {A support : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A)
    (hDom : MatrixExpSupportDomination A support hA)
    (hSupportLeOne :
      support <= (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)) :
    MatrixExpExcessSupportDomination A support hA := by
  unfold MatrixExpExcessSupportDomination
  have hDom' :
      matrixExp A <=
        SMul.smul (Real.exp (lambdaMaxOrdered A hA)) support :=
    mathlib_le_of_matrixLE hDom
  have hSub :
      matrixExp A - (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) <=
        SMul.smul (Real.exp (lambdaMaxOrdered A hA)) support -
          (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) := by
    exact sub_le_sub_right hDom'
      (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
  have hSubSupport :
      SMul.smul (Real.exp (lambdaMaxOrdered A hA)) support -
          (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) <=
        SMul.smul (Real.exp (lambdaMaxOrdered A hA)) support - support := by
    exact sub_le_sub_left hSupportLeOne
      (SMul.smul (Real.exp (lambdaMaxOrdered A hA)) support)
  have hEq :
      SMul.smul (Real.exp (lambdaMaxOrdered A hA)) support - support =
        SMul.smul (Real.exp (lambdaMaxOrdered A hA) - 1) support := by
    ext i j
    change
      Real.exp (lambdaMaxOrdered A hA) * support i j - support i j =
        (Real.exp (lambdaMaxOrdered A hA) - 1) * support i j
    ring
  have hCompress :
      SMul.smul (Real.exp (lambdaMaxOrdered A hA)) support -
          (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) <=
        SMul.smul (Real.exp (lambdaMaxOrdered A hA) - 1) support := by
    calc
      SMul.smul (Real.exp (lambdaMaxOrdered A hA)) support -
          (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
          <= SMul.smul (Real.exp (lambdaMaxOrdered A hA)) support - support :=
        hSubSupport
      _ = SMul.smul (Real.exp (lambdaMaxOrdered A hA) - 1) support := hEq
  exact matrixLE_of_mathlib_le (hSub.trans hCompress)

end

end HighDimProb

