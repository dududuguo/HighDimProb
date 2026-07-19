import HighDimProb.Concentration.SubGaussianMax

open MeasureTheory
open HighDimProb

#check HighDimProb.expect_iSup_abs_sub_anchor_le_mul_intervalIntegral_of_denseRange_of_prefix_bound

example
    {Ω α : Type*} [MeasurableSpace Ω] [TopologicalSpace α]
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
