# Leaf Plan

## Scalar

- Centering
- Variance
- ExpectationBridges
- TailBridges
- IntegrabilityBridges

## Analysis

- RealInequalities
- GammaBounds
- GaussianMomentBounds

## Concentration

- LayerCake
- Markov
- Chebyshev
- Chernoff
- MGF
- SubGaussianSums
- RademacherSums
- Hoeffding
  - Rademacher specialization: implemented in `RademacherSums`
  - Finite unweighted bounded-variable form: conservative, sharp centered, and sharp non-centered versions implemented in `Hoeffding`
  - Finite unweighted milestone: completed in `docs/HoeffdingMilestone.md`
  - Weighted bounded-variable form: implemented in `Hoeffding`
- Bernstein
  - Stage B1: `Concentration/SubExponentialSums.lean`, `Concentration/Bernstein.lean`
  - Stage B1-fix: `Concentration/MaxScale.lean`, normalized raw/lintegral finite-sum MGF, local quadratic Bernstein
  - Stage B2: full scalar Bernstein min-form tail bound under the lintegral predicate
  - Stage SC-closeout: theorem-family import/test/doc audit recorded in `docs/ScalarConcentrationMilestone.md`
  - Stage B3: deterministic weighted scalar Bernstein theorem under the lintegral predicate
  - Stage SC-final: leaf/theorem/test/milestone closure recorded in `docs/Milestone-ScalarConcentration.md`
  - Stage M-real-1: real-exponent `SubGaussianMoment` bridge
  - Stage M-real-2: real-exponent `SubExponentialMoment` bridge
  - Stage SC-final-update: scalar closeout refreshed after both moment bridges
  - Current repository next task:
    RM-negative-trace-mgf-provider-wrapper-audit; the BR natural history/state
    construction remains a separate local leaf. Matrix Bernstein,
    Hanson-Wright, and WLLN/SLLN remain separate future directions
- OrliczToTail
- TailToOrlicz
- MomentImplications
- Implications
- SubGaussianImplications
- SubExponentialImplications

## Distributions

- Rademacher
- RademacherProduct
- BernoulliAtoms
- BoundedSigns

## Vector

- Marginals
- VectorNorms
- Centered
- CovarianceTheorems
- IsotropicTheorems
- SubGaussianVectorTheorems

## Geometry

- CoveringPacking
- MetricEntropyLog
- GaussianWidth
- StableDimension
- ChainingStatements

## RandomMatrix

- SelfAdjoint
- MatrixOrder
- Expectation
- Sums
- VarianceProxy
- ConcentrationStatements
- Spectral
- TraceExp
- Laplace
- IndependentRows
- IidRows
- Algebra
- Statements
- SampleCovarianceAlgebra
- SampleCovarianceTheorems
- UnitSphere
- OperatorNormMeasurability
- OperatorNormNetBridge
- MatrixDeviationStatements
- MatrixBernsteinStatements
- HansonWrightStatements
- JLStatements
- CovarianceEstimationStatements
- Follow-up at the time: Stage MB-S9-trace-mgf-to-laplace-tail-contract. Audit
  the trace-mgf provider route now that the single-summand MGF provider is
  proved under explicit pointwise Bernstein CFC assumptions and the bounded
  Bernstein RHS coefficient is normalized, while the Bernstein CFC primitive
  itself remains typed only. Do not prove Golden-Thompson, Lieb, the full
  trace-mgf provider, or Matrix Bernstein in that contract stage.

## Current RandomMatrix Leaf

### Tropp bookkeeping reduction: prefix/suffix partial sums

- Completed leaf ID: `RM-BR-state-prefix-suffix-partial-sum-api`.
- Purpose: finite-sum/state bookkeeping for the existing `Fin m` Tropp
  conditional-step route.
- New API in `HighDimProb/RandomMatrix/Sums.lean`:
  `comparisonMatrixPrefixSum`, `comparisonMatrixSuffixSum`,
  `randomMatrixPrefixSum`, `randomMatrixSuffixSum`, endpoint/successor
  lemmas, and `randomMatrixSum_eq_prefixSum_last`.
- Abstraction boundary: deterministic comparison-matrix prefix/suffix sums
  live below random-matrix prefix/suffix sums; both remain bookkeeping APIs
  for state construction and do not replace `randomMatrixSum`.
- Scope preserved: this does not prove Lieb, Bernstein CFC, Golden-Thompson,
  Matrix Bernstein, arbitrary finite-index Tropp, or natural history/state
  construction.
- Follow-up completed leaf:
  `RM-lightweight-bookkeeping-bridges`, adding the trace-exp endpoint wrappers
  `traceMatrixExp_randomMatrixPrefixSum_last` and
  `traceMatrixExp_comparisonMatrixPrefixSum_last`, plus example-only
  prefix/state and reindex transport usage modules.
- Boundary preserved: `ConditionalStateEndpointData` is example-local; no
  Lieb, Golden-Thompson, Bernstein CFC, conditional-expectation independence,
  full Matrix Bernstein, or arbitrary finite-index primitive was proved.
- Follow-up completed leaf:
  `RM-MAIN-natural-tropp-matrix-bernstein-pipeline`, adding the natural
  `Fin m` trace state, endpoint theorems, finite-family Tropp provider, and
  trace-MGF provider wrapper.
- Boundary preserved: this remains a TraceExp-level route. It does not prove
  Lieb, Golden-Thompson, Bernstein CFC, independence conditioning,
  trace-exp integrability propagation, full Matrix Bernstein, or a
  public-friendly sample covariance natural-state wrapper.
- Next safe leaf: `RM-MAIN-natural-state-assumption-bundle-contract`.

## Process

- GaussianProcess
- CanonicalMetric
- SubGaussianIncrement
- EmpiricalMeasure
- EmpiricalProcessBounds
- VC

## LimitTheorems

- Basic
- WeakLaw
- Assumptions
- SampleMean
- ConvergenceInProbability
- Independence
- VarianceSums
- StrongLawStatements

## Statements

- ConcentrationStatements
- RandomMatrixStatements
- RandomMatrixConcentrationStatements
- ProcessStatements
- RecoveryStatements

## Tactic

- Measurability
- FinsetSimp
- MatrixEntry
- Tail

## MB-S9 Bernstein Coefficient Leaf Update

- `HighDimProb/RandomMatrix/TraceExp.lean` now contains
  `bernsteinCoefficient_nonneg`, a proved scalar helper for the Bernstein
  coefficient used by the typed CFC and single-summand MGF primitives.
- The single-summand provider remains unproved. The downstream matrix
  exponential lower bound `MatrixLE (1 + c smul V) (matrixExp (c smul V))`, the
  Bernstein CFC primitive proof, trace-mgf provider, Golden-Thompson, Lieb,
  and Matrix Bernstein remain unproved.
- Next safe task was MB-S9-exp-lower-bound-contract.

## MB-S9 Exp Lower Bound Leaf Update

- `HighDimProb/RandomMatrix/TraceExp.lean` now contains
  `matrixLE_one_add_self_le_matrixExp_of_selfAdjoint`, proving
  `MatrixLE (1 + A) (matrixExp A)` for self-adjoint real matrices.
- It also contains `matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint`,
  the scalar-multiple wrapper for downstream single-summand provider work.
- The Bernstein CFC primitive remains typed only, and trace-mgf provider,
  Golden-Thompson, Lieb, full CFC-free single-summand provider, and Matrix
  Bernstein remain unproved.
- Next safe task was MB-S9-trace-mgf-to-laplace-tail-contract.

## MB-S9 Single-Summand Provider Under CFC Leaf Update

- `HighDimProb/RandomMatrix/TraceExp.lean` now contains
  `singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic`,
  proving the single-summand matrix MGF variance-proxy target under an
  explicit pointwise `bernsteinMatrixExp_le_quadratic_statement` assumption.
- The theorem preserves the typed target's explicit centeredness,
  integrability, boundedness, theta-range, self-adjointness, and
  second-moment comparison assumptions.
- The Bernstein CFC primitive itself remains typed only. Tropp/Lieb,
  trace-mgf provider, full CFC-free single-summand provider, and Matrix
  Bernstein remain unproved.
- Next safe task was MB-S9-trace-mgf-to-laplace-tail-contract.

## MB-S9 RHS Normalization Leaf Update

- `HighDimProb/RandomMatrix/TraceExp.lean` now contains
  `bernsteinMGFCoeff`, the canonical bounded Bernstein coefficient
  `(theta ^ 2 / 2) / (1 - abs theta * R / 3)`.
- It also contains `bernsteinMGFCoeff_nonneg`,
  `TraceMGFBernsteinVarianceProxyBound`,
  `TraceMGFBernsteinVarianceProxyBoundLIntegral`, and
  `traceMGFBernsteinVarianceProxyBound_statement`.
- `HighDimProb/RandomMatrix/ConcentrationStatements.lean` now contains
  `matrixBernsteinTraceMGFWithBernsteinCoeff_statement`.
- The retained `TraceMGFVarianceProxyBound` and
  `matrixBernsteinTraceMGF_statement` use `theta ^ 2 / 2` and are not the
  bounded Bernstein denominator target.
- Trace-mgf provider, Tropp/Lieb, Bernstein CFC, full CFC-free
  single-summand provider, and Matrix Bernstein remained open at this leaf.
  Later RM-TROPP work proves only the narrow `Fin m` conditional-step provider
  and conditional-step trace-MGF wrapper; the arbitrary finite-index provider
  remains open.
- MB-S9-tropp-shape-refactor adds
  `troppMasterTraceMGFFiniteFamily_statement`, a typed-only finite-family
  Tropp/Lieb iteration interface consuming per-summand matrix-MGF comparisons
  and bounded-RHS normalization. The one-step Tropp primitive remains
  available. Later RM-TROPP work proves only the narrow `Fin m`
  conditional-step provider and conditional-step trace-MGF wrapper; no Lieb,
  Golden-Thompson, arbitrary finite-index provider, or Matrix Bernstein theorem
  is proved.
- Follow-up at the time: MB-S9-trace-mgf-to-laplace-tail-contract.
## MB-S9 Trace-MGF Thin Wrapper Leaf

- Completed leaf: prove thin wrappers from
  `troppMasterTraceMGFFiniteFamily_statement`.
- New API:
  `traceMGFBernsteinVarianceProxyBound_of_troppMasterTraceMGFFiniteFamily`;
  `matrixBernsteinTraceMGFWithBernsteinCoeff_of_troppMasterTraceMGFFiniteFamily`.
- Scope preserved: no Tropp/Lieb proof, no Bernstein CFC proof, no Matrix
  Bernstein tail proof.
- Next safe leaf:
  MB-S9-trace-mgf-to-laplace-tail-contract.

## MB-S9 Matrix Bernstein Trace-MGF Under Primitives Leaf

- Completed leaf: prove high-level bounded Matrix Bernstein trace-MGF under
  explicit finite-family Tropp and pointwise Bernstein CFC primitive
  assumptions.
- New API: `matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives`.
- Scope preserved: no Tropp/Lieb proof, no Bernstein CFC proof, no Matrix
  Bernstein tail proof.
- Next safe leaf: MB-S9-trace-mgf-to-laplace-tail-contract.
