# Status

Current version target: v0.1-alpha

Current stage: Stage H7

Current task: non-centered Wikipedia-form Hoeffding corollary for bounded variables

Milestone status:
- Boole inequality, sample-covariance algebra, weak-law scaffold, Stage C1 cleanup, fixed low moment implications, all-natural absolute-moment factorial bound, natural moment-to-Lp bridge, crude linear subGaussian real-Lp growth, sharp natural-exponent typed compatibility statements, natural-exponent sqrt-growth real-Lp bounds, sharp natural-exponent predicate bridges, forward centered-MGF-to-tail/psi2/moment links, the Milestone 3 scalar closeout audit, the canonical Rademacher MGF atom, the Rademacher/Hoeffding branch readiness cleanup, finite product Rademacher family infrastructure, weighted finite Rademacher sum MGF, finite Rademacher Hoeffding tail bound, Rademacher/Hoeffding branch closeout, weighted Rademacher zero-weight cleanup, independent finite subGaussian sum MGF, finite Hoeffding theorem for bounded centered variables, sharp finite Hoeffding theorem for bounded centered variables, and non-centered Wikipedia-form finite Hoeffding are complete.

Workflow file:
- docs/Workflow.md

Project path:
- C:\Users\User\research\HighDimProb

Reference notes:
- Not present in the current checkout; expected path was `C:\Users\User\research\HighDimProb\高维概率及其在数据科学中的应用.md`.

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
- Stage G1E Boole inequality / finite union bound proof
- Stage RM2 random matrix finite-sum algebra bridge cleanup
- Stage LLN0-LLN1 weak law scaffold and sample mean vocabulary
- Stage C1 abstraction cleanup after scalar concentration and random-matrix proof spine
- Stage G2A scalar absolute natural-moment implication pilot
- Stage G2B all-natural-exponent absolute moment bound
- Stage G2C absMomentNat-to-realLpNorm bridge
- Stage G2D sharpen subGaussian natural-moment growth
- Stage G2E sharp subGaussian moment tail-integral/Gamma estimate design
- Stage G2E-fix deterministic real inequality proof for sharp moment growth
- Stage G2F connect sharp natural-exponent moment theorem to `SubGaussianMoment` interface
- Stage G2F-cleanup library abstraction and code-trace cleanup
- Stage M3 scalar subGaussian proof spine closeout
- Stage H1 Rademacher subGaussian MGF proof
- Stage H0 Rademacher/Hoeffding branch readiness cleanup
- Stage H2A finite product Rademacher family infrastructure
- Stage H2B weighted finite Rademacher sum MGF
- Stage H3 finite Rademacher Hoeffding tail bound
- Stage H4 Rademacher/Hoeffding branch closeout
- Stage H2-cleanup weighted Rademacher zero-weight cleanup
- Stage H5 independent finite subGaussian sum MGF
- Stage H6 finite Hoeffding theorem for bounded centered variables
- Stage H6-sharp sharp finite Hoeffding theorem for bounded centered variables
- Stage H7 non-centered Wikipedia-form Hoeffding corollary

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

Stage G1E implemented:
- proved `measure_biUnion_le` as a HighDimProb-facing finite union bound / Boole inequality.
- reused Mathlib `MeasureTheory.measure_biUnion_finset_le`.
- kept the theorem in `HighDimProb/ProbabilitySpace.lean` as stable probability infrastructure.
- no measurability assumptions are required because the underlying Mathlib theorem is outer-measure subadditivity.
- no Borel-Cantelli, Hoeffding, Bernstein, or random matrix norm bounds were added.

Stage RM2 implemented:
- proved `quadraticForm_sampleCovariance_eq_sum_sq` with normal form `(1 / (m : Real)) * sum k, (sum i, A omega k i * x i)^2`.
- proved `quadraticForm_sampleCovariance_nonneg` without any positive-dimension assumption, including the `m = 0` total-division edge case.
- added `HighDimProb.RandomMatrix.Algebra` and imported it from `HighDimProb.RandomMatrix`.
- reused `Finset.mul_sum`, `Finset.sum_mul`, `Finset.sum_comm`, targeted `Finset.sum_congr`, `ring`, `sq_nonneg`, and `one_div_nonneg`.
- did not prove random matrix norm bounds, Hanson-Wright, Johnson-Lindenstrauss, or optional dependency theorem families.

Stage LLN0-LLN1 implemented:
- added experimental `HighDimProb.LimitTheorems` with `LimitTheorems.Basic` and `LimitTheorems.WeakLaw`.
- defined `sampleSum`, `sampleMean`, and `sampleMeanCentered` for finite samples indexed by `Fin n` without assuming `0 < n`.
- proved sample sum/mean measurability and integrability bridges from coordinate assumptions.
- added typed `Prop` specifications `weakLawChebyshevBoundStatement` and `weakLawFiniteVarianceStatement` only; no WLLN theorem proof was claimed.
- reused Mathlib `Finset.measurable_sum`, `integrable_finset_sum`, `Integrable.const_mul`, and `MeasureTheory.TendstoInMeasure`.
- did not prove SLLN, Kolmogorov SLLN, Borel-Cantelli, Hoeffding, Bernstein, or measure-theoretic convergence theorem proofs.

Stage C1 implemented:
- added `HighDimProb.Concentration.LayerCake` as the reusable import boundary for existing layer-cake and exponential-tail calculus helpers.
- kept public scalar concentration implication theorem names stable and documented the fixed-scale Orlicz/tail graph.
- added `rowDot`, row-dot nonnegativity helpers, and `quadraticForm_sampleCovariance_eq_scaled_sum_rowDot_sq` for random-matrix algebra reuse.
- added `HighDimProb.LimitTheorems.Assumptions` with Mathlib-backed scalar independence, pairwise independence, identical-distribution, and iid vocabulary.
- did not prove Hoeffding, Bernstein, full WLLN, random matrix norm bounds, Hanson-Wright, Johnson-Lindenstrauss, or optional dependency theorem families.

Stage G2C implemented:
- proved `lintegral_enorm_rpow_nat_eq_absMomentNat`, identifying the Mathlib `eLpNorm` natural-exponent integrand with `absMomentNat`.
- proved `memLp_of_finiteAbsMomentNat` for `q != 0`, with explicit `IsRealRandomVariable P X` measurability.
- added first- and second-moment convenience wrappers `memLp_one_of_finiteAbsMomentNat_one` and `memLp_two_of_finiteAbsMomentNat_two`.
- proved `realLpNorm_nat_le_of_absMomentNat_le_ennreal` and `realLpNorm_nat_le_of_absMomentNat_le`.
- added `SubGaussianMomentNat` and proved `subGaussianMomentNat_of_psi2Bound` and `subGaussianMomentNat_of_subGaussianTail` with the existing factorial constants.
- did not prove the sharp `sqrt(q)` moment-growth theorem, MGF links, Hoeffding, Bernstein, or full subGaussian equivalence.

Stage G2D implemented:
- proved `realLpNorm_nat_le_linear_of_psi2Bound` with constant `8` for natural `q >= 1`.
- proved `realLpNorm_nat_le_linear_of_subGaussianTail` with constant `16`, using the existing `K -> 2*K` tail-to-ψ₂ scale loss.
- reused `Nat.factorial_le_pow`, `Real.rpow_le_rpow`, `Real.mul_rpow`, `Real.rpow_mul`, `Real.exp_one_lt_three`, and the existing `absMomentNat -> realLpNorm` bridge.
- documented that the factorial-root route only yields linear `q`; sharp `sqrt(q)` growth remains blocked by missing direct tail-integral/Gamma moment estimates.

Stage G2E implemented:
- added typed proof-plan declarations `powLeSqrtGrowthMulExpSqStatement`, `sqrtMomentGrowthOfPsi2Statement`, and `sqrtMomentGrowthOfSubGaussianTailStatement`.
- kept the proved constants unchanged: linear `8` for `Psi2Bound`, linear `16` for `SubGaussianTail`; sharp typed targets use intended constants `8` and `16`.
- found that Mathlib has layer-cake and Gamma integral formulas, but the missing bridge is a reusable deterministic optimization or Gamma upper-bound lemma yielding `sqrt(q)`.
- did not prove the sharp `sqrt(q)` theorem.

Stage G2E-fix implemented:
- added `HighDimProb.Analysis.RealInequalities` as a small deterministic helper leaf.
- proved `pow_le_two_sqrt_mul_exp_sq`, a stronger constant-`2` version of the deterministic envelope; `powLeSqrtGrowthMulExpSq` is kept as a constant-`4` compatibility wrapper.
- proved `absMomentNat_le_sqrt_growth_of_psi2Bound` with bound `(4*K*sqrt q)^q`.
- proved `realLpNorm_nat_le_sqrt_of_psi2Bound` with constant `4` and `realLpNorm_nat_le_sqrt_of_subGaussianTail` with constant `8`.
- proved the typed statement wrappers `sqrtMomentGrowthOfPsi2` and `sqrtMomentGrowthOfSubGaussianTail`.

Stage G2F implemented:
- inspected `SubGaussianMoment`; it quantifies over all finite `p : ENNReal`, while the proved sharp theorem is natural-exponent only.
- added `SubGaussianMomentNatSqrt` as a non-breaking sharp natural-exponent real-Lp predicate.
- proved `subGaussianMomentNatSqrt_of_psi2Bound` with scale `4 * K`.
- proved `subGaussianMomentNatSqrt_of_subGaussianTail` with scale `8 * K`.
- left the existing factorial-growth `SubGaussianMomentNat` predicate and the full real-exponent `SubGaussianMoment` predicate unchanged.

Stage G2F-cleanup implemented:
- updated the concentration implication aggregate documentation so it accurately owns tail/Orlicz arrows while moment arrows stay in `MomentImplications`.
- rephrased old typed-target comments as compatibility statement wrappers after the sharper theorems were proved.
- added aggregate import checks for `SubGaussianMomentNatSqrt` and its bridge theorems.
- refreshed local path/status wording and removed stale "sharp target remains only typed" documentation.

Milestone Sprint S4 implemented:
- added `HighDimProb.Concentration.MGF` and `CenteredSubGaussianMGFLIntegral`.
- proved `centeredSubGaussianMGFLIntegral_of_centeredSubGaussianMGF`.
- proved one-sided Chernoff upper and lower tails from both the lintegral MGF predicate and the existing Mathlib-backed MGF predicate.
- proved `subGaussianTail_of_centeredSubGaussianMGF` with scale `2*K`.
- proved `psi2Bound_of_centeredSubGaussianMGF` with scale `4*K`.
- proved `subGaussianMomentNatSqrt_of_centeredSubGaussianMGF` with scale `16*K`.
- added `HighDimProbTest/MGFImplicationsAPI.lean`.

Stage M3 implemented:
- added `docs/Milestone3.md` as the scalar subGaussian proof spine closeout summary.
- converted `docs/ScalarImplicationGraph.md` to a table-driven audit of proved and blocked scalar implication arrows.
- updated `HighDimProb.Concentration.Implications` to re-export tail/Orlicz, natural-moment, and MGF implication leaves.
- strengthened aggregate implication API tests so public theorem names are discoverable through the implication import.
- recorded reverse MGF, full real-exponent `SubGaussianMoment`, subExponential MGF, Hoeffding, and Bernstein as future work.

Stage H1 implemented:
- added experimental `HighDimProb.Distributions` and `HighDimProb.Distributions.Rademacher`.
- defined `rademacherPMF`, `rademacherMeasure`, and `rademacher` on `Bool`.
- proved `isRealRandomVariable_rademacher`, `rademacher_mem_Icc`, and `integral_rademacher`.
- proved `centeredSubGaussianMGF_rademacher` with scale `1`.
- derived `subGaussianTail_rademacher` with scale `2` by the existing MGF-to-tail bridge.
- added `HighDimProbTest/RademacherAPI.lean`.

Stage H0 implemented:
- audited `HighDimProb.Distributions.Rademacher`, `HighDimProb.Distributions`, `HighDimProb.Concentration.MGF`, and `HighDimProb.Concentration.Implications`.
- confirmed the canonical Rademacher atom declarations exist and are covered by `HighDimProbTest/RademacherAPI.lean`.
- added `docs/RademacherPlan.md` for the H0/H2A/H2B/H3/H4 branch route.
- recorded finite product Rademacher families, coordinate independence, product expectation/MGF factorization, finite-sum exponential algebra, and constant bookkeeping as the next blockers.

Stage H2A implemented:
- added `HighDimProb.Distributions.RademacherFamily`.
- defined `rademacherVectorMeasure n` as the finite product measure `Measure.pi (fun _ : Fin n => rademacherMeasure)`.
- defined `rademacherVectorPMF n` as the PMF induced from `rademacherVectorMeasure n`.
- defined `rademacherCoord` and `rademacherVector`.
- proved coordinate measurability, pointwise `[-1,1]` bounds, coordinate mean zero, and `iIndepFun_rademacherCoord`.
- added `HighDimProbTest/RademacherFamilyAPI.lean`.

Stage H2B implemented:
- added `HighDimProb.Concentration.RademacherSums`.
- defined `weightedRademacherSum a` as `fun omega => sum i, a i * rademacherCoord i omega`.
- proved `isRealRandomVariable_weightedRademacherSum`.
- proved `hasSubgaussianMGF_rademacherCoord`, `iIndepFun_weightedRademacherTerms`, and `hasSubgaussianMGF_weightedRademacherTerm`.
- proved `hasSubgaussianMGF_weightedRademacherSum` with Mathlib MGF proxy `sum_i a_i^2`.
- proved `centeredSubGaussianMGF_weightedRademacherSum` with scale `sqrt (sum_i a_i^2)` under `0 < sum_i a_i^2`.
- added `HighDimProbTest/RademacherSumsAPI.lean`.

Stage H3 implemented:
- proved `subGaussianTail_weightedRademacherSum` by composing the weighted-sum MGF theorem with `subGaussianTail_of_centeredSubGaussianMGF`.
- proved `hoeffding_rademacher_sum`, the explicit two-sided bound with denominator `4 * sum_i a_i^2`, under `0 < sum_i a_i^2`.
- updated Rademacher sum API, implication, branch, and experimental import checks.
- recorded the all-zero-weight vector as a zero-scale predicate cleanup issue, not a blocker for the positive-square-sum Hoeffding theorem.

Stage H4 implemented:
- added `docs/RademacherMilestone.md` as the finite Rademacher concentration closeout summary.
- audited import boundaries: stable root unchanged; `HighDimProb.Distributions` exposes atom/family; `HighDimProb.Concentration` exposes weighted sums and tail/Hoeffding corollaries; `HighDimProb.Experimental` exposes both aggregates.
- audited theorem-name discoverability for the atom, family, weighted-sum MGF, weighted tail, and explicit Hoeffding declarations.
- confirmed focused API tests and aggregate import tests cover the public Rademacher/Hoeffding declarations.

Stage H2-cleanup implemented:
- proved `weightedRademacherSum_eq_zero_of_forall_eq_zero`.
- proved `weightedRademacherSum_eq_zero_of_sum_sq_eq_zero` using finite sums of nonnegative squares.
- proved `absTailProb_weightedRademacherSum_eq_zero_of_forall_eq_zero_of_pos`.
- proved `absTailProb_weightedRademacherSum_eq_zero_of_sum_sq_eq_zero_of_pos`.
- added `hoeffding_rademacher_sum_of_pos_variance` as a user-facing alias for the existing positive-square-sum theorem.
- documented that exact scale-0 `CenteredSubGaussianMGF`/`SubGaussianTail` wrappers remain unavailable because those predicates require positive scales.

Stage H5 implemented:
- added `HighDimProb.Concentration.SubGaussianSums`.
- proved `hasSubgaussianMGF_finset_sum_of_iIndepFun` and `centeredSubGaussianMGF_finset_sum_of_iIndepFun_of_pos`.
- proved `centeredSubGaussianMGF_sum_of_iIndepFun_of_pos` with scale `sqrt (sum_i K_i^2)`.
- proved deterministic-weight independence and MGF helpers: `iIndepFun_weighted_of_iIndepFun`, `hasSubgaussianMGF_weighted_of_centeredSubGaussianMGF`, and `hasSubgaussianMGF_finset_weighted_sum_of_iIndepFun`.
- proved `centeredSubGaussianMGF_weighted_sum_of_iIndepFun_of_pos` with scale `sqrt (sum_i (a_i*K_i)^2)`.
- proved `subGaussianTail_sum_of_iIndepFun_of_pos` and `subGaussianTail_weighted_sum_of_iIndepFun_of_pos` by composing with `subGaussianTail_of_centeredSubGaussianMGF`.
- updated `HighDimProb.Concentration`, `HighDimProb.Concentration.Implications`, focused API tests, and aggregate import checks.

Stage H6 implemented:
- added `HighDimProb.Concentration.Hoeffding`.
- proved `centeredSubGaussianMGF_of_ae_mem_Icc_of_centered` by reusing Mathlib `ProbabilityTheory.hasSubgaussianMGF_of_mem_Icc_of_integral_eq_zero`.
- proved `centeredSubGaussianMGF_of_forall_mem_Icc_of_centered` as the pointwise-bounded convenience wrapper.
- proved `centeredSubGaussianMGF_sum_of_iIndepFun_bounded_centered` with scale `sqrt (sum_i ((b_i-a_i)/2)^2)`.
- proved `subGaussianTail_sum_of_iIndepFun_bounded_centered` with tail scale `2 * sqrt (sum_i ((b_i-a_i)/2)^2)`.
- proved `hoeffding_sum_bounded_centered` with explicit denominator `sum_i (b_i-a_i)^2`.
- updated `HighDimProb.Concentration`, `HighDimProb.Concentration.Implications`, focused API tests, aggregate import checks, and documentation.

Stage H6-sharp implemented:
- proved `upperTailProb_le_exp_neg_two_mul_sq_div_of_mgf_eighth` from the local eighth-MGF hypothesis `E exp(lambda*Y) <= exp(lambda^2*V/8)`.
- proved `lowerTailProb_le_exp_neg_two_mul_sq_div_of_mgf_eighth` and `absTailProb_le_two_mul_exp_neg_two_mul_sq_div_of_mgf_eighth`.
- proved `hoeffding_sum_bounded_centered_sharp` with explicit classical/Wikipedia exponent `-(2*t^2 / sum_i (b_i-a_i)^2)` under the visible denominator assumption `0 < sum_i (b_i-a_i)^2`.
- kept `hoeffding_sum_bounded_centered`, `SubGaussianTail`, `Psi2Bound`, `CenteredSubGaussianMGF`, and the existing scalar implication meanings unchanged.
- updated focused Hoeffding tests, aggregate import checks, and documentation.

Stage H7 implemented:
- proved `expect_finset_sum` for finite sums of integrable real random variables.
- proved `iIndepFun_centered_of_iIndepFun`, preserving independence under deterministic centering.
- proved `ae_mem_Icc_centered_of_ae_mem_Icc`, shifting a.e. interval bounds after centering.
- proved `sum_centered_eq_sum_sub_expect_sum`, identifying the sum of centered variables with `sum_i X_i - E[sum_i X_i]`.
- proved `hoeffding_sum_bounded` with the exact non-centered classical/Wikipedia exponent `-(2*t^2 / sum_i (b_i-a_i)^2)` under explicit integrability and the visible denominator assumption `0 < sum_i (b_i-a_i)^2`.
- kept `hoeffding_sum_bounded_centered`, `hoeffding_sum_bounded_centered_sharp`, `CenteredSubGaussianMGF`, `SubGaussianTail`, `Psi2Bound`, and the existing scalar implication meanings unchanged.
- updated focused Hoeffding tests, aggregate import checks, and documentation.

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
- `absMomentNat`
- `finiteAbsMomentNat`
- `SubGaussianMomentNat`
- `SubGaussianMomentNatSqrt`
- `lintegral_enorm_rpow_nat_eq_absMomentNat`
- `memLp_of_finiteAbsMomentNat`
- `memLp_one_of_finiteAbsMomentNat_one`
- `memLp_two_of_finiteAbsMomentNat_two`
- `realLpNorm_nat_le_of_absMomentNat_le_ennreal`
- `realLpNorm_nat_le_of_absMomentNat_le`
- `realLpNorm_nat_le_linear_of_psi2Bound`
- `realLpNorm_nat_le_linear_of_subGaussianTail`
- `realLpNorm_nat_le_sqrt_of_psi2Bound`
- `realLpNorm_nat_le_sqrt_of_subGaussianTail`
- `subGaussianMomentNat_of_psi2Bound`
- `subGaussianMomentNat_of_subGaussianTail`
- `subGaussianMomentNatSqrt_of_psi2Bound`
- `subGaussianMomentNatSqrt_of_subGaussianTail`
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
- `measure_biUnion_le`
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
- `quadraticForm_sampleCovariance_eq_sum_sq`
- `quadraticForm_sampleCovariance_nonneg`
- `tailEventMeasurabilityStatement`
- `lawMapApplyStatement`
- `realLawMapApplyStatement`
- `expectAliasStatement`
- `tailProbabilityWrapperStatement`
- `sampleSum`
- `sampleMean`
- `sampleMeanCentered`
- `isRealRandomVariable_sampleSum`
- `isRealRandomVariable_sampleMean`
- `integrable_sampleSum`
- `integrable_sampleMean`
- `weakLawChebyshevBoundStatement`
- `weakLawFiniteVarianceStatement`
- `rowDot`
- `rowDot_sq_nonneg`
- `sum_rowDot_sq_nonneg`
- `quadraticForm_sampleCovariance_eq_scaled_sum_rowDot_sq`
- `IndependentSample`
- `PairwiseIndependentFinSample`
- `IdenticallyDistributedSample`
- `IidSample`
- `IndependentFinSample`
- `IdenticallyDistributedFinSample`
- `IidFinSample`
- `IndependentSequence`
- `IdenticallyDistributedSequence`
- `IidSequence`
- `measurableSet_upperTailEvent`
- `measurableSet_lowerTailEvent`
- `measurableSet_absTailEvent`
- `tailEventMeasurabilityStatement_holds`
- `isRealRandomVariable_finset_sum`
- `isRealRandomVariable_finset_weighted_sum`
- `hasSubgaussianMGF_finset_sum_of_iIndepFun`
- `centeredSubGaussianMGF_finset_sum_of_iIndepFun_of_pos`
- `centeredSubGaussianMGF_sum_of_iIndepFun_of_pos`
- `subGaussianTail_finset_sum_of_iIndepFun_of_pos`
- `subGaussianTail_sum_of_iIndepFun_of_pos`
- `iIndepFun_weighted_of_iIndepFun`
- `hasSubgaussianMGF_weighted_of_centeredSubGaussianMGF`
- `hasSubgaussianMGF_finset_weighted_sum_of_iIndepFun`
- `centeredSubGaussianMGF_finset_weighted_sum_of_iIndepFun_of_pos`
- `centeredSubGaussianMGF_weighted_sum_of_iIndepFun_of_pos`
- `subGaussianTail_finset_weighted_sum_of_iIndepFun_of_pos`
- `subGaussianTail_weighted_sum_of_iIndepFun_of_pos`
- `centeredSubGaussianMGF_of_ae_mem_Icc_of_centered`
- `centeredSubGaussianMGF_of_forall_mem_Icc_of_centered`
- `centeredSubGaussianMGF_sum_of_iIndepFun_bounded_centered`
- `subGaussianTail_sum_of_iIndepFun_bounded_centered`
- `hoeffding_sum_bounded_centered`
- `upperTailProb_le_exp_neg_two_mul_sq_div_of_mgf_eighth`
- `lowerTailProb_le_exp_neg_two_mul_sq_div_of_mgf_eighth`
- `absTailProb_le_two_mul_exp_neg_two_mul_sq_div_of_mgf_eighth`
- `hoeffding_sum_bounded_centered_sharp`
- `expect_finset_sum`
- `iIndepFun_centered_of_iIndepFun`
- `ae_mem_Icc_centered_of_ae_mem_Icc`
- `sum_centered_eq_sum_sub_expect_sum`
- `hoeffding_sum_bounded`

## Active

Stage G1E, Stage RM2, Stage LLN0-LLN1, Stage C1, Stage G2A, Stage G2B, Stage G2C, Stage G2D, Stage G2E, Stage G2E-fix, Stage G2F, Stage G2F-cleanup, Sprint S4, Stage M3, Stage H1, Stage H0, Stage H2A, Stage H2B, Stage H3, Stage H4, Stage H2-cleanup, Stage H5, Stage H6, Stage H6-sharp, and Stage H7 are complete.

The scalar subGaussian forward spine is closed for this milestone:
`CenteredSubGaussianMGF -> SubGaussianTail (2*K) -> Psi2Bound (4*K) -> SubGaussianMomentNatSqrt (16*K)`.
The full real-exponent `SubGaussianMoment` connector and reverse/source MGF links remain deferred.

Target files:
- HighDimProb/Concentration.lean
- HighDimProb/Concentration/LayerCake.lean
- HighDimProb/Concentration/Implications.lean
- HighDimProb/Concentration/MomentImplications.lean
- HighDimProb/Concentration/MGF.lean
- HighDimProb/Concentration/SubGaussianSums.lean
- HighDimProb/Concentration/Hoeffding.lean
- HighDimProb/Concentration/RademacherSums.lean
- HighDimProb/Distributions.lean
- HighDimProb/Distributions/Rademacher.lean
- HighDimProb/Distributions/RademacherFamily.lean
- HighDimProb/ProbabilitySpace.lean
- HighDimProb/RandomMatrix/Algebra.lean
- HighDimProb/RandomMatrix.lean
- HighDimProb/LimitTheorems.lean
- HighDimProb/LimitTheorems/Basic.lean
- HighDimProb/LimitTheorems/WeakLaw.lean
- HighDimProb/LimitTheorems/Assumptions.lean
- HighDimProb/Experimental.lean
- HighDimProbTest/ProbabilityObjectAPI.lean
- HighDimProbTest/MomentImplicationsAPI.lean
- HighDimProbTest/PublicImports.lean
- HighDimProbTest/LayerCakeAPI.lean
- HighDimProbTest/ConcentrationImplicationsAPI.lean
- HighDimProbTest/MGFImplicationsAPI.lean
- HighDimProbTest/SubGaussianSumsAPI.lean
- HighDimProbTest/HoeffdingAPI.lean
- HighDimProbTest/RademacherAPI.lean
- HighDimProbTest/RademacherFamilyAPI.lean
- HighDimProbTest/RademacherSumsAPI.lean
- HighDimProbTest/RandomMatrixProofsAPI.lean
- HighDimProbTest/LimitTheoremsAPI.lean
- HighDimProbTest/ExperimentalImports.lean
- HighDimProbTest/BranchImports.lean
- HighDimProbTest.lean
- docs/LLNPlan.md
- docs/IndependencePlan.md
- docs/AssumptionVocabulary.md
- docs/RademacherPlan.md
- docs/RademacherMilestone.md
- docs/ScalarImplicationGraph.md
- docs/Milestone3.md
- docs/ModuleTree.md
- docs/TheoremAtlas.md
- docs/BookProgress.md
- docs/TermMap.md
- docs/AbstractionLog.md
- docs/TODO.md
- docs/TestPlan.md
- docs/Status.md
- docs/SmallProofBattery.md
- docs/BranchRegistry.md
- docs/LeafPlan.md

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
- `HighDimProbTest.LayerCakeAPI`
- `HighDimProbTest.ConcentrationImplicationsAPI`
- `HighDimProbTest.MGFImplicationsAPI`
- `HighDimProbTest.SubGaussianSumsAPI`
- `HighDimProbTest.HoeffdingAPI`
- `HighDimProbTest.RademacherAPI`
- `HighDimProbTest.RademacherFamilyAPI`
- `HighDimProbTest.RademacherSumsAPI`
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
- Do not prove Bernstein yet.
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
- finite union bound / Boole inequality
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
- concentration layer-cake import boundary
- random matrix theorem statement layer
- deterministic epsilon-net operator norm typed statement
- random matrix assumption vocabulary audit
- small branch proof battery
- random matrix row-dot algebra helpers
- scalar sample independence/iid assumption wrappers
- scalar absolute natural-moment implication pilot
- all-natural absolute-moment factorial bound
- natural absolute-moment to `MemLp` / `realLpNorm` bridge
- factorial-growth natural subGaussian moment predicate
- crude linear `realLpNorm` growth from ψ₂ and subGaussian-tail control
- sharp natural-exponent `realLpNorm <= C*K*sqrt(q)` growth
- sharp natural-exponent subGaussian moment predicate bridge
- forward centered-MGF-to-tail/psi2/natural-moment implication spine
- Milestone 3 scalar implication graph closeout
- canonical Bool Rademacher MGF and tail corollary
- Rademacher/Hoeffding branch readiness plan
- finite product Rademacher family infrastructure
- weighted finite Rademacher sum MGF
- weighted finite Rademacher Hoeffding tail bound
- Rademacher/Hoeffding branch closeout
- weighted Rademacher zero-weight cleanup
- independent finite subGaussian sum MGF
- finite Hoeffding theorem for bounded centered variables
- sharp Wikipedia-form finite Hoeffding bound
- non-centered Wikipedia-form finite Hoeffding bound

Currently processing:
- none; Stage H7 is complete

Not yet processed:
- LLN variance-of-sample-mean proof bridge
- variance-of-finite-sample-sum bridge
- convergence-in-probability HighDimProb alias/wrapper
- sample covariance PSD / symmetry statement layer
- full subGaussian/subExponential equivalence theorems
- real-exponent `SubGaussianMoment` / `SubExponentialMoment` formulation links
- reverse/source MGF formulation implication links
- finite-gauge Orlicz variants
- independent-sum Chernoff inequality variants
- weighted bounded-variable Hoeffding inequality
- Bernstein inequality
- random process
- Gaussian width
- empirical process
- signal recovery

## Blocked

Stage H7 has no build blocker. Independent finite bounded sums now have
one-variable bounded centered MGF wrappers, finite-sum MGF and tail closure, the
existing conservative explicit centered Hoeffding bound, the sharp
classical/Wikipedia centered bound, and the exact non-centered Wikipedia-form
bound around `E[sum_i X_i]` under explicit integrability and the visible
positive denominator assumption. Exact scale-0 `SubGaussianTail` and
`CenteredSubGaussianMGF` wrappers remain unavailable because those predicates
require strictly positive scales.

No current Stage G1E, Stage RM2, Stage LLN0-LLN1, Stage C1, Stage G2A, Stage G2B, Stage G2C, Stage G2D, Stage G2E, Stage G2E-fix, Stage G2F, Stage G2F-cleanup, Sprint S4, Stage H0, Stage H2A, Stage H2B, Stage H2-cleanup, Stage H3, Stage H4, Stage H5, Stage H6, Stage H6-sharp, or Stage H7 build blocker. The finite union bound is proved, the sample-covariance quadratic-form bridge/nonnegativity theorems are proved, the weak-law scaffold now includes sample-mean vocabulary, scalar assumption wrappers, and honest typed statements, and the scalar moment/MGF branch proves fixed-exponent absolute-moment bridges, all-natural absolute moments with factorial constants, natural moment-to-Lp bridges, crude linear real-Lp growth, natural-exponent sharp `sqrt(q)` real-Lp growth, sharp natural-exponent predicate bridges, forward MGF-to-tail/psi2/moment composition, the weighted finite Rademacher Hoeffding specialization, independent finite subGaussian sum MGF/tail closure, finite bounded centered Hoeffding, sharp finite bounded centered Hoeffding, and non-centered finite bounded Hoeffding.

Fixed-scale psi2 and psi1 tail-to-Orlicz reverse implications are proven. Stage G2A proves Psi2Bound -> absMomentNat q=2, SubGaussianTail -> absMomentNat q=2, and the analogous first-moment psi1/subExponential pilot. Stage G2B proves Psi2Bound/SubGaussianTail -> absMomentNat q for all natural q with a crude factorial constant. Stage G2C proves `finiteAbsMomentNat -> MemLp`, quantitative `absMomentNat -> realLpNorm`, and the factorial-growth `SubGaussianMomentNat` wrappers. Stage G2D proves the linear `realLpNorm <= C*K*q` consequence. Stage G2E records the sharp route as typed targets, Stage G2E-fix proves the deterministic envelope plus natural-exponent sqrt-growth moment bounds, Stage G2F packages those bounds as `SubGaussianMomentNatSqrt`, and Sprint S4 proves `CenteredSubGaussianMGF -> SubGaussianTail (2*K) -> Psi2Bound (4*K) -> SubGaussianMomentNatSqrt (16*K)`. The full `SubGaussianMoment` connector is still blocked by the gap from natural exponents to arbitrary finite `ENNReal` exponents; Mathlib has `eLpNorm_le_eLpNorm_of_exponent_le`, but HighDimProb still needs a ceiling/`ENNReal.toReal`/sqrt comparison bridge before this should be promoted. Finite-gauge variants, reverse/source MGF connectors, centered Chebyshev corollaries, deeper scalar concentration inequalities, physical migration of larger branches, random matrix theorem bridge work, and future lint/import minimization remain future stages.

Random matrix theorem statements are blocked except `epsilonNetOperatorNormStatement` because independent entries, iid rows, symmetric random matrices, PSD/order vocabulary, and high-probability theorem syntax are not yet implemented.

Theorem statements blocked by missing infrastructure are tracked in docs/TheoremAtlas.md.

## Next safe task

Stage H8 - weighted bounded Hoeffding theorem.
