# Matrix Concentration Plan

## Summary

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
| Matrix square and variance proxy | `matrixSquare`, `randomMatrixSquare`, `matrixSecondMoment`, `matrixVarianceProxy`, `MatrixVarianceProxy`, `matrixVarianceProxyBound`, `MatrixVarianceProxyBound`, `deterministicMatrixVarianceProxyNorm`, `matrixVarianceProxyNorm` | implemented; square measurability and self-adjoint square structural lemma proved | `HighDimProb/RandomMatrix/VarianceProxy.lean` |
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

## Remaining TODOs

- Prove PSD facts for `matrixSecondMoment` and `matrixVarianceProxy` under
  self-adjoint hypotheses in the explicit `IsPSDMatrix` order.
- Add matrix Laplace-transform and trace/exponential-moment infrastructure
  before attempting matrix Bernstein.
- Decide whether future matrix Bernstein should use pointwise or a.e.
  operator-norm boundedness as its primary public assumption.
- Upgrade `sampleCovarianceOperatorNormViaUnitSphereStatement` only after the
  required supremum/unit-sphere or net argument is selected.
- Add independent-row and iid-row assumptions if covariance-estimation proofs
  need them.
- Add centered empirical covariance conventions beyond the current uncentered
  `sampleCovariance`.

## Next Safe Task

Stage MC4 - matrix Bernstein theorem statement refinement and proof plan.
