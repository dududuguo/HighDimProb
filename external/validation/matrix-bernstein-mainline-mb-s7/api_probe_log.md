# MB-S7.1 API Probe Log

## FSM Path
- `QUEUED -> API_SURVEYING -> API_CONTRACTING -> VERIFYING -> API_READY`

## File Lease
- Allowed writes only in `external/validation/matrix-bernstein-mainline-mb-s7/`.
- No Lean source, test, judge, or docs files are leased for this API contract stage.

## Files Read
- Earlier manager-level validation summaries, since consolidated and removed
  from the active validation tree.
- `external/validation/matrix-bernstein-mainline-mb-s7/SOURCE_DIGEST.md`
- `external/validation/matrix-bernstein-mainline-mb-s7/source_lookup_log.md`
- `HighDimProb/RandomMatrix/Laplace.lean`
- `HighDimProb/RandomMatrix/Spectral.lean`
- `HighDimProb/RandomMatrix/TraceExp.lean`
- `HighDimProb/RandomMatrix/SelfAdjoint.lean`
- `HighDimProb/RandomMatrix/MatrixOrder.lean`

## Existing Signature Manifest

### Laplace
- `TraceExpDominatesQuadraticFormUpperTail Y theta t : Prop`
- `traceExpDominatesQuadraticFormUpperTailStatement Y theta t : Prop`
- `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates`
- `matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail`
- `matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail`
- `traceExpThresholdEvent Y theta t : Set Omega`
- `matrixLaplaceRHSLIntegral P Y theta t : ENNReal`
- `matrixLaplaceRHSLIntegralDiv P Y theta t : ENNReal`

### Spectral
- `lambdaMax A hA : Real`
- `lambdaMin A hA : Real`
- `QuadraticFormUpperBound A t : Prop`
- `LambdaMaxBound A t : Prop`
- `quadraticFormUpperTailEvent A t : Set Omega`
- `quadraticFormLowerTailEvent A t : Set Omega`
- `twoSidedQuadraticFormTailEvent A t : Set Omega`
- `selfAdjointOperatorNormTailViaQuadraticFormStatement A t : Prop`
- `lambdaMax_le_iff_quadraticForm_le_statement A hA t : Prop`
- `operatorNorm_eq_max_abs_lambda_statement A hA : Prop`

### TraceExp
- `matrixExp_posSemidef_of_selfAdjoint hA : Matrix.PosSemidef (matrixExp A)`
- `traceMatrixExp_nonneg_of_selfAdjoint hA : 0 <= traceMatrixExp A`
- `traceExpIntegrand Y theta : RealRandomVariable Omega`
- `traceExpIntegrand_nonneg_of_randomSelfAdjoint theta hY`
- `traceExpMoment_nonneg_of_randomSelfAdjoint Y theta hY`

### SelfAdjoint
- `IsSelfAdjointMatrix A : Prop`
- `RandomSelfAdjointMatrix P A : Prop`
- `isSelfAdjointMatrix_smul c hA`
- `randomSelfAdjointMatrix_smul c hA`

## Mathlib API Search Summary
- `ContinuousLinearMap.rayleighQuotient` exists in Mathlib's Rayleigh file.
- `ContinuousLinearMap.iSup_rayleigh_eq_iSup_rayleigh_sphere` exists.
- `ContinuousLinearMap.norm_eq_iSup_rayleighQuotient` exists.
- `Matrix.trace_eq_sum_eigenvalues` exists.
- `Matrix.IsHermitian.posSemidef_iff_eigenvalues_nonneg` exists.
- `Matrix.PosSemidef.eigenvalues_nonneg` exists.
- `Matrix.PosSemidef.trace_nonneg` exists.
- `Matrix.nonneg_iff_posSemidef` exists.
- `IsSelfAdjoint.exp_nonneg` exists and is already used by HighDimProb.

## Preliminary Route Assessment
- The source supports the dominance step mathematically through Rayleigh/spectral trace-exponential arguments.
- The current HighDimProb API still lacks a proved bridge between explicit `matrixQuadraticForm`/`IsUnitVector` events and Mathlib's Rayleigh/eigenvalue machinery.
- The direct theorem should be split into spectral bridge lemmas before a proof agent attempts the final dominance theorem.

## Probe Command Status
- `lake env lean external/validation/matrix-bernstein-mainline-mb-s7/MB_S7_APIProbe.lean`: passed after correcting the trace/eigenvalue theorem namespace to `Matrix.IsHermitian.trace_eq_sum_eigenvalues`.
- `lake build HighDimProb.RandomMatrix.Laplace`: passed.
- `lake build HighDimProb.RandomMatrix.Spectral`: passed.
- `python scripts/judge_policy_check.py`: passed.
- `git diff --check`: passed with existing CRLF normalization warnings on untouched root Lean files.
