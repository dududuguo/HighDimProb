# MB-S7B-trace-dominates-endpoint Probe Log

## FSM Path
- QUEUED
- SOURCE_READING
- IMPORT_AUDITING
- API_SURVEYING
- TRACE_ENDPOINT_CONTRACTING

## Placement Findings
- `HighDimProb/RandomMatrix/Spectral.lean` defines `lambdaMaxOrdered`.
- `HighDimProb/RandomMatrix/TraceExp.lean` defines `matrixTrace` and imports `Spectral.lean`.
- Importing `TraceExp.lean` into `Spectral.lean` would create a cycle.
- A pure theorem with `Matrix.trace` can live in `Spectral.lean`.

## APIs Probed
- `lambdaMaxOrdered`
- `lambdaMaxOrdered_eq_eigenvalues₀_zero`
- `lambdaMaxOrdered_is_greatest_eigenvalue`
- `lambdaMaxOrdered_smul_of_nonneg`
- `matrixTrace`
- `matrixTrace_apply`
- `Matrix.trace`
- `Matrix.PosSemidef`
- `Matrix.PosSemidef.trace_nonneg`
- `matrixTrace_nonneg_of_posSemidef`
- `matrixExp_posSemidef_of_selfAdjoint`
- `traceMatrixExp`
- `Matrix.IsHermitian.trace_eq_sum_eigenvalues`
- `Matrix.IsHermitian.posSemidef_iff_eigenvalues_nonneg`
- `Matrix.PosSemidef.eigenvalues_nonneg`
- `Matrix.IsHermitian.eigenvalues₀`
- `Matrix.IsHermitian.eigenvalues₀_antitone`
- `Matrix.IsHermitian.eigenvalues`
- `Matrix.IsHermitian.eigenvalues_mem_spectrum_real`
- `Matrix.IsHermitian.spectrum_real_eq_range_eigenvalues`
- `Finset.sum_nonneg`
- `Finset.single_le_sum`
- `Fintype.equivOfCardEq`

## Scratch Proof
- `probe_lambdaMaxOrdered_le_trace_of_posSemidef` compiled.
- Route:
  1. Use `hB.trace_eq_sum_eigenvalues`.
  2. Use `hPSD.eigenvalues_nonneg`.
  3. Use `Finset.single_le_sum`.
  4. Rewrite `lambdaMaxOrdered` through `Matrix.IsHermitian.eigenvalues` and `Fintype.equivOfCardEq`.

## Commands
- `lake env lean external/validation/matrix-bernstein-mainline-mb-s7b-trace-dominates-endpoint/MB_S7B_TraceEndpointProbe.lean`: passed.
- `lake build HighDimProb.RandomMatrix.Spectral`: passed.
- `lake build HighDimProb.RandomMatrix.TraceExp`: passed.
- `python scripts/judge_policy_check.py`: passed.
- `git diff --check`: passed with pre-existing CRLF normalization warnings.

## Exactly One Next Safe Task
- Add the pure `Matrix.trace` endpoint theorem in `HighDimProb/RandomMatrix/Spectral.lean`.

