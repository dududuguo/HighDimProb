import HighDimProb.RandomProcess
import HighDimProb.SubGaussian

open MeasureTheory
open scoped NNReal

namespace HighDimProb

/-- A process has sub-Gaussian MGF increments with scale `σ` when each increment
is controlled by the squared metric proxy `(σ * dist s t)^2`. -/
def HasSubGaussianMGFIncrements {Ω T : Type*} [MeasurableSpace Ω]
    [PseudoMetricSpace T] (P : Measure Ω) (X : RandomProcess Ω T ℝ) (σ : ℝ) : Prop :=
  ∀ s t, ProbabilityTheory.HasSubgaussianMGF (X s - X t)
    (⟨(σ * dist s t) ^ 2, sq_nonneg (σ * dist s t)⟩ : ℝ≥0) P

namespace HasSubGaussianMGFIncrements

/-- Enlarge a sub-Gaussian increment proxy to a positive radius bound. -/
theorem centeredSubGaussianMGF_of_dist_le
    {Ω T : Type*} [MeasurableSpace Ω] [PseudoMetricSpace T]
    {P : Measure Ω} {X : RandomProcess Ω T ℝ} {σ r : ℝ} {s t : T}
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hσ : 0 < σ) (hr : 0 < r) (h_dist : dist s t ≤ r) :
    CenteredSubGaussianMGF P (X s - X t) (σ * r) := by
  refine ⟨mul_pos hσ hr, hasSubgaussianMGF_mono ?_ (hX s t)⟩
  change (σ * dist s t) ^ 2 ≤ (σ * r) ^ 2
  exact (sq_le_sq₀ (by positivity) (by positivity)).mpr
    (mul_le_mul_of_nonneg_left h_dist (le_of_lt hσ))

end HasSubGaussianMGFIncrements

end HighDimProb
