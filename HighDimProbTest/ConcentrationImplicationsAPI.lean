import HighDimProb.Concentration.Implications

open HighDimProb
open MeasureTheory

#check subGaussianTail_of_psi2Bound
#check psi2Bound_of_subGaussianTail
#check subExponentialTail_of_psi1Bound
#check psi1Bound_of_subExponentialTail
#check absMomentNat_le_of_psi1Bound
#check absMomentNat_le_of_subExponentialTail
#check realLpNorm_nat_le_linear_of_psi1Bound
#check realLpNorm_nat_le_linear_of_subExponentialTail
#check realLpNorm_le_linear_of_psi1Bound
#check realLpNorm_le_linear_of_subExponentialTail
#check subExponentialMoment_of_psi1Bound
#check subExponentialMoment_of_subExponentialTail
#check realLpNorm_nat_le_sqrt_of_psi2Bound
#check realLpNorm_nat_le_sqrt_of_subGaussianTail
#check subGaussianMomentNatSqrt_of_psi2Bound
#check subGaussianMomentNatSqrt_of_subGaussianTail
#check realLpNorm_le_sqrt_of_psi2Bound
#check realLpNorm_le_sqrt_of_subGaussianTail
#check subGaussianMoment_of_psi2Bound
#check subGaussianMoment_of_subGaussianTail
#check CenteredSubGaussianMGFLIntegral
#check centeredSubGaussianMGFLIntegral_of_centeredSubGaussianMGF
#check upperTailProb_le_exp_neg_sq_of_centeredSubGaussianMGF
#check lowerTailProb_le_exp_neg_sq_of_centeredSubGaussianMGF
#check subGaussianTail_of_centeredSubGaussianMGF
#check psi2Bound_of_centeredSubGaussianMGF
#check subGaussianMomentNatSqrt_of_centeredSubGaussianMGF
#check centeredSubGaussianMGF_sum_of_iIndepFun_of_pos
#check centeredSubGaussianMGF_weighted_sum_of_iIndepFun_of_pos
#check subGaussianTail_sum_of_iIndepFun_of_pos
#check subGaussianTail_weighted_sum_of_iIndepFun_of_pos
#check CenteredSubExponentialMGFLIntegral
#check centeredSubExponentialMGF_sum_mgf_bound_of_iIndepFun_maxScale
#check centeredSubExponentialMGFLIntegral_sum_mgf_bound_of_iIndepFun_maxScale
#check centeredSubExponentialMGFLIntegral_weighted_sum_mgf_bound_of_iIndepFun_maxScale
#check absTailProb_le_two_mul_exp_neg_sq_div_varianceProxy_of_centeredSubExponentialMGFLIntegral_sum
#check bernstein_sum_subExponential
#check bernstein_weighted_sum_subExponential
#check weightedRademacherSum
#check centeredSubGaussianMGF_weightedRademacherSum
#check subGaussianTail_weightedRademacherSum
#check hoeffding_rademacher_sum
#check hoeffding_rademacher_sum_of_pos_variance
#check centeredSubGaussianMGF_of_ae_mem_Icc_of_centered
#check centeredSubGaussianMGF_of_forall_mem_Icc_of_centered
#check centeredSubGaussianMGF_sum_of_iIndepFun_bounded_centered
#check subGaussianTail_sum_of_iIndepFun_bounded_centered
#check upperTailProb_le_exp_neg_two_mul_sq_div_of_mgf_eighth
#check lowerTailProb_le_exp_neg_two_mul_sq_div_of_mgf_eighth
#check absTailProb_le_two_mul_exp_neg_two_mul_sq_div_of_mgf_eighth
#check hoeffding_sum_bounded_centered
#check hoeffding_sum_bounded_centered_sharp
#check expect_finset_sum
#check iIndepFun_centered_of_iIndepFun
#check ae_mem_Icc_centered_of_ae_mem_Icc
#check sum_centered_eq_sum_sub_expect_sum
#check sum_weighted_centered_eq_weighted_sum_sub_expect_weighted_sum
#check hoeffding_sum_bounded
#check hoeffding_weighted_sum_bounded_centered_sharp
#check hoeffding_weighted_sum_bounded

variable {Ω : Type*} [MeasurableSpace Ω]
variable {P : Measure Ω} [IsProbabilityMeasure P]
variable {X : RealRandomVariable Ω} {K : ℝ}

#check fun (hX : IsRealRandomVariable P X) (hψ : Psi2Bound P X K) =>
  subGaussianTail_of_psi2Bound (P := P) (X := X) (K := K) hX hψ

#check fun (hX : IsRealRandomVariable P X) (hTail : SubGaussianTail P X K) =>
  psi2Bound_of_subGaussianTail (P := P) (X := X) (K := K) hX hTail

#check fun (hX : IsRealRandomVariable P X) (hψ : Psi1Bound P X K) =>
  subExponentialTail_of_psi1Bound (P := P) (X := X) (K := K) hX hψ

#check fun (hX : IsRealRandomVariable P X) (hTail : SubExponentialTail P X K) =>
  psi1Bound_of_subExponentialTail (P := P) (X := X) (K := K) hX hTail
