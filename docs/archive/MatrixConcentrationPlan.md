# Matrix Concentration Plan

This is a boundary summary, not the active plan index. Historical notes are in
[`archive.md`](README.md); active work and the next task live only in
[`TODO.md`](../maintainers/TODO.md).

## Downstream Import

```lean
import HighDimProb.RandomMatrix.Concentration
```

The `HighDimProb.RandomMatrix.Provider.*` hierarchy is the expert
implementation boundary. Downstream applications should use the public facade.

## Supported Route

The finite-dimensional route now includes proved Bernstein CFC,
left/right Lieb--Epstein and Tropp one-step components, and Golden--Thompson via
`goldenThompsonTraceExp`. Current generated-history trace-MGF and tail wrappers
are CFC-free at the caller surface under their documented centeredness,
finite-family independence, integrability, boundedness, scalar-range, and
tail-side hypotheses.

The canonical bounded self-adjoint finite-family Matrix Bernstein result is
complete under the explicit `matrixBernsteinSelfAdjointOptimizedStatement`
contract through `MatrixBernstein.optimized_of_primitives`; the corresponding
`1 - delta` contract is closed by
`MatrixBernstein.highProbability_of_primitives`. Generated-history
centered-rank-one and exact-row sample-covariance endpoints are also available.

## Current Boundaries

- The core contract still exposes positive dimension, centered
  self-adjointness, finite-family independence, summand and square
  integrability, pointwise norm control, variance-proxy control, and scalar
  domain conditions. It is not an unconditional theorem.
- The high-probability form requires `0 < delta <= 1`, nonnegative `sigmaSq`
  and `R`, and `0 < sigmaSq or 0 < R`.
- Arbitrary larger-history conditioning, automatic trace-exp integrability,
  automatic variance-proxy normalization, the older arbitrary-denominator and
  arbitrary-lambda-max variants, and an `n = 0` endpoint remain outside the
  proved contract.
- Exact-row sample covariance still keeps measurability, `MemLp 2`,
  boundedness, independence, and parameter-domain hypotheses explicit.
- Older explicit-CFC and Tropp bundles are compatibility surfaces; they are not
  the preferred downstream route.
