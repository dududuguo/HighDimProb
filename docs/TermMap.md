# Term Map

This is the active term index. The old detailed map was collapsed into
[`archive.md`](archive.md); use git history for exact old wording.

| Area | Main terms | Source |
|---|---|---|
| Probability basics | `Event`, `ProbabilityMeasure`, `RandomVariable`, `law`, `expect` | [`HighDimProb`](../HighDimProb) |
| Finite expectation sums | `expect_finset_sum` | [`HighDimProb/Expectation.lean`](../HighDimProb/Expectation.lean) |
| Tail vocabulary | `upperTailEvent`, `lowerTailEvent`, `absTailEvent`, tail probabilities | [`HighDimProb/Tail.lean`](../HighDimProb/Tail.lean) |
| Scalar size | `realLpNorm`, `HasFiniteMoment`, `SubGaussianTail`, `SubExponentialTail`, `Psi2Bound`, `Psi1Bound` | [`HighDimProb/Scalar`](../HighDimProb/Scalar) and concentration files |
| Scalar concentration | Markov, Chebyshev, Orlicz/tail, moment, MGF, Rademacher, Hoeffding, Bernstein routes | [`HighDimProb/Concentration`](../HighDimProb/Concentration) |
| Analysis helpers | real inequalities including `exp_mul_le_chord_exp_of_nonneg_of_le` | [`HighDimProb/Analysis/RealInequalities.lean`](../HighDimProb/Analysis/RealInequalities.lean) |
| Random families/processes | `RandomFamily`, `RealRandomFamily`, `IsRandomFamily`, `familyAt`, `mapRandomFamily`, `RandomProcess`, `IsRandomProcess`, `processAt`, `RandomSample`, `IsRandomSample`, `sampleEvaluation` | [`HighDimProb/Process.lean`](../HighDimProb/Process.lean) |
| SubGaussian process increments | `HasSubGaussianMGFIncrements`, `hasSubgaussianMGF_mono`, `HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le` | [`HighDimProb/SubGaussianProcess.lean`](../HighDimProb/SubGaussianProcess.lean) and [`HighDimProb/SubGaussian.lean`](../HighDimProb/SubGaussian.lean) |
| Random vectors | random-vector, covariance, isotropic, subGaussian-vector vocabulary | [`HighDimProb/Vector.lean`](../HighDimProb/Vector.lean) |
| Geometry | nets, metric entropy, Gaussian width vocabulary | [`HighDimProb/Geometry.lean`](../HighDimProb/Geometry.lean) |
| Finite process supremum | `processSup`, `isRandomVariable_processSup`, `integrable_processSup` | [`HighDimProb/Chaining.lean`](../HighDimProb/Chaining.lean) |
| Cover and packing vocabulary | `epsilonRadius`, `IsEpsilonNet`, `IsInternalEpsilonNet`, `IsEpsilonSeparated`, `externalCoveringNumber`, `coveringNumber`, `packingNumber` | [`HighDimProb/Nets.lean`](../HighDimProb/Nets.lean) and [`HighDimProb/MetricEntropy.lean`](../HighDimProb/MetricEntropy.lean) |
| Finite chaining | `chain_sub_eq_sum_range`, `norm_sub_chain_le_sum_of_step_bound`, `norm_sub_chain_le_sum_of_level_sup`, `expect_abs_sub_chain_le_sum_of_level_sup` | [`HighDimProb/Chaining.lean`](../HighDimProb/Chaining.lean) |
| Deterministic finite LogSumExp | `sum_exp_pos`, `exp_mul_sup'_le_sum_exp`, `sup'_le_log_sum_exp_div`, `log_sum_exp_le_log_card_add` | [`HighDimProb/Analysis/LogSumExp.lean`](../HighDimProb/Analysis/LogSumExp.lean) |
| Fixed-CGF finite maximum | `expect_processSup_le_of_cgf_bound_at` | [`HighDimProb/Concentration/FiniteMax.lean`](../HighDimProb/Concentration/FiniteMax.lean) |
| Optimized subGaussian maxima | `CenteredSubGaussianMGF.neg`, `expect_processSup_le_of_centeredSubGaussianMGF`, `expect_finset_sup'_abs_le_of_centeredSubGaussianMGF` | [`HighDimProb/SubGaussian.lean`](../HighDimProb/SubGaussian.lean) and [`HighDimProb/Concentration/SubGaussianMax.lean`](../HighDimProb/Concentration/SubGaussianMax.lean) |
| Finite subGaussian chaining | `expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF`, `expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF_of_card_le`, `expect_abs_sub_chain_le_sum_of_level_sup_of_subGaussianMGFIncrements`, `expect_abs_sub_chain_le_finiteDyadicEntropySum` | [`HighDimProb/Concentration/SubGaussianMax.lean`](../HighDimProb/Concentration/SubGaussianMax.lean) |
| ENat covering-number bridge | `coveringNumber_le_card_of_isInternalEpsilonNet`, `exists_nat_eq_coveringNumber_of_isInternalEpsilonNet`, `exists_finset_isInternalEpsilonNet_of_totallyBounded`, `exists_parentMap_of_subset_of_isInternalEpsilonNet`, `exists_finset_parentMap_of_internalLevels`, `exists_finset_parentMap_of_internalRadiusLevels`, `exists_finset_path_of_parentMap`, `exists_finset_internalNetFamily_parentMap_path_of_totallyBounded`, `dyadicRadius`, `finiteDyadicEntropySum` | [`HighDimProb/MetricEntropy.lean`](../HighDimProb/MetricEntropy.lean) |
| Random matrices | random matrix families, self-adjointness, sums, operator norm, spectral events, ordered spectral endpoints (`lambdaMaxOrdered`, `lambdaMinOrdered`) | [`HighDimProb/RandomMatrix`](../HighDimProb/RandomMatrix) |
| Matrix concentration | public trace-MGF, tail, Matrix Bernstein, and sample-covariance facade | [`HighDimProb.RandomMatrix.Concentration`](../HighDimProb/RandomMatrix/Concentration.lean) |
| Matrix analysis providers | matrix exponential/logarithm calculus, resolvents, relative entropy, Lieb/Epstein, Golden--Thompson | [`Provider.Analysis`](../HighDimProb/RandomMatrix/Provider/Analysis.lean) |
| Matrix conditioning providers | kernels, frozen-parameter conditional expectation, natural histories | [`Provider.Conditioning`](../HighDimProb/RandomMatrix/Provider/Conditioning.lean) |
| Matrix concentration providers (internal/expert) | integrability compression, trace-MGF, tails, scoped Matrix Bernstein | [`Provider.Concentration`](../HighDimProb/RandomMatrix/Provider/Concentration.lean) |
| Matrix zero variance | zero variance proxy, almost-everywhere zero summands and sums, null positive operator-norm tails | [`HighDimProb/RandomMatrix/VarianceZero.lean`](../HighDimProb/RandomMatrix/VarianceZero.lean) |
| Matrix Bernstein | trace-MGF/Tropp bundles, scalar threshold inversion, `MatrixBernstein.*_of_primitives` optimized/operator-norm/high-probability facades, Bernstein CFC hardbone, variance-proxy bridges, centered-square exact-row adapters, support/effective-rank trace bridges, prefix/reindex/negative adapters, and compact sample-covariance contracts | [`RandomMatrixAPI.md`](RandomMatrixAPI.md) |
| PrecisionDA applications | deterministic column-sample covariance, leave-one-out covariance, shrinkage resolvents, rank-one/Woodbury identities, Frobenius trace-expansion wrappers, and H1/H2/Theorem 1 provider-contract vocabulary | [`HighDimProb/Applications/PrecisionDA`](../HighDimProb/Applications/PrecisionDA.lean) |
| Examples | compact statement-route index plus representative sample covariance, random-feature, gradient, NTK, LoRA, attention, Fisher, natural-Tropp, and PrecisionDA routes | [`HighDimProb/Examples`](../HighDimProb/Examples.lean) |

`HasSubGaussianMGFIncrements` permits the zero `NNReal` proxy at equal indices
and does not assume `0 < σ`. Conversion to `CenteredSubGaussianMGF` at radius
`r` requires `0 < σ`, `0 < r`, and `dist s t ≤ r`. The finite supremum
declarations are `Finset`-only. The minimal-cover adapter now supplies the
finite internal-net/cardinality data for `TotallyBounded K` and `0 < ε`; no
current declaration provides a separable or measurable infinite supremum.

## Lookup Rule

Use this file for orientation only. For exact declarations, use doc-gen output,
`#check`, or source search. Keep new entries short and link to the source rather
than copying full theorem signatures.

## Public And Expert RandomMatrix Terms

Use `HighDimProb.RandomMatrix.Concentration` for downstream
matrix-concentration results. The `HighDimProb.RandomMatrix.Provider.Analysis`,
`.Conditioning`, and `.Concentration` imports are internal/expert proof
boundaries; use the narrowest provider layer needed according to the dependency
ownership documented in
[`RandomMatrixArchitecture.md`](RandomMatrixArchitecture.md). The broad expert
`HighDimProb.RandomMatrix.Provider` facade imports all three.
`HighDimProb.RandomMatrix.LiebProvider` remains a compatibility import and
should not own new declarations.

The analysis layer contains ambient and self-adjoint carrier matrix-exp Frechet
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
APIs `RelativeEntropy.leftRightDenominatorMatrix`,
`RelativeEntropy.leftRightRelativeEntropyIntegrand`,
`RelativeEntropy.leftRightRelativeEntropyIntegrand_jointConvex`,
`RelativeEntropy.traceMatrixRelativeEntropyPlain`,
`LeftRightRelativeEntropyIntegrandDensityIntegrable`,
`TraceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation`,
`leftRightRelativeEntropyIntegrandDensityIntegrable`,
`traceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation`,
`relativeEntropyJointConvexity_of_leftRight_density_integral_representation`,
`relativeEntropyJointConvexity_of_leftRight`,
`liebTraceExpConcavity_statement_of_leftRight_density_integral_representation`,
`liebTraceExpConcavity_statement_of_leftRight`,
`epsteinAffineLineConcavity_of_leftRight_density_integral_representation`,
`epsteinAffineLineConcavity_of_leftRight`,
`RelativeEntropy.scalarTerm_nonneg`,
`RelativeEntropy.diagonalTerm_nonneg`,
`RelativeEntropy.fullMatrixKlein_nonneg_of_isHermitian_of_strictlyPositive`,
`RelativeEntropy.logShift`, `RelativeEntropy.expLogMatrix`,
`gibbsVariationalUpperBoundPremise_of_fullMatrixKlein`, and
`RelativeEntropy.fullKlein_epsteinConcavity`.

The same import also exposes the Epstein consumer namespace `EpsteinLine`,
conditional and left/right Epstein/Lieb/Tropp provider bridges, spectral endpoint monotonicity,
trace-MGF-to-Laplace contracts, provider-compressed natural-state tail helpers,
generated-history Bernstein finite-family/trace-MGF/tail wrappers, the
restricted-history `TraceExpConditioning.bernsteinInputs_of_primitives` and
`TraceExpConditioning.bernsteinStep_of_history_le` facades, trace-exp domain
positivity, CFC-log resolvent cutoff/remainder bridges,
conditioning-kernel reductions,
fixed-numerator trace-resolvent convexity, support-to-excess compression, and
the `TroppNaturalHistory.*` short aliases for suffix measurability and
strengthened history/current-step independence. Long natural-history theorem
names remain compatibility surfaces.

Matrix Bernstein provider-compressed tail names include
`MatrixBernsteinConditioningTraceMGFProviderAssumptions`,
`matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFProviderAssumptions`,
`matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions`, and
their `*_tailSubsetDischarged_of_randomSelfAdjoint` TailEvent wrappers.

The main-layer `MatrixBernstein.optimized_of_primitives` and
`MatrixBernstein.highProbability_of_primitives` facades construct the
finite-family generated-history witness and consume the scalar inversion layer.
`MatrixBernstein.centeredRankOneExactRow` and
`MatrixBernstein.sampleCovarianceExactRow` additionally close the row-specific
variance and normalized sample-covariance tail composition.
`MatrixBernstein.centeredRankOneExactRowHighProbability` supplies the canonical
high-probability threshold for the unnormalized centered rank-one sum.
`MatrixBernstein.sampleCovarianceExactRowHighProbability` evaluates that route
at the canonical threshold divided by the row count, while
`iIndepFun_centeredRankOne` transfers raw vector-family independence to the
centered outer-product family.
They do not prove unconditional Matrix Bernstein; the exact boundary is recorded
in `RandomMatrixAPI.md`.

`CFCLog.DerivOp` is bookkeeping only. The provider layer now includes
positive-definite inverse-convexity segment/`MatrixLE` APIs, the fixed-`t`
left/right inverse-perspective integrand joint-convexity leaf,
density/integral witnesses and route wrappers to joint convexity and Lieb/Epstein,
full matrix Klein, finite-cutoff CFC-log resolvent-kernel bridges with explicit
remainders, the `SameEigenbasisDiagonal` predicate, same-eigenbasis diagonal
remainder cutoff removal, and self-adjoint tail-event subset discharge wrappers,
and now also exposes `CFCLog.lineDeriv_one_zero` and the exact
`goldenThompsonTraceExp` endpoint. It still stops short of arbitrary-weight
plain cutoff removal, the alternative Epstein second-derivative sign route, the
unconditional finite-family Tropp/Matrix Bernstein chain, the weaker independence
statement without explicit summand measurability, the exact conditioning
expectation chain for arbitrary larger history sigma-algebras, variance-proxy
normalization, or full Matrix Bernstein. The restricted route
`mHist <= MeasurableSpace.comap H _` is closed by
`TraceExpConditioning.troppStep_of_history_le`; the Bernstein facade removes
only separate frozen-bound packet construction. Keep this separate from
reader-facing examples and the core `HighDimProb.RandomMatrix` aggregate.
