# Matrix Bernstein Proof Plan

Stage MB-S2 records the current honest proof plan for matrix Bernstein.
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
| Second moment PSD | `isPSD_matrixSecondMoment_of_selfAdjoint` |
| Finite PSD sums | `isPSDMatrix_sum` |
| Second moment self-adjointness | `isSelfAdjointMatrix_matrixSecondMoment` |
| Variance proxy self-adjointness | `isSelfAdjointMatrix_matrixVarianceProxy` |
| Variance proxy PSD | `isPSD_matrixVarianceProxy_of_selfAdjoint` |
| Spectral vocabulary | `lambdaMax`, `lambdaMaxOrdered`, `lambdaMaxOrdered_eq_eigenvalues₀_zero`, `lambdaMin`, `QuadraticFormUpperBound`, `QuadraticFormLowerBound`, `quadraticFormUpperTailEvent`, `quadraticFormLowerTailEvent`, `twoSidedQuadraticFormTailEvent`, `LambdaMaxPSDUpperBound`, `LambdaMaxOrderedPSDUpperBound`, `matrixQuadraticForm_nonneg_of_posSemidef`, `matrixQuadraticForm_smul_one_of_isUnitVector`, `matrixQuadraticForm_le_lambdaMax_of_lambdaMax_sub_posSemidef`, `matrixQuadraticForm_le_lambdaMax_of_lambdaMaxPSDUpperBound`, `lambdaMaxOrdered_is_greatest_eigenvalue`, `matrixQuadraticForm_le_lambdaMaxOrdered_of_lambdaMaxOrderedPSDUpperBound` |
| Quadratic-form event inclusions | `quadraticFormUpperTailEvent_subset_twoSidedQuadraticFormTailEvent`, `quadraticFormLowerTailEvent_subset_twoSidedQuadraticFormTailEvent` |
| Matrix exponential and trace | `matrixExp`, `matrixTrace`, `traceMatrixExp`, `traceExpIntegrand`, `traceExpMoment`, `traceExpMomentLIntegral`, `matrixExp_posSemidef_of_selfAdjoint`, `traceMatrixExp_nonneg_of_selfAdjoint`, `traceExpIntegrand_nonneg_of_randomSelfAdjoint`, `traceExpMoment_nonneg_of_randomSelfAdjoint`, `matrixTrace_nonneg_of_posSemidef`, `traceMatrixExp_nonneg_of_matrixExp_posSemidef`, `traceExpMoment_nonneg_of_nonneg`, `traceExpMomentLIntegral_nonneg`, `traceExpMomentLIntegral_eq_ofReal_traceExpMoment` |
| Conditional trace-exp Markov/Laplace bridge | `traceExpThresholdEvent`, `matrixLaplaceRHSLIntegralDiv`, `matrixLaplaceRHSLIntegralDiv_eq_matrixLaplaceRHSLIntegral`, `traceExpThresholdEvent_lintegral_bound`, `matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset`, `matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset` |
| Conditional trace-exp dominance/Laplace bridge | `TraceExpDominatesQuadraticFormUpperTail`, `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates`, `matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail`, `matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail` |

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
| Lambda-max/Rayleigh bridge | `lambdaMax_le_iff_quadraticForm_le_statement`, `matrixQuadraticForm_le_lambdaMax_statement`, `matrixQuadraticForm_le_lambdaMax_of_lambdaMax_sub_posSemidef`, `lambdaMax_eq_lambdaMaxOrdered_statement`, `matrixQuadraticForm_le_lambdaMaxOrdered_statement` | legacy direct theorem typed/unproved; ordered endpoint wrapper added; conditional PSD-to-Rayleigh helpers proved for both legacy and ordered routes |
| Self-adjoint norm/eigenvalue endpoint bridge | `operatorNorm_eq_max_abs_lambda_statement` | typed `Prop`, unproved |
| Lambda-max endpoint ordering bridge | `lambdaMax_is_greatest_eigenvalue_statement`, `lambdaMaxOrdered_is_greatest_eigenvalue_statement`, `lambdaMaxOrdered_is_greatest_eigenvalue` | legacy statement typed/unproved; ordered endpoint theorem proved for `eigenvalues₀` |
| Lambda-min endpoint ordering bridge | `lambdaMin_is_least_eigenvalue_statement` | typed `Prop`, unproved |
| Self-adjoint operator-norm tail via quadratic forms | `selfAdjointOperatorNormTailViaQuadraticFormStatement` | typed `Prop`, unproved |
| Trace-exponential moment bound | `traceExpMomentBoundStatement` | typed `Prop`, unproved |
| Variance-proxy trace-exponential bound | `traceExpVarianceProxyBoundStatement` | typed `Prop`, unproved |
| Matrix exponential PSD from self-adjointness | `matrixExp_posSemidef_of_selfAdjoint_statement`, `matrixExp_posSemidef_of_selfAdjoint` | typed target plus proven theorem |
| Trace-exp nonnegativity from self-adjointness | `traceMatrixExp_nonneg_of_selfAdjoint_statement`, `traceMatrixExp_nonneg_of_selfAdjoint`, `traceExpMoment_nonneg_statement`, `traceExpIntegrand_nonneg_of_randomSelfAdjoint`, `traceExpMoment_nonneg_of_randomSelfAdjoint` | typed targets plus proven deterministic/random-moment bridges |
| Trace-exp nonnegativity from explicit hypotheses | `matrixTrace_nonneg_of_posSemidef`, `traceMatrixExp_nonneg_of_matrixExp_posSemidef`, `traceExpMoment_nonneg_of_nonneg`, `traceExpMomentLIntegral_nonneg` | proven |
| Trace-exp real expectation / lintegral bridge | `traceExpMomentLIntegral_eq_ofReal_statement`, `traceExpMomentLIntegral_eq_ofReal_traceExpMoment` | typed target plus proven theorem under explicit integrability and pointwise nonnegativity |
| Matrix Laplace upper-tail reduction | `matrixLaplaceTransformStatement` | typed `Prop`, unproved |
| Matrix Laplace upper-tail reduction, lintegral form | `matrixLaplaceTransformLIntegralStatement` | typed `Prop`, unproved |
| Conditional trace-exp threshold Markov bound | `traceExpThresholdEvent_lintegral_bound` | proven under explicit a.e. measurability |
| Conditional quadratic-form Laplace bridge | `matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset`, `matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset` | proven only under explicit subset hypothesis `quadraticFormUpperTailEvent Y t ⊆ traceExpThresholdEvent Y theta t` |
| Trace-exp dominance target | `traceExpDominatesQuadraticFormUpperTailStatement` | typed `Prop`, unproved direct spectral/Rayleigh bridge |
| Conditional dominance-named Laplace bridge | `matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail`, `matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail` | proven only under explicit `TraceExpDominatesQuadraticFormUpperTail Y theta t` |
| Chernoff step from trace-exp bound | `matrixChernoffFromTraceExpStatement` | typed `Prop`, unproved |
| Chernoff step from trace-exp bound, lintegral form | `matrixChernoffFromTraceExpLIntegralStatement` | typed `Prop`, unproved |
| Self-adjoint operator-norm Laplace route | `selfAdjointOperatorNormLaplaceStatement` | typed `Prop`, unproved |
| Self-adjoint operator-norm Laplace route, lintegral form | `selfAdjointOperatorNormLaplaceLIntegralStatement` | typed `Prop`, unproved |
| Matrix Bernstein analytic prerequisites bundle | `matrixBernsteinLaplacePrerequisitesStatement` | typed `Prop`, unproved |

## MB-S2 Analytic Route

The current proof-ready route is:

1. Use `selfAdjointOperatorNormTailViaQuadraticFormStatement` as the future
   bridge from operator-norm tails to two-sided quadratic-form tails.
2. Use `twoSidedQuadraticFormTailEvent` as the honest event vocabulary while
   the exact Rayleigh/operator-norm theorem is unproved.
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

The old True-bodied `traceExpMomentBoundStatement` placeholder remains deleted.
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
quadraticFormUpperTailEvent Y t ⊆ traceExpThresholdEvent Y theta t
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

The direct proof of `TraceExpDominatesQuadraticFormUpperTail Y theta t`
remains open. The full matrix Laplace theorem, trace-mgf inequalities,
Golden-Thompson, Lieb, and Matrix Bernstein remain unproved.

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

1. Prove the lambda-max/Rayleigh and self-adjoint
   operator-norm/eigenvalue endpoint bridges.
2. Prove or import trace-exponential moment inequalities over the new
   `traceExpMoment` vocabulary.
3. Prove the direct `TraceExpDominatesQuadraticFormUpperTail Y theta t`
   bridge from Rayleigh/min-max, lambda-max, and trace-exponential spectral
   facts under explicit hypotheses.
4. Prove the typed matrix Laplace transform method, which still likely
   requires Golden-Thompson and Lieb-style trace inequalities for the trace-mgf
   step.
5. Optimize the resulting scalar parameter to derive the additive Bernstein
   denominator and then any min-form corollary.

## Next Safe Task

Stage MB-S7A-provider - prove that `lambdaMaxOrdered` provides
`SpectralUpperBound`, or block cleanly. Do not prove trace-exp spectral
dominance, trace-mgf, Golden-Thompson, Lieb, full matrix Laplace, or Matrix
Bernstein.

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
`((lambdaMax A hA) • 1 - A).PosSemidef` for self-adjoint
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
`((lambdaMax A hA) • 1 - A).PosSemidef`. The wrapper theorem is only a direct
reuse of the MB-S7A-fix helper; it does not prove the endpoint premise or the
unconditional Rayleigh theorem.

The next blocker is unchanged but now has a shorter target name: prove
`LambdaMaxPSDUpperBound A hA` or prove `lambdaMax_is_greatest_eigenvalue_statement`
and derive it. Trace-exp spectral dominance, full matrix Laplace, trace-mgf,
Golden-Thompson, Lieb, and Matrix Bernstein remain unproved.

## MB-S7A-order Endpoint Ordering Probe

MB-S7A-order did not add Lean source declarations. The probe found that
Mathlib proves the ordered endpoint fact for `Matrix.IsHermitian.eigenvalues₀`
via `Matrix.IsHermitian.eigenvalues₀_antitone`, but the current HighDimProb
`lambdaMax` wrapper is defined through `Matrix.IsHermitian.eigenvalues`, which
reindexes `eigenvalues₀` using `Fintype.equivOfCardEq`. No local or Mathlib API
currently proves that this reindex maps `0 : Fin (n + 1)` to the first ordered
eigenvalue index or preserves order. Therefore `LambdaMaxPSDUpperBound A hA`
and `lambdaMax_is_greatest_eigenvalue_statement` remain unproved.

## MB-S7A-index Ordered Endpoint Wrapper

MB-S7A-index preserves the existing public `lambdaMax` API and adds a separate
canonical ordered endpoint route:

```lean
lambdaMaxOrdered
lambdaMaxOrdered_eq_eigenvalues₀_zero
lambdaMax_eq_lambdaMaxOrdered_statement
lambdaMaxOrdered_is_greatest_eigenvalue_statement
lambdaMaxOrdered_is_greatest_eigenvalue
LambdaMaxOrderedPSDUpperBound
matrixQuadraticForm_le_lambdaMaxOrdered_statement
matrixQuadraticForm_le_lambdaMaxOrdered_of_lambdaMaxOrderedPSDUpperBound
lambdaMaxOrderedUpperTailEvent
quadraticFormUpperTailEvent_subset_lambdaMaxOrderedUpperTailEvent_of_matrixQuadraticForm_le_lambdaMaxOrdered
```

`lambdaMaxOrdered A hA` is definitionally `hA.eigenvalues₀ 0`, and
`lambdaMaxOrdered_is_greatest_eigenvalue` is proved by
`Matrix.IsHermitian.eigenvalues₀_antitone`. The legacy bridge
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

Next safe task: MB-S7A-provider, prove that `lambdaMaxOrdered` provides
`SpectralUpperBound`, or block cleanly.
