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
- [`HardboneStatements.lean`](../HighDimProb/RandomMatrix/HardboneStatements.lean)
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

Use these helpers in examples and tests instead of copying RHS formulas.

## Matrix Bernstein Surface

- `matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives`
- `matrixBernsteinTraceMGFWithBernsteinCoeff_under_troppPrimitive`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_of_troppAssumptions`
- `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`
- `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_of_troppAssumptions`
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_pos_under_primitives`
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_troppAssumptions`

These are under explicit primitive assumptions. The pointwise Bernstein CFC
primitive is now proved by `bernsteinMatrixExp_le_quadratic`; the
`under_troppPrimitive` trace-MGF wrapper uses that proof so callers no longer
pass pointwise CFC at the trace-MGF provider layer. The preferred optimized
public surface is the `*_of_troppAssumptions` family, which uses
`MatrixBernsteinPositiveSideTroppAssumptions` and
`MatrixBernsteinNegativeSideTroppAssumptions` to expose Tropp/Lieb and
bookkeeping assumptions without a user-supplied CFC field. The older
`*_of_assumptions` and `_under_primitives` names remain compatibility surfaces.
The route still does not prove Tropp/Lieb, Golden-Thompson, trace-exp
integrability, variance-proxy control, or a full unconditional Matrix
Bernstein theorem.

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
- `matrixExpLogDomainForSelfAdjoint_statement`
- `matrixLog_le_of_le_matrixExp_statement`
- `matrixLog_le_of_le_matrixExp`
- `traceMatrixExp_mono_add_selfAdjoint_statement`
- `troppLogExpComparisonToK_of_logOrderKChain_statement`

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
- `centeredRankOneSquare_le_rankOneSecondMoment_statement`
- `sampleCovarianceVarianceProxy_sharp_statement`
- `varianceProxyNormBound_of_centeredSquareChain_statement`

Dimension / rank / effective-rank chain:

- `traceMatrixExp_le_rank_exp_lambdaMax_statement`
- `traceMatrixExp_le_supportDim_exp_lambdaMax_statement`
- `traceMatrixExp_effectiveRank_bound_statement`

Deterministic trace / rank bridges:

- `matrixTrace_smul`
- `matrixTrace_le_of_matrixLE`
- `traceMatrixExp_le_trace_support_exp_lambdaMax_of_matrixExp_le_smul_support`
- `traceMatrixExp_eq_sum_exp_eigenvalues`
- `traceMatrixExp_smul_le_card_add_trace_div_mul_exp_sub_one_of_psd_lambdaMax_le`
- `matrixTrace_le_card_mul_of_isPSD_lambdaMaxOrdered_le`
- `matrixTrace_eq_rank_of_isStarProjection`

Thin hardbone consumers:

- `bernsteinMatrixExp_le_quadratic_of_cfcChain`
- `bernsteinMatrixExp_le_quadratic_of_cfcLeaves`
- `bernsteinMatrixExp_le_quadratic`
- `matrixLog_le_of_le_matrixExp`
- `troppLogExpComparisonToK_of_logMonotone_traceExpMono`
- `troppMasterTraceMGFStep_of_liebJensen`
- `troppConditionalStep_of_iIndepFun`
- `troppMasterTraceMGFConditionalStep_of_conditioningBridge`
- `traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider`
- `varianceProxyNormBound_of_centeredSquareChain`
- `traceMatrixExp_le_rank_exp_lambdaMax`
- `traceMatrixExp_le_rank_exp_lambdaMax_of_isStarProjection`
- `traceMatrixExp_le_supportDim_exp_lambdaMax`
- `traceMatrixExp_effectiveRank_bound`
- `traceMatrixExp_effectiveRank_bound_of_ambientTraceCertificate`

Hardbone status table:

| Statement family | Lean declaration | Status | Consumer | Remaining blocker |
|---|---|---|---|---|
| Scalar Bernstein hardbone leaf | `scalarBernsteinExpQuadraticInequality_statement` | proven by `scalarBernsteinExpQuadraticInequality` | CFC-chain assumptions can reuse the proved scalar theorem | none for this scalar leaf |
| Bernstein CFC | `bernsteinMatrixExp_le_quadratic_statement` | proven by `bernsteinMatrixExp_le_quadratic` | `bernsteinMatrixExp_le_quadratic_of_cfcLeaves` documents the reusable composition | preferred `*_of_troppAssumptions` wrappers bypass pointwise CFC fields; explicit-CFC wrappers remain for compatibility |
| Matrix log/order bridge | `matrixLog_le_of_le_matrixExp_statement` | proven by `matrixLog_le_of_le_matrixExp` | turns explicit log-monotonicity and `matrixExp` log-domain premises into `log M <= K` | operator-log monotonicity and the `matrixExp` log-domain premise remain external inputs |
| Log/order-to-`K` | `troppLogExpComparisonToK_of_logOrderKChain_statement` | typed-prop | `troppLogExpComparisonToK_of_logMonotone_traceExpMono` | trace-exp monotonicity plus the explicit log/order bridge inputs |
| Tropp/Lieb/GT one-step | `troppMasterTraceMGFStep_of_liebJensen_statement` | typed-prop | `troppMasterTraceMGFStep_of_liebJensen` | Lieb concavity, probability-measure Jensen, log-exp normalization; Golden-Thompson is separate |
| Conditioning / independence | `troppConditionalStep_of_iIndepFun_statement` | proven by `troppConditionalStep_of_iIndepFun` | `troppMasterTraceMGFConditionalStep_of_conditioningBridge` | thin forwarder only; generated histories, history/current-step independence, finite-family independence, and conditional expectation reduction remain explicit premises |
| Trace-exp integrability | `traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider_statement` | typed-prop with proved thin consumer | `traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider` | automatic absolute domination, Golden-Thompson/product, or boundedness provider |
| Variance proxy / centered square | `varianceProxyNormBound_of_centeredSquareChain_statement` | typed-prop with proved thin consumer | `varianceProxyNormBound_of_centeredSquareChain` | centered-square expansion, Loewner comparisons, deterministic norm control, sample-covariance specialization |
| Dimension / support / effective rank | `traceMatrixExp_le_rank_exp_lambdaMax_statement`, `traceMatrixExp_le_supportDim_exp_lambdaMax_statement`, `traceMatrixExp_effectiveRank_bound_statement` | rank/support targets and effective-rank consumer proved under explicit support, PSD, lambda-max, and trace-certificate assumptions; ambient trace certificate and star-projection rank consumer proved | `traceMatrixExp_le_rank_exp_lambdaMax`, `traceMatrixExp_le_rank_exp_lambdaMax_of_isStarProjection`, `traceMatrixExp_le_supportDim_exp_lambdaMax`, `traceMatrixExp_effectiveRank_bound`, `traceMatrixExp_effectiveRank_bound_of_ambientTraceCertificate`; deterministic helpers include `traceMatrixExp_eq_sum_exp_eigenvalues`, `traceMatrixExp_smul_le_card_add_trace_div_mul_exp_sub_one_of_psd_lambdaMax_le`, `matrixTrace_le_card_mul_of_isPSD_lambdaMaxOrdered_le`, `matrixTrace_eq_rank_of_isStarProjection` | support domination and support-construction certificates; `IsStarProjection`-to-`IsPSDMatrix` bridge if available; true effective-rank trace certificate provider beyond ambient dimension |
| Thin consumers | `troppMasterTraceMGFConditionalStep_of_conditioningBridge` | proven | public API/test/judge/example checks | thin wrapper only; no hard fact is discharged |

Most hardbone declarations are typed `Prop` contracts, not hard theorem proofs.
The Bernstein CFC chain is now proved by `bernsteinMatrixExp_le_quadratic`
after splitting out scalar Bernstein, spectrum localization, CFC order
transfer, and expression normalization. The direct matrix log/order bridge is
proved by `matrixLog_le_of_le_matrixExp`, but it only composes explicit
operator-log monotonicity and `matrixExp` log-domain premises. The finite-family
conditioning chain is proved by `troppConditionalStep_of_iIndepFun`, but it only
forwards the explicit per-index conditional-expectation provider and does not
discharge the history or independence hypotheses. The remaining trace-exp
monotonicity, Tropp/Lieb, automatic integrability, variance-proxy, and
dimension/rank blockers stay split into named leaves. The rank/support
trace-bound bridge is proved under explicit support domination and support trace
assumptions. The projection trace/rank certificate
`matrixTrace_eq_rank_of_isStarProjection` is available when the caller already
has an explicit `IsStarProjection support`; the thin consumer
`traceMatrixExp_le_rank_exp_lambdaMax_of_isStarProjection` routes that
certificate into the rank-bound theorem while still requiring explicit
`IsPSDMatrix support` and support domination. What remains open is constructing
support domination and support matrices for specific applications, proving or
reusing an `IsStarProjection`-to-`IsPSDMatrix` bridge, and proving true
effective-rank trace certificates beyond the ambient cardinality fallback.
The rank and effective-rank trace-exp targets keep support domination, PSD,
lambda-max, or trace-certificate assumptions explicit; the ambient certificate
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
import HighDimProb.Examples.RandomMatrix.PrefixStateTroppUsage
import HighDimProb.Examples.RandomMatrix.ConditionalStateEndpointUsage
import HighDimProb.Examples.RandomMatrix.NaturalTroppPipelineUsage
import HighDimProb.Examples.RandomMatrix.ReindexedTroppBridgeUsage
import HighDimProb.Examples.RandomMatrix.HardboneStatementAtlasUsage
```

## Sample Covariance Surface

Explicit-CFC compatibility wrappers:

- `sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy`
- `sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound`
- `sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_under_explicit_variance_proxy`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_explicit_variance_proxy`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_adapters`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_square_adapters`

Preferred CFC-free wrappers after the Bernstein CFC hardbone leaf:

- `sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy_of_troppPrimitive`
- `sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound_of_troppPrimitive`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_adapters_of_troppPrimitives`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_square_adapters_of_troppPrimitives`

These wrappers still require Tropp/Lieb trace-MGF primitives and analytic
integrability assumptions. They only remove the user-supplied pointwise
Bernstein CFC fields by applying `bernsteinMatrixExp_le_quadratic`; they do not
prove Tropp/Lieb, Golden-Thompson, trace-exp integrability, variance-proxy
control beyond existing named adapters, or unconditional sample-covariance
concentration.

### Sample covariance negative-side provider adapters

- `centeredSampleCovarianceRowRankOneFamilyNeg_expIntegrable_of_expIntegrable_neg_theta`
- `centeredSampleCovarianceRowRankOneSumNeg_traceExpIntegrable_of_traceExpIntegrable_neg_theta`
- `centeredSampleCovarianceRowRankOneFamilyNeg_cfcPrimitive_of_cfcPrimitive_neg_theta`

These are sign-normalization adapters from explicit original-family
opposite-parameter provider assumptions. They do not prove exponential
integrability, trace-exponential integrability, or the Bernstein CFC primitive,
and they are not tail wrappers by themselves.

## Variance Proxy Surface

- `MatrixVarianceProxyNormBound_of_pointwiseOperatorNormBound`
- `MatrixVarianceProxyNormBound_centeredRankOneRandomMatrixFamily_of_sqNorm_bound`
- `MatrixVarianceProxyNormBound_centeredSampleCovarianceRowRankOneFamily_of_rowSqNorm_bound`
- `sampleCovarianceCenteredRankOneVarianceProxyBound`

## Example Style

- Name matrix families before using them in public wrappers.
- Prefer named adapters over anonymous lambdas.
- Prefer the sample-covariance `_of_troppPrimitive` / `_of_troppPrimitives`
  wrappers when pointwise Bernstein CFC is the only remaining explicit field.
- Keep positive-side and negative-side assumptions visibly distinct when the
  theorem still needs both sides.
- Put domain vocabulary in examples as thin wrappers over the core RandomMatrix
  API, not as separate theorem machinery.
- Use `PrefixStateTroppUsage`, `ConditionalStateEndpointUsage`, and
  `NaturalTroppPipelineUsage` for examples of prefix/state endpoint and
  natural-state TraceExp bookkeeping. Use `ReindexedTroppBridgeUsage` for
  reindex transport bookkeeping. `ConditionalStateEndpointData` is example
  local, not core API.
