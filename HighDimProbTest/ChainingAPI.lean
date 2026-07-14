import HighDimProb.Chaining

namespace HighDimProbTest

open MeasureTheory
open HighDimProb

noncomputable section

variable {Ω : Type*} [MeasurableSpace Ω]
variable {P : Measure Ω}
variable {T : Type*}
variable {s : Finset T} (hs : s.Nonempty)
variable (X : RandomProcess Ω T ℝ)

#check processSup
#check isRandomVariable_processSup
#check integrable_processSup

example (hX : IsRandomProcess P X) :
    IsRandomVariable P (processSup X s hs) := by
  exact isRandomVariable_processSup hs hX

example (hX : ∀ t ∈ s, IntegrableRealRandomVariable P (X t)) :
    IntegrableRealRandomVariable P (processSup X s hs) := by
  exact integrable_processSup hs hX

example (X : Fin 3 → RandomVariable Ω ℝ) (hX : IsRandomProcess P X) :
    IsRandomVariable P
      (processSup X (Finset.univ : Finset (Fin 3)) Finset.univ_nonempty) := by
  exact isRandomVariable_processSup Finset.univ_nonempty hX

example (X : Fin 3 → RandomVariable Ω ℝ)
    (hX : ∀ i : Fin 3, IntegrableRealRandomVariable P (X i)) :
    IntegrableRealRandomVariable P
      (processSup X (Finset.univ : Finset (Fin 3)) Finset.univ_nonempty) := by
  exact integrable_processSup Finset.univ_nonempty (fun i _hi => hX i)

end

end HighDimProbTest
