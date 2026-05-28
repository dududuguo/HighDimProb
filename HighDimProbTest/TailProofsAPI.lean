import HighDimProb.Tail

open MeasureTheory
open HighDimProb

variable {Ω : Type*} [MeasurableSpace Ω]
variable (P : Measure Ω)
variable (X : RealRandomVariable Ω)

#check upperTailProb_antitone
#check lowerTailProb_monotone
#check absTailProb_antitone

#check (upperTailProb_antitone P X : ∀ {s t : ℝ}, s ≤ t → upperTailProb P X t ≤ upperTailProb P X s)
#check (lowerTailProb_monotone P X : ∀ {s t : ℝ}, s ≤ t → lowerTailProb P X s ≤ lowerTailProb P X t)
#check (absTailProb_antitone P X : ∀ {s t : ℝ}, s ≤ t → absTailProb P X t ≤ absTailProb P X s)
