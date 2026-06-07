# RandomMatrix Matrix Bernstein API

This index records the public RandomMatrix API used by the Matrix Bernstein
mainline. It is documentation only; theorem status is not upgraded here.

## `HighDimProb/RandomMatrix/SelfAdjoint.lean`

- `IsSymmetricMatrix`: abbrev.
- `IsSelfAdjointMatrix`: abbrev.
- `RandomSymmetricMatrix`: def.
- `RandomSelfAdjointMatrix`: def.
- `isSelfAdjointMatrix_smul`: theorem.
- `isSelfAdjointMatrix_neg`: theorem.
- `randomSelfAdjointMatrix_smul`: theorem.
- `randomSelfAdjointMatrix_neg`: theorem.

## `HighDimProb/RandomMatrix/Spectral.lean`

- `SpectralUpperBound`: abbrev, semantic upper spectral bound.
- `RayleighUpperBound`: def, semantic quadratic-form upper bound.
- `scalarUpperTailEvent`: def.
- `matrixUpperBoundTailEvent`: def.
- `lambdaMax`: def, legacy compatibility wrapper.
- `lambdaMaxOrdered`: def, canonical ordered endpoint wrapper.
- `lambdaMax_eq_lambdaMaxOrdered_statement`: typed statement.
- `lambdaMaxOrdered_is_greatest_eigenvalue`: theorem.
- `lambdaMaxOrdered_smul_of_nonneg`: theorem.
- `lambdaMaxOrdered_le_trace_of_posSemidef`: theorem.
- `LambdaMaxPSDUpperBound`: abbrev, semantic provider predicate for legacy
  `lambdaMax`.
- `LambdaMaxOrderedPSDUpperBound`: abbrev, semantic provider predicate for
  `lambdaMaxOrdered`.
- `lambdaMaxOrdered_spectralUpperBound`: theorem.
- `lambdaMaxOrderedPSDUpperBound`: theorem.
- `rayleighUpperBound_of_spectralUpperBound`: theorem.
- `lambdaMaxOrdered_rayleighUpperBound`: theorem.
- `matrixQuadraticForm_le_lambdaMax_statement`: typed statement.
- `matrixQuadraticForm_le_lambdaMaxOrdered_statement`: typed statement.
- `matrixQuadraticForm_le_lambdaMax_of_lambdaMaxPSDUpperBound`: conditional
  theorem.
- `matrixQuadraticForm_le_lambdaMaxOrdered_of_lambdaMaxOrderedPSDUpperBound`:
  conditional theorem.
- `lambdaMaxUpperTailEvent`: def.
- `lambdaMaxOrderedUpperTailEvent`: def.
- `lambdaMaxUpperTailEvent_eq_matrixUpperBoundTailEvent`: theorem.
- `lambdaMaxOrderedUpperTailEvent_eq_matrixUpperBoundTailEvent`: theorem.
- `quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_rayleighUpperBound`:
  theorem.
- `quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_spectralUpperBound`:
  theorem.
- `selfAdjointOperatorNormTailViaQuadraticFormStatement`: typed statement.
- `lambdaMax_le_iff_quadraticForm_le_statement`: typed statement.
- `operatorNorm_eq_max_abs_lambda_statement`: typed statement.

## `HighDimProb/RandomMatrix/VarianceProxy.lean`

- `matrixSquare`: def.
- `randomMatrixSquare`: def.
- `matrixSecondMoment`: def.
- `matrixVarianceProxy`: def.
- `MatrixVarianceProxy`: abbrev.
- `matrixVarianceProxyBound`: def.
- `MatrixVarianceProxyBound`: abbrev.
- `MatrixVarianceProxyUpperBound`: def, semantic matrix variance-proxy
  upper-bound predicate.
- `deterministicMatrixVarianceProxyNorm`: def.
- `matrixVarianceProxyNorm`: def.
- `MatrixVarianceProxyNormBound`: def, semantic scalar variance-proxy
  norm-bound predicate.
- `isPSD_matrixSquare_of_selfAdjoint`: theorem.
- `isPSD_matrixSecondMoment_of_selfAdjoint`: theorem.
- `isPSD_matrixVarianceProxy_of_selfAdjoint`: theorem.

## `HighDimProb/RandomMatrix/TraceExp.lean`

- `matrixExp`: def.
- `matrixTrace`: def.
- `traceMatrixExp`: def.
- `isSelfAdjointMatrix_matrixExp`: theorem.
- `matrixTrace_nonneg_of_posSemidef`: theorem.
- `traceMatrixExp_nonneg_of_matrixExp_posSemidef`: theorem.
- `matrixExp_posSemidef_of_selfAdjoint_statement`: typed statement.
- `matrixExp_posSemidef_of_selfAdjoint`: theorem.
- `traceExpIntegrand`: def.
- `traceExpMoment`: def.
- `traceExpMomentLIntegral`: def.
- `TraceMGFBound`: def, semantic real trace-mgf bound.
- `TraceMGFBoundLIntegral`: def, semantic lintegral trace-mgf bound.
- `TraceMGFVarianceProxyBound`: def, semantic real variance-proxy
  trace-mgf bound.
- `TraceMGFVarianceProxyBoundLIntegral`: def, semantic lintegral
  variance-proxy trace-mgf bound.
- `traceMatrixExp_nonneg_of_selfAdjoint_statement`: typed statement.
- `traceMatrixExp_nonneg_of_selfAdjoint`: theorem.
- `lambdaMaxOrdered_matrixExp`: theorem.
- `traceExpMoment_nonneg_statement`: typed statement.
- `traceExpMoment_nonneg_of_nonneg`: theorem.
- `traceExpIntegrand_nonneg_of_randomSelfAdjoint`: theorem.
- `traceExpMoment_nonneg_of_randomSelfAdjoint`: theorem.
- `traceExpMomentLIntegral_nonneg`: theorem.
- `traceExpMomentLIntegral_eq_ofReal_statement`: typed statement.
- `traceExpMomentLIntegral_eq_ofReal_traceExpMoment`: theorem.
- `traceExpMomentBoundStatement`: typed statement.
- `traceExpVarianceProxyBoundStatement`: typed statement.
- `traceMGFBound_statement`: typed statement.
- `traceMGFBoundLIntegral_statement`: typed statement.
- `traceMGFVarianceProxyBound_statement`: typed statement.

## `HighDimProb/RandomMatrix/Laplace.lean`

- `matrixLaplaceRHS`: def.
- `matrixLaplaceRHSLIntegral`: def.
- `traceExpThresholdEvent`: def.
- `TraceExpDominatesUpperBound`: def.
- `lambdaMaxOrdered_traceExpDominatesUpperBound`: theorem.
- `matrixUpperBoundTailEvent_subset_traceExpThresholdEvent_of_traceExpDominatesUpperBound`:
  theorem.
- `matrixLaplaceRHSLIntegralDiv`: def.
- `matrixLaplaceRHSLIntegralDiv_eq_matrixLaplaceRHSLIntegral`: theorem.
- `traceExpThresholdEvent_lintegral_bound`: theorem.
- `matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset`:
  conditional theorem.
- `matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset`: conditional
  theorem.
- `TraceExpDominatesQuadraticFormUpperTail`: def.
- `traceExpDominatesQuadraticFormUpperTailStatement`: typed statement.
- `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates`:
  theorem.
- `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_rayleighUpperBound_of_traceExpDominatesUpperBound`:
  theorem.
- `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_spectralUpperBound_of_traceExpDominatesUpperBound`:
  theorem.
- `traceExpDominatesQuadraticFormUpperTail_of_rayleighUpperBound_of_traceExpDominatesUpperBound`:
  theorem.
- `traceExpDominatesQuadraticFormUpperTail_of_spectralUpperBound_of_traceExpDominatesUpperBound`:
  theorem.
- `traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint`: theorem.
- `matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail`:
  conditional theorem.
- `matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail`:
  conditional theorem.
- `matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint`: theorem.
- `matrixLaplaceTransformLIntegral_of_randomSelfAdjoint`: theorem.
- `matrixLaplaceTransformStatement`: typed statement.
- `matrixLaplaceTransformLIntegralStatement`: typed statement.
- `matrixChernoffFromTraceExpStatement`: typed statement.
- `matrixChernoffFromTraceExpLIntegralStatement`: typed statement.
- `selfAdjointOperatorNormLaplaceStatement`: typed statement.
- `selfAdjointOperatorNormLaplaceLIntegralStatement`: typed statement.

## `HighDimProb/RandomMatrix/ConcentrationStatements.lean`

- `matrixBernsteinStatement`: typed statement.
- `matrixBernsteinSelfAdjointStatement`: typed statement.
- `matrixBernsteinLaplacePrerequisitesStatement`: typed statement.
- `matrixBernsteinTraceMGF_statement`: typed statement.

## Current Blockers

- Real RHS / real expectation bridge for the concrete lintegral Laplace
  wrappers.
- Trace-mgf provider theorem for `matrixBernsteinTraceMGF_statement`.
- Golden-Thompson / Lieb.
- Matrix Bernstein.

## Next Safe Task

MB-S9-trace-mgf-provider-contract: audit the source/API route for proving
`matrixBernsteinTraceMGF_statement`, or block cleanly on the missing
Golden-Thompson/Lieb/matrix-mgf prerequisites.
