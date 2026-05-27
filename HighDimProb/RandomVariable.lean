import HighDimProb.ProbabilitySpace

/-!
# Random variables

Random variables are functions plus Mathlib measurability assumptions.
-/

namespace HighDimProb

open MeasureTheory

/-- A random variable as a bare function. Measurability is tracked separately. -/
abbrev RandomVariable (Ω E : Type*) [MeasurableSpace Ω] := Ω → E

/-- A real-valued random variable. -/
abbrev RealRandomVariable (Ω : Type*) [MeasurableSpace Ω] := RandomVariable Ω ℝ

/--
Measurability predicate for a random variable under a measure.

The measure argument is intentionally present for probability-facing APIs, even though this
measurable version does not depend on null sets.
-/
abbrev IsRandomVariable {Ω E : Type*} [MeasurableSpace Ω] [MeasurableSpace E]
    (_P : Measure Ω) (X : RandomVariable Ω E) : Prop :=
  Measurable X

/-- User-facing predicate for real-valued measurable random variables. -/
abbrev IsRealRandomVariable {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) : Prop :=
  IsRandomVariable P X

@[simp]
theorem isRandomVariable_iff {Ω E : Type*} [MeasurableSpace Ω] [MeasurableSpace E]
    (P : Measure Ω) (X : RandomVariable Ω E) : IsRandomVariable P X ↔ Measurable X :=
  Iff.rfl

@[simp]
theorem isRealRandomVariable_iff {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) : IsRealRandomVariable P X ↔ Measurable X :=
  Iff.rfl

end HighDimProb
