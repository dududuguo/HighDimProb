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

## Sample Covariance Surface

- `sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy`
- `sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound`
- `sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_under_explicit_variance_proxy`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_explicit_variance_proxy`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_adapters`
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_square_adapters`

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
