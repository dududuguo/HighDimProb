# HighDimProb Blueprint

## Global architecture

HighDimProb is a thin Mathlib-compatible vocabulary and ergonomics layer for high-dimensional probability. It keeps Mathlib's probability model:

```lean
{Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]
```

Random variables are functions with separate measurability, integrability, and distribution assumptions.

## Active stage

The current active line is v0.1-alpha cleanup plus the experimental
RandomMatrix / Matrix Bernstein proof surface:

- the stable probability, scalar concentration, Orlicz, moment, and tail
  layers are exposed through `HighDimProb`;
- experimental high-dimensional and RandomMatrix APIs remain behind
  `HighDimProb.Experimental`, `HighDimProb.RandomMatrix`, and
  `HighDimProb.Examples`;
- RandomMatrix has prefix/suffix bookkeeping, a natural `Fin m` Tropp
  trace-state route, sample-covariance wrappers under explicit primitives,
  and named negative-side provider-transfer adapters;
- Tropp/Lieb, Golden-Thompson, Bernstein CFC, full Matrix Bernstein, and
  unconditional sample-covariance concentration are not claimed.

Use `docs/Status.md` for the current branch status and
`docs/RandomMatrixAPI.md` for the public RandomMatrix names.

## Dependency policy

Mathlib is the only core dependency. See `docs/DependencyMap.md` before adding declarations or considering optional packages. Search Mathlib first; wrap existing objects rather than replacing them.

## Module purpose

- `HighDimProb.Basic`: events and basic package vocabulary.
- `HighDimProb.ProbabilitySpace`: probability-measure aliases.
- `HighDimProb.RandomVariable`: random-variable aliases and measurability predicate.
- `HighDimProb.Distribution`: distribution/law as `Measure.map`.
- `HighDimProb.Expectation`: real-valued expectation as Mathlib integral notation.
- `HighDimProb.Lp`: Lp membership, extended Lp seminorm, and integrability vocabulary.
- `HighDimProb.Moment`: finite moment predicates and moment seminorm vocabulary.
- `HighDimProb.Orlicz`: Orlicz function vocabulary and ψ₁/ψ₂ bound predicates.
- `HighDimProb.Tail`: upper, lower, and absolute tail events and probabilities.
- `HighDimProb.SubGaussian`: separate real-valued subGaussian predicate forms.
- `HighDimProb.SubExponential`: separate real-valued subExponential predicate forms.
- `HighDimProb.RandomVector`: finite-dimensional random-vector object layer, currently imported through `HighDimProb.Experimental`.
- `HighDimProb.Covariance`: scalar covariance aliases and entrywise vector covariance vocabulary, currently imported through `HighDimProb.Experimental`.
- `HighDimProb.Isotropic`: separate isotropic random-vector predicate forms, currently imported through `HighDimProb.Experimental`.
- `HighDimProb.SubGaussianVector`: separate directional subGaussian random-vector predicate forms, currently imported through `HighDimProb.Experimental`.
- `HighDimProb.Nets`: Mathlib-backed ε-net and separated-set wrappers, currently imported through `HighDimProb.Experimental`.
- `HighDimProb.MetricEntropy`: Mathlib-backed covering and packing number wrappers, currently imported through `HighDimProb.Experimental`.
- `HighDimProb.RandomMatrix`: experimental random-matrix object, order,
  spectral, trace-exp, variance-proxy, and concentration statement layers.
- `HighDimProb.BookStatements`: typechecked `Prop` specifications for reviewed object-level APIs.
- `HighDimProb.Experimental`: aggregate import for scaffold modules not yet in the stable v0.1 API.

## Dependency graph

```text
Stable root:
Basic
  ProbabilitySpace
    RandomVariable
      Distribution
      Expectation
      Lp -> Moment -> Orlicz -> SubGaussian
      Orlicz -> SubExponential
      Tail -> SubGaussian
      Tail -> SubExponential
      Expectation -> SubExponential
      BookStatements

Experimental aggregate:
RandomVector -> Covariance -> Isotropic
RandomVector, SubGaussian -> SubGaussianVector
Nets -> MetricEntropy
RandomMatrix -> MatrixOrder, Sums, OperatorNorm, Spectral, TraceExp, VarianceProxy
RandomProcess -> GaussianWidth, EmpiricalProcess
SignalRecovery
Tactic
```

## Stable declarations

- `Event`, `IsMeasurableEvent`
- `ProbabilityMeasure`, `IsProbability`
- `RandomVariable`, `RealRandomVariable`, `IsRandomVariable`, `IsRealRandomVariable`
- `law`, `realLaw`
- `expect`
- `MemLpRandomVariable`, `MemLpRealRandomVariable`
- `lpNormRandomVariable`, `realLpNorm`
- `IntegrableRandomVariable`, `IntegrableRealRandomVariable`
- `HasFiniteMoment`, `momentSeminorm`
- `OrliczFunction`, `psiPower`, `psi1Function`, `psi2Function`
- `OrliczBound`, `Psi2Bound`, `Psi1Bound`
- `HasFinitePsi2`, `HasFinitePsi1`
- `SubGaussianTail`, `SubGaussianMoment`, `CenteredSubGaussianMGF`
- `SubGaussianOrlicz`, `HasSubGaussianOrlicz`
- `SubExponentialTail`, `SubExponentialMoment`, `CenteredSubExponentialMGF`
- `SubExponentialOrlicz`, `HasSubExponentialOrlicz`
- `upperTailEvent`, `lowerTailEvent`, `absTailEvent`
- `upperTailProb`, `lowerTailProb`, `absTailProb`
- `measurableSet_upperTailEvent`, `measurableSet_lowerTailEvent`, `measurableSet_absTailEvent`
- `tailEventMeasurabilityStatement` and related statement-layer declarations

## Experimental scaffold declarations

The modules imported by `HighDimProb.Experimental` compile, but their declarations are not stable root API yet. `HighDimProb.RandomVector` has a reviewed Stage 4A object layer and remains experimental while the v0.2 vector/covariance API is being shaped.

Reviewed experimental declarations:
- `RandomVector`, `IsRandomVector`
- `coord`, `coordinate`
- `isRealRandomVariable_coord`, `isRealRandomVariable_coordinate`
- `linearForm`, `isRealRandomVariable_linearForm`
- `marginal`, `isRealRandomVariable_marginal`
- `sqNorm`, `euclideanNorm`
- `isRealRandomVariable_sqNorm`, `isRealRandomVariable_euclideanNorm`
- `mean`, `centered`, `Centered`, `variance`, `covariance`, `secondMoment`
- `meanVector`, `centeredVector`, `CenteredVector`
- `secondMomentMatrixEntry`, `secondMomentMatrix`
- `covarianceMatrixEntry`, `covarianceMatrix`
- `isRealRandomVariable_centered`, `isRandomVector_centeredVector`
- `IsotropicSecondMoment`, `IsotropicSecondMomentMatrix`
- `IsotropicCovariance`, `IsotropicMarginal`
- `IsIsotropic`
- `directionNorm`, `directionScale`
- `SubGaussianVectorOrlicz`, `HasSubGaussianVectorOrlicz`
- `SubGaussianVectorTail`, `SubGaussianVectorMoment`, `CenteredSubGaussianVectorMGF`
- `epsilonRadius`, `epsilonERadius`
- `IsEpsilonNet`, `IsInternalEpsilonNet`, `IsEpsilonSeparated`
- `externalCoveringNumber`, `coveringNumber`, `packingNumber`

## Missing declarations

- Genuine Orlicz norm/gauge infimum definitions and Orlicz spaces.
- `AEMeasurable` random-variable vocabulary.
- Canonical subGaussian and subExponential predicates.
- Canonical high-dimensional subGaussian vector predicate and ψ₂ vector norm/gauge.
- Finite-second-moment predicates and covariance identity bridge lemmas.
- Distribution classes for Gaussian and Bernoulli random vectors.
- Full Tropp/Lieb, Golden-Thompson, and Bernstein CFC proofs.
- Full unconditional Matrix Bernstein theorem.
- Tropp/CFC-free sample-covariance operator-norm concentration.
- Public-friendly natural-state Matrix Bernstein assumption bundle.
- Natural history measurability, independence conditioning, and trace-exp
  integrability propagation for the conditional-step Tropp route.
- Empirical measures and empirical process suprema.
- Gaussian width as an expectation over a Gaussian process.
- Real-valued metric entropy/log covering number wrapper.

## Design risks

- Importing all of Mathlib in `Basic` is simple but heavy.
- `Fin n → ℝ` avoids early Euclidean-space typeclass friction but may need a bridge to `EuclideanSpace`.
- Tail-bound definitions use concrete constants and should not be treated as equivalent to Orlicz/MGF definitions until proved.
- Real-radius metric wrappers use `Real.toNNReal`; theorem layers may prefer explicit `ℝ≥0` variants.

## Next safe tasks

1. `RM-MAIN-natural-state-assumption-bundle-contract`.
2. Negative trace-MGF provider-wrapper cleanup as a side leaf, reusing the
   named opposite-parameter sample-covariance provider-transfer adapters.
