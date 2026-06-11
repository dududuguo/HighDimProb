# Matrix Bernstein MB-S9 Milestone Summary

## Scope
- RandomMatrix / Matrix Bernstein trace-MGF infrastructure.
- Scalar concentration files were not touched.

## Main Public Declarations Added

### Matrix order / expectation infrastructure
- `matrixQuadraticForm_add`
- `matrixQuadraticForm_smul`
- `isPSDMatrix_zero`
- `isPSDMatrix_add`
- `isPSDMatrix_smul_of_nonneg`
- `matrixLE_refl`
- `matrixLE_of_eq`
- `matrixLE_trans`
- `matrixLE_add`
- `matrixLE_add_left`
- `matrixLE_add_right`
- `matrixLE_smul_of_nonneg`
- `integrableRandomMatrix_sub`
- `integrableRandomMatrix_add`
- `integrableRandomMatrix_smul`
- `integrableRandomMatrix_zero`
- `integrableRandomMatrix_const`
- `matrixExpect_sub`
- `matrixExpect_add`
- `matrixExpect_smul`
- `matrixExpect_zero`
- `matrixExpect_const`
- `matrixExpect_const_of_isProbabilityMeasure`
- `matrixExpect_one_of_isProbabilityMeasure`
- `isPSDMatrix_matrixExpect_of_pointwise_isPSD`
- `matrixExpect_matrixLE_of_pointwise_matrixLE`

### Bernstein coefficient and exp lower bound
- `bernsteinMGFCoeff`
- `bernsteinCoefficient_nonneg`
- `bernsteinMGFCoeff_nonneg`
- `matrixLE_one_add_self_le_matrixExp_of_selfAdjoint`
- `matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint`

### Single-summand provider under CFC primitive
- `singleSummandMatrixMGFVarianceProxy_statement`
- `bernsteinMatrixExp_le_quadratic_statement`
- `singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic`

### Bounded RHS normalization
- `TraceMGFBernsteinVarianceProxyBound`
- `TraceMGFBernsteinVarianceProxyBoundLIntegral`
- `traceMGFBernsteinVarianceProxyBound_statement`
- `matrixBernsteinTraceMGFWithBernsteinCoeff_statement`

### Tropp finite-family typed primitive
- `troppMasterTraceMGFFiniteFamily_statement`
- `troppMasterTraceMGFStep_statement`

### Trace-MGF wrappers under primitives
- `traceMGFBernsteinVarianceProxyBound_of_troppMasterTraceMGFFiniteFamily`
- `matrixBernsteinTraceMGFWithBernsteinCoeff_of_troppMasterTraceMGFFiniteFamily`
- `matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives`

### Trace-MGF real-to-lintegral bridge
- `traceMGFBernsteinVarianceProxyBoundLIntegral_of_traceMGFBernsteinVarianceProxyBound`

### Explicit-theta quadratic-form tail wrapper
- `matrixBernsteinQuadraticFormUpperTailWithBernsteinCoeff_under_primitives`

### Generic trace-exp dimension bound
- `traceMatrixExp_smul_le_card_exp_of_lambdaMaxOrdered_le`

### Variance-proxy trace-exp dimension bound
- `lambdaMaxOrdered_le_deterministicOperatorNorm`
- `traceMatrixExp_bernsteinMGFCoeff_matrixVarianceProxy_le_card_exp`

### Scalar-RHS tail wrapper
- `matrixBernsteinQuadraticFormUpperTailScalarRHSWithBernsteinCoeff_under_primitives`
- `matrixBernsteinQuadraticFormUpperTailScalarExpRHSWithBernsteinCoeff_under_primitives`

## Proved Theorems
- MatrixLE and PSD algebra helpers listed above.
- Matrix expectation integrability closure, linearity, PSD preservation, and MatrixLE monotonicity.
- Bernstein coefficient nonnegativity and the MatrixLE lower bound `1 + A <= exp(A)` for self-adjoint real matrices.
- The single-summand MGF variance-proxy provider under explicit pointwise Bernstein CFC assumptions.
- The bounded Matrix Bernstein trace-MGF statement under explicit finite-family Tropp and pointwise CFC primitive assumptions.
- The bounded-Bernstein real semantic trace-MGF to lintegral semantic trace-MGF bridge under random self-adjointness and trace-exp integrability.
- The explicit-theta one-sided quadratic-form upper-tail bound under the same explicit primitive assumptions, with trace-exponential RHS
  `exp(-theta*t) * tr exp(SMul.smul (bernsteinMGFCoeff theta R) (matrixVarianceProxy P A))`.
- The generic deterministic trace-exp dimension bound
  `traceMatrixExp (SMul.smul c V) <= (n + 1 : Real) * exp(c * sigmaSq)` under
  `0 <= c` and a direct ordered lambda-max upper-bound assumption.
- The variance-proxy specialized trace-exp dimension bound
  `traceMatrixExp (SMul.smul (bernsteinMGFCoeff theta R) (matrixVarianceProxy P A)) <=
   (n + 1 : Real) * exp(bernsteinMGFCoeff theta R * sigmaSq)` under random
  self-adjointness, theta range, and `MatrixVarianceProxyNormBound`.
- The explicit-theta one-sided quadratic-form upper-tail scalar-RHS bound under
  the same explicit primitive assumptions, with intentionally unnormalized RHS
  `ENNReal.ofReal (Real.exp (-(theta * t)) * ((n + 1 : Real) * Real.exp (bernsteinMGFCoeff theta R * sigmaSq)))`.
- The normalized explicit-theta one-sided quadratic-form upper-tail scalar-RHS
  bound under the same explicit primitive assumptions, with RHS
  `ENNReal.ofReal ((n + 1 : Real) * Real.exp (-(theta * t) + bernsteinMGFCoeff theta R * sigmaSq))`.

## Typed-Only Primitives
- `bernsteinMatrixExp_le_quadratic_statement`
- `troppMasterTraceMGFFiniteFamily_statement`
- `troppMasterTraceMGFStep_statement`

## Not Proved
- Bernstein CFC primitive.
- Tropp/Lieb theorem.
- Golden-Thompson.
- Theta optimization for the Bernstein denominator.
- Lambda-max/operator-norm Matrix Bernstein tail theorem.
- Full Matrix Bernstein tail theorem.

## Validation
- `lake build`
- `lake test`
- `lake build HighDimProbJudge`
- `python scripts/judge_policy_check.py`
- forbidden-token audits for `sorry`, `admit`, `axiom`, and `unsafe`
- theorem-like `:= True` audit
- `git diff --check`

## Next Safe Task
- MB-S9-theta-optimization-contract
