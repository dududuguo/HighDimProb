import HighDimProb.Concentration.Basic
import HighDimProb.Scalar.Variance
import Mathlib.Probability.Moments.Variance

/-!
# Chebyshev inequality

HighDimProb-facing wrapper around Mathlib's variance-form Chebyshev inequality.
-/

namespace HighDimProb

open MeasureTheory
open scoped ProbabilityTheory

noncomputable section

/--
Chebyshev's inequality in HighDimProb notation.

This is a wrapper around `ProbabilityTheory.meas_ge_le_variance_div_sq`.
-/
theorem chebyshev_inequality {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsFiniteMeasure P] (X : RealRandomVariable Omega)
    (hX : MemLpRealRandomVariable P X 2) {t : Real} (ht : 0 < t) :
    absTailProb P (centered P X) t <= ENNReal.ofReal (variance P X / t ^ 2) := by
  change P {omega | t <= |X omega - mean P X|} <=
    ENNReal.ofReal (ProbabilityTheory.variance X P / t ^ 2)
  exact ProbabilityTheory.meas_ge_le_variance_div_sq (μ := P) (X := X) hX ht

/-- Probability-measure-facing wrapper for `chebyshev_inequality`. -/
theorem chebyshev_inequality_prob {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] (X : RealRandomVariable Omega)
    (hX : MemLpRealRandomVariable P X 2) {t : Real} (ht : 0 < t) :
    absTailProb P (centered P X) t <= ENNReal.ofReal (variance P X / t ^ 2) :=
  chebyshev_inequality X hX ht

end

end HighDimProb
