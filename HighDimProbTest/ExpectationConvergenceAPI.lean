import HighDimProb.Expectation

open HighDimProb
open MeasureTheory Filter
open scoped Topology

namespace HighDimProbTest

#check MeasureTheory.tendsto_integral_filter_of_dominated_convergence

example {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    {r : ℕ → RealRandomVariable Ω} {g : Ω → ℝ}
    (h_meas : ∀ n, AEStronglyMeasurable (r n) P)
    (h_bound : ∀ n, ∀ᵐ ω ∂P, ‖r n ω‖ ≤ g ω)
    (hg : IntegrableRealRandomVariable P g)
    (h_lim : ∀ᵐ ω ∂P, Tendsto (fun n => r n ω) atTop (𝓝 (0 : ℝ))) :
    Tendsto (fun n => expect P (r n)) atTop (𝓝 0) := by
  have h_integral :=
    MeasureTheory.tendsto_integral_filter_of_dominated_convergence
      g (Eventually.of_forall h_meas)
        (Eventually.of_forall h_bound) hg h_lim
  simpa using h_integral

end HighDimProbTest
