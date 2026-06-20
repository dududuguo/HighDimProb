# Bernstein Plan

Stage B1 starts the scalar Bernstein/subExponential concentration branch.
Stage B1-fix adds the finite max-scale/domain infrastructure needed before a
full scalar Bernstein min-form proof should be attempted. Stage B2 proves the
full scalar min-form theorem for finite independent sums under the proof-facing
lintegral subExponential MGF predicate. Stage SC-closeout records this theorem
inside the scalar concentration milestone without changing the Bernstein API.
Stage B3 proves the deterministic weighted scalar Bernstein theorem with
weighted variance and max-scale proxies.

## Predicate Audit

- `CenteredSubExponentialMGF P X K` is the existing raw expectation predicate:
  local domain `|lambda| <= 1 / K`, bound `E exp(lambda X) <= exp(K^2 lambda^2)`, and strict scale `0 < K`.
- This is suitable for expectation-level finite MGF products.
- It is not enough by itself for ENNReal tail proofs, because it does not bundle measurability, exponential integrability, or a lintegral bridge.
- Stage B1 therefore adds `CenteredSubExponentialMGFLIntegral` without replacing the existing predicate.

## Proved In Stage B1

- `centeredSubExponentialMGF_finset_sum_mgf_bound_of_iIndepFun`
- `centeredSubExponentialMGF_sum_mgf_bound_of_iIndepFun`
- `centeredSubExponentialMGF_finset_sum_of_iIndepFun_of_pos`
- `centeredSubExponentialMGF_sum_of_iIndepFun_of_pos`
- `upperTailProb_le_exp_neg_sq_of_centeredSubExponentialMGFLIntegral_of_le`
- `lowerTailProb_le_exp_neg_sq_of_centeredSubExponentialMGFLIntegral_of_le`
- `absTailProb_le_two_mul_exp_neg_sq_of_centeredSubExponentialMGFLIntegral_of_le`

The packaged finite-sum theorem uses the conservative scale
`sqrt (sum_i K_i^2)`, so its inherited lambda domain is
`1 / sqrt (sum_i K_i^2)`.

## Proved In Stage B1-fix

- `maxScale`
- `varianceProxy`
- `le_maxScale`
- `maxScale_nonneg`
- `maxScale_pos_of_exists_pos`
- `abs_le_inv_of_le_inv_maxScale`
- `varianceProxy_nonneg`
- `varianceProxy_pos_of_exists_pos`
- `sq_le_varianceProxy`
- `centeredSubExponentialMGF_of_centeredSubExponentialMGFLIntegral`
- `centeredSubExponentialMGF_sum_mgf_bound_of_iIndepFun_maxScale`
- `centeredSubExponentialMGFLIntegral_sum_mgf_bound_of_iIndepFun_maxScale`
- `upperTailProb_le_exp_neg_sq_div_varianceProxy_of_mgf_bound_of_le`
- `lowerTailProb_le_exp_neg_sq_div_varianceProxy_of_mgf_bound_of_le`
- `absTailProb_le_two_mul_exp_neg_sq_div_varianceProxy_of_mgf_bound_of_le`
- `absTailProb_le_two_mul_exp_neg_sq_div_varianceProxy_of_centeredSubExponentialMGFLIntegral_sum`

`maxScale K` is implemented as a real-valued coercion of
`Finset.univ.sup (fun i => Real.toNNReal (K i))`; this gives the empty finite
case a canonical zero value while exposing real-valued scale lemmas. The
intended subExponential use supplies positive scales, so no constants are
changed by this clipping convention.

`varianceProxy K` is exactly `sum_i K_i^2`.

## Proved In Stage B2

- `upperTailProb_le_exp_neg_linear_div_maxScale_of_mgf_bound_of_ge`
- `lowerTailProb_le_exp_neg_linear_div_maxScale_of_mgf_bound_of_ge`
- `absTailProb_le_two_mul_exp_neg_linear_div_maxScale_of_mgf_bound_of_ge`
- `upperTailProb_le_exp_neg_quarter_bernsteinRate_of_mgf_bound`
- `lowerTailProb_le_exp_neg_quarter_bernsteinRate_of_mgf_bound`
- `absTailProb_le_two_mul_exp_neg_quarter_bernsteinRate_of_mgf_bound`
- `upperTailProb_le_exp_neg_quarter_bernsteinRate_of_centeredSubExponentialMGFLIntegral_sum`
- `lowerTailProb_le_exp_neg_quarter_bernsteinRate_of_centeredSubExponentialMGFLIntegral_sum`
- `bernstein_sum_subExponential`

The large-deviation regime fixes `lambda = 1 / B` and uses
`2 * V / B <= t` to derive the one-sided exponent `exp (-(t / (2*B)))`.
The final min-form comparison uses the conservative constant `1/4`:
`exp (-(1/4 * min (t^2/V) (t/B)))`.

## Proved In Stage B3

- `weightedVarianceProxy`
- `weightedMaxScale`
- `weightedVarianceProxy_nonneg`
- `weightedMaxScale_nonneg`
- `le_weightedMaxScale`
- `abs_mul_le_inv_of_le_weightedMaxScale`
- `centeredSubExponentialMGF_const_mul_mgf_bound`
- `centeredSubExponentialMGFLIntegral_const_mul_mgf_bound`
- `centeredSubExponentialMGFLIntegral_weighted_sum_mgf_bound_of_iIndepFun_maxScale`
- `bernstein_weighted_sum_subExponential`

The weighted theorem uses
`V_c = weightedVarianceProxy c K = sum_i c_i^2 * K_i^2` and
`B_c = weightedMaxScale c K = max_i |c_i| * K_i`.  The assumptions
`0 < V_c` and `0 < B_c` are explicit.  Individual zero weights are allowed:
the scalar-multiple MGF helpers keep the domain as `|lambda * c_i| <= 1/K_i`
instead of packaging `c_i X_i` with a strictly positive scale.

## Statement-Only In Stage B1

- `centeredSubExponentialMGFLIntegral_sum_of_iIndepFun_statement`
- `bernstein_subExponential_sum_statement`
- `bernstein_subExponential_weighted_sum_statement`

These are typed `Prop` specifications, not proved theorem declarations. The
proved Stage B2 theorem is the lintegral-predicate finite-sum theorem
`bernstein_sum_subExponential`; Stage B3 also proves the concrete
lintegral-predicate deterministic weighted theorem
`bernstein_weighted_sum_subExponential`.

## Constants And Domains

- One-variable local Chernoff exponent: `exp (-(t^2 / (4*K^2)))`.
- One-variable local Chernoff domain: `0 <= t` and `t <= K`.
- Bernstein statement rate: `min (t^2 / varianceProxy) (t / maxScale)`.
- Proved scalar Bernstein min-form constant: `1/4`.
- Proved weighted scalar Bernstein min-form constant: `1/4`.
- Raw and weighted typed statement constant: explicit positive statement parameter
  `cBernstein`.
- Finite-sum raw MGF domain: `|lambda| <= 1 / Kmax`.
- Normalized finite-sum raw and lintegral MGF domain: `|lambda| <= 1 / maxScale K`.
- Normalized finite-sum raw and lintegral MGF exponent: `exp (varianceProxy K * lambda^2)`.
- Local quadratic Bernstein corollary domain: `0 <= t` and
  `t <= 2 * varianceProxy K / maxScale K`.
- Local quadratic Bernstein corollary exponent:
  `2 * exp (-(t^2 / (4 * varianceProxy K)))`.
- Large-regime Bernstein domain: `0 <= t` and
  `2 * varianceProxy K / maxScale K <= t`.
- Large-regime Bernstein exponent:
  `2 * exp (-(t / (2 * maxScale K)))`.
- Full scalar Bernstein min-form:
  `2 * exp (-(1/4 * subExponentialBernsteinRate t (varianceProxy K) (maxScale K)))`.
- Weighted scalar Bernstein min-form:
  `2 * exp (-(1/4 * subExponentialBernsteinRate t (weightedVarianceProxy c K) (weightedMaxScale c K)))`.

## Remaining Blockers

- The lintegral finite-sum MGF bridge and reusable max-scale vocabulary are now proved.
- A bridge from raw `CenteredSubExponentialMGF` to the lintegral predicate under usable assumptions remains future work; Stage B1-fix proves only the reverse direction from the stronger lintegral predicate to the raw predicate.
- Weighted max-scale and variance-proxy wrappers are proved and used by
  `bernstein_weighted_sum_subExponential`.
- Raw-predicate Bernstein theorem variants remain future work.

## Next Safe Task

This is a historical scalar Bernstein closeout note. Current active branch
selection is tracked in `docs/Status.md` and `docs/TODO.md`; remaining scalar
Bernstein work is the raw-predicate bridge, while matrix Bernstein and
Hanson-Wright remain separate theorem families.
