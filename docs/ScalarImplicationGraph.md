# Scalar Implication Graph

This graph records proved scalar concentration implications and selected blocked
directions. It does not define a canonical `SubGaussian` or `SubExponential`
predicate.

Lean import boundary:

- `HighDimProb.Concentration.Implications` re-exports the current scalar
  implication graph.
- Owning proof leaves remain `OrliczToTail`, `TailToOrlicz`,
  `MomentImplications`, and `MGF`.
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
| canonical Bool Rademacher | `CenteredSubGaussianMGF rademacherMeasure rademacher 1` | `1` | proven | `centeredSubGaussianMGF_rademacher` |
| canonical Bool Rademacher | `SubGaussianTail rademacherMeasure rademacher 2` | `2` | proven | `subGaussianTail_rademacher` |
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
