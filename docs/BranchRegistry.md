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
- Next safe tasks: real-exponent bridge lemmas only when `SubGaussianMoment` needs them.

## Concentration

- Branch name: Concentration
- Import path: `HighDimProb.Concentration`
- Status: experimental
- Purpose: scalar concentration theorem proof spine.
- Current modules: `Concentration.Basic`, `Concentration.Markov`, `Concentration.Chebyshev`, `Concentration.LayerCake`, `Concentration.OrliczToTail`, `Concentration.TailToOrlicz`, `Concentration.MomentImplications`, `Concentration.MGF`, `Concentration.SubGaussianSums`, `Concentration.RademacherSums`, `Concentration.Implications`.
- Planned leaf modules: centered/specialized `Chebyshev` extensions, reverse MGF formulation links, subExponential MGF links, general bounded-variable `Hoeffding`, `Bernstein`, finite-gauge implication links.
- Dependencies: `Scalar`, `Tail`, `Expectation`, `Lp`, `Orlicz`, `SubGaussian`, `SubExponential`.
- Forbidden scope: random matrix concentration, Hanson-Wright, and covariance estimation.
- Promotion criteria: focused theorem statements/proofs, proof-pilot tests, docs, status update, and stable-root import audit.
- Next safe tasks: Stage H6 Hoeffding lemma for bounded centered variables; reverse MGF and subExponential MGF remain later scalar routes.

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
- Next safe tasks: Stage H6 bounded centered variable Hoeffding should consume the concentration leaf rather than extending distribution atoms.

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
- Current modules: `RandomMatrix.Basic`, `RandomMatrix.RowsCols`, `RandomMatrix.Action`, `RandomMatrix.Norms`, `RandomMatrix.Assumptions`, `RandomMatrix.SampleCovariance`, `RandomMatrix.QuadraticForm`, `RandomMatrix.Algebra`, `RandomMatrix.OperatorNorm`, `RandomMatrix.Statements`.
- Planned leaf modules: `Independence`, `SampleCovarianceTheorems`, `MatrixDeviationStatements`, `MatrixBernsteinStatements`, `HansonWrightStatements`, `JLStatements`, `CovarianceEstimationStatements`, `OperatorNormNetBridge`.
- Dependencies: `Scalar`, `Vector`, `Geometry`, Mathlib matrices, finite sums, and scoped L2 operator norm APIs.
- Forbidden scope: proving matrix concentration before scalar concentration and geometry prerequisites are ready.
- Promotion criteria: submodule API tests, theorem atlas dependencies, docs, status update, and stable-root import audit.
- Next safe tasks: Stage RM3 sample covariance PSD / symmetry statement layer; Stage RM1 random matrix assumption vocabulary implementation; operator norm bridge design.

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
- Current modules: `BookStatements`, `MetricEntropyStatements`, and branch-owned typed statement modules such as `RandomMatrix.Statements`.
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
