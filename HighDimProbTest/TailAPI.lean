import HighDimProb.Tail

namespace HighDimProbTest

open MeasureTheory

section TailAPI

variable {Ω : Type*} [MeasurableSpace Ω]
variable {P : Measure Ω} [IsProbabilityMeasure P]
variable (X : Ω → ℝ)
variable (t : ℝ)
variable (hX : HighDimProb.IsRealRandomVariable P X)

#check HighDimProb.upperTailEvent X t
#check HighDimProb.lowerTailEvent X t
#check HighDimProb.absTailEvent X t
#check HighDimProb.upperTailProb P X t
#check HighDimProb.lowerTailProb P X t
#check HighDimProb.absTailProb P X t
#check HighDimProb.measurableSet_upperTailEvent hX t
#check HighDimProb.measurableSet_lowerTailEvent hX t
#check HighDimProb.measurableSet_absTailEvent hX t

example : HighDimProb.upperTailProb P X t = P (HighDimProb.upperTailEvent X t) :=
  rfl

example : HighDimProb.lowerTailProb P X t = P (HighDimProb.lowerTailEvent X t) :=
  rfl

example : HighDimProb.absTailProb P X t = P (HighDimProb.absTailEvent X t) :=
  rfl

example : MeasurableSet (HighDimProb.upperTailEvent X t) :=
  HighDimProb.measurableSet_upperTailEvent hX t

example : MeasurableSet (HighDimProb.lowerTailEvent X t) :=
  HighDimProb.measurableSet_lowerTailEvent hX t

example : MeasurableSet (HighDimProb.absTailEvent X t) :=
  HighDimProb.measurableSet_absTailEvent hX t

end TailAPI

end HighDimProbTest
