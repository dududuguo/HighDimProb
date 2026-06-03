# Source Validation Report

Produced before trusting OCR theorem statements: yes.

## Node C: Hoeffding Inequality

Purpose: validate exponent sign, constants, one-sided/two-sided factors, and assumptions across local OCR sources, Mathlib, and existing HighDimProb statements.

## Source Evidence

### High-Dimensional Probability

Source: `external/theory-roadmap/sources/High-Dimensional_Probability.md`

- Lines 1484-1488: Rademacher one-sided Hoeffding has independent Rademacher variables, deterministic weights, `t >= 0`, and exponent `-t^2 / (2 * ||a||_2^2)`.
- Lines 1552-1556: Rademacher two-sided bound adds factor `2` and keeps denominator `2 * ||a||_2^2`.
- Lines 1560-1564: bounded variables in intervals `[a_i, b_i]` satisfy a one-sided bound with exponent `-2*t^2 / sum_i (b_i - a_i)^2`.
- Lines 2001-2005: subGaussian Hoeffding gives two-sided factor `2` and an absolute constant `c` in the exponent denominator.

### Concentration Inequalities

Source: `external/theory-roadmap/sources/Concentration_inequalities.md`

- Lines 401-410: Hoeffding is derived from interval boundedness and the log-MGF bound `(lambda^2 * (b-a)^2) / 8`.
- Lines 416-423: for independent bounded variables, variance factor `v = sum_i (b_i-a_i)^2 / 4` gives two-sided probability bound `2 * exp(-t^2 / (2*v))`.
- Lines 449: bounded differences with `v = (1/4) * sum_i c_i^2` preserves the same Hoeffding-style tail.

### Mathematical Foundations of Infinite-Dimensional Statistical Models

Source: `external/theory-roadmap/sources/Mathematical_Foundations_of_Infinite-Dimensional_Statistical_Models.md`

- Lines 6808-6818: bounded differences with `sum_i c_i^2 <= c^2` gives MGF `exp(lambda^2*c^2/8)` and one-sided tails `exp(-2*t^2/c^2)`.
- Lines 6882-6886: for sums of independent bounded variables, the two-sided bound is `2 * exp(-2*t^2 / sum_i (b_i-a_i)^2)`.

### Mathlib

Source: `.lake/packages/mathlib/Mathlib/Probability/Moments/SubGaussian.lean`

- Lines 75-78: Mathlib explicitly lists Hoeffding's lemma for expectation-zero bounded variables.
- Lines 839-845: `hasSubgaussianMGF_of_mem_Icc_of_integral_eq_zero` gives a centered bounded variable a subGaussian MGF parameter `((b-a)/2)^2`.
- Lines 308-319 and 685-688: scalar multiplication preserves MGF control with squared scalar factor.
- Lines 321-347: Chernoff bridge gives one-sided upper tails with negative exponent.

### Existing HighDimProb

Sources:

- `HighDimProb/Concentration/RademacherSums.lean`
- `docs/TheoremAtlas.md`
- `docs/ScalarImplicationGraph.md`
- `docs/RademacherMilestone.md`

Validated facts:

- `centeredSubGaussianMGF_weightedRademacherSum` uses scale `sqrt(sum_i a_i^2)` under positive square-sum.
- `subGaussianTail_weightedRademacherSum` uses scale `2 * sqrt(sum_i a_i^2)` because of the existing MGF-to-tail bridge.
- `hoeffding_rademacher_sum` states the explicit two-sided denominator `4 * sum_i a_i^2`.
- Local docs state these constants follow the current bridge and are not claimed sharp.

## Constant and Assumption Check

| Variant | Assumptions | Bound shape | Verdict |
|---|---|---|---|
| HDP Rademacher one-sided | independent signs, deterministic weights, `t >= 0` | `exp(-t^2/(2*||a||_2^2))` | validated |
| HDP Rademacher two-sided | same, `t > 0` | `2*exp(-t^2/(2*||a||_2^2))` | validated |
| HDP bounded one-sided | independent, `X_i in [a_i,b_i]` | `exp(-2*t^2/sum_i(b_i-a_i)^2)` | validated |
| BLM bounded two-sided | independent bounded intervals | `2*exp(-t^2/(2*v))`, `v=sum_i(b_i-a_i)^2/4` | validated; algebraically same as `2*exp(-2*t^2/sum_i(b_i-a_i)^2)` |
| Mathlib bounded MGF | probability measure, AEMeasurable, `X in Icc a b` a.e., mean zero | parameter `((b-a)/2)^2` | validated |
| HighDimProb Rademacher specialization | independent finite product signs, positive square-sum | `2*exp(-t^2/(4*sum_i a_i^2))` | validated as existing bridge constant, not source-sharp |

## OCR/KG Verdict

Verdict: validated.

No KG correction is required for MVP-1 because the OCR sources agree on the negative exponent sign, bounded-variable denominator, and two-sided factor. The apparent difference between the sharp Rademacher source denominator `2 * sum_i a_i^2` and the current HighDimProb Rademacher denominator `4 * sum_i a_i^2` is already documented as a consequence of the existing MGF-to-tail bridge, not an OCR error.

General bounded-variable Hoeffding remains deferred and should not be formalized in MVP-1.

