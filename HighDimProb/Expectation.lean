import HighDimProb.RandomVariable

/-!
# Expectation

HighDimProb uses Mathlib integral notation for expectations. The alias in this file is only a
lightweight ergonomic wrapper for real-valued random variables.
-/

namespace HighDimProb

open MeasureTheory

noncomputable section

/-- Expectation of a real-valued random variable, as a Mathlib integral. -/
abbrev expect {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) : ℝ :=
  ∫ ω, X ω ∂P

@[simp]
theorem expect_def {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) :
    expect P X = ∫ ω, X ω ∂P :=
  rfl

end

end HighDimProb
