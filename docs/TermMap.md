# Term Map

This is the active term index. The old detailed map was collapsed into
[`archive.md`](archive.md); use git history for exact old wording.

| Area | Main terms | Source |
|---|---|---|
| Probability basics | `Event`, `ProbabilityMeasure`, `RandomVariable`, `law`, `expect` | [`HighDimProb`](../HighDimProb) |
| Tail vocabulary | `upperTailEvent`, `lowerTailEvent`, `absTailEvent`, tail probabilities | [`HighDimProb/Tail.lean`](../HighDimProb/Tail.lean) |
| Scalar size | `realLpNorm`, `HasFiniteMoment`, `SubGaussianTail`, `SubExponentialTail`, `Psi2Bound`, `Psi1Bound` | [`HighDimProb/Scalar`](../HighDimProb/Scalar) and concentration files |
| Scalar concentration | Markov, Chebyshev, Orlicz/tail, moment, MGF, Rademacher, Hoeffding, Bernstein routes | [`HighDimProb/Concentration`](../HighDimProb/Concentration) |
| Random vectors | random-vector, covariance, isotropic, subGaussian-vector vocabulary | [`HighDimProb/Vector`](../HighDimProb/Vector) |
| Geometry | nets, metric entropy, Gaussian width vocabulary | [`HighDimProb/Geometry`](../HighDimProb/Geometry) |
| Random matrices | random matrix families, self-adjointness, sums, operator norm, spectral events | [`HighDimProb/RandomMatrix`](../HighDimProb/RandomMatrix) |
| Matrix Bernstein | trace-MGF, CFC/Tropp primitives, prefix/state bookkeeping, reindex transport, optimized scalar RHS, quadratic-form and operator-norm wrappers | [`RandomMatrixAPI.md`](RandomMatrixAPI.md) |
| Examples | sample covariance, random features, gradients, NTK, LoRA, attention, Fisher, prefix-state, conditional-state, and reindexed-Tropp routes | [`HighDimProb/Examples/RandomMatrix`](../HighDimProb/Examples/RandomMatrix) |

## Lookup Rule

Use this file for orientation only. For exact declarations, use doc-gen output,
`#check`, or source search. Keep new entries short and link to the source rather
than copying full theorem signatures.
