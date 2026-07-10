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

## Current PrecisionDA Application Entry Names

PrecisionDA application scaffolding is isolated under
`HighDimProb.Applications.PrecisionDA` and is intentionally application-facing.
Current stable entry points include deterministic column-sample covariance,
leave-one-out covariance, shrinkage resolvents, rank-one/Woodbury identities,
Frobenius trace-expansion wrappers, and explicit provider contracts for the H1,
H2, and Theorem 1 paper-tail statement boundaries. These entries do not prove
paper concentration bounds, deterministic equivalents, H1/H2 discharge, or
PrecisionDA Theorem 1.

## Current LoRA Covariance Example Entry Names

The examples-only LoRA covariance route now exposes the normalized empirical
and mean covariance matrices, their centered deviation, the explicit normalized
Matrix Bernstein tail, the canonical high-probability radius, and the Loewner
sandwich. The result uses the current generic centered rank-one variance proxy
`4 m R^2`; the sharper `m R^2` paper constant remains a separate variance-proxy
leaf and is not claimed by these wrappers.

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
- `matrixBernsteinTraceMGF_under_tropp`
- `troppMasterTraceMGFFiniteFamily_generatedHistory_of_bernsteinPrimitives`
- `matrixBernsteinTraceMGFWithBernsteinCoeff_generatedHistory_of_bernsteinPrimitives`
- `matrixBernsteinQuadraticFormUpperTail_generatedHistory_of_bernsteinPrimitives`
- `matrixBernsteinQuadraticFormUpperTail_generatedHistory_of_bernsteinPrimitives_tailSubsetDischarged_of_randomSelfAdjoint`
- `MatrixBernsteinConditioningTraceMGFProviderAssumptions`
- `MatrixBernsteinConditioningTraceMGFProviderAssumptions.toTailAssumptions`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFProviderAssumptions`
- `matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge_tailSubsetDischarged_of_randomSelfAdjoint`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFProviderAssumptions_tailSubsetDischarged_of_randomSelfAdjoint`
- `matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions_tailSubsetDischarged_of_randomSelfAdjoint`
- `matrixBernsteinQuadTail_trace_under_tropp`
- `matrixBernsteinQuadTail_scalar_under_tropp`
- `matrixBernsteinQuadTail_opt_under_tropp`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions`
- `matrixBernsteinQuadTail_opt_of_tropp`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge`
- `MatrixBernsteinConditioningTraceMGFTailAssumptions`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFTailAssumptions`
- `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions`
- `matrixBernsteinQuadTail_twoSided_opt_of_tropp`
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_assumptions`
- `matrixBernsteinOpNormTail_opt_of_tropp`

High-probability inversion and contract:

- `bernsteinAdditiveTailThreshold`
- `bernsteinAdditiveTailThreshold_nonneg`
- `bernsteinAdditiveTailThreshold_sq`
- `bernsteinAdditiveTailThreshold_pos`
- `bernsteinAdditiveTailThreshold_exponent_eq`
- `matrixBernsteinLogFactor`
- `matrixBernsteinLogFactor_pos`
- `matrixBernsteinHighProbabilityThreshold`
- `matrixBernsteinHighProbabilityThreshold_nonneg`
- `matrixBernsteinTwoSidedOptimizedScalarTailRHS_highProbabilityThreshold`
- `matrixBernsteinSelfAdjointHighProbabilityStatement`
- `matrixBernsteinSelfAdjointHighProbabilityStatement_of_optimizedStatement`
- `MatrixBernstein.operatorNormTail_of_primitives`
- `MatrixBernstein.operatorNormTail_of_primitives_nonneg`
- `MatrixBernstein.operatorNormUpperTail_of_primitives`
- `MatrixBernstein.optimized_of_primitives`
- `MatrixBernstein.CenteredRankOneInputs`
- `MatrixBernstein.centeredRankOne`
- `MatrixBernstein.highProbability_of_primitives`

TraceExp / Tropp bookkeeping helpers:

- `troppTraceState`
- `troppStateHistory`
- `troppNaturalState_zero`
- `troppNaturalState_last`
- `troppNaturalState_left`
- `troppNaturalState_right`
- `troppHistoryStepIndependent_of_iIndepFun_of_measurable`
- `TraceExpTroppFrozenBoundInputs`
- `TraceExpConditioning.troppStep_of_history_le`
- `TraceExpConditioning.condExpStep_of_history_le`
- `TraceExpConditioning.bernsteinInputs_of_primitives`
- `TraceExpConditioning.bernsteinStep_of_history_le`
- `troppTraceExpFiniteFamilyIterationSkeleton_of_naturalStateConditionalSteps`
- `troppMasterTraceMGFFiniteFamily_of_naturalStateConditionalSteps`
- `traceMGFBernsteinVarianceProxyBound_of_naturalStateConditionalSteps`
- `matrixExp_isStrictlyPositive_of_selfAdjoint`
- `isStrictlyPositive_matrixExpect_matrixExp_of_randomSelfAdjoint`
- `isSelfAdjointMatrix_matrixExpect_matrixExp_troppCurrentRandomStep_of_centeredSelfAdjoint`
- `isStrictlyPositive_matrixExpect_matrixExp_troppCurrentRandomStep_of_centeredSelfAdjoint`
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
- `traceExpIntegrable_randomMatrixSum_of_operatorNormBounds_finiteMeasure`
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
- `lambdaMinOrdered`
- `lambdaMinOrdered_is_least_eigenvalue_statement`
- `lambdaMinOrdered_is_least_eigenvalue`
- `lambdaMinOrdered_le_eigenvalues₀`
- `traceMatrixExp_effectiveRank_bound_of_ambientTraceCertificate`
- `matrixTrace_eq_rank_of_isStarProjection`
- `realMatrixToCStarStarAlgHom`
- `realMatrixToCStar_nonneg`
- `realMatrixToCStar_strictlyPositive`
- `realMatrixToCStar_matrixLE`
- `realMatrixToCStar_log`
- `matrixLE_of_realMatrixToCStar_matrixLE`
- `operatorLogMonotoneOnPositiveMatrices`
- `troppLogExpComparisonToK`
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
- `traceMatrixExp_mono_add_selfAdjoint`

Hardbone conditioning bridge leaf:

- `troppConditionalStep_of_iIndepFun`

Reader-facing example routes:

- `StatementRoutes`
- `SampleCovarianceTailUsage`
- `RankOneMatrixBernsteinPipelineUsage`
- `RandomFeatureKernelUsage`, `NTKGramUsage`, and
  `GradientCovarianceUsage`, whose finite-index application bundles derive
  generated-history Tropp witnesses from Bernstein primitives instead of
  storing a `troppPrimitive` field
- `NaturalTroppPipelineUsage`, including arbitrary-history TailEvent consumer
  usage that derives the combinator and history/current-step contract from
  stable APIs without assuming a product-space coordinate model

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
  bridge is now proved through `matrixLog_le_of_le_matrixExp`; the operator-log
  premise is supplied by `operatorLogMonotoneOnPositiveMatrices`, the
  trace-exponential monotonicity leaf is proved by
  `traceMatrixExp_mono_add_selfAdjoint`, and the deterministic log/order-to-`K`
  target is proved by `troppLogExpComparisonToK`. The
  conditioning chain now has the thin theorem witness
  `troppConditionalStep_of_iIndepFun`, which only forwards the explicit
  per-index conditional-expectation provider and does not prove history
  measurability or independence. The restricted-history facade
  `TraceExpConditioning.troppStep_of_history_le` now supplies that exact
  per-step conditional contract when `mHist <= MeasurableSpace.comap H _` and
  `TraceExpTroppFrozenBoundInputs` is available. For a standard Bernstein
  current step, `TraceExpConditioning.bernsteinStep_of_history_le` constructs
  that packet directly from the single-summand primitives while leaving the
  contract's `IndepFun` premise explicit. The S10 wrapper
  `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge` threads
  the S9 trace-MGF consumer into the quadratic-form Laplace/tail route under an
  explicit tail-event subset assumption, while the TailEvent provider wrappers
  discharge that subset premise under random self-adjointness. The preferred optimized Matrix Bernstein
  assumption bundles are now `MatrixBernsteinPositiveSideTroppAssumptions` and
  `MatrixBernsteinNegativeSideTroppAssumptions`, which expose Tropp/Lieb
  primitives but not pointwise CFC fields. The older explicit-CFC bundles and
  `_under_primitives` wrappers remain compatibility surfaces. The
  generated-history Bernstein wrappers exposed through
  `HighDimProb.RandomMatrix.LiebProvider` derive current-step exponential-mean
  self-adjointness and strict positivity from centered self-adjoint bounded
  summands. Tail-side measurability remains explicit; the subset premise can be
  discharged by the self-adjoint TailEvent provider wrappers.
- The zero-variance operator-norm branch is proved in
  `HighDimProb.RandomMatrix.VarianceZero`: a zero variance-proxy norm bound
  forces each self-adjoint square-integrable summand and the finite sum to
  vanish almost everywhere, so every positive operator-norm upper tail is
  zero. The optimized scalar API also records the equal-parameter two-sided
  normalization and its positive-dimension zero-threshold lower bound.
- Arbitrary-history conditioning, automatic trace-exp integrability, automatic
  variance-proxy control, and unconditional full Matrix Bernstein remain open
  unless a referenced theorem says otherwise. Golden--Thompson is closed by
  `goldenThompsonTraceExp`.
- The main layer now owns the reusable scalar inversion and the generated-history
  proof composition. `MatrixBernstein.optimized_of_primitives` proves the
  canonical optimized statement over every finite index type, and
  `MatrixBernstein.highProbability_of_primitives` closes the public `1 - delta`
  contract. The exact nondegenerate boundary remains `0 < n`,
  `0 < delta <= 1`, `0 <= sigmaSq`, `0 <= R`, and
  `0 < sigmaSq or 0 < R`. This is not an unconditional Matrix Bernstein theorem:
  the statement still exposes centeredness, self-adjointness, independence,
  integrability, norm, and variance-proxy assumptions.
- Prefix/suffix/state bookkeeping now includes a natural `Fin m` trace-state
  route through the finite-family Tropp and trace-MGF provider surfaces.
  `TraceExpConditioning.troppStep_of_history_le` separately closes the exact
  conditional-step contract under `mHist <= MeasurableSpace.comap H _` and an
  explicit frozen-bound packet. The Bernstein facade constructs that packet from
  the standard single-summand primitives. Neither theorem discharges the exact
  statement's `IndepFun`, history measurability, independence for arbitrary
  larger histories, trace-exp integrability, log/K, CFC, or variance-proxy
  hypotheses.
- `StatementRoutes` is an examples-only route index; it groups representative example-level statement families without adding core API. Lower-level bridge and frontier checks belong in source, tests, and judge files rather than separate reader-facing examples.
- Positive-threshold operator-norm routes use `0 < t`; the zero-dimensional `t = 0` endpoint is not part of that route.
- Sample covariance wrappers remain conditional APIs, not unconditional concentration theorems. The positive-side quadratic-form route now has an exact-row variance-proxy wrapper, but two-sided and operator-norm exact-row wrappers still need a negative-side exact-row variance-proxy provider contract. The preferred sample-covariance and reader-facing Matrix Bernstein example routes now use Tropp-only wrappers that fill pointwise Bernstein CFC fields with `bernsteinMatrixExp_le_quadratic`; explicit-CFC wrappers remain compatibility surfaces.
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
- Completed restricted-history closure leaf:
  `TraceExpConditioning.troppStep_of_history_le`.
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
  `RM-LIEB-S3-operator-log-monotonicity-representation-bridge-contract`, with the reusable `MatrixOrder` bridges `isPSDMatrix_of_posSemidef`, `matrixLE_of_mathlib_le`, and `mathlib_le_of_matrixLE` now living below `Spectral`.
- Completed hardbone contract leaf:
  `RM-LIEB-S4-real-matrix-to-cstar-log-monotonicity-contract`, confirming Mathlib `CFC.log_le_log` on `CStarMatrix (Fin n) (Fin n) ℂ`; this is now consumed by the main operator-log witness.
- Completed hardbone proof leaf:
  `RM-LIEB-S6-real-to-cstar-transport-and-operator-log`, proving strict positivity/order/log-back transport through `CStarBridge` and the main witness `operatorLogMonotoneOnPositiveMatrices`.
- Completed hardbone proof leaf:
  `RM-LIEB-S8-direct-log-order-to-K-wrapper`, proving the deterministic `troppLogExpComparisonToK` wrapper from the already proved operator-log and trace-exp monotonicity leaves.
- Progress-first hardbone scaffold:
  `RM-LIEB-S9-conditional-step-assumption-composition-contract`, adding `traceMGFBernsteinVarianceProxyBound_of_conditioningBridge` as a finite-family trace-MGF consumer from explicit conditioning, natural-state, integrability, and variance-proxy assumptions. The hard assumptions consumed by the theorem are recorded in `docs/STATEMENTS.md`; this does not prove those assumptions.
- Progress-first hardbone scaffold:
  `RM-LIEB-S10-trace-mgf-to-tail-assumption-composition-contract`, adding
  `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge` as a
  trace-MGF-to-tail consumer under explicit tail-side assumptions. The hard
  assumptions consumed by the theorem are recorded in `docs/STATEMENTS.md`;
  this does not prove those assumptions or a full Matrix Bernstein theorem.
- Completed public API leaf: the scalar threshold helpers and the
  `matrixBernsteinSelfAdjointHighProbabilityStatement` consumer expose the
  canonical `1 - delta` contract under the exact nondegenerate boundary above.
- Completed generated-history closure: `MatrixBernstein.optimized_of_primitives`
  and `MatrixBernstein.highProbability_of_primitives` derive the optimized and
  high-probability statements from the standard finite-dimensional Bernstein
  primitives, including zero-threshold and zero-variance branches.

## Provider-Facing Lieb/Tropp Layer

Integrated `HighDimProb.RandomMatrix.LiebProvider` as a separate provider-facing
import layer. It now exposes the ambient matrix-exp Frechet derivative
primitives, the self-adjoint carrier restriction, and the reusable scalar
matrix-exp divided-difference coefficient layer:
`matrixExpDividedDifferenceSeries`, `matrixExpDividedDifferenceSeries_pos`,
`matrixExpDividedDifferenceSeries_ne_zero`, and the preferred trace-pairing
alias `MatrixExpFDeriv.conjDiagonalSymmTraceSum`. The longer theorem names
`matrixExpFDerivSelfAdjoint_diagonal_symm_entry_mul` and
`trace_mul_matrixExpFDerivSelfAdjoint_conj_diagonal_symm_eq_sum` remain available
as precise backing APIs for low-level proof work.

The strictly-positive carrier `CFC.log` first-derivative layer remains exposed
through `cfcLogSelfAdjoint`, `CFCLog.derivSAAt`, `CFCLog.lineDeriv`,
`CFCLog.lineDeriv_one_zero`, and `CFCLog.hasDerivAt_line`. The preferred
spectral adapter aliases are
`CFCLog.diagonalDerivEntryMul`, `CFCLog.diagonalLineDerivEntryMul`, and
`CFCLog.diagonalLineDerivTraceSum`; the longer descriptive theorem names remain
available for exact proof matching. These are diagonal and trace-paired spectral
adapters at exponential self-adjoint diagonal base points; they are not the
conjugated-eigenbasis weighted resolvent-kernel adapter and do not prove the
Epstein sign theorem or Lieb concavity.

The resolvent side is split into two stable namespaces. The older short
derivative layer exposes inverse and trace-resolvent affine-line derivative
bookkeeping. The new `LogResolvent` namespace exposes finite-cutoff trace/CFC
log-resolvent identities and renormalized cutoff limits:
`LogResolvent.kernelFixedSum`, `LogResolvent.kernelCutoffSum`,
`LogResolvent.shiftedInvTraceSum`, `LogResolvent.identityCutoffSum`,
`LogResolvent.identityCutoffTraceLogSub`, `LogResolvent.weightedCutoffSum`,
`LogResolvent.weightedCutoffTraceLogSub`,
`LogResolvent.weightedTraceLogEqShiftSubCutoff`,
`LogResolvent.weightedShiftTraceLogSubScalarLog_tendsto_zero`,
`LogResolvent.weightedCutoffSubScalarLog_tendsto_negTraceLog`,
`LogResolvent.weightedShiftRemainderTendstoZero`, and
`LogResolvent.weightedCutoffRenormTendstoNegTraceLog`. It also exposes
`LogResolvent.SameEigenbasisDiagonal`, `LogResolvent.scalarSquareKernelIntegral`,
`LogResolvent.scalarSquareKernelRemainderTendstoZero`, and
`LogResolvent.sameEigenbasisCutoffRemainderTendstoZero` for the explicit
same-eigenbasis diagonal remainder. This removes that cutoff only in the
same-eigenbasis case; it is not the general two-index weighted cutoff limit.

The inverse-convexity positive-definite segment layer is upstream as
`inv_quadraticForm_affine_le_of_posDef`,
`inv_quadraticForm_iSup_affine_of_posDef`,
`convexCombo_posDef_of_posDef`,
`inv_quadraticForm_convex_combo_le_of_posDef`, and
`inv_matrixLE_convex_combo_le_of_posDef`. These are reusable quadratic-form and
`MatrixLE` segment identities; they do not prove full operator convexity of
inverse, relative-entropy joint convexity, or Lieb concavity.

The relative-entropy route now includes the scalar/diagonal Klein surface,
diagonal-matrix and same-basis `CFC.log` bookkeeping, common-eigenbasis and
overlap-weight spectral expansions, and the full finite-dimensional real matrix
Klein theorem under Hermitian strictly-positive hypotheses:
`RelativeEntropy.fullMatrixKlein_nonneg_of_isHermitian_of_strictlyPositive`,
`RelativeEntropy.kleinInequality_relativeEntropy_nonneg`, and the root alias
`kleinInequality_relativeEntropy_nonneg`. It also exposes the left/right
inverse-perspective leaf
`RelativeEntropy.leftRightRelativeEntropyIntegrand_jointConvex` through the
supporting denominator and trace-paired integrand APIs
`RelativeEntropy.leftRightDenominatorMatrix`,
`RelativeEntropy.leftRightDenominatorMatrix_posDef`,
`RelativeEntropy.leftRightDenominatorMatrix_affine`,
`RelativeEntropy.tracePairedInversePerspectiveIntegrand_jointConvex`, and
`trace_inversePerspective_jointConvex`. The new route assembly layer exposes
`RelativeEntropy.traceMatrixRelativeEntropyPlain`,
`TraceMatrixRelativeEntropyPlainJointConvexity`,
`LeftRightRelativeEntropyIntegrandDensityIntegrable`,
`TraceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation`,
`traceMatrixRelativeEntropyPlain_jointConvex_of_leftRight_density_integral_representation`,
`relativeEntropyJointConvexity_of_leftRight_density_integral_representation`,
the proved witnesses
`leftRightRelativeEntropyIntegrandDensityIntegrable` and
`traceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation`, the
unconditional facades
`traceMatrixRelativeEntropyPlain_jointConvex_of_leftRight`,
`relativeEntropyJointConvexity_of_leftRight`,
`liebTraceExpConcavity_statement_of_leftRight`,
`epsteinAffineLineConcavity_of_leftRight`, and the exact tangent consequence
`goldenThompsonTraceExp`, together with the left/right Tropp wrappers
`troppMasterTraceMGFStep_of_leftRight` and
`troppMasterTraceMGFStep_trace_bound_of_leftRight_and_providerLogOrder`. The
legacy Lieb/Jensen decomposition contract is closed for compatibility by
`troppLiebJensenChain_of_leftRight`; it is not the preferred proof-facing
route. The conditional density/integral-premise facades to
`liebTraceExpConcavity_statement` and `EpsteinAffineLineConcavity` remain
available. The bridge layer also exposes
`RelativeEntropyJointConvexity`, `GibbsKleinPremise`,
`gibbsVariationalUpperBoundPremise_of_fullMatrixKlein`, and the short facades
`RelativeEntropy.fullKlein_liebCarrierConcavity`, `RelativeEntropy.fullKlein_liebConcavity`, and
`RelativeEntropy.fullKlein_epsteinConcavity`.
This discharges the Gibbs upper-bound premise from full matrix Klein, proves
the fixed-`t` left/right integrand convexity leaf, proves the density
integrability and left/right integral representation witnesses, and closes the
left/right route to relative-entropy joint convexity, Lieb/Epstein,
Golden--Thompson, and the Tropp one-step provider wrappers. It still does not
prove the conditional-expectation step for arbitrary larger histories,
automatic variance-proxy normalization, or an unconditional full Matrix
Bernstein theorem.

Interface audit: these migrations give downstream proof agents concrete
finite-dimensional spectral, CFC-log, cutoff-resolvent, inverse-convexity
segment/`MatrixLE`, left/right inverse-perspective integrand,
density/integral route assembly, and full-matrix-Klein relative-entropy
handles inside the main repository. They
still do not prove a weighted `CFCLog.lineDeriv` / `CFCLog.derivSAAt`
resolvent-kernel adapter, arbitrary-weight plain cutoff removal without
scalar-log renormalization, or the alternative Epstein second-derivative sign
route. Golden--Thompson is closed independently by the identity tangent;
arbitrary-history conditional expectation, automatic variance-proxy control,
and unconditional full Matrix Bernstein remain open.

The layer also continues to expose derivative-level Epstein consumer reductions,
the explicit `EpsteinAffineLineConcavity` conditional route, bounded
finite-measure integrability providers, natural-history measurability from
suffix-entry measurability, the `TroppNaturalHistory.*` short aliases,
strengthened history/current-step independence from `iIndepFun` plus summand
measurability, the exact-contract wrapper
`TroppNaturalHistory.historyStepContractOfIsRandomMatrix` under explicit
random-matrix data, its use inside the provider-compressed Matrix Bernstein
bundle, identity support domination, spectral endpoint monotonicity,
thin trace-MGF-to-Laplace contracts, and the S16 natural-state tail wrapper
`matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions`.
`CFCLog.DerivOp` remains pointwise derivative bookkeeping only; it is not a
stable second-level Frechet codomain.

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

Last verified locally on 2026-07-10 with the commands above.

## Archive

Completed stage logs, historical blockers, and old milestone notes were reduced
to a short summary in [`archive.md`](archive.md). Keep this file current-facing
only.
