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
- `sampleCovarianceCenteredRankOneRadius`
- `sampleCovarianceTailTheta`
- `sampleCovarianceQuadraticFormTailRHS`

Use these helpers in examples and tests instead of copying RHS formulas.

## Matrix Bernstein Surface

- `matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions`
- `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_pos_under_primitives`

These are under explicit primitive assumptions. They do not prove Tropp/Lieb,
CFC, Golden-Thompson, or a full unconditional Matrix Bernstein theorem.

## Hardbone Statement Targets

Bernstein CFC chain:

- `scalarBernsteinExpQuadraticInequality_statement`
- `selfAdjointSpectrumBoundedByOperatorNorm_statement`
- `cfcScalarInequalityToMatrixLE_statement`
- `bernsteinCFCExpressionNormalization_statement`
- `bernsteinMatrixExp_le_quadratic_of_cfcChain_statement`

Log/order-to-`K` chain:

- `operatorLogMonotoneOnPositiveMatrices_statement`
- `matrixExpLogDomainForSelfAdjoint_statement`
- `matrixLog_le_of_le_matrixExp_statement`
- `traceMatrixExp_mono_add_selfAdjoint_statement`
- `troppLogExpComparisonToK_of_logOrderKChain_statement`

Tropp/Lieb/Golden-Thompson chain:

- `liebTraceExpConcavity_statement`
- `liebJensenTraceExp_statement`
- `goldenThompsonTraceExp_statement`
- `matrixExpLogSelfAdjointNormalization_statement`
- `troppMasterTraceMGFStep_of_liebJensen_statement`

Conditioning / independence chain:

- `troppNaturalHistoryMeasurable_statement`
- `troppHistoryStepIndependent_of_iIndepFun_statement`
- `condExp_traceExp_history_add_independent_step_statement`
- `troppConditionalStep_of_iIndepFun_statement`

Integrability provider chain:

- `matrixExpScaledIntegrable_of_provider_statement`
- `traceExpIntegrable_troppStateHistory_add_step_statement`
- `traceExpIntegrable_troppStateHistory_add_K_statement`
- `traceExpIntegrable_randomMatrixSum_of_summandProviders_statement`

Variance-proxy / centered-square chain:

- `matrixSquare_centeredRandomMatrix_expectation_expansion_statement`
- `centeredRankOneSquare_le_rankOneSecondMoment_statement`
- `sampleCovarianceVarianceProxy_sharp_statement`
- `varianceProxyNormBound_of_centeredSquareChain_statement`

Dimension / rank / effective-rank chain:

- `traceMatrixExp_le_rank_exp_lambdaMax_statement`
- `traceMatrixExp_le_supportDim_exp_lambdaMax_statement`
- `traceMatrixExp_effectiveRank_bound_statement`

Thin hardbone consumers:

- `bernsteinMatrixExp_le_quadratic_of_cfcChain`
- `troppLogExpComparisonToK_of_logMonotone_traceExpMono`
- `troppMasterTraceMGFStep_of_liebJensen`
- `troppMasterTraceMGFConditionalStep_of_conditioningBridge`

Hardbone status table:

| Statement family | Lean declaration | Status | Consumer | Remaining blocker |
|---|---|---|---|---|
| Bernstein CFC | `bernsteinMatrixExp_le_quadratic_of_cfcChain_statement` | typed-prop | `bernsteinMatrixExp_le_quadratic_of_cfcChain` | scalar Bernstein, spectral localization, CFC order transfer, expression normalization |
| Log/order-to-`K` | `troppLogExpComparisonToK_of_logOrderKChain_statement` | typed-prop | `troppLogExpComparisonToK_of_logMonotone_traceExpMono` | operator-log monotonicity, log domain for `matrixExp`, trace-exp monotonicity |
| Tropp/Lieb/GT one-step | `troppMasterTraceMGFStep_of_liebJensen_statement` | typed-prop | `troppMasterTraceMGFStep_of_liebJensen` | Lieb concavity, Jensen, log-exp normalization; Golden-Thompson is separate |
| Conditioning / independence | `troppConditionalStep_of_iIndepFun_statement` | typed-prop | `troppMasterTraceMGFConditionalStep_of_conditioningBridge` | generated histories, history-step independence, conditional expectation reduction |
| Trace-exp integrability | `traceExpIntegrable_randomMatrixSum_of_summandProviders_statement` | typed-prop | none yet | matrix-exp and trace-exp integrability propagation |
| Variance proxy / centered square | `varianceProxyNormBound_of_centeredSquareChain_statement` | typed-prop | none yet | centered-square expansion, rank-one comparison, order/norm bookkeeping |
| Dimension / support / effective rank | `traceMatrixExp_effectiveRank_bound_statement` | typed-prop | none yet | rank/support/effective-rank core theory |
| Thin consumers | `troppMasterTraceMGFConditionalStep_of_conditioningBridge` | proven | public API/test/judge/example checks | thin wrapper only; no hard fact is discharged |

These declarations are typed `Prop` contracts, not hard theorem proofs. They
split the current large CFC, log/order, Tropp/Lieb, conditioning,
integrability, variance-proxy, and dimension/rank blockers into named leaves.
The thin consumers only apply explicit statement-chain assumptions; they do
not prove CFC, Lieb/Jensen, conditioning, finite-family Tropp, or any Matrix
Bernstein tail theorem.

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

- `sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy`
- `sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound`
- `sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_under_explicit_variance_proxy`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_explicit_variance_proxy`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_adapters`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_square_adapters`

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
- Keep positive-side and negative-side assumptions visibly distinct when the
  theorem still needs both sides.
- Put domain vocabulary in examples as thin wrappers over the core RandomMatrix
  API, not as separate theorem machinery.
- Use `PrefixStateTroppUsage`, `ConditionalStateEndpointUsage`, and
  `NaturalTroppPipelineUsage` for examples of prefix/state endpoint and
  natural-state TraceExp bookkeeping. Use `ReindexedTroppBridgeUsage` for
  reindex transport bookkeeping. `ConditionalStateEndpointData` is example
  local, not core API.
