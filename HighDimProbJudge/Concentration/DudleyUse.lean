import HighDimProb.Concentration

open HighDimProb
open MeasureTheory

#check HighDimProb.abs_sub_root_le_sum_level_sup_of_mem_terminal
#check HighDimProb.sup'_abs_sub_root_le_sum_level_sup
#check HighDimProb.expect_sup'_abs_sub_root_le_sum_level_sup
#check HighDimProb.expect_sup'_abs_sub_root_le_finiteEntropySum
#check HighDimProb.exists_terminal_net_expect_sup'_abs_sub_le_truncatedEntropyIntegral
#check HighDimProb.dudleySupremum
#check HighDimProb.dudley_full_supremum_bound

/-- External-user view: from a totally bounded index set, a root within radius
`R`, subGaussian increments, and measurability, obtain a finite internal
terminal net at the dyadic scale `dyadicRadius R L` whose expected
`|X t - X t₀|` supremum is bounded by the truncated covering-number entropy
integral. No paths, parent maps, nets, or covering-number facts are supplied. -/
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

/-- External-user view of the full Dudley bound on the actual set supremum. -/
example {Ω α : Type*} [MeasurableSpace Ω] [PseudoMetricSpace α]
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
