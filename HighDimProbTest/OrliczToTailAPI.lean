import HighDimProb.Concentration

open HighDimProb
open MeasureTheory

#check lintegral_exp_sq_div_le_two_of_psi2Bound
#check lintegral_exp_abs_div_le_two_of_psi1Bound
#check subGaussianTail_of_psi2Bound
#check subExponentialTail_of_psi1Bound

variable {Ω : Type*} [MeasurableSpace Ω]
variable {P : Measure Ω} [IsProbabilityMeasure P]
variable {X : RealRandomVariable Ω} {K : ℝ}

#check fun (hψ : Psi2Bound P X K) =>
  lintegral_exp_sq_div_le_two_of_psi2Bound (P := P) (X := X) (K := K) hψ

#check fun (hψ : Psi1Bound P X K) =>
  lintegral_exp_abs_div_le_two_of_psi1Bound (P := P) (X := X) (K := K) hψ

#check fun (hX : IsRealRandomVariable P X) (hψ : Psi2Bound P X K) =>
  subGaussianTail_of_psi2Bound (P := P) (X := X) (K := K) hX hψ

#check fun (hX : IsRealRandomVariable P X) (hψ : Psi1Bound P X K) =>
  subExponentialTail_of_psi1Bound (P := P) (X := X) (K := K) hX hψ
