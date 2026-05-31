import HighDimProb.Analysis.RealInequalities

open HighDimProb

#check log_le_sq_of_nonneg
#check pow_le_exp_nat_mul_sq
#check pow_le_two_sqrt_mul_exp_sq
#check pow_le_two_mul_scale_sqrt_mul_exp_sq_div_four
#check pow_le_two_mul_scale_sqrt_mul_exp_sq_div
#check two_mul_pow_le_two_mul_pow
#check pow_le_four_sqrt_mul_exp_sq

variable {x K : Real}
variable {q : Nat}

#check fun (hx : 0 <= x) (hq : 1 <= q) =>
  pow_le_two_sqrt_mul_exp_sq (x := x) (q := q) hx hq

#check fun (hx : 0 <= x) (hK : 0 < K) (hq : 1 <= q) =>
  pow_le_two_mul_scale_sqrt_mul_exp_sq_div
    (x := x) (K := K) (q := q) hx hK hq
