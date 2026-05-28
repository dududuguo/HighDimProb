# Status

Current version target: v0.1-alpha

Current stage: Stage I3

Current task: root-to-branch module abstraction

Milestone status:
- Milestone 1 complete; root-to-branch module abstraction is being aligned before further mathematical expansion

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
- Stage I0 infrastructure scaffold hardening
- Stage 5B covering/packing theorem statement layer
- Stage P1 first proof pilot: maximal separated set gives epsilon net
- Stage P2 second proof pilot: isotropic matrix/entrywise bridge
- Stage P3 third proof pilot: centered vector coordinate bridge
- Stage P4 centered scalar operation proof pilot
- Stage P5 tail probability monotonicity proof pilot
- Stage 6A random matrix infrastructure deepening and folder abstraction
- Stage 6B sample covariance vocabulary and matrix norm bridge audit
- Stage I1 CSLib-inspired infrastructure alignment
- Stage I3 root-to-branch module abstraction

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

Stage 5B implemented:
- theorem atlas entries for maximal separated sets, packing-covering inequalities, Euclidean ball bounds, Hamming cube bounds, epsilon-net operator norm bounds, metric entropy log/coding interpretations, and Dudley integral dependency
- typed `Prop` specifications `maximalSeparatedNetStatement`, `epsilonNetCoveringNumberStatement`, and `packingCoveringInequalityStatement`
- typed statement specifications are routed through the `HighDimProb.Statements` aggregate after Stage I3
- API regression tests for metric entropy statement declarations
- no covering/packing theorem proofs
- no metric entropy real-log convention

Stage P1 implemented:
- single-point maximality predicate `MaximalEpsilonSeparatedIn`
- proof `isInternalEpsilonNet_of_maximalEpsilonSeparatedIn`
- API regression test for the proof pilot
- theorem atlas status promoted from typed-prop to proven for maximal separated set is an epsilon-net
- no probability inequalities, covering-number bounds, packing-covering inequalities, or random matrices

Stage P2 implemented:
- proof `isotropicSecondMomentMatrix_iff_isotropicSecondMoment`
- API regression test for the isotropic proof pilot
- theorem atlas status set to proven for the matrix/entrywise second-moment bridge
- no probability inequalities, covariance PSD/symmetry theorem, norm concentration theorem, or random matrices

Stage P3 implemented:
- proof `centeredVector_iff_forall_centered_coord`
- API regression test for the covariance proof pilot
- theorem atlas status set to proven for the centered vector coordinate bridge
- no probability inequalities, covariance identities, isotropic equivalence theorems beyond the coordinate bridge, or random matrices

Stage P4 implemented:
- proof `centered_centered`
- reused Mathlib integrability and Bochner-integral lemmas through the existing `expect` / `mean` wrappers
- API regression test for the centered scalar proof pilot
- theorem atlas status set to proven for centered random variable has mean zero
- no random matrices, concentration inequalities, subGaussian/subExponential equivalences, or covariance PSD/symmetry theorem

Stage P5 implemented:
- proof `upperTailProb_antitone`
- proof `lowerTailProb_monotone`
- proof `absTailProb_antitone`
- reused Mathlib measure monotonicity through transparent tail probability wrappers
- API regression test for the tail monotonicity proof pilot
- stable public import checks for the new tail theorems
- theorem atlas status set to proven for upper-tail, lower-tail, and absolute-tail probability monotonicity
- no concentration inequalities, Markov/Chebyshev theorem, subGaussian equivalences, random matrices, or optional dependencies

Stage 6A implemented:
- refactored `HighDimProb.RandomMatrix` into an aggregate over `Basic`, `RowsCols`, `Action`, `Norms`, and `Assumptions`
- concrete random matrix representation `Omega -> Matrix (Fin m) (Fin n) Real`
- entry random variables and `IsRandomMatrix`
- row and column random-vector views with measurability bridges
- deterministic matrix-vector and transposed matrix-vector actions with measurability bridges
- Frobenius squared norm, Frobenius norm, and entrywise max absolute value vocabulary
- centered-entry, subGaussian-entry, subGaussian-row, and isotropic-row predicates
- random matrix API regression tests split by submodule
- random matrix module kept under `HighDimProb.Experimental`
- no random matrix norm bounds, matrix Bernstein, Hanson-Wright, Johnson-Lindenstrauss, covariance estimation, optional dependencies, or stable root promotion

Stage 6B implemented:
- added `HighDimProb.RandomMatrix.SampleCovariance` for Gram, row Gram, and uncentered sample covariance entries/matrices
- added entry measurability bridges for Gram, row Gram, and sample covariance entries
- added `HighDimProb.RandomMatrix.QuadraticForm` for quadratic and bilinear form vocabulary
- added measurability bridges for quadratic and bilinear forms
- added `HighDimProb.RandomMatrix.OperatorNorm` using Mathlib's scoped L2 operator norm
- updated the random matrix aggregate, experimental import checks, theorem atlas dependencies, and random matrix API tests
- random matrix modules remain experimental and are not imported by the stable root
- no covariance estimation, random matrix norm bound, Hanson-Wright, Johnson-Lindenstrauss, matrix Bernstein, optional dependency, or stable root promotion was added

Stage I1 implemented:
- added `HighDimProb.Init` as a root initialization module for shared Mathlib/probability imports and conventions
- added repository organization and notation policy documents
- added automation policy documentation for simp, proof-pilot feedback, and future tactics
- updated contribution workflow with PR title categories and coordination policy
- updated test policy for stable, experimental, proof-pilot, lint, and import hygiene
- added a staged roadmap from M1 through M6
- kept experimental modules out of the stable root import
- no new mathematics, theorem proofs, optional dependencies, or CSLib dependency were added

Stage I3 implemented:
- added logical branch aggregate modules `HighDimProb.Scalar`, `HighDimProb.Vector`, `HighDimProb.Geometry`, `HighDimProb.Process`, and `HighDimProb.Statements`
- updated `HighDimProb` to import only `Init`, `Scalar`, and `Statements`
- updated `HighDimProb.Experimental` to import the experimental branch aggregates and keep v0.2+ APIs out of the stable root
- added branch import regression tests
- documented the module tree and physical migration policy
- no files were physically moved, no new mathematics was added, and no experimental branch was promoted to the stable root

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
- `centered_centered`
- `variance`
- `covariance`
- `secondMoment`
- `meanVector`
- `centeredVector`
- `CenteredVector`
- `centeredVector_iff_forall_centered_coord`
- `secondMomentMatrixEntry`
- `secondMomentMatrix`
- `covarianceMatrixEntry`
- `covarianceMatrix`
- `IsotropicSecondMoment`
- `IsotropicSecondMomentMatrix`
- `isotropicSecondMomentMatrix_iff_isotropicSecondMoment`
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
- `MaximalEpsilonSeparatedIn`
- `isInternalEpsilonNet_of_maximalEpsilonSeparatedIn`
- `externalCoveringNumber`
- `coveringNumber`
- `packingNumber`
- `maximalSeparatedNetStatement`
- `epsilonNetCoveringNumberStatement`
- `packingCoveringInequalityStatement`
- `RandomMatrix`
- `matrixEntry`
- `IsRandomMatrix`
- `matrixEntry_apply`
- `isRealRandomVariable_matrixEntry`
- `rowVector`
- `colVector`
- `isRandomVector_rowVector`
- `isRandomVector_colVector`
- `matVec`
- `vecMat`
- `isRandomVector_matVec`
- `isRandomVector_vecMat`
- `frobeniusSq`
- `frobeniusNorm`
- `entrywiseMaxAbs`
- `isRealRandomVariable_frobeniusSq`
- `isRealRandomVariable_frobeniusNorm`
- `SubGaussianEntriesOrlicz`
- `SubGaussianEntriesTail`
- `SubGaussianRowsOrlicz`
- `IsotropicRowsSecondMoment`
- `IsotropicRowsCovariance`
- `CenteredEntries`
- `gramMatrixEntry`
- `gramMatrix`
- `rowGramMatrixEntry`
- `rowGramMatrix`
- `sampleCovarianceEntry`
- `sampleCovariance`
- `isRealRandomVariable_gramMatrixEntry`
- `isRealRandomVariable_rowGramMatrixEntry`
- `isRealRandomVariable_sampleCovarianceEntry`
- `quadraticForm`
- `bilinearForm`
- `isRealRandomVariable_quadraticForm`
- `isRealRandomVariable_bilinearForm`
- `operatorNorm`
- `isRealRandomVariable_centered`
- `isRandomVector_centeredVector`
- `lowerTailEvent`
- `upperTailEvent`
- `absTailEvent`
- `upperTailProb`
- `lowerTailProb`
- `absTailProb`
- `upperTailProb_antitone`
- `lowerTailProb_monotone`
- `absTailProb_antitone`
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

Stage I3 is active in this round.

Stage 6C is the next theorem-statement option after this round.

Target files:
- HighDimProb/Scalar.lean
- HighDimProb/Vector.lean
- HighDimProb/Geometry.lean
- HighDimProb/Process.lean
- HighDimProb/Statements.lean
- HighDimProb.lean
- HighDimProb/Experimental.lean
- HighDimProbTest/BranchImports.lean
- HighDimProbTest.lean
- HighDimProbTest/PublicImports.lean
- HighDimProbTest/ExperimentalImports.lean
- ORGANISATION.md
- docs/ModuleTree.md
- docs/AbstractionLog.md
- docs/TestPlan.md
- docs/Status.md

Expected test modules:
- `HighDimProbTest.Smoke`
- `HighDimProbTest.PublicImports`
- `HighDimProbTest.BranchImports`
- `HighDimProbTest.ExperimentalImports`
- `HighDimProbTest.ProbabilityObjectAPI`
- `HighDimProbTest.TailAPI`
- `HighDimProbTest.TailProofsAPI`
- `HighDimProbTest.LpMomentAPI`
- `HighDimProbTest.OrliczAPI`
- `HighDimProbTest.SubGaussianAPI`
- `HighDimProbTest.SubExponentialAPI`
- `HighDimProbTest.RandomVectorAPI`
- `HighDimProbTest.CovarianceAPI`
- `HighDimProbTest.CovarianceProofsAPI`
- `HighDimProbTest.IsotropicAPI`
- `HighDimProbTest.IsotropicProofsAPI`
- `HighDimProbTest.SubGaussianVectorAPI`
- `HighDimProbTest.RandomMatrixBasicAPI`
- `HighDimProbTest.RandomMatrixRowsColsAPI`
- `HighDimProbTest.RandomMatrixActionAPI`
- `HighDimProbTest.RandomMatrixNormsAPI`
- `HighDimProbTest.RandomMatrixAssumptionsAPI`
- `HighDimProbTest.RandomMatrixSampleCovarianceAPI`
- `HighDimProbTest.RandomMatrixQuadraticFormAPI`
- `HighDimProbTest.RandomMatrixOperatorNormAPI`
- `HighDimProbTest.NetsMetricEntropyAPI`
- `HighDimProbTest.NetsProofsAPI`
- `HighDimProbTest.MetricEntropyStatementsAPI`
- `HighDimProbTest.BookStatements`
- `HighDimProbTest.NoDeepMathYet`

## Current implementation rules

Follow docs/Workflow.md exactly.

Hard rules:
- Do not translate the book linearly.
- Do not prove random matrix norm bounds.
- Do not prove matrix Bernstein.
- Do not prove Hanson-Wright.
- Do not prove Johnson-Lindenstrauss.
- Do not prove covariance estimation.
- Do not promote random matrix modules to stable root import.
- Do not prove concentration inequalities.
- Do not prove subGaussian/subExponential equivalences.
- Do not prove covariance PSD/symmetry.
- Do not implement new mathematical content.
- Do not prove new theorems.
- Do not physically move files unless absolutely necessary.
- Do not write unproved results as `theorem` or `lemma`.
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
- maximal separated set theorem statement
- covering number bound from epsilon-net statement
- packing-covering inequality statement
- Euclidean ball covering bounds theorem atlas entry
- Hamming cube covering/packing theorem atlas entry
- epsilon-net operator norm theorem atlas entry
- metric entropy log/coding theorem atlas entries
- Dudley integral dependency theorem atlas entry
- maximal separated set gives epsilon net proof pilot
- isotropic second-moment matrix/entrywise proof pilot
- centered vector coordinate bridge proof pilot
- centered scalar operation proof pilot
- tail probability monotonicity proof pilot
- random matrix object layer
- random matrix row and column vocabulary
- random matrix action vocabulary
- random matrix Frobenius and entrywise norm vocabulary
- random matrix L2 operator norm vocabulary
- Gram and row Gram matrix vocabulary
- sample covariance vocabulary
- quadratic and bilinear form vocabulary
- random matrix centered, subGaussian, and isotropic assumption predicates
- root-to-branch module abstraction

Currently processing:
- root-to-branch module abstraction

Not yet processed:
- random process
- Gaussian width
- empirical process
- signal recovery

## Blocked

No current Stage I3 build blocker. Physical file migration, random matrix theorem bridge work, scalar concentration proof work, and future lint/import minimization remain future stages.

Theorem statements blocked by missing infrastructure are tracked in docs/TheoremAtlas.md.

## Next safe task

Stage 6C - random matrix theorem statement layer.
