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

#check expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF

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

end

end HighDimProbTest
