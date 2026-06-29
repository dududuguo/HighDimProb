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
| Random vectors | random-vector, covariance, isotropic, subGaussian-vector vocabulary | [`HighDimProb/Vector.lean`](../HighDimProb/Vector.lean) |
| Geometry | nets, metric entropy, Gaussian width vocabulary | [`HighDimProb/Geometry.lean`](../HighDimProb/Geometry.lean) |
| Random matrices | random matrix families, self-adjointness, sums, operator norm, spectral events, ordered spectral endpoints (`lambdaMaxOrdered`, `lambdaMinOrdered`) | [`HighDimProb/RandomMatrix`](../HighDimProb/RandomMatrix) |
| Matrix Bernstein | trace-MGF/Tropp bundles, Bernstein CFC hardbone, variance-proxy bridge chain, PSD Loewner norm monotonicity, centered-square exact-row adapters, support/effective-rank trace bridges, prefix/reindex/negative adapters, optimized RHS helpers, compact sample-covariance target/assumption records, and short `QuadTail` / `OpNormTail` wrappers | [`RandomMatrixAPI.md`](RandomMatrixAPI.md) |
| Examples | compact statement-route index plus representative sample covariance, random-feature, gradient, NTK, LoRA, attention, Fisher, and natural-Tropp routes | [`HighDimProb/Examples/RandomMatrix`](../HighDimProb/Examples/RandomMatrix) |

## Lookup Rule

Use this file for orientation only. For exact declarations, use doc-gen output,
`#check`, or source search. Keep new entries short and link to the source rather
than copying full theorem signatures.

## Provider-Facing RandomMatrix Terms

`HighDimProb.RandomMatrix.LiebProvider` is the explicit import for the ambient
and self-adjoint carrier matrix-exp Frechet derivative primitives, including
`matrixExpFDerivSelfAdjoint_spectral_equiv`, conditional Epstein/Lieb/Tropp
provider bridges, spectral endpoint monotonicity, trace-MGF-to-Laplace
contracts, and provider-compressed natural-state tail helpers. Downstream
consumers still do not use a strictly positive carrier derivative API here, so
this remains pre-`CFC.log` / Epstein analytic infrastructure rather than a
direct hookup. Keep this separate from
reader-facing examples and the core `HighDimProb.RandomMatrix` aggregate.
