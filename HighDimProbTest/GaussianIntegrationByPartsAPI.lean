import HighDimProb.GaussianFunctional.IntegrationByParts

open HighDimProb
open MeasureTheory

#check @HighDimProb.hasDerivAt_gaussianPDFReal_zero_one
#check @HighDimProb.continuous_gaussianPDFReal_zero_one
#check @HighDimProb.hasCompactSupport_deriv_of_hasCompactSupport
#check @HighDimProb.integrable_deriv_of_gaussianReal_zero_one
#check @HighDimProb.integrable_id_mul_of_gaussianReal_zero_one
#check @HighDimProb.integral_id_mul_eq_integral_deriv_of_gaussianReal_zero_one

/-- The Stein identity applies to any compactly supported `C^1` test function,
and both sides are separately integrable. -/
example {f : ℝ → ℝ} (hf : ContDiff ℝ 1 f) (hfc : HasCompactSupport f) :
    (∫ x, x * f x ∂(ProbabilityTheory.gaussianReal 0 1) =
      ∫ x, deriv f x ∂(ProbabilityTheory.gaussianReal 0 1)) ∧
    Integrable (fun x => x * f x) (ProbabilityTheory.gaussianReal 0 1) ∧
    Integrable (deriv f) (ProbabilityTheory.gaussianReal 0 1) :=
  ⟨HighDimProb.integral_id_mul_eq_integral_deriv_of_gaussianReal_zero_one hf hfc,
    HighDimProb.integrable_id_mul_of_gaussianReal_zero_one hf hfc,
    HighDimProb.integrable_deriv_of_gaussianReal_zero_one hf hfc⟩
