# MB-S3 Codebase Memory Delta

## Files Touched

- `HighDimProb/RandomMatrix/TraceExp.lean`
- `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- `docs/MatrixBernsteinProofPlan.md`
- `docs/MatrixConcentrationPlan.md`
- `docs/TheoremAtlas.md`
- `docs/TermMap.md`
- `docs/AbstractionLog.md`
- `docs/TODO.md`
- `docs/Status.md`
- `docs/TestPlan.md`
- `docs/JudgeSystem.md`
- `docs/BranchRegistry.md`
- `docs/LeafPlan.md`
- `docs/BookProgress.md`
- `external/validation/matrix-bernstein-mainline-mb-s3/*`

## New Declarations

- `matrixTrace_nonneg_of_posSemidef`
- `traceMatrixExp_nonneg_of_matrixExp_posSemidef`
- `matrixExp_posSemidef_of_selfAdjoint_statement`
- `traceExpIntegrand`
- `traceExpMoment_nonneg_of_nonneg`
- `traceExpMomentLIntegral_nonneg`
- `traceExpMomentLIntegral_eq_ofReal_traceExpMoment`

## Status

- Trace nonnegativity from a Mathlib PSD certificate: proven.
- Trace of matrix exponential nonnegativity from a Mathlib PSD certificate for
  the exponential: proven.
- Real trace-exp moment nonnegativity from explicit pointwise nonnegativity:
  proven.
- ENNReal trace-exp lintegral nonnegativity: proven.
- Real expectation / lintegral bridge under explicit integrability and
  pointwise nonnegativity: proven.
- `traceMatrixExp_nonneg_of_selfAdjoint`: still typed target only.
- Matrix Bernstein: not proved.

## Mathlib Dependencies

- `Matrix.PosSemidef.trace_nonneg`
- `Matrix.IsHermitian.exp`
- `NormedSpace.exp`
- `Matrix.trace`
- `ofReal_integral_eq_lintegral_ofReal`
- `integral_nonneg_of_ae`
- `ae_of_all`

## Blocker

`matrixExp_posSemidef_of_selfAdjoint_statement` remains open. Mathlib CFC has
`IsSelfAdjoint.exp_nonneg`, but this theorem is not directly applicable to
`Matrix (Fin n) (Fin n) Real` because the required ordered star-ring structure
does not synthesize for the current matrix type.

## Judge Coverage

`HighDimProbJudge/RandomMatrix/TraceExpUse.lean` checks all new public
trace-exp declarations and contains examples applying the real moment
nonnegativity theorem and the real/lintegral bridge theorem.

## MCP Refresh

`codebase-memory-mcp.index_repository` completed in fast mode with persistence:

- project: `C-Users-11388-reserach-HighDimProb`
- nodes: 1339
- edges: 2567
- artifact: `.codebase-memory/graph.db.zst`
