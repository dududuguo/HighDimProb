# MB-S3 Workflow Delta

## Learned Pattern

Matrix analytic bridge proofs need an explicit Mathlib API survey before Lean
translation. In this stage, the theorem shape split into:

1. a downstream bridge that can be proved from explicit PSD/nonnegativity
   hypotheses; and
2. a narrower spectral/CFC blocker that should remain a typed target.

This pattern avoids overclaiming trace-exponential positivity while still
adding useful infrastructure for future matrix Laplace work.

## Reusable Gate

Before attempting matrix analytic theorems, check:

- whether the target theorem uses HighDimProb explicit `IsPSDMatrix` or
  Mathlib `Matrix.PosSemidef`;
- whether Mathlib CFC theorems require an ordered star-ring instance;
- whether a matrix-to-linear-map bridge is needed before applying CFC order
  theorems;
- whether a real expectation theorem should be stated with pointwise or a.e.
  nonnegativity.

## FSM Update

No FSM file patch was made. Existing `REUSE_SOURCE_VALIDATING` is sufficient if
future matrix analytic stages explicitly include a spectral/CFC-order API
survey before translation.

## Next Workflow Recommendation

Add a focused MB-S4 stage for `matrixExp_posSemidef_of_selfAdjoint_statement`
instead of attempting matrix Laplace or matrix Bernstein directly.
