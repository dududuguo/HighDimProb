# Scalar Concentration Milestone

## Summary

Stage SC-final-update records the scalar concentration theorem family after the
Hoeffding, Bernstein, weighted Bernstein, and full real/`ENNReal` moment-bridge
rounds. No theorem meanings changed in this closeout.

The branch now has proved Markov/Chebyshev/union-bound basics, fixed-scale
Orlicz-to-tail and tail-to-Orlicz implications, natural and finite-`ENNReal`
subGaussian moment growth, natural and finite-`ENNReal` subExponential moment
growth, MGF-to-tail/Orlicz/moment links, Rademacher/Hoeffding theorem families,
subExponential finite-sum MGF infrastructure, local Bernstein tails, the full
scalar Bernstein min-form theorem, and the deterministic weighted scalar
Bernstein min-form theorem under the proof-facing lintegral subExponential MGF
predicate.

## Theorem Family Table

| Theorem name | Mathematical statement summary | Constants | Assumptions | Status | Source file | Test file |
|---|---|---|---|---|---|---|
| `markov_inequality` | Nonnegative integrable random variable has upper-tail probability bounded by expectation over threshold. | `E[X] / a` | `IntegrableRealRandomVariable`, pointwise `0 <= X`, `0 < a` | proven | `HighDimProb/Concentration/Markov.lean` | `HighDimProbTest/ConcentrationAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `chebyshev_inequality` | Centered absolute tail is bounded by variance over squared threshold. | `variance P X / t^2` | finite measure, `MemLpRealRandomVariable P X 2`, `0 < t` | proven | `HighDimProb/Concentration/Chebyshev.lean` | `HighDimProbTest/ConcentrationAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `subGaussianTail_of_psi2Bound` | psi2 Orlicz control implies subGaussian tail control. | matching scale `K` | probability measure, measurable `X`, `Psi2Bound P X K` | proven | `HighDimProb/Concentration/OrliczToTail.lean` | `HighDimProbTest/OrliczToTailAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `psi2Bound_of_subGaussianTail` | SubGaussian tail control implies psi2 Orlicz control. | scale loss `K -> 2*K` | probability measure, measurable `X`, `SubGaussianTail P X K` | proven | `HighDimProb/Concentration/TailToOrlicz.lean` | `HighDimProbTest/TailToOrliczAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `realLpNorm_nat_le_sqrt_of_psi2Bound` | psi2 control gives sharp natural-exponent real-Lp sqrt growth. | `4*K*sqrt(q)` | probability measure, `Psi2Bound P X K`, `1 <= q` | proven | `HighDimProb/Concentration/MomentImplications.lean` | `HighDimProbTest/MomentImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `realLpNorm_nat_le_sqrt_of_subGaussianTail` | SubGaussian tail control gives natural-exponent real-Lp sqrt growth. | `8*K*sqrt(q)` | probability measure, measurable `X`, `SubGaussianTail P X K`, `1 <= q` | proven | `HighDimProb/Concentration/MomentImplications.lean` | `HighDimProbTest/MomentImplicationsAPI.lean`, `HighDimProbTest/ConcentrationImplicationsAPI.lean` |
| `realLpNorm_le_sqrt_of_psi2Bound` | psi2 control gives finite-`ENNReal` real-Lp sqrt growth. | `8*K*sqrt(p.toReal)` | probability measure, measurable `X`, `Psi2Bound P X K`, `1 <= p`, `p != infinity` | proven | `HighDimProb/Concentration/MomentImplications.lean` | `HighDimProbTest/MomentImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `realLpNorm_le_sqrt_of_subGaussianTail` | SubGaussian tail control gives finite-`ENNReal` real-Lp sqrt growth. | `16*K*sqrt(p.toReal)` | probability measure, measurable `X`, `SubGaussianTail P X K`, `1 <= p`, `p != infinity` | proven | `HighDimProb/Concentration/MomentImplications.lean` | `HighDimProbTest/MomentImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `subGaussianMoment_of_psi2Bound` | psi2 control gives the full finite-`ENNReal` `SubGaussianMoment` interface. | scale `8*K` | probability measure, measurable `X`, `Psi2Bound P X K` | proven | `HighDimProb/Concentration/MomentImplications.lean` | `HighDimProbTest/MomentImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `subGaussianMoment_of_subGaussianTail` | SubGaussian tail control gives the full finite-`ENNReal` `SubGaussianMoment` interface. | scale `16*K` | probability measure, measurable `X`, `SubGaussianTail P X K` | proven | `HighDimProb/Concentration/MomentImplications.lean` | `HighDimProbTest/MomentImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `subGaussianTail_of_centeredSubGaussianMGF` | Centered subGaussian MGF control implies two-sided tail control. | tail scale `2*K` | measurable `X`, `CenteredSubGaussianMGF P X K` | proven | `HighDimProb/Concentration/MGF.lean` | `HighDimProbTest/MGFImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `hoeffding_sum_bounded_centered` | Independent bounded centered sum satisfies a conservative two-sided Hoeffding bound. | `2*exp(-t^2/V)` | independent finite family, centered, a.e. bounded intervals, positive proxy | proven conservative | `HighDimProb/Concentration/Hoeffding.lean` | `HighDimProbTest/HoeffdingAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `hoeffding_sum_bounded_centered_sharp` | Independent bounded centered sum satisfies the sharp classical two-sided Hoeffding bound. | `2*exp(-2*t^2/V)` | independent finite family, centered, a.e. bounded intervals, positive denominator | proven sharp | `HighDimProb/Concentration/Hoeffding.lean` | `HighDimProbTest/HoeffdingAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `hoeffding_sum_bounded` | Independent bounded non-centered sum has the sharp classical bound around its expectation. | `2*exp(-2*t^2/V)` | independent finite family, integrable, a.e. bounded intervals, positive denominator | proven sharp | `HighDimProb/Concentration/Hoeffding.lean` | `HighDimProbTest/HoeffdingAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `hoeffding_weighted_sum_bounded` | Deterministic weighted bounded sum has the sharp classical bound around its expectation. | `2*exp(-2*t^2/V_c)` | independent finite family, integrable, a.e. bounded intervals, arbitrary real weights, positive weighted denominator | proven sharp | `HighDimProb/Concentration/Hoeffding.lean` | `HighDimProbTest/HoeffdingAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `subExponentialTail_of_psi1Bound` | psi1 Orlicz control implies subExponential tail control. | matching scale `K` | probability measure, measurable `X`, `Psi1Bound P X K` | proven | `HighDimProb/Concentration/OrliczToTail.lean` | `HighDimProbTest/OrliczToTailAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `psi1Bound_of_subExponentialTail` | SubExponential tail control implies psi1 Orlicz control. | scale loss `K -> 3*K` | probability measure, measurable `X`, `SubExponentialTail P X K` | proven | `HighDimProb/Concentration/TailToOrlicz.lean` | `HighDimProbTest/TailToOrliczAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `absMomentNat_le_of_psi1Bound` | psi1 Orlicz control gives all natural absolute moments with factorial growth. | `2*K^q*q!` | probability measure, `Psi1Bound P X K`, natural `q` | proven | `HighDimProb/Concentration/MomentImplications.lean` | `HighDimProbTest/MomentImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `absMomentNat_le_of_subExponentialTail` | SubExponential tail control gives all natural absolute moments with factorial growth. | `2*(3*K)^q*q!` | probability measure, measurable `X`, `SubExponentialTail P X K`, natural `q` | proven | `HighDimProb/Concentration/MomentImplications.lean` | `HighDimProbTest/MomentImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `realLpNorm_nat_le_linear_of_psi1Bound` | psi1 Orlicz control gives natural real-Lp linear growth. | `8*K*q` | probability measure, `Psi1Bound P X K`, `1 <= q` | proven | `HighDimProb/Concentration/MomentImplications.lean` | `HighDimProbTest/MomentImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `realLpNorm_nat_le_linear_of_subExponentialTail` | SubExponential tail control gives natural real-Lp linear growth. | `24*K*q` | probability measure, measurable `X`, `SubExponentialTail P X K`, `1 <= q` | proven | `HighDimProb/Concentration/MomentImplications.lean` | `HighDimProbTest/MomentImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `realLpNorm_le_linear_of_psi1Bound` | psi1 Orlicz control gives finite-`ENNReal` real-Lp linear growth. | `16*K*p.toReal` | probability measure, measurable `X`, `Psi1Bound P X K`, `1 <= p`, `p != infinity` | proven | `HighDimProb/Concentration/MomentImplications.lean` | `HighDimProbTest/MomentImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `realLpNorm_le_linear_of_subExponentialTail` | SubExponential tail control gives finite-`ENNReal` real-Lp linear growth. | `48*K*p.toReal` | probability measure, measurable `X`, `SubExponentialTail P X K`, `1 <= p`, `p != infinity` | proven | `HighDimProb/Concentration/MomentImplications.lean` | `HighDimProbTest/MomentImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `subExponentialMoment_of_psi1Bound` | psi1 Orlicz control gives the full finite-`ENNReal` `SubExponentialMoment` interface. | scale `16*K` | probability measure, measurable `X`, `Psi1Bound P X K` | proven | `HighDimProb/Concentration/MomentImplications.lean` | `HighDimProbTest/MomentImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `subExponentialMoment_of_subExponentialTail` | SubExponential tail control gives the full finite-`ENNReal` `SubExponentialMoment` interface. | scale `48*K` | probability measure, measurable `X`, `SubExponentialTail P X K` | proven | `HighDimProb/Concentration/MomentImplications.lean` | `HighDimProbTest/MomentImplicationsAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `bernstein_sum_subExponential` | Independent centered subExponential finite sum satisfies the scalar Bernstein min-form tail bound. | `2*exp(-(1/4 * min(t^2/V) (t/B)))` | independent finite family, `CenteredSubExponentialMGFLIntegral`, `0 < V`, `0 < B`, `0 <= t` | proven | `HighDimProb/Concentration/Bernstein.lean` | `HighDimProbTest/BernsteinAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |
| `bernstein_weighted_sum_subExponential` | Deterministic weighted independent centered subExponential finite sum satisfies the scalar Bernstein min-form tail bound. | `2*exp(-(1/4 * min(t^2/V_c) (t/B_c)))` | independent finite family, `CenteredSubExponentialMGFLIntegral`, arbitrary real weights, `0 < V_c`, `0 < B_c`, `0 <= t` | proven | `HighDimProb/Concentration/Bernstein.lean` | `HighDimProbTest/BernsteinAPI.lean`, `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` |

## Constants Table

| Family | Main constant or scale | Conservative/sharp status | Notes |
|---|---|---|---|
| Markov | `E[X] / a` | exact wrapper | Uses HighDimProb `upperTailProb` and `expect`. |
| Chebyshev | `variance P X / t^2` | exact wrapper | Probability-measure alias is `chebyshev_inequality_prob`. |
| psi2 to tail | `K` | matching scale | Requires measurability outside the Orlicz predicate. |
| tail to psi2 | `2*K` | conservative scale loss | Uses layer-cake and exponential-tail calculus. |
| psi2 to natural real-Lp | `4*K*sqrt(q)` | sharp natural-exponent route | Applies to natural `q >= 1`. |
| psi2 to `SubGaussianMoment` | `8*K` | conservative finite-exponent bridge | Uses Lp monotonicity to `ceil(p.toReal)` and a sqrt-ceiling comparison. |
| tail to `SubGaussianMoment` | `16*K` | conservative finite-exponent bridge | Combines the `2*K` tail-to-psi2 scale loss with the ceiling bridge. |
| MGF to tail | `2*K` | conservative MGF-to-tail bridge | Uses exponent denominator `4*K^2`. |
| Rademacher Hoeffding | `2*exp(-t^2/(4*sum_i a_i^2))` | conservative through generic subGaussian tail | Requires positive square-sum. |
| Centered bounded Hoeffding | `2*exp(-t^2/V)` | conservative | Kept as the generic subGaussian-pipeline theorem. |
| Sharp centered Hoeffding | `2*exp(-2*t^2/V)` | sharp | Uses Hoeffding-specific Chernoff optimization. |
| Non-centered Hoeffding | `2*exp(-2*t^2/V)` | sharp | Around `E[sum_i X_i]`. |
| Weighted bounded Hoeffding | `2*exp(-2*t^2/V_c)` | sharp | `V_c = sum_i c_i^2 * (b_i-a_i)^2`. |
| psi1 to tail | `K` | matching scale | Uses fixed-scale psi1 Orlicz control. |
| tail to psi1 | `3*K` | conservative scale loss | Uses fixed-scale exponential-tail calculus. |
| psi1 to subExponential natural moments | `2*K^q*q!`, then `8*K*q` for natural real-Lp | conservative factorial route | Uses `x^q / q! <= exp x`. |
| psi1 to `SubExponentialMoment` | `16*K` | conservative finite-exponent bridge | Uses Lp monotonicity to `ceil(p.toReal)`. |
| tail to `SubExponentialMoment` | `48*K` | conservative finite-exponent bridge | Combines the `3*K` tail-to-psi1 scale loss with the ceiling bridge. |
| Local Bernstein | `2*exp(-t^2/(4V))` | local quadratic | Domain `t <= 2*V/B`. |
| Full scalar Bernstein | `2*exp(-(1/4 * min(t^2/V) (t/B)))` | conservative min-form | `V = varianceProxy K`, `B = maxScale K`. |
| Weighted scalar Bernstein | `2*exp(-(1/4 * min(t^2/V_c) (t/B_c)))` | conservative min-form | `V_c = weightedVarianceProxy c K`, `B_c = weightedMaxScale c K`. |

## Import Paths

- `import HighDimProb.Concentration` exposes the full experimental scalar
  concentration theorem family, including Markov, Chebyshev, Orlicz/tail
  implications, moment implications, MGF implications, subGaussian sums,
  subExponential sums, Hoeffding, and Bernstein.
- `import HighDimProb.Concentration.Implications` exposes the scalar implication
  graph families: Orlicz/tail, moment, MGF, subGaussian sums, subExponential
  sums, Bernstein, Rademacher sums, and Hoeffding.
- Focused imports remain available for local use:
  `Concentration.Markov`, `Concentration.Chebyshev`,
  `Concentration.OrliczToTail`, `Concentration.TailToOrlicz`,
  `Concentration.MomentImplications`, `Concentration.MGF`,
  `Concentration.SubGaussianSums`, `Concentration.SubExponentialSums`,
  `Concentration.Bernstein`, `Concentration.RademacherSums`, and
  `Concentration.Hoeffding`.

## Stable vs Experimental Status

- The stable root `import HighDimProb` remains the v0.1 scalar object layer and
  statement layer.
- The scalar concentration theorem family remains experimental and is exposed
  through `import HighDimProb.Concentration` and `import HighDimProb.Experimental`.
- No random-matrix concentration theorem is promoted or proved in this closeout.
- No optional dependency is added.

## Known Conservative vs Sharp Results

- `hoeffding_sum_bounded_centered` is conservative and intentionally retained.
  It validates the generic subGaussian finite-sum pipeline.
- `hoeffding_sum_bounded_centered_sharp`, `hoeffding_sum_bounded`, and
  `hoeffding_weighted_sum_bounded` are the sharp bounded-variable Hoeffding
  APIs.
- `absTailProb_le_two_mul_exp_neg_sq_div_varianceProxy_of_centeredSubExponentialMGFLIntegral_sum`
  is the local quadratic Bernstein theorem.
- `bernstein_sum_subExponential` is the full scalar Bernstein min-form theorem.
  It uses the proof-facing lintegral subExponential MGF predicate.
- `bernstein_weighted_sum_subExponential` is the deterministic weighted scalar
  Bernstein min-form theorem. It keeps the same `1/4` min-form constant with
  `weightedVarianceProxy` and `weightedMaxScale`.
- `subExponentialMoment_of_psi1Bound` and
  `subExponentialMoment_of_subExponentialTail` are conservative moment bridges:
  the psi1 route uses scale `16*K`, and the tail route uses scale `48*K` after
  the existing `3*K` tail-to-psi1 loss.

## Remaining TODOs

- Raw-predicate Bernstein variants from `CenteredSubExponentialMGF`, pending a
  raw-to-lintegral bridge or equivalent source assumptions.
- Full subGaussian/subExponential equivalence packages.
- Degenerate bounded-Hoeffding scale cleanup where exact scale-zero predicates
  are still unavailable.
- Bennett, bounded differences, matrix Bernstein, Hanson-Wright, random matrix
  norm bounds, and empirical-process concentration remain future branches.

## Final Summary

Scalar concentration branch status: closed for the current milestone with full
fixed-scale Orlicz/tail/moment bridges for subGaussian and subExponential
formulations.
