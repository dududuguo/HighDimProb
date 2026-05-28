import HighDimProb.Init

/-!
# HighDimProb basic vocabulary

This package is a thin ergonomic layer over Mathlib probability.
-/

namespace HighDimProb

open MeasureTheory

/-- An event on a measurable space, represented by a set. -/
abbrev Event (Ω : Type*) [MeasurableSpace Ω] := Set Ω

/-- A measurable event on a measurable space. -/
abbrev IsMeasurableEvent {Ω : Type*} [MeasurableSpace Ω] (s : Event Ω) : Prop :=
  MeasurableSet s

@[simp]
theorem measurableEvent_iff {Ω : Type*} [MeasurableSpace Ω] (s : Event Ω) :
    IsMeasurableEvent s ↔ MeasurableSet s :=
  Iff.rfl

end HighDimProb
