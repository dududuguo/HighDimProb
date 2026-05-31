import HighDimProb.Concentration.OrliczToTail
import HighDimProb.Concentration.TailToOrlicz

/-!
# Scalar tail/Orlicz implication graph

This module is the small collection point for proved scalar Orlicz/tail
implications.  Moment-growth implication theorems live in
`HighDimProb.Concentration.MomentImplications`, which imports this module.

HighDimProb deliberately does not introduce canonical `SubGaussian` or
`SubExponential` predicates; the formulation-specific predicates stay separate
until the moment, MGF, and finite-gauge links are broad enough.

Current proved arrows:

* `Psi2Bound -> SubGaussianTail`
* `SubGaussianTail -> Psi2Bound` with scale loss `K -> 2 * K`
* `Psi1Bound -> SubExponentialTail`
* `SubExponentialTail -> Psi1Bound` with scale loss `K -> 3 * K`

Natural-exponent factorial and sharp `sqrt(q)` moment links live in
`HighDimProb.Concentration.MomentImplications`, including the
`SubGaussianMomentNatSqrt` interface.  The full real-exponent
`SubGaussianMoment` theorem and MGF formulation links remain TODO.
This module intentionally keeps the proof theorem names from the owning leaves
instead of adding canonical `SubGaussian` or `SubExponential` predicates.
-/

namespace HighDimProb

end HighDimProb
