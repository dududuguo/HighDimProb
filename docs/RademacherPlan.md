# Rademacher / Hoeffding Branch Plan

## Status

The canonical one-sign Rademacher atom and the finite product coordinate
family are now available and tested:

- `rademacherPMF`
- `rademacherMeasure`
- `rademacher`
- `isRealRandomVariable_rademacher`
- `rademacher_mem_Icc`
- `integral_rademacher`
- `centeredSubGaussianMGF_rademacher`
- `subGaussianTail_rademacher`
- `rademacherVectorMeasure`
- `rademacherVectorPMF`
- `rademacherCoord`
- `rademacherVector`
- `integral_rademacherCoord`
- `iIndepFun_rademacherCoord`
- `weightedRademacherSum`
- `isRealRandomVariable_weightedRademacherSum`
- `hasSubgaussianMGF_weightedRademacherSum`
- `centeredSubGaussianMGF_weightedRademacherSum`
- `subGaussianTail_weightedRademacherSum`
- `hoeffding_rademacher_sum`
- `weightedRademacherSum_eq_zero_of_sum_sq_eq_zero`
- `absTailProb_weightedRademacherSum_eq_zero_of_sum_sq_eq_zero_of_pos`
- `hoeffding_rademacher_sum_of_pos_variance`
- `centeredSubGaussianMGF_sum_of_iIndepFun_bounded_centered`
- `subGaussianTail_sum_of_iIndepFun_bounded_centered`
- `hoeffding_sum_bounded_centered`
- `hoeffding_sum_bounded_centered_sharp`

One-sign representation choice: `Bool` with `PMF.bernoulli (1 / 2)`, using `true -> 1` and `false -> -1`.

Finite-family representation choice: product measure
`Measure.pi (fun _ : Fin n => rademacherMeasure)` on `Fin n -> Bool`.
The associated PMF is recovered as `(rademacherVectorMeasure n).toPMF`,
so the measure remains aligned with Mathlib's product-measure independence API.

## Planned Stages

| Stage | Goal | Status |
|---|---|---|
| H0 | Readiness cleanup, API audit, roadmap, and test coverage check. | complete |
| H2A | Finite product Rademacher family infrastructure over `Fin n -> Bool`. | complete |
| H2B | Weighted Rademacher sum MGF from independent signs. | complete |
| H3 | Rademacher Hoeffding tail bound by composing MGF and tail bridges. | complete |
| H4 | Branch closeout: imports, theorem atlas, implication graph, and tests. | complete |
| H5 | Factor independent finite subGaussian sum MGF and tail closure. | complete |
| H6 | Finite Hoeffding theorem for independent bounded centered variables. | complete |
| H6-sharp | Sharp classical/Wikipedia finite bounded centered Hoeffding constant. | complete |
| H7 | Non-centered Wikipedia-form finite bounded Hoeffding corollary. | complete |

Milestone closeout: see `docs/RademacherMilestone.md`.

## Expected Blockers

- Zero-weight-vector cleanup is split from the positive-scale predicates:
  H2-cleanup proves the weighted sum is zero when `sum_i a_i^2 = 0` and that
  its absolute tail probability is zero for every strictly positive threshold.
  The all-zero vector still cannot use scale `0` in `SubGaussianTail` because
  that predicate requires strictly positive scales.
- Constant bookkeeping is fixed for the current bridge: MGF scale
  `sqrt (sum_i a_i^2)` gives two-sided tail scale
  `2 * sqrt (sum_i a_i^2)` and explicit denominator `4 * sum_i a_i^2`.

## Mathlib Reuse Targets

- `PMF.bernoulli`, `PMF.toMeasure`, `Measure.toPMF`, and finite product-measure APIs.
- `measurePreserving_eval` and `ProbabilityTheory.iIndepFun_pi`.
- `ProbabilityTheory.HasSubgaussianMGF`,
  `ProbabilityTheory.HasSubgaussianMGF.sum_of_iIndepFun`, and
  `ProbabilityTheory.iIndepFun.comp`.
- Existing HighDimProb `CenteredSubGaussianMGF`, `subGaussianTail_of_centeredSubGaussianMGF`, and scalar implication graph.

## Scope Guard

The Rademacher/Hoeffding closeout has recorded the constants and zero-scale edge
case. The bounded centered unweighted Hoeffding theorem now has both the
conservative Stage H6 API theorem and the sharp Stage H6-sharp classical
constant, and Stage H7 adds the sharp non-centered Wikipedia-form theorem
around `E[sum_i X_i]`; the next safe widening is deterministic weighted bounded
Hoeffding, not Bernstein, random-matrix bounds, or reverse MGF results.
