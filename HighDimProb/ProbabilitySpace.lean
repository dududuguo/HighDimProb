import HighDimProb.Basic

/-!
# Probability spaces

HighDimProb uses Mathlib's probability model:
`{Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]`.
-/

namespace HighDimProb

open MeasureTheory

/-- Alias for a Mathlib measure intended to carry an `IsProbabilityMeasure` instance. -/
abbrev ProbabilityMeasure (Ω : Type*) [MeasurableSpace Ω] := Measure Ω

/-- Predicate alias for Mathlib's probability-measure typeclass. -/
abbrev IsProbability {Ω : Type*} [MeasurableSpace Ω] (P : ProbabilityMeasure Ω) : Prop :=
  IsProbabilityMeasure P

@[simp]
theorem isProbability_iff {Ω : Type*} [MeasurableSpace Ω] (P : ProbabilityMeasure Ω) :
    IsProbability P ↔ IsProbabilityMeasure P :=
  Iff.rfl

example {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P] :
    IsProbabilityMeasure P :=
  inferInstance

example {Ω : Type*} [MeasurableSpace Ω] {P : ProbabilityMeasure Ω} [IsProbabilityMeasure P] :
    IsProbability P :=
  inferInstance

end HighDimProb
