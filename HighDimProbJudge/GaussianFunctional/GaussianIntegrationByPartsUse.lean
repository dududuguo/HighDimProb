import HighDimProb.GaussianFunctional.IntegrationByParts

open HighDimProb
open MeasureTheory

#check HighDimProb.hasDerivAt_gaussianPDFReal_zero_one
#check HighDimProb.continuous_gaussianPDFReal_zero_one
#check HighDimProb.integrable_deriv_of_gaussianReal_zero_one
#check HighDimProb.integrable_id_mul_of_gaussianReal_zero_one
#check HighDimProb.integral_id_mul_eq_integral_deriv_of_gaussianReal_zero_one

/-- External-user view: for a compactly supported `C^1` test function, the
standard Gaussian measure satisfies the Stein integration-by-parts identity
`∫ x, x * f x ∂γ = ∫ x, deriv f x ∂γ`, and both sides are integrable. -/
example {f : ℝ → ℝ} (hf : ContDiff ℝ 1 f) (hfc : HasCompactSupport f) :
    (∫ x, x * f x ∂(ProbabilityTheory.gaussianReal 0 1) =
      ∫ x, deriv f x ∂(ProbabilityTheory.gaussianReal 0 1)) ∧
    Integrable (fun x => x * f x) (ProbabilityTheory.gaussianReal 0 1) ∧
    Integrable (deriv f) (ProbabilityTheory.gaussianReal 0 1) :=
  ⟨integral_id_mul_eq_integral_deriv_of_gaussianReal_zero_one hf hfc,
    integrable_id_mul_of_gaussianReal_zero_one hf hfc,
    integrable_deriv_of_gaussianReal_zero_one hf hfc⟩
