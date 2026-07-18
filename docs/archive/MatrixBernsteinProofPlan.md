# Matrix Bernstein Proof Plan

This file records the current proof boundary, not the active task. Historical
notes are in [`archive.md`](README.md); active work is tracked only in
[`TODO.md`](../maintainers/TODO.md).

## Downstream Import

```lean
import HighDimProb.RandomMatrix.Concentration
```

`HighDimProb.RandomMatrix.Provider.*` imports are expert implementation
surfaces, not the default downstream API.

## Closed Surface

- `goldenThompsonTraceExp` proves the finite-dimensional real self-adjoint
  Golden--Thompson endpoint.
- `bernsteinMatrixExp_le_quadratic` proves the pointwise Bernstein CFC bound.
- The current generated-history wrappers, including
  `troppMasterTraceMGFFiniteFamily_generatedHistory_of_bernsteinPrimitives` and
  `matrixBernsteinTraceMGFWithBernsteinCoeff_generatedHistory_of_bernsteinPrimitives`,
  are CFC-free at the call site under their documented centeredness,
  independence, integrability, norm, and scalar-range hypotheses.
- `MatrixBernstein.optimized_of_primitives` proves the canonical optimized
  self-adjoint Matrix Bernstein statement for every finite index type.
  `MatrixBernstein.highProbability_of_primitives` proves its `1 - delta` form.
- The centered-rank-one and exact-row sample-covariance specializations are
  listed in [`RandomMatrixAPI.md`](../user/RandomMatrixAPI.md).

## Exact Boundary

The optimized theorem contract keeps `0 < n`, summand and square integrability,
centered self-adjointness, finite-family independence, a pointwise operator-norm
bound, a variance-proxy norm bound, and nonnegative `sigmaSq`, `R`, and `t`
explicit. The high-probability contract additionally requires
`0 < delta <= 1` and `0 < sigmaSq or 0 < R`.

Thus the core bounded self-adjoint finite-family theorem is complete under its
explicit contract. It does not supply automatic variance-proxy bounds,
arbitrary-larger-history conditional expectation, the older
arbitrary-denominator or arbitrary-lambda-max variants, or an `n = 0`
endpoint. Explicit-CFC bundles remain compatibility surfaces, not evidence of a
missing CFC theorem.
