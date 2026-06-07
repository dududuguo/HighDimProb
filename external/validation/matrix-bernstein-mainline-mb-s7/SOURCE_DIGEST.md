# Source Digest

## Active Stage

- Stage MB-S7.0 - source/API survey for a direct proof of
  `TraceExpDominatesQuadraticFormUpperTail Y theta t`.

## Source Files Checked

- `external/theory-roadmap/sources/High-Dimensional_Probability.md`
- `external/theory-roadmap/sources/Topics_in_Random_Matrix_Theory.md`
- `external/theory-roadmap/roadmap/roadmap_digest.md`
- `external/validation/matrix-bernstein-mainline-mb-s6/SOURCE_DIGEST.md`
- `external/validation/matrix-bernstein-mainline-mb-s6/final_report.md`

## Relevant Source Statements

### Source Statement 1

- Path: `external/theory-roadmap/sources/High-Dimensional_Probability.md`
- Section / name: Section 4.1.2, min-max theorem / operator norm facts.
- Statement summary: For symmetric matrices, eigenvalues have min-max
  characterizations, and the operator norm satisfies
  `||A|| = max_k |lambda_k(A)| = max_{||x||=1} |x^T A x|`.
- Assumptions: real symmetric matrix, Euclidean unit sphere, ordered real
  eigenvalues.
- Depends on: spectral theorem, min-max/Rayleigh bridge.
- Formalization recommendation: `USE_EXPLICIT_HYPOTHESIS` until HighDimProb's
  explicit `matrixQuadraticForm` / `IsUnitVector` layer is bridged to Mathlib's
  `ContinuousLinearMap.rayleighQuotient` or matrix eigenvalue API.

### Source Statement 2

- Path: `external/theory-roadmap/sources/High-Dimensional_Probability.md`
- Section / name: Section 5.4.3, Proof of matrix Bernstein, Step 1:
  Reduction to MGF.
- Statement summary: For a symmetric sum `S` and `lambda >= 0`, the proof
  bounds `P(lambda_max(S) >= t)` by applying scalar Markov to
  `exp(lambda * lambda_max(S))`. Since the eigenvalues of `exp(lambda S)` are
  `exp(lambda * lambda_i(S))`, the maximal eigenvalue of `exp(lambda S)` is
  bounded by `tr exp(lambda S)`.
- Assumptions: symmetric/self-adjoint `S`, largest eigenvalue vocabulary,
  nonnegative scalar parameter, trace of matrix exponential.
- Depends on: scalar Markov, spectral calculus for matrix exponential, trace as
  sum of eigenvalues, positivity of exponential eigenvalues.
- Formalization recommendation: `PROVE_DIRECT_FROM_EXISTING_API` only after
  the HighDimProb tail event is connected to Mathlib eigenvalue/Rayleigh
  vocabulary. At the current API boundary, keep an explicit dominance
  hypothesis.

### Source Statement 3

- Path: `external/theory-roadmap/sources/Topics_in_Random_Matrix_Theory.md`
- Section / name: Section 1.3, equation (1.52), Theorem 1.3.1, and Theorem
  1.3.2.
- Statement summary: Hermitian matrices admit a real ordered spectrum and an
  orthonormal eigenbasis; the largest eigenvalue satisfies the Rayleigh formula
  `lambda_1(A) = sup_{|v|=1} v^* A v`; Courant-Fischer gives the full min-max
  theorem.
- Assumptions: Hermitian/self-adjoint finite-dimensional matrix.
- Depends on: spectral theorem and Courant-Fischer min-max theorem.
- Formalization recommendation: `USE_EXPLICIT_HYPOTHESIS` unless the Mathlib
  linear-map Rayleigh API can be bridged to the matrix entries already used by
  HighDimProb.

## Mathlib / HighDimProb API Candidates

- Mathlib:
  - `ContinuousLinearMap.rayleighQuotient`
  - `ContinuousLinearMap.iSup_rayleigh_eq_iSup_rayleigh_sphere`
  - `ContinuousLinearMap.norm_eq_iSup_rayleighQuotient`
  - `Matrix.trace_eq_sum_eigenvalues`
  - `Matrix.IsHermitian.posSemidef_iff_eigenvalues_nonneg`
  - `Matrix.PosSemidef.eigenvalues_nonneg`
  - `Matrix.PosSemidef.trace_nonneg`
- HighDimProb:
  - `lambdaMax`, `lambdaMin`
  - `lambdaMax_is_greatest_eigenvalue_statement`
  - `lambdaMax_le_iff_quadraticForm_le_statement`
  - `operatorNorm_eq_max_abs_lambda_statement`
  - `quadraticFormUpperTailEvent`
  - `traceExpThresholdEvent`
  - `TraceExpDominatesQuadraticFormUpperTail`

## Facts Not Found

- No compiled HighDimProb theorem currently proves
  `TraceExpDominatesQuadraticFormUpperTail Y theta t` directly.
- No compiled HighDimProb theorem currently bridges
  `quadraticFormUpperTailEvent` to `lambdaMax` or to Mathlib's
  `ContinuousLinearMap.rayleighQuotient`.
- No compiled theorem currently proves that the eigenvalue of
  `exp(theta • Y omega)` matching the quadratic-form tail is bounded by
  `traceMatrixExp (theta • Y omega)` in the exact current event API.

## Recommendation

- `USE_EXPLICIT_HYPOTHESIS` for theorem-facing code until the Rayleigh bridge
  is proved.
- Next stage should be an API contract/scratch proof stage over a leased
  spectral bridge file, not a Matrix Bernstein proof stage.
