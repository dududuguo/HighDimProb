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
#check chain_sub_eq_sum_range
#check norm_sub_chain_le_sum_of_step_bound

example {α E : Type*} [SeminormedAddCommGroup E]
    (gamma : ℕ → α) (f : α → E) (b : ℕ → ℝ) :
    ‖f (gamma 0) - f (gamma 0)‖ ≤
      Finset.sum (Finset.range 0) b := by
  apply norm_sub_chain_le_sum_of_step_bound gamma f 0 b
  simp

example {α : Type*} (gamma : ℕ → α) (c : ℝ) (L : ℕ) :
    ‖c - c‖ ≤ Finset.sum (Finset.range L) (fun _ => (1 : ℝ)) := by
  apply norm_sub_chain_le_sum_of_step_bound gamma (fun _ => c) L (fun _ => 1)
  intro k hk
  simp

example {α E : Type*} [AddCommGroup E]
    (gamma : ℕ → α) (f : α → E) :
    f (gamma 0) - f (gamma 0) =
      Finset.sum (Finset.range 0) (fun k => f (gamma (k + 1)) - f (gamma k)) := by
  exact chain_sub_eq_sum_range gamma f 0

example {α E : Type*} [AddCommGroup E]
    (gamma : ℕ → α) (f : α → E) :
    f (gamma 3) - f (gamma 0) =
      Finset.sum (Finset.range 3) (fun k => f (gamma (k + 1)) - f (gamma k)) := by
  simpa using chain_sub_eq_sum_range gamma f 3

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
