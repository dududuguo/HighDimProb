# Status

Current version target: `v0.1-alpha`

This file is intentionally short. Old stage notes were collapsed into
[`archive.md`](archive.md); use git history for exact old wording. Detailed API
surfaces are tracked in the focused reference docs linked below.

## Current Focus

- Active branch: RandomMatrix / Matrix Bernstein experimental API.
- Active process/random-object API leaf: small `RandomFamily` vocabulary for process and sample surfaces.
- Stable import surface: [`HighDimProb`](../HighDimProb.lean).
- Experimental import surface: [`HighDimProb.Experimental`](../HighDimProb/Experimental.lean) and [`HighDimProb.Examples`](../HighDimProb/Examples.lean).
- Main active RandomMatrix files:
  [`TraceExp.lean`](../HighDimProb/RandomMatrix/TraceExp.lean),
  [`HardboneStatements.lean`](../HighDimProb/RandomMatrix/HardboneStatements.lean), and
  [`ConcentrationStatements.lean`](../HighDimProb/RandomMatrix/ConcentrationStatements.lean).

## Active API Pointers

- API overview: [`APIOverview.md`](APIOverview.md)
- RandomMatrix API index: [`RandomMatrixAPI.md`](RandomMatrixAPI.md)
- Term map / symbol index: [`TermMap.md`](TermMap.md)
- Theorem atlas: [`TheoremAtlas.md`](TheoremAtlas.md)
- Test plan: [`TestPlan.md`](TestPlan.md)
- Judge system: [`JudgeSystem.md`](JudgeSystem.md)
- Workflow: [`Workflow.md`](Workflow.md)

## Current Process / Random Object Entry Names

Random-family helpers:

- `RandomFamily`
- `RealRandomFamily`
- `IsRandomFamily`
- `IsRealRandomFamily`
- `familyAt`
- `mapRandomFamily`
- `isRandomFamily_map`
- `IsRandomProcess`
- `processAt`
- `isRandomVariable_processAt`
- `IsRandomSample`
- `sampleEvaluation`

## Current RandomMatrix Entry Names

Core Matrix Bernstein helpers:

- `matrixBernsteinOptimizedScalarTailRHS`
- `matrixBernsteinTwoSidedOptimizedScalarTailRHS`
- `rowSqNormVarianceProxyNormRHS`
- `MatrixBernsteinPositiveSideAssumptions`
- `MatrixBernsteinNegativeSideAssumptions`
- `MatrixBernsteinPositiveSideTroppAssumptions`
- `MatrixBernsteinNegativeSideTroppAssumptions`
- `matrixBernsteinTraceMGFWithBernsteinCoeff_under_troppPrimitive`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_of_troppAssumptions`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge`
- `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions`
- `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_of_troppAssumptions`
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_assumptions`
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_troppAssumptions`

TraceExp / Tropp bookkeeping helpers:

- `troppTraceState`
- `troppStateHistory`
- `troppNaturalState_zero`
- `troppNaturalState_last`
- `troppNaturalState_left`
- `troppNaturalState_right`
- `troppTraceExpFiniteFamilyIterationSkeleton_of_naturalStateConditionalSteps`
- `troppMasterTraceMGFFiniteFamily_of_naturalStateConditionalSteps`
- `traceMGFBernsteinVarianceProxyBound_of_naturalStateConditionalSteps`
- `traceMatrixExp_randomMatrixPrefixSum_last`
- `traceMatrixExp_comparisonMatrixPrefixSum_last`

Sample covariance wrappers:

- `SampleCovarianceTailTarget`
- `SampleCovarianceTailTarget.event`
- `SampleCovarianceTailTarget.rhs`
- `SampleCovarianceBoundedRowTroppAssumptions`
- `sampleCovariance_tail_optimized_under_boundedRowTroppAssumptions`
- lower-level positive-side wrappers, including
  `sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound_of_troppPrimitive`
  and `sampleCovariance_quadraticForm_tail_optimized_under_exactRowSqNorm_bound_of_troppPrimitive`
- bridge-layer exact-row centered-square wrappers and bundles, including
  `SampleCovarianceExactRowCenteredSquareTroppAssumptions`,
  `SampleCovarianceExactRowCenteredSquareTwoSidedTroppAssumptions`, and their
  `..._of_centeredSquareChain...` wrappers
- lower-level compatibility operator-norm wrappers remain available for explicit
  proof-boundary work, but the compact target/record route is the preferred
  reader-facing bounded-row surface.

Sample covariance negative-side provider-transfer adapters:

- `centeredSampleCovarianceRowRankOneFamilyNeg_expIntegrable_of_expIntegrable_neg_theta`
- `centeredSampleCovarianceRowRankOneSumNeg_traceExpIntegrable_of_traceExpIntegrable_neg_theta`
- `centeredSampleCovarianceRowRankOneFamilyNeg_cfcPrimitive_of_cfcPrimitive_neg_theta`

Hardbone proved leaves, deterministic bridges, statement targets, and thin consumers:

- `scalarBernsteinExpQuadraticInequality`
- `selfAdjointSpectrumBoundedByOperatorNorm`
- `bernsteinCFCExpressionNormalization`
- `cfcScalarInequalityToMatrixLE_bernsteinExpQuadratic`
- `bernsteinMatrixExp_le_quadratic_of_cfcLeaves`
- `bernsteinMatrixExp_le_quadratic`
- `traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider`
- `varianceProxyNormBound_of_centeredSquareChain`
- `matrixSquare_centeredRandomMatrix_expectation_expansion`
- `varianceProxyNormBound_of_centeredSquareChain_expansion`
- `matrixTrace_smul`
- `matrixTrace_le_of_matrixLE`
- `traceMatrixExp_le_trace_support_exp_lambdaMax_of_supportDomination`
- `traceMatrixExp_le_rank_exp_lambdaMax`
- `traceMatrixExp_le_supportDim_exp_lambdaMax`
- `traceMatrixExp_eq_sum_exp_eigenvalues`
- `traceMatrixExp_smul_le_card_add_trace_div_mul_exp_sub_one_of_psd_lambdaMax_le`
- `traceMatrixExp_effectiveRank_bound`
- `matrixTrace_le_card_mul_of_isPSD_lambdaMaxOrdered_le`
- `traceMatrixExp_effectiveRank_bound_of_ambientTraceCertificate`
- `matrixTrace_eq_rank_of_isStarProjection`
- `matrixExpLogDomainForSelfAdjoint`
- `isPSDMatrix_of_isStarProjection`
- `isPSDMatrix_of_posSemidef`
- `matrixLE_of_mathlib_le`
- `mathlib_le_of_matrixLE`
- `MatrixExpSupportDomination`
- `MatrixExpExcessSupportDomination`
- `matrixExpSupportDomination_identity_statement`
- `traceMatrixExp_excess_supportDim_exp_lambdaMax_statement`
- `traceMatrixExp_le_card_add_trace_support_mul_exp_sub_one_of_excessSupportDomination`
- `traceMatrixExp_excess_supportDim_exp_lambdaMax`

Hardbone matrix-exp/log normalization leaf:

- `matrixExpLogSelfAdjointNormalization`

Hardbone log/order bridge leaf:

- `matrixLog_le_of_le_matrixExp`

Hardbone conditioning bridge leaf:

- `troppConditionalStep_of_iIndepFun`

Reader-facing example routes:

- `StatementRoutes`
- `SampleCovarianceTailUsage`
- `RankOneMatrixBernsteinPipelineUsage`
- `RandomFeatureKernelUsage`
- `NTKGramUsage`
- `GradientCovarianceUsage`
- `NaturalTroppPipelineUsage`

Low-level prefix/state, reindex, negative-family, nullspace/decomposition, exact adapter, and statement-atlas APIs remain covered by source, tests, and judge files; they are not all exposed as separate examples.
## Current Caveats

- The random-family layer is vocabulary only: it adds indexed aliases, endpoint/map wrappers, and pointwise measurability lemmas, but no filtrations, adaptedness, martingales, or conditioning providers.

- RandomMatrix / Matrix Bernstein remains experimental.
- The hardbone statement atlas names CFC, log/order, Tropp/Lieb,
  conditioning, integrability, variance-proxy, and dimension/rank blockers as
  typed statement targets. The trace-exp domination-provider consumer is proved as
  `traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider`, but it only
  consumes an explicit nonnegative integrable dominator and pointwise absolute
  domination. The centered-square expectation expansion is now proved as
  `matrixSquare_centeredRandomMatrix_expectation_expansion`, reusing
  `matrixSecondMoment_centeredRandomMatrix`. The centered rank-one second-moment
  comparison is proved as `centeredRankOneSquare_le_rankOneSecondMoment`, via
  the general covariance comparison
  `matrixSecondMoment_centeredRandomMatrix_le_matrixSecondMoment` and the
  deterministic order helper `matrixLE_sub_right_of_isPSD`. The
  sample-covariance hardbone consumer
  `sampleCovarianceVarianceProxy_sharp_of_rankOneSecondMoment` now supplies the
  rank-one comparison to the abstract sharp-variance chain, and
  `sampleCovarianceVarianceProxy_sharp_of_exactRowSecondMoment` removes the
  reflexive row second-moment comparison by choosing
  `V_i = matrixSecondMoment P (rankOneRandomMatrix (X i))`. The generic
  finite-sum norm-control bridge for such deterministic sums is exposed as
  `deterministicMatrixVarianceProxyNorm_sum_le_sum`. Row-specific exact
  rank-one second-moment norm providers are now exposed as
  `deterministicMatrixVarianceProxyNorm_matrixSecondMoment_rankOneRandomMatrix_le_sq_of_sqNorm_bound`
  and
  `deterministicMatrixVarianceProxyNorm_sum_matrixSecondMoment_rankOneRandomMatrix_le_sum_sq_of_sqNorm_bound`.
  Rank-one square-integrability can now be provided from explicit
  four-coordinate product integrability by
  `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_integrable_four_products`;
  the coordinate-`MemLp 4` provider is
  `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_memLp_four`;
  the bounded-row provider from coordinate `MemLp 2` plus pointwise
  `vectorSqNorm <= R` is
  `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_sqNorm_bound_memLp_two`.
  The row-specific exact-row sample-covariance hardbone consumer
  `sampleCovarianceVarianceProxy_sharp_of_exactRowSqNorm_bound_memLp_two`
  now combines this bounded-row square-integrability route with exact-row
  deterministic norm control to produce RHS `rowSqNormVarianceProxyNormRHS R`.
  The bridge layer also exposes the generic centered-square to exact-row
  sample-covariance adapter, the named negative-family exact-row variance-proxy
  transfer, and exact-row centered-square sample-covariance wrappers/bundles for
  positive and two-sided/operator-norm routes. These are proof-infrastructure
  providers only: the compact bounded-row sample-covariance target route remains
  the reader-facing surface. The variance-proxy provider-chain consumer is
  proved as `varianceProxyNormBound_of_centeredSquareChain`; the newer
  `varianceProxyNormBound_of_centeredSquareChain_of_normMono` proves the
  finite-sum Loewner bookkeeping under an explicit norm-monotonicity premise,
  and `deterministicMatrixVarianceProxyNorm_mono_of_matrixLE` discharges the
  PSD Loewner-to-operator-norm bridge. `varianceProxyNormBound_of_centeredSquareChain_expansion` removes the explicit
  centered-square expansion argument but still requires Loewner comparison and
  deterministic norm-control assumptions at the wrapper boundary. The rank/support trace-bound bridge is now proved through
  `traceMatrixExp_le_trace_support_exp_lambdaMax_of_supportDomination`
  and the `traceMatrixExp_le_rank_exp_lambdaMax` /
  `traceMatrixExp_le_supportDim_exp_lambdaMax` consumers. Explicit
  star-projection rank certificates are now consumed by
  `traceMatrixExp_le_rank_exp_lambdaMax_of_isStarProjection`, using
  `matrixTrace_eq_rank_of_isStarProjection` and
  `isPSDMatrix_of_isStarProjection`. This discharges the PSD premise from an
  explicit `IsStarProjection support`; the domination premise is now named
  `MatrixExpSupportDomination`, but providers for that certificate and support
  construction for applications remain separate. The ambient identity provider
  target is named by `matrixExpSupportDomination_identity_statement`. The
  corrected low-rank route is named separately by
  `MatrixExpExcessSupportDomination` and
  `traceMatrixExp_excess_supportDim_exp_lambdaMax_statement`; the trace bridge
  `traceMatrixExp_le_card_add_trace_support_mul_exp_sub_one_of_excessSupportDomination`
  and thin consumer `traceMatrixExp_excess_supportDim_exp_lambdaMax` are now
  proved under an explicit excess certificate, trace support-dimension bound,
  and nonnegative excess-coefficient premise. None of these provider
  targets gives a true effective-rank certificate. The
  ambient route only supplies the
  certificate with effective-rank parameter `(n + 1 : Real)`. The Bernstein
  CFC route is now proved through
  `bernsteinMatrixExp_le_quadratic`, reusing scalar Bernstein, spectrum
  localization, Bernstein-specific CFC order transfer, and CFC expression
  normalization. The local matrix-exp/log normalization leaf is now proved by
  `matrixExpLogSelfAdjointNormalization`; it is only the pointwise CFC
  normalization consumed by the Tropp/Lieb one-step chain. The matrix log/order
  bridge is now proved through `matrixLog_le_of_le_matrixExp`, but it only
  composes explicit log-monotonicity and `matrixExp` log-domain premises. The
  conditioning chain now has the thin theorem witness
  `troppConditionalStep_of_iIndepFun`, which only forwards the explicit
  per-index conditional-expectation provider and does not prove history
  measurability or independence. The S10 wrapper
  `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge` threads
  the S9 trace-MGF consumer into the quadratic-form Laplace/tail route under an
  explicit tail-event subset assumption. The preferred optimized Matrix Bernstein
  assumption bundles are now `MatrixBernsteinPositiveSideTroppAssumptions` and
  `MatrixBernsteinNegativeSideTroppAssumptions`, which expose Tropp/Lieb
  primitives but not pointwise CFC fields. The older explicit-CFC bundles and
  `_under_primitives` wrappers remain compatibility surfaces.
- Tropp/Lieb, Golden-Thompson, trace-exp integrability, variance-proxy control,
  and full Matrix Bernstein are not claimed as complete unless a referenced
  theorem says so directly.
- Prefix/suffix/state bookkeeping now includes a natural `Fin m` trace-state
  route through the finite-family Tropp and trace-MGF provider surfaces. This
  does not discharge the analytic conditional-step, history measurability,
  independence, trace-exp integrability, log/K, CFC, or variance-proxy
  hypotheses.
- `StatementRoutes` is an examples-only route index; it groups representative example-level statement families without adding core API. Lower-level bridge and frontier checks belong in source, tests, and judge files rather than separate reader-facing examples.
- Positive-threshold operator-norm routes use `0 < t`; the zero-dimensional `t = 0` endpoint is not part of that route.
- Sample covariance wrappers remain conditional APIs, not unconditional concentration theorems. The positive-side quadratic-form route now has an exact-row variance-proxy wrapper, but two-sided and operator-norm exact-row wrappers still need a negative-side exact-row variance-proxy provider contract. The preferred sample-covariance example route now uses Tropp-only wrappers that fill pointwise Bernstein CFC fields with `bernsteinMatrixExp_le_quadratic`; explicit-CFC wrappers remain compatibility surfaces.
- Negative-side provider-transfer adapters only move explicit opposite-parameter
  assumptions onto the named negative sample-covariance family; they do not
  prove exponential integrability, trace-exponential integrability, or CFC.
- Completed hardbone wrapper task: `RM-HB-sample-covariance-cfc-free-wrapper-contract`.
- Completed hardbone proof leaf:
  `RM-HB12-matrix-exp-log-selfadjoint-normalization-leaf`.
- Completed hardbone proof leaf:
  `RM-HB12-matrix-log-le-of-le-matrix-exp-bridge-leaf`.
- Completed hardbone proof leaf:
  `RM-HB12-trace-exp-rank-support-bound-leaf`.
- Completed hardbone proof leaf:
  `RM-HB12-tropp-conditional-step-of-iindepfun-bridge-leaf`.
- Completed hardbone proof leaf:
  `CG-B17-star-projection-rank-support-consumer-contract`.
- Completed hardbone proof leaf:
  `CG-B18-star-projection-psd-bridge-contract`, proving
  `isPSDMatrix_of_isStarProjection` and removing the explicit PSD premise from
  `traceMatrixExp_le_rank_exp_lambdaMax_of_isStarProjection`.
- Completed hardbone abstraction leaf:
  `CG-B19-support-domination-certificate-contract`, naming the support
  domination premise as `MatrixExpSupportDomination` without proving any
  provider for it.
- Completed hardbone abstraction leaf:
  `CG-B20-support-domination-provider-contract`, splitting the provider
  frontier into the ambient identity-support target
  `matrixExpSupportDomination_identity_statement` and the corrected excess
  support route `MatrixExpExcessSupportDomination` /
  `traceMatrixExp_excess_supportDim_exp_lambdaMax_statement`.
- Completed hardbone proof leaf:
  `CG-B21-excess-support-trace-bridge-contract`, proving the deterministic
  excess-support trace bridge and supportDim consumer while leaving support
  provider construction separate.
- Completed hardbone proof leaf:
  `RM-VP-deterministic-matrix-expectation-mul-bridge-contract`, proving
  deterministic left/right matrix multiplication through expectation, the
  centered-square expectation expansion, and a thin variance-proxy consumer that
  no longer asks users for the expansion premise.
- Completed hardbone proof leaf:
  `RM-VP-rank-one-second-moment-contract`, proving the centered rank-one
  second-moment / Loewner comparison and a thin sample-covariance hardbone
  consumer that supplies it.
- Completed hardbone proof leaf:
  `RM-VP-sample-covariance-row-second-moment-contract`, adding the exact
  row-second-moment hardbone consumer while leaving norm control explicit.
- Completed hardbone proof leaf:
  `RM-VP-exact-row-second-moment-norm-control-contract`, adding
  `deterministicMatrixVarianceProxyNorm_sum_le_sum` as the reusable
  finite-sum subadditivity bridge for deterministic variance-proxy norms.
- Completed hardbone proof leaf:
  `RM-VP-exact-row-second-moment-operator-norm-provider-contract`, adding
  single-row and row-specific finite-family norm providers for exact rank-one
  second moments under explicit rank-one square-integrability assumptions.
- Completed hardbone proof leaf:
  `RM-VP-rank-one-square-integrability-provider-contract`, adding
  `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_integrable_four_products`
  as a direct provider from explicit four-coordinate product integrability.
- Completed hardbone proof leaf:
  `RM-VP-rank-one-square-integrability-memlp4-provider-contract`, adding
  `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_memLp_four`
  by reusing Mathlib `MemLp.mul`, `MemLp.integrable_mul`, and an explicit
  `(4,4,2)` Holder triple.
- Completed hardbone proof leaf:
  `RM-VP-rank-one-square-integrability-bounded-row-provider-contract`, adding
  `coordinate_sq_le_vectorSqNorm` and
  `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_sqNorm_bound_memLp_two`.
  The provider discharges uncentered rank-one square-integrability from
  coordinate `MemLp 2` and pointwise `vectorSqNorm <= R`; it does not prove a
  variance-proxy norm bound by itself. Centered rank-one square-integrability is
  now supplied by
  `integrableRandomMatrix_randomMatrixSquare_centeredRankOneRandomMatrixFamily_of_memLp_four`
  and
  `integrableRandomMatrix_randomMatrixSquare_centeredRankOneRandomMatrixFamily_of_sqNorm_bound_memLp_two`;
  the bounded-row crude consumer
  `MatrixVarianceProxyNormBound_centeredRankOneRandomMatrixFamily_of_sqNorm_bound_memLp_two`
  removes the explicit centered square-integrability premise from that route.
- Completed hardbone proof leaf:
  `RM-VP-centered-rank-one-square-integrability-provider-contract`, adding centered rank-one square-integrability providers and the bounded-row crude variance-proxy consumer that supplies the centered square-integrability premise.
- Completed hardbone proof leaf:
  `RM-VP-sample-covariance-exact-row-variance-proxy-wrapper-contract`, adding
  `sampleCovarianceVarianceProxy_sharp_of_exactRowSqNorm_bound_memLp_two` as a
  row-specific exact-row variance-proxy consumer under explicit hardbone
  sharp-chain, coordinate `MemLp 2`, pointwise row squared-norm, and
  nonnegative radius assumptions.
- Completed hardbone proof leaf:
  `RM-VP-sample-covariance-tail-wrapper-with-exact-row-vp-contract`, adding
  `sampleCovariance_quadraticForm_tail_optimized_under_exactRowSqNorm_bound_of_troppPrimitive` as a positive-side quadratic-form wrapper with row-specific
  exact-row variance-proxy RHS and explicit hardbone sharp-chain premise.
- Integrated bridge-layer PR stack:
  exact-row centered-square sample-covariance wrappers/bundles, negative-side
  exact-row variance-proxy transfer, and
  `deterministicMatrixVarianceProxyNorm_mono_of_matrixLE`. These are kept as
  infrastructure for future provider compression rather than the preferred
  user-facing sample-covariance route.
- Completed hardbone proof leaf:
  `RM-LIEB-S3-operator-log-monotonicity-representation-bridge-contract`, adding `isPSDMatrix_of_posSemidef`, `matrixLE_of_mathlib_le`, and `mathlib_le_of_matrixLE`; direct `CFC.log_le_log` use remains blocked for real matrices by the missing CStar route.
- Completed hardbone contract leaf:
  `RM-LIEB-S4-real-matrix-to-cstar-log-monotonicity-contract`, proving that Mathlib `CFC.log_le_log` is available on `CStarMatrix (Fin n) (Fin n) ℂ` while leaving real-matrix transport open.
- Completed hardbone contract leaf:
  `RM-LIEB-S5-real-to-cstar-transport-api-contract`, proving the basic real-to-`CStarMatrix` transport shape in a probe, including entrywise, add/sub, and self-adjoint transport; positivity/order/log transport remains provider work, not a current main-repository completion.
- Progress-first hardbone scaffold:
  `RM-LIEB-S9-conditional-step-assumption-composition-contract`, adding `traceMGFBernsteinVarianceProxyBound_of_conditioningBridge` as a finite-family trace-MGF consumer from explicit conditioning, natural-state, integrability, and variance-proxy assumptions. The hard assumptions consumed by the theorem are recorded in `docs/STATEMENTS.md`; this does not prove those assumptions.
- Progress-first hardbone scaffold:
  `RM-LIEB-S10-trace-mgf-to-tail-assumption-composition-contract`, adding
  `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge` as a
  trace-MGF-to-tail consumer under explicit tail-side assumptions. The hard
  assumptions consumed by the theorem are recorded in `docs/STATEMENTS.md`;
  this does not prove those assumptions or a full Matrix Bernstein theorem.

## Verification

Run before pushing API or docs changes:

```bash
python .github/scripts/check_text_quality.py
python scripts/judge_policy_check.py
lake build
lake build HighDimProb.Examples
lake test
lake build HighDimProbJudge
```

Last verified locally on 2026-06-20 with the commands above.

## Archive

Completed stage logs, historical blockers, and old milestone notes were reduced
to a short summary in [`archive.md`](archive.md). Keep this file current-facing
only.
