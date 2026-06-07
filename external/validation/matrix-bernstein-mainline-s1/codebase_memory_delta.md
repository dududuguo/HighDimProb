# Codebase Memory Delta

Status: manual delta recorded; codebase-memory MCP fast index refreshed.

Codebase-memory project:
- `C-Users-11388-reserach-HighDimProb`

Discovery:
- Initial preflight had no callable graph tools in context.
- On continuation, `search_graph` and `get_code_snippet` were available and
  used to inspect matrix Bernstein and variance-proxy declaration locations.

Files touched in the matrix branch:
- `HighDimProb/RandomMatrix/MatrixOrder.lean`
- `HighDimProb/RandomMatrix/VarianceProxy.lean`
- `HighDimProb/RandomMatrix/ConcentrationStatements.lean`

New declarations:
- `matrixQuadraticForm_sum`
- `isPSDMatrix_sum`
- `matrixQuadraticForm_matrixSquare_eq_matVecSqNorm_of_selfAdjoint`
- `isPSD_matrixSquare_of_selfAdjoint`
- `matrixQuadraticForm_matrixExpect`
- `isPSD_matrixSecondMoment_of_selfAdjoint`
- `isPSD_matrixVarianceProxy_of_selfAdjoint`

Updated declarations:
- `matrixBernsteinSelfAdjointStatement` now includes per-summand square
  integrability and no longer has a separate PSD variance-proxy assumption.
- `matrixBernsteinStatement` remains compatible and keeps its explicit PSD
  variance-proxy assumption.

Theorem status:
- PSD square theorem: proven.
- Quadratic-form / matrix expectation bridge: proven.
- PSD second moment theorem: proven with square-integrability assumption.
- PSD variance proxy theorem: proven with per-summand square-integrability.
- Matrix Bernstein: not proved.

Tests/judge touched:
- `HighDimProbTest/RandomMatrixConcentrationAPI.lean`
- `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean`
- `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean`

Remaining blockers:
- spectral/operator-norm tail reduction;
- matrix Laplace transform;
- trace exponential moment bound;
- Golden-Thompson/Lieb-style prerequisites.

MCP refresh:
- `index_repository` ran in `fast` mode with persistence for
  `C:/Users/11388/reserach/HighDimProb`.
- Result: project `C-Users-11388-reserach-HighDimProb` indexed with 1285 nodes
  and 2735 edges; `.codebase-memory/graph.db.zst` artifact present.
