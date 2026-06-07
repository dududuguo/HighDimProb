# Judge Delta - MC5

Status: complete

## Existing RandomMatrix Judge Coverage Before MC5

- `HighDimProbJudge/RandomMatrix/OperatorNormUse.lean`
- `HighDimProbJudge/RandomMatrix/PSDUse.lean`
- `HighDimProbJudge/RandomMatrix/SampleCovarianceUse.lean`
- `HighDimProbJudge/RandomMatrix/StatementUse.lean`
- `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean`

## New Judge Files

- `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`
- `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`

## Judge Root Update

`HighDimProbJudge.lean` now imports every MC5 judge file. The policy script's
judge-root import check passes.

## Coverage Added

Spectral judge:

- lambda-max/min wrappers,
- quadratic-form upper/lower bound predicates,
- quadratic-form tail events,
- self-adjoint operator-norm tail event,
- typed Rayleigh/operator-norm bridge targets.

Trace-exp judge:

- matrix exponential wrapper,
- matrix trace wrapper,
- trace of matrix exponential,
- trace-exponential moment,
- self-adjointness of matrix exponential,
- typed trace-exponential bound targets.

Laplace judge:

- `matrixLaplaceRHS`,
- `matrixLaplaceTransformStatement`,
- `matrixChernoffFromTraceExpStatement`,
- `selfAdjointOperatorNormLaplaceStatement`.

Matrix Bernstein judge:

- refined matrix Bernstein statement-layer imports,
- MC5 spectral/trace-exp/Laplace dependencies visible through
  `HighDimProb.RandomMatrix`.

## Validation

- `lake build HighDimProbJudge`: passed.
- `python scripts/judge_policy_check.py`: passed.

Implementation note: `TraceExpUse.lean` is in a `noncomputable section` because
the trace-exponential moment examples call noncomputable matrix exponential
vocabulary.
