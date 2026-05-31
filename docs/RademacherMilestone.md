# Rademacher / Hoeffding Milestone

Stage H4 closes the finite Rademacher concentration branch as an experimental,
importable mini-domain.

## Import Boundary

- Stable root `HighDimProb` remains unchanged and does not import this branch.
- `HighDimProb.Distributions` exposes the canonical Rademacher atom and finite
  product family.
- `HighDimProb.Concentration` exposes the weighted-sum MGF and Hoeffding tail
  specializations.
- `HighDimProb.Experimental` exposes both aggregates.

## Proven Spine

| Layer | Main declarations | Status |
|---|---|---|
| Canonical sign atom | `rademacherPMF`, `rademacherMeasure`, `rademacher` | proven |
| Atom measurability/centering | `isRealRandomVariable_rademacher`, `integral_rademacher` | proven |
| Atom MGF/tail | `centeredSubGaussianMGF_rademacher`, `subGaussianTail_rademacher` | proven |
| Finite product family | `rademacherVectorMeasure`, `rademacherVectorPMF` | proven |
| Coordinates | `rademacherCoord`, `rademacherVector` | proven |
| Coordinate facts | `isRealRandomVariable_rademacherCoord`, `integral_rademacherCoord`, `iIndepFun_rademacherCoord` | proven |
| Weighted sum | `weightedRademacherSum`, `isRealRandomVariable_weightedRademacherSum` | proven |
| Weighted MGF | `hasSubgaussianMGF_weightedRademacherSum`, `centeredSubGaussianMGF_weightedRademacherSum` | proven under positive square-sum for the HighDimProb wrapper |
| Weighted tail | `subGaussianTail_weightedRademacherSum` | proven under positive square-sum |
| Explicit Hoeffding form | `hoeffding_rademacher_sum` | proven under positive square-sum |
| Zero-weight cleanup | `weightedRademacherSum_eq_zero_of_sum_sq_eq_zero`, `absTailProb_weightedRademacherSum_eq_zero_of_sum_sq_eq_zero_of_pos` | proven |

## Constants

- One-sign MGF scale: `1`.
- One-sign tail scale: `2`, by the existing MGF-to-tail bridge.
- Weighted Mathlib MGF proxy: `sum_i a_i^2`.
- Weighted HighDimProb MGF scale: `sqrt (sum_i a_i^2)`, assuming
  `0 < sum_i a_i^2`.
- Weighted tail scale: `2 * sqrt (sum_i a_i^2)`.
- Explicit Hoeffding denominator: `4 * sum_i a_i^2`.
- These constants follow the existing MGF-to-tail bridge and are not asserted
  to be sharp.

## Blockers

- The all-zero weight vector is covered by zero-sum and strictly positive
  threshold zero-tail helper theorems.
- The all-zero weight vector is still not expressible as an exact-scale
  HighDimProb `CenteredSubGaussianMGF` or `SubGaussianTail` theorem at scale
  `0`, because both predicates require strictly positive scales.
- General bounded-variable Hoeffding is not part of this branch. It still needs
  an independent finite subGaussian or bounded-variable sum abstraction.
- Bernstein, bounded differences, random matrix concentration, and reverse MGF
  implications remain separate theorem families.

## Test Coverage

- `HighDimProbTest/RademacherAPI.lean` checks the canonical atom.
- `HighDimProbTest/RademacherFamilyAPI.lean` checks the finite product family.
- `HighDimProbTest/RademacherSumsAPI.lean` checks weighted sums, MGF, tail, and
  explicit Hoeffding declarations.
- `HighDimProbTest/BranchImports.lean`, `ExperimentalImports.lean`, and
  `ConcentrationImplicationsAPI.lean` check aggregate discoverability.

## Next Theorem Family

Recommended next safe task: Stage H5 -- independent finite subGaussian sum MGF.
