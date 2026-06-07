# MB-S7A-provider Proof Log

## FSM Path
- QUEUED
- API_SURVEYING
- PROVIDER_CONTRACTING
- TRANSLATING
- COMPILING

## Contract Used
- `external/validation/matrix-bernstein-mainline-mb-s7a-provider/PROVIDER_CONTRACT.md`
- Route: `PROVIDER_DIRECT_READY`

## Declarations Added
- `lambdaMaxOrdered_spectralUpperBound`
- `lambdaMaxOrderedPSDUpperBound`
- `lambdaMaxOrdered_rayleighUpperBound`

## Proof Status
- lambdaMaxOrdered_spectralUpperBound: proved.
- LambdaMaxOrderedPSDUpperBound: proved by wrapper theorem
  `lambdaMaxOrderedPSDUpperBound`.
- lambdaMaxOrdered Rayleigh bound: proved by wrapper theorem
  `lambdaMaxOrdered_rayleighUpperBound`.

## Commands
- `lake build HighDimProb.RandomMatrix.Spectral`: passed.
- `python scripts/judge_policy_check.py`: passed.
- `git diff --check`: passed with existing CRLF normalization warnings.

## Blockers
- No provider-stage blocker.
- Trace-exp spectral dominance remains unproved and out of scope.
- Full matrix Laplace remains unproved and out of scope.
- Matrix Bernstein remains unproved and out of scope.

## Exactly One Next Safe Task
- Add test and judge coverage for the new provider declarations.
