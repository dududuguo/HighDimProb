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
  - Next: choose one major branch; matrix Bernstein, Hanson-Wright, and WLLN/SLLN remain separate future directions
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
- Next: Stage MC4 matrix Bernstein theorem statement refinement and proof plan; do not prove matrix Bernstein yet.

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
