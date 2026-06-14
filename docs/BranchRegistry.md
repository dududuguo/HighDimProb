# Branch Registry

This registry records the intended root-to-branch-to-leaf layout for HighDimProb.
It is a planning document, not a request to physically move existing files.

## Scalar

- Branch name: Scalar
- Import path: `HighDimProb.Scalar`
- Status: stable
- Purpose: one-dimensional probability infrastructure.
- Current modules: `Basic`, `ProbabilitySpace`, `RandomVariable`, `Distribution`, `Expectation`, `Tail`, `Lp`, `Moment`, `Scalar.Centering`, `Scalar.Variance`, `Orlicz`, `SubGaussian`, `SubExponential`.
- Planned leaf modules: scalar expectation bridge lemmas, scalar integrability bridge lemmas, scalar tail bridge lemmas.
- Dependencies: `HighDimProb.Init` and Mathlib probability, measure, integration, Lp, moment, Orlicz-style, and MGF APIs already used by the stable layer.
- Forbidden scope: random vector, random matrix, and concentration theorem families beyond small scalar wrappers.
- Promotion criteria: already stable; new leaves need focused API tests, docs, status updates, and a root import audit.
- Next safe tasks: scalar expectation bridge cleanup; scalar tail bridge cleanup.

## Analysis

- Branch name: Analysis
- Import path: `HighDimProb.Analysis`
- Status: experimental helper branch
- Purpose: small deterministic real-analysis lemmas used by probability and concentration proof layers.
- Current modules: `Analysis.RealInequalities`.
- Planned leaf modules: only targeted real inequalities needed by active proof stages; no broad analysis library yet.
- Dependencies: Mathlib real logarithm, exponential, square-root, and tactic APIs.
- Forbidden scope: probability assumptions, concentration theorem statements, and optional analytic dependencies.
- Promotion criteria: focused helper tests, downstream proof reuse, docs, status update, and root import audit.
- Next safe tasks: targeted deterministic helper lemmas only when a proof stage
  needs them; the current subGaussian and subExponential moment bridges are
  complete.

## Concentration

- Branch name: Concentration
- Import path: `HighDimProb.Concentration`
- Status: experimental
- Purpose: scalar concentration theorem proof spine.
- Current modules: `Concentration.Basic`, `Concentration.Markov`, `Concentration.Chebyshev`, `Concentration.LayerCake`, `Concentration.OrliczToTail`, `Concentration.TailToOrlicz`, `Concentration.MomentImplications`, `Concentration.MGF`, `Concentration.MaxScale`, `Concentration.SubGaussianSums`, `Concentration.SubExponentialSums`, `Concentration.Bernstein`, `Concentration.RademacherSums`, `Concentration.Hoeffding`, `Concentration.Implications`.
- Planned leaf modules: centered/specialized `Chebyshev` extensions, reverse MGF formulation links, finite-gauge implication links, raw-predicate Bernstein variants, and future concentration families after their prerequisites are ready.
- Dependencies: `Scalar`, `Tail`, `Expectation`, `Lp`, `Orlicz`, `SubGaussian`, `SubExponential`.
- Forbidden scope: random matrix concentration, Hanson-Wright, and covariance estimation.
- Promotion criteria: focused theorem statements/proofs, proof-pilot tests, docs, status update, and stable-root import audit.
- Next safe tasks: reverse/source MGF links, finite-gauge implication links, and
  raw-predicate Bernstein variants are the remaining scalar-only cleanup items.
  The bounded Hoeffding family, including weighted centered and non-centered
  forms, is recorded in `docs/HoeffdingMilestone.md`; Stage B1/B1-fix/B2/B3
  records the Bernstein scaffold, max-scale infrastructure, scalar min-form
  theorem, and deterministic weighted theorem in `docs/BernsteinPlan.md`; Stage
  SC-final-update records the audited scalar theorem-family surface after the
  full subGaussian and subExponential moment bridges.

## Distributions

- Branch name: Distributions
- Import path: `HighDimProb.Distributions`
- Status: experimental
- Purpose: small concrete distribution-level atoms used by concentration proof branches.
- Current modules: `Distributions.Rademacher`, `Distributions.RademacherFamily`.
- Planned leaf modules: `RademacherProduct`, `BoundedSigns`, `GaussianAtoms`, `BernoulliAtoms`.
- Dependencies: `Scalar`, `Concentration.MGF`, Mathlib PMF and distribution APIs.
- Forbidden scope: a broad probability distribution hierarchy, independent-sum concentration theorems, and canonical subGaussian predicates.
- Promotion criteria: focused API tests, theorem atlas entries, status updates, and stable-root import audit.
- Next safe tasks: distribution work should remain separate from scalar
  concentration theorem-family scaffolds; after Stage SC-final-update, larger
  theorem work should be chosen deliberately rather than routed through the
  distribution branch.

## Vector

- Branch name: Vector
- Import path: `HighDimProb.Vector`
- Status: experimental
- Purpose: finite-dimensional random vector infrastructure.
- Current modules: `RandomVector`, `Covariance`, `Isotropic`, `SubGaussianVector`.
- Planned leaf modules: `CenteredVector`, `Marginals`, `VectorNorms`, `VectorMoments`, `IsotropicTheorems`, `SubGaussianVectorImplications`.
- Dependencies: `Scalar`, Mathlib finite sums, functions over `Fin`, matrices for covariance objects, and scalar expectation/integrability APIs.
- Forbidden scope: matrix-specific sample covariance and random process theory.
- Promotion criteria: object API tests, proof-pilot tests for bridge lemmas, docs, status update, and stable-root import audit.
- Next safe tasks: vector bridge cleanup; vector theorem statement allocation.

## Geometry

- Branch name: Geometry
- Import path: `HighDimProb.Geometry`
- Status: experimental
- Purpose: metric entropy and probabilistic geometry vocabulary.
- Current modules: `Nets`, `MetricEntropy`, `MetricEntropyStatements`, `GaussianWidth`.
- Planned leaf modules: `CoveringPacking`, `EntropyNumbers`, `GaussianWidth`, `GaussianComplexity`, `StableDimension`, `ChainingStatements`.
- Dependencies: Mathlib metric covering/packing APIs, `Statements`, and later vector/process/random-matrix APIs where theorem statements require them.
- Forbidden scope: random matrix entries/rows and empirical process proofs unless `Process` imports this branch.
- Promotion criteria: stable object APIs, import tests, theorem atlas updates, docs, status update, and stable-root import audit.
- Next safe tasks: covering/packing bridge cleanup; Gaussian width vocabulary stage.

## RandomMatrix

- Branch name: RandomMatrix
- Import path: `HighDimProb.RandomMatrix`
- Status: experimental physical branch
- Purpose: random matrix object layer and theorem prerequisites.
- Current modules: `RandomMatrix.Basic`, `RandomMatrix.RowsCols`, `RandomMatrix.Action`, `RandomMatrix.Norms`, `RandomMatrix.Assumptions`, `RandomMatrix.SampleCovariance`, `RandomMatrix.QuadraticForm`, `RandomMatrix.Algebra`, `RandomMatrix.UnitSphere`, `RandomMatrix.OperatorNorm`, `RandomMatrix.SelfAdjoint`, `RandomMatrix.MatrixOrder`, `RandomMatrix.Expectation`, `RandomMatrix.Sums`, `RandomMatrix.VarianceProxy`, `RandomMatrix.Spectral`, `RandomMatrix.TraceExp`, `RandomMatrix.Laplace`, `RandomMatrix.Statements`, `RandomMatrix.ConcentrationStatements`.
- Planned leaf modules: `IndependentRows`, `IidRows`, `SampleCovarianceTheorems`, `MatrixDeviationProofs`, `MatrixBernsteinProofs`, `HansonWrightStatements`, `JLStatements`, `CovarianceEstimationProofs`, `OperatorNormNetBridge`.
- Dependencies: `Scalar`, `Vector`, `Geometry`, Mathlib matrices, finite sums, and scoped L2 operator norm APIs.
- Forbidden scope: proving matrix concentration before matrix Laplace-transform, variance-proxy, and covariance-estimation prerequisites are ready.
- Promotion criteria: submodule API tests, theorem atlas dependencies, docs, status update, and stable-root import audit.
- Next safe tasks: Stage MB-S9-trace-mgf-to-laplace-tail-contract:
  audit the trace-mgf provider route now that the single-summand provider
  under explicit pointwise Bernstein CFC assumptions is proved, while the
  Bernstein CFC primitive itself remains typed only.
  Matrix Bernstein remains forbidden until its missing bridges are proved.
  Independent-row/iid-row vocabulary remains separate until
  covariance-estimation proof work starts.

## Process

- Branch name: Process
- Import path: `HighDimProb.Process`
- Status: experimental / reserved
- Purpose: random processes, empirical processes, Gaussian processes.
- Current modules: `RandomProcess`, `EmpiricalProcess`.
- Planned leaf modules: `GaussianProcess`, `SubGaussianIncrement`, `CanonicalMetric`, `EmpiricalMeasure`, `VC`, `UniformDeviation`, `Chaining`.
- Dependencies: `Scalar`, later `Geometry`, and selected vector vocabulary when needed.
- Forbidden scope: algorithmic learning applications and signal recovery application proofs.
- Promotion criteria: object API tests, docs, theorem atlas dependencies, status update, and stable-root import audit.
- Next safe tasks: random process vocabulary stage; empirical process vocabulary stage.

## LimitTheorems

- Branch name: LimitTheorems
- Import path: `HighDimProb.LimitTheorems`
- Status: experimental / reserved
- Purpose: limit theorem vocabulary and typed theorem targets such as weak laws of large numbers.
- Current modules: `LimitTheorems.Basic`, `LimitTheorems.WeakLaw`, `LimitTheorems.Assumptions`.
- Planned leaf modules: `WeakLaw`, `ConvergenceInProbability`, `SampleMean`, `Assumptions`, `VarianceSums`, `StrongLawStatements`.
- Dependencies: `Scalar`, `Concentration.Chebyshev`, Mathlib finite sums, integrability, and `MeasureTheory.TendstoInMeasure`.
- Forbidden scope: strong law proofs, Kolmogorov SLLN, Borel-Cantelli, and measure-theoretic convergence theorem proofs.
- Promotion criteria: object API tests, theorem atlas dependencies, docs, status update, and stable-root import audit.
- Next safe tasks: sample mean expectation and variance bridge design; convergence-in-probability alias decision.

## Statements

- Branch name: Statements
- Import path: `HighDimProb.Statements`
- Status: stable for typed specs, not theorem proofs
- Purpose: typed `Prop` statement layer and theorem atlas bridge.
- Current modules: `BookStatements`, `MetricEntropyStatements`, and branch-owned typed statement modules such as `RandomMatrix.Statements` and `RandomMatrix.ConcentrationStatements`.
- Planned leaf modules: `ConcentrationStatements`, `RandomMatrixStatements`, `GaussianWidthStatements`, `ProcessStatements`, `RecoveryStatements`.
- Dependencies: current object-layer branches needed to type each specification.
- Forbidden scope: unproved theorem/lemma declarations and axioms.
- Promotion criteria: typed specs must be backed by existing objects, tests, docs, theorem atlas entries, and no fake proofs.
- Next safe tasks: concentration statement allocation; random matrix statement allocation.

## Tactic

- Branch name: Tactic
- Import path: `HighDimProb.Tactic`
- Status: reserved
- Purpose: future automation.
- Current modules: `Tactic`.
- Planned leaf modules: `highdim_prob` tactic, norm/tail simplification, finite-sum simplification, measurability automation, matrix-entry extensionality helpers.
- Dependencies: proof-pilot lessons and safe normal-form lemmas.
- Forbidden scope: fragile automation in stable modules before proof pilots validate it.
- Promotion criteria: local proof-pilot use, documented simp behavior, tests, and no broad unstable automation.
- Next safe tasks: tactic design notes after more proof pilots.

## Experimental

- Branch name: Experimental
- Import path: `HighDimProb.Experimental`
- Status: experimental aggregate
- Purpose: single import for v0.2+ branch APIs.
- Current imports: `Vector`, `Geometry`, `Concentration`, `RandomMatrix`, `LimitTheorems`, `Process`, `SignalRecovery`, `Tactic`.
- Planned leaf modules: none directly; leaves belong under their owning branch.
- Dependencies: experimental branch aggregates.
- Forbidden scope: stable API promotion by accident and new declarations inside the aggregate.
- Promotion criteria: not promoted as a whole; branches are promoted individually.
- Next safe tasks: keep aggregate synchronized with reserved and experimental branches.

## Judge

- Branch name: Judge
- Import path: `HighDimProbJudge`
- Status: external-facing compile-time judge library
- Purpose: lightweight OJ-style API and policy checks for downstream users.
- Current modules: `Smoke`, `StableImports`, `Concentration.BasicUse`,
  `Concentration.OrliczTailUse`, `Concentration.MomentUse`,
  `Concentration.RademacherUse`, `Concentration.SumsUse`,
  `Concentration.HoeffdingUse`, `Concentration.BernsteinUse`,
  `Concentration.SubGaussianUse`, `RandomMatrix.OperatorNormUse`,
  `RandomMatrix.StatementUse`, `RandomMatrix.PSDUse`,
  `RandomMatrix.SampleCovarianceUse`, `RandomMatrix.VarianceProxyUse`,
  `RandomMatrix.SpectralUse`, `RandomMatrix.TraceExpUse`,
  `RandomMatrix.LaplaceUse`, and `RandomMatrix.MatrixBernsteinUse`.
- Dependencies: public `HighDimProb`, `HighDimProb.Concentration`, and
  `HighDimProb.RandomMatrix` imports.
- Forbidden scope: new theorem proving, theorem meaning changes, and hidden
  promotion of experimental modules into the stable root.
- Promotion criteria: not a stable API branch; it is built with
  `lake build HighDimProbJudge` and guarded by
  `scripts/judge_policy_check.py`.
- Next safe tasks: add judge coverage for geometry, vector, and
  limit-theorem APIs after the current matrix Bernstein bridge surface remains
  green.

## MC4-cleanup -> Matrix Concentration Statement Honesty

- Stage: MC4-cleanup
- Date: 2026-02-03 (approximate)
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/VarianceProxy.lean`,
  `HighDimProb/RandomMatrix/ConcentrationStatements.lean`
- Test modules: `HighDimProbTest/RandomMatrixConcentrationAPI.lean`,
  `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean`
- Docs: `docs/MatrixBernsteinProofPlan.md`, `docs/MatrixConcentrationPlan.md`,
  `docs/TheoremAtlas.md`, `docs/Status.md`, `docs/AbstractionLog.md`
- New declarations: `IntegrableRandomMatrix`, `matrixBernsteinSelfAdjointStatement`,
  `operatorNorm_eq_spectralRadius_of_selfAdjointStatement`,
  `HighProbabilityBound`, `highProbabilityBound`,
  `isSelfAdjointMatrix_matrixSecondMoment`,
  `isSelfAdjointMatrix_matrixVarianceProxy`,
  `isPSD_matrixSquare_of_selfAdjoint_statement`,
  `isPSD_matrixSecondMoment_of_selfAdjoint_statement`,
  `isPSD_matrixVarianceProxy_of_selfAdjoint_statement`
- Removed placeholders: `matrixLaplaceTransformStatement` and
  `traceExpMomentBoundStatement`; matrix Laplace and trace exponential work is
  documentation-only until honest typed objects exist.
- Proven: self-adjointness of `matrixSecondMoment` and `matrixVarianceProxy`

## MB-S1 Matrix Bernstein Mainline PSD Algebra

- Stage: MB-S1
- Date: 2026-06-06
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/MatrixOrder.lean`,
  `HighDimProb/RandomMatrix/VarianceProxy.lean`,
  `HighDimProb/RandomMatrix/ConcentrationStatements.lean`
- Test modules: `HighDimProbTest/RandomMatrixConcentrationAPI.lean`,
  `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean`,
  `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean`
- New declarations: `matrixQuadraticForm_sum`, `isPSDMatrix_sum`,
  `matrixQuadraticForm_matrixSquare_eq_matVecSqNorm_of_selfAdjoint`,
  `isPSD_matrixSquare_of_selfAdjoint`, `matrixQuadraticForm_matrixExpect`,
  `isPSD_matrixSecondMoment_of_selfAdjoint`,
  `isPSD_matrixVarianceProxy_of_selfAdjoint`
- Proven: PSD square, PSD second moment under square integrability, and PSD
  matrix variance proxy under per-summand square integrability.
- Blocked: lambda-max/spectral tail bridge, matrix Laplace transform, trace
  exponential machinery, and Golden-Thompson/Lieb-style prerequisites.

## MB-S7A Spectral Bridge Typed Split

- Stage: MB-S7A
- Date: 2026-06-07
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/Spectral.lean`
- Test modules: `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- New declarations: `matrixQuadraticForm_le_lambdaMax_statement`,
  `quadraticFormUpperBound_of_lambdaMax_le_of_matrixQuadraticForm_le_lambdaMax`,
  `lambdaMaxUpperTailEvent`,
  `quadraticFormUpperTailEvent_subset_lambdaMaxUpperTailEvent_of_matrixQuadraticForm_le_lambdaMax`,
  `not_isUnitVector_fin_zero`, `unitSphere_empty_of_zero_dim`, and
  `quadraticFormUpperTailEvent_empty_of_zero_dim`.
- Proven: conditional quadratic-form/lambda-max bound and event helpers under
  the explicit Rayleigh bridge hypothesis; zero-dimensional unit-sphere and
  upper-tail events are empty.
- Typed only: direct Rayleigh bridge from explicit `matrixQuadraticForm` /
  `IsUnitVector` to `lambdaMax`.
- Blocked: direct Rayleigh proof, trace-exp spectral dominance, full matrix
  Laplace, trace-mgf, Golden-Thompson, Lieb, and matrix Bernstein.

## MB-S7A-fix Rayleigh Conversion Helper Bridge

- Stage: MB-S7A-fix
- Date: 2026-06-07
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/Spectral.lean`
- Test modules: `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- New declarations: `matrixQuadraticForm_nonneg_of_posSemidef`,
  `matrixQuadraticForm_smul_one_of_isUnitVector`, and
  `matrixQuadraticForm_le_lambdaMax_of_lambdaMax_sub_posSemidef`.
- Proven: Mathlib PSD implies nonnegativity of the explicit HighDimProb
  quadratic form; scalar identity matrices evaluate to the scalar on explicit
  unit vectors; the Rayleigh typed statement follows from the explicit PSD
  premise `((lambdaMax A hA) smul 1 - A).PosSemidef`.
- Typed only: direct Rayleigh bridge from explicit `matrixQuadraticForm` /
  `IsUnitVector` to `lambdaMax`.
- Blocked: endpoint-order/PSD bridge for `lambdaMax`, trace-exp spectral
  dominance, full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, and matrix
  Bernstein.

## MB-S7A-clean Spectral Bridge API Consolidation

- Stage: MB-S7A-clean
- Date: 2026-06-07
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/Spectral.lean`
- Test modules: `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- New declarations: `LambdaMaxPSDUpperBound` and
  `matrixQuadraticForm_le_lambdaMax_of_lambdaMaxPSDUpperBound`.
- Proven: only a wrapper over the existing endpoint-PSD helper; no endpoint
  spectral theorem was proved.
- Compatibility: all MB-S7A and MB-S7A-fix names are preserved.
- Blocked: prove `LambdaMaxPSDUpperBound A hA` from endpoint ordering,
  trace-exp spectral dominance, full matrix Laplace, trace-mgf,
  Golden-Thompson, Lieb, and matrix Bernstein.

## MB-S7A-order Endpoint Ordering Probe

- Stage: MB-S7A-order
- Date: 2026-06-07
- Branch: RandomMatrix (experimental)
- Leaf modules touched: none
- Test modules touched: none
- Judge modules touched: none
- New declarations: none
- Result: blocked cleanly. Mathlib provides ordered endpoint control through
  `Matrix.IsHermitian.eigenvalues₀_antitone`, but current `lambdaMax` is based
  on the reindexed `Matrix.IsHermitian.eigenvalues`.
- Blocked: prove an index-normalization/compatibility bridge from current
  `lambdaMax` to the ordered `eigenvalues₀ 0` endpoint. Trace-exp spectral
  dominance, full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, and matrix
  Bernstein remain unproved.

## MB-S7A-index Ordered Endpoint Wrapper

- Stage: MB-S7A-index
- Date: 2026-06-07
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/Spectral.lean`
- Test modules: `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- New declarations: `lambdaMaxOrdered`,
  `lambdaMaxOrdered_eq_eigenvalues₀_zero`,
  `lambdaMax_eq_lambdaMaxOrdered_statement`,
  `lambdaMaxOrdered_is_greatest_eigenvalue_statement`,
  `lambdaMaxOrdered_is_greatest_eigenvalue`,
  `LambdaMaxOrderedPSDUpperBound`,
  `matrixQuadraticForm_le_lambdaMaxOrdered_statement`,
  `matrixQuadraticForm_le_lambdaMaxOrdered_of_lambdaMaxOrderedPSDUpperBound`,
  `lambdaMaxOrderedUpperTailEvent`, and
  `quadraticFormUpperTailEvent_subset_lambdaMaxOrderedUpperTailEvent_of_matrixQuadraticForm_le_lambdaMaxOrdered`.
- Proven: ordered endpoint is definitionally `eigenvalues₀ 0`, ordered endpoint
  greatest theorem, and conditional ordered PSD-premise-to-Rayleigh/event
  helpers.
- Compatibility: existing public `lambdaMax` is preserved unchanged; the
  legacy-to-ordered bridge remains typed as
  `lambdaMax_eq_lambdaMaxOrdered_statement`.
- Blocked: prove `LambdaMaxOrderedPSDUpperBound A hA` or an equivalent ordered
  Rayleigh bridge. Trace-exp spectral dominance, full matrix Laplace,
  trace-mgf, Golden-Thompson, Lieb, and matrix Bernstein remain unproved.

## MB-S7A-abstract Semantic Spectral API

- Stage: MB-S7A-abstract
- Date: 2026-06-07
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/Spectral.lean`
- Test modules: `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- New declarations: `SpectralUpperBound`, `RayleighUpperBound`,
  `scalarUpperTailEvent`, `matrixUpperBoundTailEvent`,
  `rayleighUpperBound_of_spectralUpperBound`,
  `quadraticFormUpperTailEvent_subset_scalarUpperTailEvent_of_rayleighUpperBound`,
  `quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_rayleighUpperBound`,
  `quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_spectralUpperBound`,
  `spectralUpperBound_of_lambdaMaxPSDUpperBound`,
  `spectralUpperBound_of_lambdaMaxOrderedPSDUpperBound`,
  `lambdaMaxUpperTailEvent_eq_matrixUpperBoundTailEvent`, and
  `lambdaMaxOrderedUpperTailEvent_eq_matrixUpperBoundTailEvent`.
- Proven: semantic PSD-to-Rayleigh bridge and generic event subset bridges from
  explicit semantic assumptions.
- Compatibility: existing public `lambdaMax` and `lambdaMaxOrdered` APIs are
  preserved as concrete provider routes.
- Follow-up: proving that `lambdaMaxOrdered` provides `SpectralUpperBound` was
  resolved later in MB-S7A-provider. Trace-exp spectral dominance, full matrix
  Laplace, trace-mgf, Golden-Thompson, Lieb, and matrix Bernstein remain
  unproved.

## MB-S7A-provider Ordered Endpoint Semantic Provider

- Stage: MB-S7A-provider
- Date: 2026-06-07
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/Spectral.lean`
- Test modules: `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- New declarations: `lambdaMaxOrdered_spectralUpperBound`,
  `lambdaMaxOrderedPSDUpperBound`, and `lambdaMaxOrdered_rayleighUpperBound`.
- Proven: the canonical ordered endpoint wrapper provides
  `SpectralUpperBound`; the named ordered PSD provider wrapper and direct
  ordered Rayleigh wrapper follow by the semantic route.
- Compatibility: existing public `lambdaMax` and `lambdaMaxOrdered` APIs are
  preserved; `lambdaMax_eq_lambdaMaxOrdered_statement` remains a typed
  compatibility target.
- Blocked: trace-exp spectral dominance, full matrix Laplace, trace-mgf,
  Golden-Thompson, Lieb, and matrix Bernstein remain unproved.

## MB-S7B-semantic Trace-Exp Semantic Dominance Bridge

- Stage: MB-S7B-semantic
- Date: 2026-06-07
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/Laplace.lean`
- Test modules: `HighDimProbTest/RandomMatrixLaplaceAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`
- New declarations: `TraceExpDominatesUpperBound`,
  `matrixUpperBoundTailEvent_subset_traceExpThresholdEvent_of_traceExpDominatesUpperBound`,
  `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_rayleighUpperBound_of_traceExpDominatesUpperBound`,
  `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_spectralUpperBound_of_traceExpDominatesUpperBound`,
  `traceExpDominatesQuadraticFormUpperTail_of_rayleighUpperBound_of_traceExpDominatesUpperBound`,
  and
  `traceExpDominatesQuadraticFormUpperTail_of_spectralUpperBound_of_traceExpDominatesUpperBound`.
- Proven: generic event bridges from explicit semantic upper-bound and
  trace-exp dominance assumptions to the existing MB-S6 dominance predicate.
- Blocked: `lambdaMaxOrdered` trace-exp provider theorem, spectral mapping,
  full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, and matrix Bernstein
  remain unproved.

## MB-S7B-scalar-endpoint Ordered Endpoint Scalar Multiplication

- Stage: MB-S7B-scalar-endpoint
- Date: 2026-06-07
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/Spectral.lean`
- Test modules: `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- New declarations: `lambdaMaxOrdered_smul_of_nonneg`.
- Proven: nonnegative scalar multiplication for the canonical ordered endpoint.
- Did not prove: `lambdaMaxOrdered` trace-exp provider theorem, exponential
  spectral mapping, trace endpoint theorem, full matrix Laplace, trace-mgf,
  Golden-Thompson, Lieb, or matrix Bernstein.

## MB-S7B-exp-spectral-mapping Ordered Endpoint Matrix Exponential

- Stage: MB-S7B-exp-spectral-mapping
- Date: 2026-06-07
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/TraceExp.lean`
- Test modules: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- New declarations: `lambdaMaxOrdered_matrixExp`.
- Proven: ordered endpoint spectral mapping for `matrixExp`.
- Did not prove: `lambdaMaxOrdered` trace-exp provider theorem, trace endpoint
  theorem, full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, or matrix
  Bernstein.

## MB-S7B-trace-dominates-endpoint Ordered Endpoint Trace Domination

- Stage: MB-S7B-trace-dominates-endpoint
- Date: 2026-06-07
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/Spectral.lean`
- Test modules: `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- New declarations: `lambdaMaxOrdered_le_trace_of_posSemidef`.
- Proven: ordered endpoint trace domination for positive semidefinite
  self-adjoint matrices.
- Blocked: `lambdaMaxOrdered` trace-exp provider theorem, full matrix Laplace,
  trace-mgf, Golden-Thompson, Lieb, and matrix Bernstein remain unproved.

## MB-S7B-provider-close Ordered Endpoint Trace-Exp Provider

- Stage: MB-S7B-provider-close
- Date: 2026-06-07
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/Laplace.lean`
- Test modules: `HighDimProbTest/RandomMatrixLaplaceAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`
- New declarations: `lambdaMaxOrdered_traceExpDominatesUpperBound`.
- Proven: deterministic trace-exp dominance provider for `lambdaMaxOrdered`
  under explicit `0 <= theta`.
- Blocked: full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, and matrix
  Bernstein remain unproved.

## MB-S7C-assemble-dominance Concrete Dominance Assembly

- Stage: MB-S7C-assemble-dominance
- Date: 2026-06-07
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/Laplace.lean`
- Test modules: `HighDimProbTest/RandomMatrixLaplaceAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`
- New declarations:
  `traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint`.
- Proven: concrete `TraceExpDominatesQuadraticFormUpperTail` assembly for
  random self-adjoint matrices under explicit `0 <= theta`.
- Blocked: full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, and matrix
  Bernstein remain unproved.

## MB-S8-laplace-assembly Concrete LIntegral Laplace Assembly

- Stage: MB-S8-laplace-assembly
- Date: 2026-06-07
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/Laplace.lean`
- Test modules: `HighDimProbTest/RandomMatrixLaplaceAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`
- New declarations:
  `matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint`,
  `matrixLaplaceTransformLIntegral_of_randomSelfAdjoint`.
- Proven: concrete division-RHS and product-RHS lintegral Laplace wrappers for
  random self-adjoint matrices under explicit trace-exp integrand a.e.
  measurability and `0 <= theta`.
- Blocked: real RHS bridge, trace-mgf, Golden-Thompson, Lieb, and matrix
  Bernstein remain unproved.

## MB-S9-foundation Trace-MGF / Variance-Proxy Foundation

- Stage: MB-S9-foundation
- Date: 2026-06-07
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/TraceExp.lean`,
  `HighDimProb/RandomMatrix/VarianceProxy.lean`,
  `HighDimProb/RandomMatrix/ConcentrationStatements.lean`
- Test modules: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`,
  `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`,
  `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean`,
  `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`,
  `HighDimProbJudge/RandomMatrix/StatementUse.lean`
- New declarations: `TraceMGFBound`, `TraceMGFBoundLIntegral`,
  `TraceMGFVarianceProxyBound`, `TraceMGFVarianceProxyBoundLIntegral`,
  `MatrixVarianceProxyUpperBound`, `MatrixVarianceProxyNormBound`,
  `traceMGFBound_statement`, `traceMGFBoundLIntegral_statement`,
  `traceMGFVarianceProxyBound_statement`, and
  `matrixBernsteinTraceMGF_statement`.
- Proven: semantic definitions and typed targets only; no hard analytic
  theorem.
- Blocked: Golden-Thompson, Lieb, the full trace-mgf master theorem, the real
  RHS bridge, and matrix Bernstein remain unproved.

## MB-S9-Tropp-master-typed-primitive Tropp Master Typed Primitive

- Stage: MB-S9-Tropp-master-typed-primitive
- Date: 2026-06-08
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/TraceExp.lean`
- Test modules: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- New declarations: `troppMasterTraceMGFStep_statement`.
- Proven: no new theorem; typed Tropp/Lieb primitive only.
- Blocked: Lieb concavity, Golden-Thompson, trace-mgf provider, full
  trace-mgf master theorem, real RHS bridge, and matrix Bernstein remain
  unproved.

## MB-S9-single-summand-mgf-typed-primitive Single-Summand MGF Typed Primitive

- Stage: MB-S9-single-summand-mgf-typed-primitive
- Date: 2026-06-08
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/TraceExp.lean`
- Test modules: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- New declarations: `singleSummandMatrixMGFVarianceProxy_statement`.
- Proven: no new theorem; typed single-summand matrix MGF primitive only.
- Blocked: scalar-to-matrix functional calculus bridge, matrix-valued
  expectation monotonicity, operator-norm-to-spectral-interval bridge,
  trace-mgf provider, Golden-Thompson, Lieb, real RHS bridge, and matrix
  Bernstein remain unproved.

## MB-S9-bernstein-cfc-typed-primitive Bernstein CFC Typed Primitive

- Stage: MB-S9-bernstein-cfc-typed-primitive
- Date: 2026-06-08
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/TraceExp.lean`
- Test modules: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- New declarations: `bernsteinMatrixExp_le_quadratic_statement`.
- Proven: no new theorem; typed Bernstein-specific scalar-to-matrix CFC
  primitive only.
- Blocked: functional-calculus proof, single-summand MGF theorem,
  operator-norm-to-spectral-interval bridge, trace-mgf provider,
  Golden-Thompson, Lieb, real RHS bridge, and matrix Bernstein remain
  unproved.

## MB-S9-tropp-shape-refactor Tropp Interface Shape

- Stage: MB-S9-tropp-shape-refactor
- Date: 2026-06-09
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/TraceExp.lean`
- Test modules: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- New declarations: `troppMasterTraceMGFFiniteFamily_statement`.
- Proven: none; the declaration is a typed `Prop` interface only.
- Blocked: Lieb/Tropp finite-family proof, Bernstein CFC proof, trace-mgf
  provider, Golden-Thompson, Lieb, and matrix Bernstein remain unproved.

## MB-S9-rhs-normalization-proof Bounded Trace-MGF RHS

- Stage: MB-S9-rhs-normalization-proof
- Date: 2026-06-09
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/TraceExp.lean`,
  `HighDimProb/RandomMatrix/ConcentrationStatements.lean`
- Test modules: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`,
  `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`,
  `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`,
  `HighDimProbJudge/RandomMatrix/StatementUse.lean`,
  `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean`
- New declarations: `bernsteinMGFCoeff`, `bernsteinMGFCoeff_nonneg`,
  `TraceMGFBernsteinVarianceProxyBound`,
  `TraceMGFBernsteinVarianceProxyBoundLIntegral`,
  `traceMGFBernsteinVarianceProxyBound_statement`, and
  `matrixBernsteinTraceMGFWithBernsteinCoeff_statement`.
- Proven: scalar wrapper nonnegativity for the named coefficient.
- Typed only: bounded trace-mgf semantic targets and high-level bounded
  Matrix Bernstein trace-mgf target.
- Compatibility: `matrixBernsteinTraceMGF_statement` remains the old
  `theta ^ 2 / 2` target and is not the bounded Bernstein denominator target.
- Blocked: trace-mgf provider, Bernstein CFC proof, Tropp/Lieb primitive,
  Golden-Thompson, Lieb, and matrix Bernstein remain unproved.

## MB-S9-exp-lower-bound-proof Matrix Exponential Lower Bound

- Stage: MB-S9-exp-lower-bound-proof
- Date: 2026-06-08
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/TraceExp.lean`
- Test modules: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- New declarations: `matrixLE_one_add_self_le_matrixExp_of_selfAdjoint` and
  `matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint`.
- Proven: deterministic MatrixLE lower bound `1 + A <= matrixExp A` for
  self-adjoint real matrices and the scalar-multiple wrapper.
- Blocked: single-summand provider, Bernstein CFC proof, trace-mgf provider,
  Golden-Thompson, Lieb, real RHS bridge, and matrix Bernstein remain
  unproved.
- Next safe task was MB-S9-trace-mgf-to-laplace-tail-contract.

## MB-S9-single-summand-provider-under-cfc Single-Summand Provider Under CFC

- Stage: MB-S9-single-summand-provider-under-cfc
- Date: 2026-06-09
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/TraceExp.lean`
- Test modules: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- New declarations:
  `singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic`.
- Proven: single-summand matrix MGF variance-proxy typed target under an
  explicit pointwise `bernsteinMatrixExp_le_quadratic_statement` assumption.
- Blocked: Bernstein CFC proof, Tropp/Lieb proof, trace-mgf provider, full
  CFC-free single-summand provider, Golden-Thompson, Lieb, real RHS bridge,
  and matrix Bernstein remain unproved.
- Next safe task was MB-S9-trace-mgf-to-laplace-tail-contract.

- Stage: MB-S9-bernstein-coefficient-proof
- Date: 2026-06-08
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/TraceExp.lean`
- Test modules: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- New declarations: `bernsteinCoefficient_nonneg`.
- Proven: nonnegativity of the Bernstein quadratic coefficient under
  `abs theta * R < 3`.
- Blocked: single-summand MGF provider, Bernstein CFC proof, downstream
  matrix exponential lower bound, trace-mgf provider, Golden-Thompson, Lieb,
  real RHS bridge, and matrix Bernstein remain unproved.

## MB-S9-matrixle-algebra-proof MatrixLE / PSD Algebra

- Stage: MB-S9-matrixle-algebra-proof
- Date: 2026-06-08
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/MatrixOrder.lean`
- Test modules: `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean`
- New declarations: `matrixQuadraticForm_add`, `matrixQuadraticForm_smul`,
  `isPSDMatrix_zero`, `isPSDMatrix_add`,
  `isPSDMatrix_smul_of_nonneg`, `matrixLE_refl`, `matrixLE_of_eq`,
  `matrixLE_trans`, `matrixLE_add`, `matrixLE_add_left`,
  `matrixLE_add_right`, and `matrixLE_smul_of_nonneg`.
- Proven: small PSD and MatrixLE algebra helpers needed for future
  single-summand MGF RHS normalization.
- Blocked: Bernstein CFC proof, single-summand MGF provider,
  operator-norm-to-spectral-interval bridge, trace-mgf provider,
  Golden-Thompson, Lieb, real RHS bridge, and matrix Bernstein remain
  unproved.

## MB-S9-PSD-expectation-proof PSD Expectation Bridge

- Stage: MB-S9-PSD-expectation-proof
- Date: 2026-06-08
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/VarianceProxy.lean`
- Test modules: `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean`
- New declarations: `integrableRandomMatrix_sub`, `matrixExpect_sub`,
  `isPSDMatrix_matrixExpect_of_pointwise_isPSD`,
  `matrixExpect_matrixLE_of_pointwise_matrixLE`.
- Proven: entrywise matrix expectation preserves pointwise PSD matrices and is
  monotone for `MatrixLE` under explicit entrywise integrability assumptions.
- Blocked: functional-calculus proof, single-summand MGF theorem,
  operator-norm-to-spectral-interval bridge, trace-mgf provider,
  Golden-Thompson, Lieb, real RHS bridge, and matrix Bernstein remain
  unproved.

## MB-S9-expectation-linearity-proof Expectation Linearity Bridge

- Stage: MB-S9-expectation-linearity-proof
- Date: 2026-06-08
- Branch: RandomMatrix (experimental)
- Leaf modules touched: `HighDimProb/RandomMatrix/VarianceProxy.lean`
- Test modules: `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean`
- New declarations: `integrableRandomMatrix_add`,
  `integrableRandomMatrix_smul`, `integrableRandomMatrix_zero`,
  `integrableRandomMatrix_const`, `matrixExpect_add`, `matrixExpect_smul`,
  `matrixExpect_zero`, `matrixExpect_const`,
  `matrixExpect_const_of_isProbabilityMeasure`, and
  `matrixExpect_one_of_isProbabilityMeasure`.
- Proven: entrywise integrability closure and matrix expectation
  add/smul/zero/constant normalization, with finite-measure and
  probability-measure assumptions kept explicit where needed.
- Blocked: functional-calculus proof, single-summand MGF theorem,
  operator-norm-to-spectral-interval bridge, trace-mgf provider,
  Golden-Thompson, Lieb, real RHS bridge, and matrix Bernstein remain
  unproved.
## MB-S9 Trace-MGF Thin Wrapper Branch

- Stage: MB-S9-trace-mgf-provider-thin-wrapper-proof.
- Status: complete.
- Added proved wrappers:
  `traceMGFBernsteinVarianceProxyBound_of_troppMasterTraceMGFFiniteFamily`
  and
  `matrixBernsteinTraceMGFWithBernsteinCoeff_of_troppMasterTraceMGFFiniteFamily`.
- Remaining unproved: finite-family Tropp/Lieb primitive, Bernstein CFC
  primitive, Lieb, Golden-Thompson, Matrix Bernstein tail theorem.
- Follow-up at the time: MB-S9-trace-mgf-to-laplace-tail-contract.

## MB-S9 Matrix Bernstein Trace-MGF Under Primitives Branch

- Stage: MB-S9-matrix-bernstein-trace-mgf-under-primitives-proof.
- Status: complete.
- Added proved theorem:
  `matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives`.
- Remaining unproved: finite-family Tropp/Lieb primitive, Bernstein CFC
  primitive, Lieb, Golden-Thompson, Matrix Bernstein tail theorem.
- Follow-up at the time: MB-S9-trace-mgf-to-laplace-tail-contract.
