import HighDimProb.Concentration.Dudley

/-!
# Truncated Dudley terminal-net usage example

This examples-only file records the external calling pattern of the finite,
fixed-root, terminal-net truncated Dudley consumer: the caller provides only a
totally bounded index set, a root within radius `R`, subGaussian increments, and
measurability, and receives a finite internal terminal net with the truncated
covering-number entropy-integral bound.
-/

namespace HighDimProb.Examples.DudleyUsage

open MeasureTheory

noncomputable section

/-- Thin external call of the fixed-root terminal-net Dudley consumer. -/
theorem exists_terminal_net_dudley_bound {Ω α : Type*}
    [MeasurableSpace Ω] [PseudoMetricSpace α]
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

/-- Depth-zero degeneration: the terminal net is the singleton root at scale
`dyadicRadius R 0 = R`, and the same consumer still returns the truncated
integral bound. -/
theorem exists_terminal_net_dudley_bound_depth_zero {Ω α : Type*}
    [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ} {K : Set α} {t₀ : α} {R σ : ℝ}
    (hK : TotallyBounded K) (ht₀ : t₀ ∈ K) (hR : 0 < R)
    (hdist : ∀ t ∈ K, dist t t₀ ≤ R)
    (hXMeas : ∀ t, Measurable (X t))
    (hX : HasSubGaussianMGFIncrements P X σ) (hσ : 0 < σ) :
    ∃ T : Finset α, ∃ hT : T.Nonempty,
      (T : Set α) ⊆ K ∧
      IsInternalEpsilonNet K (T : Set α) (dyadicRadius R 0) ∧
      expect P (fun ω => T.sup' hT (fun t => |X t ω - X t₀ ω|)) ≤
        4 * σ * (∫ t in dyadicRadius R 1..R,
          Real.sqrt (2 * Real.log (2 * ((coveringNumber K t).toNat : ℝ)))) :=
  exists_terminal_net_expect_sup'_abs_sub_le_truncatedEntropyIntegral
    0 hK ht₀ hR hdist hXMeas hX hσ

end

end HighDimProb.Examples.DudleyUsage
