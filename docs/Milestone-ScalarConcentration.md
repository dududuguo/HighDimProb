# Milestone: Scalar Concentration

Stage SC-final-update closes the scalar concentration branch as an experimental
proof layer after the full real/`ENNReal` moment bridges. The branch includes
core scalar concentration, the subGaussian implication spine,
Rademacher/Hoeffding, subExponential/Bernstein, deterministic weighted scalar
Bernstein, and fixed-scale subGaussian/subExponential moment bridges.

## Completed Theorem Families

| Family | Main declarations | Status | Notes |
|---|---|---|---|
| Core concentration | `measure_biUnion_le`, `markov_inequality`, `markov_inequality_ae_nonneg`, `chebyshev_inequality`, `chebyshev_inequality_prob` | proven | Union bound is stable object-layer API; Markov/Chebyshev are experimental concentration APIs. |
| SubGaussian Orlicz/tail | `subGaussianTail_of_psi2Bound`, `psi2Bound_of_subGaussianTail` | proven | Reverse direction has scale loss `2*K`. |
| SubGaussian moments and Lp | `realLpNorm_nat_le_sqrt_of_psi2Bound`, `realLpNorm_nat_le_sqrt_of_subGaussianTail`, `subGaussianMomentNatSqrt_of_psi2Bound`, `subGaussianMomentNatSqrt_of_subGaussianTail`, `subGaussianMoment_of_psi2Bound`, `subGaussianMoment_of_subGaussianTail` | proven for natural and finite `ENNReal` exponents | Full `SubGaussianMoment` bridge is complete for psi2/tail inputs. |
| MGF implication spine | `subGaussianTail_of_centeredSubGaussianMGF`, `psi2Bound_of_centeredSubGaussianMGF`, `subGaussianMomentNatSqrt_of_centeredSubGaussianMGF` | proven forward direction | Full `SubGaussianMoment` follows by composition through `psi2Bound_of_centeredSubGaussianMGF` and `subGaussianMoment_of_psi2Bound`; no direct wrapper is currently exposed. Reverse/source MGF implications are not proved. |
| Rademacher | `centeredSubGaussianMGF_rademacher`, `subGaussianTail_rademacher`, `iIndepFun_rademacherCoord`, `centeredSubGaussianMGF_weightedRademacherSum`, `hoeffding_rademacher_sum` | proven | Includes finite product family and weighted sums. |
| SubGaussian sums | `centeredSubGaussianMGF_sum_of_iIndepFun_of_pos`, `centeredSubGaussianMGF_weighted_sum_of_iIndepFun_of_pos`, tail corollaries | proven | Positive proxy assumptions remain because current predicates require positive scales. |
| Hoeffding | `hoeffding_sum_bounded_centered`, `hoeffding_sum_bounded_centered_sharp`, `hoeffding_sum_bounded`, `hoeffding_weighted_sum_bounded_centered_sharp`, `hoeffding_weighted_sum_bounded` | proven | Conservative theorem retained; sharp/classical/weighted APIs are separate. |
| SubExponential Orlicz/tail | `subExponentialTail_of_psi1Bound`, `psi1Bound_of_subExponentialTail` | proven | Reverse direction has scale loss `3*K`. |
| SubExponential moments and Lp | `absMomentNat_le_of_psi1Bound`, `realLpNorm_nat_le_linear_of_psi1Bound`, `realLpNorm_le_linear_of_psi1Bound`, `subExponentialMoment_of_psi1Bound`, `subExponentialMoment_of_subExponentialTail` | proven for natural and finite `ENNReal` exponents | Full `SubExponentialMoment` bridge is complete for psi1/tail inputs. |
| SubExponential sums | `centeredSubExponentialMGF_sum_mgf_bound_of_iIndepFun_maxScale`, `centeredSubExponentialMGFLIntegral_sum_mgf_bound_of_iIndepFun_maxScale`, `centeredSubExponentialMGFLIntegral_weighted_sum_mgf_bound_of_iIndepFun_maxScale` | proven under raw or lintegral source predicates | Lintegral predicate is the proof-facing source for ENNReal Chernoff tails. |
| Bernstein | local tails, generic min-form helpers, `bernstein_sum_subExponential`, `bernstein_weighted_sum_subExponential` | proven under lintegral predicate | Raw-predicate Bernstein remains statement-only. |

## Constants Table

| Result | Constant or scale | Status |
|---|---|---|
| Markov | `E[X] / a` | exact wrapper |
| Chebyshev | `variance P X / t^2` | exact wrapper |
| `Psi2Bound -> SubGaussianTail` | `K` | matching scale |
| `SubGaussianTail -> Psi2Bound` | `2*K` | conservative scale loss |
| `Psi2Bound -> realLpNorm` | `4*K*sqrt(q)` | sharp natural-exponent route |
| `SubGaussianTail -> realLpNorm` | `8*K*sqrt(q)` | sharp natural-exponent route with tail loss |
| `Psi2Bound -> SubGaussianMoment` | `8*K` | finite-`ENNReal` bridge |
| `SubGaussianTail -> SubGaussianMoment` | `16*K` | finite-`ENNReal` bridge with tail loss |
| `CenteredSubGaussianMGF -> SubGaussianTail` | `2*K` | conservative MGF-to-tail scale |
| `CenteredSubGaussianMGF -> Psi2Bound` | `4*K` | conservative composed scale |
| `CenteredSubGaussianMGF -> SubGaussianMomentNatSqrt` | `16*K` | conservative composed scale |
| Rademacher weighted sum tail | `2*sqrt(sum_i a_i^2)` | generic subGaussian tail |
| Rademacher Hoeffding | `2*exp(-t^2/(4*sum_i a_i^2))` | conservative |
| Conservative bounded Hoeffding | `2*exp(-t^2/V)` | retained generic-pipeline theorem |
| Sharp/classical bounded Hoeffding | `2*exp(-2*t^2/V)` | sharp |
| Weighted bounded Hoeffding | `2*exp(-2*t^2/V_c)` | sharp weighted |
| `Psi1Bound -> SubExponentialTail` | `K` | matching scale |
| `SubExponentialTail -> Psi1Bound` | `3*K` | conservative scale loss |
| `Psi1Bound -> SubExponentialMoment` | `16*K` | finite-`ENNReal` bridge |
| `SubExponentialTail -> SubExponentialMoment` | `48*K` | finite-`ENNReal` bridge with tail loss |
| SubExponential finite-sum MGF | exponent `varianceProxy K * lambda^2`, domain `1/maxScale K` | normalized Bernstein infrastructure |
| Weighted subExponential finite-sum MGF | exponent `weightedVarianceProxy c K * lambda^2`, domain `1/weightedMaxScale c K` | normalized weighted Bernstein infrastructure |
| Local Bernstein | `2*exp(-t^2/(4V))` | local quadratic |
| Scalar Bernstein min-form | `2*exp(-(1/4*min(t^2/V,t/B)))` | conservative min-form |
| Weighted scalar Bernstein min-form | `2*exp(-(1/4*min(t^2/V_c,t/B_c)))` | conservative weighted min-form |

## Import And Test Status

- `import HighDimProb.Concentration` reaches every scalar concentration leaf.
- `import HighDimProb.Concentration.Implications` reaches the implication graph
  leaves, including subGaussian sums, subExponential sums, Bernstein,
  Rademacher sums, and Hoeffding.
- `import HighDimProb.Experimental` reaches the concentration aggregate and the
  Rademacher distribution leaves.
- `import HighDimProb` intentionally remains stable-object-layer only and does
  not import the concentration theorem branch.
- `docs/ConcentrationLeafAudit.md` records the leaf-module import audit.
- `docs/ScalarConcentrationTheoremIndex.md` records the theorem-family index.
- `docs/ConcentrationTestCoverage.md` records focused and aggregate `#check`
  coverage.

## Remaining Blockers

- Reverse/source MGF implications from tail, Orlicz, or moment hypotheses.
- Full subExponential equivalence package beyond the proved Orlicz/tail/moment
  connectors.
- Raw-predicate Bernstein bridge from `CenteredSubExponentialMGF` to the
  lintegral source needed by ENNReal Chernoff proofs.
- Exact scale-zero predicate cleanup for degenerate Hoeffding/subGaussian cases.
- WLLN/SLLN proof branches.
- Matrix Bernstein, Hanson-Wright, and random matrix concentration.

## Stable / Experimental Decision

`HighDimProb.Concentration` remains experimental. The branch has broad theorem
coverage and test coverage, but promotion to the stable root would be premature
because several equivalence edges and raw-predicate bridges remain intentionally
incomplete. The stable root continues to expose only reviewed scalar object
infrastructure and typed statement specifications.

## Next Recommended Branch

Recommended next branch: Stage Branch-choice, selecting exactly one of matrix
Bernstein, Hanson-Wright, or WLLN/SLLN based on project direction.

Reason: the scalar concentration branch now has the fixed-scale Orlicz/tail and
full moment bridges for both subGaussian and subExponential formulations. The
remaining scalar work is equivalence/source-link cleanup, while the next major
proof direction should be chosen deliberately.
