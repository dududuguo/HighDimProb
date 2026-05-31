import HighDimProb.Concentration.MomentImplications

open HighDimProb
open MeasureTheory
open scoped ENNReal

#check absMomentNat
#check finiteAbsMomentNat
#check SubGaussianMomentNat
#check SubGaussianMomentNatSqrt
#check lintegral_enorm_rpow_nat_eq_absMomentNat
#check memLp_of_finiteAbsMomentNat
#check memLp_one_of_finiteAbsMomentNat_one
#check memLp_two_of_finiteAbsMomentNat_two
#check realLpNorm_nat_le_of_absMomentNat_le_ennreal
#check realLpNorm_nat_le_of_absMomentNat_le
#check abs_pow_le_exp_sq_factorial
#check absMomentNat_two_le_of_psi2Bound
#check finiteAbsMomentNat_two_of_psi2Bound
#check absMomentNat_le_of_psi2Bound
#check finiteAbsMomentNat_of_psi2Bound
#check absMomentNat_le_sqrt_growth_of_psi2Bound
#check realLpNorm_nat_le_sqrt_of_psi2Bound
#check realLpNorm_nat_le_linear_of_psi2Bound
#check absMomentNat_two_le_of_subGaussianTail
#check finiteAbsMomentNat_two_of_subGaussianTail
#check absMomentNat_le_of_subGaussianTail
#check finiteAbsMomentNat_of_subGaussianTail
#check realLpNorm_nat_le_sqrt_of_subGaussianTail
#check realLpNorm_nat_le_linear_of_subGaussianTail
#check subGaussianMomentNat_of_psi2Bound
#check subGaussianMomentNat_of_subGaussianTail
#check subGaussianMomentNatSqrt_of_psi2Bound
#check subGaussianMomentNatSqrt_of_subGaussianTail
#check absMomentNat_one_le_of_psi1Bound
#check absMomentNat_one_le_of_subExponentialTail
#check subGaussianMomentNatOfSubGaussianTailStatement
#check powLeSqrtGrowthMulExpSqStatement
#check powLeSqrtGrowthMulExpSq
#check sqrtMomentGrowthOfPsi2Statement
#check sqrtMomentGrowthOfPsi2
#check sqrtMomentGrowthOfSubGaussianTailStatement
#check sqrtMomentGrowthOfSubGaussianTail

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable {X : RealRandomVariable Omega}
variable {K : Real}
variable {B : Real}
variable {q : Nat}

#check fun (hpsi : Psi2Bound P X K) =>
  absMomentNat_le_of_psi2Bound
    (P := P) (X := X) (K := K) hpsi q

#check fun (hpsi : Psi2Bound P X K) =>
  finiteAbsMomentNat_of_psi2Bound
    (P := P) (X := X) (K := K) hpsi q

#check fun (hpsi : Psi2Bound P X K) (hq : 1 ≤ q) =>
  realLpNorm_nat_le_sqrt_of_psi2Bound
    (P := P) (X := X) (K := K) (q := q) hpsi hq

#check fun (hpsi : Psi2Bound P X K) (hq : 1 ≤ q) =>
  realLpNorm_nat_le_linear_of_psi2Bound
    (P := P) (X := X) (K := K) (q := q) hpsi hq

#check fun (hq : q ≠ 0) (hX : IsRealRandomVariable P X)
    (hfin : finiteAbsMomentNat P X q) =>
  memLp_of_finiteAbsMomentNat
    (P := P) (X := X) (q := q) hq hX hfin

#check fun (hq : q ≠ 0) (hB : 0 ≤ B)
    (hbound : absMomentNat P X q ≤ ENNReal.ofReal B) =>
  realLpNorm_nat_le_of_absMomentNat_le
    (P := P) (X := X) (q := q) (B := B) hq hB hbound

#check fun (hpsi : Psi2Bound P X K) =>
  subGaussianMomentNat_of_psi2Bound
    (P := P) (X := X) (K := K) hpsi

#check fun (hpsi : Psi2Bound P X K) =>
  subGaussianMomentNatSqrt_of_psi2Bound
    (P := P) (X := X) (K := K) hpsi

#check fun (hX : IsRealRandomVariable P X) (hTail : SubGaussianTail P X K) =>
  absMomentNat_two_le_of_subGaussianTail
    (P := P) (X := X) (K := K) hX hTail

#check fun (hX : IsRealRandomVariable P X) (hTail : SubGaussianTail P X K) =>
  finiteAbsMomentNat_two_of_subGaussianTail
    (P := P) (X := X) (K := K) hX hTail

#check fun (hX : IsRealRandomVariable P X) (hTail : SubGaussianTail P X K) =>
  absMomentNat_le_of_subGaussianTail
    (P := P) (X := X) (K := K) hX hTail q

#check fun (hX : IsRealRandomVariable P X) (hTail : SubGaussianTail P X K) =>
  finiteAbsMomentNat_of_subGaussianTail
    (P := P) (X := X) (K := K) hX hTail q

#check fun (hX : IsRealRandomVariable P X) (hTail : SubGaussianTail P X K)
    (hq : 1 ≤ q) =>
  realLpNorm_nat_le_sqrt_of_subGaussianTail
    (P := P) (X := X) (K := K) (q := q) hX hTail hq

#check fun (hX : IsRealRandomVariable P X) (hTail : SubGaussianTail P X K)
    (hq : 1 ≤ q) =>
  realLpNorm_nat_le_linear_of_subGaussianTail
    (P := P) (X := X) (K := K) (q := q) hX hTail hq

#check fun (hX : IsRealRandomVariable P X) (hTail : SubGaussianTail P X K) =>
  subGaussianMomentNat_of_subGaussianTail
    (P := P) (X := X) (K := K) hX hTail

#check fun (hX : IsRealRandomVariable P X) (hTail : SubGaussianTail P X K) =>
  subGaussianMomentNatSqrt_of_subGaussianTail
    (P := P) (X := X) (K := K) hX hTail

#check fun (hX : IsRealRandomVariable P X) (hTail : SubExponentialTail P X K) =>
  absMomentNat_one_le_of_subExponentialTail
    (P := P) (X := X) (K := K) hX hTail
