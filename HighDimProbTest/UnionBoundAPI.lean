import HighDimProb.ProbabilitySpace

open MeasureTheory
open scoped BigOperators

namespace HighDimProbTest

section UnionBoundAPI

variable {Ω ι : Type*} [MeasurableSpace Ω]

#check HighDimProb.measure_biUnion_le

example (P : Measure Ω) (s : Finset ι) (A : ι → HighDimProb.Event Ω) :
    P (⋃ i ∈ s, A i) ≤ ∑ i ∈ s, P (A i) :=
  HighDimProb.measure_biUnion_le P s A

example (P : Measure Ω) (n : ℕ) (A : Fin n → HighDimProb.Event Ω) :
    P (⋃ i ∈ (Finset.univ : Finset (Fin n)), A i) ≤
      ∑ i ∈ (Finset.univ : Finset (Fin n)), P (A i) :=
  HighDimProb.measure_biUnion_le P (Finset.univ : Finset (Fin n)) A

end UnionBoundAPI

end HighDimProbTest

