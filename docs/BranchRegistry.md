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

## Concentration

- Branch name: Concentration
- Import path: `HighDimProb.Concentration`
- Status: experimental
- Purpose: scalar concentration theorem proof spine.
- Current modules: `Concentration.Basic`, `Concentration.Markov`, `Concentration.Chebyshev`.
- Planned leaf modules: a.e.-nonnegative `Markov` extensions, centered/specialized `Chebyshev` extensions, `Chernoff`, `Hoeffding`, `Bernstein`, `OrliczToTail`, `SubGaussianImplications`, `SubExponentialImplications`.
- Dependencies: `Scalar`, `Tail`, `Expectation`, `Lp`, `Orlicz`, `SubGaussian`, `SubExponential`.
- Forbidden scope: random matrix concentration, Hanson-Wright, and covariance estimation.
- Promotion criteria: focused theorem statements/proofs, proof-pilot tests, docs, status update, and stable-root import audit.
- Next safe tasks: a.e.-nonnegative Markov wrapper; centered Chebyshev corollary; Chernoff statement planning.

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
- Current modules: `RandomMatrix.Basic`, `RandomMatrix.RowsCols`, `RandomMatrix.Action`, `RandomMatrix.Norms`, `RandomMatrix.Assumptions`, `RandomMatrix.SampleCovariance`, `RandomMatrix.QuadraticForm`, `RandomMatrix.OperatorNorm`.
- Planned leaf modules: `Independence`, `SampleCovarianceTheorems`, `MatrixDeviationStatements`, `MatrixBernsteinStatements`, `HansonWrightStatements`, `JLStatements`, `CovarianceEstimationStatements`, `OperatorNormNetBridge`.
- Dependencies: `Scalar`, `Vector`, `Geometry`, Mathlib matrices, finite sums, and scoped L2 operator norm APIs.
- Forbidden scope: proving matrix concentration before scalar concentration and geometry prerequisites are ready.
- Promotion criteria: submodule API tests, theorem atlas dependencies, docs, status update, and stable-root import audit.
- Next safe tasks: Stage 6C random matrix theorem statement layer; operator norm bridge design.

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

## Statements

- Branch name: Statements
- Import path: `HighDimProb.Statements`
- Status: stable for typed specs, not theorem proofs
- Purpose: typed `Prop` statement layer and theorem atlas bridge.
- Current modules: `BookStatements`, `MetricEntropyStatements`.
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
- Current imports: `Vector`, `Geometry`, `Concentration`, `RandomMatrix`, `Process`, `SignalRecovery`, `Tactic`.
- Planned leaf modules: none directly; leaves belong under their owning branch.
- Dependencies: experimental branch aggregates.
- Forbidden scope: stable API promotion by accident and new declarations inside the aggregate.
- Promotion criteria: not promoted as a whole; branches are promoted individually.
- Next safe tasks: keep aggregate synchronized with reserved and experimental branches.
