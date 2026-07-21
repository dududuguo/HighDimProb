import HighDimProb.Chaining
import HighDimProb.Concentration.SubGaussianMax
import HighDimProb.MetricEntropy

/-!
# Truncated Dudley inequality for a finite terminal net with a fixed root

This module closes the finite, fixed-root, terminal-net-supremum form of the
truncated Dudley chaining inequality. It does not attempt the full infinite
Dudley integral and proves no Gaussian functional inequality.

The chain of arguments is:

* pointwise terminal-net chaining with a common root
  (`HighDimProb.sup'_abs_sub_root_le_sum_level_sup`), so the supremum bound is
  proved pointwise before any integration;
* integration by monotonicity, giving the expectation of the terminal-net
  supremum by the sum of the expected per-level suprema;
* the finite-maximum subGaussian bound on each level;
* a rooted dyadic net chain constructed internally from total boundedness, with
  base level the singleton `{t₀}` (an internal `R`-net of `K` by the radius
  hypothesis), minimal internal nets at the finer dyadic scales, and parent maps
  into the previous level;
* the existing dyadic finite-entropy-sum to truncated covering-number integral
  comparison.

The high-level consumer
`exists_terminal_net_expect_sup'_abs_sub_le_truncatedEntropyIntegral` only asks
for the metric hypotheses on `K`, `t₀`, `R`, the subGaussian increment scale,
and measurability; the nets, parent maps, covering-number equalities, and
finiteness facts are constructed internally.
-/

namespace HighDimProb

open MeasureTheory

noncomputable section

/-- Expectation of the terminal-net supremum is bounded by the sum of the
expected per-level parent-increment suprema, with the fixed common root `t₀`.

The pointwise bound is established first
(`sup'_abs_sub_root_le_sum_level_sup`), then integrated by monotonicity. -/
theorem expect_sup'_abs_sub_root_le_sum_level_sup
    {Ω α : Type*} [MeasurableSpace Ω]
    {P : Measure Ω}
    {X : RandomProcess Ω α ℝ}
    {L : ℕ}
    {levels : Fin (L + 1) → Finset α} {parent : Fin L → α → α} {t₀ : α}
    (hroot : ∀ y ∈ levels 0, y = t₀)
    (hparent_mem : ∀ k x, x ∈ levels (Fin.succ k) →
      parent k x ∈ levels (Fin.castSucc k))
    (hne : ∀ k : Fin L, (levels (Fin.succ k)).Nonempty)
    (hT : (levels (Fin.last L)).Nonempty)
    (hLevelInt : ∀ k : Fin L,
      IntegrableRealRandomVariable P (fun ω =>
        (levels (Fin.succ k)).sup' (hne k)
          (fun y => |X y ω - X (parent k y) ω|))) :
    expect P
        (fun ω => (levels (Fin.last L)).sup' hT (fun x => |X x ω - X t₀ ω|)) ≤
      Finset.univ.sum (fun k : Fin L =>
        expect P (fun ω =>
          (levels (Fin.succ k)).sup' (hne k)
            (fun y => |X y ω - X (parent k y) ω|))) := by
  let upper : Fin L → Ω → ℝ := fun k ω =>
    (levels (Fin.succ k)).sup' (hne k)
      (fun y => |X y ω - X (parent k y) ω|)
  have hUpper : IntegrableRealRandomVariable P
      (fun ω => ∑ k : Fin L, upper k ω) := by
    unfold IntegrableRealRandomVariable IntegrableRandomVariable
    exact MeasureTheory.integrable_finset_sum Finset.univ
      (fun k _hk => hLevelInt k)
  have hPointwise : ∀ ω,
      (levels (Fin.last L)).sup' hT (fun x => |X x ω - X t₀ ω|) ≤
        ∑ k : Fin L, upper k ω := by
    intro ω
    exact sup'_abs_sub_root_le_sum_level_sup levels parent (fun t => X t ω) t₀
      hroot hparent_mem hne hT
  have hnonneg : ∀ ω,
      0 ≤ (levels (Fin.last L)).sup' hT (fun x => |X x ω - X t₀ ω|) := by
    intro ω
    obtain ⟨x, hx⟩ := hT
    exact (abs_nonneg _).trans
      (Finset.le_sup' (fun x => |X x ω - X t₀ ω|) hx)
  have hIntegral :
      expect P
          (fun ω => (levels (Fin.last L)).sup' hT
            (fun x => |X x ω - X t₀ ω|)) ≤
        expect P (fun ω => ∑ k : Fin L, upper k ω) := by
    rw [expect_def]
    exact MeasureTheory.integral_mono_of_nonneg
      (Filter.Eventually.of_forall hnonneg) hUpper
      (Filter.Eventually.of_forall hPointwise)
  calc
    expect P (fun ω => (levels (Fin.last L)).sup' hT
        (fun x => |X x ω - X t₀ ω|))
        ≤ expect P (fun ω => ∑ k : Fin L, upper k ω) := hIntegral
    _ = ∑ k : Fin L, expect P (upper k) := by
      exact expect_finset_sum (fun k _hk => hLevelInt k)
    _ = Finset.univ.sum (fun k : Fin L =>
        expect P (fun ω =>
          (levels (Fin.succ k)).sup' (hne k)
            (fun y => |X y ω - X (parent k y) ω|))) := by
      rfl

/-- Terminal-net supremum expectation bound for subGaussian-increment processes,
summed into the finite entropy sum of the level cardinalities. -/
theorem expect_sup'_abs_sub_root_le_finiteEntropySum
    {Ω α : Type*} [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ}
    {L : ℕ}
    {levels : Fin (L + 1) → Finset α} {parent : Fin L → α → α} {t₀ : α}
    {σ : ℝ} {rho : Fin (L + 1) → ℝ}
    (hroot : ∀ y ∈ levels 0, y = t₀)
    (hparent_mem : ∀ k x, x ∈ levels (Fin.succ k) →
      parent k x ∈ levels (Fin.castSucc k))
    (hparent_dist : ∀ k x, x ∈ levels (Fin.succ k) →
      dist x (parent k x) ≤ rho (Fin.castSucc k))
    (hne : ∀ k : Fin L, (levels (Fin.succ k)).Nonempty)
    (hT : (levels (Fin.last L)).Nonempty)
    (hXMeas : ∀ t, Measurable (X t))
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hσ : 0 < σ)
    (hρ : ∀ j : Fin (L + 1), 0 < rho j) :
    expect P
        (fun ω => (levels (Fin.last L)).sup' hT (fun x => |X x ω - X t₀ ω|)) ≤
      finiteEntropySum rho (fun k => (levels (Fin.succ k)).card) σ := by
  have hXSG : ∀ k : Fin L, ∀ x ∈ levels (Fin.succ k),
      CenteredSubGaussianMGF P (fun ω => X x ω - X (parent k x) ω)
        (σ * rho (Fin.castSucc k)) := by
    intro k x hx
    exact HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le
      hX hσ (hρ (Fin.castSucc k)) (hparent_dist k x hx)
  have hLevelInt : ∀ k : Fin L,
      IntegrableRealRandomVariable P (fun ω =>
        (levels (Fin.succ k)).sup' (hne k)
          (fun y => |X y ω - X (parent k y) ω|)) := by
    intro k
    let Y : RandomProcess Ω α ℝ :=
      fun x ω => |X x ω - X (parent k x) ω|
    have hYIntegrable : ∀ x ∈ levels (Fin.succ k),
        IntegrableRealRandomVariable P (Y x) := by
      intro x hx
      simpa only [Y] using (hXSG k x hx).2.integrable.abs
    have hSup := integrable_processSup
      (P := P) (X := Y) (s := levels (Fin.succ k)) (hne k) hYIntegrable
    convert hSup using 1
    funext ω
    simp only [processSup, Finset.sup'_apply, Y]
  have hLevelBound : ∀ k : Fin L,
      expect P (fun ω =>
          (levels (Fin.succ k)).sup' (hne k)
            (fun y => |X y ω - X (parent k y) ω|)) ≤
        (σ * rho (Fin.castSucc k)) *
          Real.sqrt (2 * Real.log
            (2 * ((levels (Fin.succ k)).card : ℝ))) := by
    intro k
    exact expect_finset_sup'_abs_le_of_centeredSubGaussianMGF
      (P := P) (X := fun x ω => X x ω - X (parent k x) ω)
      (s := levels (Fin.succ k)) (hne k)
      (fun x _hx => (hXMeas x).sub (hXMeas (parent k x)))
      (fun x hx => hXSG k x hx)
  have hChain := expect_sup'_abs_sub_root_le_sum_level_sup
    (P := P) (X := X) hroot hparent_mem hne hT hLevelInt
  calc
    expect P (fun ω => (levels (Fin.last L)).sup' hT
        (fun x => |X x ω - X t₀ ω|))
        ≤ Finset.univ.sum (fun k : Fin L =>
          expect P (fun ω =>
            (levels (Fin.succ k)).sup' (hne k)
              (fun y => |X y ω - X (parent k y) ω|))) := hChain
    _ ≤ Finset.univ.sum (fun k : Fin L =>
        (σ * rho (Fin.castSucc k)) *
          Real.sqrt (2 * Real.log
            (2 * ((levels (Fin.succ k)).card : ℝ)))) := by
      exact Finset.sum_le_sum (fun k _hk => hLevelBound k)
    _ = finiteEntropySum rho (fun k => (levels (Fin.succ k)).card) σ := by
      rfl

/-- Truncated Dudley inequality for a finite terminal net with a fixed root.

From totally bounded `K`, a root `t₀ ∈ K` within radius `R` of every point of
`K`, subGaussian increments of scale `σ > 0`, and measurability of the process,
there exists a finite internal terminal net `T` of `K` at scale
`dyadicRadius R L` such that the expected supremum of `|X t - X t₀|` over `T`
is bounded by the truncated covering-number entropy integral.

The chain is built internally: the base level is the singleton `{t₀}` (an
internal `R`-net of `K` by the radius hypothesis), the finer levels are minimal
internal dyadic nets (so their cardinalities equal the covering numbers), and
the parent maps point into the previous level. The caller supplies no paths,
parents, level cardinalities, or finiteness facts. -/
theorem exists_terminal_net_expect_sup'_abs_sub_le_truncatedEntropyIntegral
    {Ω α : Type*} [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ}
    {K : Set α} {t₀ : α} {R σ : ℝ} (L : ℕ)
    (hK : TotallyBounded K) (ht₀ : t₀ ∈ K) (hR : 0 < R)
    (hdist : ∀ t ∈ K, dist t t₀ ≤ R)
    (hXMeas : ∀ t, Measurable (X t))
    (hX : HasSubGaussianMGFIncrements P X σ) (hσ : 0 < σ) :
    ∃ T : Finset α, ∃ hT : T.Nonempty,
      (T : Set α) ⊆ K ∧
      IsInternalEpsilonNet K (T : Set α) (dyadicRadius R L) ∧
      expect P (fun ω => T.sup' hT (fun t => |X t ω - X t₀ ω|)) ≤
        4 * σ * (∫ t in dyadicRadius R (L + 1)..R,
          Real.sqrt (2 * Real.log
            (2 * ((coveringNumber K t).toNat : ℝ)))) := by
  obtain ⟨levels', hlevels', hcard', -⟩ :=
    exists_finset_internalNetFamily_of_totallyBounded
      (rho := fun i : Fin (L + 1) => dyadicRadius R (i : Nat))
      (fun i => dyadicRadius_pos hR i) hK
  let levels : Fin (L + 1) → Finset α :=
    fun i => if (i : Nat) = 0 then {t₀} else levels' i
  have hR0 : dyadicRadius R 0 = R := by simp [dyadicRadius]
  have hroot_net : IsInternalEpsilonNet K (({t₀} : Finset α) : Set α)
      (dyadicRadius R 0) := by
    rw [hR0]
    refine ⟨?_, ?_⟩
    · intro y hy
      simp only [Finset.coe_singleton, Set.mem_singleton_iff] at hy
      rw [hy]
      exact ht₀
    · intro x hx
      refine ⟨t₀, by simp, ?_⟩
      simp only [Set.mem_setOf_eq]
      rw [edist_le_coe]
      have hnndist : (nndist x t₀ : ℝ) ≤ (epsilonRadius R : ℝ) := by
        rw [Real.coe_toNNReal R hR.le, ← dist_nndist]
        exact hdist x hx
      exact NNReal.coe_le_coe.mp hnndist
  have hlevels : ∀ i : Fin (L + 1),
      IsInternalEpsilonNet K (levels i : Set α)
        (dyadicRadius R (i : Nat)) := by
    intro i
    by_cases hi : (i : Nat) = 0
    · have hli : levels i = {t₀} := if_pos hi
      rw [hli, hi]
      exact hroot_net
    · have hli : levels i = levels' i := if_neg hi
      rw [hli]
      exact hlevels' i
  obtain ⟨parent, hparent_mem, hparent_dist⟩ :=
    exists_finset_parentMap_of_internalRadiusLevels
      (rho := fun i : Fin (L + 1) => dyadicRadius R (i : Nat))
      (fun k => hlevels (Fin.castSucc k))
      (fun k => (hlevels (Fin.succ k)).1)
      (fun k => dyadicRadius_pos hR (Fin.castSucc k : Nat))
  have hne_levels : ∀ i : Fin (L + 1), (levels i).Nonempty := by
    intro i
    by_cases hi : (i : Nat) = 0
    · have hli : levels i = {t₀} := if_pos hi
      rw [hli]
      exact Finset.singleton_nonempty t₀
    · obtain ⟨y, hy, -⟩ := (hlevels i).2 ht₀
      exact ⟨y, Finset.mem_coe.mp hy⟩
  have hroot : ∀ y ∈ levels 0, y = t₀ := by
    intro y hy
    have hli : levels 0 = {t₀} := if_pos rfl
    rw [hli] at hy
    exact Finset.mem_singleton.mp hy
  have hN : ∀ k : Fin L,
      coveringNumber K (dyadicRadius R ((k : Nat) + 1)) =
        ((levels (Fin.succ k)).card : ENat) := by
    intro k
    have hneq : (Fin.succ k : Nat) ≠ 0 := by
      have hval : (Fin.succ k : Nat) = (k : Nat) + 1 := rfl
      omega
    have hli : levels (Fin.succ k) = levels' (Fin.succ k) := if_neg hneq
    rw [hli]
    exact hcard' (Fin.succ k)
  obtain ⟨Nf, -, hcoverNf, -⟩ :=
    exists_finset_isInternalEpsilonNet_of_totallyBounded
      (dyadicRadius_pos hR (L + 1)) hK
  have hfinite : coveringNumber K (dyadicRadius R (L + 1)) ≠ ⊤ := by
    rw [hcoverNf]
    exact ENat.coe_ne_top Nf.card
  refine ⟨levels (Fin.last L), hne_levels _, (hlevels _).1, ?_, ?_⟩
  · have hnet := hlevels (Fin.last L)
    rwa [Fin.val_last] at hnet
  · calc
      expect P (fun ω =>
          (levels (Fin.last L)).sup' (hne_levels _)
            (fun t => |X t ω - X t₀ ω|))
          ≤ finiteEntropySum
            (fun i : Fin (L + 1) => dyadicRadius R (i : Nat))
            (fun k => (levels (Fin.succ k)).card) σ :=
        expect_sup'_abs_sub_root_le_finiteEntropySum
          (P := P) (X := X) (σ := σ)
          (rho := fun i : Fin (L + 1) => dyadicRadius R (i : Nat))
          hroot hparent_mem hparent_dist
          (fun k => hne_levels _) (hne_levels _)
          hXMeas hX hσ (fun i => dyadicRadius_pos hR i)
      _ ≤ 4 * σ * (∫ t in dyadicRadius R (L + 1)..R,
          Real.sqrt (2 * Real.log
            (2 * ((coveringNumber K t).toNat : ℝ)))) :=
        finiteEntropySum_dyadic_le_four_mul_intervalIntegral_coveringNumber
          (K := K) (R := R) (sigma := σ) hR (le_of_lt hσ)
          (fun k => (levels (Fin.succ k)).card) hN hfinite

end

end HighDimProb
