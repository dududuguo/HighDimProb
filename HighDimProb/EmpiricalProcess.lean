import HighDimProb.RandomProcess

/-!
# Empirical process vocabulary
-/

namespace HighDimProb

open MeasureTheory

/-- A finite sample of `E`-valued random variables. -/
abbrev RandomSample (Ω E : Type*) [MeasurableSpace Ω] (n : ℕ) :=
  Fin n → RandomVariable Ω E

/-- Evaluation of a test function over a finite random sample. -/
def sampleEvaluation {Ω E : Type*} [MeasurableSpace Ω] {n : ℕ}
    (X : RandomSample Ω E n) (f : E → ℝ) (ω : Ω) : Fin n → ℝ :=
  fun i => f (X i ω)

@[simp]
theorem sampleEvaluation_apply {Ω E : Type*} [MeasurableSpace Ω] {n : ℕ}
    (X : RandomSample Ω E n) (f : E → ℝ) (ω : Ω) (i : Fin n) :
    sampleEvaluation X f ω i = f (X i ω) :=
  rfl

end HighDimProb
