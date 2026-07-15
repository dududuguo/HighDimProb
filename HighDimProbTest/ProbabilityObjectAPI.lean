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
#check HighDimProb.expect_finset_sum
#check HighDimProb.measure_biUnion_le

example : HighDimProb.IsRealRandomVariable P X :=
  hX

example : HighDimProb.realLaw P X = Measure.map X P :=
  rfl

example : HighDimProb.expect P X = ∫ ω, X ω ∂P :=
  rfl

example {ι : Type*} (s : Finset ι)
    (Y : ι → HighDimProb.RealRandomVariable Ω)
    (hY : ∀ i, i ∈ s →
      HighDimProb.IntegrableRealRandomVariable P (Y i)) :
    HighDimProb.expect P (fun ω => ∑ i ∈ s, Y i ω) =
      ∑ i ∈ s, HighDimProb.expect P (Y i) :=
  HighDimProb.expect_finset_sum (P := P) (s := s) (X := Y) hY

example {ι : Type*} (s : Finset ι) (A : ι → HighDimProb.Event Ω) :
    P (⋃ i ∈ s, A i) ≤ ∑ i ∈ s, P (A i) :=
  HighDimProb.measure_biUnion_le P s A

end ProbabilityObjectAPI

end HighDimProbTest
