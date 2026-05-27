import HighDimProb.RandomVector

/-!
# Random matrices
-/

namespace HighDimProb

open MeasureTheory

/-- An `m × n` real random matrix. -/
abbrev RandomMatrix (Ω : Type*) [MeasurableSpace Ω] (m n : ℕ) :=
  RandomVariable Ω (Matrix (Fin m) (Fin n) ℝ)

/-- Entry random variable of a random matrix. -/
def matrixEntry {Ω : Type*} [MeasurableSpace Ω] {m n : ℕ}
    (A : RandomMatrix Ω m n) (i : Fin m) (j : Fin n) : RealRandomVariable Ω :=
  fun ω => A ω i j

@[simp]
theorem matrixEntry_apply {Ω : Type*} [MeasurableSpace Ω] {m n : ℕ}
    (A : RandomMatrix Ω m n) (i : Fin m) (j : Fin n) (ω : Ω) :
    matrixEntry A i j ω = A ω i j :=
  rfl

end HighDimProb
