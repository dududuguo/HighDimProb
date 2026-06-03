import HighDimProb.Concentration.Implications

open HighDimProb
open MeasureTheory

#check subGaussianTail_of_psi2Bound
#check psi2Bound_of_subGaussianTail
#check subExponentialTail_of_psi1Bound
#check psi1Bound_of_subExponentialTail
#check realLpNorm_nat_le_sqrt_of_psi2Bound
#check realLpNorm_nat_le_sqrt_of_subGaussianTail
#check subGaussianMomentNatSqrt_of_psi2Bound
#check subGaussianMomentNatSqrt_of_subGaussianTail
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
#check weightedRademacherSum
#check centeredSubGaussianMGF_weightedRademacherSum
#check subGaussianTail_weightedRademacherSum
#check hoeffding_rademacher_sum
#check hoeffding_rademacher_sum_of_pos_variance
#check centeredSubGaussianMGF_of_ae_mem_Icc_of_centered
#check centeredSubGaussianMGF_of_forall_mem_Icc_of_centered
#check centeredSubGaussianMGF_sum_of_iIndepFun_bounded_centered
#check subGaussianTail_sum_of_iIndepFun_bounded_centered
#check hoeffding_sum_bounded_centered

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
