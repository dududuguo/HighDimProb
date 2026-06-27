# Matrix Bernstein Proof Plan

This file records only the current proof boundary. Old proof notes were
collapsed into [`archive.md`](archive.md); use git history for exact old wording.

## Proved Under Explicit Primitives

- `matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives`
- `matrixBernsteinTraceMGF_under_tropp`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions`
- `matrixBernsteinQuadTail_opt_of_tropp`
- `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`
- `matrixBernsteinQuadTail_twoSided_opt_of_tropp`
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_pos_under_primitives`
- `matrixBernsteinOpNormTail_opt_of_tropp`
- sample-covariance quadratic-form and operator-norm wrappers listed in [`RandomMatrixAPI.md`](RandomMatrixAPI.md)

## Shared RHS Helpers

- `matrixBernsteinOptimizedScalarTailRHS`
- `matrixBernsteinTwoSidedOptimizedScalarTailRHS`
- `sampleCovarianceQuadraticFormTailRHS`

## Still Not Claimed

- Full Tropp/Lieb proof.
- Golden-Thompson route.
- Arbitrary lambda-max Matrix Bernstein tail theorem.
- Nonnegative-threshold zero-dimensional operator-norm endpoint.
- Tropp-only sample-covariance concentration wrappers without explicit
  sample-covariance CFC fields.

## Current CFC Boundary

The pointwise Bernstein CFC primitive is proved by
`bernsteinMatrixExp_le_quadratic`. Preferred optimized Matrix Bernstein
surfaces use `MatrixBernsteinPositiveSideTroppAssumptions` and
`MatrixBernsteinNegativeSideTroppAssumptions`; compatibility wrappers with
explicit `cfcPrimitive` fields remain available for older call sites and for
sample-covariance wrappers that have not yet been cleaned.

## Rule

A wrapper may shorten a public call site only when it is a theorem-backed
adapter or a transparent packaging of existing assumptions. Do not turn missing
analytic primitives into documentation claims.
