import HighDimProb.Basic

/-!
# Probability spaces

HighDimProb uses Mathlib's probability model:
`{Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]`.

Verified Wikipedia reference:
https://en.wikipedia.org/wiki/Probability_space
-/

namespace HighDimProb

open MeasureTheory

/--
Alias for a Mathlib measure intended to carry an `IsProbabilityMeasure` instance.

Formula reference: this is the `P` component of the probability triple
`(Omega, F, P)`; see https://en.wikipedia.org/wiki/Probability_space
-/
abbrev ProbabilityMeasure (Ω : Type*) [MeasurableSpace Ω] := Measure Ω

/--
Predicate alias for Mathlib's probability-measure typeclass.

Formula reference: probability measures assign probabilities to events in the
event space of `(Omega, F, P)`; see
https://en.wikipedia.org/wiki/Probability_space
-/
abbrev IsProbability {Ω : Type*} [MeasurableSpace Ω] (P : ProbabilityMeasure Ω) : Prop :=
  IsProbabilityMeasure P

@[simp]
theorem isProbability_iff {Ω : Type*} [MeasurableSpace Ω] (P : ProbabilityMeasure Ω) :
    IsProbability P ↔ IsProbabilityMeasure P :=
  Iff.rfl

/--
Finite union bound / Boole inequality for a finite family of events.

This is a HighDimProb-facing wrapper around Mathlib's finite subadditivity
lemma for measures. It does not require the events to be measurable.
-/
theorem measure_biUnion_le {Ω ι : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (s : Finset ι) (A : ι → Event Ω) :
    P (⋃ i ∈ s, A i) ≤ ∑ i ∈ s, P (A i) :=
  MeasureTheory.measure_biUnion_finset_le s A

example {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P] :
    IsProbabilityMeasure P :=
  inferInstance

example {Ω : Type*} [MeasurableSpace Ω] {P : ProbabilityMeasure Ω} [IsProbabilityMeasure P] :
    IsProbability P :=
  inferInstance

end HighDimProb
