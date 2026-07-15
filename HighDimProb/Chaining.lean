import HighDimProb.RandomProcess
import HighDimProb.Lp
import HighDimProb.Expectation

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

/-- A chain endpoint difference is bounded by the sum of its step bounds. -/
theorem norm_sub_chain_le_sum_of_step_bound
    {α E : Type*} [SeminormedAddCommGroup E]
    (gamma : ℕ → α) (f : α → E) (L : ℕ) (b : ℕ → ℝ)
    (hstep : ∀ k ∈ Finset.range L,
      ‖f (gamma (k + 1)) - f (gamma k)‖ ≤ b k) :
    ‖f (gamma L) - f (gamma 0)‖ ≤
      Finset.sum (Finset.range L) b := by
  rw [chain_sub_eq_sum_range]
  exact (norm_sum_le (Finset.range L)
    (fun k => f (gamma (k + 1)) - f (gamma k))).trans
      (Finset.sum_le_sum hstep)

/-- A finite chain is bounded by the sum of the worst parent increment at each level. -/
theorem norm_sub_chain_le_sum_of_level_sup
    {α E : Type*} [SeminormedAddCommGroup E]
    (gamma : ℕ → α) (f : α → E) (L : ℕ)
    (nextLevel : Fin L → Finset α)
    (parent : Fin L → α → α)
    (hmem : ∀ k : Fin L,
      gamma ((k : ℕ) + 1) ∈ nextLevel k)
    (hparent : ∀ k : Fin L,
      gamma (k : ℕ) =
        parent k (gamma ((k : ℕ) + 1))) :
    ‖f (gamma L) - f (gamma 0)‖ ≤
      Finset.univ.sum (fun k : Fin L =>
        Finset.sup' (nextLevel k)
          ⟨gamma ((k : ℕ) + 1), hmem k⟩
          (fun x => ‖f x - f (parent k x)‖)) := by
  let stepSup : Fin L → ℝ := fun k =>
    Finset.sup' (nextLevel k)
      ⟨gamma ((k : ℕ) + 1), hmem k⟩
      (fun x => ‖f x - f (parent k x)‖)
  let b : ℕ → ℝ := fun k =>
    if hk : k < L then stepSup ⟨k, hk⟩ else 0
  calc
    ‖f (gamma L) - f (gamma 0)‖ ≤
        Finset.sum (Finset.range L) b := by
      apply norm_sub_chain_le_sum_of_step_bound gamma f L b
      intro k hk
      have hkL : k < L := Finset.mem_range.mp hk
      let kFin : Fin L := ⟨k, hkL⟩
      simp only [b, dif_pos hkL]
      rw [hparent kFin]
      simpa [stepSup, kFin] using
        (Finset.le_sup'
          (fun x => ‖f x - f (parent kFin x)‖)
          (hmem kFin))
    _ = Finset.univ.sum stepSup := by
      rw [Finset.sum_fin_eq_sum_range]
    _ = Finset.univ.sum (fun k : Fin L =>
        Finset.sup' (nextLevel k)
          ⟨gamma ((k : ℕ) + 1), hmem k⟩
          (fun x => ‖f x - f (parent k x)‖)) := by
      rfl

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

/-- The expected endpoint difference is bounded by the expected sum of level suprema. -/
theorem expect_abs_sub_chain_le_sum_of_level_sup
    {Ω α : Type*} [MeasurableSpace Ω]
    {P : Measure Ω}
    {X : RandomProcess Ω α ℝ}
    (gamma : ℕ → α) (L : ℕ)
    (nextLevel : Fin L → Finset α)
    (parent : Fin L → α → α)
    (hmem : ∀ k : Fin L,
      gamma ((k : ℕ) + 1) ∈ nextLevel k)
    (hparent : ∀ k : Fin L,
      gamma (k : ℕ) =
        parent k (gamma ((k : ℕ) + 1)))
    (hLevelIntegrable :
      ∀ k : Fin L,
        IntegrableRealRandomVariable P
          (fun ω =>
            Finset.sup' (nextLevel k)
              ⟨gamma ((k : ℕ) + 1), hmem k⟩
              (fun x => |X x ω - X (parent k x) ω|))) :
    expect P (fun ω => |X (gamma L) ω - X (gamma 0) ω|) ≤
      Finset.univ.sum (fun k : Fin L =>
        expect P
          (fun ω =>
            Finset.sup' (nextLevel k)
              ⟨gamma ((k : ℕ) + 1), hmem k⟩
              (fun x => |X x ω - X (parent k x) ω|))) := by
  let upper : Fin L → Ω → ℝ := fun k ω =>
    Finset.sup' (nextLevel k)
      ⟨gamma ((k : ℕ) + 1), hmem k⟩
      (fun x => |X x ω - X (parent k x) ω|)
  have hUpper : IntegrableRealRandomVariable P (fun ω => ∑ k : Fin L, upper k ω) := by
    unfold IntegrableRealRandomVariable IntegrableRandomVariable
    exact MeasureTheory.integrable_finset_sum Finset.univ
      (fun k _hk => hLevelIntegrable k)
  have hPointwise : ∀ ω, |X (gamma L) ω - X (gamma 0) ω| ≤ ∑ k : Fin L, upper k ω := by
    intro ω
    simpa only [upper, Real.norm_eq_abs] using
      (norm_sub_chain_le_sum_of_level_sup gamma (fun t => X t ω) L
        nextLevel parent hmem hparent)
  have hIntegral :
      expect P (fun ω => |X (gamma L) ω - X (gamma 0) ω|) ≤
        expect P (fun ω => ∑ k : Fin L, upper k ω) := by
    rw [expect_def]
    exact MeasureTheory.integral_mono_of_nonneg
      (Filter.Eventually.of_forall (fun ω => abs_nonneg _))
      hUpper
      (Filter.Eventually.of_forall hPointwise)
  calc
    expect P (fun ω => |X (gamma L) ω - X (gamma 0) ω|)
        ≤ expect P (fun ω => ∑ k : Fin L, upper k ω) := hIntegral
    _ = ∑ k : Fin L, expect P (upper k) := by
      exact expect_finset_sum (fun k _hk => hLevelIntegrable k)
    _ = Finset.univ.sum (fun k : Fin L =>
        expect P
          (fun ω =>
            Finset.sup' (nextLevel k)
              ⟨gamma ((k : ℕ) + 1), hmem k⟩
              (fun x => |X x ω - X (parent k x) ω|))) := by
      rfl

end

end HighDimProb
