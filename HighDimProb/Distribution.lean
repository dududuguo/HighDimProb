import HighDimProb.RandomVariable

/-!
# Distributions and laws

The law of a random variable is `Measure.map X P`.
-/

namespace HighDimProb

open MeasureTheory

/-- Distribution/law of a random variable under a measure. -/
noncomputable abbrev law {Ω E : Type*} [MeasurableSpace Ω] [MeasurableSpace E]
    (P : Measure Ω) (X : RandomVariable Ω E) : Measure E :=
  Measure.map X P

@[simp]
theorem law_def {Ω E : Type*} [MeasurableSpace Ω] [MeasurableSpace E]
    (P : Measure Ω) (X : RandomVariable Ω E) :
    law P X = Measure.map X P :=
  rfl

/-- Distribution/law of a real-valued random variable. -/
noncomputable abbrev realLaw {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) : Measure ℝ :=
  law P X

@[simp]
theorem realLaw_def {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) :
    realLaw P X = Measure.map X P :=
  rfl

end HighDimProb
