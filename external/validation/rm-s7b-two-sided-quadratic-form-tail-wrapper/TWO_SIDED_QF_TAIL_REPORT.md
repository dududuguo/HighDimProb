# RM-S7B Two-Sided Quadratic-Form Tail Report

## Result

RM-S7B adds a conditional two-sided quadratic-form Matrix Bernstein wrapper:

- `quadraticFormLowerTailEvent_subset_quadraticFormUpperTailEvent_neg`
- `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`

The theorem bounds

```text
P (twoSidedQuadraticFormTailEvent (randomMatrixSum A) t)
```

by the sum of the optimized one-sided scalar RHS for `A` and the optimized
one-sided scalar RHS for pointwise `-A`.

## Reused API

- `twoSidedQuadraticFormTailEvent`
- `quadraticFormUpperTailEvent`
- `quadraticFormLowerTailEvent`
- `randomMatrixSum`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`
- `PointwiseOperatorNormBound`
- `MatrixVarianceProxyNormBound`
- `bernsteinThetaChoice`
- `bernsteinMatrixExp_le_quadratic_statement`
- `troppMasterTraceMGFFiniteFamily_statement`
- `measure_union_le`

## Explicit Assumptions

The wrapper intentionally keeps the following assumptions explicit for both
signs when required by the reused one-sided API:

- centered self-adjoint family assumptions;
- independent self-adjoint family assumptions;
- summand and square integrability assumptions;
- trace-exponential and scaled-exponential integrability assumptions;
- pointwise operator-norm radius bounds;
- scalar variance-proxy norm bounds;
- positive variance proxies and nonnegative radii;
- Bernstein CFC primitives;
- Tropp finite-family trace-MGF primitives.

## Non-Goals

RM-S7B does not prove:

- a self-adjoint operator-norm tail theorem;
- a finite-net reduction;
- variance-proxy control;
- Tropp/Lieb, Bernstein CFC, or Golden-Thompson;
- a CFC-free Matrix Bernstein theorem.

## FSM State Log

- `READY -> ACTIVE`: governance docs, FSM docs, prior validation artifacts,
  and source references read.
- `ACTIVE -> IMPLEMENTED`: minimal spectral event bridge and two-sided
  concentration wrapper added.
- `IMPLEMENTED -> VALIDATING`: test/judge API checks, docs, and validation
  artifacts updated.
- `VALIDATING -> COMPLETE`: RM-S7B probe, focused modules, full build/test,
  judge build, policy check, whitespace check, and disallowed-token checks
  passed.

## Validation Summary

All required validation commands completed successfully. `git diff --check`
returned exit status 0 and repeated the pre-existing warning that
`docs/visualizations/lake_import_graph.html` has CRLF normalization pending
the next time Git touches it; RM-S7B did not edit that file.
