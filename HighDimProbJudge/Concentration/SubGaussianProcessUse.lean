import HighDimProb.SubGaussianProcess

open MeasureTheory
open HighDimProb

example {Ω T : Type*} [MeasurableSpace Ω] [PseudoMetricSpace T]
    {P : Measure Ω} {X : RandomProcess Ω T ℝ} {σ r : ℝ} {s t : T}
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hσ : 0 < σ) (hr : 0 < r) (h_dist : dist s t ≤ r) :
    CenteredSubGaussianMGF P (X s - X t) (σ * r) := by
  exact HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le
    hX hσ hr h_dist
