# Term Map

This is the active term index. The old detailed map was collapsed into
[`archive.md`](archive.md); use git history for exact old wording.

| Area | Main terms | Source |
|---|---|---|
| Probability basics | `Event`, `ProbabilityMeasure`, `RandomVariable`, `law`, `expect` | [`HighDimProb`](../HighDimProb) |
| Tail vocabulary | `upperTailEvent`, `lowerTailEvent`, `absTailEvent`, tail probabilities | [`HighDimProb/Tail.lean`](../HighDimProb/Tail.lean) |
| Scalar size | `realLpNorm`, `HasFiniteMoment`, `SubGaussianTail`, `SubExponentialTail`, `Psi2Bound`, `Psi1Bound` | [`HighDimProb/Scalar`](../HighDimProb/Scalar) and concentration files |
| Scalar concentration | Markov, Chebyshev, Orlicz/tail, moment, MGF, Rademacher, Hoeffding, Bernstein routes | [`HighDimProb/Concentration`](../HighDimProb/Concentration) |
| Analysis helpers | real inequalities including `exp_mul_le_chord_exp_of_nonneg_of_le` | [`HighDimProb/Analysis/RealInequalities.lean`](../HighDimProb/Analysis/RealInequalities.lean) |
| Random families/processes | `RandomFamily`, `RealRandomFamily`, `IsRandomFamily`, `familyAt`, `mapRandomFamily`, `RandomProcess`, `IsRandomProcess`, `processAt`, `RandomSample`, `IsRandomSample`, `sampleEvaluation` | [`HighDimProb/Process.lean`](../HighDimProb/Process.lean) |
| Random vectors | random-vector, covariance, isotropic, subGaussian-vector vocabulary | [`HighDimProb/Vector`](../HighDimProb/Vector) |
| Geometry | nets, metric entropy, Gaussian width vocabulary | [`HighDimProb/Geometry`](../HighDimProb/Geometry) |
| Random matrices | random matrix families, self-adjointness, sums, operator norm, spectral events | [`HighDimProb/RandomMatrix`](../HighDimProb/RandomMatrix) |
| Matrix Bernstein | trace-MGF, Tropp-only assumption bundles, compatibility explicit-CFC bundles, proved Bernstein CFC hardbone leaf, hardbone thin consumers, rank/support trace bridge, `MatrixExpSupportDomination`, `MatrixExpExcessSupportDomination`, trace-exp eigenvalue-sum bridge, effective-rank thin consumer, ambient trace certificate, ambient effective-rank wrapper, star-projection trace/rank/PSD certificate and rank consumer, hardbone statement targets, prefix/state bookkeeping, reindex transport, negative-side adapters, optimized scalar RHS, quadratic-form and operator-norm wrappers | [`RandomMatrixAPI.md`](RandomMatrixAPI.md) |
| Examples | statement-route index, sample covariance, random features, gradients, NTK, LoRA, attention, Fisher, prefix-state, conditional-state, natural-Tropp, reindexed-Tropp, and hardbone statement-atlas routes | [`HighDimProb/Examples/RandomMatrix`](../HighDimProb/Examples/RandomMatrix) |

## Lookup Rule

Use this file for orientation only. For exact declarations, use doc-gen output,
`#check`, or source search. Keep new entries short and link to the source rather
than copying full theorem signatures.
