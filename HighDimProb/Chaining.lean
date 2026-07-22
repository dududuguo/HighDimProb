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

/-- A finite family of paths is bounded from a common anchor by a terminal
residual and supplied per-level step bounds. -/
theorem finset_sup'_norm_sub_anchor_le_residual_add_sum_of_step_bound
    {α E : Type*} [SeminormedAddCommGroup E]
    {L : ℕ}
    (s : Finset α)
    (hs : s.Nonempty)
    (path : α → Fin (L + 1) → α)
    (anchor : α)
    (f : α → E)
    (residual : ℝ)
    (stepBound : Fin L → ℝ)
    (hresidual : ∀ x ∈ s,
      ‖f x - f (path x (Fin.last L))‖ ≤ residual)
    (hanchor : ∀ x ∈ s, path x 0 = anchor)
    (hstep : ∀ x ∈ s, ∀ k : Fin L,
      ‖f (path x (Fin.succ k)) - f (path x (Fin.castSucc k))‖ ≤ stepBound k) :
    s.sup' hs (fun x => ‖f x - f anchor‖) ≤
      residual + ∑ k : Fin L, stepBound k := by
  have hchain : ∀ x ∈ s,
      ‖f (path x (Fin.last L)) - f anchor‖ ≤
        ∑ k : Fin L, stepBound k := by
    intro x hx
    let gamma : ℕ → α := fun n =>
      if hn : n ≤ L then path x ⟨n, Nat.lt_succ_of_le hn⟩
      else path x (Fin.last L)
    have hgamma (n : ℕ) (hn : n ≤ L) :
        gamma n = path x ⟨n, Nat.lt_succ_of_le hn⟩ := by
      simp [gamma, hn]
    have hgamma_last : gamma L = path x (Fin.last L) := by
      rw [hgamma L le_rfl]
      apply congrArg (path x)
      apply Fin.ext
      rfl
    have hgamma_zero : gamma 0 = path x 0 := by
      rw [hgamma 0 (Nat.zero_le L)]
      apply congrArg (path x)
      apply Fin.ext
      rfl
    let b : ℕ → ℝ := fun k =>
      if hk : k < L then stepBound ⟨k, hk⟩ else 0
    have hstep' : ∀ k ∈ Finset.range L,
        ‖f (gamma (k + 1)) - f (gamma k)‖ ≤ b k := by
      intro k hk
      have hkL : k < L := Finset.mem_range.mp hk
      let kFin : Fin L := ⟨k, hkL⟩
      calc
        ‖f (gamma (k + 1)) - f (gamma k)‖ =
            ‖f (path x (Fin.succ kFin)) -
              f (path x (Fin.castSucc kFin))‖ := by
          rw [show gamma (k + 1) = path x (Fin.succ kFin) by
            simpa using hgamma (k + 1) (Nat.succ_le_of_lt hkL)]
          rw [show gamma k = path x (Fin.castSucc kFin) by
            simpa using hgamma k (Nat.le_of_lt hkL)]
        _ ≤ stepBound kFin := hstep x hx kFin
        _ = b k := by
          simp only [b, dif_pos hkL]
          apply congrArg stepBound
          apply Fin.ext
          rfl
    have h := norm_sub_chain_le_sum_of_step_bound gamma f L b hstep'
    calc
      ‖f (path x (Fin.last L)) - f anchor‖ =
          ‖f (gamma L) - f (gamma 0)‖ := by
            rw [hgamma_last, hgamma_zero, hanchor x hx]
      _ ≤ Finset.sum (Finset.range L) b := h
      _ = ∑ k : Fin L, stepBound k := by
        rw [Finset.sum_fin_eq_sum_range]
  apply Finset.sup'_le hs
  intro x hx
  calc
    ‖f x - f anchor‖ =
        ‖(f x - f (path x (Fin.last L))) +
          (f (path x (Fin.last L)) - f anchor)‖ := by
      rw [sub_add_sub_cancel]
    _ ≤ ‖f x - f (path x (Fin.last L))‖ +
          ‖f (path x (Fin.last L)) - f anchor‖ := norm_add_le _ _
    _ ≤ residual + ∑ k : Fin L, stepBound k :=
      add_le_add (hresidual x hx) (hchain x hx)

/-- The expected finite anchored supremum is bounded by an expected terminal
residual and the expected sum of supplied per-level step bounds. -/
theorem expect_finset_sup'_abs_sub_anchor_le_residual_add_sum_of_step_bound
    {Ω α : Type*} [MeasurableSpace Ω]
    {P : Measure Ω}
    {L : ℕ}
    {X : RandomProcess Ω α ℝ}
    (s : Finset α)
    (hs : s.Nonempty)
    (path : α → Fin (L + 1) → α)
    (anchor : α)
    (residual : RealRandomVariable Ω)
    (stepBound : Fin L → RealRandomVariable Ω)
    (hresidual : ∀ x ∈ s, ∀ ω : Ω,
      |X x ω - X (path x (Fin.last L)) ω| ≤ residual ω)
    (hanchor : ∀ x ∈ s, path x 0 = anchor)
    (hstep : ∀ x ∈ s, ∀ k : Fin L, ∀ ω : Ω,
      |X (path x (Fin.succ k)) ω - X (path x (Fin.castSucc k)) ω| ≤
        stepBound k ω)
    (hresidualIntegrable : IntegrableRealRandomVariable P residual)
    (hstepIntegrable : ∀ k : Fin L,
      IntegrableRealRandomVariable P (stepBound k)) :
    expect P (fun ω => s.sup' hs (fun x => |X x ω - X anchor ω|)) ≤
      expect P residual + ∑ k : Fin L, expect P (stepBound k) := by
  have hsum : IntegrableRealRandomVariable P
      (fun ω => ∑ k : Fin L, stepBound k ω) := by
    unfold IntegrableRealRandomVariable IntegrableRandomVariable
    exact MeasureTheory.integrable_finset_sum Finset.univ
      (fun k _hk => hstepIntegrable k)
  have hupper : IntegrableRealRandomVariable P
      (fun ω => residual ω + ∑ k : Fin L, stepBound k ω) :=
    hresidualIntegrable.add hsum
  have hpointwise : ∀ ω : Ω,
      s.sup' hs (fun x => |X x ω - X anchor ω|) ≤
        residual ω + ∑ k : Fin L, stepBound k ω := by
    intro ω
    simpa only [Real.norm_eq_abs] using
      (finset_sup'_norm_sub_anchor_le_residual_add_sum_of_step_bound
        s hs path anchor (fun t => X t ω) (residual ω)
        (fun k => stepBound k ω)
        (fun x hx => hresidual x hx ω)
        hanchor
        (fun x hx k => hstep x hx k ω))
  have hnonneg : ∀ ω : Ω,
      0 ≤ s.sup' hs (fun x => |X x ω - X anchor ω|) := by
    intro ω
    obtain ⟨x, hx⟩ := hs
    exact (abs_nonneg _).trans
      (Finset.le_sup' (fun x => |X x ω - X anchor ω|) hx)
  have hIntegral :
      expect P (fun ω =>
        s.sup' hs (fun x => |X x ω - X anchor ω|)) ≤
        expect P (fun ω => residual ω + ∑ k : Fin L, stepBound k ω) := by
    rw [expect_def, expect_def]
    exact MeasureTheory.integral_mono_of_nonneg
      (Filter.Eventually.of_forall hnonneg)
      hupper
      (Filter.Eventually.of_forall hpointwise)
  calc
    expect P (fun ω =>
        s.sup' hs (fun x => |X x ω - X anchor ω|)) ≤
        expect P (fun ω => residual ω + ∑ k : Fin L, stepBound k ω) := hIntegral
    _ = expect P residual +
        expect P (fun ω => ∑ k : Fin L, stepBound k ω) := by
      rw [expect_def, expect_def, expect_def]
      exact MeasureTheory.integral_add hresidualIntegrable hsum
    _ = expect P residual + ∑ k : Fin L, expect P (stepBound k) := by
      rw [expect_finset_sum (fun k _hk => hstepIntegrable k)]

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

/-- For a terminal point of a finite level family whose base level is rooted at
`t0`, the endpoint difference is bounded pointwise by the sum of the per-level
parent-increment suprema. The bound is uniform in the terminal point, which is
what allows taking the terminal-net supremum afterwards. -/
theorem abs_sub_root_le_sum_level_sup_of_mem_terminal
    {α : Type*} {L : ℕ}
    (levels : Fin (L + 1) → Finset α) (parent : Fin L → α → α)
    (f : α → ℝ) (t₀ : α)
    (hroot : ∀ y ∈ levels 0, y = t₀)
    (hparent_mem : ∀ k x, x ∈ levels (Fin.succ k) →
      parent k x ∈ levels (Fin.castSucc k))
    (hne : ∀ k : Fin L, (levels (Fin.succ k)).Nonempty)
    {x : α} (hx : x ∈ levels (Fin.last L)) :
    |f x - f t₀| ≤
      Finset.univ.sum (fun k : Fin L =>
        (levels (Fin.succ k)).sup' (hne k)
          (fun y => |f y - f (parent k y)|)) := by
  let path : Fin (L + 1) → α :=
    Fin.reverseInduction x (fun i yi => parent i yi)
  have hpath_mem : ∀ i : Fin (L + 1), path i ∈ levels i := by
    intro i
    induction i using Fin.reverseInduction with
    | last => simpa [path] using hx
    | cast i ih =>
        simpa [path] using hparent_mem i (path i.succ) ih
  have hpath_parent : ∀ k : Fin L,
      path (Fin.castSucc k) = parent k (path (Fin.succ k)) := by
    intro k
    simp [path]
  have hpath_last : path (Fin.last L) = x := by simp [path]
  have hpath_zero : path 0 = t₀ := hroot (path 0) (hpath_mem 0)
  let gamma : ℕ → α := fun n =>
    if h : n ≤ L then path ⟨n, Nat.lt_succ_of_le h⟩ else path (Fin.last L)
  have hgamma (n : ℕ) (hn : n ≤ L) :
      gamma n = path ⟨n, Nat.lt_succ_of_le hn⟩ := by
    simp [gamma, hn]
  have hgamma_zero : gamma 0 = path 0 := by
    simpa using hgamma 0 (by omega)
  have hgamma_last : gamma L = path (Fin.last L) := by
    simpa using hgamma L (by omega)
  have hgamma_mem : ∀ k : Fin L,
      gamma ((k : ℕ) + 1) ∈ levels (Fin.succ k) := by
    intro k
    rw [show gamma ((k : ℕ) + 1) = path (Fin.succ k) by
      simpa using hgamma ((k : ℕ) + 1) (by omega)]
    exact hpath_mem _
  have hgamma_parent : ∀ k : Fin L,
      gamma (k : ℕ) = parent k (gamma ((k : ℕ) + 1)) := by
    intro k
    rw [show gamma (k : ℕ) = path (Fin.castSucc k) by
        simpa using hgamma (k : ℕ) (Nat.le_of_lt k.isLt),
      show gamma ((k : ℕ) + 1) = path (Fin.succ k) by
        simpa using hgamma ((k : ℕ) + 1) (by omega)]
    exact hpath_parent k
  have hchain := norm_sub_chain_le_sum_of_level_sup gamma f L
    (fun k => levels (Fin.succ k)) parent hgamma_mem hgamma_parent
  rw [hgamma_last, hpath_last, hgamma_zero, hpath_zero] at hchain
  simpa only [Real.norm_eq_abs] using hchain

/-- Pointwise terminal-net supremum chaining with a fixed root: the supremum of
the endpoint differences over the terminal net is bounded by the sum of the
per-level parent-increment suprema, uniformly over the terminal points. -/
theorem sup'_abs_sub_root_le_sum_level_sup
    {α : Type*} {L : ℕ}
    (levels : Fin (L + 1) → Finset α) (parent : Fin L → α → α)
    (f : α → ℝ) (t₀ : α)
    (hroot : ∀ y ∈ levels 0, y = t₀)
    (hparent_mem : ∀ k x, x ∈ levels (Fin.succ k) →
      parent k x ∈ levels (Fin.castSucc k))
    (hne : ∀ k : Fin L, (levels (Fin.succ k)).Nonempty)
    (hT : (levels (Fin.last L)).Nonempty) :
    (levels (Fin.last L)).sup' hT (fun x => |f x - f t₀|) ≤
      Finset.univ.sum (fun k : Fin L =>
        (levels (Fin.succ k)).sup' (hne k)
          (fun y => |f y - f (parent k y)|)) := by
  apply Finset.sup'_le
  intro x hx
  exact abs_sub_root_le_sum_level_sup_of_mem_terminal levels parent f t₀
    hroot hparent_mem hne hx

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
