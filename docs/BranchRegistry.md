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
- Next safe tasks: Stage MB-S7A-provider, prove that `lambdaMaxOrdered`
  provides `SpectralUpperBound`, or block cleanly. Full matrix Laplace,
  trace-mgf, Golden-Thompson, Lieb, trace-exp spectral dominance, and Matrix
  Bernstein remain forbidden until their missing bridges are proved.
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

## MC4-cleanup — Matrix Concentration Statement Honesty

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
  premise `((lambdaMax A hA) • 1 - A).PosSemidef`.
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
- Blocked: prove that `lambdaMaxOrdered` provides `SpectralUpperBound`, or
  block cleanly. Trace-exp spectral dominance, full matrix Laplace, trace-mgf,
  Golden-Thompson, Lieb, and matrix Bernstein remain unproved.
