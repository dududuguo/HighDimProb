import HighDimProb.Concentration.OrliczToTail
import HighDimProb.Concentration.TailToOrlicz
import HighDimProb.Concentration.MomentImplications
import HighDimProb.Concentration.MGF
import HighDimProb.Concentration.SubGaussianSums
import HighDimProb.Concentration.SubExponentialSums
import HighDimProb.Concentration.Bernstein
import HighDimProb.Concentration.RademacherSums
import HighDimProb.Concentration.Hoeffding

/-!
# Scalar implication graph

This module is the collection point for proved scalar concentration implication
theorems. The owning leaves remain `OrliczToTail`, `TailToOrlicz`,
`MomentImplications`, `MGF`, `SubGaussianSums`, `SubExponentialSums`,
`Bernstein`, `RademacherSums`, and `Hoeffding`; this aggregate re-exports those
theorem names for downstream users who want the current implication graph
through one import.

HighDimProb deliberately does not introduce canonical `SubGaussian` or
`SubExponential` predicates. The formulation-specific predicates stay separate
until the moment, MGF, and finite-gauge links are broad enough.

Current proved arrows:

* `Psi2Bound -> SubGaussianTail`
* `SubGaussianTail -> Psi2Bound` with scale loss `K -> 2 * K`
* `Psi1Bound -> SubExponentialTail`
* `SubExponentialTail -> Psi1Bound` with scale loss `K -> 3 * K`
* natural-exponent factorial and sharp `sqrt(q)` moment links
* `Psi2Bound/SubGaussianTail -> SubGaussianMoment` over finite `ENNReal`
  exponents, by exponent monotonicity and the natural-ceiling bridge
* `Psi1Bound/SubExponentialTail -> SubExponentialMoment` over finite
  `ENNReal` exponents, by factorial moment growth and the same natural-ceiling
  bridge
* `CenteredSubGaussianMGF -> SubGaussianTail/Psi2Bound/SubGaussianMomentNatSqrt`
* independent finite centered subGaussian sums satisfy centered MGF and tail control
* independent finite centered subExponential sums satisfy raw and lintegral MGF
  control, local Bernstein tails, and unweighted/weighted scalar Bernstein
  min-form tail bounds
* finite weighted Rademacher sums satisfy centered MGF control and Hoeffding tails
* bounded centered variables and finite independent bounded centered sums satisfy
  Hoeffding MGF, tail, and explicit two-sided tail bounds
* finite independent bounded non-centered sums satisfy the classical/Wikipedia
  two-sided Hoeffding bound around `E[sum_i X_i]`
* deterministic weighted finite bounded sums satisfy the corresponding
  centered and non-centered Hoeffding bounds with denominator
  `sum_i c_i^2 * (b_i-a_i)^2`

Reverse MGF formulation links remain TODO. This module intentionally keeps the
proof theorem names from the owning leaves instead of adding canonical
predicates.
-/

namespace HighDimProb

end HighDimProb
