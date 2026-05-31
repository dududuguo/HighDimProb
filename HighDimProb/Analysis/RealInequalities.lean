import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Tactic

/-!
# Real inequalities for moment growth

This file contains small deterministic real-analysis helpers used by the
concentration moment layer.  It deliberately avoids probability assumptions.
-/

namespace HighDimProb

/-- A convenient elementary bound used to dominate powers by Gaussian tails. -/
lemma log_le_sq_of_nonneg {y : ℝ} (hy : 0 ≤ y) :
    Real.log y ≤ y ^ 2 := by
  by_cases hy0 : y = 0
  · simp [hy0]
  · have hpos : 0 < y := lt_of_le_of_ne hy (Ne.symm hy0)
    by_cases hle : y ≤ 1
    · have hlog_nonpos : Real.log y ≤ 0 := by
        rw [← Real.exp_le_exp, Real.exp_log hpos, Real.exp_zero]
        exact hle
      exact hlog_nonpos.trans (sq_nonneg y)
    · have hge : 1 ≤ y := le_of_lt (lt_of_not_ge hle)
      have hysq : y ≤ y ^ 2 := by
        have hmul : y * 1 ≤ y * y := mul_le_mul_of_nonneg_left hge hy
        simpa [pow_two] using hmul
      exact (Real.log_le_self hy).trans hysq

/-- Powers are dominated by a Gaussian exponential envelope. -/
lemma pow_le_exp_nat_mul_sq {y : ℝ} (hy : 0 ≤ y) (q : ℕ) :
    y ^ q ≤ Real.exp ((q : ℝ) * y ^ 2) := by
  by_cases hy0 : y = 0
  · subst y
    cases q with
    | zero => simp
    | succ q => simp
  · have hpos : 0 < y := lt_of_le_of_ne hy (Ne.symm hy0)
    have hlog : Real.log (y ^ q) ≤ (q : ℝ) * y ^ 2 := by
      rw [Real.log_pow]
      exact mul_le_mul_of_nonneg_left (log_le_sq_of_nonneg hy) (Nat.cast_nonneg q)
    rwa [Real.log_le_iff_le_exp (pow_pos hpos q)] at hlog

/--
Deterministic sharp-growth envelope for natural powers.

The constant `2` is the main helper; a constant-`4` compatibility wrapper is
provided below for theorem statements that use a looser envelope.
-/
theorem pow_le_two_sqrt_mul_exp_sq {x : ℝ} (hx : 0 ≤ x)
    {q : ℕ} (hq : 1 ≤ q) :
    x ^ q ≤ (2 * Real.sqrt (q : ℝ)) ^ q * Real.exp (x ^ 2 / 4) := by
  have hqposNat : 0 < q := lt_of_lt_of_le Nat.zero_lt_one hq
  have hqpos : 0 < (q : ℝ) := by exact_mod_cast hqposNat
  have hdenpos : 0 < 2 * Real.sqrt (q : ℝ) := by positivity
  have hy_nonneg : 0 ≤ x / (2 * Real.sqrt (q : ℝ)) :=
    div_nonneg hx hdenpos.le
  have hcore := pow_le_exp_nat_mul_sq hy_nonneg q
  have harg :
      (q : ℝ) * (x / (2 * Real.sqrt (q : ℝ))) ^ 2 = x ^ 2 / 4 := by
    field_simp [hdenpos.ne', hqpos.ne']
    rw [Real.sq_sqrt hqpos.le]
    ring
  calc
    x ^ q = (2 * Real.sqrt (q : ℝ) * (x / (2 * Real.sqrt (q : ℝ)))) ^ q := by
      field_simp [hdenpos.ne']
    _ = (2 * Real.sqrt (q : ℝ)) ^ q *
          (x / (2 * Real.sqrt (q : ℝ))) ^ q := by
      rw [mul_pow]
    _ ≤ (2 * Real.sqrt (q : ℝ)) ^ q *
          Real.exp ((q : ℝ) * (x / (2 * Real.sqrt (q : ℝ))) ^ 2) := by
      exact mul_le_mul_of_nonneg_left hcore (pow_nonneg hdenpos.le q)
    _ = (2 * Real.sqrt (q : ℝ)) ^ q * Real.exp (x ^ 2 / 4) := by
      rw [harg]

/-- Scaled version of `pow_le_two_sqrt_mul_exp_sq`. -/
theorem pow_le_two_mul_scale_sqrt_mul_exp_sq_div_four
    {x K : ℝ} (hx : 0 ≤ x) (hK : 0 < K) {q : ℕ} (hq : 1 ≤ q) :
    x ^ q ≤ (2 * K * Real.sqrt (q : ℝ)) ^ q *
      Real.exp ((x / K) ^ 2 / 4) := by
  have hdiv_nonneg : 0 ≤ x / K := div_nonneg hx hK.le
  have h := pow_le_two_sqrt_mul_exp_sq (x := x / K) hdiv_nonneg (q := q) hq
  have hKpow_nonneg : 0 ≤ K ^ q := pow_nonneg hK.le q
  have hmul := mul_le_mul_of_nonneg_left h hKpow_nonneg
  calc
    x ^ q = K ^ q * (x / K) ^ q := by
      rw [div_pow]
      field_simp [pow_ne_zero q hK.ne']
    _ ≤ K ^ q * ((2 * Real.sqrt (q : ℝ)) ^ q *
          Real.exp ((x / K) ^ 2 / 4)) := hmul
    _ = (2 * K * Real.sqrt (q : ℝ)) ^ q *
          Real.exp ((x / K) ^ 2 / 4) := by
      rw [mul_pow]
      ring

/-- A looser scaled envelope with the full exponential-square term. -/
theorem pow_le_two_mul_scale_sqrt_mul_exp_sq_div
    {x K : ℝ} (hx : 0 ≤ x) (hK : 0 < K) {q : ℕ} (hq : 1 ≤ q) :
    x ^ q ≤ (2 * K * Real.sqrt (q : ℝ)) ^ q *
      Real.exp ((x / K) ^ 2) := by
  have hbase_nonneg : 0 ≤ (2 * K * Real.sqrt (q : ℝ)) ^ q := by positivity
  have hsq_nonneg : 0 ≤ (x / K) ^ 2 := sq_nonneg (x / K)
  have hquarter_le : (x / K) ^ 2 / 4 ≤ (x / K) ^ 2 := by nlinarith
  exact (pow_le_two_mul_scale_sqrt_mul_exp_sq_div_four hx hK hq).trans
    (mul_le_mul_of_nonneg_left (Real.exp_le_exp_of_le hquarter_le) hbase_nonneg)

private lemma two_le_two_pow_succ (n : ℕ) :
    (2 : ℝ) ≤ 2 ^ (n + 1) := by
  induction n with
  | zero => norm_num
  | succ n ih =>
      have hpow_nonneg : 0 ≤ (2 : ℝ) ^ (n + 1) := by positivity
      calc
        (2 : ℝ) ≤ 2 ^ (n + 1) := ih
        _ ≤ 2 ^ (n + 1) * 2 := by nlinarith
        _ = 2 ^ (Nat.succ n + 1) := by
          rw [show Nat.succ n + 1 = Nat.succ (n + 1) by omega]
          exact (pow_succ (2 : ℝ) (n + 1)).symm

private lemma two_le_two_pow (q : ℕ) (hq : 1 ≤ q) :
    (2 : ℝ) ≤ 2 ^ q := by
  cases q with
  | zero => cases hq
  | succ n =>
      simpa [Nat.succ_eq_add_one] using two_le_two_pow_succ n

/-- Absorb a leading factor `2` by doubling the base of a nonzero natural power. -/
lemma two_mul_pow_le_two_mul_pow {a : ℝ} (ha : 0 ≤ a)
    {q : ℕ} (hq : 1 ≤ q) :
    2 * a ^ q ≤ (2 * a) ^ q := by
  calc
    2 * a ^ q ≤ 2 ^ q * a ^ q := by
      exact mul_le_mul_of_nonneg_right (two_le_two_pow q hq) (pow_nonneg ha q)
    _ = (2 * a) ^ q := by
      rw [mul_pow]

/-- Constant-`4` compatibility wrapper for the deterministic envelope. -/
theorem pow_le_four_sqrt_mul_exp_sq {x : ℝ} (hx : 0 ≤ x)
    {q : ℕ} (hq : 1 ≤ q) :
    x ^ q ≤ (4 * Real.sqrt (q : ℝ)) ^ q * Real.exp (x ^ 2 / 4) := by
  have h := pow_le_two_sqrt_mul_exp_sq (x := x) hx (q := q) hq
  have hleft_nonneg : 0 ≤ (2 * Real.sqrt (q : ℝ)) ^ q := by positivity
  have hsqrt_nonneg : 0 ≤ Real.sqrt (q : ℝ) := Real.sqrt_nonneg _
  have hbase : 2 * Real.sqrt (q : ℝ) ≤ 4 * Real.sqrt (q : ℝ) := by
    nlinarith
  have hpow :
      (2 * Real.sqrt (q : ℝ)) ^ q ≤ (4 * Real.sqrt (q : ℝ)) ^ q := by
    exact pow_le_pow_left₀ (by positivity) hbase q
  exact h.trans
    (mul_le_mul_of_nonneg_right hpow (Real.exp_pos (x ^ 2 / 4)).le)

end HighDimProb
