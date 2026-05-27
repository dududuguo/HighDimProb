import HighDimProb.Distribution
import HighDimProb.Expectation

namespace HighDimProb

open MeasureTheory

example {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]
    (X : RealRandomVariable Ω) (hX : IsRealRandomVariable P X) :
    Measurable X :=
  hX

example {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]
    (X : RealRandomVariable Ω) :
    realLaw P X = Measure.map X P :=
  rfl

example {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]
    (X : RealRandomVariable Ω) :
    expect P X = ∫ ω, X ω ∂P :=
  rfl

end HighDimProb
