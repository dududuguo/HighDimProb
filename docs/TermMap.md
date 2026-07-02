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
| PrecisionDA applications | deterministic column-sample covariance, leave-one-out covariance, shrinkage resolvents, rank-one/Woodbury identities, Frobenius trace-expansion wrappers, H2 deterministic event factorization, H2 atomic resolvent-event vocabulary, H2 measurability provider shells, resolvent primitive-measurability finite-intersection proof layer, and H1/H2/Theorem 1 provider-contract vocabulary | [`HighDimProb/Applications/PrecisionDA`](../HighDimProb/Applications/PrecisionDA.lean) |
| Examples | compact statement-route index plus representative sample covariance, random-feature, gradient, NTK, LoRA, attention, Fisher, natural-Tropp, and PrecisionDA routes | [`HighDimProb/Examples`](../HighDimProb/Examples.lean) |

## Lookup Rule

Use this file for orientation only. For exact declarations, use doc-gen output,
`#check`, or source search. Keep new entries short and link to the source rather
than copying full theorem signatures.

## Provider-Facing RandomMatrix Terms

`HighDimProb.RandomMatrix.LiebProvider` is the explicit import for the ambient
and self-adjoint carrier matrix-exp Frechet derivative primitives, the
strictly-positive carrier `CFC.log` first-derivative namespace `CFCLog`
(`Carrier`, `DerivOp`, `derivSAAt`, `lineDeriv`, `hasDerivAt_line`), the short
inverse/trace-resolvent derivative layer
(`hasDerivAt_inverse_affineLine`,
`hasDerivAt_trace_mul_inverse_affineLine_general_neg_cycle`, and
specializations), the Epstein consumer namespace `EpsteinLine`
(`traceSlope`, `traceSecond`, `concavity_of_traceSecond_nonpos_of_lineDerivSA`,
`_of_eval`), conditional Epstein/Lieb/Tropp provider bridges, spectral
endpoint monotonicity, trace-MGF-to-Laplace contracts, provider-compressed
natural-state tail helpers, and the `TroppNaturalHistory.*` short aliases for
suffix measurability and strengthened history/current-step independence. The
long natural-history theorem names remain compatibility surfaces.
`CFCLog.DerivOp` is bookkeeping only, and the provider layer still stops short
of any log-resolvent representation, the Epstein sign theorem, full Lieb/Tropp
claims, the weaker independence statement without explicit summand
measurability, or the exact conditioning expectation chain. Keep this separate
from reader-facing examples and the core `HighDimProb.RandomMatrix` aggregate.
