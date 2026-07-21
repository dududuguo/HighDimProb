import HighDimProb.GaussianFunctional.AffineStability

open HighDimProb
open MeasureTheory ProbabilityTheory
open scoped NNReal

#check @HighDimProb.gaussianReal_prod_map_add_linear
#check @HighDimProb.gaussianReal_prod_map_add_linear_of_sq_add_sq_eq_one
#check @HighDimProb.integral_gaussianReal_prod_add_linear
#check @HighDimProb.gaussianReal_prod_map_ouLinear

/-- External-user view: for `a² + b² = 1`, the linear combination of the two
independent standard Gaussian coordinates is again standard Gaussian; in
particular the OU/Mehler combination at any `t ≥ 0` is standard Gaussian. -/
example (a b : ℝ) (h : a ^ 2 + b ^ 2 = 1) {t : ℝ} (ht : 0 ≤ t) :
    (((gaussianReal 0 1).prod (gaussianReal 0 1)).map
        (fun z : ℝ × ℝ => a * z.1 + b * z.2) = gaussianReal 0 1) ∧
    (((gaussianReal 0 1).prod (gaussianReal 0 1)).map
        (fun z : ℝ × ℝ => Real.exp (-t) * z.1 +
          Real.sqrt (1 - Real.exp (-2 * t)) * z.2) = gaussianReal 0 1) :=
  ⟨gaussianReal_prod_map_add_linear_of_sq_add_sq_eq_one a b h,
    gaussianReal_prod_map_ouLinear ht⟩

/-- External-user view: integral transport for a bounded-support-free measurable
integrable real test function, with the composed integrand proved integrable. -/
example {f : ℝ → ℝ} (a b : ℝ) (hfm : Measurable f)
    (hfi : Integrable f
      (gaussianReal 0 ⟨a ^ 2 + b ^ 2, add_nonneg (sq_nonneg a) (sq_nonneg b)⟩)) :
    Integrable (fun z : ℝ × ℝ => f (a * z.1 + b * z.2))
        ((gaussianReal 0 1).prod (gaussianReal 0 1)) ∧
      ∫ z, f (a * z.1 + b * z.2) ∂((gaussianReal 0 1).prod (gaussianReal 0 1)) =
        ∫ u, f u ∂(gaussianReal 0 ⟨a ^ 2 + b ^ 2,
          add_nonneg (sq_nonneg a) (sq_nonneg b)⟩) :=
  integral_gaussianReal_prod_add_linear a b hfm hfi
