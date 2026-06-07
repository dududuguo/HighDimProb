# MB-S7A-provider Read Once Manifest

## FSM State
- API_SURVEYING

## Sequential Fallback
- Requested worktrees were not created because the repository already has broad
  dirty/untracked state. The five phases are run sequentially with explicit
  file leases.

## Files Read
- `HighDimProb/RandomMatrix/Spectral.lean`
- `HighDimProb/RandomMatrix/SelfAdjoint.lean`
- `HighDimProb/RandomMatrix/MatrixOrder.lean`
- `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- `external/validation/matrix-bernstein-mainline-mb-s7a/final_report.md`
- local Mathlib matrix/CFC source files under `.lake/packages/mathlib/`

## Files To Write
- `external/validation/matrix-bernstein-mainline-mb-s7a-provider/BLACKBOARD.md`
- `external/validation/matrix-bernstein-mainline-mb-s7a-provider/MB_S7A_ProviderProbe.lean`
- `external/validation/matrix-bernstein-mainline-mb-s7a-provider/provider_probe_log.md`
- `external/validation/matrix-bernstein-mainline-mb-s7a-provider/PROVIDER_CONTRACT.md`

## Scope Guard
- Probe phase writes validation files only.
- No Lean source, test, judge, or docs edits in the probe phase.
