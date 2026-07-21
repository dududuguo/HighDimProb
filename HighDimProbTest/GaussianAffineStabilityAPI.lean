import HighDimProb.GaussianFunctional.AffineStability

open HighDimProb
open MeasureTheory ProbabilityTheory
open scoped NNReal

#check @HighDimProb.indepFun_fst_snd_gaussianReal_prod
#check @HighDimProb.gaussianReal_prod_map_add_linear
#check @HighDimProb.gaussianReal_prod_map_add_linear_of_sq_add_sq_eq_one
#check @HighDimProb.gaussianReal_prod_map_add_linear_zero_zero
#check @HighDimProb.integrable_gaussianReal_prod_add_linear
#check @HighDimProb.integral_gaussianReal_prod_add_linear
#check @HighDimProb.ou_coeff_sq_add_sq_eq_one
#check @HighDimProb.gaussianReal_prod_map_ouLinear

/-- General linear combination on the Gaussian product space has the claimed
mean-zero variance-`a²+b²` Gaussian law. -/
example (a b : ℝ) :
    ((gaussianReal 0 1).prod (gaussianReal 0 1)).map
        (fun z : ℝ × ℝ => a * z.1 + b * z.2) =
      gaussianReal 0 ⟨a ^ 2 + b ^ 2, add_nonneg (sq_nonneg a) (sq_nonneg b)⟩ :=
  gaussianReal_prod_map_add_linear a b

/-- The OU/Mehler coefficients square to one, so the OU linear combination is
standard Gaussian. -/
example {t : ℝ} (ht : 0 ≤ t) :
    Real.exp (-t) ^ 2 + Real.sqrt (1 - Real.exp (-2 * t)) ^ 2 = 1 ∧
    ((gaussianReal 0 1).prod (gaussianReal 0 1)).map
        (fun z : ℝ × ℝ => Real.exp (-t) * z.1 +
          Real.sqrt (1 - Real.exp (-2 * t)) * z.2) = gaussianReal 0 1 :=
  ⟨ou_coeff_sq_add_sq_eq_one ht, gaussianReal_prod_map_ouLinear ht⟩
