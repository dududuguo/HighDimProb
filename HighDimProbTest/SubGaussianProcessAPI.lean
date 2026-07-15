import HighDimProb.SubGaussianProcess

open MeasureTheory
open HighDimProb
open scoped NNReal

#check HighDimProb.HasSubGaussianMGFIncrements
#check HighDimProb.HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le

example {Ω T : Type*} [MeasurableSpace Ω] [PseudoMetricSpace T]
    {P : Measure Ω} {X : RandomProcess Ω T ℝ} {σ : ℝ} {s t : T}
    (hX : HasSubGaussianMGFIncrements P X σ) :
    ProbabilityTheory.HasSubgaussianMGF (X s - X t)
      (⟨(σ * dist s t) ^ 2, sq_nonneg (σ * dist s t)⟩ : ℝ≥0) P :=
  hX s t

example {T : Type*} [PseudoMetricSpace T] {σ : ℝ} (s : T) :
    (⟨(σ * dist s s) ^ 2, sq_nonneg (σ * dist s s)⟩ : ℝ≥0) = 0 := by
  simp

example {Ω T : Type*} [MeasurableSpace Ω] [PseudoMetricSpace T]
    {P : Measure Ω} {X : RandomProcess Ω T ℝ} {σ r : ℝ} {s t : T}
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hσ : 0 < σ) (hr : 0 < r) (h_dist : dist s t ≤ r) :
    CenteredSubGaussianMGF P (X s - X t) (σ * r) :=
  HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le
    hX hσ hr h_dist
