# MB-S7A-provider Probe Log

## FSM Path
- QUEUED
- API_SURVEYING
- PROVIDER_CONTRACTING

## Files Read
- `HighDimProb/RandomMatrix/Spectral.lean`
- `HighDimProb/RandomMatrix/SelfAdjoint.lean`
- `HighDimProb/RandomMatrix/MatrixOrder.lean`
- `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- `external/validation/matrix-bernstein-mainline-mb-s7a/final_report.md`
- `.lake/packages/mathlib/Mathlib/Analysis/Matrix/Spectrum.lean`
- `.lake/packages/mathlib/Mathlib/Analysis/Matrix/PosDef.lean`
- `.lake/packages/mathlib/Mathlib/Analysis/Matrix/Order.lean`
- `.lake/packages/mathlib/Mathlib/Analysis/Matrix/HermitianFunctionalCalculus.lean`
- `.lake/packages/mathlib/Mathlib/Analysis/CStarAlgebra/ContinuousFunctionalCalculus/Unital.lean`

## Probe Result
- Direct provider route typechecked in
  `external/validation/matrix-bernstein-mainline-mb-s7a-provider/MB_S7A_ProviderProbe.lean`.
- The route proves `SpectralUpperBound A (lambdaMaxOrdered A hA)` from:
  - `le_algebraMap_of_spectrum_le`
  - `Matrix.IsHermitian.spectrum_real_eq_range_eigenvalues`
  - `Matrix.IsHermitian.eigenvalues₀_antitone`
  - `Matrix.le_iff`
  - `Algebra.algebraMap_eq_smul_one`
- Source will need access to `Mathlib.Analysis.Matrix.Order` for the matrix
  order/CFC theorem and `Matrix.le_iff`.

## Commands
- `lake env lean external/validation/matrix-bernstein-mainline-mb-s7a-provider/MB_S7A_ProviderProbe.lean`: passed.
- `lake build HighDimProb.RandomMatrix.Spectral`: passed.
- `python scripts/judge_policy_check.py`: passed.
- `git diff --check`: passed with existing CRLF normalization warnings.

## Exactly One Next Safe Task
- Dispatch provider proof with `PROVIDER_DIRECT_READY`.
