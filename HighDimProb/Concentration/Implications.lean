import HighDimProb.Concentration.OrliczToTail
import HighDimProb.Concentration.TailToOrlicz
import HighDimProb.Concentration.MomentImplications
import HighDimProb.Concentration.MGF
import HighDimProb.Concentration.SubGaussianSums
import HighDimProb.Concentration.RademacherSums

/-!
# Scalar implication graph

This module is the collection point for proved scalar concentration implication
theorems. The owning leaves remain `OrliczToTail`, `TailToOrlicz`,
`MomentImplications`, and `MGF`; this aggregate re-exports those theorem names
for downstream users who want the current implication graph through one import.

HighDimProb deliberately does not introduce canonical `SubGaussian` or
`SubExponential` predicates. The formulation-specific predicates stay separate
until the moment, MGF, and finite-gauge links are broad enough.

Current proved arrows:

* `Psi2Bound -> SubGaussianTail`
* `SubGaussianTail -> Psi2Bound` with scale loss `K -> 2 * K`
* `Psi1Bound -> SubExponentialTail`
* `SubExponentialTail -> Psi1Bound` with scale loss `K -> 3 * K`
* natural-exponent factorial and sharp `sqrt(q)` moment links
* `CenteredSubGaussianMGF -> SubGaussianTail/Psi2Bound/SubGaussianMomentNatSqrt`
* independent finite centered subGaussian sums satisfy centered MGF and tail control
* finite weighted Rademacher sums satisfy centered MGF control and Hoeffding tails

The full real-exponent `SubGaussianMoment` theorem and reverse MGF formulation
links remain TODO. This module intentionally keeps the proof theorem names from
the owning leaves instead of adding canonical predicates.
-/

namespace HighDimProb

end HighDimProb
