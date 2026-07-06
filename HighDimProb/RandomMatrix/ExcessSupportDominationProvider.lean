import HighDimProb.RandomMatrix.ExcessSupportCompressionProvider

/-!
# Excess-support domination provider bridges

This module proves the smallest honest excess-support certificate currently
available: ambient identity support also controls `matrixExp A - 1` after
subtracting the identity from the already-proved matrix-exp domination bound.

It does not construct smaller support projections, prove low-rank excess
certificates, or prove any effective-rank, Lieb, or Matrix Bernstein fact.
-/

namespace HighDimProb

noncomputable section

open scoped MatrixOrder Matrix.Norms.Operator

/-- Ambient identity excess-support domination for the matrix exponential.

This is a thin but exact bridge from the existing identity-support domination
certificate for `matrixExp A` to the corrected excess certificate for
`matrixExp A - 1`. It keeps the ambient support `1`; it does not construct a
smaller support matrix. -/
theorem matrixExpExcessSupportDomination_identity {n : Nat}
    {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) :
    MatrixExpExcessSupportDomination A 1 hA := by
  exact
    matrixExpExcessSupportDomination_of_supportDomination_of_support_le_one
      hA (matrixExpSupportDomination_identity A hA) le_rfl

end

end HighDimProb
