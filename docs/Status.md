# Status

Current version target: `v0.1-alpha`

This file is intentionally short. Old stage notes were collapsed into
[`archive.md`](archive.md); use git history for exact old wording. Detailed API
surfaces are tracked in the focused reference docs linked below.

## Current Focus

- Active branch: RandomMatrix / Matrix Bernstein experimental API.
- Stable import surface: [`HighDimProb`](../HighDimProb.lean).
- Experimental import surface: [`HighDimProb.Experimental`](../HighDimProb/Experimental.lean) and [`HighDimProb.Examples`](../HighDimProb/Examples.lean).
- Main active RandomMatrix files:
  [`TraceExp.lean`](../HighDimProb/RandomMatrix/TraceExp.lean),
  [`HardboneStatements.lean`](../HighDimProb/RandomMatrix/HardboneStatements.lean), and
  [`ConcentrationStatements.lean`](../HighDimProb/RandomMatrix/ConcentrationStatements.lean).

## Active API Pointers

- RandomMatrix API index: [`RandomMatrixAPI.md`](RandomMatrixAPI.md)
- Term map / symbol index: [`TermMap.md`](TermMap.md)
- Theorem atlas: [`TheoremAtlas.md`](TheoremAtlas.md)
- Test plan: [`TestPlan.md`](TestPlan.md)
- Judge system: [`JudgeSystem.md`](JudgeSystem.md)
- Workflow: [`Workflow.md`](Workflow.md)

## Current RandomMatrix Entry Names

Core Matrix Bernstein helpers:

- `matrixBernsteinOptimizedScalarTailRHS`
- `matrixBernsteinTwoSidedOptimizedScalarTailRHS`
- `MatrixBernsteinPositiveSideAssumptions`
- `MatrixBernsteinNegativeSideAssumptions`
- `MatrixBernsteinPositiveSideTroppAssumptions`
- `MatrixBernsteinNegativeSideTroppAssumptions`
- `matrixBernsteinTraceMGFWithBernsteinCoeff_under_troppPrimitive`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_of_troppAssumptions`
- `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions`
- `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_of_troppAssumptions`
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_assumptions`
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_troppAssumptions`

TraceExp / Tropp bookkeeping helpers:

- `troppTraceState`
- `troppStateHistory`
- `troppNaturalState_zero`
- `troppNaturalState_last`
- `troppNaturalState_left`
- `troppNaturalState_right`
- `troppTraceExpFiniteFamilyIterationSkeleton_of_naturalStateConditionalSteps`
- `troppMasterTraceMGFFiniteFamily_of_naturalStateConditionalSteps`
- `traceMGFBernsteinVarianceProxyBound_of_naturalStateConditionalSteps`
- `traceMatrixExp_randomMatrixPrefixSum_last`
- `traceMatrixExp_comparisonMatrixPrefixSum_last`

Sample covariance wrappers:

- `sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy`
- `sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy_of_troppPrimitive`
- `sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound`
- `sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound_of_troppPrimitive`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_adapters`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_adapters_of_troppPrimitives`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_square_adapters`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_square_adapters_of_troppPrimitives`
- `SampleCovarianceTailUsage.SampleCovarianceTailAssumptions`
- `SampleCovarianceTailUsage.SampleCovarianceOperatorNormTailAssumptions`

Sample covariance negative-side provider-transfer adapters:

- `centeredSampleCovarianceRowRankOneFamilyNeg_expIntegrable_of_expIntegrable_neg_theta`
- `centeredSampleCovarianceRowRankOneSumNeg_traceExpIntegrable_of_traceExpIntegrable_neg_theta`
- `centeredSampleCovarianceRowRankOneFamilyNeg_cfcPrimitive_of_cfcPrimitive_neg_theta`

Hardbone Bernstein CFC leaf:

- `scalarBernsteinExpQuadraticInequality`
- `selfAdjointSpectrumBoundedByOperatorNorm`
- `bernsteinCFCExpressionNormalization`
- `cfcScalarInequalityToMatrixLE_bernsteinExpQuadratic`
- `bernsteinMatrixExp_le_quadratic_of_cfcLeaves`
- `bernsteinMatrixExp_le_quadratic`

Hardbone conditioning bridge leaf:

- `troppConditionalStep_of_iIndepFun`

Example-layer wrappers:

- `sampleCovariance_quadraticForm_tail_usage`
- `sampleCovariance_operatorNorm_tail_usage`
- `negativeFamily_twoSided_quadraticForm_tail_usage`
- `negativeFamily_selfAdjoint_operatorNorm_tail_usage`
- `boundedRowSampleCovariance_operatorNorm_tail_usage`
- `attentionFeatureGram_quadraticForm_tail_usage`
- `attentionFeatureGram_operatorNorm_tail_usage`
- `empiricalFisher_operatorNorm_tail_usage`
- `loraAdapterSubspaceCovariance_operatorNorm_tail_usage`

Example modules:

- `PrefixStateTroppUsage`
- `ConditionalStateEndpointUsage`
- `NaturalTroppPipelineUsage`
- `ReindexedTroppBridgeUsage`
- `HardboneStatementAtlasUsage`

## Current Caveats

- RandomMatrix / Matrix Bernstein remains experimental.
- The hardbone statement atlas names CFC, log/order, Tropp/Lieb,
  conditioning, integrability, variance-proxy, and dimension/rank blockers as
  typed statement targets. The Bernstein CFC route is now proved through
  `bernsteinMatrixExp_le_quadratic`, reusing scalar Bernstein, spectrum
  localization, Bernstein-specific CFC order transfer, and CFC expression
  normalization. The conditioning chain now has the thin theorem witness
  `troppConditionalStep_of_iIndepFun`, which only forwards the explicit
  per-index conditional-expectation provider and does not prove history
  measurability or independence. The preferred optimized Matrix Bernstein
  assumption bundles
  are now `MatrixBernsteinPositiveSideTroppAssumptions` and
  `MatrixBernsteinNegativeSideTroppAssumptions`, which expose Tropp/Lieb
  primitives but not pointwise CFC fields. The older explicit-CFC bundles and
  `_under_primitives` wrappers remain compatibility surfaces.
- Tropp/Lieb, Golden-Thompson, trace-exp integrability, variance-proxy control,
  and full Matrix Bernstein are not claimed as complete unless a referenced
  theorem says so directly.
- Prefix/suffix/state bookkeeping now includes a natural `Fin m` trace-state
  route through the finite-family Tropp and trace-MGF provider surfaces. This
  does not discharge the analytic conditional-step, history measurability,
  independence, trace-exp integrability, log/K, CFC, or variance-proxy
  hypotheses.
- The conditional-state bundle is example-local, and the reindexed example is transport-only.
- Positive-threshold operator-norm routes use `0 < t`; the zero-dimensional `t = 0` endpoint is not part of that route.
- Sample covariance wrappers remain conditional APIs, not unconditional concentration theorems. The preferred sample-covariance example route now uses Tropp-only wrappers that fill pointwise Bernstein CFC fields with `bernsteinMatrixExp_le_quadratic`; explicit-CFC wrappers remain compatibility surfaces.
- Negative-side provider-transfer adapters only move explicit opposite-parameter
  assumptions onto the named negative sample-covariance family; they do not
  prove exponential integrability, trace-exponential integrability, or CFC.
- Completed hardbone wrapper task: `RM-HB-sample-covariance-cfc-free-wrapper-contract`.
- Completed hardbone proof leaf:
  `RM-HB12-tropp-conditional-step-of-iindepfun-bridge-leaf`.
- Next safe hardbone task: `RM-HB12-select-next-hardbone-proof-leaf`.

## Verification

Run before pushing API or docs changes:

```bash
python .github/scripts/check_text_quality.py
python scripts/judge_policy_check.py
lake build
lake build HighDimProb.Examples
lake test
lake build HighDimProbJudge
```

Last verified locally on 2026-06-19 with the commands above.

## Archive

Completed stage logs, historical blockers, and old milestone notes were reduced
to a short summary in [`archive.md`](archive.md). Keep this file current-facing
only.
