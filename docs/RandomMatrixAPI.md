# RandomMatrix Matrix Bernstein API

This index records the public RandomMatrix API used by the Matrix Bernstein
mainline. It is documentation only; theorem status is not upgraded here.

## Contributor Module Guide

- Put core objects and pointwise algebra in the object layer:
  `Basic`, `Expectation`, `SelfAdjoint`, `MatrixOrder`, `OperatorNorm`,
  `Sums`, `VarianceProxy`, `Spectral`, `TraceExp`, `Laplace`, and
  `ConcentrationStatements`.
- Use `Assumptions.lean` for theorem-interface vocabulary: named predicates
  and thin adapters that convert existing objects into hypotheses consumed by
  Matrix Bernstein examples. Despite the name, it is not a dumping ground for
  arbitrary facts.
- Prefer named family adapters over inline families in public theorem
  statements and examples. For rank-one covariance-style code, use
  `rankOneRandomMatrixFamily`, `centeredRandomMatrixFamily`, and
  `centeredRankOneRandomMatrixFamily`.
- Domain-specific examples may keep readable names such as
  `rankOneCovarianceContribution`, but those names should be thin aliases or
  wrappers over the public RandomMatrix API rather than separate reproofs.
- When an example needs an indexed random-vector family, name that family
  first, then feed it to the shared rank-one adapters. Existing examples use
  names such as `randomGradientVectorFamily`,
  `randomJacobianFeatureVectorFamily`, and `randomFeatureVectorFamily` for this
  purpose.

## Current Public Status

- Proved MB-S9 theorem:
  `matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives`.
- This theorem is conditional on explicit typed primitives:
  `troppMasterTraceMGFFiniteFamily_statement` and
  `bernsteinMatrixExp_le_quadratic_statement`.
- Added typed log/order-to-`K` bridge primitive:
  `troppLogExpComparisonToK_statement`, plus the thin one-step wrapper
  `troppMasterTraceMGFStep_trace_bound_of_logExpComparisonToK`.
- Added typed conditional/history one-step Tropp primitive:
  `troppMasterTraceMGFConditionalStep_statement`.
- Proved conditional-step integration and finite-chain skeleton theorems:
  `troppMasterTraceMGFConditionalStep_expect_bound` and
  `troppTraceExpFiniteFamilyIterationSkeleton_of_conditionalSteps`.
- Proved narrow `Fin m` finite-family provider:
  `troppMasterTraceMGFFiniteFamily_of_conditionalSteps`, under explicit
  named scaled-family equality `Z = scaledRandomMatrixFamily theta X`,
  history, state-identification, conditional-step, and integrability
  assumptions.
- Added thin trace-MGF provider wrapper:
  `traceMGFBernsteinVarianceProxyBound_of_troppConditionalSteps`, deriving the
  finite-family Tropp primitive from the shared conditional-step finite-chain
  core and then applying the existing finite-family trace-MGF wrapper. Its
  public signature intentionally mirrors the ordinary finite-family wrapper.
- S7 downstream-wrapper audit added no Matrix Bernstein conditional-step
  wrapper: replacing the finite-family primitive with positive/negative
  conditional-step state packages would make public call-sites larger.
- Added finite-sum/state bookkeeping in `Sums.lean`:
  `comparisonMatrixPrefixSum`, `comparisonMatrixSuffixSum`,
  `randomMatrixPrefixSum`, `randomMatrixSuffixSum`, endpoint and successor
  lemmas, and `randomMatrixSum_eq_prefixSum_last`. This is a definition-level
  prefix/suffix API with theorem-level wrappers for endpoint, step, and
  full-sum identities. It prepares the natural-state construction leaf only;
  it does not prove Lieb, Bernstein CFC, Golden-Thompson, Matrix Bernstein, or
  an arbitrary finite-index Tropp provider.
- The arbitrary-index finite-family Tropp/Lieb proof, natural history/state
  constructors, independence conditioning, integrability propagation,
  Bernstein CFC primitive, Golden-Thompson, and the full Matrix Bernstein tail
  theorem remain outside the current API.
- Proved real-to-lintegral bridge:
  `traceMGFBernsteinVarianceProxyBoundLIntegral_of_traceMGFBernsteinVarianceProxyBound`.
- Proved explicit-theta quadratic-form upper-tail wrapper under primitives:
  `matrixBernsteinQuadraticFormUpperTailWithBernsteinCoeff_under_primitives`.
- Its RHS remains trace-exponential:
  `exp(-theta*t) * tr exp(SMul.smul (bernsteinMGFCoeff theta R) (matrixVarianceProxy P A))`.
- Proved generic deterministic trace-exp dimension bound:
  `traceMatrixExp_smul_le_card_exp_of_lambdaMaxOrdered_le`.
- Proved variance-proxy specialized trace-exp dimension bound:
  `traceMatrixExp_bernsteinMGFCoeff_matrixVarianceProxy_le_card_exp`.
- Proved explicit-theta quadratic-form scalar-RHS wrapper under primitives:
  `matrixBernsteinQuadraticFormUpperTailScalarRHSWithBernsteinCoeff_under_primitives`.
- Its RHS is intentionally unnormalized:
  `ENNReal.ofReal (Real.exp (-(theta * t)) * ((n + 1 : Real) * Real.exp (bernsteinMGFCoeff theta R * sigmaSq)))`.
- Proved normalized explicit-theta quadratic-form scalar-RHS wrapper under
  primitives:
  `matrixBernsteinQuadraticFormUpperTailScalarExpRHSWithBernsteinCoeff_under_primitives`.
- Its RHS is:
  `ENNReal.ofReal ((n + 1 : Real) * Real.exp (-(theta * t) + bernsteinMGFCoeff theta R * sigmaSq))`.
- Proved theta-choice scalar helpers:
  `bernsteinThetaChoice`, `bernsteinThetaChoice_range`, and
  `bernsteinThetaChoice_exponent_eq`.
- Proved theta-optimized quadratic-form scalar-RHS wrapper under primitives:
  `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`.
- Its RHS is:
  `ENNReal.ofReal ((n + 1 : Real) * Real.exp (-(t ^ 2 / (2 * sigmaSq + (2 / 3) * R * t))))`.
- Proved self-adjoint operator-norm wrapper for nonempty square dimensions
  under explicit primitives:
  `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_nonempty_under_primitives`.
  This reuses the bridge-explicit operator-norm wrapper and discharges only the
  spectral bridge via
  `selfAdjointOperatorNormTailViaQuadraticFormStatement_nonempty`; Tropp, CFC,
  variance-proxy, independence, and integrability assumptions remain explicit
  for both signs.
- Proved the supported arbitrary-dimensional self-adjoint operator-norm
  spectral bridge on the positive-threshold route:
  `selfAdjointOperatorNormTailEvent_empty_of_zero_dim_of_pos` and
  `selfAdjointOperatorNormTailViaQuadraticFormStatement_of_pos`. The current
  arbitrary-dimensional API uses `0 < t`; it does not package the
  zero-dimensional `t = 0` endpoint.
- Proved arbitrary-dimensional self-adjoint operator-norm Matrix Bernstein
  wrapper under explicit primitives and `0 < t`:
  `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_pos_under_primitives`.
  This removes the explicit spectral-bridge assumption only on the corrected
  positive-threshold route; Tropp, CFC, variance-proxy, independence, and
  integrability assumptions remain explicit for both signs.
- Added packaged Matrix Bernstein assumption-bundle entry points:
  `MatrixBernsteinPositiveSideAssumptions`,
  `MatrixBernsteinNegativeSideAssumptions`,
  `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions`,
  and
  `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_assumptions`.
  These remove repeated public theorem arguments; they do not prove
  positive-to-negative transfer, Tropp/Lieb, or Bernstein CFC.
- Retained sample-covariance quadratic-form tail wrapper under explicit
  variance-proxy and Matrix Bernstein primitive assumptions:
  `sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy`.
  It rewrites the centered sample covariance through the named normalized
  centered row rank-one sum and applies the optimized quadratic-form wrapper at
  threshold `(m : Real) * t` with the core helper
  `sampleCovarianceCenteredRankOneRadius R`.
- Proved crude sample-covariance variance-proxy control from a bounded-row
  squared-norm assumption:
  `sampleCovarianceCenteredRankOneVarianceProxyBound`,
  `sampleCovarianceCenteredRankOneVarianceProxyBoundOfRows`,
  `MatrixVarianceProxyNormBound_centeredSampleCovarianceRowRankOneFamily_of_rowSqNorm_bound`.
- Proved bounded-row sample-covariance tail wrappers that use the crude variance
  proxy internally:
  `sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound` and
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound`.
- Proved adapter-based bounded-row sample-covariance operator-norm wrapper:
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_adapters`.
  This derives negative centeredness, independence, entrywise integrability,
  and pointwise operator-norm bounds from named adapters while leaving negative
  square/exponential/trace integrability, Tropp, and CFC assumptions explicit.
- Core sample-covariance tail helpers:
  `sampleCovarianceCenteredRankOneRadius`,
  `sampleCovarianceCenteredRankOneVarianceProxyBoundOfRows`,
  `sampleCovarianceTailTheta`, `sampleCovarianceTailThetaOfRows`, and
  `sampleCovarianceQuadraticFormTailRHS`. The explicit `OfRows` aliases make
  the row count visible at call sites; the RHS helper uses the actual column
  dimension parameter, so nonempty examples pass `n + 1` explicitly.
- Example-layer sample-covariance tail usage wrapper:
  `sampleCovariance_quadraticForm_tail_usage`, with assumptions bundled in
  `SampleCovarianceTailAssumptions` and RHS supplied by the core
  `sampleCovarianceQuadraticFormTailRHS`.
  This wrapper calls the bounded-row theorem and no longer asks users for the
  positive-side `MatrixVarianceProxyNormBound`; independence,
  square/exponential/trace integrability, Tropp, and CFC assumptions remain
  explicit.
- Proved sample-covariance self-adjoint operator-norm wrapper for nonempty
  covariance dimensions under explicit variance-proxy and Matrix Bernstein
  primitive assumptions:
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_nonempty_under_explicit_variance_proxy`.
  It reuses the sample-covariance operator-norm event bridge and the RM-ON-S4
  nonempty operator-norm Matrix Bernstein wrapper, so the theorem has no
  explicit spectral-bridge assumption.
- Proved sample-covariance self-adjoint operator-norm wrapper for arbitrary
  covariance dimensions under the explicit positive-threshold assumption and
  the existing explicit variance-proxy and Matrix Bernstein primitive
  assumptions:
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_explicit_variance_proxy`.
  It reuses the generalized sample-covariance event bridge and the arbitrary
  positive-threshold self-adjoint operator-norm Matrix Bernstein wrapper.
- The current operator-norm API covers positive-threshold wrappers under
  explicit primitives. It still does not include an arbitrary-dimensional
  lambda-max Matrix Bernstein tail, the zero-dimensional `t = 0` endpoint, or a
  full CFC/Tropp-free Matrix Bernstein theorem.
- Proved rank-one operator-norm prerequisite bridge:
  `rankOneOperatorNorm_le_vectorSqNorm`,
  `BoundedOperatorNorm_rankOneRandomMatrix_of_sqNorm_bound`, and
  `PointwiseOperatorNormBound_rankOneRandomMatrix_of_sqNorm_bound`.
- Proved centered rank-one operator-norm adapters:
  `BoundedOperatorNorm_centeredRankOneRandomMatrix_of_sqNorm_bound` and
  `PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound`.
  These reuse expectation contraction and the S2 centered operator-norm
  wrappers.
- Proved centered operator-norm prerequisite bridge under an explicit expectation
  operator-norm bound:
  `deterministicOperatorNorm_sub_le_add`,
  `BoundedOperatorNorm_centered_of_bound_expect_bound`,
  `PointwiseOperatorNormBound_centered_of_bound_expect_bound`, and
  `PointwiseOperatorNormBound_centered_of_bound_expect_bound_same`.
- Proved expectation contraction and centered pointwise operator-norm wrappers:
  `matrixExpect_eq_integral_l2Operator`, `matrixExpect_eq_integral`,
  `deterministicOperatorNorm_matrixExpect_le_of_boundedOperatorNorm`,
  `expectationOperatorNormBound_of_pointwiseOperatorNormBound`,
  `BoundedOperatorNorm_centered_of_boundedOperatorNorm`,
  `PointwiseOperatorNormBound_centered_of_pointwiseOperatorNormBound`, and
  `PointwiseOperatorNormBound_centered_of_pointwiseOperatorNormBound_same`.
- Proved vector-to-rank-one matrix measurability/integrability bridge:
  `rankOneRandomMatrix`, `rankOneRandomMatrixFamily`,
  `isRandomMatrix_rankOneRandomMatrix`,
  `integrableRandomMatrix_rankOneRandomMatrix_of_integrable_products`, and
  `integrableRandomMatrix_rankOneRandomMatrix_of_memLp_two`.
- Proved centered rank-one random matrix structural adapters:
  `centeredRankOneRandomMatrix`, `centeredRankOneRandomMatrixFamily`,
  `isSelfAdjointMatrix_rankOneMatrix`,
  `randomSelfAdjointMatrix_rankOneRandomMatrix`,
  `isPSDMatrix_rankOneMatrix`, `randomPSDMatrix_rankOneRandomMatrix`,
  `centeredRankOneRandomMatrix_isRandomMatrix`,
  `centeredRankOneRandomMatrix_integrable_of_memLp_two`, and
  `centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two`.
- Proved centered structural bridge:
  `isRandomMatrix_centeredRandomMatrix`,
  `integrableRandomMatrix_centeredRandomMatrix`,
  `isSelfAdjointMatrix_matrixExpect_of_randomSelfAdjoint`,
  `randomSelfAdjointMatrix_centeredRandomMatrix`,
  `matrixExpect_centeredRandomMatrix`,
  `selfAdjointRandomMatrixFamily_centeredRandomMatrixFamily`, and
  `centeredSelfAdjointRandomMatrixFamily_centeredRandomMatrixFamily`.
- Proved PSD nullspace converse bridge:
  `posSemidef_of_isPSDMatrix`,
  `matrixQuadraticForm_eq_zero_iff_mulVec_eq_zero_of_posSemidef`,
  `matrix_mulVec_eq_zero_of_posSemidef_quadraticForm_eq_zero`,
  `matrixQuadraticForm_eq_zero_iff_mulVec_eq_zero_of_isPSDMatrix`, and
  `matrix_mulVec_eq_zero_of_isPSDMatrix_quadraticForm_eq_zero`.
- Deterministic rank-one kernel/nullspace API:
  `rankOneMatrixSum`,
  `rankOneMatrix_quadraticForm_eq_inner_sq`,
  `rankOneMatrix_mulVec_eq_zero_iff_inner_eq_zero`, and
  `rankOneSum_mulVec_eq_zero_of_forall_inner_eq_zero`.
  This reuses the existing `rankOneMatrix`, `matrixQuadraticForm`,
  `Matrix.mulVec`, finite sums, and PSD-nullspace bridge; it does not introduce
  a parallel rank-one or nullspace theory.
- The kernel/nullspace examples now route rank-one invisible-direction proofs
  through the core API instead of local finite-sum algebra.
- Proved sample covariance row rank-one sum objects and bridge:
  `sampleCovarianceRowRankOneFamily`, `sampleCovarianceRowRankOneSum`,
  `normalizedSampleCovarianceRowRankOneSum`, and
  `sampleCovariance_eq_normalized_rowRankOne_sum`.
- Proved sample covariance centered row rank-one sum objects and centering
  bridge: `centeredSampleCovarianceRowRankOneFamily`,
  `centeredSampleCovarianceRowRankOneSum`,
  `normalizedCenteredSampleCovarianceRowRankOneSum`, and
  `sampleCovariance_deviation_eq_normalized_centered_rowRankOne_sum`.
- Proved sample-covariance quadratic-form tail wrapper under explicit
  variance-proxy and Matrix Bernstein primitive assumptions:
  `sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy`.
- Proved sample-covariance operator-norm event bridge, retained conditional
  operator-norm tail wrapper, nonempty operator-norm tail wrapper, and
  arbitrary positive-threshold operator-norm tail wrapper under explicit
  variance-proxy and both-sign primitive assumptions:
  `sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum`
  and
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_under_explicit_variance_proxy`,
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_nonempty_under_explicit_variance_proxy`,
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_explicit_variance_proxy`.
- The example surface now includes sample covariance, negative-family,
  bounded-row, attention-feature Gram, empirical Fisher, and LoRA
  adapter-subspace usage wrappers:
  `sampleCovariance_quadraticForm_tail_usage`,
  `sampleCovariance_operatorNorm_tail_usage`,
  `negativeFamily_twoSided_quadraticForm_tail_usage`,
  `negativeFamily_selfAdjoint_operatorNorm_tail_usage`,
  `boundedRowSampleCovariance_operatorNorm_tail_usage`,
  `attentionFeatureGram_quadraticForm_tail_usage`,
  `attentionFeatureGram_operatorNorm_tail_usage`,
  `empiricalFisher_operatorNorm_tail_usage`, and
  `loraAdapterSubspaceCovariance_operatorNorm_tail_usage`.
  The ML-facing wrappers keep feature, gradient, and adapter assumptions
  visible as domain documentation; those fields do not derive Matrix
  Bernstein primitive bundles. For wrappers that expose `positiveSide` and
  `negativeSide`, those bundles are the actual tail-proof obligations. The
  bounded-row sample-covariance wrappers route through the core bounded-row
  theorems; the operator-norm example uses the adapter-based theorem so
  negative centeredness, independence, entrywise integrability, pointwise
  operator-norm bounds, and square-integrability are derived from named
  negative-family adapters. The sign-normalization API can rewrite negative
  exp/trace/CFC obligations to original-family negative-theta obligations when
  those are supplied, but current wrappers still keep negative exponential/trace
  integrability, Tropp, and CFC assumptions explicit.
- The current surface still does not include sharp moment-optimal variance
  control, arbitrary-dimensional lambda-max Matrix Bernstein tails, the
  zero-dimensional `t = 0` operator-norm endpoint, full Matrix Bernstein,
  the arbitrary finite-index Tropp/Lieb provider, Bernstein CFC,
  Golden-Thompson, or unconditional sample-covariance concentration. The
  narrow `Fin m` Tropp provider from explicit conditional-step/state data is
  documented in the trace-exp section below.
- RM-ON-S8 documentation synchronization records the S6 example update and S7
  test/judge update without changing the API surface.
- Next safe task: `RM-negative-tropp-primitive-boundary-audit`.
- Separate local leaf: `RM-BR-natural-history-state-construction`.

## `HighDimProb/RandomMatrix/Basic.lean`

- `RandomMatrix`: abbrev, finite-dimensional real random matrix.
- `matrixEntry`: def, entry random variable.
- `IsRandomMatrix`: abbrev, entrywise measurability predicate.
- `scaledRandomMatrix`: def, named pointwise scalar multiple of a random
  matrix.
- `scaledRandomMatrixFamily`: def, named family-level scalar-multiple adapter.
- `negRandomMatrix`: def, named pointwise negation adapter for a random matrix.
- `scaledRandomMatrix_apply`: theorem.
- `scaledRandomMatrixFamily_apply`: theorem.
- `scaledRandomMatrixFamily_apply_apply`: theorem.
- `negRandomMatrix_apply`: theorem.
- `isRandomMatrix_scaledRandomMatrix`: theorem, scalar multiplication
  preserves entrywise random-matrix measurability.
- `isRandomMatrix_scaledRandomMatrixFamily`: theorem, family-level version.
- `isRandomMatrix_negRandomMatrix`: theorem, pointwise negation preserves
  entrywise random-matrix measurability.
- `rankOneMatrix`: def, deterministic rank-one self outer-product matrix.
- `rankOneRandomMatrix`: def, vector-to-rank-one random matrix with entries
  `X_i * X_j`.
- `rankOneRandomMatrixFamily`: def, named indexed family of rank-one random
  matrices.
- `rankOneMatrix_apply`: theorem.
- `rankOneRandomMatrix_apply`: theorem.
- `rankOneRandomMatrixFamily_apply`: theorem.
- `matrixEntry_rankOneRandomMatrix`: theorem.
- `isRandomMatrix_rankOneRandomMatrix`: theorem, entrywise measurability from
  `IsRandomVector`.
- `measurable_randomMatrix_of_isRandomMatrix`: theorem.
- `isRandomMatrix_of_sub_measurable_entries`: theorem, entrywise
  measurability in a smaller measurable space gives ambient random-matrix
  measurability when the smaller measurable space is below the ambient one.

## `HighDimProb/RandomMatrix/Expectation.lean`

- `matrixExpect`: def, entrywise matrix expectation.
- `IntegrableRandomMatrix`: def, entrywise integrability predicate.
- `matrixExpect_eq_integral_l2Operator`: theorem, Bochner-integrable matrix
  random variables have entrywise `matrixExpect` equal to the Bochner integral.
- `matrixExpect_eq_integral`: theorem, entrywise-integrable random matrices
  have entrywise `matrixExpect` equal to the Bochner integral.
- `centeredRandomMatrix`: def.
- `centeredRankOneRandomMatrix`: def, named centered rank-one random matrix
  adapter.
- `centeredRankOneRandomMatrixFamily`: def, named indexed centered rank-one
  random matrix adapter.
- `isRandomMatrix_centeredRandomMatrix`: theorem, centering preserves entrywise
  measurability.
- `integrableRandomMatrix_centeredRandomMatrix`: theorem, centering preserves
  entrywise integrability over finite measures.
- `centeredRandomMatrixFamily`: def, indexed family obtained by centering each
  random matrix in a family.
- `centeredRandomMatrixFamily_apply`: theorem.
- `centeredRankOneRandomMatrix_apply`: theorem.
- `centeredRankOneRandomMatrixFamily_apply`: theorem.
- `matrixExpect_centeredRandomMatrix`: theorem, an integrable centered random
  matrix has zero entrywise expectation under a probability measure.
- `integrableRandomMatrix_rankOneRandomMatrix_of_integrable_products`: theorem,
  rank-one entrywise integrability from explicit product integrability.
- `integrableRandomMatrix_rankOneRandomMatrix_of_memLp_two`: theorem, rank-one
  entrywise integrability from coordinate `MemLp ... 2` assumptions.

## `HighDimProb/RandomMatrix/SelfAdjoint.lean`

- `IsSymmetricMatrix`: abbrev.
- `IsSelfAdjointMatrix`: abbrev.
- `RandomSymmetricMatrix`: def.
- `RandomSelfAdjointMatrix`: def.
- `isSelfAdjointMatrix_rankOneMatrix`: theorem, rank-one self outer products
  are self-adjoint.
- `randomSelfAdjointMatrix_rankOneRandomMatrix`: theorem, pointwise
  self-adjointness of `rankOneRandomMatrix`.
- `isSelfAdjointMatrix_smul`: theorem.
- `isSelfAdjointMatrix_neg`: theorem.
- `randomSelfAdjointMatrix_smul`: theorem.
- `randomSelfAdjointMatrix_scaledRandomMatrix`: theorem.
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
- `lambdaMaxOrdered_le_deterministicOperatorNorm`: theorem.
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
- `selfAdjointOperatorNormTailViaQuadraticFormStatement_nonempty`: theorem
  proving the typed bridge for nonempty square dimensions.
- `lambdaMax_le_iff_quadraticForm_le_statement`: typed statement.
- `operatorNorm_eq_max_abs_lambda_statement`: typed statement.
- `posSemidef_of_isPSDMatrix`: theorem, converts HighDimProb explicit PSD to Mathlib `Matrix.PosSemidef`.
- `matrixQuadraticForm_eq_zero_iff_mulVec_eq_zero_of_posSemidef`: theorem, PSD quadratic-form zero iff kernel membership.
- `matrix_mulVec_eq_zero_of_posSemidef_quadraticForm_eq_zero`: theorem, one-way Mathlib-PSD nullspace converse.
- `matrixQuadraticForm_eq_zero_iff_mulVec_eq_zero_of_isPSDMatrix`: theorem, explicit-PSD iff variant.
- `matrix_mulVec_eq_zero_of_isPSDMatrix_quadraticForm_eq_zero`: theorem, one-way explicit-PSD nullspace converse.
- `rankOneMatrixSum`: def, finite sum of deterministic rank-one
  outer-product matrices.
- `rankOneMatrix_quadraticForm_eq_inner_sq`: theorem, rank-one quadratic
  form as a squared inner product.
- `rankOneMatrix_mulVec_eq_zero_iff_inner_eq_zero`: theorem, rank-one kernel
  membership iff orthogonality to the generating vector.
- `rankOneSum_mulVec_eq_zero_of_forall_inner_eq_zero`: theorem, finite rank-one
  sum kernel membership from per-summand orthogonality.

## `HighDimProb/RandomMatrix/OperatorNorm.lean`

- `operatorNorm`: def, random-matrix operator norm as a real random variable.
- `deterministicOperatorNorm`: def, deterministic matrix operator norm using the
  same scoped L2 convention.
- `deterministicOperatorNorm_apply`: theorem, definitional bridge.
- `deterministicOperatorNorm_sub_le_add`: theorem, deterministic triangle bound.
- `rankOneOperatorNorm_le_vectorSqNorm`: theorem, `||v v?||op <= ||v||?^2.
- `matVecSqNorm`: def.
- `randomMatVecSqNorm`: def.
- `OperatorNormBoundSq`: def.
- `operatorNorm_le_of_operatorNormBoundSq`: theorem.
- `operatorNormBoundSq_of_operatorNorm_le`: theorem.
- `isRealRandomVariable_operatorNorm`: theorem.

## `HighDimProb/RandomMatrix/Assumptions.lean`

- `BoundedOperatorNorm`: def, pointwise operator-norm bound for one random
  matrix.
- `deterministicOperatorNorm_matrixExpect_le_of_boundedOperatorNorm`: theorem,
  expectation operator-norm contraction from entrywise integrability and a
  pointwise operator-norm bound.
- `BoundedOperatorNorm_rankOneRandomMatrix_of_sqNorm_bound`: theorem, rank-one
  pointwise wrapper from vector squared-norm bounds.
- `BoundedOperatorNorm_centered_of_bound_expect_bound`: theorem, centered
  wrapper from a pointwise bound plus an explicit expectation operator-norm
  bound.
- `BoundedOperatorNorm_centered_of_boundedOperatorNorm`: theorem, centered
  single-matrix wrapper with bound `2 * R`.
- `BoundedOperatorNorm_centeredRankOneRandomMatrix_of_sqNorm_bound`: theorem,
  centered rank-one single-matrix wrapper with bound `2 * R` from vector
  squared-norm, random-vector, and coordinate `MemLp ... 2` assumptions.
- `PointwiseOperatorNormBound`: def, indexed pointwise operator-norm bound.
- `expectationOperatorNormBound_of_pointwiseOperatorNormBound`: theorem,
  family expectation operator-norm contraction.
- `PointwiseOperatorNormBound_rankOneRandomMatrix_of_sqNorm_bound`: theorem,
  indexed rank-one wrapper from vector squared-norm bounds.
- `PointwiseOperatorNormBound_centered_of_bound_expect_bound`: theorem, indexed
  centered wrapper with explicit expectation bound.
- `PointwiseOperatorNormBound_centered_of_bound_expect_bound_same`: theorem,
  same-radius centered wrapper.
- `PointwiseOperatorNormBound_centered_of_pointwiseOperatorNormBound`: theorem,
  centered family wrapper with bound `2 * R`.
- `PointwiseOperatorNormBound_centered_of_pointwiseOperatorNormBound_same`:
  theorem, same wrapper in the `R + R` style.
- `PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound`:
  theorem, centered rank-one family wrapper with bound `2 * R` from pointwise
  squared-vector-norm, random-vector, and coordinate `MemLp ... 2`
  assumptions.
- `isSelfAdjointMatrix_matrixExpect_of_randomSelfAdjoint`: theorem, the
  entrywise expectation of a pointwise self-adjoint random matrix is
  self-adjoint.
- `randomSelfAdjointMatrix_centeredRandomMatrix`: theorem, centering preserves
  pointwise self-adjointness.
- `selfAdjointRandomMatrixFamily_centeredRandomMatrixFamily`: theorem,
  centering preserves the self-adjoint family predicate.
- `centeredSelfAdjointRandomMatrixFamily_centeredRandomMatrixFamily`: theorem,
  centering an integrable self-adjoint family gives a centered self-adjoint
  family under a probability measure.
- `centeredRankOneRandomMatrix_isRandomMatrix`: theorem, centered rank-one
  measurability from `IsRandomVector`.
- `centeredRankOneRandomMatrix_integrable_of_memLp_two`: theorem, centered
  rank-one entrywise integrability from coordinate `MemLp ... 2`.
- `centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two`: theorem,
  centered rank-one families are centered self-adjoint under random-vector
  measurability and coordinate `MemLp ... 2` assumptions.
- `UniformOperatorNormBound`: abbrev.
- `AeOperatorNormBound`: def.

## `HighDimProb/RandomMatrix/Algebra.lean`

- `rowDot`: def, dot product of one random-matrix row with a deterministic
  vector.
- `rowDot_sq_nonneg`: theorem.
- `sum_rowDot_sq_nonneg`: theorem.
- `sampleCovarianceRowRankOneFamily`: abbrev, named row rank-one family behind
  `sampleCovariance`.
- `sampleCovarianceRowRankOneFamily_apply`: theorem.
- `centeredSampleCovarianceRowRankOneFamily`: abbrev, named centered row
  rank-one family behind centered sample covariance deviations.
- `centeredSampleCovarianceRowRankOneFamily_apply`: theorem.
- `sampleCovarianceRowRankOneSum`: def, unnormalized sum of row rank-one
  random matrices.
- `normalizedSampleCovarianceRowRankOneSum`: def, row rank-one sum with the
  same `(1 / m)` scaling convention as `sampleCovariance`.
- `centeredSampleCovarianceRowRankOneSum`: def, unnormalized sum of centered
  row rank-one random matrices.
- `normalizedCenteredSampleCovarianceRowRankOneSum`: def, centered row
  rank-one sum with the same `(1 / m)` scaling convention as
  `sampleCovariance`.
- `sampleCovariance_eq_normalized_rowRankOne_sum`: theorem, rewrites
  `sampleCovariance A` as `normalizedSampleCovarianceRowRankOneSum A`.
- `sampleCovariance_deviation_eq_normalized_centered_rowRankOne_sum`: theorem,
  rewrites `centeredRandomMatrix P (sampleCovariance A)` as
  `normalizedCenteredSampleCovarianceRowRankOneSum (P := P) A` under explicit
  row rank-one integrability.
- `quadraticForm_sampleCovariance_eq_sum_sq`: theorem.
- `quadraticForm_sampleCovariance_eq_scaled_sum_rowDot_sq`: theorem.
- `quadraticForm_sampleCovariance_nonneg`: theorem.

## `HighDimProb/RandomMatrix/MatrixOrder.lean`

- `matrixQuadraticForm`: def.
- `IsPSDMatrix`: def.
- `RandomPSDMatrix`: def.
- `isPSDMatrix_rankOneMatrix`: theorem, rank-one self outer products are PSD in
  the explicit quadratic-form order.
- `randomPSDMatrix_rankOneRandomMatrix`: theorem, pointwise PSD wrapper for
  `rankOneRandomMatrix`.
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
- `troppLogExpComparisonToK_statement`: typed deterministic bridge from
  `M <= exp(K)` to
  `traceMatrixExp (H + CFC.log M) <= traceMatrixExp (H + K)`, with explicit
  self-adjointness and strict-positivity assumptions. This remains a typed
  primitive; it does not prove matrix-log operator monotonicity or trace-exp
  monotonicity.
- `troppMasterTraceMGFStep_trace_bound_of_logExpComparisonToK`: theorem
  applying `troppMasterTraceMGFStep_statement` and
  `troppLogExpComparisonToK_statement` to obtain the one-step trace bound with
  deterministic `K`.
- `troppMasterTraceMGFConditionalStep_statement`: typed conditional/history
  one-step primitive for the finite-family iteration route. It exposes the
  history sigma-algebra, random-history measurability, integrability,
  self-adjointness, independence, and deterministic `K` comparison assumptions
  explicitly, and concludes only the one-step conditional trace-exponential
  bound.
- `troppMasterTraceMGFConditionalStep_apply_of_histEntryMeasurable`: theorem
  applying the conditional-step primitive while deriving ambient measurability
  of `H` from history-entry measurability and `mHist <= mOmega`.
- `troppMasterTraceMGFConditionalStep_expect_bound`: theorem integrating one
  typed conditional/history step to an unconditional expected
  trace-exponential comparison under explicit history sigma-finiteness and
  RHS integrability.
- `troppTraceExpFiniteFamilyIterationSkeleton_of_conditionalSteps`: theorem
  proving the finite induction chain once each adjacent state has been
  identified with a conditional/history Tropp step. It uses `randomMatrixSum`
  for the left endpoint and `Finset.univ.sum` for the deterministic `K`
  endpoint, while leaving history construction, state-identification algebra,
  and independence conditioning explicit.
- `troppMasterTraceMGFFiniteFamily_of_conditionalSteps`: theorem deriving the
  existing `troppMasterTraceMGFFiniteFamily_statement` for `Fin m` from the S4
  finite-chain skeleton, under explicit conditional-step primitives,
  `Z = scaledRandomMatrixFamily theta X`, state endpoint/adjacent equalities,
  history measurability, sigma-finiteness, and step-level integrability
  assumptions.
  It does not derive those histories or state equalities from `iIndepFun`.
- `troppMasterTraceMGFFiniteFamily_statement`: typed finite-family
  Tropp/Lieb iteration primitive consuming per-summand matrix-MGF `MatrixLE`
  comparisons, independence, trace-exp integrability, comparison
  self-adjointness, and bounded-Bernstein RHS normalization to produce
  `TraceMGFBernsteinVarianceProxyBound` for `randomMatrixSum`.
- `troppMasterTraceMGFFiniteFamily_statement_of_reindexedFin`: theorem
  transporting a provider for the canonical `Fin (Fintype.card I)` reindex to
  the original arbitrary finite index type. It is a reindexing bridge only and
  does not prove the Tropp/Lieb primitive or construct conditional-step state
  data.
- `bernsteinMGFCoeff`: def, canonical bounded Matrix Bernstein trace-mgf
  coefficient `(theta ^ 2 / 2) / (1 - abs theta * R / 3)`.
- `bernsteinThetaChoice`: def, canonical scalar theta choice
  `t / (sigmaSq + R * t / 3)`.
- `bernsteinThetaChoice_den_pos`, `bernsteinThetaChoice_nonneg`,
  `bernsteinThetaChoice_pos`, `bernsteinThetaChoice_range`, and
  `bernsteinThetaChoice_exponent_eq`: scalar helpers proving denominator
  positivity, theta positivity/nonnegativity, the bounded-MGF range, and the
  Bernstein denominator exponent identity.
- `bernsteinCoefficient_nonneg`: theorem proving nonnegativity of the
  Bernstein quadratic coefficient
  `(theta ^ 2 / 2) / (1 - abs theta * R / 3)` under `abs theta * R < 3`.
- `bernsteinMGFCoeff_nonneg`: theorem wrapper proving
  `0 <= bernsteinMGFCoeff theta R` under `abs theta * R < 3`.
- `TraceMGFBernsteinVarianceProxyBound`: def, semantic real trace-mgf bound
  using the bounded Bernstein denominator coefficient.
- `TraceMGFBernsteinVarianceProxyBoundLIntegral`: def, semantic lintegral
  trace-mgf bound using the bounded Bernstein denominator coefficient.
- `traceMGFBernsteinVarianceProxyBoundLIntegral_of_traceMGFBernsteinVarianceProxyBound`:
  theorem converting the bounded-Bernstein real semantic trace-mgf bound into
  the corresponding lintegral semantic trace-mgf bound under random
  self-adjointness and trace-exp integrability.
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
- `traceMatrixExp_smul_le_card_exp_of_lambdaMaxOrdered_le`: theorem proving
  `traceMatrixExp (SMul.smul c V) <= (n + 1 : Real) * Real.exp (c * sigmaSq)` from
  `0 <= c`, self-adjointness of `V`, and
  `lambdaMaxOrdered V hV <= sigmaSq`.
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
- `matrixLaplaceRHSLIntegral_le_of_traceMGFBernsteinVarianceProxyBoundLIntegral`:
  theorem substituting a bounded-Bernstein lintegral trace-MGF bound into the
  product-form Laplace RHS.
- `quadraticFormUpperTail_laplace_bound_of_traceMGFBernsteinVarianceProxyBoundLIntegral`:
  conditional theorem combining the event-subset Laplace bridge with the
  bounded-Bernstein lintegral trace-MGF RHS.
- `quadraticFormUpperTail_laplace_bound_of_traceMGFBernsteinVarianceProxyBoundLIntegral_statement`:
  typed target for the reusable bounded-Bernstein lintegral trace-MGF to
  quadratic-form Laplace contract.
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
- `matrixExpScaledFamily`: def, matrix-exponential random-matrix family
  `i |-> exp(theta * A_i)`.
- `matrixExpScaledFamily_apply`: theorem.
- `bernsteinSecondMomentComparisonFamily`: def, Bernstein coefficient times
  the per-summand second moment.
- `bernsteinSecondMomentComparisonFamily_apply`: theorem.
- `matrixBernsteinQuadraticFormUpperTailWithBernsteinCoeff_under_primitives`:
  theorem proving the explicit-theta one-sided quadratic-form upper-tail
  bound under the same explicit Tropp/Lieb and Bernstein CFC primitive
  assumptions, with trace-exponential RHS
  `exp(-theta*t) * tr exp(SMul.smul (bernsteinMGFCoeff theta R) (matrixVarianceProxy P A))`.
- `traceMatrixExp_bernsteinMGFCoeff_matrixVarianceProxy_le_card_exp`: theorem
  specializing the trace-exp dimension bound to `bernsteinMGFCoeff theta R`
  and `matrixVarianceProxy P A` under `MatrixVarianceProxyNormBound`.
- `matrixBernsteinQuadraticFormUpperTailScalarRHSWithBernsteinCoeff_under_primitives`:
  theorem reducing the explicit-theta quadratic-form RHS to the unnormalized
  scalar dimension/norm form.
- `matrixBernsteinQuadraticFormUpperTailScalarExpRHSWithBernsteinCoeff_under_primitives`:
  theorem normalizing the scalar RHS to exponential-add form.
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`:
  theorem choosing `bernsteinThetaChoice t sigmaSq R` and rewriting the RHS to
  the Bernstein denominator exponent
  `-(t ^ 2 / (2 * sigmaSq + (2 / 3) * R * t))`; still one-sided,
  quadratic-form, and under explicit primitives.
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`:
  bridge-explicit self-adjoint operator-norm wrapper under explicit positive
  and negative primitive assumptions.
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_nonempty_under_primitives`:
  nonempty-dimensional self-adjoint operator-norm wrapper that supplies the
  nonempty spectral bridge internally.
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_pos_under_primitives`:
  arbitrary-dimensional self-adjoint operator-norm wrapper on the corrected
  positive-threshold route.
- `MatrixBernsteinPositiveSideAssumptions`: structure packaging the positive
  optimized Matrix Bernstein hypotheses for a family `A`.
- `MatrixBernsteinNegativeSideAssumptions`: structure packaging the
  negative-side optimized hypotheses for `negRandomMatrixFamily A`.
- `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions`:
  assumption-bundle wrapper for the two-sided quadratic-form Matrix Bernstein
  route.
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_assumptions`:
  assumption-bundle wrapper for the arbitrary-dimensional positive-threshold
  self-adjoint operator-norm route.
- `negRandomMatrixFamily`: abbrev naming the pointwise negative of a
  random-matrix family, used by two-sided Matrix Bernstein wrappers instead of
  exposing anonymous negative-family lambdas in public signatures.
- `sampleCovarianceCenteredRankOneRadius`: abbrev naming the `2 * R` centered
  rank-one radius produced by a row squared-norm bound.
- `sampleCovarianceCenteredRankOneVarianceProxyBound`: abbrev naming the crude
  variance-proxy RHS `(m : Real) * sampleCovarianceCenteredRankOneRadius R ^ 2`.
- `sampleCovarianceCenteredRankOneVarianceProxyBoundOfRows`: explicit-row-count
  alias for `sampleCovarianceCenteredRankOneVarianceProxyBound`.
- `sampleCovarianceCenteredRankOneVarianceProxyBoundOfRows_pos`: positivity
  theorem for the explicit-row-count alias.
- `sampleCovarianceTailTheta`: abbrev naming the optimized Bernstein theta for
  the sample-covariance wrapper at threshold `(m : Real) * t`.
- `sampleCovarianceTailThetaOfRows`: explicit-row-count alias for
  `sampleCovarianceTailTheta`.
- `sampleCovarianceQuadraticFormTailRHS`: abbrev naming the scalar RHS of the
  sample-covariance quadratic-form tail wrapper.
- `centeredSampleCovarianceRowRankOneFamilyNeg`: abbrev naming the negative
  centered row-rank-one family for sample-covariance operator-norm wrappers.
- `centeredSampleCovarianceRowRankOneSumNeg`: abbrev naming the sum of the
  negative centered row-rank-one family.
- `sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy`:
  theorem proving the conditional sample-covariance quadratic-form tail wrapper
  under explicit variance-proxy, integrability, Tropp, and CFC assumptions.
- `sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound`:
  theorem proving the bounded-row quadratic-form tail wrapper with the crude
  variance proxy supplied internally.
- `sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum`:
  theorem bridging the centered sample-covariance operator-norm event to the
  unnormalized centered row-rank-one sum at threshold `(m : Real) * t`.
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_under_explicit_variance_proxy`:
  theorem proving the conditional sample-covariance self-adjoint
  operator-norm tail wrapper under explicit variance-proxy, both-sign
  integrability/independence, Tropp, CFC, and spectral-bridge assumptions.
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_nonempty_under_explicit_variance_proxy`:
  theorem proving the nonempty sample-covariance self-adjoint operator-norm
  tail wrapper under explicit variance-proxy, both-sign
  integrability/independence, Tropp, and CFC assumptions, with the spectral
  bridge supplied internally by the RM-ON-S4 Matrix Bernstein wrapper.
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_explicit_variance_proxy`:
  theorem proving the arbitrary positive-threshold sample-covariance
  operator-norm tail wrapper under explicit variance-proxy and primitive
  assumptions, with the corrected spectral bridge supplied internally.
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound`:
  theorem proving the arbitrary positive-threshold sample-covariance
  operator-norm tail wrapper with the positive-side crude variance proxy
  supplied from the bounded-row assumption. This retained wrapper still exposes
  negative-family structure and pointwise-bound assumptions explicitly.
- `isRandomMatrix_negRandomMatrixFamily`,
  `integrableRandomMatrix_negRandomMatrixFamily`,
  `selfAdjointRandomMatrixFamily_negRandomMatrixFamily`,
  `centeredSelfAdjointRandomMatrixFamily_negRandomMatrixFamily`,
  `independentRandomMatrices_negRandomMatrixFamily`,
  `independentSelfAdjointRandomMatrices_negRandomMatrixFamily`, and
  `PointwiseOperatorNormBound_negRandomMatrixFamily`: thin generic adapters
  transferring measurability, entrywise integrability, centered/self-adjoint
  structure, independence, and pointwise operator-norm bounds through the named
  negative-family alias.
- `centeredSampleCovarianceRowRankOneFamilyNeg_integrable_of_memLp_two`,
  `centeredSampleCovarianceRowRankOneFamilyNeg_centeredSelfAdjoint_of_memLp_two`,
  and
  `PointwiseOperatorNormBound_centeredSampleCovarianceRowRankOneFamilyNeg_of_rowSqNorm_bound`:
  sample-covariance adapters deriving the negative centered row-rank-one
  family assumptions from row measurability, `MemLp 2`, and row squared-norm
  bounds.
- `matrixSquare_neg`, `randomMatrixSquare_neg`: deterministic and named
  `negRandomMatrix` pointwise square identities for `(-X)^2 = X^2`.
- `randomMatrixSquare_negRandomMatrixFamily`,
  `integrableRandomMatrix_randomMatrixSquare_negRandomMatrixFamily`:
  generic negative-family square and square-integrability adapters.
- `centeredSampleCovarianceRowRankOneFamilyNeg_squareIntegrable_of_squareIntegrable`:
  derives negative centered sample-covariance row-rank-one square-integrability
  from the positive family by the square-negation identity.
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_adapters`:
  lighter arbitrary positive-threshold bounded-row operator-norm wrapper that
  consumes the first negative-family adapters. It keeps negative
  square/exponential/trace integrability, Tropp, and CFC primitive assumptions
  explicit.
- `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_square_adapters`:
  lighter bounded-row operator-norm wrapper that additionally derives the
  negative square-integrability assumption from the positive family. It still
  keeps negative exponential/trace integrability, Tropp, and CFC primitive
  assumptions explicit.
- `matrixBernsteinTraceMGFToLaplaceContract_statement`: retained typed
  compatibility contract for the bounded-Bernstein lintegral Laplace route
  specialized to `randomMatrixSum A` and `matrixVarianceProxy P A`.
- `matrixBernsteinTraceMGFToLaplaceContract_under_primitives_statement`:
  retained provider-aware typed contract keeping the bounded trace-MGF premise
  explicit at the Matrix Bernstein layer.

## Current Blockers

- The current supported operator-norm route is the explicit-primitive,
  positive-threshold API listed above. What is still not automatic:
  arbitrary-dimensional lambda-max tails, the zero-dimensional `t = 0`
  endpoint, CFC/Tropp-free Matrix Bernstein, and the remaining
  negative-square-integrability adapter needed to make sample-covariance
  operator-norm wrappers lighter to use.
- Unconditional trace-MGF provider theorem without explicit finite-family
  Tropp assumptions. The bounded theorem under primitives is proved for
  `matrixBernsteinTraceMGFWithBernsteinCoeff_statement`; the narrow `Fin m`
  finite-family provider from explicit conditional-step/state data is proved,
  and canonical finite-index reindex transport is available, but the full
  arbitrary finite-index provider from natural conditional-step data and
  automatic history/state construction remain open.
- The older `matrixBernsteinTraceMGF_statement` is retained for the
  `theta ^ 2 / 2` compatibility target and is not the bounded Matrix
  Bernstein RHS.
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
- `traceMGFBernsteinVarianceProxyBound_of_troppConditionalSteps`: theorem in
  `TraceExp.lean`, thin wrapper from the S5 conditional-step finite chain to
  `TraceMGFBernsteinVarianceProxyBound`. It is a `Fin m` API and keeps the S5
  history/state/integrability data explicit, while also keeping the ordinary
  finite-family assumptions in the public signature for consistency with
  `traceMGFBernsteinVarianceProxyBound_of_troppMasterTraceMGFFiniteFamily`.
  The shared private core removes duplicated finite-chain proof work without
  narrowing the exported wrapper shape.
- `matrixBernsteinTraceMGFWithBernsteinCoeff_of_troppMasterTraceMGFFiniteFamily`:
  theorem in `ConcentrationStatements.lean`, thin high-level wrapper from the
  finite-family Tropp typed primitive to
  `matrixBernsteinTraceMGFWithBernsteinCoeff_statement`.
- S7 intentionally does not add a Matrix Bernstein conditional-step wrapper:
  the resulting signature would include all S5 history/state data plus the
  existing Matrix Bernstein primitive inputs, making call-sites worse than
  passing the finite-family primitive directly.
- The finite-family Tropp primitive remains an explicit input for downstream
  Matrix Bernstein wrappers. A narrow `Fin m` provider exists only when callers
  already have the S5 conditional-step/state package. The Bernstein CFC
  primitive remains explicit; Lieb, Golden-Thompson, and full Matrix
  Bernstein are still outside the proved API.

## Completed Square-Negation Adapter Slice

RM-negative-square-integrability-adapters proves the thin `randomMatrixSquare`
/ square-integrability transfer for named negative row-rank-one families. The
preferred bounded-row operator-norm wrapper no longer asks for negative
square-integrability separately; it derives it from the positive family by
`(-X)^2 = X^2`.

## Completed Negative Exp/Trace Primitive Audit

RM-negative-exp-trace-primitive-audit adds thin sign-normalization adapters:

- `bernsteinMGFCoeff_neg`;
- `bernsteinMatrixExp_le_quadratic_neg_of_neg_theta`;
- `matrixExpScaledFamily_negRandomMatrixFamily`;
- `integrableRandomMatrix_matrixExpScaledFamily_negRandomMatrixFamily`;
- `randomMatrixSum_negRandomMatrixFamily`;
- `traceExpIntegrand_randomMatrixSum_negRandomMatrixFamily`;
- `integrableRealRandomVariable_traceExpIntegrand_randomMatrixSum_negRandomMatrixFamily`.

These adapters say that negative-family exp/trace/CFC obligations at `theta`
can be discharged from original-family obligations at `-theta` when those
negative-theta obligations are available. They do not prove matrix-exponential
integrability, trace-integrability, CFC, or Tropp from the current positive-side
positive-theta assumptions.

## Next Safe Task

RM-negative-tropp-primitive-boundary-audit: audit the finite-family Tropp primitive boundary for the negative
family.  This should determine which variance-proxy/K-family equalities,
trace-MGF sign rewrites, and MGF-comparison hypotheses would be required before
any honest Tropp transfer can be exposed. Golden-Thompson, Lieb, Bernstein CFC,
and full Matrix Bernstein remain explicit blockers.

Separate local leaf: `RM-BR-natural-history-state-construction` should use the
prefix/suffix bookkeeping API to construct the natural history/state route for
the existing `Fin m` conditional-step provider. Keep this as state
construction, not as Lieb, Bernstein CFC, Golden-Thompson, Matrix Bernstein, or
a parallel arbitrary-index Tropp primitive.

## MB-S9 Matrix Bernstein Trace-MGF Under Primitives API

- `matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives`: theorem in
  `ConcentrationStatements.lean`. It proves
  `matrixBernsteinTraceMGFWithBernsteinCoeff_statement P A theta R` from
  ordinary finite-family assumptions, an explicit
  `troppMasterTraceMGFFiniteFamily_statement` assumption, and explicit
  pointwise `bernsteinMatrixExp_le_quadratic_statement` assumptions.
- The arbitrary-index finite-family Tropp provider remains open. The narrow
  `Fin m` provider from explicit conditional-step/state data is proved, and
  the canonical finite-index reindex transport is proved, but downstream
  Matrix Bernstein wrappers still take the finite-family primitive directly
  until the conditional-step/state package is made ergonomic. The Bernstein
  CFC primitive remains typed only. No Lieb theorem,
  Golden-Thompson theorem, or Matrix Bernstein tail theorem was proved.
- The generic bounded-Bernstein real-to-lintegral semantic bridge is now
  proved in `TraceExp.lean`.
- The explicit-theta one-sided quadratic-form upper-tail wrapper under
  primitives is now proved in `ConcentrationStatements.lean`, with
  trace-exponential RHS.
- The explicit-theta scalar-RHS quadratic-form wrapper under primitives is now
  proved in `ConcentrationStatements.lean`, with intentionally unnormalized RHS.
- The normalized scalar-RHS quadratic-form wrapper under primitives is now
  proved in `ConcentrationStatements.lean`, with exponential-add RHS.
- The theta-optimized scalar-RHS quadratic-form wrapper under primitives is now
  proved in `ConcentrationStatements.lean`, with Bernstein denominator RHS.
- The sample-covariance quadratic-form tail wrapper under explicit variance
  proxy and primitive assumptions is retained in `ConcentrationStatements.lean`;
  the bounded-row wrapper now supplies the crude positive-side variance proxy
  internally.
- RM-S5E adds `SampleCovarianceTailUsage.lean`; the current example wrappers
  demonstrate the bounded-row variants while preserving independence,
  square/exponential/trace integrability, Tropp, and CFC assumptions explicitly.
- RM-S7E/RM-S7F add the sample-covariance operator-norm event bridge and
  conditional operator-norm tail wrapper:
  `sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum`
  and
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_under_explicit_variance_proxy`.
  The example file now also checks `sampleCovariance_operatorNorm_tail_usage`.
- RM-VP proves the crude variance-proxy route from pointwise operator-norm
  bounds and specializes it to centered rank-one and sample-covariance row
  rank-one families.
- RM-S6 adds the deterministic rank-one kernel/nullspace bridge in
  `Spectral.lean`.
- The rank-one nullspace examples now use the S6 core bridge where it removes
  local action/sum algebra.
- RM-ON-S4 adds
  `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_nonempty_under_primitives`,
  which reuses the bridge-explicit operator-norm wrapper and supplies
  `selfAdjointOperatorNormTailViaQuadraticFormStatement_nonempty` internally.
- RM-ON-S5 adds
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_nonempty_under_explicit_variance_proxy`,
  which reuses the RM-S7E event bridge and the RM-ON-S4 nonempty operator-norm
  Matrix Bernstein wrapper so the sample-covariance theorem no longer carries
  an explicit spectral-bridge assumption.
- RM-ON-S6 validates `sampleCovariance_operatorNorm_tail_usage`, RM-ON-S7
  validates focused test/judge coverage, and RM-ON-S8 synchronizes the docs.
- The arbitrary-dimension bridge leaf adds the corrected positive-threshold
  arbitrary spectral bridge and arbitrary operator-norm Matrix
  Bernstein/sample-covariance wrappers under explicit primitive assumptions.
- The RM-BR prefix/suffix API adds only finite-sum/state bookkeeping for the
  natural-state construction leaf; it does not prove Lieb, Bernstein CFC,
  Golden-Thompson, Matrix Bernstein, or arbitrary finite-index Tropp.
- Next safe task: RM-negative-tropp-primitive-boundary-audit.
- Separate local leaf: RM-BR-natural-history-state-construction.
