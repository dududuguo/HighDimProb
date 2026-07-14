import HighDimProb.RandomProcess
import HighDimProb.Lp

/-!
# Finite process suprema

This module provides the finite real-valued supremum of a random process.
-/

namespace HighDimProb

open MeasureTheory

noncomputable section

/-- The endpoint difference of a chain telescopes into its consecutive increments. -/
theorem chain_sub_eq_sum_range
    {α E : Type*} [AddCommGroup E]
    (gamma : ℕ → α) (f : α → E) (L : ℕ) :
    f (gamma L) - f (gamma 0) =
      Finset.sum (Finset.range L) (fun k => f (gamma (k + 1)) - f (gamma k)) := by
  induction L with
  | zero => simp
  | succ L ih =>
      rw [Finset.sum_range_succ, ← ih]
      abel

/-- Pointwise supremum of a real-valued random process over a nonempty finite set. -/
def processSup {Ω T : Type*} [MeasurableSpace Ω]
    (X : RandomProcess Ω T ℝ) (s : Finset T) (hs : s.Nonempty) :
    RealRandomVariable Ω :=
  Finset.sup' s hs X

/-- A finite supremum of a measurable random process is measurable. -/
theorem isRandomVariable_processSup {Ω T : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {X : RandomProcess Ω T ℝ} {s : Finset T}
    (hs : s.Nonempty) (hX : IsRandomProcess P X) :
    IsRandomVariable P (processSup X s hs) := by
  unfold processSup
  exact Finset.measurable_sup' hs (fun t _ht => hX t)

/-- A finite supremum is integrable when each indexed process is integrable. -/
theorem integrable_processSup {Ω T : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {X : RandomProcess Ω T ℝ} {s : Finset T}
    (hs : s.Nonempty)
    (hX : ∀ t ∈ s, IntegrableRealRandomVariable P (X t)) :
    IntegrableRealRandomVariable P (processSup X s hs) := by
  unfold processSup IntegrableRealRandomVariable IntegrableRandomVariable
  refine Finset.sup'_induction hs X (p := fun f => Integrable f P) ?_ ?_
  · intro f hf g hg
    exact hf.sup hg
  · intro t ht
    exact hX t ht

end

end HighDimProb
