import HighDimProb.Scalar.Centering
import Mathlib.Probability.Moments.Variance

/-!
# Scalar variance and covariance

Thin HighDimProb aliases around Mathlib scalar variance, covariance, and second moments.
-/

namespace HighDimProb

open MeasureTheory
open scoped ProbabilityTheory

noncomputable section

/-- Variance of a real random variable, reusing Mathlib's definition. -/
abbrev variance {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) : ℝ :=
  ProbabilityTheory.variance X P

/-- Covariance of two real random variables, reusing Mathlib's definition. -/
abbrev covariance {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X Y : RealRandomVariable Ω) : ℝ :=
  ProbabilityTheory.covariance X Y P

/-- Uncentered second moment of two real random variables. -/
abbrev secondMoment {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X Y : RealRandomVariable Ω) : ℝ :=
  expect P (fun ω => X ω * Y ω)

@[simp]
theorem covariance_def {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X Y : RealRandomVariable Ω) :
    covariance P X Y = ProbabilityTheory.covariance X Y P :=
  rfl

@[simp]
theorem variance_def {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) :
    variance P X = ProbabilityTheory.variance X P :=
  rfl

@[simp]
theorem covariance_eq_integral {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X Y : RealRandomVariable Ω) :
    covariance P X Y = ∫ ω, (X ω - mean P X) * (Y ω - mean P Y) ∂P :=
  rfl

@[simp]
theorem secondMoment_def {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X Y : RealRandomVariable Ω) :
    secondMoment P X Y = expect P (fun ω => X ω * Y ω) :=
  rfl

end

end HighDimProb
