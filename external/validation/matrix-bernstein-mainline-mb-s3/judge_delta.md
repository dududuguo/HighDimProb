# MB-S3 Judge Delta

## Updated Judge File

- `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`

## Added Checks

- `HighDimProb.matrixTrace_nonneg_of_posSemidef`
- `HighDimProb.traceMatrixExp_nonneg_of_matrixExp_posSemidef`
- `HighDimProb.matrixExp_posSemidef_of_selfAdjoint_statement`
- `HighDimProb.traceExpIntegrand`
- `HighDimProb.traceExpMoment_nonneg_of_nonneg`
- `HighDimProb.traceExpMomentLIntegral_nonneg`
- `HighDimProb.traceExpMomentLIntegral_eq_ofReal_traceExpMoment`

## Added Examples

- Application example for `traceExpMoment_nonneg_of_nonneg`.
- Application example for `traceExpMomentLIntegral_eq_ofReal_traceExpMoment`.

## Gate Results

- `lake build HighDimProbJudge`: passed after the update.
- `python scripts/judge_policy_check.py`: passed after the update.
