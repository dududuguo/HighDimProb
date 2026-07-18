import HighDimProb.Concentration.FiniteMax
import HighDimProb.MetricEntropy
import HighDimProb.SubGaussian
import HighDimProb.SubGaussianProcess

/-!
# Finite maxima of centered subGaussian processes

This module specializes the fixed-parameter finite-maximum bound to a common
Mathlib subGaussian MGF scale and evaluates it at the optimized parameter.
-/

namespace HighDimProb

open MeasureTheory

noncomputable section

/--
Expected finite-process maximum bound for a common centered subGaussian scale.

The MGF and exponential-integrability obligations are discharged directly from
Mathlib's `HasSubgaussianMGF` fields.
-/
theorem expect_processSup_le_of_centeredSubGaussianMGF {Omega T : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {X : RandomProcess Omega T Real} {s : Finset T} (hs : s.Nonempty)
    (hs_card : 2 ≤ s.card)
    {K : Real}
    (hXMeas : ∀ t, t ∈ s → Measurable (X t))
    (hXSG : ∀ t, t ∈ s → CenteredSubGaussianMGF P (X t) K) :
    expect P (processSup X s hs) <=
      K * Real.sqrt (2 * Real.log (s.card : Real)) := by
  have hK : 0 < K := by
    obtain ⟨t, ht⟩ := hs
    exact (hXSG t ht).1
  have hLogPos : 0 < Real.log (s.card : Real) :=
    Real.log_pos (by exact_mod_cast hs_card)
  have hTwoLogPos : 0 < 2 * Real.log (s.card : Real) := by
    positivity
  let q : Real := Real.sqrt (2 * Real.log (s.card : Real))
  have hqPos : 0 < q := by
    dsimp [q]
    exact Real.sqrt_pos.mpr hTwoLogPos
  let theta : Real := q / K
  have hTheta : 0 < theta := by
    dsimp [theta]
    exact div_pos hqPos hK
  have hXCgf : ∀ t, t ∈ s →
      ProbabilityTheory.cgf (X t) P theta <= theta ^ 2 * K ^ 2 / 2 := by
    intro t ht
    have h := (hXSG t ht).2.cgf_le theta
    simpa [theta, q, mul_comm] using h
  have hXExpInt : ∀ t, t ∈ s →
      IntegrableRealRandomVariable P
        (fun omega => Real.exp (theta * X t omega)) := by
    intro t ht
    exact (hXSG t ht).2.integrable_exp_mul theta
  have hXInt : ∀ t, t ∈ s → IntegrableRealRandomVariable P (X t) := by
    intro t ht
    exact (hXSG t ht).2.integrable
  have hBound := expect_processSup_le_of_cgf_bound_at
    (P := P) (X := X) (s := s) hs hTheta hXMeas hXInt hXCgf hXExpInt
  have hqSq : q ^ 2 = 2 * Real.log (s.card : Real) := by
    dsimp [q]
    exact Real.sq_sqrt (le_of_lt hTwoLogPos)
  have hAlg :
      (1 / theta) * (Real.log (s.card : Real) + theta ^ 2 * K ^ 2 / 2) =
        K * q := by
    dsimp [theta]
    field_simp [ne_of_gt hK, ne_of_gt hqPos]
    nlinarith [hqSq]
  calc
    expect P (processSup X s hs) <=
        (1 / theta) * (Real.log (s.card : Real) + theta ^ 2 * K ^ 2 / 2) := hBound
    _ = K * Real.sqrt (2 * Real.log (s.card : Real)) := by
      rw [hAlg]

/-- Expected finite supremum of absolute values for a centered subGaussian process. -/
theorem expect_finset_sup'_abs_le_of_centeredSubGaussianMGF
    {Ω T : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω T ℝ} {s : Finset T} (hs : s.Nonempty)
    {K : ℝ}
    (hXMeas : ∀ t, t ∈ s → Measurable (X t))
    (hXSG : ∀ t, t ∈ s → CenteredSubGaussianMGF P (X t) K) :
    expect P (fun ω => s.sup' hs (fun t => |X t ω|)) ≤
      K * Real.sqrt (2 * Real.log (2 * (s.card : ℝ))) := by
  let Y : RandomProcess Ω (Sum T T) ℝ :=
    fun u =>
      match u with
      | Sum.inl t => X t
      | Sum.inr t => -X t
  let ss : Finset (Sum T T) := s.disjSum s
  have hss : ss.Nonempty := by
    dsimp [ss]
    obtain ⟨t, ht⟩ := hs
    exact ⟨Sum.inl t, Finset.mem_disjSum.mpr (Or.inl ⟨t, ht, rfl⟩)⟩
  have hss_card_eq : ss.card = 2 * s.card := by
    simp [ss, Finset.card_disjSum, two_mul]
  have hss_card : 2 ≤ ss.card := by
    have hs_card_pos : 1 ≤ s.card := Finset.card_pos.mpr hs
    omega
  have hYMeas : ∀ u, u ∈ ss → Measurable (Y u) := by
    intro u hu
    have hu' : u ∈ s.disjSum s := by simpa [ss] using hu
    rcases Finset.mem_disjSum.mp hu' with
      (⟨t, ht, rfl⟩ | ⟨t, ht, rfl⟩)
    · simpa [Y] using hXMeas t ht
    · change Measurable (fun x => -(X t x))
      exact (hXMeas t ht).neg
  have hYSG : ∀ u, u ∈ ss → CenteredSubGaussianMGF P (Y u) K := by
    intro u hu
    have hu' : u ∈ s.disjSum s := by simpa [ss] using hu
    rcases Finset.mem_disjSum.mp hu' with
      (⟨t, ht, rfl⟩ | ⟨t, ht, rfl⟩)
    · simpa [Y] using hXSG t ht
    · simpa [Y] using (hXSG t ht).neg
  have hPointwise : ∀ ω, processSup Y ss hss ω =
      s.sup' hs (fun t => |X t ω|) := by
    intro ω
    simp only [processSup, Finset.sup'_apply]
    apply le_antisymm
    · apply Finset.sup'_le hss
      intro u hu
      have hu' : u ∈ s.disjSum s := by simpa [ss] using hu
      rcases Finset.mem_disjSum.mp hu' with
        (⟨t, ht, rfl⟩ | ⟨t, ht, rfl⟩)
      · calc
          Y (Sum.inl t) ω = X t ω := by rfl
          _ ≤ |X t ω| := le_abs_self _
          _ ≤ s.sup' hs (fun t => |X t ω|) :=
            Finset.le_sup' (fun t => |X t ω|) ht
      · calc
          Y (Sum.inr t) ω = -X t ω := by rfl
          _ ≤ |X t ω| := neg_le_abs _
          _ ≤ s.sup' hs (fun t => |X t ω|) :=
            Finset.le_sup' (fun t => |X t ω|) ht
    · apply Finset.sup'_le hs
      intro t ht
      rw [abs_eq_max_neg]
      apply max_le
      · have hinl : Sum.inl t ∈ ss := by
          change Sum.inl t ∈ s.disjSum s
          exact Finset.mem_disjSum.mpr (Or.inl ⟨t, ht, rfl⟩)
        simpa [Y] using (Finset.le_sup' (fun u => Y u ω) hinl)
      · have hinr : Sum.inr t ∈ ss := by
          change Sum.inr t ∈ s.disjSum s
          exact Finset.mem_disjSum.mpr (Or.inr ⟨t, ht, rfl⟩)
        simpa [Y] using (Finset.le_sup' (fun u => Y u ω) hinr)
  have hBound := expect_processSup_le_of_centeredSubGaussianMGF
    (P := P) (X := Y) (s := ss) hss hss_card hYMeas hYSG
  calc
    expect P (fun ω => s.sup' hs (fun t => |X t ω|)) =
        expect P (processSup Y ss hss) := by
      apply congrArg (expect P)
      funext ω
      exact (hPointwise ω).symm
    _ ≤ K * Real.sqrt (2 * Real.log (ss.card : ℝ)) := hBound
    _ = K * Real.sqrt (2 * Real.log (2 * (s.card : ℝ))) := by
      simp [hss_card_eq, Nat.cast_mul]

/-- Expected finite chaining bound for centered subGaussian increments. -/
theorem expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF
    {Ω α : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ}
    (gamma : ℕ → α) (L : ℕ)
    (nextLevel : Fin L → Finset α)
    (parent : Fin L → α → α)
    (K : Fin L → ℝ)
    (hmem : ∀ k : Fin L,
      gamma ((k : ℕ) + 1) ∈ nextLevel k)
    (hparent : ∀ k : Fin L,
      gamma (k : ℕ) =
        parent k (gamma ((k : ℕ) + 1)))
    (hXMeas : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      Measurable (fun ω => X x ω - X (parent k x) ω))
    (hXSG : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      CenteredSubGaussianMGF P
        (fun ω => X x ω - X (parent k x) ω) (K k)) :
    expect P (fun ω => |X (gamma L) ω - X (gamma 0) ω|) ≤
      Finset.univ.sum (fun k : Fin L =>
        (K k) * Real.sqrt
          (2 * Real.log (2 * ((nextLevel k).card : ℝ)))) := by
  have hNextLevel : ∀ k : Fin L, (nextLevel k).Nonempty := by
    intro k
    exact ⟨gamma ((k : ℕ) + 1), hmem k⟩
  have hLevelIntegrable : ∀ k : Fin L,
      IntegrableRealRandomVariable P
        (fun ω =>
          Finset.sup' (nextLevel k)
            ⟨gamma ((k : ℕ) + 1), hmem k⟩
            (fun x => |X x ω - X (parent k x) ω|)) := by
    intro k
    let Y : RandomProcess Ω α ℝ :=
      fun x ω => |X x ω - X (parent k x) ω|
    have hYIntegrable : ∀ x ∈ nextLevel k,
        IntegrableRealRandomVariable P (Y x) := by
      intro x hx
      simpa only [Y] using (hXSG k x hx).2.integrable.abs
    have hSup := integrable_processSup
      (P := P) (X := Y) (s := nextLevel k) (hNextLevel k) hYIntegrable
    convert hSup using 1
    funext ω
    simp only [processSup, Finset.sup'_apply, Y]
  have hLevelBound : ∀ k : Fin L,
      expect P
          (fun ω =>
            Finset.sup' (nextLevel k)
              ⟨gamma ((k : ℕ) + 1), hmem k⟩
              (fun x => |X x ω - X (parent k x) ω|)) ≤
        (K k) * Real.sqrt
          (2 * Real.log (2 * ((nextLevel k).card : ℝ))) := by
    intro k
    exact
      expect_finset_sup'_abs_le_of_centeredSubGaussianMGF
        (P := P) (X := fun x ω => X x ω - X (parent k x) ω)
        (s := nextLevel k) (hNextLevel k)
        (fun x hx => hXMeas k x hx)
        (fun x hx => hXSG k x hx)
  have hChain := expect_abs_sub_chain_le_sum_of_level_sup
    (P := P) (X := X) gamma L nextLevel parent hmem hparent hLevelIntegrable
  calc
    expect P (fun ω => |X (gamma L) ω - X (gamma 0) ω|) ≤
        Finset.univ.sum (fun k : Fin L =>
          expect P
            (fun ω =>
              Finset.sup' (nextLevel k)
                ⟨gamma ((k : ℕ) + 1), hmem k⟩
                (fun x => |X x ω - X (parent k x) ω|))) := hChain
    _ ≤ Finset.univ.sum (fun k : Fin L =>
        (K k) * Real.sqrt
          (2 * Real.log (2 * ((nextLevel k).card : ℝ)))) := by
      exact Finset.sum_le_sum (fun k _hk => hLevelBound k)

/-- Expected finite chaining bound from metric subGaussian increments and level radii. -/
theorem expect_abs_sub_chain_le_sum_of_level_sup_of_subGaussianMGFIncrements
    {Ω α : Type*} [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ}
    (gamma : ℕ → α) (L : ℕ)
    (nextLevel : Fin L → Finset α)
    (parent : Fin L → α → α)
    (σ : ℝ) (r : Fin L → ℝ)
    (hmem : ∀ k : Fin L,
      gamma ((k : ℕ) + 1) ∈ nextLevel k)
    (hparent : ∀ k : Fin L,
      gamma (k : ℕ) = parent k (gamma ((k : ℕ) + 1)))
    (hXMeas : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      Measurable (fun ω => X x ω - X (parent k x) ω))
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hσ : 0 < σ)
    (hr : ∀ k : Fin L, 0 < r k)
    (hdist : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      dist x (parent k x) ≤ r k) :
    expect P (fun ω => |X (gamma L) ω - X (gamma 0) ω|) ≤
      Finset.univ.sum (fun k : Fin L =>
        (σ * r k) * Real.sqrt
          (2 * Real.log (2 * ((nextLevel k).card : ℝ)))) := by
  have hXSG : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      CenteredSubGaussianMGF P
        (fun ω => X x ω - X (parent k x) ω) (σ * r k) := by
    intro k x hx
    exact HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le
      hX hσ (hr k) (hdist k x hx)
  exact expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF
    gamma L nextLevel parent (fun k => σ * r k)
    hmem hparent hXMeas hXSG

/-- Expected finite chaining bound with cardinality upper bounds. -/
theorem expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF_of_card_le
    {Ω α : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ}
    (gamma : ℕ → α) (L : ℕ)
    (nextLevel : Fin L → Finset α)
    (parent : Fin L → α → α)
    (K : Fin L → ℝ)
    (N : Fin L → ℕ)
    (hmem : ∀ k : Fin L,
      gamma ((k : ℕ) + 1) ∈ nextLevel k)
    (hparent : ∀ k : Fin L,
      gamma (k : ℕ) = parent k (gamma ((k : ℕ) + 1)))
    (hXMeas : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      Measurable (fun ω => X x ω - X (parent k x) ω))
    (hXSG : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      CenteredSubGaussianMGF P
        (fun ω => X x ω - X (parent k x) ω) (K k))
    (hcard : ∀ k : Fin L, (nextLevel k).card ≤ N k) :
    expect P (fun ω => |X (gamma L) ω - X (gamma 0) ω|) ≤
      Finset.univ.sum (fun k : Fin L =>
        (K k) * Real.sqrt (2 * Real.log (2 * (N k : ℝ)))) := by
  have hBound :=
    expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF
      gamma L nextLevel parent K hmem hparent hXMeas hXSG
  calc
    expect P (fun ω => |X (gamma L) ω - X (gamma 0) ω|) ≤
        Finset.univ.sum (fun k : Fin L =>
          (K k) * Real.sqrt
            (2 * Real.log (2 * ((nextLevel k).card : ℝ)))) := hBound
    _ ≤ Finset.univ.sum (fun k : Fin L =>
        (K k) * Real.sqrt (2 * Real.log (2 * (N k : ℝ)))) := by
      apply Finset.sum_le_sum
      intro k _hk
      have hK : 0 < K k :=
        (hXSG k (gamma ((k : ℕ) + 1)) (hmem k)).1
      have hCardPosNat : 0 < (nextLevel k).card :=
        Finset.card_pos.mpr ⟨gamma ((k : ℕ) + 1), hmem k⟩
      have hCardPos : 0 < ((nextLevel k).card : ℝ) := by
        exact_mod_cast hCardPosNat
      have hCardLe : ((nextLevel k).card : ℝ) ≤ (N k : ℝ) := by
        exact_mod_cast hcard k
      have hLog :
          Real.log (2 * ((nextLevel k).card : ℝ)) ≤
            Real.log (2 * (N k : ℝ)) := by
        apply Real.log_le_log
        · positivity
        · exact mul_le_mul_of_nonneg_left hCardLe (by norm_num)
      have hSqrt :
          Real.sqrt (2 * Real.log (2 * ((nextLevel k).card : ℝ))) ≤
            Real.sqrt (2 * Real.log (2 * (N k : ℝ))) :=
        Real.sqrt_le_sqrt (mul_le_mul_of_nonneg_left hLog (by norm_num))
      exact mul_le_mul_of_nonneg_left hSqrt (le_of_lt hK)

/-- Finite chaining bound written with an explicit natural cardinality family. -/
theorem expect_abs_sub_chain_le_finiteEntropySum
    {Ω α : Type*} [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ}
    (gamma : ℕ → α) (L : ℕ)
    (nextLevel : Fin L → Finset α)
    (parent : Fin L → α → α)
    (σ : ℝ) (rho : Fin (L + 1) → ℝ)
    (N : Fin L → ℕ)
    (hmem : ∀ k : Fin L,
      gamma ((k : ℕ) + 1) ∈ nextLevel k)
    (hparent : ∀ k : Fin L,
      gamma (k : ℕ) = parent k (gamma ((k : ℕ) + 1)))
    (hXMeas : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      Measurable (fun ω => X x ω - X (parent k x) ω))
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hσ : 0 < σ)
    (hρ : ∀ j : Fin (L + 1), 0 < rho j)
    (hdist : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      dist x (parent k x) ≤ rho (Fin.castSucc k))
    (hcard : ∀ k : Fin L, (nextLevel k).card = N k) :
    expect P (fun ω => |X (gamma L) ω - X (gamma 0) ω|) ≤
      finiteEntropySum rho N σ := by
  have hBound :=
    expect_abs_sub_chain_le_sum_of_level_sup_of_subGaussianMGFIncrements
      gamma L nextLevel parent σ (fun k => rho (Fin.castSucc k))
      hmem hparent hXMeas hX hσ
      (fun k => hρ (Fin.castSucc k)) hdist
  simpa [finiteEntropySum, hcard] using hBound

/-- Finite chaining bound for a path indexed by `Fin (L + 1)`. -/
theorem expect_abs_sub_chain_le_finiteEntropySum_of_path
    {Ω α : Type*} [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ}
    {L : Nat}
    (path : Fin (L + 1) → α)
    (nextLevel : Fin L → Finset α)
    (parent : Fin L → α → α)
    (σ : ℝ) (rho : Fin (L + 1) → ℝ) (N : Fin L → ℕ)
    (hmem : ∀ k : Fin L, path (Fin.succ k) ∈ nextLevel k)
    (hparent : ∀ k : Fin L,
      path (Fin.castSucc k) = parent k (path (Fin.succ k)))
    (hXMeas : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      Measurable (fun ω => X x ω - X (parent k x) ω))
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hσ : 0 < σ)
    (hρ : ∀ j : Fin (L + 1), 0 < rho j)
    (hdist : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      dist x (parent k x) ≤ rho (Fin.castSucc k))
    (hcard : ∀ k : Fin L, (nextLevel k).card = N k) :
    expect P (fun ω =>
        |X (path (Fin.last L)) ω - X (path 0) ω|) ≤
      finiteEntropySum rho N σ := by
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
      gamma ((k : ℕ) + 1) ∈ nextLevel k := by
    intro k
    rw [show gamma ((k : ℕ) + 1) = path (Fin.succ k) by
      simpa using hgamma ((k : ℕ) + 1) (by omega)]
    exact hmem k
  have hgamma_parent : ∀ k : Fin L,
      gamma (k : ℕ) = parent k (gamma ((k : ℕ) + 1)) := by
    intro k
    rw [show gamma (k : ℕ) = path (Fin.castSucc k) by
        simpa using hgamma (k : ℕ) (Nat.le_of_lt k.isLt),
      show gamma ((k : ℕ) + 1) = path (Fin.succ k) by
        simpa using hgamma ((k : ℕ) + 1) (by omega)]
    exact hparent k
  have hBound := expect_abs_sub_chain_le_finiteEntropySum
    gamma L nextLevel parent σ rho N hgamma_mem hgamma_parent
    hXMeas hX hσ hρ hdist hcard
  simpa [hgamma_zero, hgamma_last] using hBound

/-- Expected finite anchored supremum bound with an explicit terminal residual. -/
theorem expect_finset_sup'_abs_sub_anchor_le_finiteEntropySum
    {Ω α : Type*} [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ}
    {L : Nat}
    (s : Finset α) (hs : s.Nonempty)
    (path : α → Fin (L + 1) → α)
    (nextLevel : Fin L → Finset α)
    (parent : Fin L → α → α)
    (anchor : α)
    (residual : RealRandomVariable Ω)
    (σ : ℝ) (rho : Fin (L + 1) → ℝ)
    (hmem : ∀ x ∈ s, ∀ k : Fin L,
      path x (Fin.succ k) ∈ nextLevel k)
    (hparent : ∀ x ∈ s, ∀ k : Fin L,
      path x (Fin.castSucc k) = parent k (path x (Fin.succ k)))
    (hresidual : ∀ x ∈ s, ∀ ω : Ω,
      |X x ω - X (path x (Fin.last L)) ω| ≤ residual ω)
    (hanchor : ∀ x ∈ s, path x 0 = anchor)
    (hXMeas : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      Measurable (fun ω => X x ω - X (parent k x) ω))
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hσ : 0 < σ)
    (hρ : ∀ j : Fin (L + 1), 0 < rho j)
    (hdist : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      dist x (parent k x) ≤ rho (Fin.castSucc k))
    (hresidualIntegrable : IntegrableRealRandomVariable P residual) :
    expect P (fun ω => s.sup' hs (fun x => |X x ω - X anchor ω|)) ≤
      expect P residual +
        finiteEntropySum rho (fun k : Fin L => (nextLevel k).card) σ := by
  let x₀ : α := Classical.choose hs
  have hx₀ : x₀ ∈ s := Classical.choose_spec hs
  have hNextLevel : ∀ k : Fin L, (nextLevel k).Nonempty := by
    intro k
    exact ⟨path x₀ (Fin.succ k), hmem x₀ hx₀ k⟩
  let stepBound : Fin L → RealRandomVariable Ω := fun k ω =>
    Finset.sup' (nextLevel k) (hNextLevel k)
      (fun x => |X x ω - X (parent k x) ω|)
  have hstep : ∀ x ∈ s, ∀ k : Fin L, ∀ ω : Ω,
      |X (path x (Fin.succ k)) ω - X (path x (Fin.castSucc k)) ω| ≤
        stepBound k ω := by
    intro x hx k ω
    rw [hparent x hx k]
    exact Finset.le_sup' (fun y => |X y ω - X (parent k y) ω|)
      (hmem x hx k)
  have hXSG : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      CenteredSubGaussianMGF P
        (fun ω => X x ω - X (parent k x) ω)
        (σ * rho (Fin.castSucc k)) := by
    intro k x hx
    exact HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le
      hX hσ (hρ (Fin.castSucc k)) (hdist k x hx)
  have hstepIntegrable : ∀ k : Fin L,
      IntegrableRealRandomVariable P (stepBound k) := by
    intro k
    let Y : RandomProcess Ω α ℝ := fun x ω =>
      |X x ω - X (parent k x) ω|
    have hYIntegrable : ∀ x ∈ nextLevel k,
        IntegrableRealRandomVariable P (Y x) := by
      intro x hx
      simpa only [Y] using (hXSG k x hx).2.integrable.abs
    have hSup := integrable_processSup
      (P := P) (X := Y) (s := nextLevel k) (hNextLevel k) hYIntegrable
    change IntegrableRealRandomVariable P
      (fun ω => Finset.sup' (nextLevel k) (hNextLevel k)
        (fun x => |X x ω - X (parent k x) ω|))
    convert hSup using 1
    funext ω
    simp only [processSup, Finset.sup'_apply, Y]
  have hLevelBound : ∀ k : Fin L,
      expect P (stepBound k) ≤
        (σ * rho (Fin.castSucc k)) * Real.sqrt
          (2 * Real.log (2 * ((nextLevel k).card : ℝ))) := by
    intro k
    exact expect_finset_sup'_abs_le_of_centeredSubGaussianMGF
      (P := P)
      (X := fun x ω => X x ω - X (parent k x) ω)
      (s := nextLevel k) (hNextLevel k)
      (fun x hx => hXMeas k x hx)
      (fun x hx => hXSG k x hx)
  have hBound :=
    expect_finset_sup'_abs_sub_anchor_le_residual_add_sum_of_step_bound
      (P := P) (X := X) (s := s) (hs := hs) (path := path)
      (anchor := anchor) (residual := residual) (stepBound := stepBound)
      (hresidual := hresidual) (hanchor := hanchor) (hstep := hstep)
      (hresidualIntegrable := hresidualIntegrable)
      (hstepIntegrable := hstepIntegrable)
  calc
    expect P (fun ω => s.sup' hs (fun x => |X x ω - X anchor ω|)) ≤
        expect P residual + ∑ k : Fin L, expect P (stepBound k) := hBound
    _ ≤ expect P residual + ∑ k : Fin L,
        (σ * rho (Fin.castSucc k)) * Real.sqrt
          (2 * Real.log (2 * ((nextLevel k).card : ℝ))) := by
      calc
        expect P residual + ∑ k : Fin L, expect P (stepBound k) =
            (∑ k : Fin L, expect P (stepBound k)) + expect P residual :=
          add_comm _ _
        _ ≤ (∑ k : Fin L,
            (σ * rho (Fin.castSucc k)) * Real.sqrt
              (2 * Real.log (2 * ((nextLevel k).card : ℝ)))) +
            expect P residual :=
          add_le_add_left
            (Finset.sum_le_sum (s := (Finset.univ : Finset (Fin L)))
              (fun k _hk => hLevelBound k)) _
        _ = expect P residual + ∑ k : Fin L,
            (σ * rho (Fin.castSucc k)) * Real.sqrt
              (2 * Real.log (2 * ((nextLevel k).card : ℝ))) :=
          add_comm _ _
    _ = expect P residual +
        finiteEntropySum rho (fun k : Fin L => (nextLevel k).card) σ := by
      rfl

/-- Expected finite anchored supremum bound by a truncated entropy integral and
an explicit terminal residual. -/
theorem expect_finset_sup'_abs_sub_anchor_le_truncatedEntropyIntegral
    {Ω α : Type*} [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ}
    {K : Set α} {L : Nat} {R σ : ℝ}
    (s : Finset α) (hs : s.Nonempty)
    (path : α → Fin (L + 1) → α)
    (nextLevel : Fin L → Finset α)
    (parent : Fin L → α → α)
    (anchor : α)
    (residual : RealRandomVariable Ω)
    (hmem : ∀ x ∈ s, ∀ k : Fin L,
      path x (Fin.succ k) ∈ nextLevel k)
    (hparent : ∀ x ∈ s, ∀ k : Fin L,
      path x (Fin.castSucc k) = parent k (path x (Fin.succ k)))
    (hresidual : ∀ x ∈ s, ∀ ω : Ω,
      |X x ω - X (path x (Fin.last L)) ω| ≤ residual ω)
    (hanchor : ∀ x ∈ s, path x 0 = anchor)
    (hXMeas : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      Measurable (fun ω => X x ω - X (parent k x) ω))
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hσ : 0 < σ)
    (hR : 0 < R)
    (hdist : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      dist x (parent k x) ≤ dyadicRadius R (Fin.castSucc k : Nat))
    (hN : ∀ k : Fin L,
      coveringNumber K (dyadicRadius R ((k : Nat) + 1)) =
        ((nextLevel k).card : ENat))
    (hfinite : coveringNumber K (dyadicRadius R (L + 1)) ≠ ⊤)
    (hresidualIntegrable : IntegrableRealRandomVariable P residual) :
    expect P (fun ω => s.sup' hs (fun x => |X x ω - X anchor ω|)) ≤
      expect P residual +
        4 * σ *
          (∫ t in dyadicRadius R (L + 1)..R,
            Real.sqrt (2 * Real.log
              (2 * ((coveringNumber K t).toNat : ℝ)))) := by
  have hFinite :=
    expect_finset_sup'_abs_sub_anchor_le_finiteEntropySum
      (P := P) (X := X) (s := s) (hs := hs) (path := path)
      (nextLevel := nextLevel) (parent := parent) (anchor := anchor)
      (residual := residual) (σ := σ)
      (rho := fun i : Fin (L + 1) => dyadicRadius R (i : Nat))
      (hmem := hmem) (hparent := hparent) (hresidual := hresidual)
      (hanchor := hanchor) (hXMeas := hXMeas) (hX := hX) (hσ := hσ)
      (hρ := fun i => dyadicRadius_pos hR i) (hdist := hdist)
      (hresidualIntegrable := hresidualIntegrable)
  have hEntropy :=
    finiteEntropySum_dyadic_le_four_mul_intervalIntegral_coveringNumber
      (K := K) (R := R) (sigma := σ)
      hR (le_of_lt hσ) (fun k : Fin L => (nextLevel k).card) hN hfinite
  calc
    expect P (fun ω => s.sup' hs (fun x => |X x ω - X anchor ω|)) ≤
        expect P residual +
          finiteEntropySum
            (fun i : Fin (L + 1) => dyadicRadius R (i : Nat))
            (fun k : Fin L => (nextLevel k).card) σ := hFinite
    _ ≤ expect P residual +
        4 * σ *
          (∫ t in dyadicRadius R (L + 1)..R,
            Real.sqrt (2 * Real.log
              (2 * ((coveringNumber K t).toNat : ℝ)))) := by
      calc
        expect P residual +
            finiteEntropySum
              (fun i : Fin (L + 1) => dyadicRadius R (i : Nat))
              (fun k : Fin L => (nextLevel k).card) σ =
            finiteEntropySum
              (fun i : Fin (L + 1) => dyadicRadius R (i : Nat))
              (fun k : Fin L => (nextLevel k).card) σ + expect P residual :=
          add_comm _ _
        _ ≤
            4 * σ *
                (∫ t in dyadicRadius R (L + 1)..R,
                  Real.sqrt (2 * Real.log
                    (2 * ((coveringNumber K t).toNat : ℝ)))) +
              expect P residual :=
          add_le_add_left hEntropy _
        _ = expect P residual +
            4 * σ *
                (∫ t in dyadicRadius R (L + 1)..R,
                  Real.sqrt (2 * Real.log
                  (2 * ((coveringNumber K t).toNat : ℝ)))) :=
          add_comm _ _

/-- Finite dyadic chaining bound by the truncated covering-number entropy integral. -/
theorem expect_abs_sub_dyadic_path_le_truncatedEntropyIntegral
    {Ω α : Type*} [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ}
    {K : Set α} {L : Nat} {R σ : ℝ}
    (path : Fin (L + 1) → α)
    (nextLevel : Fin L → Finset α)
    (parent : Fin L → α → α)
    (hmem : ∀ k : Fin L, path (Fin.succ k) ∈ nextLevel k)
    (hparent : ∀ k : Fin L,
      path (Fin.castSucc k) = parent k (path (Fin.succ k)))
    (hXMeas : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      Measurable (fun ω => X x ω - X (parent k x) ω))
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hσ : 0 < σ)
    (hR : 0 < R)
    (hdist : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      dist x (parent k x) ≤ dyadicRadius R (Fin.castSucc k : Nat))
    (hN : ∀ k : Fin L,
      coveringNumber K (dyadicRadius R ((k : Nat) + 1)) =
        ((nextLevel k).card : ENat))
    (hfinite : coveringNumber K (dyadicRadius R (L + 1)) ≠ ⊤) :
    expect P (fun ω =>
        |X (path (Fin.last L)) ω - X (path 0) ω|) ≤
      4 * σ *
        (∫ t in dyadicRadius R (L + 1)..R,
          Real.sqrt (2 * Real.log
            (2 * ((coveringNumber K t).toNat : ℝ)))) := by
  have hPath :=
    expect_abs_sub_chain_le_finiteEntropySum_of_path
      (path := path) (nextLevel := nextLevel) (parent := parent)
      (σ := σ)
      (rho := fun i : Fin (L + 1) => dyadicRadius R (i : Nat))
      (N := fun k : Fin L => (nextLevel k).card)
      hmem hparent hXMeas hX hσ
      (fun i => dyadicRadius_pos hR i) hdist (fun _ => rfl)
  exact hPath.trans
    (finiteEntropySum_dyadic_le_four_mul_intervalIntegral_coveringNumber
      (K := K) (R := R) (sigma := σ) hR (le_of_lt hσ)
      (fun k : Fin L => (nextLevel k).card) hN hfinite)

end

end HighDimProb
