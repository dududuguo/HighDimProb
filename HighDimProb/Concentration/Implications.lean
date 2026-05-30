import HighDimProb.Concentration.OrliczToTail
import HighDimProb.Concentration.TailToOrlicz

/-!
# Scalar concentration implication graph

This module is the small collection point for proved scalar Orlicz/tail
implications. It deliberately does not introduce canonical `SubGaussian` or
`SubExponential` predicates; HighDimProb keeps the formulation-specific
predicates separate until the moment and MGF links are proved.

Current proved arrows:

* `Psi2Bound -> SubGaussianTail`
* `SubGaussianTail -> Psi2Bound` with scale loss `K -> 2 * K`
* `Psi1Bound -> SubExponentialTail`
* `SubExponentialTail -> Psi1Bound` with scale loss `K -> 3 * K`
-/

namespace HighDimProb

end HighDimProb
