import HighDimProb.MetricEntropy

open Filter MeasureTheory
open HighDimProb
open scoped Interval Topology

#check HighDimProb.tendsto_intervalIntegral_of_leftEndpoint_tendsto
#check HighDimProb.tendsto_dyadicRadius_atTop
#check HighDimProb.tendsto_intervalIntegral_dyadicRadius_atTop

example {f : ℝ → ℝ} {R : ℝ} (hR : 0 ≤ R)
    (hf : IntervalIntegrable f volume 0 R) :
    Tendsto (fun L : Nat => ∫ t in dyadicRadius R (L + 1)..R, f t)
      atTop (𝓝 (∫ t in (0 : ℝ)..R, f t)) := by
  exact tendsto_intervalIntegral_dyadicRadius_atTop hR hf
