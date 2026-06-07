# Judge Delta

Status: updated for MB-S1.

Initial judge status:
- `HighDimProbJudge.lean` exists.
- Random-matrix judge coverage currently includes operator norm, statements,
  PSD/order, sample covariance, and variance proxy.

MB-S1 judge updates:
- Updated `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean`.
- Added `#check` coverage for:
  - `matrixQuadraticForm_sum`
  - `isPSDMatrix_sum`
  - `matrixQuadraticForm_matrixExpect`
  - `isPSD_matrixSecondMoment_of_selfAdjoint`
  - `isPSD_matrixVarianceProxy_of_selfAdjoint`
- Added downstream-style examples for:
  - PSD of `matrixSecondMoment P A` from self-adjointness and square
    integrability;
  - PSD of `matrixVarianceProxy P A` from per-summand self-adjointness and
    square integrability.

Expected judge command:
- `lake build HighDimProbJudge`
