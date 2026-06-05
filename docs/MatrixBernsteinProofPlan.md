# Matrix Bernstein Proof Plan

Stage MC4-cleanup records the current honest proof plan for matrix Bernstein.
This document is documentation-only for the missing analytic machinery; the
Lean file keeps only typed `Prop` statements whose objects already exist.

## Target Theorem

For a finite family of independent centered self-adjoint random matrices
`A_i : Omega -> Matrix (Fin n) (Fin n) Real`, the intended additive-form
Bernstein target is:

```text
P(||sum_i A_i|| >= t) <= 2*n*exp(-t^2 / (c1*sigma2 + c2*R*t)).
```

The refined Lean target is `matrixBernsteinSelfAdjointStatement`. It now
explicitly assumes:

- `0 < n`;
- `IsProbabilityMeasure P`;
- entrywise `IntegrableRandomMatrix P (A i)` for every summand;
- `CenteredSelfAdjointRandomMatrixFamily P A`;
- `IndependentSelfAdjointRandomMatrices P A`;
- `PointwiseOperatorNormBound A R`;
- `IsPSDMatrix (matrixVarianceProxy P A)`;
- `matrixVarianceProxyNorm P A <= sigma2`;
- `0 <= sigma2`, `0 <= R`, `0 < c1`, `0 < c2`, `0 <= t`;
- `0 < c1 * sigma2 + c2 * R * t`.

The older `matrixBernsteinStatement` remains a typed min-form statement for
compatibility, but the proof-ready statement is the additive-form
`matrixBernsteinSelfAdjointStatement`.

## Proven Infrastructure

| Area | Declarations |
|---|---|
| Random matrix sums | `randomMatrixSum`, `isRandomMatrix_sum` |
| Self-adjoint sums | `isSelfAdjointMatrix_sum`, `randomSelfAdjointMatrix_sum` |
| Matrix expectation | `matrixExpect`, `centeredRandomMatrix`, `IntegrableRandomMatrix` |
| Operator norm bridge | `operatorNorm_le_of_operatorNormBoundSq`, `operatorNormBoundSq_of_operatorNorm_le` |
| Operator norm measurability | `isRealRandomVariable_operatorNorm` |
| Sample covariance PSD | `isPSD_sampleCovariance`, `randomPSDMatrix_sampleCovariance` |
| Matrix square self-adjointness | `isSelfAdjointMatrix_matrixSquare_of_isSelfAdjointMatrix` |
| Second moment self-adjointness | `isSelfAdjointMatrix_matrixSecondMoment` |
| Variance proxy self-adjointness | `isSelfAdjointMatrix_matrixVarianceProxy` |

## Typed Statements Only

| Target | Declaration | Status |
|---|---|---|
| Matrix Bernstein min-form | `matrixBernsteinStatement` | typed `Prop`, unproved |
| Matrix Bernstein additive form | `matrixBernsteinSelfAdjointStatement` | typed `Prop`, unproved |
| Matrix Hoeffding | `matrixHoeffdingStatement` | typed `Prop`, unproved |
| Matrix Chernoff | `matrixChernoffStatement` | typed `Prop`, unproved |
| Covariance estimation | `covarianceEstimationStatement` | typed `Prop`, unproved |
| Sample covariance operator norm | `sampleCovarianceOperatorNormStatement` | typed `Prop`, unproved |
| Sample covariance unit-sphere route | `sampleCovarianceOperatorNormViaUnitSphereStatement` | typed `Prop`, unproved |
| Spectral-radius bridge | `operatorNorm_eq_spectralRadius_of_selfAdjointStatement` | typed `Prop`, unproved |
| PSD matrix square | `isPSD_matrixSquare_of_selfAdjoint_statement` | typed `Prop`, unproved |
| PSD second moment | `isPSD_matrixSecondMoment_of_selfAdjoint_statement` | typed `Prop`, unproved |
| PSD variance proxy | `isPSD_matrixVarianceProxy_of_selfAdjoint_statement` | typed `Prop`, unproved |

## Documentation-Only TODOs

The following are not Lean declarations, because the required objects or major
analytic theorems are not available cleanly enough for honest typed statements:

- matrix Laplace transform bound;
- trace exponential moment bound;
- Golden-Thompson inequality;
- Lieb concavity / Tropp master bound;
- lambda-max/eigenvalue tail bridge beyond the spectral-radius typed target.

No Lean declaration named `matrixLaplaceTransformStatement` or
`traceExpMomentBoundStatement` remains after MC4-cleanup.

## PSD Variance Proxy Status

The PSD variance proxy theorem is not proved. The honest typed target is:

```lean
isPSD_matrixVarianceProxy_of_selfAdjoint_statement
```

It remains blocked by:

1. PSD of the square of a self-adjoint matrix in the explicit
   `IsPSDMatrix` predicate;
2. expectation preserving PSD through entrywise `matrixExpect`;
3. finite sums preserving PSD in the explicit quadratic-form order.

The code does prove self-adjointness of the square, second moment, and variance
proxy; it does not prove PSD for those expectation/sum objects.

## Proof Route

1. Prove the PSD algebra layer for `A^2`, `E[A^2]`, and
   `sum_i E[A_i^2]`.
2. Refine or prove the spectral-radius/operator-norm bridge for self-adjoint
   matrices.
3. Add honest trace-exponential vocabulary only after the matrix exponential,
   trace, and measurability/integrability interfaces are clear.
4. Prove or import the matrix Laplace transform method, which likely requires
   Golden-Thompson and Lieb-style trace inequalities.
5. Optimize the resulting scalar parameter to derive the additive Bernstein
   denominator and then any min-form corollary.

## Next Safe Task

Stage MC4-psd - PSD square and variance-proxy algebra cleanup.
