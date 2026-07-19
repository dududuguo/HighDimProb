import HighDimProb.Concentration.SubGaussianMax

namespace HighDimProbTest

open HighDimProb
open MeasureTheory

noncomputable section

#check expect_processSup_le_of_centeredSubGaussianMGF

example {Omega T : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {X : RandomProcess Omega T Real} {s : Finset T} (hs : s.Nonempty)
    (hs_card : 2 ≤ s.card)
    {K : Real}
    (hXMeas : ∀ t, t ∈ s → Measurable (X t))
    (hXSG : ∀ t, t ∈ s → CenteredSubGaussianMGF P (X t) K) :
    expect P (processSup X s hs) <=
      K * Real.sqrt (2 * Real.log (s.card : Real)) := by
  exact expect_processSup_le_of_centeredSubGaussianMGF
    hs hs_card hXMeas hXSG

#check expect_finset_sup'_abs_le_of_centeredSubGaussianMGF

#check expect_iSup_abs_sub_anchor_le_of_denseRange_of_prefix_bound
#check expect_iSup_abs_sub_anchor_le_mul_intervalIntegral_of_denseRange_of_prefix_bound

#check expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF

#check expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF_of_card_le
#check expect_abs_sub_chain_le_finiteEntropySum
#check expect_abs_sub_chain_le_finiteEntropySum_of_path
#check expect_abs_sub_dyadic_path_le_truncatedEntropyIntegral
#check expect_finset_sup'_abs_sub_anchor_le_finiteEntropySum
#check expect_finset_sup'_abs_sub_anchor_le_truncatedEntropyIntegral

example
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
  exact expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF
    gamma L nextLevel parent K hmem hparent hXMeas hXSG

example
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
      gamma (k : ℕ) =
        parent k (gamma ((k : ℕ) + 1)))
    (hXMeas : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      Measurable (fun ω => X x ω - X (parent k x) ω))
    (hXSG : ∀ k : Fin L, ∀ x ∈ nextLevel k,
      CenteredSubGaussianMGF P
        (fun ω => X x ω - X (parent k x) ω) (K k))
    (hcard : ∀ k : Fin L, (nextLevel k).card ≤ N k) :
    expect P (fun ω => |X (gamma L) ω - X (gamma 0) ω|) ≤
      Finset.univ.sum (fun k : Fin L =>
        (K k) * Real.sqrt
          (2 * Real.log (2 * (N k : ℝ)))) := by
  exact expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF_of_card_le
    gamma L nextLevel parent K N hmem hparent hXMeas hXSG hcard

example
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
  exact expect_abs_sub_chain_le_finiteEntropySum
    gamma L nextLevel parent σ rho N hmem hparent hXMeas hX hσ hρ hdist hcard

-- These fields are the geometry path package consumed by the Fin-indexed API.
example
    {Ω α : Type*} [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ}
    {L : Nat}
    (levels : Fin (L + 1) → Finset α)
    (parent : Fin L → α → α)
    (path : Fin (L + 1) → α) (x : α)
    (σ : ℝ) (rho : Fin (L + 1) → ℝ)
    (hpath : path (Fin.last L) = x ∧
      (∀ j, path j ∈ levels j) ∧
      (∀ k : Fin L,
        path (Fin.castSucc k) = parent k (path (Fin.succ k)) ∧
        dist (path (Fin.succ k))
          (parent k (path (Fin.succ k))) ≤ rho (Fin.castSucc k)))
    (hXMeas : ∀ k : Fin L, ∀ y ∈ levels (Fin.succ k),
      Measurable (fun ω => X y ω - X (parent k y) ω))
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hσ : 0 < σ)
    (hρ : ∀ j : Fin (L + 1), 0 < rho j)
    (hdist : ∀ k : Fin L, ∀ y ∈ levels (Fin.succ k),
      dist y (parent k y) ≤ rho (Fin.castSucc k)) :
    expect P (fun ω => |X x ω - X (path 0) ω|) ≤
      finiteEntropySum rho (fun k : Fin L => (levels (Fin.succ k)).card) σ := by
  have hBound := expect_abs_sub_chain_le_finiteEntropySum_of_path
    (path := path) (nextLevel := fun k : Fin L => levels (Fin.succ k))
    (parent := parent) (σ := σ) (rho := rho)
    (N := fun k : Fin L => (levels (Fin.succ k)).card)
    (fun k => hpath.2.1 (Fin.succ k))
    (fun k => (hpath.2.2 k).1)
    hXMeas hX hσ hρ hdist (fun _ => rfl)
  simpa [hpath.1] using hBound

example
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
  exact expect_abs_sub_dyadic_path_le_truncatedEntropyIntegral
    path nextLevel parent hmem hparent hXMeas hX hσ hR hdist hN hfinite

example
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
  exact expect_finset_sup'_abs_sub_anchor_le_truncatedEntropyIntegral
    (s := s) (hs := hs) (path := path) (nextLevel := nextLevel)
    (parent := parent) (anchor := anchor) (residual := residual)
    (hmem := hmem) (hparent := hparent) (hresidual := hresidual)
    (hanchor := hanchor) (hXMeas := hXMeas) (hX := hX) (hσ := hσ)
    (hR := hR) (hdist := hdist) (hN := hN) (hfinite := hfinite)
    (hresidualIntegrable := hresidualIntegrable)

example {Omega T : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {X : RandomProcess Omega T Real} {s : Finset T} (hs : s.Nonempty)
    {K : Real}
    (hXMeas : ∀ t, t ∈ s → Measurable (X t))
    (hXSG : ∀ t, t ∈ s → CenteredSubGaussianMGF P (X t) K) :
    expect P (fun omega => s.sup' hs (fun t => |X t omega|)) <=
      K * Real.sqrt (2 * Real.log (2 * (s.card : Real))) := by
  exact expect_finset_sup'_abs_le_of_centeredSubGaussianMGF
    hs hXMeas hXSG

example {Ω α : Type*} [MeasurableSpace Ω] [TopologicalSpace α]
    {P : Measure Ω}
    {X : RandomProcess Ω α ℝ}
    (u : ℕ → α) (hu : DenseRange u) (anchor : α) (C : ℝ)
    (hAnchorMeas : Measurable (X anchor))
    (hUmeas : ∀ n : ℕ, Measurable (X (u n)))
    (hPathCont : ∀ ω : Ω, Continuous
      (fun x => |X x ω - X anchor ω|))
    (hPathBdd : ∀ ω : Ω, BddAbove
      (Set.range (fun x => |X x ω - X anchor ω|)))
    (hFullIntegrable : IntegrableRealRandomVariable P
      (fun ω => ⨆ x : α, |X x ω - X anchor ω|))
    (hPrefixBound : ∀ n : ℕ,
      expect P (fun ω =>
        (Finset.range (n + 1)).sup' Finset.nonempty_range_add_one
          (fun k => |X (u k) ω - X anchor ω|)) ≤ C) :
    expect P (fun ω => ⨆ x : α, |X x ω - X anchor ω|) ≤ C := by
  exact expect_iSup_abs_sub_anchor_le_of_denseRange_of_prefix_bound
    u hu anchor C hAnchorMeas hUmeas hPathCont hPathBdd
    hFullIntegrable hPrefixBound

example {Ω α : Type*} [MeasurableSpace Ω] [TopologicalSpace α]
    {P : Measure Ω}
    {X : RandomProcess Ω α ℝ}
    (u : ℕ → α) (hu : DenseRange u) (anchor : α)
    (c R : ℝ) (f : ℝ → ℝ) (residual : ℕ → ℕ → ℝ)
    (hAnchorMeas : Measurable (X anchor))
    (hUmeas : ∀ n : ℕ, Measurable (X (u n)))
    (hPathCont : ∀ ω : Ω, Continuous
      (fun x => |X x ω - X anchor ω|))
    (hPathBdd : ∀ ω : Ω, BddAbove
      (Set.range (fun x => |X x ω - X anchor ω|)))
    (hFullIntegrable : IntegrableRealRandomVariable P
      (fun ω => ⨆ x : α, |X x ω - X anchor ω|))
    (hR : 0 ≤ R)
    (hf : IntervalIntegrable f volume 0 R)
    (hResidualTendsto : ∀ n : ℕ,
      Filter.Tendsto (residual n) Filter.atTop (nhds 0))
    (hPrefixBound : ∀ n m : ℕ,
      expect P (fun ω =>
        (Finset.range (n + 1)).sup' Finset.nonempty_range_add_one
          (fun k => |X (u k) ω - X anchor ω|)) ≤
        residual n m + c *
          (∫ t in dyadicRadius R (m + 1)..R, f t)) :
    expect P (fun ω => ⨆ x : α, |X x ω - X anchor ω|) ≤
      c * (∫ t in (0 : ℝ)..R, f t) := by
  exact expect_iSup_abs_sub_anchor_le_mul_intervalIntegral_of_denseRange_of_prefix_bound
    u hu anchor c R f residual hAnchorMeas hUmeas hPathCont hPathBdd
    hFullIntegrable hR hf hResidualTendsto hPrefixBound

end

end HighDimProbTest
