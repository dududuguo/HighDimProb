import HighDimProb.Concentration.Dudley

open HighDimProb
open MeasureTheory

#check @HighDimProb.abs_sub_root_le_sum_level_sup_of_mem_terminal
#check @HighDimProb.sup'_abs_sub_root_le_sum_level_sup
#check @HighDimProb.expect_sup'_abs_sub_root_le_sum_level_sup
#check @HighDimProb.expect_sup'_abs_sub_root_le_finiteEntropySum
#check @HighDimProb.exists_terminal_net_expect_sup'_abs_sub_le_truncatedEntropyIntegral

/-- The fixed-root terminal-net Dudley consumer applies directly from metric and
process hypotheses, with no path, parent, or cardinality data supplied. -/
example {Ω α : Type*} [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ} {K : Set α} {t₀ : α} {R σ : ℝ} (L : ℕ)
    (hK : TotallyBounded K) (ht₀ : t₀ ∈ K) (hR : 0 < R)
    (hdist : ∀ t ∈ K, dist t t₀ ≤ R)
    (hXMeas : ∀ t, Measurable (X t))
    (hX : HasSubGaussianMGFIncrements P X σ) (hσ : 0 < σ) :
    ∃ T : Finset α, ∃ hT : T.Nonempty,
      (T : Set α) ⊆ K ∧
      IsInternalEpsilonNet K (T : Set α) (dyadicRadius R L) ∧
      expect P (fun ω => T.sup' hT (fun t => |X t ω - X t₀ ω|)) ≤
        4 * σ * (∫ t in dyadicRadius R (L + 1)..R,
          Real.sqrt (2 * Real.log (2 * ((coveringNumber K t).toNat : ℝ)))) :=
  exists_terminal_net_expect_sup'_abs_sub_le_truncatedEntropyIntegral
    L hK ht₀ hR hdist hXMeas hX hσ
