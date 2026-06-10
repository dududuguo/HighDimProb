# Matrix Concentration Plan

## Summary

Current public RandomMatrix status: MB-S9 has proved
`matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives`, the bounded
Matrix Bernstein trace-MGF statement under explicit finite-family
Tropp/Lieb and pointwise Bernstein CFC primitive assumptions. The typed
primitives themselves remain unproved, and the full Matrix Bernstein tail
theorem remains unproved.

The MB-S9 trace-MGF-to-Laplace/tail contract core is present: bounded
Bernstein lintegral trace-MGF bounds now substitute into the Laplace RHS and
conditional quadratic-form tail theorem. Next safe task:
`MB-S9-real-to-lintegral-bridge-proof-hardening`.
Stage MC1 starts the matrix concentration branch after the scalar concentration
closeout. It adds the assumption vocabulary, explicit matrix order vocabulary,
matrix expectation wrappers, and typed theorem-statement layer needed before
matrix Bernstein, matrix Hoeffding, matrix Chernoff, Hanson-Wright, or
covariance estimation proof work can begin.

No matrix concentration theorem is proved in MC1.

Stage MC2 adds the operator-norm / unit-vector / quadratic-form bridge
vocabulary needed by future random-matrix concentration stages. No matrix
Bernstein, Hanson-Wright, covariance-estimation, or sample-covariance
operator-norm theorem is proved in MC2.

Stage MC2-fix proves the finite-sum norm bridges to Mathlib's L2
Euclidean/operator norm, proves both directions between the squared explicit
unit-vector operator-norm bound and `deterministicOperatorNorm`, and proves
operator-norm measurability from entrywise random-matrix measurability.

Stage MC3 adds the finite random-matrix sum, independent self-adjoint family,
matrix square / second-moment, variance-proxy matrix, scalar variance-proxy
norm, and pointwise/a.e. operator-norm-bound vocabulary needed before a matrix
Bernstein proof. It updates `matrixBernsteinStatement` to use this vocabulary
and keeps the result as a typed `Prop` statement only.

No matrix Bernstein, matrix Hoeffding, matrix Chernoff, Hanson-Wright,
covariance-estimation, or sample-covariance operator-norm theorem is proved in
MC3.

Stage MC5 begins the analytic matrix Bernstein layer. Its first substages add
spectral vocabulary, quadratic-form tail predicates, matrix trace-exponential
wrappers, and honest matrix Laplace typed targets without proving a
lambda-max/Rayleigh quotient theorem, trace-mgf theorem, matrix Laplace
theorem, or matrix concentration theorem.

Stage MC5.4 refines the matrix Bernstein proof plan while keeping
`matrixBernsteinSelfAdjointStatement` as an operator-norm statement. The proof
route is now explicitly routed through the spectral, trace-exponential, and
Laplace typed targets, but no analytic reduction theorem is proved.

Stage MB-S2 closes the next bridge pass over the same mainline. It adds
monotonicity lemmas for quadratic-form bound predicates, two-sided
quadratic-form tail event vocabulary, lintegral trace-exponential and Laplace
targets, and a matrix Bernstein analytic-prerequisite bundle. It does not prove
Rayleigh, matrix Laplace, trace-mgf, trace-exponential positivity, or matrix
Bernstein.

Stage MB-S3 proves the trace-exp bridges that only need explicit
nonnegativity/integrability hypotheses. It does not prove that `exp(A)` is PSD
for every self-adjoint real matrix.

Stage MB-S4 proves that `matrixExp A` is Mathlib-positive-semidefinite for
real self-adjoint `A`, and derives trace-exp nonnegativity for deterministic
self-adjoint matrices and random self-adjoint trace-exp moments. It does not
prove matrix Laplace, trace-mgf inequalities, or matrix Bernstein.

Stage MB-S5 proves the generic lintegral Markov/Laplace step for the
trace-exponential threshold event and the conditional quadratic-form bridge
under the explicit subset hypothesis
`quadraticFormUpperTailEvent Y t ‚ä?traceExpThresholdEvent Y theta t`. It does
not prove that subset, trace-mgf inequalities, full matrix Laplace, or matrix
Bernstein.

Stage MB-S6 names that missing subset as the explicit predicate
`TraceExpDominatesQuadraticFormUpperTail`, records the typed target
`traceExpDominatesQuadraticFormUpperTailStatement`, and proves conditional
Laplace wrappers from the named hypothesis. It does not prove the direct
dominance bridge, trace-mgf inequalities, full matrix Laplace, or matrix
Bernstein.

Stage MB-S7A-provider proves the semantic ordered endpoint provider theorem
`lambdaMaxOrdered_spectralUpperBound`, the named provider wrapper
`lambdaMaxOrderedPSDUpperBound`, and the direct ordered Rayleigh wrapper
`lambdaMaxOrdered_rayleighUpperBound`. It preserves the legacy `lambdaMax` API
and does not prove trace-exp dominance, trace-mgf inequalities, full matrix
Laplace, or matrix Bernstein.

Stage MB-S7B-semantic adds `TraceExpDominatesUpperBound` as the deterministic
trace-exp dominance predicate for an arbitrary scalar upper-bound process and
proves generic event bridges from `matrixUpperBoundTailEvent`,
`RayleighUpperBound`, and `SpectralUpperBound` assumptions to
`traceExpThresholdEvent` / `TraceExpDominatesQuadraticFormUpperTail`. It does
not prove the `lambdaMaxOrdered` trace-exp provider theorem, spectral mapping,
trace-mgf inequalities, full matrix Laplace, or matrix Bernstein.

Stage MB-S7B-scalar-endpoint proves `lambdaMaxOrdered_smul_of_nonneg`, the
nonnegative scalar-multiplication theorem for the canonical ordered endpoint.
It resolves only the scalar endpoint split behind the trace-exp provider route.
The `lambdaMaxOrdered` trace-exp provider theorem, exponential spectral
mapping, trace-dominates-endpoint theorem, trace-mgf inequalities, full matrix
Laplace, and matrix Bernstein remain unproved.

Stage MB-S7B-exp-spectral-mapping proves `lambdaMaxOrdered_matrixExp`, the
ordered endpoint spectral-mapping theorem for the matrix exponential. It
resolves only the exponential spectral-mapping split behind the trace-exp
provider route. The `lambdaMaxOrdered` trace-exp provider theorem,
trace-dominates-endpoint theorem, trace-mgf inequalities, full matrix Laplace,
and matrix Bernstein remain unproved.

Stage MB-S7B-trace-dominates-endpoint proves
`lambdaMaxOrdered_le_trace_of_posSemidef`, the ordered endpoint trace
domination theorem for positive semidefinite self-adjoint matrices. It resolves
only the trace endpoint split behind the trace-exp provider route. The
`lambdaMaxOrdered` trace-exp provider theorem, trace-mgf inequalities, full
matrix Laplace, and matrix Bernstein remain unproved.

Stage MB-S7B-provider-close proves
`lambdaMaxOrdered_traceExpDominatesUpperBound`, assembling the scalar endpoint,
matrix-exponential spectral mapping, and trace endpoint helper into the
deterministic `TraceExpDominatesUpperBound` provider for `lambdaMaxOrdered`.
It does not prove trace-mgf inequalities, full matrix Laplace,
Golden-Thompson, Lieb, or matrix Bernstein.

Stage MB-S7C-assemble-dominance proves
`traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint`, assembling the
`lambdaMaxOrdered` Rayleigh and trace-exp providers into the concrete
`TraceExpDominatesQuadraticFormUpperTail` dominance wrapper for random
self-adjoint matrices. It does not prove trace-mgf inequalities, full matrix
Laplace, Golden-Thompson, Lieb, or matrix Bernstein.

Stage MB-S8-laplace-assembly proves
`matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint` and
`matrixLaplaceTransformLIntegral_of_randomSelfAdjoint`, assembling concrete
random self-adjoint dominance with the existing conditional Laplace wrappers.
The theorems keep the trace-exp integrand a.e. measurability hypothesis
explicit. They do not prove the real RHS bridge, trace-mgf inequalities,
Golden-Thompson, Lieb, or matrix Bernstein.

Stage MB-S9-foundation adds semantic trace-mgf and variance-proxy foundation
vocabulary: `TraceMGFBound`, `TraceMGFBoundLIntegral`,
`TraceMGFVarianceProxyBound`, `TraceMGFVarianceProxyBoundLIntegral`,
`MatrixVarianceProxyUpperBound`, `MatrixVarianceProxyNormBound`, and typed
trace-mgf provider targets including `matrixBernsteinTraceMGF_statement`. It
does not prove Golden-Thompson, Lieb, the full trace-mgf master theorem, the
real RHS bridge, or matrix Bernstein.

Stage MB-S9-exp-lower-bound-proof proves
`matrixLE_one_add_self_le_matrixExp_of_selfAdjoint` and
`matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint`, giving the
deterministic `1 + A <= matrixExp A` MatrixLE lower bound for self-adjoint
real matrices and the downstream scalar-multiple wrapper. It does not prove
the single-summand provider, Bernstein CFC primitive, trace-mgf provider,
Golden-Thompson, Lieb, or matrix Bernstein.

Stage MB-S9-single-summand-provider-under-cfc proves
`singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic`,
the single-summand matrix MGF variance-proxy provider under an explicit
pointwise Bernstein CFC primitive assumption. The Bernstein CFC primitive
itself, trace-mgf provider, Golden-Thompson, Lieb, and matrix Bernstein remain
unproved.

## Implemented Vocabulary

| Area | Declarations | Status | Source |
|---|---|---|---|
| Unit vectors | `vectorSqNorm`, `IsUnitVector`, `unitSphere`, `vectorSqNorm_eq_norm_sq_toLp`, `norm_sq_toLp_eq_vectorSqNorm`, `norm_toLp_eq_one_of_isUnitVector`, `isUnitVector_of_norm_toLp_eq_one` | implemented with explicit finite sums and proved L2 norm bridge | `HighDimProb/RandomMatrix/UnitSphere.lean` |
| Symmetry/self-adjointness | `IsSymmetricMatrix`, `IsSelfAdjointMatrix`, `RandomSymmetricMatrix`, `RandomSelfAdjointMatrix` | implemented | `HighDimProb/RandomMatrix/SelfAdjoint.lean` |
| PSD/order | `matrixQuadraticForm`, `IsPSDMatrix`, `RandomPSDMatrix`, `MatrixLE`, `quadraticForm_le_of_matrixLE` | implemented; Loewner quadratic-form monotonicity proven | `HighDimProb/RandomMatrix/MatrixOrder.lean` |
| Sample covariance PSD | `isSymmetricMatrix_sampleCovariance`, `isPSD_sampleCovariance`, `randomPSDMatrix_sampleCovariance` | proven for uncentered sample covariance | `HighDimProb/RandomMatrix/MatrixOrder.lean` |
| Matrix expectation | `matrixExpect`, `centeredRandomMatrix` | entrywise expectation wrapper | `HighDimProb/RandomMatrix/Expectation.lean` |
| Matrix-valued measurability for independence | `instMeasurableSpaceMatrix`, `measurable_randomMatrix_of_isRandomMatrix` | product measurable-space instance and entrywise-to-matrix measurability bridge | `HighDimProb/RandomMatrix/Basic.lean` |
| Deterministic operator norm bridge vocabulary | `deterministicOperatorNorm`, `matVecSqNorm`, `randomMatVecSqNorm`, `OperatorNormBoundSq`, `RandomOperatorNormBoundSq`, `matVecSqNorm_eq_norm_sq_toLp_mulVec`, `norm_sq_toLp_mulVec_eq_matVecSqNorm` | implemented with explicit squared finite-sum norm and proved L2 matrix-vector bridge | `HighDimProb/RandomMatrix/OperatorNorm.lean` |
| Exact operator norm bridges and measurability | `operatorNorm_le_of_operatorNormBoundSqStatement`, `operatorNormBoundSq_of_operatorNorm_leStatement`, `operatorNormMeasurabilityStatement`, `operatorNorm_le_of_operatorNormBoundSq`, `operatorNormBoundSq_of_operatorNorm_le`, `instOpensMeasurableSpaceMatrixL2Operator`, `isRealRandomVariable_operatorNorm` | typed `Prop` targets retained; bridge directions and measurability theorem proved | `HighDimProb/RandomMatrix/OperatorNorm.lean` |
| Finite random-matrix sums | `randomMatrixSum`, `randomMatrixSum_apply`, `randomMatrixSum_entry`, `isRandomMatrix_sum`, `isSelfAdjointMatrix_sum`, `randomSelfAdjointMatrix_sum` | implemented with measurability and self-adjoint sum lemmas | `HighDimProb/RandomMatrix/Sums.lean` |
| Matrix assumptions | `IndependentRandomMatrices`, `SelfAdjointRandomMatrixFamily`, `IndependentSelfAdjointRandomMatrices`, `CenteredSelfAdjointRandomMatrixFamily`, `CenteredRandomSelfAdjointMatrices`, `BoundedOperatorNorm`, `PointwiseOperatorNormBound`, `UniformOperatorNormBound`, `AeOperatorNormBound` | implemented; pointwise and a.e. norm bounds are named separately | `HighDimProb/RandomMatrix/Assumptions.lean` |
| Matrix square, expectation, and variance proxy | `matrixSquare`, `randomMatrixSquare`, `matrixSecondMoment`, `matrixVarianceProxy`, `MatrixVarianceProxy`, `matrixVarianceProxyBound`, `MatrixVarianceProxyBound`, `MatrixVarianceProxyUpperBound`, `deterministicMatrixVarianceProxyNorm`, `matrixVarianceProxyNorm`, `MatrixVarianceProxyNormBound`, `integrableRandomMatrix_sub`, `integrableRandomMatrix_add`, `integrableRandomMatrix_smul`, `integrableRandomMatrix_zero`, `integrableRandomMatrix_const`, `matrixExpect_sub`, `matrixExpect_add`, `matrixExpect_smul`, `matrixExpect_zero`, `matrixExpect_const`, `matrixExpect_const_of_isProbabilityMeasure`, `matrixExpect_one_of_isProbabilityMeasure`, `isPSDMatrix_matrixExpect_of_pointwise_isPSD`, `matrixExpect_matrixLE_of_pointwise_matrixLE` | implemented; square measurability, PSD square, PSD second moment, PSD variance proxy, PSD preservation under entrywise matrix expectation, MatrixLE expectation monotonicity, and matrix expectation add/smul/zero/constant normalization are proved with explicit integrability or probability-measure assumptions where needed; MB-S9 adds semantic upper-bound and scalar-norm-bound predicates | `HighDimProb/RandomMatrix/VarianceProxy.lean` |
| Spectral and quadratic-form tails | `lambdaMax`, `lambdaMaxOrdered`, `lambdaMaxOrdered_eq_eigenvalues‚ÇÄ_zero`, `lambdaMin`, `QuadraticFormUpperBound`, `QuadraticFormLowerBound`, `quadraticFormUpperBound_mono`, `quadraticFormLowerBound_mono`, `LambdaMaxBound`, `LambdaMaxPSDUpperBound`, `LambdaMaxOrderedPSDUpperBound`, `quadraticFormUpperTailEvent`, `quadraticFormLowerTailEvent`, `twoSidedQuadraticFormTailEvent`, `SelfAdjointOperatorNormTailEvent`, `selfAdjointOperatorNormTailViaQuadraticFormStatement`, `lambdaMax_le_iff_quadraticForm_le_statement`, `lambdaMax_eq_lambdaMaxOrdered_statement`, `lambdaMaxOrdered_is_greatest_eigenvalue`, `lambdaMaxOrdered_spectralUpperBound`, `lambdaMaxOrderedPSDUpperBound`, `lambdaMaxOrdered_rayleighUpperBound`, `lambdaMaxOrdered_smul_of_nonneg`, `lambdaMaxOrdered_le_trace_of_posSemidef`, `matrixQuadraticForm_le_lambdaMaxOrdered_statement`, `operatorNorm_eq_max_abs_lambda_statement`, `matrixQuadraticForm_nonneg_of_posSemidef`, `matrixQuadraticForm_smul_one_of_isUnitVector`, `matrixQuadraticForm_le_lambdaMax_of_lambdaMax_sub_posSemidef`, `matrixQuadraticForm_le_lambdaMax_of_lambdaMaxPSDUpperBound`, `matrixQuadraticForm_le_lambdaMaxOrdered_of_lambdaMaxOrderedPSDUpperBound`, `lambdaMaxOrderedUpperTailEvent`, `quadraticFormUpperTailEvent_subset_lambdaMaxOrderedUpperTailEvent_of_matrixQuadraticForm_le_lambdaMaxOrdered` | implemented vocabulary; legacy eigenvalue wrappers are preserved, `lambdaMaxOrdered` uses Mathlib's ordered `eigenvalues‚ÇÄ 0` endpoint directly, ordered endpoint greatest theorem, semantic provider/Rayleigh wrappers, nonnegative scalar endpoint theorem, and trace endpoint theorem are proved; legacy direct Rayleigh/operator-norm bridges remain unproved | `HighDimProb/RandomMatrix/Spectral.lean` |
| Trace exponential vocabulary | `matrixExp`, `matrixTrace`, `traceMatrixExp`, `isSelfAdjointMatrix_matrixExp`, `matrixExp_posSemidef_of_selfAdjoint`, `matrixLE_one_add_self_le_matrixExp_of_selfAdjoint`, `matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint`, `matrixTrace_nonneg_of_posSemidef`, `traceMatrixExp_nonneg_of_matrixExp_posSemidef`, `traceMatrixExp_nonneg_of_selfAdjoint`, `matrixExp_posSemidef_of_selfAdjoint_statement`, `traceExpIntegrand`, `traceExpMoment`, `traceExpMomentLIntegral`, `TraceMGFBound`, `TraceMGFBoundLIntegral`, `TraceMGFVarianceProxyBound`, `TraceMGFVarianceProxyBoundLIntegral`, `troppMasterTraceMGFStep_statement`, `bernsteinMatrixExp_le_quadratic_statement`, `singleSummandMatrixMGFVarianceProxy_statement`, `singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic`, `traceExpMoment_nonneg_of_nonneg`, `traceExpIntegrand_nonneg_of_randomSelfAdjoint`, `traceExpMoment_nonneg_of_randomSelfAdjoint`, `traceExpMomentLIntegral_nonneg`, `traceExpMomentLIntegral_eq_ofReal_traceExpMoment`, `traceMatrixExp_nonneg_of_selfAdjoint_statement`, `traceExpMoment_nonneg_statement`, `traceExpMomentLIntegral_eq_ofReal_statement`, `traceExpMomentBoundStatement`, `traceExpVarianceProxyBoundStatement`, `traceMGFBound_statement`, `traceMGFBoundLIntegral_statement`, `traceMGFVarianceProxyBound_statement` | implemented vocabulary; deterministic self-adjoint matrix exponential PSD, MatrixLE affine lower bound for matrix exponential, trace-exp nonnegativity, random self-adjoint trace-exp moment nonnegativity, expectation/lintegral bridges, and the single-summand provider under explicit CFC primitive are proved under explicit hypotheses; MB-S9 adds semantic trace-mgf predicates plus typed Tropp, Bernstein CFC, and single-summand MGF primitives, while CFC proof and trace-mgf inequalities remain unproved | `HighDimProb/RandomMatrix/TraceExp.lean` |
| Matrix Laplace vocabulary | `matrixLaplaceRHS`, `matrixLaplaceRHSLIntegral`, `traceExpThresholdEvent`, `TraceExpDominatesUpperBound`, `lambdaMaxOrdered_traceExpDominatesUpperBound`, `matrixUpperBoundTailEvent_subset_traceExpThresholdEvent_of_traceExpDominatesUpperBound`, `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_rayleighUpperBound_of_traceExpDominatesUpperBound`, `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_spectralUpperBound_of_traceExpDominatesUpperBound`, `traceExpDominatesQuadraticFormUpperTail_of_rayleighUpperBound_of_traceExpDominatesUpperBound`, `traceExpDominatesQuadraticFormUpperTail_of_spectralUpperBound_of_traceExpDominatesUpperBound`, `traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint`, `matrixLaplaceRHSLIntegralDiv`, `matrixLaplaceRHSLIntegralDiv_eq_matrixLaplaceRHSLIntegral`, `traceExpThresholdEvent_lintegral_bound`, `matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset`, `matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset`, `TraceExpDominatesQuadraticFormUpperTail`, `traceExpDominatesQuadraticFormUpperTailStatement`, `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates`, `matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail`, `matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail`, `matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint`, `matrixLaplaceTransformLIntegral_of_randomSelfAdjoint`, `matrixLaplaceTransformStatement`, `matrixLaplaceTransformLIntegralStatement`, `matrixChernoffFromTraceExpStatement`, `matrixChernoffFromTraceExpLIntegralStatement`, `selfAdjointOperatorNormLaplaceStatement`, `selfAdjointOperatorNormLaplaceLIntegralStatement` | conditional lintegral Markov/Laplace, dominance-wrapper bridges, semantic trace-exp upper-bound event bridges, the `lambdaMaxOrdered` trace-exp provider theorem, concrete random self-adjoint dominance assembly, and concrete random self-adjoint lintegral Laplace wrappers are proved under explicit hypotheses; real RHS bridge remains unproved | `HighDimProb/RandomMatrix/Laplace.lean` |
| Matrix Bernstein analytic prerequisite bundle | `matrixBernsteinLaplacePrerequisitesStatement`, `matrixBernsteinTraceMGF_statement`, `matrixBernsteinTraceMGFToLaplaceContract_statement`, `matrixBernsteinTraceMGFToLaplaceContract_under_primitives_statement` | typed targets bundling the operator-norm/quadratic-form event bridge, lintegral Laplace routes, semantic trace-mgf target, and bounded trace-MGF-to-Laplace contract; no matrix Bernstein theorem proved | `HighDimProb/RandomMatrix/ConcentrationStatements.lean` |
| Helper random matrices | `sampleCovarianceMinusIdentity` | implemented | `HighDimProb/RandomMatrix/ConcentrationStatements.lean` |

## Typed Statement Layer

| Statement target | Declaration | Status |
|---|---|---|
| Matrix Bernstein | `matrixBernsteinStatement` | typed `Prop`; now uses independent self-adjoint family, zero mean via `matrixExpect`, pointwise operator-norm bound `R`, PSD variance proxy, scalar variance-proxy norm `sigma2`, and operator norm of `randomMatrixSum A` |
| Matrix Hoeffding | `matrixHoeffdingStatement` | typed `Prop`, unproved |
| Matrix Chernoff | `matrixChernoffStatement` | typed `Prop`, unproved |
| Covariance estimation | `covarianceEstimationStatement` | typed `Prop`, unproved |
| Sample covariance operator-norm tail | `sampleCovarianceOperatorNormStatement` | typed `Prop`, unproved |
| Sample covariance unit-sphere operator-norm route | `sampleCovarianceQuadraticFormDeviation`, `sampleCovarianceOperatorNormViaUnitSphereStatement` | typed `Prop`, unproved |

## Mathlib APIs Reused

- `Matrix.IsSymm` for real symmetric matrices.
- `Matrix.IsHermitian` for real self-adjoint matrix vocabulary and small
  self-adjoint sum/square structural lemmas.
- `Matrix.sum_apply`, `Matrix.mul_apply`, and finite sums over `Fin`/`Fintype`
  for explicit matrix sums, entries, multiplication, and variance proxies.
- Product measurable spaces for function spaces, unfolded through
  `Matrix m n alpha = m -> n -> alpha`.
- `Finset.measurable_sum` and `Measurable.mul` for random-matrix sum and square
  measurability.
- `ProbabilityTheory.iIndepFun` for matrix-valued independence.
- `Matrix.Norms.L2Operator` for the existing `operatorNorm` wrapper.
- `Matrix.IsHermitian.eigenvalues` for the narrow nonempty-dimension legacy
  `lambdaMax` / `lambdaMin` wrappers.
- `Matrix.IsHermitian.eigenvalues‚ÇÄ` for the canonical ordered
  `lambdaMaxOrdered` endpoint wrapper.
- `Matrix.IsHermitian.eigenvalues‚ÇÄ_antitone` and
  `LinearMap.IsSymmetric.eigenvalues_antitone` as ordering evidence; MB-S7A-index
  proves the ordered endpoint greatest theorem for `lambdaMaxOrdered`, while
  the legacy `lambdaMax` bridge remains typed only.
- `NormedSpace.exp` and `Matrix.IsHermitian.exp` from
  `Mathlib.Analysis.Normed.Algebra.MatrixExponential` for matrix exponential
  and self-adjointness preservation.
- `Matrix.trace` for `matrixTrace` and `traceMatrixExp`.
- `Matrix.PosSemidef.trace_nonneg` for trace nonnegativity once a Mathlib PSD
  certificate is available.
- `ofReal_integral_eq_lintegral_ofReal`, `integral_nonneg_of_ae`, and
  `ae_of_all` for the real trace-exp moment / lintegral bridge under explicit
  integrability and nonnegativity assumptions.
- `EuclideanSpace.real_norm_sq_eq`, `WithLp.toLp`, and `EuclideanSpace.equiv`
  for finite-sum vector/matrix-vector norm bridges.
- `Matrix.l2_opNorm_def`, `Matrix.l2_opNorm_mulVec`,
  `ContinuousLinearMap.opNorm_le_of_unit_norm`, and `Matrix.toLpLin_apply` for
  the two operator-norm bound directions.
- `measurable_norm` plus the entrywise-to-matrix measurability bridge for
  `isRealRandomVariable_operatorNorm`.
- `Matrix.scalar` for scalar multiples of the identity in variance-proxy
  bounds.

## Deliberate Choices

- `IsPSDMatrix` is explicit: symmetry plus nonnegative quadratic forms. MC3
  still does not install or rely on a global Loewner order instance.
- `matrixExpect` is entrywise, matching the existing random-matrix object layer
  and avoiding a Bochner expectation commitment.
- `IndependentRandomMatrices` is genuinely matrix-valued through Mathlib
  `iIndepFun`, enabled by the product measurable-space instance for matrices.
- `CenteredSelfAdjointRandomMatrixFamily` records self-adjointness and zero mean
  as `matrixExpect P (A i) = 0`; `CenteredRandomSelfAdjointMatrices` is retained
  as entrywise-centered compatibility vocabulary.
- `matrixVarianceProxy P A` is the standard self-adjoint Bernstein candidate
  `sum_i E[A_i^2]`, implemented as
  `sum_i, matrixSecondMoment P (A i)`.
- `matrixVarianceProxyNorm P A` is the deterministic Mathlib L2 operator norm
  of `matrixVarianceProxy P A`, not a random variable.
- `PointwiseOperatorNormBound` and `AeOperatorNormBound` are separate names.
  Current matrix concentration statements use the pointwise predicate so the
  a.e. strengthening is not hidden.
- Matrix Bernstein/Hoeffding/Chernoff constants in statements are placeholders
  for future proof targets, not proved sharp constants.
- `OperatorNormBoundSq` records squared matrix-vector bounds over unit vectors
  and Stage MC2-fix proves its comparison with the scoped Mathlib L2 operator
  norm while keeping the explicit predicate available for theorem statements.
- Stage MC5.1 keeps two spectral layers separate: true Mathlib Hermitian
  eigenvalue wrappers for `Fin (n + 1)` matrices, and dimension-agnostic
  quadratic-form predicates for proof planning before the Rayleigh quotient
  bridge is proved.

## Remaining TODOs

- Keep the PSD variance-proxy theorem assumptions visible in future matrix
  Bernstein statements: `isPSD_matrixVarianceProxy_of_selfAdjoint` needs
  self-adjoint summands and entrywise integrability of every `A_i^2`.
- Prove matrix Laplace-transform and trace/exponential-moment inequalities
  before attempting matrix Bernstein. MC5.2 adds the trace-exponential
  vocabulary, and MC5.3 adds typed Laplace targets; the matrix Laplace theorem
  and trace-mgf inequalities remain future proof work.
- Decide whether future matrix Bernstein should use pointwise or a.e.
  operator-norm boundedness as its primary public assumption.
- Upgrade `sampleCovarianceOperatorNormViaUnitSphereStatement` only after the
  required supremum/unit-sphere or net argument is selected.
- Add independent-row and iid-row assumptions if covariance-estimation proofs
  need them.
- Add centered empirical covariance conventions beyond the current uncentered
  `sampleCovariance`.

## Stage MB-S2 - Spectral, Rayleigh, Trace-Exp, and Laplace Bridge

MB-S2 strengthens the statement layer without changing theorem meanings:

- `quadraticFormUpperBound_mono` and `quadraticFormLowerBound_mono` are proved.
- `twoSidedQuadraticFormTailEvent` and the two one-sided subset lemmas are
  proved as event-vocabulary bridges.
- `lambdaMax_is_greatest_eigenvalue_statement`,
  `lambdaMin_is_least_eigenvalue_statement`, and
  `selfAdjointOperatorNormTailViaQuadraticFormStatement` remain typed targets.
- `traceExpMomentLIntegral` and its nonnegativity / real-expectation bridge
  targets are available; MB-S3 later proves the bridge under explicit
  nonnegativity and integrability assumptions.
- `matrixLaplaceTransformLIntegralStatement`,
  `matrixChernoffFromTraceExpLIntegralStatement`, and
  `selfAdjointOperatorNormLaplaceLIntegralStatement` are meaningful typed
  targets.
- `matrixBernsteinLaplacePrerequisitesStatement` records the analytic
  dependency bundle needed before a proof attempt.

No matrix Laplace theorem, trace-mgf theorem, Rayleigh theorem, or matrix
Bernstein theorem is proved in MB-S2.

## Stage MC4-cleanup ‚Ä?Matrix Concentration Statement Honesty

Stage MC4-cleanup removes misleading statement targets whose bodies were just
`True`, and keeps matrix Laplace / trace exponential work as documentation-only
TODOs until the required objects and analytic theorems are available.

### MC4-cleanup Additions

| Area | Declarations | Status |
|---|---|---|
| Matrix integrability | `IntegrableRandomMatrix` | implemented entrywise predicate |
| Refined Bernstein statement | `matrixBernsteinSelfAdjointStatement` | typed `Prop` with explicit probability-measure, summand integrability, square integrability, positivity, variance-proxy norm, and denominator assumptions |
| Spectral-radius bridge | `operatorNorm_eq_spectralRadius_of_selfAdjointStatement` | typed `Prop`, unproved |
| High-probability syntax | `HighProbabilityBound`, `highProbabilityBound` | implemented thin wrapper |
| Self-adjoint second moment | `isSelfAdjointMatrix_matrixSecondMoment` | proven |
| Self-adjoint variance proxy | `isSelfAdjointMatrix_matrixVarianceProxy` | proven |
| PSD square | `isPSD_matrixSquare_of_selfAdjoint` | proven |
| PSD second moment | `isPSD_matrixSecondMoment_of_selfAdjoint` | proven with `IntegrableRandomMatrix P (randomMatrixSquare A)` |
| PSD variance proxy | `isPSD_matrixVarianceProxy_of_selfAdjoint` | proven with per-summand square-integrability |
| Matrix Laplace transform | no Lean declaration | documentation-only TODO |
| Trace exponential moment | `traceExpMoment`, `traceExpMomentBoundStatement`, `traceExpVarianceProxyBoundStatement` | meaningful typed vocabulary added in MC5.2; no trace-mgf theorem proved |
| Proof plan document | `docs/MatrixBernsteinProofPlan.md` | updated |

### PSD Variance Proxy Status

The PSD variance-proxy algebra is now proved in the explicit
quadratic-form order. The proof chain is:

- `matrixQuadraticForm_matrixSquare_eq_matVecSqNorm_of_selfAdjoint`
- `isPSD_matrixSquare_of_selfAdjoint`
- `matrixQuadraticForm_matrixExpect`
- `isPSD_matrixSecondMoment_of_selfAdjoint`
- `matrixQuadraticForm_sum`
- `isPSDMatrix_sum`
- `isPSD_matrixVarianceProxy_of_selfAdjoint`

The typed target names remain as compatibility signposts, but they are no
longer blockers.

### Matrix Laplace / Trace Exponential Blockers

The old `matrixLaplaceTransformStatement` and `traceExpMomentBoundStatement`
declarations whose bodies were just `True` are gone. MC5.2 reintroduces
`traceExpMomentBoundStatement` as a meaningful typed statement over
`traceExpMoment`; MC5.3 reintroduces `matrixLaplaceTransformStatement` as a
meaningful typed statement over `quadraticFormUpperTailEvent` and
`traceExpMoment`. Golden-Thompson inequality and Lieb concavity are not in the
current project.

## Stage MC5.1 - Spectral Vocabulary

Stage MC5.1 adds `HighDimProb.RandomMatrix.Spectral`.

Implemented declarations:

- `lambdaMax` and `lambdaMin`, narrow wrappers around
  `Matrix.IsHermitian.eigenvalues` for matrices indexed by `Fin (n + 1)`.
- `QuadraticFormUpperBound` and `QuadraticFormLowerBound`, explicit
  unit-sphere quadratic-form predicates usable without a full spectral theorem.
- `LambdaMaxBound`, an honest alias for the quadratic-form upper bound.
- `quadraticFormUpperTailEvent`, `quadraticFormLowerTailEvent`, and
  `SelfAdjointOperatorNormTailEvent`, event vocabulary for future Laplace and
  operator-norm reductions.
- `lambdaMax_le_iff_quadraticForm_le_statement` and
  `operatorNorm_eq_max_abs_lambda_statement`, typed targets only.

Status: vocabulary implemented and API-tested. The lambda-max/Rayleigh quotient
bridge and self-adjoint operator-norm/eigenvalue endpoint theorem remain
unproved.

## Stage MC5.2 - Trace and Matrix Exponential Vocabulary

Stage MC5.2 adds `HighDimProb.RandomMatrix.TraceExp`.

Implemented declarations:

- `matrixExp`, a wrapper around Mathlib `NormedSpace.exp` on matrices.
- `matrixTrace`, a wrapper around `Matrix.trace`.
- `traceMatrixExp`.
- `isSelfAdjointMatrix_matrixExp`, using Mathlib `Matrix.IsHermitian.exp`.
- `traceExpIntegrand`, shared by real and lintegral trace-exp moments.
- `traceExpMoment`.
- `traceExpMomentLIntegral`.
- `traceExpMomentBoundStatement` and
  `traceExpVarianceProxyBoundStatement`, meaningful typed targets only.

Status: vocabulary implemented and API-tested. Matrix trace-mgf bounds,
Golden-Thompson/Lieb inequalities, and matrix Laplace transforms remain
unproved.

## Stage MB-S3 - Trace-Exponential Positivity Bridge

MB-S3 proves the downstream trace-exp positivity and coercion bridges:

- `matrixTrace_nonneg_of_posSemidef`;
- `traceMatrixExp_nonneg_of_matrixExp_posSemidef`;
- `traceExpMoment_nonneg_of_nonneg`;
- `traceExpMomentLIntegral_nonneg`;
- `traceExpMomentLIntegral_eq_ofReal_traceExpMoment`.

MB-S4 later proves the self-adjoint bridge recorded by
`traceMatrixExp_nonneg_of_selfAdjoint_statement`.

## Stage MB-S4 - Matrix Exponential PSD Bridge

MB-S4 proves:

- `matrixExp_posSemidef_of_selfAdjoint`;
- `traceMatrixExp_nonneg_of_selfAdjoint`;
- `traceExpIntegrand_nonneg_of_randomSelfAdjoint`;
- `traceExpMoment_nonneg_of_randomSelfAdjoint`.

The proof uses Mathlib's scoped matrix Loewner order, the CFC theorem
`IsSelfAdjoint.exp_nonneg`, and `Matrix.nonneg_iff_posSemidef`. Matrix
Laplace, trace-mgf inequalities, Golden-Thompson, Lieb, Hanson-Wright, and
matrix Bernstein remain unproved.

## Stage MC5.3 - Matrix Laplace Statement Vocabulary

Stage MC5.3 adds `HighDimProb.RandomMatrix.Laplace`.

Implemented declarations:

- `matrixLaplaceRHS`.
- `matrixLaplaceTransformStatement`, a typed upper-tail reduction target over
  `quadraticFormUpperTailEvent`.
- `matrixChernoffFromTraceExpStatement`.
- `selfAdjointOperatorNormLaplaceStatement`, a typed two-sided route using
  trace-exponential moments of `Y` and `-Y`.

Status: vocabulary implemented and API-tested. No matrix Laplace theorem,
operator-norm/lambda-max reduction theorem, trace-mgf theorem, or matrix
Bernstein theorem is proved.

## Stage MB-S5 - Conditional Trace-Exp Markov/Laplace Bridge

MB-S5 adds:

- `traceExpThresholdEvent`;
- `matrixLaplaceRHSLIntegralDiv`;
- `matrixLaplaceRHSLIntegralDiv_eq_matrixLaplaceRHSLIntegral`;
- `traceExpThresholdEvent_lintegral_bound`;
- `matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset`;
- `matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset`.

The proof uses Mathlib's `MeasureTheory.meas_ge_le_lintegral_div` and existing
HighDimProb `traceExpIntegrand`, `traceExpMomentLIntegral`,
`matrixLaplaceRHSLIntegral`, and `quadraticFormUpperTailEvent` vocabulary.

Status: conditional bridge proved and API-tested. The missing pointwise subset
`quadraticFormUpperTailEvent Y t ‚ä?traceExpThresholdEvent Y theta t` is not
proved, so the full matrix Laplace theorem, trace-mgf inequalities,
Golden-Thompson, Lieb, and matrix Bernstein remain unproved.

## Stage MB-S6 - Source-First Conditional Trace-Exp Dominance Bridge

MB-S6 adds:

- `TraceExpDominatesQuadraticFormUpperTail`;
- `traceExpDominatesQuadraticFormUpperTailStatement`;
- `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates`;
- `matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail`;
- `matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail`.

The source survey found book support for the largest-eigenvalue
trace-exponential route, but not a direct proof of the current HighDimProb
`quadraticFormUpperTailEvent` subset without additional spectral/Rayleigh
machinery. The new theorems are therefore conditional wrappers around the
explicit dominance hypothesis and the MB-S5 bridge.

Status: conditional dominance bridge proved and API-tested. MB-S7B-semantic
later proves generic semantic bridges from explicit
`TraceExpDominatesUpperBound` assumptions, and MB-S7B-scalar-endpoint proves
the nonnegative ordered endpoint scalar-multiplication helper.
MB-S7B-exp-spectral-mapping proves `lambdaMaxOrdered_matrixExp`. The `lambdaMaxOrdered`
trace-exp provider theorem is now proved by MB-S7B-provider-close as
`lambdaMaxOrdered_traceExpDominatesUpperBound`. MB-S7C proves the concrete
random-matrix dominance assembly as
`traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint`. The full
matrix Laplace theorem, trace-mgf inequalities, Golden-Thompson, Lieb, and
matrix Bernstein remain unproved.

## Stage MC5.4 - Bernstein Proof-Plan Refinement

Stage MC5.4 keeps `matrixBernsteinSelfAdjointStatement` unchanged in meaning:
it remains an operator-norm tail target for finite independent centered
self-adjoint random-matrix sums. The statement is not rewritten to use
`lambdaMax`, because the Rayleigh bridge and self-adjoint operator-norm
endpoint theorem remain unproved typed targets.

The proof plan now lists the route:

- spectral/quadratic-form event reduction;
- trace-exponential moment bounds;
- matrix Laplace upper-tail reduction;
- two-sided self-adjoint operator-norm reduction using `Y` and `-Y`;
- scalar optimization to the additive Bernstein denominator.

## Next Safe Task

Stage MB-S9-real-to-lintegral-bridge-proof-hardening: prove or sharpen the
explicit real bounded trace-MGF to lintegral trace-MGF bridge target while
keeping the event-subset, Tropp/Lieb, Bernstein CFC, Golden-Thompson, and full
Matrix Bernstein gaps explicit.

## Stage MB-S7A - Spectral Bridge Typed Split

MB-S7A updates only the spectral bridge layer:

- `matrixQuadraticForm_le_lambdaMax_statement` records the missing Rayleigh
  bridge from explicit HighDimProb unit-vector quadratic forms to `lambdaMax`
  as a typed `Prop`.
- `quadraticFormUpperBound_of_lambdaMax_le_of_matrixQuadraticForm_le_lambdaMax`
  and
  `quadraticFormUpperTailEvent_subset_lambdaMaxUpperTailEvent_of_matrixQuadraticForm_le_lambdaMax`
  prove conditional consequences from that explicit Rayleigh hypothesis.
- `lambdaMaxUpperTailEvent` names the lambda-max event used by those
  conditional consequences.
- `not_isUnitVector_fin_zero`, `unitSphere_empty_of_zero_dim`, and
  `quadraticFormUpperTailEvent_empty_of_zero_dim` handle the zero-dimensional
  mismatch without coercing between `Fin n` and `Fin (n + 1)`.

Status: typed split plus conditional helpers are API-tested and judge-tested.
The direct Rayleigh bridge, trace-exp spectral dominance, full matrix Laplace,
trace-mgf, Golden-Thompson, Lieb, Hanson-Wright, and matrix Bernstein remain
unproved.

## Stage MB-S7A-fix - Rayleigh Conversion Helper Bridge

MB-S7A-fix keeps the stage narrow and proves only the conversion helpers that
were source/API-backed:

- `matrixQuadraticForm_nonneg_of_posSemidef` converts Mathlib
  `Matrix.PosSemidef` to nonnegativity of HighDimProb's explicit double-sum
  quadratic form.
- `matrixQuadraticForm_smul_one_of_isUnitVector` evaluates the scalar identity
  quadratic form on an explicit HighDimProb unit vector.
- `matrixQuadraticForm_le_lambdaMax_of_lambdaMax_sub_posSemidef` proves
  `matrixQuadraticForm_le_lambdaMax_statement A hA` from the explicit PSD
  premise `((lambdaMax A hA) ‚Ä?1 - A).PosSemidef`.

Status: helper lemmas proved and API/judge-tested. The direct Rayleigh theorem
remains unproved because the endpoint/order theorem producing
`((lambdaMax A hA) ‚Ä?1 - A).PosSemidef` is still missing. Trace-exp spectral
dominance, full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, Hanson-Wright,
and matrix Bernstein remain unproved.

## Stage MB-S7A-clean - Spectral Bridge API Consolidation

MB-S7A-clean does not prove new spectral mathematics. It consolidates the
spectral bridge surface by naming the repeated endpoint PSD premise:

- `LambdaMaxPSDUpperBound A hA` abbreviates
  `((lambdaMax A hA) ‚Ä?1 - A).PosSemidef`.
- `matrixQuadraticForm_le_lambdaMax_of_lambdaMaxPSDUpperBound` reuses the
  MB-S7A-fix helper to derive `matrixQuadraticForm_le_lambdaMax_statement A hA`
  from that named premise.

Status: API cleanup only, API-tested and judge-tested. The direct Rayleigh
theorem remains unproved. Trace-exp spectral dominance, full matrix Laplace,
trace-mgf, Golden-Thompson, Lieb, Hanson-Wright, and matrix Bernstein remain
unproved.

## Stage MB-S7A-order - Endpoint Ordering Probe

MB-S7A-order did not change the Lean source API. It confirmed that Mathlib's
ordered Hermitian endpoint lives in `Matrix.IsHermitian.eigenvalues‚ÇÄ` and is
controlled by `Matrix.IsHermitian.eigenvalues‚ÇÄ_antitone`. The current
HighDimProb `lambdaMax` wrapper uses `Matrix.IsHermitian.eigenvalues 0`, whose
definition reindexes `eigenvalues‚ÇÄ` through `Fintype.equivOfCardEq`. The missing
bridge is an index-normalization theorem for that reindex, or a compatibility
preserving wrapper around the ordered endpoint.

Status: blocked cleanly with no source API change. Trace-exp spectral
dominance, full matrix Laplace, trace-mgf, Golden-Thompson, Lieb,
Hanson-Wright, and matrix Bernstein remain unproved.

## Stage MB-S7A-index - Ordered Endpoint Wrapper

Stage MB-S7A-index preserves the old `lambdaMax` wrapper and adds the ordered
endpoint route:

- `lambdaMaxOrdered` is definitionally `hA.eigenvalues‚ÇÄ 0`.
- `lambdaMaxOrdered_is_greatest_eigenvalue` is proved from
  `Matrix.IsHermitian.eigenvalues‚ÇÄ_antitone`.
- `lambdaMax_eq_lambdaMaxOrdered_statement` records the unproved legacy
  compatibility bridge.
- `LambdaMaxOrderedPSDUpperBound` and
  `matrixQuadraticForm_le_lambdaMaxOrdered_of_lambdaMaxOrderedPSDUpperBound`
  mirror the existing PSD-premise-to-Rayleigh route for the ordered endpoint.
- `lambdaMaxOrderedUpperTailEvent` and its conditional subset helper support
  future ordered endpoint tail work.

Status: ordered wrapper route implemented, API-tested, and judge-tested. The
unconditional ordered endpoint PSD theorem, direct Rayleigh theorem, trace-exp
spectral dominance, full matrix Laplace, trace-mgf, Golden-Thompson, Lieb,
Hanson-Wright, and matrix Bernstein remain unproved.

## Stage MB-S7A-abstract - Semantic Spectral API

Stage MB-S7A-abstract pauses proof progress and introduces semantic spectral
abstractions:

- `SpectralUpperBound A L` names the PSD/Loewner statement that `L ‚Ä?1 - A` is
  positive semidefinite.
- `RayleighUpperBound A L` names the explicit HighDimProb unit-vector quadratic
  form bound by `L`.
- `scalarUpperTailEvent Z t` and `matrixUpperBoundTailEvent A L t` factor the
  upper-tail event vocabulary away from a concrete eigenvalue provider.
- `rayleighUpperBound_of_spectralUpperBound` and the generic event subset
  lemmas let downstream proofs depend on semantic bounds.

Concrete wrappers such as `lambdaMaxOrdered` are provider routes into the
semantic layer, not the core downstream abstraction. This stage does not prove
`LambdaMaxOrderedPSDUpperBound`, trace-exp spectral dominance, full matrix
Laplace, trace-mgf, Golden-Thompson, Lieb, Hanson-Wright, or matrix Bernstein.

## Stage MB-S7A-provider - Ordered Endpoint Semantic Provider

MB-S7A-provider proves the ordered endpoint provider route:

- `lambdaMaxOrdered_spectralUpperBound` proves
  `SpectralUpperBound A (lambdaMaxOrdered A hA)` for self-adjoint nonempty
  matrices.
- `lambdaMaxOrderedPSDUpperBound` provides the named ordered endpoint PSD
  wrapper.
- `lambdaMaxOrdered_rayleighUpperBound` derives the direct ordered Rayleigh
  bound through `rayleighUpperBound_of_spectralUpperBound`.

The legacy `lambdaMax` API and the typed
`lambdaMax_eq_lambdaMaxOrdered_statement` compatibility target are unchanged.
Trace-exp spectral dominance, full matrix Laplace, trace-mgf, Golden-Thompson,
Lieb, Hanson-Wright, and matrix Bernstein remain unproved.

## Stage MB-S7B-scalar-endpoint - Ordered Endpoint Scalar Multiplication

MB-S7B-scalar-endpoint proves `lambdaMaxOrdered_smul_of_nonneg`, the
nonnegative scalar-multiplication theorem for the canonical ordered endpoint.
This closes the scalar endpoint split for the future trace-exp provider route.
It does not prove the `lambdaMaxOrdered` trace-exp provider theorem,
exponential spectral mapping, trace endpoint theorem, full matrix
Laplace, trace-mgf, Golden-Thompson, Lieb, Hanson-Wright, or matrix Bernstein.

## Stage MB-S7B-exp-spectral-mapping - Ordered Endpoint Matrix Exponential

MB-S7B-exp-spectral-mapping proves `lambdaMaxOrdered_matrixExp`, the ordered
endpoint spectral-mapping theorem for `matrixExp`. This closes the exponential
spectral-mapping split for the future trace-exp provider route. It does not
prove the `lambdaMaxOrdered` trace-exp provider theorem,
trace-dominates-endpoint theorem, full matrix Laplace, trace-mgf,
Golden-Thompson, Lieb, Hanson-Wright, or matrix Bernstein.

## Stage MB-S7B-trace-dominates-endpoint - Ordered Endpoint Trace Domination

MB-S7B-trace-dominates-endpoint proves `lambdaMaxOrdered_le_trace_of_posSemidef`,
the ordered largest endpoint trace bound for positive semidefinite
self-adjoint matrices. This closes the trace endpoint split for the future
trace-exp provider route. It does not prove the `lambdaMaxOrdered` trace-exp
provider theorem, full matrix Laplace, trace-mgf, Golden-Thompson, Lieb,
Hanson-Wright, or matrix Bernstein.

## Stage MB-S7B-provider-close - Ordered Endpoint Trace-Exp Provider

MB-S7B-provider-close proves `lambdaMaxOrdered_traceExpDominatesUpperBound`,
the deterministic trace-exp dominance provider for the canonical ordered
endpoint. This closes the provider split by composing
`lambdaMaxOrdered_smul_of_nonneg`, `lambdaMaxOrdered_matrixExp`, and
`lambdaMaxOrdered_le_trace_of_posSemidef`. It does not prove full matrix
Laplace, trace-mgf, Golden-Thompson, Lieb, Hanson-Wright, or matrix Bernstein.

## Stage MB-S7C-assemble-dominance - Concrete Dominance Assembly

MB-S7C-assemble-dominance proves
`traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint`, assembling the
`lambdaMaxOrdered` Rayleigh provider, the `lambdaMaxOrdered`
`TraceExpDominatesUpperBound` provider, and the generic semantic bridge into
the concrete `TraceExpDominatesQuadraticFormUpperTail` wrapper for random
self-adjoint matrices. It does not prove full matrix Laplace, trace-mgf,
Golden-Thompson, Lieb, Hanson-Wright, or matrix Bernstein.

## Stage MB-S8-laplace-assembly - Concrete LIntegral Laplace Assembly

MB-S8-laplace-assembly proves
`matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint` and
`matrixLaplaceTransformLIntegral_of_randomSelfAdjoint`, the division-RHS and
product-RHS lintegral Laplace wrappers for random self-adjoint matrices under
explicit trace-exp integrand a.e. measurability and `0 <= theta`. This stage
does not prove the real RHS bridge, trace-mgf, Golden-Thompson, Lieb,
Hanson-Wright, or matrix Bernstein.

## Stage MB-S9-Tropp-master-typed-primitive - Typed Tropp/Lieb Primitive

MB-S9-Tropp-master-typed-primitive adds
`troppMasterTraceMGFStep_statement`, a typed-only Tropp master trace-mgf
primitive in `HighDimProb/RandomMatrix/TraceExp.lean`. The statement exposes
self-adjointness, trace-exp integrability, matrix-exponential entrywise
integrability, self-adjointness of `E exp Z`, and strict positivity of
`E exp Z`.

This stage does not prove Lieb concavity, Golden-Thompson, the trace-mgf
provider, the full trace-mgf master theorem, the real RHS bridge, Hanson-Wright,
or matrix Bernstein. This stage was followed by
MB-S9-single-summand-mgf-contract.

## Stage MB-S9-single-summand-mgf-typed-primitive - Typed Single-Summand MGF Primitive

MB-S9-single-summand-mgf-typed-primitive adds
`singleSummandMatrixMGFVarianceProxy_statement`, a typed-only source-backed
single-summand matrix MGF variance-proxy primitive in
`HighDimProb/RandomMatrix/TraceExp.lean`.

The statement exposes self-adjointness, entrywise measurability,
integrability of `X`, `X^2`, and `exp(theta X)`, entrywise zero mean,
pointwise operator-norm boundedness, theta range, self-adjoint/PSD structure
of the deterministic comparison matrix, square/variance-proxy comparison,
and the `MatrixLE` conclusion.

This stage does not prove the scalar-to-matrix functional-calculus bridge,
operator-norm-to-spectral-interval bridge, the trace-mgf provider,
Golden-Thompson, Lieb, Hanson-Wright, or matrix Bernstein. This stage was followed by
MB-S9-bernstein-cfc-typed-primitive.

## Stage MB-S9-bernstein-cfc-typed-primitive - Typed Bernstein CFC Primitive

MB-S9-bernstein-cfc-typed-primitive adds
`bernsteinMatrixExp_le_quadratic_statement`, a typed-only Bernstein-specific
scalar-to-matrix functional-calculus primitive in
`HighDimProb/RandomMatrix/TraceExp.lean`.

The statement exposes self-adjointness, deterministic operator-norm
boundedness, nonnegative radius, theta range, the explicit Bernstein
quadratic coefficient, and the `MatrixLE` conclusion.

This stage does not prove the functional-calculus bridge, single-summand MGF
theorem, operator-norm-to-spectral-interval bridge, the trace-mgf provider,
Golden-Thompson, Lieb, Hanson-Wright, or matrix Bernstein. It was followed by
MB-S9-PSD-expectation-proof.

## Stage MB-S9-PSD-expectation-proof - PSD Expectation Bridge

MB-S9-PSD-expectation-proof proves:

```lean
isPSDMatrix_matrixExpect_of_pointwise_isPSD
matrixExpect_matrixLE_of_pointwise_matrixLE
```

It also adds the direct helper theorems `integrableRandomMatrix_sub` and
`matrixExpect_sub`. This closes the matrix-valued expectation monotonicity
blocker for `MatrixLE` under explicit entrywise integrability assumptions.
It does not prove the functional-calculus bridge, the single-summand MGF
theorem, the trace-mgf provider, Golden-Thompson, Lieb, Hanson-Wright, or
matrix Bernstein. This stage was followed by
MB-S9-expectation-linearity-proof.

## Stage MB-S9-expectation-linearity-proof - Matrix Expectation Linearity

MB-S9-expectation-linearity-proof proves:

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

This closes the small add/smul/zero/constant normalization blocker for the
future single-summand provider. Constant integrability remains explicit through
`[IsFiniteMeasure P]`, and constant expectation normalization over probability
measures uses `[IsProbabilityMeasure P]`. This stage does not prove the
functional-calculus bridge, the single-summand MGF theorem, the trace-mgf
provider, Golden-Thompson, Lieb, Hanson-Wright, or matrix Bernstein. This stage
was followed by MB-S9-matrixle-algebra-proof.

## Stage MB-S9-matrixle-algebra-proof - MatrixLE / PSD Algebra

MB-S9-matrixle-algebra-proof proves:

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

This closes the MatrixLE algebra and RHS-normalization blocker identified by
the single-summand provider proof contract. The stage does not prove the
functional-calculus bridge, the single-summand MGF provider, the trace-mgf
provider, Golden-Thompson, Lieb, Hanson-Wright, or matrix Bernstein. The next
safe task was MB-S9-trace-mgf-to-laplace-tail-contract.

## MB-S9 Bernstein Coefficient Helper

Stage MB-S9-bernstein-coefficient-proof proves `bernsteinCoefficient_nonneg`
for the coefficient `(theta ^ 2 / 2) / (1 - abs theta * R / 3)` under
`abs theta * R < 3`. This closes only the scalar coefficient nonnegativity
blocker for the future single-summand provider. The provider itself remains
unproved. The downstream matrix exponential lower bound was later resolved by
MB-S9-exp-lower-bound-proof. The Bernstein CFC proof, trace-mgf provider,
Golden-Thompson, Lieb, Hanson-Wright, and matrix Bernstein remain unproved.

## MB-S9 Exp Lower Bound

Stage MB-S9-exp-lower-bound-proof proves:

```lean
matrixLE_one_add_self_le_matrixExp_of_selfAdjoint
matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint
```

The first theorem proves `MatrixLE (1 + A) (matrixExp A)` for self-adjoint real
matrices. The second is the scalar-multiple wrapper used by the provider under
explicit CFC assumptions. The stage itself does not prove the single-summand
provider, the Bernstein CFC primitive, trace-mgf provider, Golden-Thompson,
Lieb, Hanson-Wright, or matrix Bernstein.

## MB-S9 Single-Summand Provider Under CFC

Stage MB-S9-single-summand-provider-under-cfc proves:

```lean
singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic
```

The theorem proves the single-summand matrix MGF variance-proxy provider under
an explicit pointwise `bernsteinMatrixExp_le_quadratic_statement` assumption.
It does not prove the Bernstein CFC primitive itself, trace-mgf provider,
Golden-Thompson, Lieb, Hanson-Wright, or matrix Bernstein. The next safe task
was MB-S9-trace-mgf-to-laplace-tail-contract.

## MB-S9 RHS Normalization

Stage MB-S9-rhs-normalization-proof normalizes the bounded Matrix Bernstein
trace-mgf RHS coefficient to:

```lean
bernsteinMGFCoeff theta R =
  (theta ^ 2 / 2) / (1 - abs theta * R / 3)
```

It adds `bernsteinMGFCoeff_nonneg` as a wrapper around the existing scalar
nonnegativity proof, updates the bounded single-summand/CFC typed targets to
use the named coefficient, and exposes the bounded-denominator trace-mgf
targets:

```lean
TraceMGFBernsteinVarianceProxyBound
TraceMGFBernsteinVarianceProxyBoundLIntegral
traceMGFBernsteinVarianceProxyBound_statement
matrixBernsteinTraceMGFWithBernsteinCoeff_statement
```

The old `theta ^ 2 / 2` coefficient target is retained for compatibility but
is not the bounded Bernstein denominator target. This stage does not prove the
trace-mgf provider, Tropp/Lieb primitive, Bernstein CFC primitive,
Golden-Thompson, Lieb, Hanson-Wright, or matrix Bernstein. The next safe task
is MB-S9-trace-mgf-to-laplace-tail-contract.

## MB-S9-tropp-shape-refactor

The trace-exp layer now exposes `troppMasterTraceMGFFiniteFamily_statement`,
a typed-only finite-family Tropp/Lieb iteration primitive for the bounded
Matrix Bernstein trace-mgf route. It links per-summand matrix-MGF `MatrixLE`
comparisons, `iIndepFun` independence, trace-exp integrability, and
`sum_i K_i = bernsteinMGFCoeff theta R ‚Ä?V` normalization to
`TraceMGFBernsteinVarianceProxyBound P (randomMatrixSum X) V theta R`.

The one-step `troppMasterTraceMGFStep_statement` remains available. No Lieb,
Golden-Thompson, trace-mgf provider, or Matrix Bernstein theorem was proved.
The next safe task is
MB-S9-trace-mgf-to-laplace-tail-contract.

## MB-S9 Trace-MGF Thin Wrapper

The bounded trace-MGF provider now has proved thin wrappers from the
finite-family Tropp typed primitive:

```lean
traceMGFBernsteinVarianceProxyBound_of_troppMasterTraceMGFFiniteFamily
matrixBernsteinTraceMGFWithBernsteinCoeff_of_troppMasterTraceMGFFiniteFamily
```

These wrappers only apply explicit finite-family primitive assumptions. The
finite-family Tropp primitive remains typed only, the Bernstein CFC primitive
remains typed only, and no Lieb, Golden-Thompson, or Matrix Bernstein tail
theorem was proved.

Next safe task: MB-S9-real-to-lintegral-bridge-proof-hardening.

## MB-S9 Matrix Bernstein Trace-MGF Under Primitives

The bounded Matrix Bernstein trace-MGF statement is now proved under explicit
primitive assumptions:

```lean
matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives
```

The theorem keeps both analytic primitives explicit:
`troppMasterTraceMGFFiniteFamily_statement` and pointwise
`bernsteinMatrixExp_le_quadratic_statement`. It does not prove Tropp/Lieb,
the Bernstein CFC primitive, Golden-Thompson, or the Matrix Bernstein tail
theorem.

Next safe task: MB-S9-real-to-lintegral-bridge-proof-hardening.
