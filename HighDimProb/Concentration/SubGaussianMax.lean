import HighDimProb.Concentration.FiniteMax
import HighDimProb.SubGaussian

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

end

end HighDimProb
