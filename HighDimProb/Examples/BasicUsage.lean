import HighDimProb.ProbabilitySpace

namespace HighDimProb

open MeasureTheory

example {Ω : Type*} [MeasurableSpace Ω] (s : Event Ω) :
    IsMeasurableEvent s ↔ MeasurableSet s :=
  Iff.rfl

example {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P] :
    IsProbability P :=
  inferInstance

end HighDimProb
