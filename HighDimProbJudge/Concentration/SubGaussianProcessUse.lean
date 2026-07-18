import HighDimProb.SubGaussianProcess
import HighDimProb.Concentration.SubGaussianMax

open MeasureTheory
open HighDimProb

#check HighDimProb.HasSubGaussianMGFIncrements
#check HighDimProb.HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le
#check HighDimProb.expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF
#check HighDimProb.expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF_of_card_le
#check HighDimProb.expect_abs_sub_chain_le_sum_of_level_sup_of_subGaussianMGFIncrements
#check HighDimProb.finiteEntropySum
#check HighDimProb.expect_abs_sub_chain_le_finiteEntropySum
#check HighDimProb.expect_abs_sub_chain_le_finiteEntropySum_of_path
#check HighDimProb.expect_abs_sub_dyadic_path_le_truncatedEntropyIntegral
#check HighDimProb.expect_finset_sup'_abs_sub_anchor_le_finiteEntropySum
#check HighDimProb.expect_finset_sup'_abs_sub_anchor_le_truncatedEntropyIntegral
#check HighDimProb.expect_iSup_abs_sub_anchor_le_of_denseRange_of_prefix_bound

example
    {Ω α : Type*} [MeasurableSpace Ω] [TopologicalSpace α]
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
  exact HighDimProb.expect_iSup_abs_sub_anchor_le_of_denseRange_of_prefix_bound
    u hu anchor C hAnchorMeas hUmeas hPathCont hPathBdd hFullIntegrable hPrefixBound

example
    {Ω α : Type*} [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ}
    {K : Set α} {s : Finset α} {L : Nat} {R σ : ℝ}
    (hs : s.Nonempty)
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

example {Ω T : Type*} [MeasurableSpace Ω] [PseudoMetricSpace T]
    {P : Measure Ω} {X : RandomProcess Ω T ℝ} {σ r : ℝ} {s t : T}
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hσ : 0 < σ) (hr : 0 < r) (h_dist : dist s t ≤ r) :
    CenteredSubGaussianMGF P (X s - X t) (σ * r) := by
  exact HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le
    hX hσ hr h_dist

example {Ω T : Type*} [MeasurableSpace Ω] [PseudoMetricSpace T]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω T ℝ} {σ r : ℝ}
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hXMeas : ∀ t, Measurable (X t))
    (hσ : 0 < σ) (hr : 0 < r)
    (gamma : ℕ → T) (nextLevel : Fin 1 → Finset T)
    (parent : Fin 1 → T → T)
    (hmem : ∀ k : Fin 1, gamma ((k : ℕ) + 1) ∈ nextLevel k)
    (hparent : ∀ k : Fin 1,
      gamma (k : ℕ) = parent k (gamma ((k : ℕ) + 1)))
    (hdist : ∀ k : Fin 1, ∀ x, x ∈ nextLevel k →
      dist x (parent k x) ≤ r) :
    expect P (fun ω => |X (gamma 1) ω - X (gamma 0) ω|) ≤
      Finset.univ.sum (fun k : Fin 1 =>
        (σ * r) * Real.sqrt
          (2 * Real.log (2 * ((nextLevel k).card : ℝ)))) := by
  refine expect_abs_sub_chain_le_sum_of_level_sup_of_subGaussianMGFIncrements
    gamma 1 nextLevel parent σ (fun _ => r) hmem hparent ?_ hX hσ ?_ ?_
  · intro k x hx
    exact (hXMeas x).sub (hXMeas (parent k x))
  · intro _
    exact hr
  · exact hdist
