# RandomMatrix Matrix Bernstein API

This is the current compact API index. Old historical notes were collapsed into
[`archive.md`](archive.md); use git history for exact old wording.

## Core Modules

- [`Basic.lean`](../HighDimProb/RandomMatrix/Basic.lean)
- [`Assumptions.lean`](../HighDimProb/RandomMatrix/Assumptions.lean)
- [`Sums.lean`](../HighDimProb/RandomMatrix/Sums.lean)
- [`OperatorNorm.lean`](../HighDimProb/RandomMatrix/OperatorNorm.lean)
- [`Spectral.lean`](../HighDimProb/RandomMatrix/Spectral.lean)
- [`TraceExp.lean`](../HighDimProb/RandomMatrix/TraceExp.lean)
- [`TraceExpDerivative.lean`](../HighDimProb/RandomMatrix/TraceExpDerivative.lean)
- [`TraceExpMonotonicity.lean`](../HighDimProb/RandomMatrix/TraceExpMonotonicity.lean)
- [`HardboneStatements.lean`](../HighDimProb/RandomMatrix/HardboneStatements.lean)
- [`CStarBridge.lean`](../HighDimProb/RandomMatrix/CStarBridge.lean)
- [`VarianceProxy.lean`](../HighDimProb/RandomMatrix/VarianceProxy.lean)
- [`ConcentrationStatements.lean`](../HighDimProb/RandomMatrix/ConcentrationStatements.lean)

## Shared Helpers

- `matrixBernsteinOptimizedScalarTailRHS`
- `matrixBernsteinTwoSidedOptimizedScalarTailRHS`
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

## Matrix Bernstein Surface

- `matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives`
- `matrixBernsteinTraceMGF_under_tropp`
- `matrixBernsteinQuadTail_trace_under_tropp`
- `matrixBernsteinQuadTail_scalar_under_tropp`
- `matrixBernsteinQuadTail_opt_under_tropp`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge`
- `MatrixBernsteinConditioningTraceMGFTailAssumptions`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFTailAssumptions`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions`
- `matrixBernsteinQuadTail_opt_of_tropp`
- `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`
- `matrixBernsteinQuadTail_twoSided_opt_of_tropp`
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_pos_under_primitives`
- `matrixBernsteinOpNormTail_opt_of_tropp`

These are under explicit primitive assumptions. The pointwise Bernstein CFC
primitive is now proved by `bernsteinMatrixExp_le_quadratic`; the
`under_troppPrimitive` trace-MGF wrapper uses that proof so callers no longer
pass pointwise CFC at the trace-MGF provider layer. The preferred optimized
public surface is the `*_of_troppAssumptions` family, which uses
`MatrixBernsteinPositiveSideTroppAssumptions` and
`MatrixBernsteinNegativeSideTroppAssumptions` to expose Tropp/Lieb and
bookkeeping assumptions without a user-supplied CFC field. The older
`*_of_assumptions` and `_under_primitives` names remain compatibility surfaces.
The S10 conditioning-to-tail route also records the developer-facing scaffold
`MatrixBernsteinConditioningTraceMGFTailAssumptions` and the thin
`matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFTailAssumptions`
wrapper for provider-target bookkeeping. These names are not the preferred
reader-facing Matrix Bernstein API. The route still does not prove
Tropp/Lieb, Golden-Thompson, trace-exp integrability, variance-proxy control,
tail event domination, or a full unconditional Matrix Bernstein theorem. The conditioning-to-tail wrapper
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
- `matrixExpLogSelfAdjointNormalization_statement`
- `matrixExpLogSelfAdjointNormalization`
- `troppMasterTraceMGFStep_of_liebJensen_statement`

Conditioning / independence chain:

- `troppNaturalHistoryMeasurable_statement`
- `troppHistoryStepIndependent_of_iIndepFun_statement`
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

Hardbone status table:

| Statement family | Lean declaration | Status | Consumer | Remaining blocker |
|---|---|---|---|---|
| Scalar Bernstein hardbone leaf | `scalarBernsteinExpQuadraticInequality_statement` | proven by `scalarBernsteinExpQuadraticInequality` | CFC-chain assumptions can reuse the proved scalar theorem | none for this scalar leaf |
| Bernstein CFC | `bernsteinMatrixExp_le_quadratic_statement` | proven by `bernsteinMatrixExp_le_quadratic` | `bernsteinMatrixExp_le_quadratic_of_cfcLeaves` documents the reusable composition | preferred `*_of_troppAssumptions` wrappers bypass pointwise CFC fields; explicit-CFC wrappers remain for compatibility |
| Matrix log/order bridge | `matrixLog_le_of_le_matrixExp_statement` | proven by `matrixLog_le_of_le_matrixExp`; operator-log premise can now be supplied by `operatorLogMonotoneOnPositiveMatrices` | turns log-monotonicity and `matrixExp` log-domain premises into `log M <= K` | `matrixExp` log-domain is supplied by `matrixExpLogDomainForSelfAdjoint`; the wrapper intentionally keeps premises explicit |
| Real-to-CStar bridge | `realMatrixToCStarMatrix` and transport lemmas | representation map, add/sub, self-adjoint, strict positivity, order, log-back, and reflected order transport proved | supplies the CStar representation route used by `operatorLogMonotoneOnPositiveMatrices` | log-back is restricted to strictly positive self-adjoint real matrices |
| Log/order-to-`K` | `troppLogExpComparisonToK_statement` | proven by `troppLogExpComparisonToK` | direct deterministic comparison from `M <= matrixExp K` | still deterministic only; Lieb/Jensen, Golden-Thompson, conditioning, integrability, and variance-proxy inputs remain separate |
| Tropp/Lieb/GT one-step | `troppMasterTraceMGFStep_of_liebJensen_statement` | typed-prop | `troppMasterTraceMGFStep_of_liebJensen` | Lieb concavity, probability-measure Jensen, log-exp normalization; Golden-Thompson is separate |
| Conditioning / independence | `troppConditionalStep_of_iIndepFun_statement` | proven by `troppConditionalStep_of_iIndepFun` | `troppMasterTraceMGFConditionalStep_of_conditioningBridge`; `traceMGFBernsteinVarianceProxyBound_of_conditioningBridge` composes this route into the finite-family trace-MGF bound | thin forwarder/composer only; generated histories, history/current-step independence, finite-family independence, conditional expectation reduction, integrability, and variance-proxy inputs remain explicit premises |
| Trace-exp integrability | `traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider_statement` | typed-prop with proved thin consumer | `traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider` | automatic absolute domination, Golden-Thompson/product, or boundedness provider |
| Variance proxy / centered square | `varianceProxyNormBound_of_centeredSquareChain_statement`, `deterministicMatrixVarianceProxyNorm_mono_of_matrixLE_statement`, `matrixSquare_centeredRandomMatrix_expectation_expansion_statement`, `centeredRankOneSquare_le_rankOneSecondMoment_statement` | centered-square expectation expansion, finite-sum MatrixLE bookkeeping, PSD Loewner-to-operator-norm monotonicity, and centered rank-one second-moment comparison proved; typed-prop chain has proved thin consumers | `matrixSquare_centeredRandomMatrix_expectation_expansion`, `matrixSecondMoment_centeredRandomMatrix_le_matrixSecondMoment`, `centeredRankOneSquare_le_rankOneSecondMoment`, `varianceProxyNormBound_of_centeredSquareChain`, `deterministicMatrixVarianceProxyNorm_mono_of_matrixLE`, `varianceProxyNormBound_of_centeredSquareChain_of_normMono`, `varianceProxyNormBound_of_centeredSquareChain_expansion`, `sampleCovarianceVarianceProxy_sharp_of_rankOneSecondMoment`, `sampleCovarianceVarianceProxy_sharp_of_exactRowSecondMoment`, `deterministicMatrixVarianceProxyNorm_sum_le_sum`, `deterministicMatrixVarianceProxyNorm_matrixSecondMoment_rankOneRandomMatrix_le_sq_of_sqNorm_bound`, `deterministicMatrixVarianceProxyNorm_sum_matrixSecondMoment_rankOneRandomMatrix_le_sum_sq_of_sqNorm_bound`, `sampleCovarianceVarianceProxy_sharp_of_exactRowSqNorm_bound_memLp_two`, `sampleCovarianceVarianceProxy_sharp_statement_of_centeredSquareChain_exactRowSqNorm_bound_memLp_two`, `sampleCovarianceVarianceProxy_sharp_of_exactRowSqNorm_bound_memLp_two_of_centeredSquareChain`, `MatrixVarianceProxyNormBound_centeredSampleCovarianceRowRankOneFamilyNeg_of_exactRowSqNorm_bound_memLp_two`, exact-row centered-square sample-covariance wrappers and bundles, `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_integrable_four_products`, `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_memLp_four`, `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_sqNorm_bound_memLp_two`, `integrableRandomMatrix_randomMatrixSquare_centeredRankOneRandomMatrixFamily_of_memLp_four`, `integrableRandomMatrix_randomMatrixSquare_centeredRankOneRandomMatrixFamily_of_sqNorm_bound_memLp_two`, `MatrixVarianceProxyNormBound_centeredRankOneRandomMatrixFamily_of_sqNorm_bound_memLp_two` | full generic centered-square-chain providers, Tropp/Lieb, trace-MGF integrability, and full Matrix Bernstein remain explicit or open |
| Dimension / support / effective rank | `traceMatrixExp_le_rank_exp_lambdaMax_statement`, `traceMatrixExp_le_supportDim_exp_lambdaMax_statement`, `traceMatrixExp_effectiveRank_bound_statement`, `matrixExpSupportDomination_identity_statement`, `traceMatrixExp_excess_supportDim_exp_lambdaMax_statement` | rank/support targets and effective-rank consumer proved under explicit support, PSD, lambda-max, and trace-certificate assumptions; ambient trace certificate and star-projection rank/PSD consumer proved; identity support provider target named only; excess trace bridge and supportDim consumer proved under explicit excess certificate | `traceMatrixExp_le_rank_exp_lambdaMax`, `traceMatrixExp_le_rank_exp_lambdaMax_of_isStarProjection`, `traceMatrixExp_le_supportDim_exp_lambdaMax`, `traceMatrixExp_excess_supportDim_exp_lambdaMax`, `traceMatrixExp_effectiveRank_bound`, `traceMatrixExp_effectiveRank_bound_of_ambientTraceCertificate`; deterministic helpers include `MatrixExpSupportDomination`, `MatrixExpExcessSupportDomination`, `traceMatrixExp_le_card_add_trace_support_mul_exp_sub_one_of_excessSupportDomination`, `traceMatrixExp_eq_sum_exp_eigenvalues`, `traceMatrixExp_smul_le_card_add_trace_div_mul_exp_sub_one_of_psd_lambdaMax_le`, `matrixTrace_le_card_mul_of_isPSD_lambdaMaxOrdered_le`, `matrixTrace_eq_rank_of_isStarProjection`, `isPSDMatrix_of_isStarProjection` | identity/excess support-domination providers and support-construction certificates; true effective-rank trace certificate provider beyond ambient dimension |
| Thin consumers | `troppMasterTraceMGFConditionalStep_of_conditioningBridge`, `traceMGFBernsteinVarianceProxyBound_of_conditioningBridge` | proven | source/test/judge checks | thin developer-facing wrappers only; no hard fact is discharged |

Most hardbone declarations are typed `Prop` contracts, not hard theorem proofs.
The Bernstein CFC chain is now proved by `bernsteinMatrixExp_le_quadratic`
after splitting out scalar Bernstein, spectrum localization, CFC order
transfer, and expression normalization. The direct matrix log/order bridge is
proved by `matrixLog_le_of_le_matrixExp`; `operatorLogMonotoneOnPositiveMatrices`
supplies the operator-log premise, `traceMatrixExp_mono_add_selfAdjoint`
closes the downstream trace-exponential monotonicity leaf, and
`troppLogExpComparisonToK` now proves the deterministic log/order-to-`K` comparison.
The finite-family conditioning chain is proved by `troppConditionalStep_of_iIndepFun`,
but it only forwards explicit per-index providers. The separate theorem
`troppHistoryStepIndependent_of_iIndepFun_of_measurable` supplies
history/current-step independence from `iIndepFun X P` plus explicit summand
measurability, but the exact weaker independence statement and
conditional-expectation provider remain separate. The remaining
Tropp/Lieb, automatic trace-exp integrability, variance-proxy,
and dimension/rank blockers stay split into named leaves. The rank/support
trace-bound bridge is proved under the named support-domination certificate
`MatrixExpSupportDomination` and explicit support trace assumptions. The
projection trace/rank certificate
`matrixTrace_eq_rank_of_isStarProjection` is available when the caller already
has an explicit `IsStarProjection support`; the thin consumer
`traceMatrixExp_le_rank_exp_lambdaMax_of_isStarProjection` now routes that
certificate together with `isPSDMatrix_of_isStarProjection` into the rank-bound
theorem. What remains open is proving providers for
`MatrixExpSupportDomination`, constructing support matrices for specific
applications, and proving true effective-rank trace certificates beyond the
ambient cardinality fallback. The provider frontier is split between the ambient
identity target `matrixExpSupportDomination_identity_statement` and the corrected
excess-support target `traceMatrixExp_excess_supportDim_exp_lambdaMax_statement`.
The deterministic bridge
`traceMatrixExp_le_card_add_trace_support_mul_exp_sub_one_of_excessSupportDomination`
and consumer `traceMatrixExp_excess_supportDim_exp_lambdaMax` are proved under
explicit excess certificate, trace support-dimension, and nonnegative
coefficient assumptions. The support/excess providers themselves remain open.
The rank and effective-rank trace-exp targets keep `MatrixExpSupportDomination`,
`MatrixExpExcessSupportDomination`, lambda-max, or trace-certificate assumptions explicit; the ambient certificate
only gives the `(n + 1 : Real)` effective-rank parameter, so zero directions are
not accidentally treated as free. The thin consumers only apply explicit
statement-chain assumptions; they do not prove Lieb/Jensen, conditional
expectation reduction, automatic domination, variance-proxy control,
finite-family Tropp, or any Matrix Bernstein tail theorem.

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
equalities. It remains a TraceExp-level bridge: conditional-step analytic,
history measurability, independence, trace-exp integrability, log/K, CFC, and
variance-proxy assumptions remain explicit.

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


Recent provider-compression APIs:

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
- `trace_mul_mono_right_of_matrixLE_of_isPSDMatrix`
- `trace_mul_inv_add_const_convex_combo_le`
- `matrixExpExcessSupportDomination_of_supportDomination_of_support_le_one`
- `matrixExpExcessSupportDomination_identity`
- `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint`
- `matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions_tailSubsetDischarged_of_randomSelfAdjoint`

These are proof-provider APIs. They remove local bookkeeping and selected tail/support/conditioning premises, but they do not prove full Lieb, full Tropp, Golden-Thompson, variance-proxy normalization, or full Matrix Bernstein.
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

## Provider-Facing Lieb/Tropp Layer

Use this layer explicitly, not through the core `HighDimProb.RandomMatrix` aggregate:

```lean
import HighDimProb.RandomMatrix.LiebProvider
```

This import exposes the upstream provider facade: ambient and self-adjoint
matrix-exp derivatives, first-order strictly-positive `CFC.log` affine-line
APIs, short inverse/trace-resolvent derivatives, finite-cutoff log-resolvent
identities, inverse-convexity segment/`MatrixLE` identities, full-matrix-Klein
relative-entropy APIs, the fixed-`t` left/right relative-entropy integrand
joint-convexity leaf, the left/right scalar, quadratic, spectral-overlap,
density, and integral-representation route to relative-entropy joint convexity
and Lieb/Epstein facades, conditional relative-entropy/Gibbs bridges,
derivative-level Epstein consumers, conditional and left/right Tropp/Lieb
bridges, CFC-log resolvent cutoff/remainder bridges, conditioning-kernel
reductions over `MeasurableSpace.comap H`, fixed-numerator trace-resolvent
convexity, support-to-excess compression, and tail-event subset-discharge
wrappers.

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
wrappers are exposed below. This layer still does not prove Golden-Thompson,
the conditional-expectation step, variance-proxy normalization, tail-event
domination, or full Matrix Bernstein.

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
- `troppMasterTraceMGFStep_trace_bound_of_leftRight_and_providerLogOrder`
- `TroppNaturalHistory.suffixMeasurable`
- `TroppNaturalHistory.historyStepIndependent`
- `troppNaturalHistoryMeasurable_of_suffix_entry_measurable`
- `troppHistoryStepIndependent_of_iIndepFun_of_measurable`
- `matrixExpScaledIntegrable_of_provider_finiteMeasure`
- `traceExpIntegrable_troppStateHistory_add_step_of_operatorNormBounds_finiteMeasure`
- `traceExpIntegrable_troppStateHistory_add_K_of_operatorNormBounds_finiteMeasure`
- `troppCurrentRandomStep_operatorNorm_le_of_summand_bound`
- `troppStateHistory_operatorNorm_le_of_summand_and_comparison_bounds`
- `traceExpIntegrable_troppStateHistory_add_step_of_summand_and_comparison_bounds_finiteMeasure`
- `traceExpIntegrable_troppStateHistory_add_K_of_summand_and_comparison_bounds_finiteMeasure`
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
`CFCLog.derivSAAt` resolvent-kernel adapter or an Epstein sign proof. The
provider layer still stops short of Golden-Thompson, exact conditioning expectation,
variance-proxy normalization or full Matrix Bernstein. Self-adjoint quadratic-form tail subset discharge is now available through the TailEvent provider wrappers.
It is intentionally separate from reader-facing examples and the core
`HighDimProb.RandomMatrix` aggregate.
