# Term Map

This is the concise concept-to-module routing index, including public entry
points. The old detailed map was collapsed into [`archive.md`](../archive/README.md); use
git history for exact old wording. Exact RandomMatrix endpoints, imports, and
assumptions are in [`RandomMatrixAPI.md`](../user/RandomMatrixAPI.md); supported scope is
maintained in [`Status.md`](../user/Status.md), active work in [`TODO.md`](../maintainers/TODO.md),
ownership and dependency direction in
[`RandomMatrixArchitecture.md`](../architecture/RandomMatrixArchitecture.md), and family-level
proved/open status in [`TheoremAtlas.md`](TheoremAtlas.md).

| Area | Main terms | Source |
|---|---|---|
| Probability basics | `Event`, `ProbabilityMeasure`, `RandomVariable`, `law`, `expect` | [`HighDimProb`](../../HighDimProb) |
| Finite expectation sums | `expect_finset_sum` | [`HighDimProb/Expectation.lean`](../../HighDimProb/Expectation.lean) |
| Tail vocabulary | `upperTailEvent`, `lowerTailEvent`, `absTailEvent`, tail probabilities | [`HighDimProb/Tail.lean`](../../HighDimProb/Tail.lean) |
| Scalar size | `realLpNorm`, `HasFiniteMoment`, `SubGaussianTail`, `SubExponentialTail`, `Psi2Bound`, `Psi1Bound` | [`HighDimProb/Scalar`](../../HighDimProb/Scalar) and concentration files |
| Scalar concentration | Markov, Chebyshev, Orlicz/tail, moment, MGF, Rademacher, Hoeffding, Bernstein routes | [`HighDimProb/Concentration`](../../HighDimProb/Concentration) |
| Hanson-Wright | `centeredQuadraticForm`, `deterministicFrobeniusNorm`, `HighDimProb.HansonWright.hanson_wright_inequality_hdp_explicit_constant`, `hansonWrightUniversalConstant`; finite real matrix and finite coordinate family, `K > 0`, `iIndepFun`, coordinate `HasSubgaussianMGF` at `K^2`, explicit universal-constant Frobenius/operator min-form tail, no symmetry premise; existential compatibility wrapper `hanson_wright_inequality_hdp` | [`HighDimProb/Concentration/HansonWright.lean`](../../HighDimProb/Concentration/HansonWright.lean) · [`HighDimProbTest/HansonWrightAPI.lean`](../../HighDimProbTest/HansonWrightAPI.lean) |
| Analysis helpers | real inequalities including `exp_mul_le_chord_exp_of_nonneg_of_le` | [`HighDimProb/Analysis/RealInequalities.lean`](../../HighDimProb/Analysis/RealInequalities.lean) |
| Analysis dense-sup bridge | `ciSup_eq_ciSup_of_denseRange` | [`HighDimProb/Analysis/DenseSup.lean`](../../HighDimProb/Analysis/DenseSup.lean) |
| Sum/integral comparison | `sum_mul_sub_le_intervalIntegral_of_antitoneOn`, `tendsto_intervalIntegral_of_leftEndpoint_tendsto`, `le_intervalIntegral_of_le_residual_add_of_tendsto_zero` | [`HighDimProb/Analysis/SumIntegral.lean`](../../HighDimProb/Analysis/SumIntegral.lean) |
| Compact residual convergence | `tendstoUniformlyOn_abs_sub_of_isCompact`, `tendsto_edist_uniformFun_abs_sub_of_isCompact`, `tendsto_toReal_edist_uniformFun_abs_sub_of_isCompact` | [`HighDimProb/Analysis/CompactApproximation.lean`](../../HighDimProb/Analysis/CompactApproximation.lean) |
| Dominated expectation convergence | `MeasureTheory.tendsto_integral_filter_of_dominated_convergence` (direct Mathlib use; no project wrapper) | [`HighDimProbTest/ExpectationConvergenceAPI.lean`](../../HighDimProbTest/ExpectationConvergenceAPI.lean) |
| Random families/processes | `RandomFamily`, `RealRandomFamily`, `IsRandomFamily`, `familyAt`, `mapRandomFamily`, `RandomProcess`, `IsRandomProcess`, `processAt`, `RandomSample`, `IsRandomSample`, `sampleEvaluation` | [`HighDimProb/Process.lean`](../../HighDimProb/Process.lean) |
| SubGaussian process increments | `HasSubGaussianMGFIncrements`, `hasSubgaussianMGF_mono`, `HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le` | [`HighDimProb/SubGaussianProcess.lean`](../../HighDimProb/SubGaussianProcess.lean) and [`HighDimProb/SubGaussian.lean`](../../HighDimProb/SubGaussian.lean) |
| Random-process path regularity | `HasUniformlyContinuousSamplePathsOn`, finite-net supremum convergence | [`HighDimProb/RandomProcess/PathRegularity.lean`](../../HighDimProb/RandomProcess/PathRegularity.lean) |
| Full Dudley | `Dudley.supremum`, `Dudley.entropyIntegrand`, `Dudley.entropyIntegral`, `Dudley.Inputs`, `Dudley.fullBound`, `Dudley.Inputs.bound`; finite support consumer `Dudley.truncatedBound` | [`HighDimProb/Concentration.lean`](../../HighDimProb/Concentration.lean) |
| Gaussian functional foundations | standard-Gaussian integration by parts; affine/product Gaussian stability, integral transport, and OU specialization | [`IntegrationByParts.lean`](../../HighDimProb/GaussianFunctional/IntegrationByParts.lean) and [`AffineStability.lean`](../../HighDimProb/GaussianFunctional/AffineStability.lean) |
| Random vectors | random-vector, covariance, isotropic, subGaussian-vector vocabulary | [`HighDimProb/Vector.lean`](../../HighDimProb/Vector.lean) |
| Geometry | nets, metric entropy, Gaussian width vocabulary | [`HighDimProb/Geometry.lean`](../../HighDimProb/Geometry.lean) |
| Finite process supremum | `processSup`, `isRandomVariable_processSup`, `integrable_processSup` | [`HighDimProb/Chaining.lean`](../../HighDimProb/Chaining.lean) |
| Cover and packing vocabulary | `epsilonRadius`, `IsEpsilonNet`, `IsInternalEpsilonNet`, `IsEpsilonSeparated`, `externalCoveringNumber`, `coveringNumber`, `packingNumber` | [`HighDimProb/Nets.lean`](../../HighDimProb/Nets.lean) and [`HighDimProb/MetricEntropy.lean`](../../HighDimProb/MetricEntropy.lean) |
| Finite chaining | `chain_sub_eq_sum_range`, `norm_sub_chain_le_sum_of_step_bound`, `norm_sub_chain_le_sum_of_level_sup`, `expect_abs_sub_chain_le_sum_of_level_sup`, `finset_sup'_norm_sub_anchor_le_residual_add_sum_of_step_bound`, `expect_finset_sup'_abs_sub_anchor_le_residual_add_sum_of_step_bound` | [`HighDimProb/Chaining.lean`](../../HighDimProb/Chaining.lean) |
| Deterministic finite LogSumExp | `sum_exp_pos`, `exp_mul_sup'_le_sum_exp`, `sup'_le_log_sum_exp_div`, `log_sum_exp_le_log_card_add` | [`HighDimProb/Analysis/LogSumExp.lean`](../../HighDimProb/Analysis/LogSumExp.lean) |
| Fixed-CGF finite maximum | `expect_processSup_le_of_cgf_bound_at` | [`HighDimProb/Concentration/FiniteMax.lean`](../../HighDimProb/Concentration/FiniteMax.lean) |
| Optimized subGaussian maxima | `CenteredSubGaussianMGF.neg`, `expect_processSup_le_of_centeredSubGaussianMGF`, `expect_finset_sup'_abs_le_of_centeredSubGaussianMGF` | [`HighDimProb/SubGaussian.lean`](../../HighDimProb/SubGaussian.lean) and [`HighDimProb/Concentration/SubGaussianMax.lean`](../../HighDimProb/Concentration/SubGaussianMax.lean) |
| Finite subGaussian chaining | `finiteEntropySum`, `expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF`, `expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF_of_card_le`, `expect_abs_sub_chain_le_sum_of_level_sup_of_subGaussianMGFIncrements`, `expect_abs_sub_chain_le_finiteEntropySum`, `expect_abs_sub_chain_le_finiteEntropySum_of_path`, `expect_finset_sup'_abs_sub_anchor_le_finiteEntropySum`, `expect_finset_sup'_abs_sub_anchor_le_truncatedEntropyIntegral`, `expect_abs_sub_dyadic_path_le_truncatedEntropyIntegral`, `finiteEntropySum_dyadic_le_four_mul_intervalIntegral_coveringNumber` | [`HighDimProb/MetricEntropy.lean`](../../HighDimProb/MetricEntropy.lean) and [`HighDimProb/Concentration/SubGaussianMax.lean`](../../HighDimProb/Concentration/SubGaussianMax.lean) |
| Dense/full anchored supremum passage | `expect_iSup_abs_sub_anchor_le_of_denseRange_of_prefix_bound`, `expect_iSup_abs_sub_anchor_le_mul_intervalIntegral_of_denseRange_of_prefix_bound` (the latter requires supplied prefix bounds and supplied residual expectation convergence) | [`HighDimProb/Concentration/SubGaussianMax.lean`](../../HighDimProb/Concentration/SubGaussianMax.lean) |
| Dudley entropy integral | `dudleyEntropyIntegral` (anchored supremum over a totally bounded subtype, under explicit dense-sequence, anchor-net, regularity, and integrability assumptions) | [`HighDimProb/Concentration/Dudley.lean`](../../HighDimProb/Concentration/Dudley.lean) |
| Volumetric covering bounds | `l1Ball`, `coveringNumber_euclideanBall_le`, `coveringNumber_l1Ball_le` (internal `ENat` bounds `ceil((1 + 2R/eps)^card)` and `ceil((1 + 4R/eps)^card)`, for `R >= 0`, `eps > 0`, and finite nonempty index; the l1 bound is via `B1 ⊆ B2` (`l1Ball` inside the Euclidean closed ball) plus Mathlib subset comparison, not the sharper Maurey estimate) | [`HighDimProb/Geometry/CoveringNumber.lean`](../../HighDimProb/Geometry/CoveringNumber.lean); public import [`HighDimProb.Geometry`](../../HighDimProb/Geometry.lean) |
| ENat covering-number bridge | `coveringNumber_le_card_of_isInternalEpsilonNet`, `exists_nat_eq_coveringNumber_of_isInternalEpsilonNet`, `exists_finset_isInternalEpsilonNet_of_totallyBounded`, `exists_parentMap_of_subset_of_isInternalEpsilonNet`, `exists_finset_parentMap_of_internalLevels`, `exists_finset_parentMap_of_internalRadiusLevels`, `exists_finset_path_of_parentMap`, `exists_finset_internalNetFamily_parentMap_path_of_totallyBounded`, `dyadicRadius`, `tendsto_dyadicRadius_atTop`, `tendsto_intervalIntegral_dyadicRadius_atTop` | [`HighDimProb/MetricEntropy.lean`](../../HighDimProb/MetricEntropy.lean) |
| Random matrices | random matrix families, self-adjointness, sums, operator norm, spectral events, ordered spectral endpoints (`lambdaMaxOrdered`, `lambdaMinOrdered`) | [`HighDimProb/RandomMatrix`](../../HighDimProb/RandomMatrix) |
| Matrix concentration | public trace-MGF, tail, Matrix Bernstein, and sample-covariance facade | [`HighDimProb.RandomMatrix.Concentration`](../../HighDimProb/RandomMatrix/Concentration.lean) |
| Matrix sub-Gaussian route | `MatrixSubGaussianMGF`, `MatrixSubGaussianMGF.neg`, `traceMGFVarianceProxyBound_of_matrixSubGaussian_under_troppPrimitive`, `subGaussian_quadraticFormUpperTail_under_troppPrimitive` | [`HighDimProb.RandomMatrix.Concentration`](../../HighDimProb/RandomMatrix/Concentration.lean), [`SubGaussian.lean`](../../HighDimProb/RandomMatrix/SubGaussian.lean), [`SubGaussianMatrixAPI.lean`](../../HighDimProbTest/SubGaussianMatrixAPI.lean) |
| Directional matrix sub-Gaussian route | `DirectionallySubGaussianSelfAdjointMatrix`, `IsUnitSphereNet`, independent-sum closure, deterministic net control, and explicit-`N.card` operator-norm tails | [`HighDimProb.RandomMatrix.Concentration`](../../HighDimProb/RandomMatrix/Concentration.lean), [`DirectionalSubGaussian.lean`](../../HighDimProb/RandomMatrix/DirectionalSubGaussian.lean), [`DirectionalOperatorNorm.lean`](../../HighDimProb/RandomMatrix/DirectionalOperatorNorm.lean) |
| Matrix analysis providers | matrix exponential/logarithm calculus, resolvents, relative entropy, Lieb/Epstein, Golden--Thompson | [`Provider.Analysis`](../../HighDimProb/RandomMatrix/Provider/Analysis.lean) |
| Matrix conditioning providers | kernels, frozen-parameter conditional expectation, natural histories | [`Provider.Conditioning`](../../HighDimProb/RandomMatrix/Provider/Conditioning.lean) |
| Matrix concentration providers (internal/expert) | integrability compression, trace-MGF, tails, scoped Matrix Bernstein | [`Provider.Concentration`](../../HighDimProb/RandomMatrix/Provider/Concentration.lean) |
| Matrix zero variance | zero variance proxy, almost-everywhere zero summands and sums, null positive operator-norm tails | [`HighDimProb/RandomMatrix/VarianceZero.lean`](../../HighDimProb/RandomMatrix/VarianceZero.lean) |
| Matrix Bernstein | trace-MGF/Tropp bundles, scalar threshold inversion, `MatrixBernstein.*_of_primitives` optimized/operator-norm/high-probability facades, Bernstein CFC hardbone, variance-proxy bridges, centered-square exact-row adapters, support/effective-rank trace bridges, prefix/reindex/negative adapters, and compact sample-covariance contracts | [`RandomMatrixAPI.md`](../user/RandomMatrixAPI.md) |
| PrecisionDA applications | deterministic column-sample covariance, leave-one-out covariance, shrinkage resolvents, rank-one/Woodbury identities, Frobenius trace-expansion wrappers, and H1/H2/Theorem 1 provider-contract vocabulary | [`HighDimProb/Applications/PrecisionDA`](../../HighDimProb/Applications/PrecisionDA.lean) |
| Examples | compact statement-route index plus representative sample covariance, random-feature, gradient, NTK, LoRA, attention, Fisher, natural-Tropp, and PrecisionDA routes | [`HighDimProb/Examples`](../../HighDimProb/Examples.lean) |

The matrix sub-Gaussian predicate is only a conditional Loewner MGF contract.
The finite-family and tail declarations retain the Tropp comparison,
random/self-adjoint/independence, variance-proxy self-adjointness, and
unbounded matrix/trace-exponential integrability assumptions; the tail endpoint
additionally retains the aggregate proxy spectral bound at
`theta = t / sigmaSq`. They do not bundle centeredness, PSD, or probability,
and do not assert unconditional Matrix Chernoff, full Tropp, or
infinite-dimensional results.

## Lookup Rule

Use this file for orientation only. For exact declarations, use doc-gen output,
`#check`, or source search. Keep new entries short and link to the source rather
than copying full theorem signatures.

## Public And Internal RandomMatrix Terms

Use `HighDimProb.RandomMatrix.Concentration` for downstream
matrix-concentration results. Provider modules are internal proof-ownership
boundaries, not downstream imports. Their exact dependency map is maintained in
[`RandomMatrixArchitecture.md`](../architecture/RandomMatrixArchitecture.md).

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

`Provider.Analysis` also exposes the Epstein consumer namespace `EpsteinLine`,
left/right Epstein/Lieb and relative-entropy/Gibbs bridges, spectral endpoint
monotonicity, trace-exp domain positivity, CFC-log resolvent cutoff/remainder
bridges, and fixed-numerator trace-resolvent convexity.

`Provider.Conditioning` owns conditioning-kernel reductions and the
`TroppNaturalHistory.*` aliases for suffix measurability and strengthened
history/current-step independence. Long natural-history theorem names remain
compatibility surfaces.

`Provider.Concentration` owns the Tropp one-step and trace-MGF-to-Laplace
contracts, provider-compressed natural-state tail helpers, generated-history
Bernstein finite-family/trace-MGF/tail assembly, the restricted-history
`TraceExpConditioning.bernsteinInputs_of_primitives` and
`TraceExpConditioning.bernsteinStep_of_history_le` facades, integrability
compression, support-to-excess compression, and tail-event subset discharge.
Downstream callers consume re-exported results through
`HighDimProb.RandomMatrix.Concentration`.

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
They do not prove unconditional Matrix Bernstein; exact caller assumptions are
recorded in [`RandomMatrixAPI.md`](../user/RandomMatrixAPI.md), and family-level closure
is recorded in [`TheoremAtlas.md`](TheoremAtlas.md).
