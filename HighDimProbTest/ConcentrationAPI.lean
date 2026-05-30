import HighDimProb.Concentration

open HighDimProb
open MeasureTheory

#check upperTailEvent_subset_of_le
#check lowerTailEvent_subset_of_le
#check absTailEvent_subset_of_le
#check expect_nonneg_of_nonneg
#check expect_nonneg_of_nonneg_integrable
#check lintegral_ofReal_eq_ofReal_expect
#check lintegral_ofReal_eq_ofReal_expect_ae_nonneg
#check markov_inequality_nonneg
#check markov_inequality
#check markov_inequality_ae_nonneg
#check lintegral_exp_sq_div_le_two_of_psi2Bound
#check lintegral_exp_abs_div_le_two_of_psi1Bound
#check subGaussianTail_of_psi2Bound
#check subExponentialTail_of_psi1Bound
#check lintegral_ofReal_eq_lintegral_tail
#check lintegral_half_exp_neg_three_quarters_le_one
#check lintegral_two_thirds_exp_neg_two_thirds_le_one
#check integral_quarter_exp_quarter
#check integral_third_exp_third
#check lintegral_exp_quarter_sub_one_le_of_exp_tail
#check lintegral_exp_third_sub_one_le_of_exp_tail
#check lintegral_exp_sq_div_four_sub_one_le_of_subGaussianTail
#check psi2Bound_of_subGaussianTail
#check lintegral_exp_abs_div_three_sub_one_le_of_subExponentialTail
#check psi1Bound_of_subExponentialTail
#check psi2BoundOfSubGaussianTailStatement
#check psi1BoundOfSubExponentialTailStatement
#check integrable_centered
#check chebyshev_inequality
#check chebyshev_inequality_prob
#check centered_centered
#check variance_nonneg
#check variance_centered_eq_variance

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsFiniteMeasure P]
variable (X : RealRandomVariable Omega)

#check fun (hX : IntegrableRealRandomVariable P X) (hX_nonneg : forall omega, 0 <= X omega) =>
  markov_inequality_nonneg X hX hX_nonneg

#check fun (hX : IntegrableRealRandomVariable P X) (hX_nonneg : forall omega, 0 <= X omega) =>
  markov_inequality X hX hX_nonneg

#check fun (hX : IntegrableRealRandomVariable P X)
    (hX_nonneg : Filter.Eventually (fun omega => 0 <= X omega) (ae P)) =>
  markov_inequality_ae_nonneg X hX hX_nonneg

#check fun (hX : MemLpRealRandomVariable P X 2) =>
  chebyshev_inequality X hX

variable [IsProbabilityMeasure P]

#check fun (hX : MemLpRealRandomVariable P X 2) =>
  chebyshev_inequality_prob X hX
