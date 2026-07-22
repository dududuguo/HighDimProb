import HighDimProb.Concentration.DudleyFull

/-!
# Dudley usage examples

This file records both public layers: the finite terminal-net consumer with a
truncated entropy integral, and the full consumer for the measurable,
integrable supremum over the actual index set.
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

/-- External call of the full Dudley consumer, expanded to the actual set supremum. -/
theorem dudley_full_supremum_usage {Ω α : Type*}
    [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ}
    {K : Set α} {t₀ : α} {R σ : ℝ}
    (hK : TotallyBounded K) (ht₀ : t₀ ∈ K) (hR : 0 < R)
    (hdist : ∀ t ∈ K, dist t t₀ ≤ R)
    (hXMeas : ∀ t, Measurable (X t))
    (hX : HasSubGaussianMGFIncrements P X σ) (hσ : 0 < σ)
    (hPath : HasUniformlyContinuousSamplePathsOn
      (fun t ω => X t ω) K)
    (hEntropy : IntervalIntegrable (dudleyEntropyIntegrand K) volume 0 R) :
    Measurable
        (fun ω => sSup (Set.image (fun t => |X t ω - X t₀ ω|) K)) ∧
      Integrable
          (fun ω => sSup (Set.image (fun t => |X t ω - X t₀ ω|) K)) P ∧
        expect P (fun ω => sSup (Set.image (fun t => |X t ω - X t₀ ω|) K)) ≤
          4 * σ * dudleyEntropyIntegral K R := by
  simpa only [dudleySupremum] using
    (dudley_full_supremum_bound (P := P) (X := X) (K := K)
      (t0 := t₀) (R := R) (sigma := σ)
      hK ht₀ hR hdist hXMeas hX hσ hPath hEntropy)
end HighDimProb.Examples.DudleyUsage
