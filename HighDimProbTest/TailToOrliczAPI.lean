import HighDimProb.Concentration.TailToOrlicz

open HighDimProb
open MeasureTheory

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

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable (X : RealRandomVariable Omega)
variable (K : Real)

#check (psi2BoundOfSubGaussianTailStatement P X K : Prop)
#check (psi1BoundOfSubExponentialTailStatement P X K : Prop)

#check fun (hX : IsRealRandomVariable P X) (hTail : SubGaussianTail P X K) =>
  psi2Bound_of_subGaussianTail (P := P) (X := X) (K := K) hX hTail

#check fun (hX : IsRealRandomVariable P X) (hTail : SubExponentialTail P X K) =>
  psi1Bound_of_subExponentialTail (P := P) (X := X) (K := K) hX hTail
