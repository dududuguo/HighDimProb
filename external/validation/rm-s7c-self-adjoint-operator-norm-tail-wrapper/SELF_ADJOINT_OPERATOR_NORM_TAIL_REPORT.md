# RM-S7C Self-Adjoint Operator-Norm Tail Report

## Result

Added the conditional wrapper
`matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`.

The theorem proves

```lean
P (SelfAdjointOperatorNormTailEvent (randomMatrixSum A) t) <=
  ENNReal.ofReal ((n + 1 : Real) *
    Real.exp (-(t ^ 2 / (2 * sigmaSq + (2 / 3) * R * t)))) +
  ENNReal.ofReal ((n + 1 : Real) *
    Real.exp (-(t ^ 2 / (2 * sigmaSqNeg + (2 / 3) * Rneg * t))))
```

under the RM-S7B two-sided assumptions and the explicit bridge assumption

```lean
selfAdjointOperatorNormTailViaQuadraticFormStatement (randomMatrixSum A) t
```

## Conditional Boundary

The operator-norm-to-two-sided-quadratic-form bridge is still a typed statement
in the current API. RM-S7C does not prove it. The new wrapper is therefore
conditional on that bridge.

## APIs Reused

- `SelfAdjointOperatorNormTailEvent`
- `twoSidedQuadraticFormTailEvent`
- `selfAdjointOperatorNormTailViaQuadraticFormStatement`
- `randomSelfAdjointMatrix_sum`
- `measure_mono`
- `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`

## FSM State Log

`QUEUED -> EXTRACTING -> EXTRACTED -> REUSE_SOURCE_VALIDATING -> TRANSLATING -> TRANSLATED -> COMPILING -> COMPILED -> REVIEWING -> APPROVED -> VERIFYING -> VERIFIED -> INTEGRATING`

## Out of Scope

This round does not prove full Matrix Bernstein, variance-proxy control,
Tropp/Lieb, Bernstein CFC, Golden-Thompson, a finite-net proof, or a CFC-free
Matrix Bernstein theorem.
