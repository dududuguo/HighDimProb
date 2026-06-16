# Scalar Implication Graph

This graph records proved scalar concentration implications and selected blocked
directions. It does not define a canonical `SubGaussian` or `SubExponential`
predicate.

Lean import boundary:

- `HighDimProb.Concentration.Implications` re-exports the current scalar
  implication graph.
- Owning proof leaves remain `OrliczToTail`, `TailToOrlicz`,
  `MomentImplications`, `MGF`, `SubGaussianSums`, `SubExponentialSums`,
  `Bernstein`, `RademacherSums`, and `Hoeffding`.
- Reusable layer-cake and exponential-tail calculus helpers are available
  through `HighDimProb.Concentration.LayerCake`.
- Stage SC-final-update records the audited theorem-family surface after the
  full real/`ENNReal` subGaussian and subExponential moment bridges in
  `docs/ScalarConcentrationMilestone.md`.
- Stage B3 adds deterministic weighted scalar Bernstein under the same
  lintegral subExponential MGF predicate.

## A. SubGaussian Graph

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
| finite real/`ENNReal` exponent `p` | natural ceiling exponent `ceil(p.toReal)` | exact monotonicity | proven | `realLpNorm_le_natCeil_of_realExponent` |
| `Psi2Bound P X K` | `SubGaussianMoment P X (8*K)` over all finite `p : ENNReal` | `8*K` | proven | `subGaussianMoment_of_psi2Bound` |
| `SubGaussianTail P X K` | `SubGaussianMoment P X (16*K)` over all finite `p : ENNReal` | `16*K` | proven | `subGaussianMoment_of_subGaussianTail` |
| `CenteredSubGaussianMGF P X K` | `CenteredSubGaussianMGFLIntegral P X K` | `K` | proven | `centeredSubGaussianMGFLIntegral_of_centeredSubGaussianMGF` |
| `CenteredSubGaussianMGF P X K` | one-sided upper/lower tails | denominator `4*K^2` | proven | `upperTailProb_le_exp_neg_sq_of_centeredSubGaussianMGF`, `lowerTailProb_le_exp_neg_sq_of_centeredSubGaussianMGF` |
| `CenteredSubGaussianMGF P X K` | `SubGaussianTail P X (2*K)` | `2*K` | proven | `subGaussianTail_of_centeredSubGaussianMGF` |
| `CenteredSubGaussianMGF P X K` | `Psi2Bound P X (4*K)` | `4*K` | proven | `psi2Bound_of_centeredSubGaussianMGF` |
| `CenteredSubGaussianMGF P X K` | `SubGaussianMomentNatSqrt P X (16*K)` | `16*K` | proven | `subGaussianMomentNatSqrt_of_centeredSubGaussianMGF` |
| `CenteredSubGaussianMGF P X K` | `SubGaussianMoment P X (32*K)` over all finite `p : ENNReal` | `32*K` | composition available | `psi2Bound_of_centeredSubGaussianMGF` then `subGaussianMoment_of_psi2Bound`; no direct wrapper |
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

### SubGaussian Constants

| Edge or family | Constant or scale | Status |
|---|---|---|
| `Psi2Bound -> SubGaussianTail` | `K` | matching scale |
| `SubGaussianTail -> Psi2Bound` | `2*K` | conservative scale loss |
| `Psi2Bound -> realLpNorm` | `4*K*sqrt(q)` | natural-exponent sharp route |
| `SubGaussianTail -> realLpNorm` | `8*K*sqrt(q)` | natural-exponent sharp route with tail loss |
| natural ceiling sqrt comparison | factor `2` | finite `p >= 1`, `sqrt(ceil p.toReal) <= 2*sqrt(p.toReal)` |
| `Psi2Bound -> SubGaussianMoment` | `8*K` | full finite-`ENNReal` exponent bridge |
| `SubGaussianTail -> SubGaussianMoment` | `16*K` | full finite-`ENNReal` exponent bridge with tail loss |
| `CenteredSubGaussianMGF -> SubGaussianTail` | `2*K` | conservative forward MGF route |
| `CenteredSubGaussianMGF -> Psi2Bound` | `4*K` | composed forward route |
| `CenteredSubGaussianMGF -> SubGaussianMomentNatSqrt` | `16*K` | composed forward route |
| `CenteredSubGaussianMGF -> SubGaussianMoment` | `32*K` | composition available; direct wrapper TODO only if wanted |
| finite independent subGaussian sum | `sqrt(sum_i K_i^2)` for MGF, doubled for tail | positive proxy required |
| finite weighted independent subGaussian sum | `sqrt(sum_i (a_i*K_i)^2)` for MGF, doubled for tail | positive weighted proxy required |

Stage H6 sources centered MGF control from bounded centered variables and
composes it with the Stage H5 independent finite-sum layer. Stage H6-sharp
keeps the existing conservative `SubGaussianTail` bridge unchanged and proves
the classical/Wikipedia factor `2` by a Hoeffding-specific Chernoff
optimization. Stage H7 centers a non-centered bounded family locally, proves
the exact finite-sum expectation identity, and reuses the sharp centered theorem
without changing `CenteredSubGaussianMGF`, `SubGaussianTail`, or `Psi2Bound`.
Stage H8 proves deterministic weighted bounded Hoeffding.

### Remaining SubGaussian Missing Edges

| From | To | Scale | Status | Theorem or blocker |
|---|---|---:|---|---|
| typed sqrt-growth compatibility | looser statement wrappers | `8*K`, `16*K` | proven wrappers | `sqrtMomentGrowthOfPsi2`, `sqrtMomentGrowthOfSubGaussianTail` |
| tail / Orlicz / moment | `CenteredSubGaussianMGF` | TBD | blocked | reverse MGF bridge |
| formulation-specific predicates | canonical `SubGaussian` predicate | TBD | blocked | canonical equivalence package |

## B. SubExponential Graph

| From | To | Scale | Status | Theorem |
|---|---|---:|---|---|
| `Psi1Bound P X K` | `SubExponentialTail P X K` | `K` | proven | `subExponentialTail_of_psi1Bound` |
| `SubExponentialTail P X K` | `Psi1Bound P X (3*K)` | `3*K` | proven | `psi1Bound_of_subExponentialTail` |
| `Psi1Bound P X K` | `absMomentNat P X 1 <= K` | `K` | proven | `absMomentNat_one_le_of_psi1Bound` |
| `SubExponentialTail P X K` | `absMomentNat P X 1 <= 3*K` | `3*K` | proven | `absMomentNat_one_le_of_subExponentialTail` |
| `Psi1Bound P X K` | all natural absolute moments | `2*K^q*q!` | proven | `absMomentNat_le_of_psi1Bound` |
| `SubExponentialTail P X K` | all natural absolute moments | `2*(3*K)^q*q!` | proven | `absMomentNat_le_of_subExponentialTail` |
| `Psi1Bound P X K` | natural real-Lp growth | `8*K*q` | proven | `realLpNorm_nat_le_linear_of_psi1Bound` |
| `SubExponentialTail P X K` | natural real-Lp growth | `24*K*q` | proven | `realLpNorm_nat_le_linear_of_subExponentialTail` |
| `Psi1Bound P X K` | finite-`ENNReal` real-Lp linear growth | `16*K*p.toReal` | proven | `realLpNorm_le_linear_of_psi1Bound` |
| `SubExponentialTail P X K` | finite-`ENNReal` real-Lp linear growth | `48*K*p.toReal` | proven | `realLpNorm_le_linear_of_subExponentialTail` |
| `Psi1Bound P X K` | `SubExponentialMoment P X (16*K)` over all finite `p : ENNReal` | `16*K` | proven | `subExponentialMoment_of_psi1Bound` |
| `SubExponentialTail P X K` | `SubExponentialMoment P X (48*K)` over all finite `p : ENNReal` | `48*K` | proven | `subExponentialMoment_of_subExponentialTail` |
| independent finite `CenteredSubExponentialMGF P (X i) (K i)` | raw local MGF bound for `sum_i X_i` | variance proxy `sum_i K_i^2`, domain `1/Kmax` | proven | `centeredSubExponentialMGF_sum_mgf_bound_of_iIndepFun` |
| independent finite `CenteredSubExponentialMGF P (X i) (K i)` | normalized raw local MGF bound for `sum_i X_i` | `varianceProxy K`, domain `1 / maxScale K` | proven | `centeredSubExponentialMGF_sum_mgf_bound_of_iIndepFun_maxScale` |
| independent finite `CenteredSubExponentialMGF P (X i) (K i)` | packaged `CenteredSubExponentialMGF` for `sum_i X_i` | `sqrt (sum_i K_i^2)` | proven conservative domain | `centeredSubExponentialMGF_sum_of_iIndepFun_of_pos` |
| `CenteredSubExponentialMGFLIntegral P X K` | local one-/two-sided Chernoff tails | exponent denominator `4*K^2`, domain `t <= K` | proven local | `absTailProb_le_two_mul_exp_neg_sq_of_centeredSubExponentialMGFLIntegral_of_le` |
| `CenteredSubExponentialMGFLIntegral P X K` | raw `CenteredSubExponentialMGF P X K` | `K` | proven | `centeredSubExponentialMGF_of_centeredSubExponentialMGFLIntegral` |
| independent finite `CenteredSubExponentialMGFLIntegral` | lintegral finite-sum MGF product | `varianceProxy K`, domain `1 / maxScale K` | proven | `centeredSubExponentialMGFLIntegral_sum_mgf_bound_of_iIndepFun_maxScale` |
| independent finite weighted `CenteredSubExponentialMGFLIntegral` | lintegral finite-sum MGF product for `sum_i c_i X_i` | `weightedVarianceProxy c K`, domain `1 / weightedMaxScale c K` | proven | `centeredSubExponentialMGFLIntegral_weighted_sum_mgf_bound_of_iIndepFun_maxScale` |
| independent finite `CenteredSubExponentialMGFLIntegral` | local quadratic Bernstein small-deviation tail | exponent denominator `4*varianceProxy K`, domain `t <= 2*varianceProxy K / maxScale K` | proven local | `absTailProb_le_two_mul_exp_neg_sq_div_varianceProxy_of_centeredSubExponentialMGFLIntegral_sum` |
| local lintegral MGF bound with `V,B` | large-regime Bernstein linear tail | exponent `-t/(2*B)`, domain `2*V/B <= t` | proven | `absTailProb_le_two_mul_exp_neg_linear_div_maxScale_of_mgf_bound_of_ge` |
| local lintegral MGF bound with `V,B` | Bernstein min-form one-/two-sided tails | `exp (-(1/4 * min(t^2/V, t/B)))` | proven | `upperTailProb_le_exp_neg_quarter_bernsteinRate_of_mgf_bound`, `absTailProb_le_two_mul_exp_neg_quarter_bernsteinRate_of_mgf_bound` |
| independent finite `CenteredSubExponentialMGFLIntegral` | full scalar Bernstein min-form tail | `2*exp (-(1/4 * min(t^2/V, t/B)))`, `V=varianceProxy K`, `B=maxScale K` | proven | `bernstein_sum_subExponential` |
| deterministic weighted independent finite `CenteredSubExponentialMGFLIntegral` | full scalar Bernstein min-form tail for `sum_i c_i X_i` | `2*exp (-(1/4 * min(t^2/V_c, t/B_c)))`, `V_c=weightedVarianceProxy c K`, `B_c=weightedMaxScale c K` | proven | `bernstein_weighted_sum_subExponential` |
| raw centered subExponential variables | Bernstein min-form variants | explicit positive statement parameter `cBernstein` | typed-prop | `bernstein_subExponential_sum_statement`, `bernstein_subExponential_weighted_sum_statement` |
| tail / Orlicz | full natural-moment and real-`Lp` growth | `16*K` / `48*K` full moment scales | proven | `subExponentialMoment_of_psi1Bound`, `subExponentialMoment_of_subExponentialTail` |
| local MGF | global subExponential tail / `Psi1Bound` | TBD | partial | local Chernoff proven only for `CenteredSubExponentialMGFLIntegral`; global tail remains future |
| formulation-specific predicates | canonical `SubExponential` predicate | TBD | blocked | canonical equivalence package |

### SubExponential Constants

| Edge or family | Constant or scale | Status |
|---|---|---|
| `Psi1Bound -> SubExponentialTail` | `K` | matching scale |
| `SubExponentialTail -> Psi1Bound` | `3*K` | conservative scale loss |
| `Psi1Bound -> all natural moments` | `2*K^q*q!` | factorial route |
| `SubExponentialTail -> all natural moments` | `2*(3*K)^q*q!` | via tail-to-psi1 |
| `Psi1Bound -> natural real-Lp` | `8*K*q` | factorial-root route |
| `SubExponentialTail -> natural real-Lp` | `24*K*q` | via tail-to-psi1 |
| `Psi1Bound -> SubExponentialMoment` | `16*K` | finite-`ENNReal` ceiling bridge |
| `SubExponentialTail -> SubExponentialMoment` | `48*K` | finite-`ENNReal` ceiling bridge plus tail loss |
| raw finite-sum local MGF | `varianceProxy K`, domain `1/maxScale K` | proven |
| lintegral finite-sum local MGF | `varianceProxy K`, domain `1/maxScale K` | proven |
| weighted lintegral finite-sum local MGF | `weightedVarianceProxy c K`, domain `1/weightedMaxScale c K` | proven |
| local Bernstein | `2*exp(-t^2/(4V))` | local |
| scalar Bernstein min-form | `2*exp(-(1/4*min(t^2/V,t/B)))` | proven |
| weighted scalar Bernstein min-form | `2*exp(-(1/4*min(t^2/V_c,t/B_c)))` | proven |

### Remaining SubExponential Missing Edges

| From | To | Status | Blocker |
|---|---|---|---|
| local MGF | global subExponential tail / `Psi1Bound` | partial | local Chernoff is proved; global formulation bridge remains future |
| raw `CenteredSubExponentialMGF` | lintegral Bernstein source | blocked | raw-to-lintegral bridge or equivalent source assumptions |
| formulation-specific predicates | canonical `SubExponential` predicate | blocked | equivalence package not complete |

## C. Hoeffding Graph

| From | To | Constant or scale | Status | Theorem |
|---|---|---:|---|---|
| bounded centered `X` with `X in Icc a b` a.e. | `CenteredSubGaussianMGF P X ((b-a)/2)` | `(b-a)/2` | proven | `centeredSubGaussianMGF_of_ae_mem_Icc_of_centered` |
| independent finite bounded centered family | centered MGF of `sum_i X_i` | `sqrt(sum_i ((b_i-a_i)/2)^2)` | proven under positive proxy sum | `centeredSubGaussianMGF_sum_of_iIndepFun_bounded_centered` |
| independent finite bounded centered family | sharp centered two-sided Hoeffding tail | exponent `-2*t^2 / sum_i (b_i-a_i)^2` | proven | `hoeffding_sum_bounded_centered_sharp` |
| independent finite bounded family | non-centered classical/Wikipedia tail around `E[sum_i X_i]` | exponent `-2*t^2 / sum_i (b_i-a_i)^2` | proven | `hoeffding_sum_bounded` |
| independent finite bounded centered family with deterministic weights | sharp centered weighted Hoeffding tail | exponent `-2*t^2 / (sum_i c_i^2 * (b_i-a_i)^2)` | proven under positive weighted denominator | `hoeffding_weighted_sum_bounded_centered_sharp` |
| independent finite bounded family with deterministic weights | non-centered weighted classical/Wikipedia tail around `E[sum_i c_i X_i]` | exponent `-2*t^2 / (sum_i c_i^2 * (b_i-a_i)^2)` | proven under positive weighted denominator and explicit integrability | `hoeffding_weighted_sum_bounded` |

The conservative theorem `hoeffding_sum_bounded_centered` remains part of the
graph as the generic subGaussian-pipeline consequence with exponent
`-t^2 / sum_i (b_i-a_i)^2`.
Stage H8 handles arbitrary real weights through the weighted finite-sum MGF
proxy, so negative weights enter only through squares in the denominator.

### Hoeffding Constants

| Theorem family | Constant | Status |
|---|---|---|
| Conservative centered Hoeffding | `2*exp(-t^2/V)` | retained |
| Sharp centered Hoeffding | `2*exp(-2*t^2/V)` | sharp |
| Non-centered classical Hoeffding | `2*exp(-2*t^2/V)` around `E[sum_i X_i]` | classical |
| Weighted bounded Hoeffding | `2*exp(-2*t^2/V_c)` | sharp weighted |

## D. Bernstein Graph

| From | To | Constant or scale | Status | Theorem |
|---|---|---:|---|---|
| one-variable lintegral local MGF | local one-/two-sided tails | `exp(-t^2/(4*K^2))`, `t <= K` | proven | `absTailProb_le_two_mul_exp_neg_sq_of_centeredSubExponentialMGFLIntegral_of_le` |
| independent finite lintegral MGF family | finite-sum local MGF | `varianceProxy K`, domain `1/maxScale K` | proven | `centeredSubExponentialMGFLIntegral_sum_mgf_bound_of_iIndepFun_maxScale` |
| weighted independent finite lintegral MGF family | weighted finite-sum local MGF | `weightedVarianceProxy c K`, domain `1/weightedMaxScale c K` | proven | `centeredSubExponentialMGFLIntegral_weighted_sum_mgf_bound_of_iIndepFun_maxScale` |
| local MGF bound with `V,B` | local quadratic tail | `2*exp(-t^2/(4V))` | proven | `absTailProb_le_two_mul_exp_neg_sq_div_varianceProxy_of_mgf_bound_of_le` |
| local MGF bound with `V,B` | large-regime linear tail | `2*exp(-t/(2*B))` | proven | `absTailProb_le_two_mul_exp_neg_linear_div_maxScale_of_mgf_bound_of_ge` |
| local MGF bound with `V,B` | min-form tail | `2*exp(-(1/4*min(t^2/V,t/B)))` | proven | `absTailProb_le_two_mul_exp_neg_quarter_bernsteinRate_of_mgf_bound` |
| independent finite lintegral MGF family | scalar Bernstein min-form | `V=varianceProxy K`, `B=maxScale K` | proven | `bernstein_sum_subExponential` |
| weighted independent finite lintegral MGF family | weighted scalar Bernstein min-form | `V_c=weightedVarianceProxy c K`, `B_c=weightedMaxScale c K` | proven | `bernstein_weighted_sum_subExponential` |

## Policy

- Keep formulation-specific predicates until all major links are proved.
- Record constant losses in theorem names or documentation.
- Do not promote a canonical predicate from this graph without proof coverage,
  tests, and a status update.
