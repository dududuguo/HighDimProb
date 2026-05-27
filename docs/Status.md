# Status

Current version target: v0.1-alpha

Current stage: Stage P0

Current task: public push readiness

Milestone status:
- Milestone 1 complete, preparing v0.1-alpha public push

Workflow file:
- docs/Workflow.md

Project path:
- /Users/dudu/research/HighDimProb

Reference notes:
- /Users/dudu/research/HighDimProb/高维概率及其在数据科学中的应用.md

Last known build status:
- `lake build` passes

Last known test status:
- `lake test` passes

## Completed

- Initial Lean4 package skeleton
- Dependency-first documentation
- docs/DependencyMap.md
- docs/Workflow.md
- docs/BookProgress.md
- Stage 1A real-valued probability object layer
- Stage 1T test harness and API regression tests
- Stage 1S theorem atlas initialized
- Stage 1B tail-event measurability bridge lemmas
- Stage 1C public API boundary and scaffold cleanup
- Stage 1R README workflow and future-work documentation
- Stage 2A Lp and moment vocabulary
- Stage 2B Orlicz / ψ₁ / ψ₂ definition layer
- Stage 3A subGaussian predicate layer
- Stage 3B subExponential predicate layer
- Stage 4A random vector object layer
- Stage 4B covariance and centered random vector vocabulary
- Stage 4C isotropic random vector vocabulary
- Stage 4D high-dimensional subGaussian vector predicate layer
- Stage 5A metric entropy / nets API alignment
- Stage M1 milestone closeout and audit documentation
- Stage P0 public push readiness

Stage 1A implemented:
- probability-space convention
- real-valued random variable predicate
- law/distribution wrapper
- expectation wrapper
- lower/upper/absolute tail events
- lower/upper/absolute tail probability wrappers
- basic examples for random variables and tail probabilities

Stage 1S implemented:
- theorem atlas for major book result groups
- typed `Prop` specifications for existing object-level APIs
- API regression test for the statement module

Stage 1B implemented:
- measurable upper-tail events for measurable real random variables
- measurable lower-tail events for measurable real random variables
- measurable absolute-tail events for measurable real random variables
- proved connector for `tailEventMeasurabilityStatement`
- API regression tests for tail-event measurability

Stage 1C implemented:
- stable root import restricted to reviewed Stage 1 modules and `BookStatements`
- future scaffold modules grouped under `HighDimProb.Experimental`
- public import tests separated from experimental import tests

Stage 1R implemented:
- README describes package goals, stable API, experimental API, workflow, tests, theorem atlas, roadmap, and future work

Stage 2A implemented:
- Lp membership vocabulary around Mathlib `MemLp`
- extended Lp seminorm vocabulary around Mathlib `eLpNorm`
- integrable random-variable vocabulary around Mathlib `Integrable`
- finite moment vocabulary through Mathlib `MemLp` and `eLpNorm`
- stable public import promotion for `HighDimProb.Lp` and `HighDimProb.Moment`
- API regression tests for Lp and moment declarations

Stage 2B implemented:
- Orlicz function vocabulary
- `ψ₁` and `ψ₂` model functions
- Orlicz bound predicate using `lintegral`
- `ψ₂` exponential-square bound predicate
- `ψ₁` exponential-linear bound predicate
- finite `ψ₂` and finite `ψ₁` predicates
- stable public import promotion for `HighDimProb.Orlicz`
- API regression tests for Orlicz declarations

Stage 3A implemented:
- subGaussian tail predicate form
- subGaussian moment-growth predicate form
- centered MGF predicate form wrapping Mathlib `ProbabilityTheory.HasSubgaussianMGF`
- subGaussian Orlicz predicate form wrapping `Psi2Bound`
- finite subGaussian Orlicz predicate wrapping `HasFinitePsi2`
- stable public import promotion for `HighDimProb.SubGaussian`
- API regression tests for subGaussian declarations

Stage 3B implemented:
- subExponential tail predicate form
- subExponential moment-growth predicate form
- centered local-MGF predicate form
- subExponential Orlicz predicate form wrapping `Psi1Bound`
- finite subExponential Orlicz predicate wrapping `HasFinitePsi1`
- stable public import promotion for `HighDimProb.SubExponential`
- API regression tests for subExponential declarations

Stage 4A implemented:
- finite-dimensional random-vector alias using `Ω → Fin n → ℝ`
- coordinatewise random-vector measurability predicate
- coordinate random-variable wrapper and bridge lemmas
- finite linear marginal wrapper and measurability bridge
- squared Euclidean norm random variable
- Euclidean norm random variable
- API regression tests for random-vector declarations
- random-vector module kept under `HighDimProb.Experimental`

Stage 4B implemented:
- scalar mean wrapper around `expect`
- scalar centered random-variable function and predicate
- scalar variance and covariance wrappers around Mathlib `ProbabilityTheory`
- scalar second-moment vocabulary
- random-vector mean vector
- centered random vector function and predicate
- second-moment matrix entries and matrix
- covariance matrix entries and matrix
- API regression tests for covariance declarations
- covariance module kept under `HighDimProb.Experimental`

Stage 4C implemented:
- entrywise second-moment isotropic predicate
- matrix-form second-moment isotropic predicate
- covariance-form isotropic predicate
- marginal second-moment isotropic predicate
- compatibility alias from `IsIsotropic` to `IsotropicCovariance`
- API regression tests for isotropic declarations
- isotropic module kept under `HighDimProb.Experimental`

Stage 4D implemented:
- marginal alias for finite linear forms
- deterministic direction norm and direction scale vocabulary
- directional Orlicz subGaussian vector predicate
- finite directional Orlicz subGaussian vector predicate
- directional tail, moment, and centered-MGF subGaussian vector predicates
- API regression tests for subGaussian vector declarations
- subGaussian vector module kept under `HighDimProb.Experimental`

Stage 5A implemented:
- real-radius wrappers `epsilonRadius` and `epsilonERadius`
- ε-net wrapper around Mathlib `Metric.IsCover`
- internal ε-net wrapper requiring centers in the covered set
- separated-set wrapper around Mathlib `Metric.IsSeparated`
- external covering number wrapper around Mathlib `Metric.externalCoveringNumber`
- internal covering number wrapper around Mathlib `Metric.coveringNumber`
- packing number wrapper around Mathlib `Metric.packingNumber`
- metric entropy real-log wrapper deferred
- API regression tests for nets and metric entropy declarations
- nets and metric entropy modules kept under `HighDimProb.Experimental`

Important existing declarations:
- `IsRandomVariable`
- `IsRealRandomVariable`
- `realLaw`
- `expect`
- `MemLpRandomVariable`
- `MemLpRealRandomVariable`
- `lpNormRandomVariable`
- `realLpNorm`
- `IntegrableRandomVariable`
- `IntegrableRealRandomVariable`
- `HasFiniteMoment`
- `momentSeminorm`
- `OrliczFunction`
- `psiPower`
- `psi1Function`
- `psi2Function`
- `OrliczBound`
- `Psi2Bound`
- `Psi1Bound`
- `HasFinitePsi2`
- `HasFinitePsi1`
- `SubGaussianTail`
- `SubGaussianMoment`
- `CenteredSubGaussianMGF`
- `SubGaussianOrlicz`
- `HasSubGaussianOrlicz`
- `SubExponentialTail`
- `SubExponentialMoment`
- `CenteredSubExponentialMGF`
- `SubExponentialOrlicz`
- `HasSubExponentialOrlicz`
- `RandomVector`
- `IsRandomVector`
- `coord`
- `coordinate`
- `isRealRandomVariable_coord`
- `isRealRandomVariable_coordinate`
- `linearForm`
- `marginal`
- `isRealRandomVariable_linearForm`
- `isRealRandomVariable_marginal`
- `sqNorm`
- `euclideanNorm`
- `isRealRandomVariable_sqNorm`
- `isRealRandomVariable_euclideanNorm`
- `mean`
- `centered`
- `Centered`
- `variance`
- `covariance`
- `secondMoment`
- `meanVector`
- `centeredVector`
- `CenteredVector`
- `secondMomentMatrixEntry`
- `secondMomentMatrix`
- `covarianceMatrixEntry`
- `covarianceMatrix`
- `IsotropicSecondMoment`
- `IsotropicSecondMomentMatrix`
- `IsotropicCovariance`
- `IsotropicMarginal`
- `IsIsotropic`
- `directionNorm`
- `directionScale`
- `SubGaussianVectorOrlicz`
- `HasSubGaussianVectorOrlicz`
- `SubGaussianVectorTail`
- `SubGaussianVectorMoment`
- `CenteredSubGaussianVectorMGF`
- `epsilonRadius`
- `epsilonERadius`
- `IsEpsilonNet`
- `IsInternalEpsilonNet`
- `IsEpsilonSeparated`
- `externalCoveringNumber`
- `coveringNumber`
- `packingNumber`
- `isRealRandomVariable_centered`
- `isRandomVector_centeredVector`
- `lowerTailEvent`
- `upperTailEvent`
- `absTailEvent`
- `upperTailProb`
- `lowerTailProb`
- `absTailProb`
- `tailEventMeasurabilityStatement`
- `lawMapApplyStatement`
- `realLawMapApplyStatement`
- `expectAliasStatement`
- `tailProbabilityWrapperStatement`
- `measurableSet_upperTailEvent`
- `measurableSet_lowerTailEvent`
- `measurableSet_absTailEvent`
- `tailEventMeasurabilityStatement_holds`

## Active

Stage P0 is active in this round.

Stage 5B is queued but not started in this round.

Stage 6A is an alternative next safe task, but random matrices are not started in this round.

Target files:
- README.md
- CONTRIBUTING.md
- LICENSE
- .github/ISSUE_TEMPLATE/
- .github/workflows/ci.yml
- docs/ContributorRoadmap.md
- docs/Status.md
- docs/Milestone1.md
- docs/Workflow.md
- docs/TheoremAtlas.md
- docs/TestPlan.md
- docs/TODO.md

Expected test modules:
- `HighDimProbTest.Smoke`
- `HighDimProbTest.PublicImports`
- `HighDimProbTest.ExperimentalImports`
- `HighDimProbTest.ProbabilityObjectAPI`
- `HighDimProbTest.TailAPI`
- `HighDimProbTest.LpMomentAPI`
- `HighDimProbTest.OrliczAPI`
- `HighDimProbTest.SubGaussianAPI`
- `HighDimProbTest.SubExponentialAPI`
- `HighDimProbTest.RandomVectorAPI`
- `HighDimProbTest.CovarianceAPI`
- `HighDimProbTest.IsotropicAPI`
- `HighDimProbTest.SubGaussianVectorAPI`
- `HighDimProbTest.NetsMetricEntropyAPI`
- `HighDimProbTest.BookStatements`
- `HighDimProbTest.NoDeepMathYet`

## Current implementation rules

Follow docs/Workflow.md exactly.

Hard rules:
- Do not translate the book linearly.
- Do not implement new mathematical content in Stage P0.
- Do not start Stage 5B yet.
- Do not start random matrices yet.
- Do not prove theorem statements.
- Do not prove covering number bounds yet.
- Do not prove packing-covering inequalities yet.
- Do not prove epsilon-net operator norm bounds yet.
- Do not add optional dependencies.
- Do not create a custom probability universe.
- Do not create a custom random variable structure.
- Do not write unproved book results as `theorem` or `lemma`.
- No `sorry`.
- No `admit`.
- No axioms.
- Keep `lake build` passing.
- Keep `lake test` passing.

## Book concepts currently being processed

Processed:
- probability space
- real-valued random variable
- law/distribution
- expectation
- tail event
- tail probability
- theorem atlas and statement layer
- tail-event measurability bridge lemmas
- Lp norm
- moments
- Orlicz norm vocabulary
- ψ₂ norm vocabulary
- ψ₁ norm vocabulary
- subGaussian random variable definitions
- subExponential random variable definitions
- random vector object layer
- covariance matrix
- second moment matrix
- centered random vector
- isotropic random vector vocabulary
- high-dimensional subGaussian vector vocabulary
- ε-net vocabulary
- separated set vocabulary
- covering number vocabulary
- packing number vocabulary
- metric entropy vocabulary

Currently processing:
- public push readiness

Not yet processed:
- random matrix
- random process
- Gaussian width
- empirical process
- signal recovery

## Blocked

No current public-push blocker.

Theorem statements blocked by missing infrastructure are tracked in docs/TheoremAtlas.md.

## Next safe task

Next safe task after push:

Stage 5B — covering/packing theorem statement layer.

Alternative next safe task:

Stage 6A — random matrix object layer.
