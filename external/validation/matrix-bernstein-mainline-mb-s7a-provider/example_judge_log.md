# MB-S7A-provider Example/Judge Log

## FSM Path
- QUEUED
- API_SURVEYING
- PROVIDER_CONTRACTING
- TRANSLATING
- COMPILING
- EXAMPLE_WRITING

## Declarations Covered
- `lambdaMaxOrdered_spectralUpperBound`
- `lambdaMaxOrderedPSDUpperBound`
- `lambdaMaxOrdered_rayleighUpperBound`

## Files Updated
- `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- `HighDimProbJudge/RandomMatrix/SpectralUse.lean`

## Coverage Added
- Focused `#check` coverage for each new public declaration.
- Minimal explicit-hypothesis examples using `hA : IsSelfAdjointMatrix A`.

## Commands
- `lake build HighDimProbTest.RandomMatrixSpectralAPI`: passed.
- `lake build HighDimProbJudge.RandomMatrix.SpectralUse`: passed.
- `python scripts/judge_policy_check.py`: passed.
- `git diff --check`: passed with existing CRLF normalization warnings.

## Exactly One Next Safe Task
- Update docs to mark MB-S7A-provider complete and set MB-S7B as next.
