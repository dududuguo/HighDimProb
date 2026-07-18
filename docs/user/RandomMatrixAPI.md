# RandomMatrix Matrix Bernstein API

This is the caller-facing endpoint, import, and assumption guide for the
RandomMatrix concentration API. Use it to choose public theorem endpoints,
imports, and the hypotheses they require. Old historical notes were collapsed
into [`archive.md`](../archive/README.md); use git history for exact old wording.

For supported scope and current status, see [`Status.md`](Status.md); for
active work, see [`TODO.md`](../maintainers/TODO.md); and for module ownership and dependency
direction, see [`RandomMatrixArchitecture.md`](../architecture/RandomMatrixArchitecture.md).
Family-level proved/open status is owned by [`TheoremAtlas.md`](../reference/TheoremAtlas.md).

Downstream users of the matrix-concentration results documented here should
normally use:

```lean
import HighDimProb.RandomMatrix.Concentration
```

The public `HighDimProb.RandomMatrix.Concentration` facade is the downstream
caller endpoint. The `HighDimProb.RandomMatrix.Provider.*` modules are
internal/expert proof boundaries; use the narrowest provider import only when
developing or auditing provider proofs. Their ownership and dependency rules
are defined in [`RandomMatrixArchitecture.md`](../architecture/RandomMatrixArchitecture.md).

## Core Modules

- [`Basic.lean`](../../HighDimProb/RandomMatrix/Basic.lean)
- [`Assumptions.lean`](../../HighDimProb/RandomMatrix/Assumptions.lean)
- [`Sums.lean`](../../HighDimProb/RandomMatrix/Sums.lean)
- [`OperatorNorm.lean`](../../HighDimProb/RandomMatrix/OperatorNorm.lean)
- [`Spectral.lean`](../../HighDimProb/RandomMatrix/Spectral.lean)
- [`TraceExp.lean`](../../HighDimProb/RandomMatrix/TraceExp.lean)
- [`TraceExpDerivative.lean`](../../HighDimProb/RandomMatrix/TraceExpDerivative.lean)
- [`TraceExpMonotonicity.lean`](../../HighDimProb/RandomMatrix/TraceExpMonotonicity.lean)
- [`HardboneStatements.lean`](../../HighDimProb/RandomMatrix/HardboneStatements.lean)
- [`CStarBridge.lean`](../../HighDimProb/RandomMatrix/CStarBridge.lean)
- [`VarianceProxy.lean`](../../HighDimProb/RandomMatrix/VarianceProxy.lean)
- [`ConcentrationStatements.lean`](../../HighDimProb/RandomMatrix/ConcentrationStatements.lean)

## Shared Helpers

- `matrixBernsteinOptimizedScalarTailRHS`
- `matrixBernsteinTwoSidedOptimizedScalarTailRHS`
- `matrixBernsteinTwoSidedOptimizedScalarTailRHS_sameParameters`
- `one_le_matrixBernsteinTwoSidedOptimizedScalarTailRHS_zero`
- `MatrixBernsteinPositiveSideTroppAssumptions`
- `MatrixBernsteinNegativeSideTroppAssumptions`
- `sampleCovarianceCenteredRankOneRadius`
- `sampleCovarianceTailTheta`
- `sampleCovarianceQuadraticFormTailRHS`
- `rowSqNormVarianceProxyNormRHS`

Use these helpers in examples and tests instead of copying RHS formulas.

Expectation / integrability bridges:

- `integrable_matrix_of_integrableRandomMatrix`
- `matrixExpect_eq_integral_l2Operator`
- `matrixExpect_eq_integral`

These connect the public entrywise `IntegrableRandomMatrix` and `matrixExpect`
API to Mathlib's Bochner `Integrable` / integral lemmas. Use them when provider
proofs need linear-map, measure-map, or Jensen-style integral machinery without
duplicating entrywise-to-Bochner boilerplate.

Order / PSD representation bridges:

- `isPSDMatrix_of_posSemidef`
- `posSemidef_of_isPSDMatrix`
- `matrixLE_of_mathlib_le`
- `mathlib_le_of_matrixLE`

These bridge HighDimProb's explicit quadratic-form PSD vocabulary and Mathlib's
ordered-matrix API without installing a new matrix order abstraction.

Spectral endpoints:

- `lambdaMax`
- `lambdaMaxOrdered`
- `lambdaMaxOrdered_eq_eigenvalues₀_zero`
- `lambdaMaxOrdered_is_greatest_eigenvalue_statement`
- `lambdaMaxOrdered_is_greatest_eigenvalue`
- `lambdaMin`
- `lambdaMinOrdered`
- `lambdaMinOrdered_is_least_eigenvalue_statement`
- `lambdaMinOrdered_is_least_eigenvalue`
- `lambdaMinOrdered_le_eigenvalues₀`

These wrappers keep the legacy `lambdaMax` / `lambdaMin` names while exposing
the canonical ordered `eigenvalues₀` endpoints.


CStar representation bridge:

- `realMatrixToCStarMatrix`
- `realMatrixToCStarStarAlgHom`
- `realMatrixToCStar_nonneg`
- `realMatrixToCStar_strictlyPositive`
- `realMatrixToCStar_matrixLE`
- `realMatrixToCStar_log`
- `isSelfAdjointMatrix_cfc_log`
- `cstarMatrixOfMatrix_posSemidef_of_nonneg`
- `posSemidef_of_complexification_posSemidef`
- `matrixLE_of_realMatrixToCStar_matrixLE`
- `realMatrixToCStarMatrix_apply`
- `realMatrixToCStarMatrix_add`
- `realMatrixToCStarMatrix_sub`
- `isSelfAdjoint_realMatrixToCStarMatrix`

These expose the real-matrix to `CStarMatrix` representation layer needed to
reuse Mathlib CStar functional-calculus order results. Strict positivity,
Loewner-order, and strictly-positive self-adjoint `CFC.log` transport are now
proved in the main repository; `realMatrixToCStar_log` is intentionally restricted to that domain.

## Zero-Variance Surface

- `matrixVarianceProxy_eq_zero_of_normBound_zero`
- `randomMatrixFamily_ae_eq_zero_of_matrixVarianceProxy_eq_zero`
- `randomMatrixFamily_ae_eq_zero_of_matrixVarianceProxyNormBound_zero`
- `randomMatrixSum_ae_eq_zero_of_family_ae_eq_zero`
- `upperTailProb_operatorNorm_randomMatrixSum_eq_zero_of_ae_eq_zero`
- `upperTailProb_operatorNorm_randomMatrixSum_eq_zero_of_varianceNormBound_zero`

These declarations live in `HighDimProb.RandomMatrix.VarianceZero`. They prove
the degenerate variance branch exactly: a zero variance-proxy norm bound for
self-adjoint square-integrable summands forces each summand and their finite
sum to vanish almost everywhere, hence every positive operator-norm upper tail
has probability zero. They do not supply the positive-variance Tropp branch.

## Matrix Bernstein Surface

- `bernsteinAdditiveTailThreshold`
- `bernsteinAdditiveTailThreshold_nonneg`
- `bernsteinAdditiveTailThreshold_sq`
- `bernsteinAdditiveTailThreshold_pos`
- `bernsteinAdditiveTailThreshold_exponent_eq`
- `matrixBernsteinLogFactor`
- `matrixBernsteinLogFactor_pos`
- `matrixBernsteinHighProbabilityThreshold`
- `matrixBernsteinHighProbabilityThreshold_nonneg`
- `matrixBernsteinTwoSidedOptimizedScalarTailRHS_highProbabilityThreshold`
- `matrixBernsteinSelfAdjointHighProbabilityStatement`
- `matrixBernsteinSelfAdjointHighProbabilityStatement_of_optimizedStatement`
- `MatrixBernstein.operatorNormTail_of_primitives`
- `MatrixBernstein.operatorNormTail_of_primitives_nonneg`
- `MatrixBernstein.operatorNormUpperTail_of_primitives`
- `MatrixBernstein.optimized_of_primitives`
- `MatrixBernstein.CenteredRankOneInputs`
- `MatrixBernstein.CenteredRankOneExactRowInputs`
- `MatrixBernstein.centeredRankOne`
- `MatrixBernstein.centeredRankOneExactRow`
- `MatrixBernstein.sampleCovarianceExactRow`
- `MatrixBernstein.sampleCovarianceExactRowHighProbability`
- `MatrixBernstein.highProbability_of_primitives`
- `matrixBernsteinSelfAdjointOptimizedStatement`
- `matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives`
- `TraceExpConditioning.bernsteinInputs_of_primitives`
- `TraceExpConditioning.bernsteinStep_of_history_le`
- `troppMasterTraceMGFFiniteFamily_generatedHistory_of_bernsteinPrimitives`
- `matrixBernsteinTraceMGFWithBernsteinCoeff_generatedHistory_of_bernsteinPrimitives`
- `matrixBernsteinQuadraticFormUpperTail_generatedHistory_of_bernsteinPrimitives`
- `matrixBernsteinQuadraticFormUpperTail_generatedHistory_of_bernsteinPrimitives_tailSubsetDischarged_of_randomSelfAdjoint`
- `matrixBernsteinTraceMGF_under_tropp`
- `matrixBernsteinQuadTail_trace_under_tropp`
- `matrixBernsteinQuadTail_scalar_under_tropp`
- `matrixBernsteinQuadTail_opt_under_tropp`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge`
- `MatrixBernsteinConditioningTraceMGFTailAssumptions`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFTailAssumptions`
- `MatrixBernsteinConditioningTraceMGFProviderAssumptions`
- `MatrixBernsteinConditioningTraceMGFProviderAssumptions.toTailAssumptions`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFProviderAssumptions`
- `matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge_tailSubsetDischarged_of_randomSelfAdjoint`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFProviderAssumptions_tailSubsetDischarged_of_randomSelfAdjoint`
- `matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions_tailSubsetDischarged_of_randomSelfAdjoint`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions`
- `matrixBernsteinQuadTail_opt_of_tropp`
- `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`
- `matrixBernsteinQuadTail_twoSided_opt_of_tropp`
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_pos_under_primitives`
- `matrixBernsteinOpNormTail_opt_of_tropp`

The scalar threshold API is the exact positive-root inversion for the
additive-denominator exponent
`t^2 / (2 * varianceProxy + (2 / 3) * maxScale * t)`. Its nonnegativity,
square identity, positivity, and exponent-equality lemmas expose the sign
boundary explicitly. The matrix
surface sets `logFactor = log (2 * n / delta)`. `matrixBernsteinLogFactor_pos`
requires `0 < n` and `0 < delta <= 1`; the exact RHS equality and the public
self-adjoint contract additionally require `0 <= sigmaSq`, `0 <= R`, and
`0 < sigmaSq or 0 < R`. The contract keeps integrability,
centered self-adjointness, independence, norm, and variance-proxy assumptions
explicit.

`matrixBernsteinSelfAdjointHighProbabilityStatement_of_optimizedStatement`
is the scalar-threshold consumer: it evaluates an optimized tail contract at the
canonical threshold and converts its RHS to `ENNReal.ofReal delta`.
`MatrixBernstein.optimized_of_primitives` constructs that optimized contract
from the standard finite-dimensional Bernstein primitives, and
`MatrixBernstein.highProbability_of_primitives` exposes the closed
high-probability route. These theorems do not prove unconditional Matrix
Bernstein.

`MatrixBernstein.sampleCovarianceExactRowHighProbability` specializes the
row-specific sample-covariance tail at
`matrixBernsteinHighProbabilityThreshold / m`, matching the normalization in
`sampleCovariance`. Its nondegeneracy and `delta` hypotheses are exactly the
ones used by the scalar inversion theorem. If a caller has
`ProbabilityTheory.iIndepFun X P` for the original row vectors,
`iIndepFun_centeredRankOne` supplies independence of their centered rank-one
matrix family.

These are under explicit primitive assumptions. The pointwise Bernstein CFC
primitive is now proved by `bernsteinMatrixExp_le_quadratic`; the
`under_troppPrimitive` trace-MGF wrapper uses that proof so callers no longer
pass pointwise CFC at the trace-MGF provider layer. The
`matrixBernsteinSelfAdjointOptimizedStatement` fixes the canonical two-sided
RHS over an arbitrary finite index type; `MatrixBernstein.optimized_of_primitives`
proves it by reindexing through `Fin (Fintype.card I)`. The preferred public
consumer surface is the
`*_of_troppAssumptions` family, which uses
`MatrixBernsteinPositiveSideTroppAssumptions` and
`MatrixBernsteinNegativeSideTroppAssumptions` to expose Tropp/Lieb and
bookkeeping assumptions without a user-supplied CFC field. The older
`*_of_assumptions` and `_under_primitives` names remain compatibility surfaces.
The generated-history Bernstein wrappers live behind
`HighDimProb.RandomMatrix.Provider.Concentration` and are re-exported by the
public `HighDimProb.RandomMatrix.Concentration` facade; they derive current-step
exponential-mean self-adjointness and strict positivity from centered
self-adjoint bounded summands. The base quadratic-form tail wrapper keeps tail
measurability explicit, while `MatrixBernstein.operatorNormUpperTail_of_primitives`,
`MatrixBernstein.optimized_of_primitives`, and
`MatrixBernstein.highProbability_of_primitives` perform the finite-family
operator-norm and threshold assembly.
The S10 conditioning-to-tail route also records the developer-facing scaffold
`MatrixBernsteinConditioningTraceMGFTailAssumptions` and the thin
`matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFTailAssumptions`
wrapper for provider-target bookkeeping. The compressed provider-assumption
and natural-state wrappers are
`MatrixBernsteinConditioningTraceMGFProviderAssumptions`,
`matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFProviderAssumptions`,
and `matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions`.
Their provider bundle derives the exact history/current-step independence
contract from explicit random-matrix data while retaining finite-family
independence as an input; their TailEvent variants discharge only the subset
premise. These names are not the preferred reader-facing Matrix Bernstein API.
The route still does not prove
Tropp/Lieb, Golden-Thompson, trace-exp integrability, variance-proxy control,
tail measurability, operator-norm endpoint assembly, or a full unconditional
Matrix Bernstein theorem. The raw conditioning-to-tail wrapper
`matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge` is a thin
composition from the S9 conditioning trace-MGF consumer to the existing
quadratic-form Laplace route under an explicit tail-event subset assumption.

## Hardbone Statement Targets

Bernstein CFC chain:

- `scalarBernsteinExpQuadraticInequality_statement`
- `scalarBernsteinExpQuadraticInequality`
- `selfAdjointSpectrumBoundedByOperatorNorm_statement`
- `selfAdjointSpectrumBoundedByOperatorNorm`
- `cfcScalarInequalityToMatrixLE_statement`
- `cfcScalarInequalityToMatrixLE_bernsteinExpQuadratic`
- `bernsteinCFCExpressionNormalization_statement`
- `bernsteinCFCExpressionNormalization`
- `bernsteinMatrixExp_le_quadratic_of_cfcChain_statement`
- `bernsteinMatrixExp_le_quadratic_of_cfcLeaves`
- `bernsteinMatrixExp_le_quadratic`

Log/order-to-`K` chain:

- `operatorLogMonotoneOnPositiveMatrices_statement`
- `operatorLogMonotoneOnPositiveMatrices`
- `matrixExpLogDomainForSelfAdjoint_statement`
- `matrixExpLogDomainForSelfAdjoint`
- `matrixLog_le_of_le_matrixExp_statement`
- `matrixLog_le_of_le_matrixExp`
- `traceMatrixExp_mono_add_selfAdjoint_statement`
- `traceMatrixExp_mono_add_selfAdjoint`
- `troppLogExpComparisonToK`

Tropp/Lieb/Golden-Thompson chain:

- `liebTraceExpConcavity_statement`
- `liebJensenTraceExp_statement`
- `goldenThompsonTraceExp_statement`
- `goldenThompsonTraceExp`
- `matrixExpLogSelfAdjointNormalization_statement`
- `matrixExpLogSelfAdjointNormalization`
- `troppMasterTraceMGFStep_of_liebJensen_statement`

Conditioning / independence chain:

- `troppNaturalHistoryMeasurable_statement`
- `troppHistoryStepIndependent_of_iIndepFun_statement`
- `TroppNaturalHistory.historyStepContractOfIsRandomMatrix`
- `condExp_traceExp_history_add_independent_step_statement`
- `troppConditionalStep_of_iIndepFun_statement`
- `troppConditionalStep_of_iIndepFun`

Integrability provider chain:

- `matrixExpScaledIntegrable_of_provider_statement`
- `traceExpIntegrable_troppStateHistory_add_step_statement`
- `traceExpIntegrable_troppStateHistory_add_K_statement`
- `traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider_statement`

Variance-proxy / centered-square chain:

- `matrixSquare_centeredRandomMatrix_expectation_expansion_statement`
- `matrixSquare_centeredRandomMatrix_expectation_expansion`
- `centeredRankOneSquare_le_rankOneSecondMoment_statement`
- `centeredRankOneSquare_le_rankOneSecondMoment`
- `sampleCovarianceVarianceProxy_sharp_statement`
- `sampleCovarianceVarianceProxy_sharp_of_rankOneSecondMoment`
- `sampleCovarianceVarianceProxy_sharp_of_exactRowSecondMoment`
- `sampleCovarianceVarianceProxy_sharp_of_exactRowSqNorm_bound_memLp_two`
- `sampleCovarianceVarianceProxy_sharp_statement_of_centeredSquareChain_exactRowSqNorm_bound_memLp_two`
- `sampleCovarianceVarianceProxy_sharp_of_exactRowSqNorm_bound_memLp_two_of_centeredSquareChain`
- `MatrixVarianceProxyNormBound_centeredRankOneRandomMatrixFamily_of_rowSqNorm_bound_memLp_two`
- `MatrixVarianceProxyNormBound_centeredSampleCovarianceRowRankOneFamily_of_exactRowSqNorm_bound_memLp_two`
- `MatrixVarianceProxyNormBound_centeredSampleCovarianceRowRankOneFamilyNeg_direct_of_exactRowSqNorm_bound_memLp_two`
- `MatrixVarianceProxyNormBound_centeredSampleCovarianceRowRankOneFamilyNeg_of_exactRowSqNorm_bound_memLp_two`
- `varianceProxyNormBound_of_centeredSquareChain_statement`
- `deterministicMatrixVarianceProxyNorm_mono_of_matrixLE_statement`
- `deterministicMatrixVarianceProxyNorm_mono_of_matrixLE`
- `varianceProxyNormBound_of_centeredSquareChain_of_normMono`
- `varianceProxyNormBound_of_centeredSquareChain_expansion`

Dimension / rank / effective-rank chain:

- `traceMatrixExp_le_rank_exp_lambdaMax_statement`
- `traceMatrixExp_le_supportDim_exp_lambdaMax_statement`
- `traceMatrixExp_effectiveRank_bound_statement`

Deterministic trace / rank bridges:

- `matrixTrace_smul`
- `matrixTrace_le_of_matrixLE`
- `traceMatrixExp_le_trace_support_exp_lambdaMax_of_supportDomination` (preferred reader-facing name; the older `_of_matrixExp_le_smul_support` spelling remains as a compatibility alias)
- `traceMatrixExp_le_card_add_trace_support_mul_exp_sub_one_of_excessSupportDomination`
- `traceMatrixExp_eq_sum_exp_eigenvalues`
- `traceMatrixExp_smul_le_card_add_trace_div_mul_exp_sub_one_of_psd_lambdaMax_le`
- `matrixTrace_le_card_mul_of_isPSD_lambdaMaxOrdered_le`
- `matrixTrace_eq_rank_of_isStarProjection`

Generated-history centered rank-one consumers:

- `MatrixBernstein.CenteredRankOneExactRowInputs`
- `MatrixBernstein.centeredRankOneExactRow`
- `MatrixBernstein.sampleCovarianceExactRow`
- `MatrixBernstein.sampleCovarianceExactRowHighProbability`
- `iIndepFun_centeredRankOne`

Thin hardbone consumers:

- `bernsteinMatrixExp_le_quadratic_of_cfcChain`
- `bernsteinMatrixExp_le_quadratic_of_cfcLeaves`
- `bernsteinMatrixExp_le_quadratic`
- `matrixLog_le_of_le_matrixExp`
- `troppMasterTraceMGFStep_of_liebJensen`
- `troppConditionalStep_of_iIndepFun`
- `troppMasterTraceMGFConditionalStep_of_conditioningBridge`
- `traceMGFBernsteinVarianceProxyBound_of_conditioningBridge`
- `traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider`
- `varianceProxyNormBound_of_centeredSquareChain`
- `varianceProxyNormBound_of_centeredSquareChain_of_normMono`
- `deterministicMatrixVarianceProxyNorm_mono_of_matrixLE`
- `traceMatrixExp_le_rank_exp_lambdaMax`
- `traceMatrixExp_le_rank_exp_lambdaMax_of_isStarProjection`
- `traceMatrixExp_le_supportDim_exp_lambdaMax`
- `traceMatrixExp_excess_supportDim_exp_lambdaMax`
- `traceMatrixExp_effectiveRank_bound`
- `traceMatrixExp_effectiveRank_bound_of_ambientTraceCertificate`

Family-level proved/open status for these hardbone targets is maintained in
[`TheoremAtlas.md`](../reference/TheoremAtlas.md). See [`Status.md`](Status.md) for current
project focus, [`TODO.md`](../maintainers/TODO.md) for active work, and
[`RandomMatrixArchitecture.md`](../architecture/RandomMatrixArchitecture.md) for provider
ownership. The declaration lists above remain the endpoint index for callers.

## TraceExp / Tropp Bookkeeping Surface

- `traceMatrixExp_randomMatrixPrefixSum_last`
- `traceMatrixExp_comparisonMatrixPrefixSum_last`
- `troppTraceState`
- `troppStateHistory`
- `troppNaturalState_zero`
- `troppNaturalState_last`
- `troppNaturalState_left`
- `troppNaturalState_right`
- `troppTraceExpFiniteFamilyIterationSkeleton_of_naturalStateConditionalSteps`
- `troppMasterTraceMGFFiniteFamily_of_naturalStateConditionalSteps`
- `traceMGFBernsteinVarianceProxyBound_of_naturalStateConditionalSteps`
- `troppMasterTraceMGFFiniteFamily_statement_of_reindexedFin`

The two trace-exp wrappers convert final prefix endpoints into the state
equation shapes used by the conditional-step route. The reindex bridge
transports an existing `Fin (Fintype.card I)` Tropp finite-family statement to
an arbitrary finite index type; it does not prove that primitive.

The natural-state route fixes the `Fin m` state, history, and current-step
objects to the prefix/suffix construction and discharges the raw endpoint
equalities. Separately, `TraceExpConditioning.troppStep_of_history_le` closes
the exact conditional-step contract whenever
`mHist <= MeasurableSpace.comap H _`, using the contract's own `IndepFun H Z`
premise and an explicit `TraceExpTroppFrozenBoundInputs` packet. For the
standard Bernstein current step,
`TraceExpConditioning.bernsteinStep_of_history_le` constructs that packet from
centeredness, integrability, the pointwise operator-norm bound, and the Bernstein
parameter range. It does not remove the exact statement's `IndepFun` premise.
History measurability, arbitrary-larger-history independence, trace-exp
integrability, log/K, CFC, and variance-proxy obligations remain separate.

Use the core wrappers from:

```lean
import HighDimProb.RandomMatrix
-- or, for the narrower module:
import HighDimProb.RandomMatrix.TraceExp
```

Use the examples from:

```lean
import HighDimProb.Examples.RandomMatrix.StatementRoutes
```

`StatementRoutes` is the preferred reader entry point. It imports a small set of focused route examples and avoids exposing every intermediate bridge as a separate public example.


Provider-compression APIs:

- `LogResolvent.trace_mul_derivSAAt_eq_cutoffKernel_add_remainder`
- `LogResolvent.trace_mul_lineDeriv_eq_cutoffKernel_add_remainder`
- `LogResolvent.derivSAAtCutoffRemainder_eq_sum_conjDiagonal`
- `LogResolvent.derivSAAtCutoffRemainder_eq_sum_inv_sub_kernel_conjDiagonal_of_strictlyPositive`
- `LogResolvent.SameEigenbasisDiagonal`
- `LogResolvent.scalarSquareKernelIntegral`
- `LogResolvent.scalarSquareKernelRemainderTendstoZero`
- `LogResolvent.sameEigenbasisCutoffRemainderTendstoZero`
- `indepFun_of_history_entry_measurable_of_indep`
- `historyCondExp_ae_eq_frozenParameterIntegral_of_indepFun`
- `historyCondExp_le_of_indepFun_under_uniform_bound`
- `condExp_le_of_indep_sigma_under_frozen_bound`
- `condExp_traceExp_history_add_independent_step_of_indep_sigma`
- `TraceExpTroppFrozenBoundInputs`
- `TraceExpConditioning.troppStep_of_history_le`
- `TraceExpConditioning.condExpStep_of_history_le`
- `TraceExpConditioning.bernsteinInputs_of_primitives`
- `TraceExpConditioning.bernsteinStep_of_history_le`
- `trace_mul_mono_right_of_matrixLE_of_isPSDMatrix`
- `trace_mul_inv_add_const_convex_combo_le`
- `matrixExpExcessSupportDomination_of_supportDomination_of_support_le_one`
- `matrixExpExcessSupportDomination_identity`
- `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint`
- `matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions_tailSubsetDischarged_of_randomSelfAdjoint`

These are provider-compression APIs. They remove local bookkeeping and selected
tail, support, and conditioning premises. The focused `LiebProvider` facade
separately closes the finite-dimensional left/right Lieb/Epstein route and
Golden--Thompson; `MatrixBernsteinProvider` closes generated-history endpoints
under explicit primitives. These compression names do not by themselves remove
arbitrary-history conditional expectation, automatic variance-proxy
normalization, or produce unconditional full Matrix Bernstein.

## Sample Covariance Surface

Preferred compact bounded-row route:

- `SampleCovarianceTailTarget`
- `SampleCovarianceTailTarget.event`
- `SampleCovarianceTailTarget.rhs`
- `SampleCovarianceBoundedRowTroppAssumptions`
- `sampleCovariance_tail_optimized_under_boundedRowTroppAssumptions`

Use the compact theorem with target
`SampleCovarianceTailTarget.quadraticFormUpper` or
`SampleCovarianceTailTarget.selfAdjointOperatorNorm`. This keeps the target axis
explicit without publishing a separate recommended theorem name for every
combination of target, sign, CFC route, negative adapter, and provider route.
The compact record is the full bounded-row Tropp route: it exposes the common
row assumptions and the remaining negative-side Tropp/integrability providers,
but it does not include a finite-family tail conclusion as a field.

Advanced bridge-layer routes also expose exact-row centered-square infrastructure.
Those declarations connect generic centered-square variance-proxy chains and
negative-family transfer adapters to sample-covariance wrappers. They are public
proof infrastructure for later provider compression, not a replacement for the
compact reader-facing bounded-row route.

Lower-level compatibility wrappers remain available when a proof needs fewer
assumptions or a more explicit proof boundary:

- `sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy`
- `sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy_of_troppPrimitive`
- `sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound`
- `sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound_of_troppPrimitive`
- `sampleCovariance_quadraticForm_tail_optimized_under_exactRowSqNorm_bound_of_troppPrimitive`
- `sampleCovariance_quadraticForm_tail_optimized_under_exactRowSqNorm_bound_of_centeredSquareChain_of_troppPrimitive`
- `SampleCovarianceExactRowCenteredSquareTroppAssumptions`
- `sampleCovariance_quadTail_centeredSq_exactRow_of_tropp`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_exactRowSqNorm_bound_with_neg_square_adapters_of_troppPrimitives`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_exactRowSqNorm_bound_with_neg_square_adapters_of_centeredSquareChain_of_troppPrimitives`
- `SampleCovarianceExactRowCenteredSquareTwoSidedTroppAssumptions`
- `sampleCovariance_opNormTail_centeredSq_exactRow_of_tropp`
- `sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_under_explicit_variance_proxy`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_explicit_variance_proxy`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_square_adapters_of_troppPrimitives`

These wrappers still require Tropp/Lieb trace-MGF primitives and analytic
integrability assumptions. The CFC-free wrappers remove the user-supplied
pointwise Bernstein CFC fields by applying `bernsteinMatrixExp_le_quadratic`.
The exact-row quadratic-form wrapper additionally removes the direct
`MatrixVarianceProxyNormBound` premise on the positive-side route by using the
hardbone exact-row consumer; it keeps the hardbone sharp-variance chain explicit
and separates the uniform Bernstein radius from the row-specific variance-proxy
radii. These wrappers do not prove Tropp/Lieb, Golden-Thompson, trace-exp
integrability, variance-proxy control beyond existing named adapters, or
unconditional sample-covariance concentration.

### Sample covariance negative-side provider adapters

- `centeredSampleCovarianceRowRankOneFamilyNeg_expIntegrable_of_expIntegrable_neg_theta`
- `centeredSampleCovarianceRowRankOneSumNeg_traceExpIntegrable_of_traceExpIntegrable_neg_theta`
- `centeredSampleCovarianceRowRankOneFamilyNeg_cfcPrimitive_of_cfcPrimitive_neg_theta`

These are sign-normalization adapters from explicit original-family
opposite-parameter provider assumptions. They do not prove exponential
integrability, trace-exponential integrability, or the Bernstein CFC primitive,
and they are not tail wrappers by themselves.

## Variance Proxy Surface

- `integrableRandomMatrix_const_mul`
- `integrableRandomMatrix_mul_const`
- `matrixExpect_const_mul`
- `matrixExpect_mul_const`
- `randomMatrixSquare_centeredRandomMatrix_expand`
- `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_integrable_four_products`
- `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_memLp_four`
- `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_sqNorm_bound_memLp_two`
- `integrableRandomMatrix_randomMatrixSquare_centeredRandomMatrix`
- `integrableRandomMatrix_randomMatrixSquare_centeredRankOneRandomMatrixFamily_of_memLp_four`
- `integrableRandomMatrix_randomMatrixSquare_centeredRankOneRandomMatrixFamily_of_sqNorm_bound_memLp_two`
- `matrixSecondMoment_centeredRandomMatrix`
- `deterministicMatrixVarianceProxyNorm_sum_le_sum`
- `deterministicMatrixVarianceProxyNorm_matrixSecondMoment_rankOneRandomMatrix_le_sq_of_sqNorm_bound`
- `deterministicMatrixVarianceProxyNorm_sum_matrixSecondMoment_rankOneRandomMatrix_le_sum_sq_of_sqNorm_bound`
- `sampleCovarianceVarianceProxy_sharp_of_exactRowSqNorm_bound_memLp_two`
- `MatrixVarianceProxyNormBound_of_pointwiseOperatorNormBound`
- `MatrixVarianceProxyNormBound_centeredRankOneRandomMatrixFamily_of_sqNorm_bound`
- `MatrixVarianceProxyNormBound_centeredRankOneRandomMatrixFamily_of_sqNorm_bound_memLp_two`
- `MatrixVarianceProxyNormBound_centeredSampleCovarianceRowRankOneFamily_of_rowSqNorm_bound`
- `sampleCovarianceCenteredRankOneVarianceProxyBound`

## LoRA Covariance Application Surface

The focused import
`HighDimProb.Examples.RandomMatrix.LoRAAdapterSubspaceCovarianceUsage` exposes:

- `loraEmpiricalCovariance`
- `loraMeanCovariance`
- `loraCovarianceDeviation`
- `loraEmpiricalCovariance`_sub_mean
- `loraCovariance_normalizedTail`
- `loraCovarianceRadius`
- `loraCovariance_highProbability`
- `loraCovariance_matrixLESandwich`

For a positive batch size m, adapter dimension r + 1, squared-norm radius R,
and epsilon >= 0, the normalized tail wrapper states

    P(||SigmaHat_Q - SigmaBar_Q|| >= epsilon)
      <= 2 (r + 1) exp(-m epsilon^2 / (8 R^2 + (4/3) R epsilon)).

This is the exact consequence of the generic centered rank-one variance
proxy `4 m R^2`. It gives the expected
R * (sqrt(log((r + 1)/delta) / m) + log((r + 1)/delta) / m) rate and the
Loewner sandwich around `loraMeanCovariance`. It does not claim the sharper
`m R^2` rank-one proxy; that separate improvement is required to match the
smaller square-root constant.

## Example Style

- Use `StatementRoutes` as a build-checked index of theorem-family routes before importing a focused example module.

- Name matrix families before using them in public wrappers.
- Prefer named adapters over anonymous lambdas.
- Prefer the sample-covariance `_of_troppPrimitive` / `_of_troppPrimitives`
  wrappers when pointwise Bernstein CFC is the only remaining explicit field.
- Keep positive-side and negative-side assumptions visibly distinct when the
  theorem still needs both sides.
- Put domain vocabulary in examples as thin wrappers over the core RandomMatrix
  API, not as separate theorem machinery.
- Use `StatementRoutes` first. Low-level prefix/state, reindex, and negative-family bridge APIs are covered by source, tests, and judge files rather than separate reader-facing examples.

## Expert And Internal Provider Layers

The public concentration facade is the caller endpoint and re-exports the
provider concentration assembly:

```lean
import HighDimProb.RandomMatrix.Concentration
```

Import the following implementation layers only for provider-proof development:

```lean
import HighDimProb.RandomMatrix.Provider.Analysis
import HighDimProb.RandomMatrix.Provider.Conditioning
import HighDimProb.RandomMatrix.Provider.Concentration
```

Import the narrowest provider layer needed by the proof. The broad
`HighDimProb.RandomMatrix.Provider` facade imports all three;
`HighDimProb.RandomMatrix.LiebProvider` remains a compatibility import. The
full ownership and dependency contract is in
[`RandomMatrixArchitecture.md`](../architecture/RandomMatrixArchitecture.md).

The analysis layer exposes ambient and self-adjoint
matrix-exp derivatives, first-order strictly-positive `CFC.log` affine-line
APIs, short inverse/trace-resolvent derivatives, finite-cutoff log-resolvent
identities, inverse-convexity segment/`MatrixLE` identities, full-matrix-Klein
relative-entropy APIs, the fixed-`t` left/right relative-entropy integrand
joint-convexity leaf, the left/right scalar, quadratic, spectral-overlap,
density, and integral-representation route to relative-entropy joint convexity
and Lieb/Epstein facades, the exact `goldenThompsonTraceExp` endpoint,
conditional relative-entropy/Gibbs bridges, derivative-level Epstein consumers,
trace-exp domain positivity, CFC-log resolvent cutoff/remainder bridges, and
fixed-numerator trace-resolvent convexity.

The conditioning layer exposes frozen-parameter conditional expectation,
independent-step trace-exponential conditioning, and natural-history
measurability and independence bridges. The concentration provider assembles
the conditional and left/right Tropp/Lieb bridges, integrability compression,
generated-history Bernstein finite-family/trace-MGF/tail wrappers, canonical
operator-norm/high-probability endpoints, support-to-excess compression, and
tail-event subset-discharge wrappers. These implementation surfaces are
re-exported for downstream use by `HighDimProb.RandomMatrix.Concentration`.

Matrix-exp and divided-difference API:

- `matrixExpFDeriv`
- `hasFDerivAt_matrix_exp`
- `hasStrictFDerivAt_matrix_exp`
- `hasFDerivAt_matrix_exp_trunc`
- `matrixExpSelfAdjoint`
- `matrixExpFDerivSelfAdjoint`
- `matrixExpFDerivSelfAdjoint_spectral_equiv`
- `hasFDerivAt_matrix_exp_selfAdjoint`
- `hasStrictFDerivAt_matrix_exp_selfAdjoint`
- `matrixExpDividedDifferenceSeries`
- `matrixExpDividedDifferenceSeries_pos`
- `matrixExpDividedDifferenceSeries_ne_zero`
- `matrixQuadraticForm_integrable_of_integrableRandomMatrix`
- `matrixQuadraticForm_eq_star_dotProduct_mulVec`
- `matrixExp_isStrictlyPositive_of_selfAdjoint`
- `isStrictlyPositive_matrixExpect_matrixExp_of_randomSelfAdjoint`

Preferred spectral adapter aliases:

- `MatrixExpFDeriv.conjDiagonalSymmTraceSum`

Backing low-level theorem names, kept for exact proof work and compatibility:

- `matrixExpFDerivSelfAdjoint_diagonal_symm_entry_mul`
- `trace_mul_matrixExpFDerivSelfAdjoint_conj_diagonal_symm_eq_sum`

Strictly-positive `CFC.log` derivative API:

- `cfcLogSelfAdjoint`
- `CFCLog.Carrier`
- `CFCLog.DerivOp`
- `CFCLog.derivSAAt`
- `CFCLog.hasStrictFDerivAt_derivSAAt`
- `CFCLog.lineDeriv`
- `CFCLog.lineDeriv_one_zero`
- `CFCLog.hasDerivAt_line`
- `exists_hasDerivAt_cfcLog_affineLine_of_strictlyPositive`
- `hasDerivAt_cfcLog_affineLine_of_strictlyPositive`

Preferred diagonal and trace-paired spectral adapter aliases:

- `CFCLog.diagonalDerivEntryMul`
- `CFCLog.diagonalLineDerivEntryMul`
- `CFCLog.diagonalLineDerivTraceSum`

Backing low-level theorem names, kept for exact proof work and compatibility:

- `CFCLog.derivSAAt_matrixExpSelfAdjoint_diagonal_entry_mul`
- `CFCLog.lineDerivSA_matrixExpSelfAdjoint_diagonal_entry_mul`
- `CFCLog.trace_mul_lineDerivSA_matrixExpSelfAdjoint_diagonal_eq_sum`

Resolvent and finite-cutoff log-resolvent API:

- `hasDerivAt_inverse_affineLine`
- `hasDerivAt_inverse_affineLine_of_strictlyPositive`
- `trace_resolvent_derivative_cycle`
- `neg_trace_resolvent_derivative_cycle`
- `hasDerivAt_trace_mul_inverse_affineLine_general`
- `hasDerivAt_trace_mul_inverse_affineLine_general_neg_cycle`
- `hasDerivAt_trace_mul_inverse_affineLine_general_of_strictlyPositive`
- `hasDerivAt_trace_mul_inverse_affineLine_general_neg_cycle_of_strictlyPositive`
- `hasDerivAt_trace_mul_inverse_affineLine`
- `hasDerivAt_trace_mul_inverse_affineLine_of_strictlyPositive`
- `LogResolvent.kernelFixedSum`
- `LogResolvent.kernelCutoffSum`
- `LogResolvent.shiftedInvTraceSum`
- `LogResolvent.identityCutoffSum`
- `LogResolvent.identityCutoffTraceLogSub`
- `LogResolvent.weightedCutoffSum`
- `LogResolvent.weightedCutoffTraceLogSub`
- `LogResolvent.weightedTraceLogEqShiftSubCutoff`
- `LogResolvent.weightedShiftTraceLogSubScalarLog_tendsto_zero`
- `LogResolvent.weightedCutoffSubScalarLog_tendsto_negTraceLog`
- `LogResolvent.weightedShiftRemainderTendstoZero`
- `LogResolvent.weightedCutoffRenormTendstoNegTraceLog`
- `LogResolvent.SameEigenbasisDiagonal`
- `LogResolvent.scalarSquareKernelIntegral`
- `LogResolvent.scalarSquareKernelRemainderTendstoZero`
- `LogResolvent.sameEigenbasisCutoffRemainderTendstoZero`

The `SameEigenbasisDiagonal` predicate packages the repeated conjugation-to-diagonal
hypothesis. The final cutoff-removal theorem removes the explicit cutoff only for
that same-eigenbasis diagonal remainder exposed by
`CFCLogResolventRemainderProvider`; it does not prove the general two-index
weighted cutoff limit.

Inverse-convexity positive-definite segment API:

- `inv_quadraticForm_affine_le_of_posDef`
- `inv_quadraticForm_iSup_affine_of_posDef`
- `convexCombo_posDef_of_posDef`
- `inv_quadraticForm_convex_combo_le_of_posDef`
- `inv_matrixLE_convex_combo_le_of_posDef`

These are quadratic-form variational and segment identities for positive
definite matrices, including the explicit `MatrixLE` packaging. They do not
prove full operator convexity of inverse or relative-entropy joint convexity.

Relative-entropy route API:

- `inversePerspectiveBlock_posSemidef`
- `inversePerspective_jointConvex`
- `trace_inversePerspective_jointConvex`
- `RelativeEntropy.tracePairedInversePerspectiveIntegrand`
- `RelativeEntropy.tracePairedInversePerspectiveIntegrand_jointConvex`
- `RelativeEntropy.leftRightDenominatorMatrix`
- `RelativeEntropy.leftRightDenominatorMatrix_posDef`
- `RelativeEntropy.leftRightDenominatorMatrix_affine`
- `RelativeEntropy.leftRightRelativeEntropyIntegrand`
- `RelativeEntropy.leftRightRelativeEntropyIntegrand_jointConvex`
- `RelativeEntropy.real_log_perspective_integral`
- `RelativeEntropy.real_relativeEntropy_integral_representation`
- `RelativeEntropy.real_relativeEntropy_integral_representation_density`
- `RelativeEntropy.real_relativeEntropy_integrand_integrableOn`
- `RelativeEntropy.rowMatrixOfVec`
- `RelativeEntropy.trace_rowMatrixOfVec_mul_mul_conjTranspose`
- `RelativeEntropy.leftRightRelativeEntropyIntegrand_eq_rowTrace`
- `RelativeEntropy.leftRightRelativeEntropyIntegrand_eq_quadratic`
- `RelativeEntropy.leftRightRelativeEntropyIntegrand_posDef_spectral`
- `RelativeEntropy.posDef_spectral_difference_twoSided_entries`
- `RelativeEntropy.leftRightRelativeEntropyIntegrand_posDef_spectral_overlap`
- `RelativeEntropy.traceMatrixRelativeEntropyPlain`
- `RelativeEntropy.relativeEntropyUnnormalized_eq_traceMatrixRelativeEntropyPlain`
- `TraceMatrixRelativeEntropyPlainJointConvexity`
- `relativeEntropyJointConvexity_of_traceMatrixRelativeEntropyPlain_jointConvex`
- `LeftRightRelativeEntropyIntegrandDensityIntegrable`
- `TraceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation`
- `leftRightRelativeEntropyIntegrandDensityIntegrable`
- `traceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation`
- `traceMatrixRelativeEntropyPlain_jointConvex_of_leftRight_density_integral_representation`
- `relativeEntropyJointConvexity_of_leftRight_density_integral_representation`
- `traceMatrixRelativeEntropyPlain_jointConvex_of_leftRight`
- `relativeEntropyJointConvexity_of_leftRight`
- `RelativeEntropy.fullKlein_liebCarrierConcavity_of_leftRight_density_integral_representation`
- `RelativeEntropy.fullKlein_liebConcavity_of_leftRight_density_integral_representation`
- `RelativeEntropy.fullKlein_epsteinConcavity_of_leftRight_density_integral_representation`
- `liebTraceExpConcavity_statement_of_leftRight_density_integral_representation`
- `epsteinAffineLineConcavity_of_leftRight_density_integral_representation`
- `RelativeEntropy.fullKlein_liebCarrierConcavity_of_leftRight`
- `RelativeEntropy.fullKlein_liebConcavity_of_leftRight`
- `RelativeEntropy.fullKlein_epsteinConcavity_of_leftRight`
- `liebTraceExpConcavity_statement_of_leftRight`
- `epsteinAffineLineConcavity_of_leftRight`
- `RelativeEntropy.scalarTerm`
- `RelativeEntropy.diagonalTerm`
- `RelativeEntropy.diagonalMatrixTerm`
- `RelativeEntropy.diagonalMatrixTerm_cfcLog_nonneg`
- `RelativeEntropy.weightedSpectralKlein_nonneg`
- `RelativeEntropy.fullMatrixKlein_nonneg_of_isHermitian_of_strictlyPositive`
- `RelativeEntropy.kleinInequality_relativeEntropy_nonneg`
- `kleinInequality_relativeEntropy_nonneg`
- `RelativeEntropy.logShift`
- `RelativeEntropy.expLogMatrix`
- `RelativeEntropy.carrierGibbs_le_traceMatrixExp_of_kleinPremise`
- `RelativeEntropy.carrierGibbs_eq_traceMatrixExp_at_matrixExp_logPoint`
- `RelativeEntropyJointConvexity`
- `GibbsKleinPremise`
- `gibbsVariationalUpperBoundPremise_of_fullMatrixKlein`
- `RelativeEntropy.fullKlein_liebCarrierConcavity`
- `RelativeEntropy.fullKlein_liebConcavity`
- `RelativeEntropy.fullKlein_epsteinConcavity`
- `epsteinAffineLineConcavity_of_liebTraceExpConcavity_selfAdjointCarrier`

These expose the finite-dimensional inverse-perspective leaf behind the
fixed-`t` left/right relative-entropy integrand, scalar/diagonal Klein
nonnegativity, full finite-dimensional matrix Klein under Hermitian
strictly-positive hypotheses, Gibbs/full-Klein bridge adapters, the proved
left/right density/integral representation, unconditional relative-entropy
joint convexity, and the resulting Lieb/Epstein facades. Tropp one-step
wrappers are exposed below. The separate identity-tangent consumer now proves
Golden--Thompson; the conditional-expectation step for arbitrary larger
histories, automatic variance-proxy normalization, tail-event domination, and
unconditional full Matrix Bernstein remain separate.

Golden--Thompson endpoint:

- `CFCLog.lineDeriv_one_zero`
- `goldenThompsonTraceExp`

Epstein/Tropp conditional consumers and support APIs:

- `cfcLogLineDerivTraceSecond`
- `EpsteinLine.traceSlope`
- `EpsteinLine.traceSecond`
- `EpsteinLine.hasDerivAt_traceSlope_of_lineDerivSA`
- `EpsteinLine.hasDerivAt_traceSlope_of_hasDerivAt_eval`
- `EpsteinLine.concavity_of_traceSecond_nonpos_of_lineDerivSA`
- `EpsteinLine.concavity_of_traceSecond_nonpos_of_eval`
- `matrixLog_le_of_le_matrixExp_of_providerLogMonotone`
- `troppLogExpComparisonToK_of_providerLogOrder`
- `EpsteinAffineLineConcavity`
- `liebTraceExpConcavity_of_epsteinAffineLine`
- `liebJensenTraceExp_statement_of_epsteinAffineLine`
- `troppMasterTraceMGFStep_of_epsteinAffineLine`
- `troppMasterTraceMGFStep_trace_bound_of_epsteinAffineLine_and_providerLogOrder`
- `troppMasterTraceMGFStep_of_leftRight`
- `troppLiebJensenChain_of_leftRight` (legacy compatibility)
- `troppMasterTraceMGFStep_trace_bound_of_leftRight_and_providerLogOrder`
- `TroppNaturalHistory.suffixMeasurable`
- `TroppNaturalHistory.historyStepIndependent`
- `troppNaturalHistoryMeasurable_of_suffix_entry_measurable`
- `troppHistoryStepIndependent_of_iIndepFun_of_measurable`
- `TraceExpTroppFrozenBoundInputs`
- `TraceExpConditioning.troppStep_of_history_le`
- `TraceExpConditioning.condExpStep_of_history_le`
- `TraceExpConditioning.bernsteinInputs_of_primitives`
- `TraceExpConditioning.bernsteinStep_of_history_le`
- `matrixExpScaledIntegrable_of_provider_finiteMeasure`
- `isSelfAdjointMatrix_matrixExpect_matrixExp_troppCurrentRandomStep_of_centeredSelfAdjoint`
- `isStrictlyPositive_matrixExpect_matrixExp_troppCurrentRandomStep_of_centeredSelfAdjoint`
- `traceExpIntegrable_troppStateHistory_add_step_of_operatorNormBounds_finiteMeasure`
- `traceExpIntegrable_troppStateHistory_add_K_of_operatorNormBounds_finiteMeasure`
- `troppCurrentRandomStep_operatorNorm_le_of_summand_bound`
- `troppStateHistory_operatorNorm_le_of_summand_and_comparison_bounds`
- `traceExpIntegrable_troppStateHistory_add_step_of_summand_and_comparison_bounds_finiteMeasure`
- `traceExpIntegrable_troppStateHistory_add_K_of_summand_and_comparison_bounds_finiteMeasure`
- `traceExpIntegrable_randomMatrixSum_of_operatorNormBounds_finiteMeasure`
- `lambdaMaxOrdered_le_of_matrixLE_selfAdjoint`
- `lambdaMinOrdered_le_of_matrixLE_selfAdjoint`
- `traceMGFBernsteinVarianceProxyBoundLIntegral_of_real`
- `matrixBernsteinTraceMGFToLaplaceContract`
- `matrixBernsteinTraceMGFToLaplaceContract_under_primitives`
- `MatrixBernsteinConditioningTraceMGFProviderAssumptions`
- `MatrixBernsteinConditioningTraceMGFProviderAssumptions.toTailAssumptions`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFProviderAssumptions`
- `matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions`

Interface audit: `CFCLog.DerivOp` is pointwise derivative bookkeeping only, not a
stable second-level Frechet codomain. The inverse-convexity API now includes
positive-definite segment and `MatrixLE` packaging, and the relative-entropy
route includes fixed-`t` left/right integrand joint convexity, full matrix
Klein, the proved density/integral representation, unconditional
relative-entropy joint convexity, unconditional Lieb/Epstein facades, and the
left/right Tropp one-step wrappers. The
`LogResolvent` layer gives spectral sum, CFC-log cutoff, and renormalized
cutoff-limit handles; it does not yet give a weighted `CFCLog.lineDeriv` /
`CFCLog.derivSAAt` resolvent-kernel adapter or the alternative Epstein sign
proof. The provider layer now closes Golden--Thompson through
`goldenThompsonTraceExp`; exact conditioning expectation for arbitrary
larger histories, automatic variance-proxy normalization, and unconditional
full Matrix Bernstein remain open. Self-adjoint quadratic-form tail subset
discharge is available through the TailEvent provider wrappers.
It is intentionally separate from reader-facing examples and the core
`HighDimProb.RandomMatrix` aggregate.
