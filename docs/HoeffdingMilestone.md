# Hoeffding Milestone

## Summary

HighDimProb now proves a finite classical Hoeffding inequality for independent
bounded real variables. The branch contains the Rademacher atom, weighted
Rademacher sums, independent finite subGaussian sum infrastructure, centered
bounded Hoeffding theorems with both conservative and sharp constants, and the
non-centered classical/Wikipedia finite Hoeffding form around `E[sum_i X_i]`.

Stage H8 extends the milestone with the deterministic weighted bounded-variable
Hoeffding theorem family.

Stage SC-closeout incorporates this Hoeffding milestone into the broader scalar
concentration theorem-family closeout in `docs/ScalarConcentrationMilestone.md`.
Stage B3 extends the Bernstein branch with deterministic weighted
subExponential sums, and Stage SC-final records the final scalar concentration
branch closure; the Hoeffding theorem meanings and constants are unchanged.

## Theorem family

### Rademacher atom

- `centeredSubGaussianMGF_rademacher`
- `subGaussianTail_rademacher`

### Weighted Rademacher sum

- `centeredSubGaussianMGF_weightedRademacherSum`
- `subGaussianTail_weightedRademacherSum`
- `hoeffding_rademacher_sum`
- `hoeffding_rademacher_sum_of_pos_variance`

### Independent subGaussian sums

- `hasSubgaussianMGF_finset_sum_of_iIndepFun`
- `centeredSubGaussianMGF_finset_sum_of_iIndepFun_of_pos`
- `centeredSubGaussianMGF_sum_of_iIndepFun_of_pos`
- `subGaussianTail_finset_sum_of_iIndepFun_of_pos`
- `subGaussianTail_sum_of_iIndepFun_of_pos`
- `hasSubgaussianMGF_finset_weighted_sum_of_iIndepFun`
- `centeredSubGaussianMGF_finset_weighted_sum_of_iIndepFun_of_pos`
- `centeredSubGaussianMGF_weighted_sum_of_iIndepFun_of_pos`
- `subGaussianTail_finset_weighted_sum_of_iIndepFun_of_pos`
- `subGaussianTail_weighted_sum_of_iIndepFun_of_pos`

### Centered bounded Hoeffding

- `centeredSubGaussianMGF_of_ae_mem_Icc_of_centered`
- `centeredSubGaussianMGF_of_forall_mem_Icc_of_centered`
- `centeredSubGaussianMGF_sum_of_iIndepFun_bounded_centered`
- `subGaussianTail_sum_of_iIndepFun_bounded_centered`
- `hoeffding_sum_bounded_centered`
- `upperTailProb_le_exp_neg_two_mul_sq_div_of_mgf_eighth`
- `lowerTailProb_le_exp_neg_two_mul_sq_div_of_mgf_eighth`
- `absTailProb_le_two_mul_exp_neg_two_mul_sq_div_of_mgf_eighth`
- `hoeffding_sum_bounded_centered_sharp`

### Non-centered classical Hoeffding

- `expect_finset_sum`
- `iIndepFun_centered_of_iIndepFun`
- `ae_mem_Icc_centered_of_ae_mem_Icc`
- `sum_centered_eq_sum_sub_expect_sum`
- `hoeffding_sum_bounded`

### Weighted bounded Hoeffding

- `sum_weighted_centered_eq_weighted_sum_sub_expect_weighted_sum`
- `hoeffding_weighted_sum_bounded_centered_sharp`
- `hoeffding_weighted_sum_bounded`

## Constants table

Let `V = sum_i (b_i-a_i)^2`.

| Theorem | Bound type | Constant/exponent | Status | Notes |
|---|---|---|---|---|
| `hoeffding_sum_bounded_centered` | two-sided centered | `2 exp(-t^2 / V)` | proven | conservative |
| `hoeffding_sum_bounded_centered_sharp` | two-sided centered | `2 exp(-2t^2 / V)` | proven | sharp |
| `hoeffding_sum_bounded` | two-sided non-centered | `2 exp(-2t^2 / V)` | proven | classical/Wikipedia form |

For weighted theorems, let `V_c = sum_i c_i^2 * (b_i-a_i)^2`.

| Theorem | Bound type | Constant/exponent | Status | Notes |
|---|---|---|---|---|
| `hoeffding_weighted_sum_bounded_centered_sharp` | two-sided centered weighted | `2 exp(-2t^2 / V_c)` | proven | arbitrary real weights |
| `hoeffding_weighted_sum_bounded` | two-sided non-centered weighted | `2 exp(-2t^2 / V_c)` | proven | classical weighted form |

## Assumptions

- Independent finite family via `ProbabilityTheory.iIndepFun`.
- Bounded intervals `[a_i,b_i]`, stated as a.e. membership in
  `Set.Icc (a i) (b i)` for the main bounded-variable theorems.
- Integrability assumptions for the non-centered form, used to identify
  `E[sum_i X_i]` with `sum_i E[X_i]`.
- Positive denominator assumptions, such as `0 < sum_i (b_i-a_i)^2` or the
  weighted assumption `0 < sum_i c_i^2 * (b_i-a_i)^2`, because the current MGF
  and tail predicates require positive total scales.
- Centeredness assumptions for centered forms, stated as `Centered P (X i)`.

## Negative weights

Stage H8 handles arbitrary real deterministic weights, including negative and
zero weights, by using the existing weighted finite-sum MGF theorem. The MGF
proxy uses `(c_i * ((b_i-a_i)/2))^2`, so the final denominator normalizes to
`c_i^2 * (b_i-a_i)^2`. This avoids a reduction that would force every
transformed interval `[min(c_i a_i, c_i b_i), max(c_i a_i, c_i b_i)]` to have
positive width, which would fail for zero weights.

## Why conservative theorem remains

- It is correct.
- It follows the generic subGaussian pipeline.
- It is useful for testing generic implication infrastructure.
- The sharp theorem uses a dedicated Hoeffding-specific Chernoff optimization.

## Remaining work

- Zero-width/degenerate interval cleanup.
- One-sided classical forms.
- General bounded variable wrappers if needed.
- Sharper integration with theorem atlas.
