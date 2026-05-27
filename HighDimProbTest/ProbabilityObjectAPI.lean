import HighDimProb.ProbabilitySpace
import HighDimProb.RandomVariable
import HighDimProb.Distribution
import HighDimProb.Expectation

namespace HighDimProbTest

open MeasureTheory

section ProbabilityObjectAPI

variable {Ω : Type*} [MeasurableSpace Ω]
variable {P : Measure Ω} [IsProbabilityMeasure P]
variable (X : Ω → ℝ)
variable (hX : HighDimProb.IsRealRandomVariable P X)

#check HighDimProb.realLaw P X
#check HighDimProb.expect P X

example : HighDimProb.IsRealRandomVariable P X :=
  hX

example : HighDimProb.realLaw P X = Measure.map X P :=
  rfl

example : HighDimProb.expect P X = ∫ ω, X ω ∂P :=
  rfl

end ProbabilityObjectAPI

end HighDimProbTest
