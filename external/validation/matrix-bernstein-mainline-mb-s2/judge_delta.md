# MB-S2 Judge Delta

## Judge Files Updated

- `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`
- `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`

## New Judge Coverage

Spectral:

- quadratic-form bound monotonicity lemmas;
- two-sided quadratic-form tail event vocabulary;
- one-sided subset lemmas;
- lambda endpoint typed statements;
- self-adjoint operator-norm / quadratic-form typed target.

Trace-exp:

- `traceExpMomentLIntegral`;
- trace-exp nonnegativity typed targets;
- real-expectation / lintegral typed target.

Laplace:

- lintegral matrix Laplace RHS;
- lintegral matrix Laplace typed target;
- lintegral Chernoff typed target;
- self-adjoint operator-norm lintegral Laplace RHS and typed target.

Matrix Bernstein:

- `matrixBernsteinLaplacePrerequisitesStatement`.

## Policy Script

No policy-script change was required in MB-S2. The existing script already
checks forbidden tokens, theorem-like True-bodied declarations, stable-root import boundaries,
ordinary judge experimental-import boundaries, and judge-root import
completeness.
