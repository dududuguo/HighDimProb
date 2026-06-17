# Status

Current version target: `v0.1-alpha`

This file is intentionally short. Old stage notes were collapsed into
[`archive.md`](archive.md); use git history for exact old wording. Detailed API
surfaces are tracked in the focused reference docs linked below.

## Current Focus

- Active branch: RandomMatrix / Matrix Bernstein experimental API.
- Stable import surface: [`HighDimProb`](../HighDimProb.lean).
- Experimental import surface: [`HighDimProb.Experimental`](../HighDimProb/Experimental.lean) and [`HighDimProb.Examples`](../HighDimProb/Examples.lean).
- Main active implementation file: [`HighDimProb/RandomMatrix/ConcentrationStatements.lean`](../HighDimProb/RandomMatrix/ConcentrationStatements.lean).

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
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions`
- `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions`
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_assumptions`

TraceExp / Tropp bookkeeping helpers:

- `traceMatrixExp_randomMatrixPrefixSum_last`
- `traceMatrixExp_comparisonMatrixPrefixSum_last`

Sample covariance wrappers:

- `sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_adapters`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_square_adapters`
- `SampleCovarianceTailUsage.SampleCovarianceTailAssumptions`
- `SampleCovarianceTailUsage.SampleCovarianceOperatorNormTailAssumptions`

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
- `ReindexedTroppBridgeUsage`

## Current Caveats

- RandomMatrix / Matrix Bernstein remains experimental.
- Tropp/Lieb, Golden-Thompson, Bernstein CFC, and full Matrix Bernstein are not claimed as complete unless a referenced theorem says so directly.
- Prefix/suffix/state bookkeeping is covered only as bookkeeping. The conditional-state bundle is example-local, and the reindexed example is transport-only.
- Positive-threshold operator-norm routes use `0 < t`; the zero-dimensional `t = 0` endpoint is not part of that route.
- Sample covariance wrappers remain conditional APIs, not unconditional concentration theorems.
- Next safe RandomMatrix task: `RM-BR-natural-history-state-construction-contract`.

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

Last verified locally on 2026-06-18 with the commands above.

## Archive

Completed stage logs, historical blockers, and old milestone notes were reduced
to a short summary in [`archive.md`](archive.md). Keep this file current-facing
only.
