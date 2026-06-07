# Mathlib Reuse Report

## MB0/MB1 Audit

Existing reuse already present in the matrix branch:
- `Matrix.IsSymm` and `Matrix.IsHermitian` for symmetric/self-adjoint vocabulary.
- `Matrix.mul_apply`, `Matrix.sum_apply`, finite `Finset` sums, and matrix extensionality for entrywise algebra.
- `ProbabilityTheory.iIndepFun` for matrix-valued independence.
- Mathlib scoped `Matrix.Norms.L2Operator` for `operatorNorm` and `deterministicOperatorNorm`.
- `Measurable`, `Integrable`, `MeasureTheory.integral_finset_sum`, and entrywise expectations for matrix integration vocabulary.

Planned proof-search focus:
- Finite-sum identities for quadratic forms of matrix squares.
- Integral/sum commutation and scalar multiplication of integrals for `matrixQuadraticForm_matrixExpect`.
- Finite sum closure of explicit `IsPSDMatrix`.

No optional dependency is planned or added.

## MB2-MB4 Reuse Actually Used

Matrix finite sums:
- `Matrix.mul_apply`
- `Matrix.sum_apply`
- `Finset.mul_sum`
- `Finset.sum_mul`
- `Finset.sum_comm`
- `Finset.sum_congr`
- `Finset.sum_nonneg`

Self-adjoint/symmetric structure:
- `Matrix.IsHermitian.apply`
- `Matrix.IsHermitian.ext`
- `Matrix.IsSymm.ext`
- existing HighDimProb `isSymmetricMatrix_apply`

Scalar ring/order normalization:
- `ring`
- `sq_nonneg`
- existing HighDimProb `matVecSqNorm_nonneg`

Measure/integral layer:
- `MeasureTheory.integral_finset_sum`
- `MeasureTheory.integral_const_mul`
- `MeasureTheory.integral_mul_const`
- `MeasureTheory.integral_nonneg`
- `integrable_finset_sum`
- `Integrable.const_mul`
- `Integrable.mul_const`

No spectral theorem, matrix exponential, trace API, Golden-Thompson theorem,
Lieb theorem, or optional dependency was used.

## Proof Pattern Learned

For structural PSD facts in this branch, the robust route is explicit
quadratic-form algebra:

1. rewrite the quadratic form to finite sums;
2. normalize matrix multiplication with `Matrix.mul_apply`;
3. commute finite sums with `Finset.sum_comm`;
4. prove a pointwise nonnegative expression;
5. lift through entrywise expectation only after adding explicit
   `IntegrableRandomMatrix` assumptions.
