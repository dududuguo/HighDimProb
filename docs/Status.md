# Status

Current version target: v0.1-alpha

Current stage: Stage S3

Current task: small branch proof battery

Milestone status:
- Small reusable proof battery completed across scalar concentration, centering/variance, geometry, vector/isotropic, and random matrix branches.

Workflow file:
- docs/Workflow.md

Project path:
- /Users/dudu/research/HighDimProb

Reference notes:
- /Users/dudu/research/HighDimProb/高维概率及其在数据科学中的应�?md

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
- Stage 2B Orlicz / ψ�?/ ψ�?definition layer
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
- Stage I4 branch registry and reserved module plan
- Stage G1A scalar tail concentration foundations
- Stage G1B scalar concentration API cleanup
- Stage G1C Orlicz-to-tail implication pilot
- Stage G1D tail-to-Orlicz reverse implication proof pilot
- Stage G1D-fix layer-cake / tail-integral bridge infrastructure
- Milestone Sprint S2 scalar concentration proof spine + random matrix statement layer
- Milestone Sprint S3 small branch proof battery

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
- finite-dimensional random-vector alias using `Ω �?Fin n �?ℝ`
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

Stage I4 implemented:
- added `docs/BranchRegistry.md` for branch ownership, dependencies, forbidden scope, promotion criteria, and next safe tasks
- added `docs/LeafPlan.md` for planned future leaf modules under each branch
- added `docs/PhysicalMigrationPlan.md` for future one-branch-at-a-time physical migration
- added reserved experimental aggregate `HighDimProb.Concentration`
- routed `HighDimProb.Concentration` through `HighDimProb.Experimental`, not through the stable root
- updated branch import tests to cover `HighDimProb.Concentration` and `HighDimProb.RandomMatrix` explicitly
- no existing files were physically moved, no new mathematics was added, and no experimental branch was promoted to the stable root

Stage G1A implemented:
- created `HighDimProb/Concentration/Basic.lean`, `HighDimProb/Concentration/Markov.lean`, and `HighDimProb/Concentration/Chebyshev.lean`
- proved reusable tail-event inclusion bridge lemmas
- proved `expect_nonneg_of_nonneg`
- proved `lintegral_ofReal_eq_ofReal_expect`
- proved `markov_inequality_nonneg`
- proved `integrable_centered`
- proved `chebyshev_inequality`
- reused Mathlib lintegral Markov and variance-form Chebyshev inequalities
- added concentration API tests and experimental import checks
- did not prove Hoeffding, Bernstein, subGaussian/subExponential equivalences, random matrix results, or optional dependencies

Stage G1B implemented:
- added `HighDimProb.Scalar.Centering` for scalar `mean`, `centered`, `Centered`, centering measurability, centered integrability, and `centered_centered`
- added `HighDimProb.Scalar.Variance` for scalar `variance`, `covariance`, and `secondMoment`
- updated `HighDimProb.Scalar` to import the scalar centering and variance leaves
- updated `HighDimProb.Covariance` to import scalar leaves and keep vector covariance vocabulary as its owned content
- removed the direct `HighDimProb.Covariance` import from `HighDimProb.Concentration.Chebyshev`
- changed `expect_nonneg_of_nonneg` to remove its unused integrability argument and added `expect_nonneg_of_nonneg_integrable` as a compatibility form
- added user-facing `markov_inequality` alias
- added probability-facing `chebyshev_inequality_prob`
- updated concentration, covariance, public import, branch import, and experimental import tests
- did not prove Hoeffding, Bernstein, subGaussian/subExponential equivalences, random matrix results, or optional dependencies

Stage G1C implemented:
- added `HighDimProb/Concentration/OrliczToTail.lean`
- proved `lintegral_exp_sq_div_le_two_of_psi2Bound`
- proved `lintegral_exp_abs_div_le_two_of_psi1Bound`
- proved `subGaussianTail_of_psi2Bound`
- proved `subExponentialTail_of_psi1Bound`
- used Mathlib's lintegral Markov inequality directly because the Orlicz predicates are lintegral bounds
- kept measurability explicit through `IsRealRandomVariable P X`
- kept probability mass one explicit through `[IsProbabilityMeasure P]`
- added Orlicz-to-tail API tests
- did not prove reverse implications, moment/MGF equivalences, Hoeffding, Bernstein, random matrix results, or optional dependencies

Stage G1D implemented:
- added `HighDimProb/Concentration/TailToOrlicz.lean`
- exposed `lintegral_ofReal_eq_lintegral_tail` as a HighDimProb-facing layer-cake bridge
- added typed `Prop` targets `psi2BoundOfSubGaussianTailStatement` and `psi1BoundOfSubExponentialTailStatement`
- kept the target constants `2 * K` for psi2 and `3 * K` for psi1
- recorded the initial blocker: a dedicated exponential-tail integral calculation and ENNReal/real coercion bridge infrastructure
- added Tail-to-Orlicz API tests
- did not prove the reverse implications, full equivalence theorems, Hoeffding, Bernstein, random matrix results, or optional dependencies

Stage G1D-fix implemented:
- proved `lintegral_half_exp_neg_three_quarters_le_one`
- proved `integral_quarter_exp_quarter`
- proved `lintegral_exp_quarter_sub_one_le_of_exp_tail`
- proved `lintegral_exp_sq_div_four_sub_one_le_of_subGaussianTail`
- proved `psi2Bound_of_subGaussianTail` with scale `2 * K`
- proved `lintegral_two_thirds_exp_neg_two_thirds_le_one`
- proved `integral_third_exp_third`
- proved `lintegral_exp_third_sub_one_le_of_exp_tail`
- proved `lintegral_exp_abs_div_three_sub_one_le_of_subExponentialTail`
- proved `psi1Bound_of_subExponentialTail` with scale `3 * K`
- updated Tail-to-Orlicz API tests and concentration import checks
- did not prove full equivalence theorems, Hoeffding, Bernstein, random matrix results, or optional dependencies

Milestone Sprint S2 implemented:
- completed fixed-scale scalar Orlicz/tail implication graph in both directions for ψ�?and ψ�?predicates
- added `HighDimProb.Concentration.Implications`
- added `docs/ScalarImplicationGraph.md`
- hardened concentration aggregate tests
- added `HighDimProb.RandomMatrix.Statements`
- added typed statement `epsilonNetOperatorNormStatement`
- added `HighDimProbTest.RandomMatrixStatementsAPI`
- added `docs/AssumptionVocabulary.md`
- documented blocked random-matrix theorem families by missing assumption vocabulary

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
- `upperTailEvent_subset_of_le`
- `lowerTailEvent_subset_of_le`
- `absTailEvent_subset_of_le`
- `expect_nonneg_of_nonneg`
- `expect_nonneg_of_nonneg_integrable`
- `lintegral_ofReal_eq_ofReal_expect`
- `markov_inequality_nonneg`
- `markov_inequality`
- `integrable_centered`
- `chebyshev_inequality`
- `chebyshev_inequality_prob`
- `lintegral_exp_sq_div_le_two_of_psi2Bound`
- `lintegral_exp_abs_div_le_two_of_psi1Bound`
- `subGaussianTail_of_psi2Bound`
- `subExponentialTail_of_psi1Bound`
- `lintegral_exp_quarter_sub_one_le_of_exp_tail`
- `lintegral_exp_third_sub_one_le_of_exp_tail`
- `lintegral_exp_sq_div_four_sub_one_le_of_subGaussianTail`
- `lintegral_exp_abs_div_three_sub_one_le_of_subExponentialTail`
- `psi2Bound_of_subGaussianTail`
- `psi1Bound_of_subExponentialTail`
- `epsilonNetOperatorNormStatement`
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

Stage S3 is active in this round.

Stage RM2 is the next random-matrix algebra cleanup option after this round.

Target files:
- HighDimProb/Tail.lean
- HighDimProb/Concentration/Basic.lean
- HighDimProb/Concentration/Markov.lean
- HighDimProb/Scalar/Centering.lean
- HighDimProb/Scalar/Variance.lean
- HighDimProb/Nets.lean
- HighDimProb/MetricEntropy.lean
- HighDimProb/Isotropic.lean
- HighDimProb/RandomMatrix/Norms.lean
- HighDimProb/RandomMatrix/SampleCovariance.lean
- HighDimProbTest.lean
- HighDimProbTest/ConcentrationAPI.lean
- HighDimProbTest/TailProofsAPI.lean
- HighDimProbTest/CovarianceProofsAPI.lean
- HighDimProbTest/IsotropicProofsAPI.lean
- HighDimProbTest/NetsMetricEntropyAPI.lean
- HighDimProbTest/RandomMatrixProofsAPI.lean
- docs/TheoremAtlas.md
- docs/BookProgress.md
- docs/TermMap.md
- docs/AbstractionLog.md
- docs/TODO.md
- docs/TestPlan.md
- docs/Status.md
- docs/SmallProofBattery.md

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
- `HighDimProbTest.ConcentrationAPI`
- `HighDimProbTest.OrliczToTailAPI`
- `HighDimProbTest.TailToOrliczAPI`
- `HighDimProbTest.ConcentrationImplicationsAPI`
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
- `HighDimProbTest.RandomMatrixStatementsAPI`
- `HighDimProbTest.RandomMatrixProofsAPI`
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
- Do not prove Hoeffding or Bernstein yet.
- Do not prove subGaussian/subExponential equivalences.
- Do not prove covariance PSD/symmetry.
- Do not implement mathematical content outside the S3 small proof battery scope.
- Do not prove theorem families beyond small reusable branch lemmas in this round.
- Do not move vector or random-matrix files physically in this round.
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
- ψ�?norm vocabulary
- ψ�?norm vocabulary
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
- a.e.-nonnegative Markov wrapper
- scalar variance nonnegativity
- centered variance invariance under centering
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
- branch registry and reserved module plan
- reserved scalar concentration branch aggregate
- scalar tail concentration foundations
- scalar concentration API cleanup
- Markov inequality
- Chebyshev inequality
- ψ�?Orlicz bound implies subGaussian tail
- ψ�?Orlicz bound implies subExponential tail
- tail-to-Orlicz reverse implication typed targets
- layer-cake tail integral bridge
- ψ�?tail-to-Orlicz reverse implication
- ψ�?tail-to-Orlicz reverse implication
- scalar Orlicz/tail implication graph
- random matrix theorem statement layer
- deterministic epsilon-net operator norm typed statement
- random matrix assumption vocabulary audit
- small branch proof battery

Currently processing:
- Sprint S3 closeout

Not yet processed:
- random matrix finite-sum algebra bridges for sample covariance quadratic forms
- full subGaussian/subExponential equivalence theorems
- moment formulation implication links
- MGF formulation implication links
- finite-gauge Orlicz variants
- Chernoff inequality
- Hoeffding inequality
- Bernstein inequality
- random process
- Gaussian width
- empirical process
- signal recovery

## Blocked

No current Stage S3 build blocker. The stretch theorem `quadraticForm_sampleCovariance_nonneg` is deferred because it needs a reusable finite-sum algebra bridge rewriting `x^T ((1/m) A^T A) x` as `(1/m) * sum k, (sum i, A k i * x i)^2`.

Fixed-scale psi2 and psi1 tail-to-Orlicz reverse implications are proven. Finite-gauge variants, moment/MGF connectors, centered Chebyshev corollaries, deeper scalar concentration inequalities, physical migration of larger branches, random matrix theorem bridge work, and future lint/import minimization remain future stages.

Random matrix theorem statements are blocked except `epsilonNetOperatorNormStatement` because independent entries, iid rows, symmetric random matrices, PSD/order vocabulary, and high-probability theorem syntax are not yet implemented.

Theorem statements blocked by missing infrastructure are tracked in docs/TheoremAtlas.md.

## Next safe task

Stage RM2 - random matrix algebra bridge cleanup.
