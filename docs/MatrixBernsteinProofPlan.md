# Matrix Bernstein Proof Plan

This document records the current honest proof plan for Matrix Bernstein.
It is documentation-only for missing analytic machinery; Lean files keep only
typed `Prop` statements whose objects already exist.

## Current Public Status

MB-S9 has proved the bounded Matrix Bernstein trace-MGF wrapper, the
bounded-Bernstein real-to-lintegral semantic bridge, the explicit-theta
one-sided quadratic-form upper-tail wrappers, the scalar dimension/norm RHS
reduction, and the theta-optimized scalar-RHS quadratic-form tail wrapper.

```lean
matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives
traceMGFBernsteinVarianceProxyBoundLIntegral_of_traceMGFBernsteinVarianceProxyBound
matrixBernsteinQuadraticFormUpperTailWithBernsteinCoeff_under_primitives
traceMatrixExp_smul_le_card_exp_of_lambdaMaxOrdered_le
lambdaMaxOrdered_le_deterministicOperatorNorm
traceMatrixExp_bernsteinMGFCoeff_matrixVarianceProxy_le_card_exp
matrixBernsteinQuadraticFormUpperTailScalarRHSWithBernsteinCoeff_under_primitives
matrixBernsteinQuadraticFormUpperTailScalarExpRHSWithBernsteinCoeff_under_primitives
bernsteinThetaChoice
bernsteinThetaChoice_range
bernsteinThetaChoice_exponent_eq
matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy
matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_nonempty_under_primitives
matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_pos_under_primitives
sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum
sampleCovariance_selfAdjointOperatorNorm_tail_optimized_under_explicit_variance_proxy
sampleCovariance_selfAdjointOperatorNorm_tail_optimized_nonempty_under_explicit_variance_proxy
sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_explicit_variance_proxy
MatrixVarianceProxyNormBound_of_pointwiseOperatorNormBound
MatrixVarianceProxyNormBound_centeredRankOneRandomMatrixFamily_of_sqNorm_bound
MatrixVarianceProxyNormBound_centeredSampleCovarianceRowRankOneFamily_of_rowSqNorm_bound
sampleCovarianceCenteredRankOneVarianceProxyBound
sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound
sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound
```

The optimized wrapper chooses `theta = t / (sigmaSq + R * t / 3)` and proves
the Bernstein denominator RHS:

```text
ENNReal.ofReal
  ((n + 1 : Real) *
    Real.exp (-(t ^ 2 / (2 * sigmaSq + (2 / 3) * R * t))))
```

The theorem assumes the finite-family Tropp/Lieb typed primitive and the
pointwise Bernstein CFC typed primitive explicitly. The current public API does
not include Tropp/Lieb, Golden-Thompson, the Bernstein CFC primitive, a packaged
`t = 0` operator-norm endpoint, unconditional lambda-max Matrix Bernstein
tails, or the full Matrix Bernstein tail theorem.

The retained sample-covariance wrapper
`sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy`
is now proved as a thin specialization of the optimized quadratic-form wrapper.
It uses `sampleCovariance_deviation_eq_normalized_centered_rowRankOne_sum`,
S3/S4 centered rank-one adapters, explicit row independence, explicit
square/exponential/trace integrability, explicit
`MatrixVarianceProxyNormBound`, and explicit Tropp/CFC primitive assumptions.
The bounded-row wrapper
`sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound` now
derives the positive-side crude variance proxy from the row squared-norm bound.
It is not an unconditional sample-covariance concentration theorem and not an
operator-norm Matrix Bernstein theorem.

The sample-covariance operator-norm event bridge
`sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum`
is now proved using the centered sample-covariance deviation equality. The
conditional sample-covariance operator-norm wrapper
`sampleCovariance_selfAdjointOperatorNorm_tail_optimized_under_explicit_variance_proxy`
is now proved as a thin specialization of the conditional self-adjoint
operator-norm Matrix Bernstein wrapper. The bounded-row wrapper
`sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound`
uses the crude variance-proxy theorem for the positive family and the general
pointwise-bound theorem for the negative family. It keeps Tropp/CFC primitives,
integrability, independence, negative-family pointwise bounds, and
`selfAdjointOperatorNormTailViaQuadraticFormStatement` explicit. It does not
prove sharp variance control or discharge all negative-family assumptions.

The nonempty self-adjoint operator-norm Matrix Bernstein wrapper
`matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_nonempty_under_primitives`
is proved for `Fin (n + 1)` square dimensions by supplying
`selfAdjointOperatorNormTailViaQuadraticFormStatement_nonempty` to the retained
bridge-explicit wrapper. The nonempty sample-covariance wrapper
`sampleCovariance_selfAdjointOperatorNorm_tail_optimized_nonempty_under_explicit_variance_proxy`
then reuses that nonempty Matrix Bernstein wrapper. These theorems do not prove
variance-proxy control, Tropp/Lieb, the Bernstein CFC primitive,
Golden-Thompson, or full Matrix Bernstein.

The arbitrary-dimensional self-adjoint operator-norm route is now proved on the
positive-threshold contract. The zero-dimensional positive-threshold endpoint
`selfAdjointOperatorNormTailEvent_empty_of_zero_dim_of_pos` and the arbitrary
bridge `selfAdjointOperatorNormTailViaQuadraticFormStatement_of_pos` show that
`0 < t` is the supported arbitrary-dimensional route. The corresponding Matrix
Bernstein wrapper
`matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_pos_under_primitives`
and sample-covariance wrapper
`sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_explicit_variance_proxy`
reuse the existing bridge-explicit/nonempty wrappers and keep variance proxy,
integrability, independence, Tropp, and CFC assumptions explicit.

RM-S5E adds the example-layer wrapper
`sampleCovariance_quadraticForm_tail_usage`; the current version uses the
bounded-row theorem directly while keeping independence, integrability, Tropp,
and CFC assumptions explicit. The radius, crude variance proxy, optimized theta, and scalar RHS names
belong to the core concentration layer:
`sampleCovarianceCenteredRankOneRadius`,
`sampleCovarianceCenteredRankOneVarianceProxyBound`,
`sampleCovarianceTailTheta`, and
`sampleCovarianceQuadraticFormTailRHS`.

RM-VP proves a reusable crude variance-proxy control path from pointwise
operator-norm bounds and specializes it to centered rank-one and
sample-covariance row rank-one families. It does not prove sharp fourth-moment
or moment-optimal variance bounds.

RM-S6 adds deterministic rank-one kernel/nullspace API:
`rankOneMatrixSum`, `rankOneMatrix_quadraticForm_eq_inner_sq`,
`rankOneMatrix_mulVec_eq_zero_iff_inner_eq_zero`, and
`rankOneSum_mulVec_eq_zero_of_forall_inner_eq_zero`.
It reuses `rankOneMatrix`, `matrixQuadraticForm`, `Matrix.mulVec`, finite
sums, and the PSD-nullspace bridge without adding a general nullspace theory.

The rank-one nullspace examples now reuse these core bridges where they remove
local action/sum algebra.

Next safe task: `RM-negative-family-adapters`.

RM-ON-S4 update: the nonempty self-adjoint operator-norm Matrix Bernstein
wrapper
`matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_nonempty_under_primitives`
is proved by reusing the conditional wrapper and
`selfAdjointOperatorNormTailViaQuadraticFormStatement_nonempty`. The wrapper
removes only the explicit spectral-bridge assumption for `Fin (n + 1)` square
dimensions; Tropp, CFC, variance-proxy, independence, and integrability
assumptions remain explicit.

RM prerequisite update: the entrywise `matrixExpect` to Bochner integral bridge
and expectation operator-norm contraction are now proved via
`matrixExpect_eq_integral` and
`deterministicOperatorNorm_matrixExpect_le_of_boundedOperatorNorm`. The
centered operator-norm wrappers are now proved via
`BoundedOperatorNorm_centered_of_boundedOperatorNorm` and
`PointwiseOperatorNormBound_centered_of_pointwiseOperatorNormBound`. The
vector-to-rank-one matrix bridge is also proved via `rankOneRandomMatrix`,
`isRandomMatrix_rankOneRandomMatrix`,
`integrableRandomMatrix_rankOneRandomMatrix_of_integrable_products`, and
`integrableRandomMatrix_rankOneRandomMatrix_of_memLp_two`. Centered rank-one
random matrix structural adapters are now proved via
`randomSelfAdjointMatrix_rankOneRandomMatrix`,
`randomPSDMatrix_rankOneRandomMatrix`,
`centeredRankOneRandomMatrix_isRandomMatrix`,
`centeredRankOneRandomMatrix_integrable_of_memLp_two`, and
`centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two`. Centered
rank-one operator-norm adapters are now proved via
`BoundedOperatorNorm_centeredRankOneRandomMatrix_of_sqNorm_bound` and
`PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound`,
reusing expectation contraction and the S2 centered operator-norm wrappers. The
sample covariance rank-one sum objects and bridge are proved via
`sampleCovarianceRowRankOneSum`, `normalizedSampleCovarianceRowRankOneSum`, and
`sampleCovariance_eq_normalized_rowRankOne_sum`; the sample covariance centered
sum objects and centering bridge are proved via
`centeredSampleCovarianceRowRankOneSum`,
`normalizedCenteredSampleCovarianceRowRankOneSum`, and
`sampleCovariance_deviation_eq_normalized_centered_rowRankOne_sum`. The PSD
nullspace converse bridge is proved via `posSemidef_of_isPSDMatrix`,
`matrixQuadraticForm_eq_zero_iff_mulVec_eq_zero_of_posSemidef`, and the
one-way Mathlib-/explicit-PSD kernel wrappers. The deterministic rank-one
kernel/nullspace bridge uses
`rankOneMatrixSum`, `rankOneMatrix_quadraticForm_eq_inner_sq`,
`rankOneMatrix_mulVec_eq_zero_iff_inner_eq_zero`, and
`rankOneSum_mulVec_eq_zero_of_forall_inner_eq_zero`. The RM-VP leaf proves the
crude variance-proxy route, but this does not prove integrability from
measurability alone, sharp variance control, effective dimension, restricted
Matrix Bernstein, full Matrix Bernstein, Tropp/Lieb, Bernstein CFC, or
Golden-Thompson.

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
- entrywise `IntegrableRandomMatrix P (randomMatrixSquare (A i))` for every
  squared summand;
- `CenteredSelfAdjointRandomMatrixFamily P A`;
- `IndependentSelfAdjointRandomMatrices P A`;
- `PointwiseOperatorNormBound A R`;
- `matrixVarianceProxyNorm P A <= sigma2`;
- `0 <= sigma2`, `0 <= R`, `0 < c1`, `0 < c2`, `0 <= t`;
- `0 < c1 * sigma2 + c2 * R * t`.

The PSD variance proxy condition is no longer a separate hypothesis in this
refined statement. It follows from `isPSD_matrixVarianceProxy_of_selfAdjoint`.

The older `matrixBernsteinStatement` remains a typed min-form statement for
compatibility, but the proof-ready statement is the additive-form
`matrixBernsteinSelfAdjointStatement`.

MB-S2 keeps the proof-ready statement as an operator-norm tail statement. It is
not rewritten to a lambda-max statement because the Rayleigh quotient bridge
and self-adjoint operator-norm/eigenvalue endpoint bridge are still typed
targets only.

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
| Matrix square PSD | `isPSD_matrixSquare_of_selfAdjoint` |
| Quadratic form / expectation bridge | `matrixQuadraticForm_matrixExpect` |
| Matrix expectation PSD/order/linearity bridge | `integrableRandomMatrix_sub`, `integrableRandomMatrix_add`, `integrableRandomMatrix_smul`, `integrableRandomMatrix_zero`, `integrableRandomMatrix_const`, `matrixExpect_sub`, `matrixExpect_add`, `matrixExpect_smul`, `matrixExpect_zero`, `matrixExpect_const`, `matrixExpect_const_of_isProbabilityMeasure`, `matrixExpect_one_of_isProbabilityMeasure`, `isPSDMatrix_matrixExpect_of_pointwise_isPSD`, `matrixExpect_matrixLE_of_pointwise_matrixLE` |
| Second moment PSD | `isPSD_matrixSecondMoment_of_selfAdjoint` |
| Finite PSD sums | `isPSDMatrix_sum` |
| Second moment self-adjointness | `isSelfAdjointMatrix_matrixSecondMoment` |
| Variance proxy self-adjointness | `isSelfAdjointMatrix_matrixVarianceProxy` |
| Variance proxy PSD | `isPSD_matrixVarianceProxy_of_selfAdjoint` |
| Spectral vocabulary | `lambdaMax`, `lambdaMaxOrdered`, `lambdaMaxOrdered_eq_eigenvalues?_zero`, `lambdaMin`, `SpectralUpperBound`, `RayleighUpperBound`, `QuadraticFormUpperBound`, `QuadraticFormLowerBound`, `quadraticFormUpperTailEvent`, `quadraticFormLowerTailEvent`, `twoSidedQuadraticFormTailEvent`, `LambdaMaxPSDUpperBound`, `LambdaMaxOrderedPSDUpperBound`, `matrixQuadraticForm_nonneg_of_posSemidef`, `matrixQuadraticForm_smul_one_of_isUnitVector`, `matrixQuadraticForm_le_lambdaMax_of_lambdaMax_sub_posSemidef`, `matrixQuadraticForm_le_lambdaMax_of_lambdaMaxPSDUpperBound`, `rayleighUpperBound_of_spectralUpperBound`, `lambdaMaxOrdered_is_greatest_eigenvalue`, `lambdaMaxOrdered_spectralUpperBound`, `lambdaMaxOrderedPSDUpperBound`, `lambdaMaxOrdered_rayleighUpperBound`, `lambdaMaxOrdered_smul_of_nonneg`, `lambdaMaxOrdered_le_trace_of_posSemidef`, `matrixQuadraticForm_le_lambdaMaxOrdered_of_lambdaMaxOrderedPSDUpperBound` |
| Quadratic-form event inclusions | `quadraticFormUpperTailEvent_subset_twoSidedQuadraticFormTailEvent`, `quadraticFormLowerTailEvent_subset_twoSidedQuadraticFormTailEvent` |
| Matrix exponential and trace | `matrixExp`, `matrixTrace`, `traceMatrixExp`, `traceExpIntegrand`, `traceExpMoment`, `traceExpMomentLIntegral`, `matrixExp_posSemidef_of_selfAdjoint`, `matrixLE_one_add_self_le_matrixExp_of_selfAdjoint`, `matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint`, `traceMatrixExp_nonneg_of_selfAdjoint`, `traceMatrixExp_smul_le_card_exp_of_lambdaMaxOrdered_le`, `traceExpIntegrand_nonneg_of_randomSelfAdjoint`, `traceExpMoment_nonneg_of_randomSelfAdjoint`, `matrixTrace_nonneg_of_posSemidef`, `traceMatrixExp_nonneg_of_matrixExp_posSemidef`, `traceExpMoment_nonneg_of_nonneg`, `traceExpMomentLIntegral_nonneg`, `traceExpMomentLIntegral_eq_ofReal_traceExpMoment` |
| Trace-mgf semantic foundation | `TraceMGFBound`, `TraceMGFBoundLIntegral`, `TraceMGFVarianceProxyBound`, `TraceMGFVarianceProxyBoundLIntegral` |
| Variance-proxy semantic foundation | `MatrixVarianceProxyUpperBound`, `MatrixVarianceProxyNormBound` |
| Conditional trace-exp Markov/Laplace bridge | `traceExpThresholdEvent`, `matrixLaplaceRHSLIntegralDiv`, `matrixLaplaceRHSLIntegralDiv_eq_matrixLaplaceRHSLIntegral`, `traceExpThresholdEvent_lintegral_bound`, `matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset`, `matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset` |
| Conditional trace-exp dominance/Laplace bridge | `TraceExpDominatesQuadraticFormUpperTail`, `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates`, `matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail`, `matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail`, `matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint`, `matrixLaplaceTransformLIntegral_of_randomSelfAdjoint` |
| Semantic trace-exp dominance bridge | `TraceExpDominatesUpperBound`, `lambdaMaxOrdered_traceExpDominatesUpperBound`, `matrixUpperBoundTailEvent_subset_traceExpThresholdEvent_of_traceExpDominatesUpperBound`, `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_rayleighUpperBound_of_traceExpDominatesUpperBound`, `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_spectralUpperBound_of_traceExpDominatesUpperBound`, `traceExpDominatesQuadraticFormUpperTail_of_rayleighUpperBound_of_traceExpDominatesUpperBound`, `traceExpDominatesQuadraticFormUpperTail_of_spectralUpperBound_of_traceExpDominatesUpperBound`, `traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint` |

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
| PSD matrix square compatibility target | `isPSD_matrixSquare_of_selfAdjoint_statement` | typed `Prop`; theorem proved |
| PSD second moment compatibility target | `isPSD_matrixSecondMoment_of_selfAdjoint_statement` | typed `Prop`; theorem proved with square integrability |
| PSD variance proxy compatibility target | `isPSD_matrixVarianceProxy_of_selfAdjoint_statement` | typed `Prop`; theorem proved with per-summand square integrability |
| Lambda-max/Rayleigh bridge | `lambdaMax_le_iff_quadraticForm_le_statement`, `matrixQuadraticForm_le_lambdaMax_statement`, `matrixQuadraticForm_le_lambdaMax_of_lambdaMax_sub_posSemidef`, `lambdaMax_eq_lambdaMaxOrdered_statement`, `matrixQuadraticForm_le_lambdaMaxOrdered_statement`, `lambdaMaxOrdered_spectralUpperBound`, `lambdaMaxOrderedPSDUpperBound`, `lambdaMaxOrdered_rayleighUpperBound`, `lambdaMaxOrdered_smul_of_nonneg`, `lambdaMaxOrdered_le_trace_of_posSemidef` | legacy direct theorem typed/unproved; ordered endpoint wrapper added; semantic provider, ordered Rayleigh wrappers, nonnegative scalar-multiplication endpoint theorem, and trace endpoint theorem proved for the `lambdaMaxOrdered` route |
| Self-adjoint norm/eigenvalue endpoint bridge | `operatorNorm_eq_max_abs_lambda_statement` | typed `Prop`, unproved |
| Lambda-max endpoint ordering bridge | `lambdaMax_is_greatest_eigenvalue_statement`, `lambdaMaxOrdered_is_greatest_eigenvalue_statement`, `lambdaMaxOrdered_is_greatest_eigenvalue` | legacy statement typed/unproved; ordered endpoint theorem proved for `eigenvalues?` |
| Lambda-min endpoint ordering bridge | `lambdaMin_is_least_eigenvalue_statement` | typed `Prop`, unproved |
| Self-adjoint operator-norm tail via quadratic forms | `selfAdjointOperatorNormTailViaQuadraticFormStatement`, `selfAdjointOperatorNormTailViaQuadraticFormStatement_nonempty`, `selfAdjointOperatorNormTailEvent_empty_of_zero_dim_of_pos`, `selfAdjointOperatorNormTailViaQuadraticFormStatement_of_pos` | arbitrary-`n` typed `Prop`; nonempty `Fin (n + 1)` theorem and arbitrary positive-threshold theorem proved; the supported arbitrary-dimensional theorem uses `0 < t` |
| Trace-exponential moment bound | `traceExpMomentBoundStatement` | typed `Prop`, unproved |
| Variance-proxy trace-exponential bound | `traceExpVarianceProxyBoundStatement` | typed `Prop`, unproved |
| Semantic trace-mgf bound provider | `traceMGFBound_statement`, `traceMGFBoundLIntegral_statement` | typed `Prop`, unproved |
| Variance-proxy trace-mgf provider | `traceMGFVarianceProxyBound_statement` | typed `Prop`, unproved |
| Matrix Bernstein trace-mgf target | `matrixBernsteinTraceMGF_statement` | typed `Prop`, unproved |
| Matrix exponential PSD from self-adjointness | `matrixExp_posSemidef_of_selfAdjoint_statement`, `matrixExp_posSemidef_of_selfAdjoint` | typed target plus proven theorem |
| Trace-exp nonnegativity from self-adjointness | `traceMatrixExp_nonneg_of_selfAdjoint_statement`, `traceMatrixExp_nonneg_of_selfAdjoint`, `traceExpMoment_nonneg_statement`, `traceExpIntegrand_nonneg_of_randomSelfAdjoint`, `traceExpMoment_nonneg_of_randomSelfAdjoint` | typed targets plus proven deterministic/random-moment bridges |
| Trace-exp nonnegativity from explicit hypotheses | `matrixTrace_nonneg_of_posSemidef`, `traceMatrixExp_nonneg_of_matrixExp_posSemidef`, `traceExpMoment_nonneg_of_nonneg`, `traceExpMomentLIntegral_nonneg` | proven |
| Trace-exp real expectation / lintegral bridge | `traceExpMomentLIntegral_eq_ofReal_statement`, `traceExpMomentLIntegral_eq_ofReal_traceExpMoment`, `traceMGFBernsteinVarianceProxyBoundLIntegral_of_traceMGFBernsteinVarianceProxyBound` | typed target plus proved raw bridge under explicit integrability and pointwise nonnegativity; bounded-Bernstein semantic bridge proved under random self-adjointness and trace-exp integrability |
| Matrix Laplace upper-tail reduction | `matrixLaplaceTransformStatement` | typed `Prop`, unproved |
| Matrix Laplace upper-tail reduction, lintegral form | `matrixLaplaceTransformLIntegralStatement` | typed `Prop`, unproved |
| Conditional trace-exp threshold Markov bound | `traceExpThresholdEvent_lintegral_bound` | proven under explicit a.e. measurability |
| Conditional quadratic-form Laplace bridge | `matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset`, `matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset` | proven only under explicit subset hypothesis `quadraticFormUpperTailEvent Y t subset traceExpThresholdEvent Y theta t` |
| Trace-exp dominance target | `traceExpDominatesQuadraticFormUpperTailStatement`, `traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint` | typed `Prop` statement plus proved concrete random self-adjoint assembly from the `lambdaMaxOrdered` Rayleigh and trace-exp providers |
| Conditional dominance-named Laplace bridge | `matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail`, `matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail`, `matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint`, `matrixLaplaceTransformLIntegral_of_randomSelfAdjoint` | dominance-hypothesis wrappers plus concrete random self-adjoint lintegral Laplace wrappers proved under explicit a.e. measurability and `0 <= theta` |
| Chernoff step from trace-exp bound | `matrixChernoffFromTraceExpStatement` | typed `Prop`, unproved |
| Chernoff step from trace-exp bound, lintegral form | `matrixChernoffFromTraceExpLIntegralStatement` | typed `Prop`, unproved |
| Self-adjoint operator-norm Laplace route | `selfAdjointOperatorNormLaplaceStatement` | typed `Prop`, unproved |
| Self-adjoint operator-norm Laplace route, lintegral form | `selfAdjointOperatorNormLaplaceLIntegralStatement` | typed `Prop`, unproved |
| Matrix Bernstein analytic prerequisites bundle | `matrixBernsteinLaplacePrerequisitesStatement` | typed `Prop`, unproved |

## MB-S2 Analytic Route

The current proof-ready route is:

1. Use `selfAdjointOperatorNormTailViaQuadraticFormStatement_nonempty` when
   the matrix dimension is in the nonempty `Fin (n + 1)` shape. Use
   `selfAdjointOperatorNormTailViaQuadraticFormStatement_of_pos` for arbitrary
   dimensions when `0 < t`; keep the general
   `selfAdjointOperatorNormTailViaQuadraticFormStatement` explicit only for
   retained bridge-explicit wrapper contracts.
2. Use `twoSidedQuadraticFormTailEvent` as the honest event vocabulary while
   the legacy direct lambda/operator-norm endpoint theorem remains unproved.
3. Prove the one-sided `matrixLaplaceTransformStatement` or its lintegral
   variant `matrixLaplaceTransformLIntegralStatement` over
   `quadraticFormUpperTailEvent`.
4. Connect the quadratic-form event to a true lambda-max event through
   `lambdaMax_le_iff_quadraticForm_le_statement`.
5. Connect the operator-norm event to lambda-max events for `Y` and `-Y`
   through `operatorNorm_eq_max_abs_lambda_statement` or an equivalent
   self-adjoint endpoint theorem.
6. Use the MB-S4 theorem `matrixExp_posSemidef_of_selfAdjoint` to supply
   trace-exp nonnegativity for self-adjoint matrices and random self-adjoint
   trace-exp integrands.
7. Prove the trace-mgf bound using `traceExpMoment`,
   `traceExpVarianceProxyBoundStatement`, the PSD variance proxy theorem, and
   the bounded summand assumption.

## Documentation-Only TODOs

The following remain documentation-only, because the major analytic theorems are
not yet available cleanly enough to prove or state beyond the MC5 typed
targets:

- Golden-Thompson inequality;
- Lieb concavity / Tropp master bound;
- full lambda-max/eigenvalue tail theorem beyond the MC5.1 typed targets;
- trace-mgf product/control theorem for independent self-adjoint sums.

## MB-S4 Matrix Exponential PSD Status

MB-S3 proved the reusable downstream bridges:

```lean
matrixTrace_nonneg_of_posSemidef
traceMatrixExp_nonneg_of_matrixExp_posSemidef
traceExpMoment_nonneg_of_nonneg
traceExpMomentLIntegral_nonneg
traceExpMomentLIntegral_eq_ofReal_traceExpMoment
```

MB-S4 proves the missing self-adjoint bridge:

```lean
matrixExp_posSemidef_of_selfAdjoint
traceMatrixExp_nonneg_of_selfAdjoint
traceExpIntegrand_nonneg_of_randomSelfAdjoint
traceExpMoment_nonneg_of_randomSelfAdjoint
```

The proof uses Mathlib's scoped matrix Loewner order and CFC theorem
`IsSelfAdjoint.exp_nonneg`, then converts the resulting nonnegativity through
`Matrix.nonneg_iff_posSemidef`. Matrix Laplace and trace-mgf inequalities
remain unproved.

The old True-bodied `traceExpMomentBoundStatement` declaration remains deleted.
MC5.2 adds a new meaningful `traceExpMomentBoundStatement` over
`traceExpMoment`. MC5.3 adds a new meaningful
`matrixLaplaceTransformStatement` over `quadraticFormUpperTailEvent` and
`traceExpMoment`. MB-S2 adds lintegral variants for trace-exp/Laplace targets
and the dependency bundle `matrixBernsteinLaplacePrerequisitesStatement`.

## MB-S5 Conditional Markov/Laplace Status

MB-S5 proves the generic lintegral Markov step after introducing the threshold
event explicitly:

```lean
traceExpThresholdEvent
matrixLaplaceRHSLIntegralDiv
matrixLaplaceRHSLIntegralDiv_eq_matrixLaplaceRHSLIntegral
traceExpThresholdEvent_lintegral_bound
matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset
matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset
```

The quadratic-form Laplace bridge is intentionally conditional. It assumes:

```lean
quadraticFormUpperTailEvent Y t subset traceExpThresholdEvent Y theta t
```

The current repository does not prove that subset. Therefore
`matrixLaplaceTransformStatement` and
`matrixLaplaceTransformLIntegralStatement` remain typed unproved targets, and
the trace-mgf, Golden-Thompson, Lieb, and Matrix Bernstein steps remain
unproved.

## MB-S6 Source-First Conditional Dominance Status

MB-S6 surveyed the external book/source material for the missing event-subset
step. The sources support the largest-eigenvalue trace-exponential route but
do not directly prove the current HighDimProb
`quadraticFormUpperTailEvent` subset without Rayleigh/min-max and
matrix-function spectral machinery. MB-S6 therefore exposes the missing step
as an explicit predicate:

```lean
TraceExpDominatesQuadraticFormUpperTail
traceExpDominatesQuadraticFormUpperTailStatement
```

and proves only conditional consequences:

```lean
quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates
matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail
matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail
```

The direct concrete proof
`traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint` is now proved
by MB-S7C from random self-adjointness and `0 <= theta`. The full matrix
Laplace theorem, trace-mgf inequalities, Golden-Thompson, Lieb, and Matrix
Bernstein remain unproved.

## MB-S7B Semantic Trace-Exp Dominance Status

MB-S7B-semantic adds the deterministic semantic predicate:

```lean
TraceExpDominatesUpperBound
```

and proves generic event bridges:

```lean
matrixUpperBoundTailEvent_subset_traceExpThresholdEvent_of_traceExpDominatesUpperBound
quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_rayleighUpperBound_of_traceExpDominatesUpperBound
quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_spectralUpperBound_of_traceExpDominatesUpperBound
traceExpDominatesQuadraticFormUpperTail_of_rayleighUpperBound_of_traceExpDominatesUpperBound
traceExpDominatesQuadraticFormUpperTail_of_spectralUpperBound_of_traceExpDominatesUpperBound
```

This stage proves only semantic consequences from explicit pointwise
`TraceExpDominatesUpperBound` assumptions. It does not prove the
`lambdaMaxOrdered` trace-exp provider theorem, spectral mapping, full matrix
Laplace, trace-mgf, Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S7B Scalar Endpoint Status

MB-S7B-scalar-endpoint proves:

```lean
lambdaMaxOrdered_smul_of_nonneg
```

This shows that `lambdaMaxOrdered (theta smul A)` agrees with
`theta * lambdaMaxOrdered A hA` for `0 <= theta` using the ordered endpoint and
real spectrum APIs. It resolves the scalar-multiplication split in the
trace-exp provider plan only. It does not prove the `lambdaMaxOrdered`
trace-exp provider theorem, exponential spectral mapping, trace endpoint
dominance, full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, or Matrix
Bernstein.

## MB-S7B Exponential Spectral Mapping Status

MB-S7B-exp-spectral-mapping proves:

```lean
lambdaMaxOrdered_matrixExp
```

This shows that the ordered largest endpoint of `matrixExp A` is
`Real.exp (lambdaMaxOrdered A hA)` for self-adjoint real matrices. It resolves
only the exponential spectral-mapping split in the future `lambdaMaxOrdered`
trace-exp provider route. It does not prove the `lambdaMaxOrdered` trace-exp
provider theorem, trace-dominates-endpoint theorem, full matrix Laplace,
trace-mgf, Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S7B Trace Endpoint Status

MB-S7B-trace-dominates-endpoint proves:

```lean
lambdaMaxOrdered_le_trace_of_posSemidef
```

This shows that a positive semidefinite self-adjoint matrix has ordered
largest endpoint bounded by `Matrix.trace`. It resolves the trace endpoint
split in the future `lambdaMaxOrdered` trace-exp provider route. It does not
prove the `lambdaMaxOrdered` trace-exp provider theorem, full matrix Laplace,
trace-mgf, Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S7B Provider-Close Status

MB-S7B-provider-close proves:

```lean
lambdaMaxOrdered_traceExpDominatesUpperBound
```

This assembles the proved scalar endpoint, matrix-exponential spectral mapping,
and trace endpoint helpers into the deterministic
`TraceExpDominatesUpperBound` provider for `lambdaMaxOrdered`. It does not
prove full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, or Matrix
Bernstein.

## MB-S7C Concrete Dominance Assembly Status

MB-S7C-assemble-dominance proves:

```lean
traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint
```

This assembles the `lambdaMaxOrdered` Rayleigh provider, the
`lambdaMaxOrdered` trace-exp provider, and the generic semantic bridge into
`TraceExpDominatesQuadraticFormUpperTail` for random self-adjoint matrices
under explicit `0 <= theta`. It does not prove full matrix Laplace,
trace-mgf, Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S8 Concrete LIntegral Laplace Assembly Status

MB-S8-laplace-assembly proves:

```lean
matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint
matrixLaplaceTransformLIntegral_of_randomSelfAdjoint
```

These theorems assemble the concrete dominance theorem with the existing
conditional Laplace wrappers. They keep the trace-exp integrand a.e.
measurability hypothesis explicit and assume random self-adjointness plus
`0 <= theta`. This stage does not prove the real RHS / real expectation bridge,
trace-mgf, Golden-Thompson, Lieb, or Matrix Bernstein.

## PSD Variance Proxy Status

The PSD variance proxy theorem is proved:

```lean
isPSD_matrixVarianceProxy_of_selfAdjoint
```

It requires:

1. `forall i, RandomSelfAdjointMatrix P (A i)`;
2. `forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i))`.

The proof uses explicit finite-sum algebra rather than spectral theory:
`A^2` has quadratic form `||A x||^2`, entrywise expectation commutes with the
quadratic form under entrywise integrability, and finite sums preserve the
explicit `IsPSDMatrix` predicate.

## Proof Route

1. Use the proved ordered provider route
   `lambdaMaxOrdered_spectralUpperBound -> lambdaMaxOrdered_rayleighUpperBound`
   for one-sided ordered endpoint reductions; the legacy `lambdaMax` direct
   bridge and self-adjoint operator-norm/eigenvalue endpoint bridges remain
   future proof work.
2. Use the proved concrete lintegral Laplace wrappers
   `matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint` and
   `matrixLaplaceTransformLIntegral_of_randomSelfAdjoint`.
3. Use the proved bounded-Bernstein real-to-lintegral semantic bridge under
   explicit random self-adjointness and trace-exp integrability.
4. Prove or import trace-exponential moment inequalities over the
   semantic `TraceMGFBound` / `TraceMGFVarianceProxyBound` vocabulary.
5. Optimize the resulting scalar parameter to derive the additive Bernstein
   denominator and then any min-form corollary.

## MB-S9 Foundation Status

MB-S9-foundation adds semantic trace-mgf and variance-proxy vocabulary without
proving a trace-mgf theorem:

```lean
TraceMGFBound
TraceMGFBoundLIntegral
TraceMGFVarianceProxyBound
TraceMGFVarianceProxyBoundLIntegral
MatrixVarianceProxyUpperBound
MatrixVarianceProxyNormBound
traceMGFBound_statement
traceMGFBoundLIntegral_statement
traceMGFVarianceProxyBound_statement
troppMasterTraceMGFStep_statement
matrixBernsteinTraceMGF_statement
```

The new names make the future trace-mgf route depend on semantic moment and
variance-proxy predicates rather than ad hoc concrete expressions. The typed
statements remain unproved and isolate the future matrix-mgf comparison step.
MB-S9 does not prove Golden-Thompson, Lieb, the full trace-mgf master theorem,
the real RHS bridge, or Matrix Bernstein.

## MB-S9 Tropp Master Typed Primitive

MB-S9-Tropp-master-typed-primitive adds
`troppMasterTraceMGFStep_statement` in
`HighDimProb/RandomMatrix/TraceExp.lean`.

The statement records the source-backed Tropp/Lieb one-step inequality
`E tr exp(H + Z) <= tr exp(H + log E exp Z)` as a typed `Prop` only. It keeps
the deterministic self-adjoint matrix `H`, random self-adjoint matrix `Z`,
trace-exp integrability, matrix-exponential entrywise integrability,
self-adjointness of `E exp Z`, and strict positivity of `E exp Z` explicit.
It does not prove Lieb concavity, Golden-Thompson, the trace-mgf provider, the
full trace-mgf master theorem, the real RHS bridge, or Matrix Bernstein.

## MB-S9 Single-Summand MGF Typed Primitive

MB-S9-single-summand-mgf-typed-primitive adds
`singleSummandMatrixMGFVarianceProxy_statement` in
`HighDimProb/RandomMatrix/TraceExp.lean`.

The statement records the source-backed single-summand Bernstein matrix MGF
comparison as a typed `Prop` only. It keeps self-adjointness, entrywise
measurability, integrability of `X`, `X^2`, and `exp(theta X)`, zero mean,
pointwise operator-norm boundedness, theta range, deterministic comparison
matrix structure, square/variance-proxy comparison, and the `MatrixLE`
conclusion explicit.

It does not prove the scalar-to-matrix functional-calculus bridge,
operator-norm-to-spectral-interval bridge, trace-mgf provider,
Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S9 Bernstein CFC Typed Primitive

MB-S9-bernstein-cfc-typed-primitive adds
`bernsteinMatrixExp_le_quadratic_statement` in
`HighDimProb/RandomMatrix/TraceExp.lean`.

The statement records the Bernstein-specific scalar-to-matrix
functional-calculus lift as a typed `Prop` only. It keeps self-adjointness,
the deterministic operator-norm bound, nonnegative radius, theta range,
the explicit Bernstein quadratic coefficient
`(theta ^ 2 / 2) / (1 - |theta| * R / 3)`, and the `MatrixLE` conclusion
explicit.

It does not prove the functional-calculus bridge, the single-summand MGF
theorem, operator-norm-to-spectral-interval bridge, trace-mgf provider,
Golden-Thompson, Lieb, or Matrix Bernstein. It was followed by
MB-S9-PSD-expectation-proof.

## MB-S9 PSD Expectation Proof

MB-S9-PSD-expectation-proof proves the matrix expectation PSD/order bridge in
`HighDimProb/RandomMatrix/VarianceProxy.lean`.

New proved declarations:

```lean
integrableRandomMatrix_sub
matrixExpect_sub
isPSDMatrix_matrixExpect_of_pointwise_isPSD
matrixExpect_matrixLE_of_pointwise_matrixLE
```

This stage proves that entrywise matrix expectation preserves pointwise PSD
matrices and that `matrixExpect` is monotone for `MatrixLE` under explicit
entrywise integrability assumptions. It does not prove the functional-calculus
bridge, the single-summand MGF theorem, the trace-mgf provider,
Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S9 Expectation Linearity Proof

MB-S9-expectation-linearity-proof proves small `matrixExpect` algebra and
normalization lemmas in `HighDimProb/RandomMatrix/VarianceProxy.lean`.

New proved declarations:

```lean
integrableRandomMatrix_add
integrableRandomMatrix_smul
integrableRandomMatrix_zero
integrableRandomMatrix_const
matrixExpect_add
matrixExpect_smul
matrixExpect_zero
matrixExpect_const
matrixExpect_const_of_isProbabilityMeasure
matrixExpect_one_of_isProbabilityMeasure
```

This stage proves entrywise integrability closure for add/smul/zero/constant
random matrices and expectation normalization for add/smul/zero/constant
matrices, including probability-measure wrappers for constants and the
identity matrix. Later MB-S9 stages prove the provider under explicit CFC
assumptions. The functional-calculus bridge itself, trace-mgf provider,
Golden-Thompson, Lieb, and Matrix Bernstein remain unproved.

## Next Safe Task

Stage MB-S9-trace-mgf-to-laplace-tail-contract-v2: re-audit how the proved
bounded trace-MGF theorem under explicit primitives and the proved
real-to-lintegral semantic bridge connect to the existing Laplace/tail layer.
Do not prove Lieb, Golden-Thompson, the Bernstein CFC primitive,
lambda-max/operator-norm tail reduction, or the full Matrix Bernstein
tail theorem in that contract stage.

## MB-S7A Spectral Bridge Typed Split

MB-S7A splits the missing Rayleigh/lambda route honestly in
`HighDimProb.RandomMatrix.Spectral`.

Added typed spectral target:

```lean
matrixQuadraticForm_le_lambdaMax_statement
```

This is a typed `Prop` over `Fin (n + 1)` self-adjoint matrices. It is not a
proved Rayleigh theorem.

Added proven conditional helpers:

```lean
quadraticFormUpperBound_of_lambdaMax_le_of_matrixQuadraticForm_le_lambdaMax
lambdaMaxUpperTailEvent
quadraticFormUpperTailEvent_subset_lambdaMaxUpperTailEvent_of_matrixQuadraticForm_le_lambdaMax
not_isUnitVector_fin_zero
unitSphere_empty_of_zero_dim
quadraticFormUpperTailEvent_empty_of_zero_dim
```

Dimension handling is explicit: the lambda wrappers remain `Fin (n + 1)`;
zero-dimensional unit-sphere and upper-tail events are proved empty rather than
coerced into the nonempty spectral API.

The direct quadratic-form/Rayleigh proof, lambda endpoint theorem,
trace-exponential spectral dominance, full matrix Laplace theorem, trace-mgf,
Golden-Thompson, Lieb, and Matrix Bernstein remain unproved.

## MB-S7A-fix Rayleigh Conversion Helper Bridge

MB-S7A-fix proves the small conversion lemmas needed once the lambda endpoint
PSD premise is available:

```lean
LambdaMaxPSDUpperBound
matrixQuadraticForm_nonneg_of_posSemidef
matrixQuadraticForm_smul_one_of_isUnitVector
matrixQuadraticForm_le_lambdaMax_of_lambdaMax_sub_posSemidef
matrixQuadraticForm_le_lambdaMax_of_lambdaMaxPSDUpperBound
```

The direct theorem behind `matrixQuadraticForm_le_lambdaMax_statement` remains
unproved. The remaining blocker is the spectral endpoint/order theorem giving
`((lambdaMax A hA) smul 1 - A).PosSemidef` for self-adjoint
`A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real`.

Dimension handling remains `Fin (n + 1)` for lambda wrappers, with the
zero-dimensional path handled by the MB-S7A emptiness lemmas. Trace-exp
spectral dominance, full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, and
Matrix Bernstein remain unproved.

## MB-S7A-clean API Consolidation

MB-S7A-clean keeps the API stable and names the repeated endpoint PSD premise:

```lean
LambdaMaxPSDUpperBound
matrixQuadraticForm_le_lambdaMax_of_lambdaMaxPSDUpperBound
```

`LambdaMaxPSDUpperBound A hA` is an abbreviation for the endpoint premise
`((lambdaMax A hA) smul 1 - A).PosSemidef`. The wrapper theorem is only a direct
reuse of the MB-S7A-fix helper; it does not prove the endpoint premise or the
unconditional Rayleigh theorem.

The next blocker is unchanged but now has a shorter target name: prove
`LambdaMaxPSDUpperBound A hA` or prove `lambdaMax_is_greatest_eigenvalue_statement`
and derive it. Trace-exp spectral dominance, full matrix Laplace, trace-mgf,
Golden-Thompson, Lieb, and Matrix Bernstein remain unproved.

## MB-S7A-order Endpoint Ordering Probe

MB-S7A-order did not add Lean source declarations. The probe found that
Mathlib proves the ordered endpoint fact for `Matrix.IsHermitian.eigenvalues?`
via `Matrix.IsHermitian.eigenvalues?_antitone`, but the current HighDimProb
`lambdaMax` wrapper is defined through `Matrix.IsHermitian.eigenvalues`, which
reindexes `eigenvalues?` using `Fintype.equivOfCardEq`. No local or Mathlib API
currently proves that this reindex maps `0 : Fin (n + 1)` to the first ordered
eigenvalue index or preserves order. Therefore `LambdaMaxPSDUpperBound A hA`
and `lambdaMax_is_greatest_eigenvalue_statement` remain unproved.

## MB-S7A-index Ordered Endpoint Wrapper

MB-S7A-index preserves the existing public `lambdaMax` API and adds a separate
canonical ordered endpoint route:

```lean
lambdaMaxOrdered
lambdaMaxOrdered_eq_eigenvalues?_zero
lambdaMax_eq_lambdaMaxOrdered_statement
lambdaMaxOrdered_is_greatest_eigenvalue_statement
lambdaMaxOrdered_is_greatest_eigenvalue
LambdaMaxOrderedPSDUpperBound
matrixQuadraticForm_le_lambdaMaxOrdered_statement
matrixQuadraticForm_le_lambdaMaxOrdered_of_lambdaMaxOrderedPSDUpperBound
lambdaMaxOrderedUpperTailEvent
quadraticFormUpperTailEvent_subset_lambdaMaxOrderedUpperTailEvent_of_matrixQuadraticForm_le_lambdaMaxOrdered
```

`lambdaMaxOrdered A hA` is definitionally `hA.eigenvalues? 0`, and
`lambdaMaxOrdered_is_greatest_eigenvalue` is proved by
`Matrix.IsHermitian.eigenvalues?_antitone`. The legacy bridge
`lambdaMax_eq_lambdaMaxOrdered_statement` remains a typed statement because
Mathlib's `eigenvalues` reindex still goes through `Fintype.equivOfCardEq`.
The unconditional endpoint PSD theorem, direct Rayleigh theorem, trace-exp
spectral dominance, full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, and
Matrix Bernstein remain unproved.

## MB-S7A-abstract Semantic Spectral API

MB-S7A-abstract pauses proof progress and consolidates the spectral bridge
around semantic predicates:

```lean
SpectralUpperBound
RayleighUpperBound
scalarUpperTailEvent
matrixUpperBoundTailEvent
```

The generic bridge `rayleighUpperBound_of_spectralUpperBound` now turns a
semantic PSD/Loewner upper bound into an explicit HighDimProb Rayleigh bound.
The generic event bridges route `quadraticFormUpperTailEvent` into scalar or
matrix upper-bound tail events from pointwise `RayleighUpperBound` or
`SpectralUpperBound` assumptions. Existing `lambdaMax` and `lambdaMaxOrdered`
public declarations remain compatibility/provider APIs.

This stage does not prove `LambdaMaxOrderedPSDUpperBound`, legacy/ordered
lambda compatibility, trace-exp spectral dominance, full matrix Laplace,
trace-mgf, Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S7A-provider Ordered Endpoint Semantic Provider

MB-S7A-provider proves that the canonical ordered endpoint supplies the semantic
spectral upper bound:

```lean
lambdaMaxOrdered_spectralUpperBound
lambdaMaxOrderedPSDUpperBound
lambdaMaxOrdered_rayleighUpperBound
```

The proof uses Mathlib spectral/order APIs for Hermitian matrices and preserves
the legacy `lambdaMax` API unchanged. It does not prove legacy/ordered lambda
compatibility, trace-exp spectral dominance, full matrix Laplace, trace-mgf,
Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S9-matrixle-algebra-proof MatrixLE / PSD Algebra

MB-S9-matrixle-algebra-proof proves the small matrix-order algebra needed by
the future single-summand provider:

```lean
matrixQuadraticForm_add
matrixQuadraticForm_smul
isPSDMatrix_zero
isPSDMatrix_add
isPSDMatrix_smul_of_nonneg
matrixLE_refl
matrixLE_of_eq
matrixLE_trans
matrixLE_add
matrixLE_add_left
matrixLE_add_right
matrixLE_smul_of_nonneg
```

The stage does not prove the Bernstein CFC primitive, single-summand MGF
provider, trace-mgf provider, Golden-Thompson, Lieb, or Matrix Bernstein.

Follow-up at the time: MB-S9-trace-mgf-to-laplace-tail-contract; re-audit the
single-summand provider route now that MatrixLE algebra, matrix expectation
monotonicity, and matrix expectation linearity/normalization are available, or
block cleanly on the next matrix-mgf prerequisite.

## MB-S9-bernstein-coefficient-proof Bernstein Coefficient

MB-S9-bernstein-coefficient-proof proves the scalar helper
`bernsteinCoefficient_nonneg`:

```lean
0 <= (theta ^ 2 / 2) / (1 - abs theta * R / 3)
```

under the standard Bernstein theta-range assumption `abs theta * R < 3`.
This removes the coefficient nonnegativity blocker needed by
`matrixLE_smul_of_nonneg` in the future single-summand provider assembly.

The stage did not prove the single-summand provider, the Bernstein CFC
primitive, the downstream matrix exponential lower bound, the trace-mgf
provider, Golden-Thompson, Lieb, or Matrix Bernstein. The downstream matrix
exponential lower bound is now resolved by MB-S9-exp-lower-bound-proof.

## MB-S9-exp-lower-bound-proof Matrix Exponential Lower Bound

MB-S9-exp-lower-bound-proof proves the deterministic affine lower bound for
matrix exponential in `HighDimProb/RandomMatrix/TraceExp.lean`:

```lean
matrixLE_one_add_self_le_matrixExp_of_selfAdjoint
matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint
```

The generic theorem proves `MatrixLE (1 + A) (matrixExp A)` for self-adjoint
real matrices. The wrapper proves the downstream scalar-multiple form
`MatrixLE (1 + SMul.smul c V) (matrixExp (SMul.smul c V))` from
self-adjointness of `V`. This stage did not prove the single-summand provider,
the Bernstein CFC primitive, the trace-mgf provider, Golden-Thompson, Lieb, or
Matrix Bernstein.

## MB-S9-single-summand-provider-under-cfc

MB-S9-single-summand-provider-under-cfc proves:

```lean
singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic
```

The theorem assembles `singleSummandMatrixMGFVarianceProxy_statement` from an
explicit pointwise `bernsteinMatrixExp_le_quadratic_statement` assumption,
`[IsProbabilityMeasure P]`, expectation monotonicity, expectation
add/smul/constant normalization, MatrixLE algebra, coefficient nonnegativity,
second-moment comparison, and the matrix exponential lower bound.

The Bernstein CFC primitive itself remains typed only. The trace-mgf provider,
Golden-Thompson, Lieb, full CFC-free single-summand provider, and Matrix
Bernstein remain unproved.

Next safe task was MB-S9-trace-mgf-to-laplace-tail-contract.

## MB-S9-rhs-normalization-proof Bounded Bernstein RHS

MB-S9-rhs-normalization-proof introduces the canonical bounded Bernstein
coefficient normal form in `HighDimProb/RandomMatrix/TraceExp.lean`:

```lean
bernsteinMGFCoeff theta R =
  (theta ^ 2 / 2) / (1 - abs theta * R / 3)
bernsteinMGFCoeff_nonneg
```

The bounded trace-mgf semantic targets are now:

```lean
TraceMGFBernsteinVarianceProxyBound
TraceMGFBernsteinVarianceProxyBoundLIntegral
traceMGFBernsteinVarianceProxyBound_statement
matrixBernsteinTraceMGFWithBernsteinCoeff_statement
```

The older `TraceMGFVarianceProxyBound` and
`matrixBernsteinTraceMGF_statement` are retained for compatibility, but their
RHS coefficient is `theta ^ 2 / 2`; they are not the bounded Matrix Bernstein
denominator target. This stage does not prove the trace-mgf provider, the
Tropp/Lieb primitive, the Bernstein CFC primitive, Golden-Thompson, Lieb, or
Matrix Bernstein.

Follow-up at the time: MB-S9-trace-mgf-to-laplace-tail-contract.

## MB-S9-tropp-shape-refactor Finite-Family Tropp Interface

MB-S9-tropp-shape-refactor adds the typed-only finite-family Tropp/Lieb
iteration interface:

```lean
troppMasterTraceMGFFiniteFamily_statement
```

The new statement consumes per-summand matrix-MGF `MatrixLE` comparisons,
`iIndepFun` independence, full-sum trace-exp integrability, deterministic
comparison self-adjointness, and explicit normalization of `sum_i K_i` to the
bounded Bernstein coefficient `bernsteinMGFCoeff theta R`. Its conclusion is
`TraceMGFBernsteinVarianceProxyBound P (randomMatrixSum X) V theta R`.

The one-step log-form primitive `troppMasterTraceMGFStep_statement` remains
available. This stage did not prove Lieb, Golden-Thompson, the Tropp
finite-family primitive, the trace-mgf provider, or Matrix Bernstein.

Follow-up at the time: MB-S9-trace-mgf-to-laplace-tail-contract.

## MB-S9 Trace-MGF Thin Wrapper Status

MB-S9-trace-mgf-provider-thin-wrapper-proof proves the direct wrappers:

```lean
traceMGFBernsteinVarianceProxyBound_of_troppMasterTraceMGFFiniteFamily
matrixBernsteinTraceMGFWithBernsteinCoeff_of_troppMasterTraceMGFFiniteFamily
```

The semantic wrapper applies `troppMasterTraceMGFFiniteFamily_statement` to
its explicit finite-family assumptions and concludes
`TraceMGFBernsteinVarianceProxyBound P (randomMatrixSum X) V theta R`. The
high-level wrapper specializes `V` to `matrixVarianceProxy P A` and concludes
`matrixBernsteinTraceMGFWithBernsteinCoeff_statement P A theta R`.

This stage does not prove the finite-family Tropp/Lieb primitive, the
one-step Tropp primitive, Lieb concavity, Golden-Thompson, the Bernstein CFC
primitive, or the Matrix Bernstein tail theorem.

Follow-up at the time: MB-S9-trace-mgf-to-laplace-tail-contract.

## MB-S9 Matrix Bernstein Trace-MGF Under Primitives

MB-S9-matrix-bernstein-trace-mgf-under-primitives-proof proves:

```lean
matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives
```

The theorem packages centered self-adjoint finite-family assumptions,
independence, integrability, operator-norm boundedness, the theta range, an
explicit pointwise `bernsteinMatrixExp_le_quadratic_statement` assumption, and
an explicit `troppMasterTraceMGFFiniteFamily_statement` assumption into
`matrixBernsteinTraceMGFWithBernsteinCoeff_statement P A theta R`.

The proof uses the already proved single-summand provider under CFC and the
thin high-level Tropp wrapper. It does not prove the finite-family Tropp/Lieb
primitive, the Bernstein CFC primitive, Lieb, Golden-Thompson, or the Matrix
Bernstein tail theorem.

## MB-S9 Trace-MGF LIntegral Bridge

MB-S9-trace-mgf-lintegral-bridge-proof proves:

```lean
traceMGFBernsteinVarianceProxyBoundLIntegral_of_traceMGFBernsteinVarianceProxyBound
```

This theorem converts the bounded-Bernstein real semantic trace-MGF bound to
the corresponding lintegral semantic trace-MGF bound under random
self-adjointness and trace-exp integrability. It does not prove event
reduction, lambda-max/operator-norm tail reduction, Tropp/Lieb, the
Bernstein CFC primitive, Golden-Thompson, or the Matrix Bernstein tail theorem.

The downstream compatibility contract APIs remain available:

```lean
matrixBernsteinTraceMGFToLaplaceContract_statement
matrixBernsteinTraceMGFToLaplaceContract_under_primitives_statement
```

They package the same bounded-Bernstein lintegral Laplace route with
`randomMatrixSum A` and `matrixVarianceProxy P A` visible at the Matrix
Bernstein layer.

Follow-up at the time: MB-S9-trace-mgf-to-laplace-tail-contract-v2.
