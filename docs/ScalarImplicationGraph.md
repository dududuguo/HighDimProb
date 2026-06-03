# Scalar Implication Graph

This graph records proved scalar concentration implications and selected blocked
directions. It does not define a canonical `SubGaussian` or `SubExponential`
predicate.

Lean import boundary:

- `HighDimProb.Concentration.Implications` re-exports the current scalar
  implication graph.
- Owning proof leaves remain `OrliczToTail`, `TailToOrlicz`,
  `MomentImplications`, `MGF`, `SubGaussianSums`, `RademacherSums`, and
  `Hoeffding`.
- Reusable layer-cake and exponential-tail calculus helpers are available
  through `HighDimProb.Concentration.LayerCake`.

## SubGaussian

| From | To | Scale | Status | Theorem |
|---|---|---:|---|---|
| `Psi2Bound P X K` | `SubGaussianTail P X K` | `K` | proven | `subGaussianTail_of_psi2Bound` |
| `SubGaussianTail P X K` | `Psi2Bound P X (2*K)` | `2*K` | proven | `psi2Bound_of_subGaussianTail` |
| `Psi2Bound P X K` | `absMomentNat P X 2 <= K^2` | `K` | proven | `absMomentNat_two_le_of_psi2Bound` |
| `SubGaussianTail P X K` | `absMomentNat P X 2 <= (2*K)^2` | `2*K` | proven | `absMomentNat_two_le_of_subGaussianTail` |
| `Psi2Bound P X K` | all natural absolute moments, factorial form | `K` | proven | `absMomentNat_le_of_psi2Bound` |
| `SubGaussianTail P X K` | all natural absolute moments, factorial form | `2*K` | proven | `absMomentNat_le_of_subGaussianTail` |
| `finiteAbsMomentNat P X q` | `MemLpRealRandomVariable P X q` | exact | proven | `memLp_of_finiteAbsMomentNat` |
| `absMomentNat P X q <= B` | `realLpNorm P X q <= B^(1/q)` | exact | proven | `realLpNorm_nat_le_of_absMomentNat_le_ennreal` |
| `Psi2Bound P X K` | `realLpNorm P X q <= 8*K*q` | `8*K` | proven | `realLpNorm_nat_le_linear_of_psi2Bound` |
| `SubGaussianTail P X K` | `realLpNorm P X q <= 16*K*q` | `16*K` | proven | `realLpNorm_nat_le_linear_of_subGaussianTail` |
| deterministic envelope | `x^q <= (2*sqrt q)^q * exp(x^2/4)` | `2` | proven | `pow_le_two_sqrt_mul_exp_sq` |
| `Psi2Bound P X K` | `absMomentNat P X q <= (4*K*sqrt q)^q` | `4*K` | proven | `absMomentNat_le_sqrt_growth_of_psi2Bound` |
| `Psi2Bound P X K` | `realLpNorm P X q <= 4*K*sqrt q` | `4*K` | proven | `realLpNorm_nat_le_sqrt_of_psi2Bound` |
| `SubGaussianTail P X K` | `realLpNorm P X q <= 8*K*sqrt q` | `8*K` | proven | `realLpNorm_nat_le_sqrt_of_subGaussianTail` |
| `Psi2Bound P X K` | `SubGaussianMomentNat P X K` | `K` | proven | `subGaussianMomentNat_of_psi2Bound` |
| `SubGaussianTail P X K` | `SubGaussianMomentNat P X (2*K)` | `2*K` | proven | `subGaussianMomentNat_of_subGaussianTail` |
| `Psi2Bound P X K` | `SubGaussianMomentNatSqrt P X (4*K)` | `4*K` | proven | `subGaussianMomentNatSqrt_of_psi2Bound` |
| `SubGaussianTail P X K` | `SubGaussianMomentNatSqrt P X (8*K)` | `8*K` | proven | `subGaussianMomentNatSqrt_of_subGaussianTail` |
| `CenteredSubGaussianMGF P X K` | `CenteredSubGaussianMGFLIntegral P X K` | `K` | proven | `centeredSubGaussianMGFLIntegral_of_centeredSubGaussianMGF` |
| `CenteredSubGaussianMGF P X K` | one-sided upper/lower tails | denominator `4*K^2` | proven | `upperTailProb_le_exp_neg_sq_of_centeredSubGaussianMGF`, `lowerTailProb_le_exp_neg_sq_of_centeredSubGaussianMGF` |
| `CenteredSubGaussianMGF P X K` | `SubGaussianTail P X (2*K)` | `2*K` | proven | `subGaussianTail_of_centeredSubGaussianMGF` |
| `CenteredSubGaussianMGF P X K` | `Psi2Bound P X (4*K)` | `4*K` | proven | `psi2Bound_of_centeredSubGaussianMGF` |
| `CenteredSubGaussianMGF P X K` | `SubGaussianMomentNatSqrt P X (16*K)` | `16*K` | proven | `subGaussianMomentNatSqrt_of_centeredSubGaussianMGF` |
| independent finite `CenteredSubGaussianMGF P (X i) (K i)` | centered MGF of `sum_i X_i` | `sqrt(sum_i K_i^2)` | proven under positive proxy sum | `centeredSubGaussianMGF_sum_of_iIndepFun_of_pos` |
| independent finite `CenteredSubGaussianMGF P (X i) (K i)` | centered MGF of `sum_i a_i X_i` | `sqrt(sum_i (a_i*K_i)^2)` | proven under positive weighted proxy sum | `centeredSubGaussianMGF_weighted_sum_of_iIndepFun_of_pos` |
| independent finite centered MGF family | tail of `sum_i X_i` | `2*sqrt(sum_i K_i^2)` | proven under positive proxy sum | `subGaussianTail_sum_of_iIndepFun_of_pos` |
| independent finite centered MGF family | tail of `sum_i a_i X_i` | `2*sqrt(sum_i (a_i*K_i)^2)` | proven under positive weighted proxy sum | `subGaussianTail_weighted_sum_of_iIndepFun_of_pos` |
| bounded centered `X` with `X in Icc a b` a.e. | `CenteredSubGaussianMGF P X ((b-a)/2)` | `(b-a)/2` | proven under `0 < b-a` | `centeredSubGaussianMGF_of_ae_mem_Icc_of_centered` |
| bounded centered `X` with pointwise `X in Icc a b` | `CenteredSubGaussianMGF P X ((b-a)/2)` | `(b-a)/2` | proven under `0 < b-a` | `centeredSubGaussianMGF_of_forall_mem_Icc_of_centered` |
| independent finite bounded centered family | centered MGF of `sum_i X_i` | `sqrt(sum_i ((b_i-a_i)/2)^2)` | proven under positive proxy sum | `centeredSubGaussianMGF_sum_of_iIndepFun_bounded_centered` |
| independent finite bounded centered family | tail of `sum_i X_i` | `2*sqrt(sum_i ((b_i-a_i)/2)^2)` | proven under positive proxy sum | `subGaussianTail_sum_of_iIndepFun_bounded_centered` |
| independent finite bounded centered family | conservative explicit Hoeffding bound through existing `SubGaussianTail` API | exponent `-t^2 / sum_i (b_i-a_i)^2` | proven under positive proxy sum | `hoeffding_sum_bounded_centered` |
| eighth-variance MGF bound `E exp(lambda*Y) <= exp(lambda^2*V/8)` | sharp one-sided and two-sided tails | exponent `-2*t^2/V` | proven under `0 < V` | `upperTailProb_le_exp_neg_two_mul_sq_div_of_mgf_eighth`, `lowerTailProb_le_exp_neg_two_mul_sq_div_of_mgf_eighth`, `absTailProb_le_two_mul_exp_neg_two_mul_sq_div_of_mgf_eighth` |
| independent finite bounded centered family | sharp classical/Wikipedia Hoeffding bound | exponent `-2*t^2 / sum_i (b_i-a_i)^2` | proven under positive denominator | `hoeffding_sum_bounded_centered_sharp` |
| finite integrable independent bounded family | centering infrastructure for `sum_i X_i - E[sum_i X_i]` | exact finite-sum expectation and centered-sum identity | proven | `expect_finset_sum`, `iIndepFun_centered_of_iIndepFun`, `ae_mem_Icc_centered_of_ae_mem_Icc`, `sum_centered_eq_sum_sub_expect_sum` |
| independent finite bounded family | sharp non-centered classical/Wikipedia Hoeffding bound for `sum_i X_i - E[sum_i X_i]` | exponent `-2*t^2 / sum_i (b_i-a_i)^2` | proven under positive denominator and explicit integrability | `hoeffding_sum_bounded` |
| canonical Bool Rademacher | `CenteredSubGaussianMGF rademacherMeasure rademacher 1` | `1` | proven | `centeredSubGaussianMGF_rademacher` |
| canonical Bool Rademacher | `SubGaussianTail rademacherMeasure rademacher 2` | `2` | proven | `subGaussianTail_rademacher` |
| finite product Rademacher coordinates | `iIndepFun` coordinate family | exact | proven | `iIndepFun_rademacherCoord` |
| finite weighted Rademacher sums | `CenteredSubGaussianMGF` with scale `sqrt (sum_i a_i^2)` under positive square-sum | exact | proven | `centeredSubGaussianMGF_weightedRademacherSum` |
| finite weighted Rademacher sums | `SubGaussianTail` with scale `2 * sqrt (sum_i a_i^2)` under positive square-sum | `2 * sqrt(sum_i a_i^2)` | proven | `subGaussianTail_weightedRademacherSum` |
| finite weighted Rademacher sums | explicit Hoeffding bound | denominator `4 * sum_i a_i^2` | proven under positive square-sum | `hoeffding_rademacher_sum` |
| zero weighted Rademacher sum | identically zero random variable | exact | proven | `weightedRademacherSum_eq_zero_of_sum_sq_eq_zero` |
| zero weighted Rademacher sum | strictly positive absolute tails have probability `0` | exact for `0 < t` | proven | `absTailProb_weightedRademacherSum_eq_zero_of_sum_sq_eq_zero_of_pos` |
| zero weighted Rademacher sum | unrestricted exact-scale tail predicate | scale `0` not accepted | blocked by predicate design | `SubGaussianTail` requires positive scale |

Stage H6 sources centered MGF control from bounded centered variables and
composes it with the Stage H5 independent finite-sum layer. Stage H6-sharp
keeps the existing conservative `SubGaussianTail` bridge unchanged and proves
the classical/Wikipedia factor `2` by a Hoeffding-specific Chernoff
optimization. Stage H7 centers a non-centered bounded family locally, proves
the exact finite-sum expectation identity, and reuses the sharp centered theorem
without changing `CenteredSubGaussianMGF`, `SubGaussianTail`, or `Psi2Bound`.
The next safe theorem family is deterministic weighted bounded Hoeffding in
Stage H8.
| typed sqrt-growth compatibility | looser statement wrappers | `8*K`, `16*K` | proven wrappers | `sqrtMomentGrowthOfPsi2`, `sqrtMomentGrowthOfSubGaussianTail` |
| tail / Orlicz / moment | `CenteredSubGaussianMGF` | TBD | blocked | reverse MGF bridge |
| natural-exponent moment | full `SubGaussianMoment` over finite `ENNReal` exponents | TBD | blocked | real-exponent bridge |
| formulation-specific predicates | canonical `SubGaussian` predicate | TBD | blocked | canonical equivalence package |

## SubExponential

| From | To | Scale | Status | Theorem |
|---|---|---:|---|---|
| `Psi1Bound P X K` | `SubExponentialTail P X K` | `K` | proven | `subExponentialTail_of_psi1Bound` |
| `SubExponentialTail P X K` | `Psi1Bound P X (3*K)` | `3*K` | proven | `psi1Bound_of_subExponentialTail` |
| `Psi1Bound P X K` | `absMomentNat P X 1 <= K` | `K` | proven | `absMomentNat_one_le_of_psi1Bound` |
| `SubExponentialTail P X K` | `absMomentNat P X 1 <= 3*K` | `3*K` | proven | `absMomentNat_one_le_of_subExponentialTail` |
| tail / Orlicz | full natural-moment and real-`Lp` growth | TBD | TODO | future subExponential moment branch |
| local MGF | subExponential tail / `Psi1Bound` | TBD | TODO | future subExponential MGF branch |
| formulation-specific predicates | canonical `SubExponential` predicate | TBD | blocked | canonical equivalence package |

## Policy

- Keep formulation-specific predicates until all major links are proved.
- Record constant losses in theorem names or documentation.
- Do not promote a canonical predicate from this graph without proof coverage,
  tests, and a status update.
