# RandomMatrix Matrix Bernstein API

This index records the public RandomMatrix API used by the Matrix Bernstein
mainline. It is documentation only; theorem status is not upgraded here.

## `HighDimProb/RandomMatrix/SelfAdjoint.lean`

- `IsSymmetricMatrix`: abbrev.
- `IsSelfAdjointMatrix`: abbrev.
- `RandomSymmetricMatrix`: def.
- `RandomSelfAdjointMatrix`: def.
- `isSelfAdjointMatrix_smul`: theorem.
- `isSelfAdjointMatrix_neg`: theorem.
- `randomSelfAdjointMatrix_smul`: theorem.
- `randomSelfAdjointMatrix_neg`: theorem.

## `HighDimProb/RandomMatrix/Spectral.lean`

- `SpectralUpperBound`: abbrev, semantic upper spectral bound.
- `RayleighUpperBound`: def, semantic quadratic-form upper bound.
- `scalarUpperTailEvent`: def.
- `matrixUpperBoundTailEvent`: def.
- `lambdaMax`: def, legacy compatibility wrapper.
- `lambdaMaxOrdered`: def, canonical ordered endpoint wrapper.
- `lambdaMax_eq_lambdaMaxOrdered_statement`: typed statement.
- `lambdaMaxOrdered_is_greatest_eigenvalue`: theorem.
- `lambdaMaxOrdered_smul_of_nonneg`: theorem.
- `lambdaMaxOrdered_le_trace_of_posSemidef`: theorem.
- `LambdaMaxPSDUpperBound`: abbrev, semantic provider predicate for legacy
  `lambdaMax`.
- `LambdaMaxOrderedPSDUpperBound`: abbrev, semantic provider predicate for
  `lambdaMaxOrdered`.
- `lambdaMaxOrdered_spectralUpperBound`: theorem.
- `lambdaMaxOrderedPSDUpperBound`: theorem.
- `rayleighUpperBound_of_spectralUpperBound`: theorem.
- `lambdaMaxOrdered_rayleighUpperBound`: theorem.
- `matrixQuadraticForm_le_lambdaMax_statement`: typed statement.
- `matrixQuadraticForm_le_lambdaMaxOrdered_statement`: typed statement.
- `matrixQuadraticForm_le_lambdaMax_of_lambdaMaxPSDUpperBound`: conditional
  theorem.
- `matrixQuadraticForm_le_lambdaMaxOrdered_of_lambdaMaxOrderedPSDUpperBound`:
  conditional theorem.
- `lambdaMaxUpperTailEvent`: def.
- `lambdaMaxOrderedUpperTailEvent`: def.
- `lambdaMaxUpperTailEvent_eq_matrixUpperBoundTailEvent`: theorem.
- `lambdaMaxOrderedUpperTailEvent_eq_matrixUpperBoundTailEvent`: theorem.
- `quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_rayleighUpperBound`:
  theorem.
- `quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_spectralUpperBound`:
  theorem.
- `selfAdjointOperatorNormTailViaQuadraticFormStatement`: typed statement.
- `lambdaMax_le_iff_quadraticForm_le_statement`: typed statement.
- `operatorNorm_eq_max_abs_lambda_statement`: typed statement.

## `HighDimProb/RandomMatrix/MatrixOrder.lean`

- `matrixQuadraticForm`: def.
- `IsPSDMatrix`: def.
- `RandomPSDMatrix`: def.
- `MatrixLE`: def, explicit Loewner-style predicate.
- `matrixQuadraticForm_sub`: theorem.
- `matrixQuadraticForm_sum`: theorem.
- `matrixQuadraticForm_add`: theorem.
- `matrixQuadraticForm_smul`: theorem.
- `isPSDMatrix_zero`: theorem.
- `isPSDMatrix_sum`: theorem.
- `isPSDMatrix_add`: theorem.
- `isPSDMatrix_smul_of_nonneg`: theorem.
- `matrixLE_refl`: theorem.
- `matrixLE_of_eq`: theorem.
- `matrixLE_trans`: theorem.
- `matrixLE_add`: theorem.
- `matrixLE_add_left`: theorem.
- `matrixLE_add_right`: theorem.
- `matrixLE_smul_of_nonneg`: theorem.
- `quadraticForm_le_of_matrixLE`: theorem.
- `quadraticForm_apply_le_of_matrixLE`: theorem.

## `HighDimProb/RandomMatrix/VarianceProxy.lean`

- `matrixSquare`: def.
- `randomMatrixSquare`: def.
- `matrixSecondMoment`: def.
- `matrixVarianceProxy`: def.
- `MatrixVarianceProxy`: abbrev.
- `matrixVarianceProxyBound`: def.
- `MatrixVarianceProxyBound`: abbrev.
- `MatrixVarianceProxyUpperBound`: def, semantic matrix variance-proxy
  upper-bound predicate.
- `deterministicMatrixVarianceProxyNorm`: def.
- `matrixVarianceProxyNorm`: def.
- `MatrixVarianceProxyNormBound`: def, semantic scalar variance-proxy
  norm-bound predicate.
- `isPSD_matrixSquare_of_selfAdjoint`: theorem.
- `integrableRandomMatrix_sub`: theorem.
- `integrableRandomMatrix_add`: theorem.
- `integrableRandomMatrix_smul`: theorem.
- `integrableRandomMatrix_zero`: theorem.
- `integrableRandomMatrix_const`: theorem, under `[IsFiniteMeasure P]`.
- `matrixExpect_sub`: theorem.
- `matrixExpect_add`: theorem.
- `matrixExpect_smul`: theorem.
- `matrixExpect_zero`: theorem.
- `matrixExpect_const`: theorem, with factor `(P.real Set.univ)`.
- `matrixExpect_const_of_isProbabilityMeasure`: theorem.
- `matrixExpect_one_of_isProbabilityMeasure`: theorem.
- `isPSDMatrix_matrixExpect_of_pointwise_isPSD`: theorem.
- `matrixExpect_matrixLE_of_pointwise_matrixLE`: theorem.
- `isPSD_matrixSecondMoment_of_selfAdjoint`: theorem.
- `isPSD_matrixVarianceProxy_of_selfAdjoint`: theorem.

## `HighDimProb/RandomMatrix/TraceExp.lean`

- `matrixExp`: def.
- `matrixTrace`: def.
- `traceMatrixExp`: def.
- `isSelfAdjointMatrix_matrixExp`: theorem.
- `matrixTrace_nonneg_of_posSemidef`: theorem.
- `traceMatrixExp_nonneg_of_matrixExp_posSemidef`: theorem.
- `matrixExp_posSemidef_of_selfAdjoint_statement`: typed statement.
- `matrixExp_posSemidef_of_selfAdjoint`: theorem.
- `traceExpIntegrand`: def.
- `traceExpMoment`: def.
- `traceExpMomentLIntegral`: def.
- `TraceMGFBound`: def, semantic real trace-mgf bound.
- `TraceMGFBoundLIntegral`: def, semantic lintegral trace-mgf bound.
- `TraceMGFVarianceProxyBound`: def, semantic real variance-proxy
  trace-mgf bound.
- `TraceMGFVarianceProxyBoundLIntegral`: def, semantic lintegral
  variance-proxy trace-mgf bound.
- `troppMasterTraceMGFStep_statement`: typed statement for the source-backed
  Tropp/Lieb one-step trace-mgf primitive
  `E tr exp(H + Z) <= tr exp(H + log E exp Z)`, with explicit
  self-adjointness, integrability, entrywise matrix-exponential expectation,
  and strict-positivity assumptions.
- `troppMasterTraceMGFFiniteFamily_statement`: typed finite-family
  Tropp/Lieb iteration primitive consuming per-summand matrix-MGF `MatrixLE`
  comparisons, independence, trace-exp integrability, comparison
  self-adjointness, and bounded-Bernstein RHS normalization to produce
  `TraceMGFBernsteinVarianceProxyBound` for `randomMatrixSum`.
- `bernsteinMGFCoeff`: def, canonical bounded Matrix Bernstein trace-mgf
  coefficient `(theta ^ 2 / 2) / (1 - abs theta * R / 3)`.
- `bernsteinCoefficient_nonneg`: theorem proving nonnegativity of the
  Bernstein quadratic coefficient
  `(theta ^ 2 / 2) / (1 - abs theta * R / 3)` under `abs theta * R < 3`.
- `bernsteinMGFCoeff_nonneg`: theorem wrapper proving
  `0 <= bernsteinMGFCoeff theta R` under `abs theta * R < 3`.
- `TraceMGFBernsteinVarianceProxyBound`: def, semantic real trace-mgf bound
  using the bounded Bernstein denominator coefficient.
- `TraceMGFBernsteinVarianceProxyBoundLIntegral`: def, semantic lintegral
  trace-mgf bound using the bounded Bernstein denominator coefficient.
- `bernsteinMatrixExp_le_quadratic_statement`: typed statement for the
  Bernstein-specific scalar-to-matrix functional-calculus primitive, with
  explicit self-adjointness, deterministic operator-norm bound, nonnegative
  radius, theta range, Bernstein quadratic coefficient, and `MatrixLE`
  conclusion.
- `singleSummandMatrixMGFVarianceProxy_statement`: typed statement for the
  source-backed single-summand matrix MGF variance-proxy primitive, with
  explicit self-adjointness, centeredness, boundedness, integrability, theta
  range, square/variance-proxy comparison, and `MatrixLE` conclusion.
- `singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic`:
  theorem proving the single-summand matrix MGF variance-proxy typed target
  under an explicit pointwise `bernsteinMatrixExp_le_quadratic_statement`
  assumption and explicit probability-measure normalization.
- `traceMatrixExp_nonneg_of_selfAdjoint_statement`: typed statement.
- `traceMatrixExp_nonneg_of_selfAdjoint`: theorem.
- `lambdaMaxOrdered_matrixExp`: theorem.
- `traceExpMoment_nonneg_statement`: typed statement.
- `traceExpMoment_nonneg_of_nonneg`: theorem.
- `traceExpIntegrand_nonneg_of_randomSelfAdjoint`: theorem.
- `traceExpMoment_nonneg_of_randomSelfAdjoint`: theorem.
- `traceExpMomentLIntegral_nonneg`: theorem.
- `traceExpMomentLIntegral_eq_ofReal_statement`: typed statement.
- `traceExpMomentLIntegral_eq_ofReal_traceExpMoment`: theorem.
- `matrixLE_one_add_self_le_matrixExp_of_selfAdjoint`: theorem.
- `matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint`: theorem.
- `traceExpMomentBoundStatement`: typed statement.
- `traceExpVarianceProxyBoundStatement`: typed statement.
- `traceMGFBound_statement`: typed statement.
- `traceMGFBoundLIntegral_statement`: typed statement.
- `traceMGFVarianceProxyBound_statement`: typed statement.
- `traceMGFBernsteinVarianceProxyBound_statement`: typed statement for the
  bounded-denominator trace-mgf variance-proxy target.

## `HighDimProb/RandomMatrix/Laplace.lean`

- `matrixLaplaceRHS`: def.
- `matrixLaplaceRHSLIntegral`: def.
- `traceExpThresholdEvent`: def.
- `TraceExpDominatesUpperBound`: def.
- `lambdaMaxOrdered_traceExpDominatesUpperBound`: theorem.
- `matrixUpperBoundTailEvent_subset_traceExpThresholdEvent_of_traceExpDominatesUpperBound`:
  theorem.
- `matrixLaplaceRHSLIntegralDiv`: def.
- `matrixLaplaceRHSLIntegralDiv_eq_matrixLaplaceRHSLIntegral`: theorem.
- `traceExpThresholdEvent_lintegral_bound`: theorem.
- `matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset`:
  conditional theorem.
- `matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset`: conditional
  theorem.
- `TraceExpDominatesQuadraticFormUpperTail`: def.
- `traceExpDominatesQuadraticFormUpperTailStatement`: typed statement.
- `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates`:
  theorem.
- `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_rayleighUpperBound_of_traceExpDominatesUpperBound`:
  theorem.
- `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_spectralUpperBound_of_traceExpDominatesUpperBound`:
  theorem.
- `traceExpDominatesQuadraticFormUpperTail_of_rayleighUpperBound_of_traceExpDominatesUpperBound`:
  theorem.
- `traceExpDominatesQuadraticFormUpperTail_of_spectralUpperBound_of_traceExpDominatesUpperBound`:
  theorem.
- `traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint`: theorem.
- `matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail`:
  conditional theorem.
- `matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail`:
  conditional theorem.
- `matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint`: theorem.
- `matrixLaplaceTransformLIntegral_of_randomSelfAdjoint`: theorem.
- `matrixLaplaceTransformStatement`: typed statement.
- `matrixLaplaceTransformLIntegralStatement`: typed statement.
- `matrixChernoffFromTraceExpStatement`: typed statement.
- `matrixChernoffFromTraceExpLIntegralStatement`: typed statement.
- `selfAdjointOperatorNormLaplaceStatement`: typed statement.
- `selfAdjointOperatorNormLaplaceLIntegralStatement`: typed statement.

## `HighDimProb/RandomMatrix/ConcentrationStatements.lean`

- `matrixBernsteinStatement`: typed statement.
- `matrixBernsteinSelfAdjointStatement`: typed statement.
- `matrixBernsteinLaplacePrerequisitesStatement`: typed statement.
- `matrixBernsteinTraceMGF_statement`: typed statement.
- `matrixBernsteinTraceMGFWithBernsteinCoeff_statement`: typed statement for
  the bounded Matrix Bernstein trace-mgf target with denominator coefficient
  `bernsteinMGFCoeff theta R`.

## Current Blockers

- Real RHS / real expectation bridge for the concrete lintegral Laplace
  wrappers.
- Full trace-mgf provider theorem without explicit finite-family Tropp
  assumptions. The bounded thin wrapper is proved for
  `matrixBernsteinTraceMGFWithBernsteinCoeff_statement`; the finite-family
  Tropp primitive itself remains typed only. The older
  `matrixBernsteinTraceMGF_statement` is retained for the `theta ^ 2 / 2`
  compatibility target and is not the bounded Matrix Bernstein RHS.
- Full CFC-free single-summand MGF provider; the current provider theorem
  assumes the pointwise Bernstein CFC primitive explicitly.
- Functional-calculus proof for
  `bernsteinMatrixExp_le_quadratic_statement`.
- Operator-norm-to-spectral-interval bridge.
- Golden-Thompson / Lieb remain unproved.
- Matrix Bernstein.

## MB-S9 Trace-MGF Thin Wrapper API

- `traceMGFBernsteinVarianceProxyBound_of_troppMasterTraceMGFFiniteFamily`:
  theorem in `TraceExp.lean`, thin wrapper applying the finite-family Tropp
  typed primitive to conclude
  `TraceMGFBernsteinVarianceProxyBound P (randomMatrixSum X) V theta R`.
- `matrixBernsteinTraceMGFWithBernsteinCoeff_of_troppMasterTraceMGFFiniteFamily`:
  theorem in `ConcentrationStatements.lean`, thin high-level wrapper from the
  finite-family Tropp typed primitive to
  `matrixBernsteinTraceMGFWithBernsteinCoeff_statement`.
- The finite-family Tropp primitive remains typed only. The Bernstein CFC
  primitive remains typed only. No Lieb theorem, Golden-Thompson theorem, or
  Matrix Bernstein tail theorem was proved.

## Next Safe Task

MB-S9-trace-mgf-to-laplace-tail-contract: audit the next
Matrix Bernstein trace-MGF route now that the thin wrappers from
`troppMasterTraceMGFFiniteFamily_statement` to the bounded semantic and
high-level trace-MGF targets are proved. Do not prove the Bernstein CFC
primitive, Golden-Thompson, Lieb, or Matrix Bernstein in that contract stage.

## MB-S9 Matrix Bernstein Trace-MGF Under Primitives API

- `matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives`: theorem in
  `ConcentrationStatements.lean`. It proves
  `matrixBernsteinTraceMGFWithBernsteinCoeff_statement P A theta R` from
  ordinary finite-family assumptions, an explicit
  `troppMasterTraceMGFFiniteFamily_statement` assumption, and explicit
  pointwise `bernsteinMatrixExp_le_quadratic_statement` assumptions.
- The finite-family Tropp primitive remains typed only. The Bernstein CFC
  primitive remains typed only. No Lieb theorem, Golden-Thompson theorem, or
  Matrix Bernstein tail theorem was proved.
- Next safe task: MB-S9-trace-mgf-to-laplace-tail-contract.
