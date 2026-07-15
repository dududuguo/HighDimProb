import HighDimProb.SubGaussianProcess
import HighDimProb.Concentration.SubGaussianMax

open MeasureTheory
open HighDimProb

#check HighDimProb.HasSubGaussianMGFIncrements
#check HighDimProb.HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le
#check HighDimProb.expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF
#check HighDimProb.expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF_of_card_le
#check HighDimProb.expect_abs_sub_chain_le_sum_of_level_sup_of_subGaussianMGFIncrements

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
