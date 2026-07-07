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
| PrecisionDA applications | deterministic column-sample covariance, leave-one-out covariance, shrinkage resolvents, rank-one/Woodbury identities, Frobenius trace-expansion wrappers, and H1/H2/Theorem 1 provider-contract vocabulary | [`HighDimProb/Applications/PrecisionDA`](../HighDimProb/Applications/PrecisionDA.lean) |
| Examples | compact statement-route index plus representative sample covariance, random-feature, gradient, NTK, LoRA, attention, Fisher, natural-Tropp, and PrecisionDA routes | [`HighDimProb/Examples`](../HighDimProb/Examples.lean) |

## Lookup Rule

Use this file for orientation only. For exact declarations, use doc-gen output,
`#check`, or source search. Keep new entries short and link to the source rather
than copying full theorem signatures.

## Provider-Facing RandomMatrix Terms

`HighDimProb.RandomMatrix.LiebProvider` is the explicit import for the provider
proof layer. It contains ambient and self-adjoint carrier matrix-exp Frechet
derivative primitives, the scalar divided-difference coefficient
`matrixExpDividedDifferenceSeries`, the preferred trace-pairing alias
`MatrixExpFDeriv.conjDiagonalSymmTraceSum`, the strictly-positive carrier
`CFC.log` first-derivative namespace `CFCLog`, preferred diagonal adapters
`CFCLog.diagonalDerivEntryMul`, `CFCLog.diagonalLineDerivEntryMul`, and
`CFCLog.diagonalLineDerivTraceSum`, the short inverse/trace-resolvent derivative
layer, the finite-cutoff log-resolvent namespace `LogResolvent`, and the
inverse-convexity quadratic-form and segment identities
`inv_quadraticForm_affine_le_of_posDef`,
`inv_quadraticForm_iSup_affine_of_posDef`, and
`inv_matrixLE_convex_combo_le_of_posDef`, plus the relative-entropy route
APIs `RelativeEntropy.scalarTerm_nonneg`,
`RelativeEntropy.diagonalTerm_nonneg`,
`RelativeEntropy.fullMatrixKlein_nonneg_of_isHermitian_of_strictlyPositive`,
`RelativeEntropy.logShift`, `RelativeEntropy.expLogMatrix`,
`gibbsVariationalUpperBoundPremise_of_fullMatrixKlein`, and
`RelativeEntropy.fullKlein_epsteinConcavity`.

The same import also exposes the Epstein consumer namespace `EpsteinLine`,
conditional Epstein/Lieb/Tropp provider bridges, spectral endpoint monotonicity,
trace-MGF-to-Laplace contracts, provider-compressed natural-state tail helpers,
CFC-log resolvent cutoff/remainder bridges, conditioning-kernel reductions,
fixed-numerator trace-resolvent convexity, support-to-excess compression, and
the `TroppNaturalHistory.*` short aliases for suffix measurability and
strengthened history/current-step independence. Long natural-history theorem
names remain compatibility surfaces.

`CFCLog.DerivOp` is bookkeeping only. The provider layer now includes
positive-definite inverse-convexity segment/`MatrixLE` APIs, full matrix Klein,
finite-cutoff CFC-log resolvent-kernel bridges with explicit remainders, the
`SameEigenbasisDiagonal` predicate, same-eigenbasis diagonal remainder cutoff
removal, and self-adjoint tail-event subset discharge wrappers, but still
stops short of
relative-entropy joint convexity, arbitrary-weight plain cutoff removal, the
Epstein second-derivative sign, full Lieb/Tropp, the weaker independence
statement without explicit summand measurability, the exact conditioning
expectation chain for arbitrary larger history sigma-algebras, variance-proxy
normalization, or full Matrix Bernstein. Keep this separate from reader-facing
examples and the core `HighDimProb.RandomMatrix` aggregate.
