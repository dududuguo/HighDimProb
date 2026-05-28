import Mathlib.Analysis.CStarAlgebra.Matrix
import HighDimProb.RandomMatrix.Basic

/-!
# Operator norm vocabulary for random matrices

This module uses Mathlib's `Matrix.Norms.L2Operator` scoped norm, i.e. the norm transported from
continuous linear maps between finite-dimensional Euclidean spaces. It is kept in its own
experimental submodule so the rest of the random-matrix layer does not accidentally depend on a
matrix norm convention.
-/

namespace HighDimProb

open MeasureTheory
open scoped Matrix.Norms.L2Operator

noncomputable section

/-- Spectral/operator norm random variable for a real random matrix. -/
def operatorNorm {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) : RealRandomVariable Omega :=
  fun omega => ‖A omega‖

@[simp]
theorem operatorNorm_apply {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (omega : Omega) :
    operatorNorm A omega = ‖A omega‖ :=
  rfl

end

end HighDimProb
