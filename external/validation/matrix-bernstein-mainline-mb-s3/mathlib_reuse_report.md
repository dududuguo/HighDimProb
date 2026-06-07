# MB-S3 Mathlib Reuse Report

## Reused APIs

- `NormedSpace.exp`
  - Source: `Mathlib.Analysis.Normed.Algebra.MatrixExponential`
  - Use: HighDimProb `matrixExp` remains a wrapper around Mathlib matrix
    exponential.

- `Matrix.IsHermitian.exp`
  - Source: `Mathlib.Analysis.Normed.Algebra.MatrixExponential`
  - Use: existing theorem `isSelfAdjointMatrix_matrixExp`.

- `Matrix.trace`
  - Use: HighDimProb `matrixTrace` and `traceMatrixExp`.

- `Matrix.PosSemidef.trace_nonneg`
  - Source: `Mathlib.LinearAlgebra.Matrix.PosDef`
  - Use: new theorem `matrixTrace_nonneg_of_posSemidef`, then
    `traceMatrixExp_nonneg_of_matrixExp_posSemidef`.

- `MeasureTheory.integral_nonneg_of_ae`
  - Use: new theorem `traceExpMoment_nonneg_of_nonneg`.

- `MeasureTheory.ofReal_integral_eq_lintegral_ofReal`
  - Use: new theorem `traceExpMomentLIntegral_eq_ofReal_traceExpMoment`.

- `MeasureTheory.ae_of_all`
  - Use: converts pointwise nonnegativity into the a.e. nonnegativity needed by
    the integral bridge.

## Surveyed But Not Directly Usable

- `IsSelfAdjoint.exp_nonneg`
  - Source: `Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.ExpLog.Basic`
  - Issue: the theorem requires a compatible `PartialOrder` and
    `StarOrderedRing` order. Lean does not synthesize the required order
    instances for `Matrix (Fin n) (Fin n) Real` in the current HighDimProb
    matrix setup.

- Hermitian eigenvalue trace route:
  - `Matrix.IsHermitian.trace_eq_sum_eigenvalues` exists.
  - A direct theorem that eigenvalues of `exp(A)` are `Real.exp` of
    eigenvalues of self-adjoint `A` was not found by name in the current
    imports.

## Resulting Blocker

The remaining deterministic theorem is:

```lean
matrixExp_posSemidef_of_selfAdjoint_statement
```

Likely proof routes:

1. Bridge matrices to ordered finite-dimensional linear maps, use CFC
   positivity, then map the PSD certificate back to `Matrix.PosSemidef`.
2. Use Mathlib Hermitian spectral theorem APIs to prove directly that
   `NormedSpace.exp A` has nonnegative eigenvalues.
