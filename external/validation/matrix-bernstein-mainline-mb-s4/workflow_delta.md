# MB-S4 Workflow Delta

## New Proof Pattern

For matrix analytic positivity goals, survey Mathlib's scoped matrix order and
CFC APIs before attempting eigenvalue or square-factor proofs.

The successful MB-S4 route was:

1. Open the matrix Loewner-order scope and matrix operator-norm scope.
2. Convert `A.IsHermitian` to root `IsSelfAdjoint A` via
   `hA.isSelfAdjoint`.
3. Use `IsSelfAdjoint.exp_nonneg` for `0 <= NormedSpace.exp A`.
4. Convert scoped matrix nonnegativity to `Matrix.PosSemidef` using
   `Matrix.nonneg_iff_posSemidef`.
5. Reuse existing trace and expectation wrappers downstream.

## Guardrail Learned

Do not treat statement abbreviations as theorem evidence. The existing
`matrixExp_posSemidef_of_selfAdjoint_statement` remained a typed target until
the compiled theorem `matrixExp_posSemidef_of_selfAdjoint` was added.

## FSM / Workflow Recommendation

No structural FSM patch is required. Future matrix analytic bridge stages should
include an explicit Mathlib scoped-order/CFC audit gate under the existing
`REUSE_SOURCE_VALIDATING` workflow before translation.

The next safe stage is MB-S5 survey / conditional Markov-Laplace bridge work.
It must not claim full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, or
Matrix Bernstein without complete Lean proofs.
