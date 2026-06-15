# RM-S7A Lambda-Max Tail Bridge Report

## Result

Proved the smallest ordered endpoint bridge:

```lean
theorem lambdaMaxOrderedUpperTailEvent_subset_quadraticFormUpperTailEvent
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega (n + 1) (n + 1))
    (hA : forall omega, IsSelfAdjointMatrix (A omega)) (t : Real) :
    lambdaMaxOrderedUpperTailEvent A hA t <=
      quadraticFormUpperTailEvent A t
```

This proves the requested goal shape under the weakest current assumptions:
the nonempty ordered endpoint dimension `Fin (n + 1)` and the existing
pointwise self-adjointness witness required by `lambdaMaxOrderedUpperTailEvent`.
No probability, measurability, nonnegativity of `t`, Matrix Bernstein
primitive, or finite-net assumption is needed.

## Proof Route

For each sample `omega`, choose the Mathlib Hermitian eigenvector basis vector
corresponding to the ordered endpoint index. Mathlib gives norm one and the
quadratic-form identity through `eigenvalues_eq`; HighDimProb converts the norm
one statement to `IsUnitVector` and rewrites the explicit `matrixQuadraticForm`
normal form. This yields a witness for `quadraticFormUpperTailEvent` whenever
`t <= lambdaMaxOrdered (A omega) (hA omega)`.

## APIs Reused

- `lambdaMaxOrdered`
- `lambdaMaxOrderedUpperTailEvent`
- `quadraticFormUpperTailEvent`
- `matrixUpperBoundTailEvent`
- `matrixQuadraticForm`
- `isUnitVector_of_norm_toLp_eq_one`
- `Matrix.IsHermitian.eigenvectorBasis`
- `Matrix.IsHermitian.eigenvalues_eq`
- `OrthonormalBasis.norm_eq_one`
- `Fintype.equivOfCardEq`

## What Remains Unproved

- The legacy `lambdaMax` compatibility route remains typed only through
  `lambdaMax_eq_lambdaMaxOrdered_statement`.
- The self-adjoint operator-norm event reduction remains typed only through
  `selfAdjointOperatorNormTailViaQuadraticFormStatement`.
- No operator-norm tail theorem, Matrix Bernstein theorem, Tropp/Lieb theorem,
  Bernstein CFC primitive, Golden-Thompson theorem, full matrix Laplace, or
  trace-MGF theorem was proved in this step.

## Classification

`PROVED_LAMBDA_MAX_ORDERED_TAIL_BRIDGE`

## Next Safe Task

`RM-S7B-self-adjoint-operator-norm-tail-bridge`
