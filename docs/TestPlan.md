# Test Plan

## Purpose

The test suite exists to catch public API regressions from future generated changes. Tests should fail when public names disappear, imports break, abstractions become unusable, or downstream-style examples stop elaborating.

## Commands

Run both commands every development round:

```bash
lake build
lake test
```

GitHub Actions mirrors these checks in `.github/workflows/ci.yml`.

## Test Suite Structure

- `HighDimProbTest.lean`: root test module.
- `HighDimProbTest/Smoke.lean`: imports `HighDimProb` and checks core public declarations.
- `HighDimProbTest/PublicImports.lean`: imports stable public modules individually.
- `HighDimProbTest/BranchImports.lean`: imports every branch aggregate and checks representative declarations.
- `HighDimProbTest/ExperimentalImports.lean`: imports experimental scaffold modules through `HighDimProb.Experimental`.
- `HighDimProbTest/ProbabilityObjectAPI.lean`: downstream-style probability object examples, including the finite union bound.
- `HighDimProbTest/UnionBoundAPI.lean`: focused finite union-bound API examples, including a `Fin n`/`Finset.univ` specialization.
- `HighDimProbTest/TailAPI.lean`: downstream-style tail event and tail probability examples.
- `HighDimProbTest/TailProofsAPI.lean`: checks the tail probability monotonicity proof-pilot declarations.
- `HighDimProbTest/LpMomentAPI.lean`: downstream-style Lp and moment vocabulary examples.
- `HighDimProbTest/RealInequalitiesAPI.lean`: checks deterministic real-analysis helpers for sharp moment growth.
- `HighDimProbTest/OrliczAPI.lean`: downstream-style Orlicz and ψ-bound vocabulary examples.
- `HighDimProbTest/SubGaussianAPI.lean`: downstream-style subGaussian predicate-form examples.
- `HighDimProbTest/SubExponentialAPI.lean`: downstream-style subExponential predicate-form examples.
- `HighDimProbTest/ConcentrationAPI.lean`: checks scalar concentration bridge lemmas, Markov/Chebyshev wrappers, and probability-facing concentration aliases.
- `HighDimProbTest/LayerCakeAPI.lean`: checks the reusable layer-cake and exponential-tail calculus import boundary.
- `HighDimProbTest/OrliczToTailAPI.lean`: checks ψ₂/ψ₁ Orlicz-to-tail implication declarations and their lintegral moment bridges.
- `HighDimProbTest/TailToOrliczAPI.lean`: checks the tail-to-Orlicz typed targets, layer-cake bridges, and proved ψ₂ reverse implication.
- `HighDimProbTest/ConcentrationImplicationsAPI.lean`: checks the proved scalar Orlicz/tail, natural-moment, MGF, independent-sum, subExponential-sum, Bernstein, Hoeffding, and Rademacher implication names through `HighDimProb.Concentration.Implications`.
- Stage H6 strengthens `HighDimProbTest/ConcentrationImplicationsAPI.lean` so the aggregate implication import also checks the bounded centered Hoeffding names.
- Stage H6-sharp strengthens the focused and aggregate Hoeffding checks so the sharp eighth-MGF helpers, the sharp `hoeffding_sum_bounded_centered_sharp` theorem, and the existing conservative `hoeffding_sum_bounded_centered` theorem remain discoverable together.
- Stage H7 strengthens the focused and aggregate Hoeffding checks so the centering infrastructure helpers and the non-centered `hoeffding_sum_bounded` theorem are discoverable together with the older centered APIs.
- Stage H7-closeout strengthens branch and implication aggregate checks for the sharp one-sided Hoeffding helpers and the centering helper lemmas, while retaining the focused `HighDimProbTest/HoeffdingAPI.lean` coverage.
- Stage H8 strengthens focused, branch, experimental, and implication aggregate checks for `sum_weighted_centered_eq_weighted_sum_sub_expect_weighted_sum`, `hoeffding_weighted_sum_bounded_centered_sharp`, and `hoeffding_weighted_sum_bounded`.
- Stage SC-closeout adds `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean`, which imports only `HighDimProb.Concentration` and checks representative names from the Markov/Chebyshev, Orlicz/tail, moment, MGF, Rademacher, Hoeffding, subGaussian-sum, subExponential-sum, and Bernstein theorem families.
- Stage B3 strengthens focused, branch, experimental, implication aggregate, and scalar milestone checks for `weightedVarianceProxy`, `weightedMaxScale`, `centeredSubExponentialMGFLIntegral_weighted_sum_mgf_bound_of_iIndepFun_maxScale`, and `bernstein_weighted_sum_subExponential`.
- Stage SC-final records the test coverage audit in `docs/ConcentrationTestCoverage.md`; no complex examples were added because focused `#check` coverage already covers the indexed public theorem names.
- Stage M-real-1 strengthens focused, branch, experimental, implication aggregate, and scalar milestone checks for `realLpNorm_le_natCeil_of_realExponent`, `sqrt_natCeil_toReal_le_two_sqrt`, `realLpNorm_le_sqrt_of_psi2Bound`, `realLpNorm_le_sqrt_of_subGaussianTail`, `subGaussianMoment_of_psi2Bound`, and `subGaussianMoment_of_subGaussianTail`.
- Stage M-real-2 strengthens focused, branch, experimental, implication aggregate, and scalar milestone checks for `abs_pow_le_exp_linear_factorial`, `natCeil_toReal_le_two_mul_toReal`, `absMomentNat_le_of_psi1Bound`, `absMomentNat_le_of_subExponentialTail`, `realLpNorm_nat_le_linear_of_psi1Bound`, `realLpNorm_nat_le_linear_of_subExponentialTail`, `realLpNorm_le_linear_of_psi1Bound`, `realLpNorm_le_linear_of_subExponentialTail`, `subExponentialMoment_of_psi1Bound`, and `subExponentialMoment_of_subExponentialTail`.
- Stage SC-final-update refreshes `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean` to check the subGaussian finite-exponent `realLpNorm` bridge through `import HighDimProb.Concentration`.
- Stage MC2-fix strengthens random-matrix operator-norm tests for the explicit finite-sum L2 norm bridges, both `OperatorNormBoundSq` / `deterministicOperatorNorm` comparison directions, and `isRealRandomVariable_operatorNorm`.
- Stage MC3 adds `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean` and strengthens branch, experimental, and concentration API checks for finite random-matrix sums, independent/centered self-adjoint family vocabulary, pointwise/a.e. operator-norm bounds, matrix square/second moment, variance-proxy matrix/norm declarations, compatibility aliases, and the updated `matrixBernsteinStatement`.
- MB-S1 extends the same API and judge surfaces with checks for `matrixQuadraticForm_matrixSquare_eq_matVecSqNorm_of_selfAdjoint`, `isPSD_matrixSquare_of_selfAdjoint`, `matrixQuadraticForm_matrixExpect`, `isPSD_matrixSecondMoment_of_selfAdjoint`, `matrixQuadraticForm_sum`, `isPSDMatrix_sum`, and `isPSD_matrixVarianceProxy_of_selfAdjoint`.
- Stage MC4-cleanup updates random-matrix concentration and variance-proxy API checks for `IntegrableRandomMatrix` and the refined `matrixBernsteinSelfAdjointStatement`, and removes checks for deleted `matrixLaplaceTransformStatement` / `traceExpMomentBoundStatement` placeholders.
- Stage MC5.1 adds `HighDimProbTest/RandomMatrixSpectralAPI.lean` for lambda-max wrappers, quadratic-form bound predicates, spectral tail events, and typed spectral bridge targets.
- Stage MC5.2 adds `HighDimProbTest/RandomMatrixTraceExpAPI.lean` for matrix exponential, trace, trace-exponential moments, self-adjointness preservation under matrix exponential, and typed trace-exponential bound targets.
- Stage MC5.3 adds `HighDimProbTest/RandomMatrixLaplaceAPI.lean` for matrix Laplace RHS vocabulary and typed matrix Laplace / trace-exp Chernoff / self-adjoint operator-norm Laplace targets, and strengthens `RandomMatrixConcentrationAPI` with the new statement names.
- Stage MB-S2 extends the random-matrix spectral, trace-exp, Laplace, and
  concentration API checks for quadratic-form bound monotonicity, two-sided
  quadratic-form tail events, lintegral trace-exponential moments, lintegral
  Laplace targets, and `matrixBernsteinLaplacePrerequisitesStatement`.
- Stage MB-S3 extends `HighDimProbTest/RandomMatrixTraceExpAPI.lean` and the
  trace-exp judge file for `traceExpIntegrand`,
  `matrixTrace_nonneg_of_posSemidef`,
  `traceMatrixExp_nonneg_of_matrixExp_posSemidef`,
  `matrixExp_posSemidef_of_selfAdjoint_statement`,
  `traceExpMoment_nonneg_of_nonneg`,
  `traceExpMomentLIntegral_nonneg`, and
  `traceExpMomentLIntegral_eq_ofReal_traceExpMoment`.
- Stage MB-S4 extends `HighDimProbTest/RandomMatrixTraceExpAPI.lean` and the
  trace-exp judge file for `matrixExp_posSemidef_of_selfAdjoint`,
  `traceMatrixExp_nonneg_of_selfAdjoint`,
  `traceExpIntegrand_nonneg_of_randomSelfAdjoint`,
  `traceExpMoment_nonneg_of_randomSelfAdjoint`, and self-adjoint scalar
  multiplication/negation bridge lemmas.
- Stage MB-S5 extends `HighDimProbTest/RandomMatrixLaplaceAPI.lean` and
  `HighDimProbJudge/RandomMatrix/LaplaceUse.lean` for
  `traceExpThresholdEvent`, `matrixLaplaceRHSLIntegralDiv`,
  `matrixLaplaceRHSLIntegralDiv_eq_matrixLaplaceRHSLIntegral`,
  `traceExpThresholdEvent_lintegral_bound`, and the two conditional
  `_of_traceExpThreshold_subset` Laplace bridges.
- Stage MB-S6 extends `HighDimProbTest/RandomMatrixLaplaceAPI.lean` and
  `HighDimProbJudge/RandomMatrix/LaplaceUse.lean` for
  `TraceExpDominatesQuadraticFormUpperTail`,
  `traceExpDominatesQuadraticFormUpperTailStatement`, and the conditional
  `_of_traceExpDominatesQuadraticFormUpperTail` Laplace wrappers.
- Stage MB-S7B-semantic extends `HighDimProbTest/RandomMatrixLaplaceAPI.lean`
  and `HighDimProbJudge/RandomMatrix/LaplaceUse.lean` for
  `TraceExpDominatesUpperBound`, the upper-bound-to-trace-exp threshold bridge,
  and the Rayleigh/spectral semantic wrappers into
  `TraceExpDominatesQuadraticFormUpperTail`.
- Stage MB-S9-foundation extends `HighDimProbTest/RandomMatrixTraceExpAPI.lean`,
  `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean`, and the corresponding
  judge files for semantic trace-mgf predicates, semantic variance-proxy bound
  predicates, and the typed `matrixBernsteinTraceMGF_statement` target.
- Stage MB-S9-expectation-linearity-proof extends
  `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean` and
  `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean` for matrix expectation
  add/smul/zero/constant normalization.
- `HighDimProbTest/MomentImplicationsAPI.lean`: checks natural absolute-moment vocabulary, fixed-exponent and all-natural-exponent moment implication theorems, finiteness corollaries, natural moment-to-`MemLp`/`realLpNorm` bridges, crude linear and sharp sqrt real-Lp growth theorems, finite-`ENNReal` exponent monotonicity bridges, `SubGaussianMomentNat`, `SubGaussianMomentNatSqrt`, full `SubGaussianMoment` and `SubExponentialMoment` bridges, sharp natural-exponent predicate bridges, and the sharp typed statement wrappers.
- `HighDimProbTest/MGFImplicationsAPI.lean`: checks the proof-friendly MGF lintegral predicate, the Mathlib-backed MGF bridge, one-sided Chernoff bounds, two-sided tail from MGF, and composed MGF-to-ψ₂/natural-moment corollaries.
- `HighDimProbTest/SubGaussianSumsAPI.lean`: checks independent finite subGaussian sum measurability helpers, Mathlib MGF proxy wrappers, unweighted and weighted centered-MGF theorems, and their tail corollaries.
- `HighDimProbTest/SubExponentialSumsAPI.lean`: checks the proof-friendly subExponential lintegral MGF predicate, max-scale and variance-proxy vocabulary, weighted max-scale and variance-proxy vocabulary, raw finite-sum MGF product bounds, normalized max-scale wrappers, the lintegral finite-sum MGF theorem, weighted scalar-multiple MGF helpers, weighted lintegral finite-sum MGF theorem, and conservative packaged finite-sum MGF closure.
- `HighDimProbTest/BernsteinAPI.lean`: checks the Bernstein rate helper, scalar and weighted typed statements, local one-/two-sided subExponential Chernoff tail theorems, large-regime Chernoff tails, generic min-form Bernstein helpers, the local quadratic finite-sum Bernstein corollary, the full finite-sum min-form theorem from the lintegral predicate, and the deterministic weighted scalar Bernstein theorem.
- `HighDimProbTest/HoeffdingAPI.lean`: checks the bounded centered one-variable MGF wrappers, finite-sum MGF theorem, tail corollary, conservative explicit Hoeffding bound, sharp eighth-MGF helpers, sharp centered explicit Hoeffding bound, finite-sum centering helpers, sharp non-centered explicit Hoeffding bound, weighted centering helper, and sharp centered/non-centered weighted Hoeffding bounds.
- Stage M3 strengthens `HighDimProbTest/ConcentrationImplicationsAPI.lean` so the aggregate implication import checks the tail/Orlicz, natural-moment, and MGF arrows together.
- `HighDimProbTest/RademacherAPI.lean`: checks the canonical Bool Rademacher PMF, measure, probability-measure instance, variable, measurability lemma, interval bound, zero-mean lemma, MGF theorem, and tail corollary.
- `HighDimProbTest/RademacherFamilyAPI.lean`: checks the finite product Rademacher measure/PMF, coordinate family, coordinate measurability, pointwise bounds, zero mean, and coordinate independence.
- `HighDimProbTest/RademacherSumsAPI.lean`: checks weighted finite Rademacher sums, measurability, zero-weight helpers, weighted-coordinate independence, term MGF proxies, the finite-sum MGF proxy, the HighDimProb centered-MGF theorem, the derived subGaussian tail theorem, the explicit Hoeffding bound, and the positive-variance alias.
- Stage H4 audits the Rademacher/Hoeffding mini-domain and confirms focused plus aggregate tests cover every public declaration in the atom, family, and weighted-sum leaves.
- `HighDimProbTest/RandomVectorAPI.lean`: downstream-style random-vector object-layer examples.
- `HighDimProbTest/CovarianceAPI.lean`: downstream-style covariance and centered-vector vocabulary examples.
- `HighDimProbTest/CovarianceProofsAPI.lean`: checks the centered-vector coordinate and centered-scalar proof-pilot declarations.
- `HighDimProbTest/IsotropicAPI.lean`: downstream-style isotropic random-vector vocabulary examples.
- `HighDimProbTest/IsotropicProofsAPI.lean`: checks the isotropic matrix/entrywise proof-pilot declaration.
- `HighDimProbTest/SubGaussianVectorAPI.lean`: downstream-style high-dimensional subGaussian vector predicate examples.
- `HighDimProbTest/RandomMatrixBasicAPI.lean`: checks basic random matrix entry and measurability declarations.
- `HighDimProbTest/RandomMatrixRowsColsAPI.lean`: checks row and column random-vector declarations.
- `HighDimProbTest/RandomMatrixActionAPI.lean`: checks deterministic matrix-vector action declarations.
- `HighDimProbTest/RandomMatrixNormsAPI.lean`: checks Frobenius and entrywise norm-vocabulary declarations.
- `HighDimProbTest/RandomMatrixAssumptionsAPI.lean`: checks entrywise, rowwise, centered, and isotropic random-matrix assumption predicates.
- `HighDimProbTest/RandomMatrixSampleCovarianceAPI.lean`: checks Gram, row Gram, and sample covariance vocabulary declarations.
- `HighDimProbTest/RandomMatrixQuadraticFormAPI.lean`: checks quadratic and bilinear form vocabulary declarations.
- `HighDimProbTest/RandomMatrixOperatorNormAPI.lean`: checks the experimental L2 operator-norm wrapper, MC2 unit-vector vocabulary, explicit matrix-vector squared norm bridge, squared operator-norm bound predicates, retained exact bridge typed statements, proved MC2-fix bridge theorems, and the proved operator-norm measurability theorem.
- `HighDimProbTest/RandomMatrixSpectralAPI.lean`: checks MC5.1/MB-S2 spectral wrappers, MB-S7A-index ordered endpoint wrappers, MB-S7A-abstract semantic spectral upper-bound abstractions, quadratic-form bound predicates, monotonicity lemmas, two-sided tail event vocabulary, subset lemmas, and typed spectral bridge targets.
- `HighDimProbTest/RandomMatrixTraceExpAPI.lean`: checks MC5.2/MB-S2 matrix exponential, trace, trace-exponential moment, lintegral trace-exp moment, self-adjointness preservation, semantic trace-mgf predicates, and typed trace-exponential / trace-mgf bound targets.
- `HighDimProbTest/RandomMatrixLaplaceAPI.lean`: checks MC5.3/MB-S2 matrix Laplace RHS vocabulary, lintegral RHS vocabulary, MB-S5 trace-exp threshold/conditional Markov-Laplace bridge declarations, MB-S6 explicit dominance and conditional dominance-wrapper declarations, MB-S7B-semantic trace-exp upper-bound dominance/event bridges, and typed Laplace/Chernoff/operator-norm statement targets.
- `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean`: checks Stage MC3 finite random-matrix sums, matrix-valued independence/self-adjoint family assumptions, entrywise matrix integrability, pointwise/a.e. operator-norm-bound predicates, matrix square/second-moment/variance-proxy declarations, semantic variance-proxy bound predicates, scalar variance-proxy norm, compatibility aliases, MB-S1 PSD square/second-moment/variance-proxy theorems, MB-S9 matrix expectation PSD/order and add/smul/zero/constant normalization theorems, and the updated matrix Bernstein typed statement.
- `HighDimProbTest/RandomMatrixStatementsAPI.lean`: checks random-matrix theorem statement declarations that are currently honest to type.
- `HighDimProbTest/RandomMatrixConcentrationAPI.lean`: checks Stage MC1 matrix symmetry/self-adjoint, PSD/order, matrix expectation/integrability, concentration-assumption vocabulary, sample-covariance PSD bridge, MC2 quadratic-form monotonicity and unit-sphere operator-norm typed target, MC2-fix operator-norm bridge theorem names, MC3 finite-sum/variance-proxy vocabulary, MC4-cleanup statement honesty names, and typed matrix concentration statement targets.
- `HighDimProbTest/RandomMatrixProofsAPI.lean`: checks small random-matrix proof declarations such as Frobenius-square nonnegativity, sample-covariance diagonal nonnegativity, row-dot helpers, and the sample-covariance quadratic-form algebra/nonnegativity bridge.
- `HighDimProbTest/LimitTheoremsAPI.lean`: checks experimental limit-theorem sample mean vocabulary, finite-sum measurability/integrability bridges, independence/iid assumption wrappers, and weak-law typed statements.
- `HighDimProbTest/NetsMetricEntropyAPI.lean`: downstream-style Mathlib-backed nets, covering, and packing examples.
- `HighDimProbTest/NetsProofsAPI.lean`: checks the first net proof-pilot declarations.
- `HighDimProbTest/BookStatements.lean`: checks typed statement specifications.
- `HighDimProbTest/NoDeepMathYet.lean`: policy marker for theorem-heavy tests deferred to later layers.
- `docs/visualizations/` is documentation-only. Stage V1 verifies it by
  running the import-graph helper script for the local shell, `lake build`, and
  `lake test`; no Lean API test is added because no Lean declaration is
  introduced.
- `HighDimProbJudge`: compile-time OJ-style judge library for downstream API
  use cases. It is built separately with `lake build HighDimProbJudge`.
- Stage J2 expands `HighDimProbJudge` with downstream-style judge files for
  basic concentration, Orlicz/tail bridges, moment bridges, Rademacher,
  subGaussian/subExponential sums, random-matrix PSD/order, sample covariance,
  and variance-proxy APIs.
- Stage MC5.5, MB-S2, MB-S5, and MB-S6 expand `HighDimProbJudge` with random-matrix
  spectral, trace-exponential, Laplace, and proof-ready matrix Bernstein
  statement judge files, including MB-S2 lintegral and two-sided-event APIs
  plus MB-S5 conditional trace-exp threshold and MB-S6 explicit-dominance
  Laplace bridge APIs.

## Stable vs Experimental Policy

- Stable v0.1 modules are imported through `import HighDimProb`.
- Experimental v0.2+ modules are imported through `import HighDimProb.Experimental`.
- No module is promoted from experimental to stable without tests, docs, a `docs/Status.md` update, and a stable root import audit.
- Stable import tests must not depend on experimental declarations.
- Experimental import tests must make experimental status explicit.

## Milestone 1 Audit

- Stable v0.1 API coverage is checked by `HighDimProbTest/Smoke.lean`, `HighDimProbTest/PublicImports.lean`, and focused API files for probability objects, tails, Lp/moments, Orlicz, subGaussian, subExponential, and book statements.
- Experimental v0.2 API coverage is checked by `HighDimProbTest/ExperimentalImports.lean` and focused API files for random vectors, covariance, isotropicity, subGaussian vectors, nets, and metric entropy.
- Scaffold-only modules are checked through `import HighDimProb.Experimental`; they are not imported by stable public tests.

## API Regression Policy

- Stable public API is tested through `import HighDimProb`.
- Stable probability infrastructure such as `measure_biUnion_le` is checked through public imports, downstream-style probability object examples, and the focused union-bound API module.
- Scalar centering and variance leaves are tested through the stable public import path and through covariance compatibility tests.
- Every stable module must have public import or focused stable API tests.
- Scaffold modules are tested only through `import HighDimProb.Experimental`.
- Every experimental module must have experimental import or focused experimental API tests.
- Every stage must keep stable and experimental imports separated.
- Any promotion from experimental to stable must be intentional and audited.
- Every new public module must get one test file or an explicit addition to an existing test file.
- Every branch aggregate module, including reserved aggregates, must have import tests.
- Every new public declaration must get at least one `#check` or tiny example.
- Every proof pilot needs a proof-focused test file checking the new proof declarations.
- Every small proof battery lemma must be covered by an existing proof/API test file or a new focused proof test file.
- Every Orlicz-to-tail bridge must have API tests for both the implication theorem and the supporting exponential-moment bridge.
- Every tail-to-Orlicz module must test typed targets, public tail-integral bridges, and any proved reverse implication.
- Every concentration implication graph module must test the collected theorem names without introducing canonical predicates prematurely.
- Every moment-implication pilot must test the moment normal form, constants, Lp bridge declarations, and any typed all-exponent statement separately from full equivalence theorem tests.
- Every MGF implication pilot must test the lintegral normal form, one-sided tail constants, two-sided tail scale, and composition corollaries without adding a canonical subGaussian predicate.
- Every bounded-variable Hoeffding theorem must have focused API checks and aggregate implication-import checks for its public theorem names.
- Every sharp Hoeffding constant helper must be tested beside the theorem that consumes it, and the older conservative theorem must stay checked in the same round.
- Every distribution atom used by concentration proofs must have a focused API test and must remain experimental unless promoted through a root import audit.
- Every random matrix submodule must have its own API test file before theorem work depends on it.
- Random-matrix statement modules should `#check` only typed `Prop` specifications; blocked theorem families remain documentation entries.
- Tests should import public modules the way downstream users would.
- Tests should catch broken names, broken imports, wrong abstraction choices, and unusable APIs.
- Keep tests separate from main package code.
- `lake build` and `lake test` are mandatory for every round.
- Judge cases should import public modules the way external users would and use
  `#check`, explicit type assertions, or direct theorem application examples.
- `scripts/judge_policy_check.py` enforces forbidden-token, True-bodied declaration, stable
  root import, judge experimental-import boundary, and judge-root
  import-completeness checks.
- Future lint and import minimization are planned, but must not replace build and test checks.

## Current Limits

No theorem-heavy tests before the object layer stabilizes. The weighted Rademacher Hoeffding specialization, finite bounded-variable Hoeffding theorem, subExponential finite-sum MGF scaffold, max-scale/variance-proxy infrastructure, Bernstein typed statements, local quadratic Bernstein corollary, scalar Bernstein min-form theorem, deterministic weighted scalar Bernstein theorem, scalar concentration closeout import surface, MC1 matrix concentration vocabulary/statement layer, MC2 operator-norm/unit-sphere bridge vocabulary, MC2-fix operator-norm bridge/measurability theorems, MC3 finite random-matrix sum / variance-proxy infrastructure, MC4-cleanup statement honesty surface, MB-S1 matrix PSD variance-proxy algebra, V1 visualization script/docs layer, J1 compile-time judge suite, and J2 expanded judge coverage are now checked; do not test full subGaussian/subExponential equivalences, random matrix bounds, matrix Bernstein proofs, Johnson-Lindenstrauss, Hanson-Wright, generic chaining, empirical process bounds, or signal recovery guarantees yet.

## Future Lint

TODO: enable `lake lint` and import-minimization checks later with the Batteries/mathlib linter once the object layer and style conventions are stable.

## MB-S7A Spectral Bridge Coverage

- `HighDimProbTest/RandomMatrixSpectralAPI.lean` checks the new typed
  Rayleigh split, conditional lambda-max upper-bound/event helpers, and
  zero-dimensional unit-sphere/tail emptiness lemmas.
- `HighDimProbJudge/RandomMatrix/SpectralUse.lean` mirrors those checks for
  downstream-style API use.
- The test and judge coverage intentionally treats
  `matrixQuadraticForm_le_lambdaMax_statement` as a typed `Prop`, not as a
  proved theorem.

## MB-S7A-fix Rayleigh Conversion Helper Coverage

- `HighDimProbTest/RandomMatrixSpectralAPI.lean` checks
  `LambdaMaxPSDUpperBound`, `matrixQuadraticForm_nonneg_of_posSemidef`,
  `matrixQuadraticForm_smul_one_of_isUnitVector`, and
  both conditional Rayleigh wrappers.
- The test examples apply each helper with explicit hypotheses, including the
  Mathlib PSD premise `((lambdaMax A hA) • 1 - A).PosSemidef`.
- `HighDimProbJudge/RandomMatrix/SpectralUse.lean` mirrors those checks for
  external API use.
- The direct Rayleigh theorem remains unproved and is still tested only through
  `matrixQuadraticForm_le_lambdaMax_statement` as a typed `Prop`.

## MB-S7A-clean API Consolidation Coverage

- `HighDimProbTest/RandomMatrixSpectralAPI.lean` and
  `HighDimProbJudge/RandomMatrix/SpectralUse.lean` both check the named
  endpoint premise `LambdaMaxPSDUpperBound` and the wrapper
  `matrixQuadraticForm_le_lambdaMax_of_lambdaMaxPSDUpperBound`.
- This coverage is API-only. It does not claim `LambdaMaxPSDUpperBound` is
  proved from self-adjointness.

## MB-S7A-order Probe Coverage

- MB-S7A-order added no public declarations, so no test or judge file changed.
- The validation scratch probe checks the relevant Mathlib ordered-eigenvalue
  APIs and records the missing index-normalization bridge.

## MB-S7A-index Ordered Endpoint Coverage

- `HighDimProbTest/RandomMatrixSpectralAPI.lean` and
  `HighDimProbJudge/RandomMatrix/SpectralUse.lean` both check:
  `lambdaMaxOrdered`, `lambdaMaxOrdered_eq_eigenvalues₀_zero`,
  `lambdaMax_eq_lambdaMaxOrdered_statement`,
  `lambdaMaxOrdered_is_greatest_eigenvalue_statement`,
  `lambdaMaxOrdered_is_greatest_eigenvalue`,
  `LambdaMaxOrderedPSDUpperBound`,
  `matrixQuadraticForm_le_lambdaMaxOrdered_statement`,
  `matrixQuadraticForm_le_lambdaMaxOrdered_of_lambdaMaxOrderedPSDUpperBound`,
  `lambdaMaxOrderedUpperTailEvent`, and the ordered upper-tail subset helper.
- Coverage proves only the ordered endpoint theorem and conditional helpers.
  It does not claim the unconditional endpoint PSD theorem, direct Rayleigh
  theorem, trace-exp spectral dominance, full matrix Laplace, trace-mgf,
  Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S7A-abstract Semantic Spectral API Coverage

- `HighDimProbTest/RandomMatrixSpectralAPI.lean` and
  `HighDimProbJudge/RandomMatrix/SpectralUse.lean` both check:
  `SpectralUpperBound`, `RayleighUpperBound`, `scalarUpperTailEvent`,
  `matrixUpperBoundTailEvent`, `rayleighUpperBound_of_spectralUpperBound`,
  the generic quadratic-form upper-tail subset lemmas, the lambda provider
  projections to `SpectralUpperBound`, and the lambda event compatibility
  wrappers.
- Coverage proves only semantic consequences from explicit assumptions. The
  ordered provider theorem is covered in MB-S7A-provider below; trace-exp
  spectral dominance, full matrix Laplace, trace-mgf, Golden-Thompson, Lieb,
  and Matrix Bernstein remain unproved.

## MB-S7A-provider Ordered Endpoint Provider Coverage

- `HighDimProbTest/RandomMatrixSpectralAPI.lean` and
  `HighDimProbJudge/RandomMatrix/SpectralUse.lean` both check:
  `lambdaMaxOrdered_spectralUpperBound`, `lambdaMaxOrderedPSDUpperBound`, and
  `lambdaMaxOrdered_rayleighUpperBound`.
- The examples apply each provider theorem with an explicit
  `hA : IsSelfAdjointMatrix A` hypothesis.
- Coverage proves only the ordered endpoint provider/Rayleigh route. It does
  not claim trace-exp spectral dominance, full matrix Laplace, trace-mgf,
  Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S7B-scalar-endpoint Ordered Endpoint Coverage

- `HighDimProbTest/RandomMatrixSpectralAPI.lean` and
  `HighDimProbJudge/RandomMatrix/SpectralUse.lean` both check
  `lambdaMaxOrdered_smul_of_nonneg`.
- The examples pass explicit `hTheta : 0 <= theta` and
  `hA : IsSelfAdjointMatrix A` hypotheses.
- Coverage proves only nonnegative scalar multiplication for the ordered
  endpoint. It does not claim the `lambdaMaxOrdered` trace-exp provider
  theorem, exponential spectral mapping, trace endpoint dominance, full matrix
  Laplace, trace-mgf, Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S7B-exp-spectral-mapping TraceExp Coverage

- `HighDimProbTest/RandomMatrixTraceExpAPI.lean` and
  `HighDimProbJudge/RandomMatrix/TraceExpUse.lean` both check
  `lambdaMaxOrdered_matrixExp`.
- The examples pass an explicit `hA : IsSelfAdjointMatrix A` hypothesis.
- Coverage proves only ordered endpoint spectral mapping for `matrixExp`. It
  does not claim the `lambdaMaxOrdered` trace-exp provider theorem,
  trace endpoint dominance, full matrix Laplace, trace-mgf, Golden-Thompson,
  Lieb, or Matrix Bernstein.

## MB-S7B-trace-dominates-endpoint Spectral Coverage

- `HighDimProbTest/RandomMatrixSpectralAPI.lean` and
  `HighDimProbJudge/RandomMatrix/SpectralUse.lean` both check
  `lambdaMaxOrdered_le_trace_of_posSemidef`.
- The examples pass explicit `hA : IsSelfAdjointMatrix A` and
  `hPSD : Matrix.PosSemidef A` hypotheses.
- Coverage proves only ordered endpoint trace domination. It does not claim the
  `lambdaMaxOrdered` trace-exp provider theorem, full matrix Laplace,
  trace-mgf, Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S7B-semantic Trace-Exp Dominance Coverage

- `HighDimProbTest/RandomMatrixLaplaceAPI.lean` and
  `HighDimProbJudge/RandomMatrix/LaplaceUse.lean` both check:
  `TraceExpDominatesUpperBound`,
  `matrixUpperBoundTailEvent_subset_traceExpThresholdEvent_of_traceExpDominatesUpperBound`,
  `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_rayleighUpperBound_of_traceExpDominatesUpperBound`,
  `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_spectralUpperBound_of_traceExpDominatesUpperBound`,
  `traceExpDominatesQuadraticFormUpperTail_of_rayleighUpperBound_of_traceExpDominatesUpperBound`,
  and
  `traceExpDominatesQuadraticFormUpperTail_of_spectralUpperBound_of_traceExpDominatesUpperBound`.
- The examples pass `hTheta`, Rayleigh/spectral upper-bound assumptions, and
  pointwise `TraceExpDominatesUpperBound` assumptions explicitly.
- Coverage proves only semantic event bridges. It does not claim the
  `lambdaMaxOrdered` trace-exp provider theorem, spectral mapping, full matrix
  Laplace, trace-mgf, Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S7B-provider-close Trace-Exp Provider Coverage

- `HighDimProbTest/RandomMatrixLaplaceAPI.lean` and
  `HighDimProbJudge/RandomMatrix/LaplaceUse.lean` both check
  `lambdaMaxOrdered_traceExpDominatesUpperBound`.
- The examples pass explicit `hA : IsSelfAdjointMatrix A`, `theta`, and
  `hTheta : 0 <= theta` hypotheses.
- Coverage proves only the deterministic `lambdaMaxOrdered`
  `TraceExpDominatesUpperBound` provider. It does not claim the concrete
  random-matrix dominance assembly, full matrix Laplace, trace-mgf,
  Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S7C-assemble-dominance Coverage

- `HighDimProbTest/RandomMatrixLaplaceAPI.lean` and
  `HighDimProbJudge/RandomMatrix/LaplaceUse.lean` both check
  `traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint`.
- The examples pass explicit
  `hY : RandomSelfAdjointMatrix P Y` and `hTheta : 0 <= theta` hypotheses.
- Coverage proves only the concrete `TraceExpDominatesQuadraticFormUpperTail`
  assembly for random self-adjoint matrices. It does not claim full matrix
  Laplace, trace-mgf, Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S8-laplace-assembly Coverage

- `HighDimProbTest/RandomMatrixLaplaceAPI.lean` and
  `HighDimProbJudge/RandomMatrix/LaplaceUse.lean` both check
  `matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint` and
  `matrixLaplaceTransformLIntegral_of_randomSelfAdjoint`.
- The examples pass explicit `hMeas`, `hY : RandomSelfAdjointMatrix P Y`, and
  `hTheta : 0 <= theta` hypotheses.
- Coverage proves only concrete lintegral Laplace wrappers. It does not claim
  the real RHS bridge, trace-mgf, Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S9-foundation Coverage

- `HighDimProbTest/RandomMatrixTraceExpAPI.lean` and
  `HighDimProbJudge/RandomMatrix/TraceExpUse.lean` both check:
  `TraceMGFBound`, `TraceMGFBoundLIntegral`,
  `TraceMGFVarianceProxyBound`, `TraceMGFVarianceProxyBoundLIntegral`,
  `traceMGFBound_statement`, `traceMGFBoundLIntegral_statement`, and
  `traceMGFVarianceProxyBound_statement`.
- `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean` and
  `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean` check
  `MatrixVarianceProxyUpperBound` and `MatrixVarianceProxyNormBound`.
- `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean` and
  `HighDimProbJudge/RandomMatrix/StatementUse.lean` check
  `matrixBernsteinTraceMGF_statement`.
- Coverage is definitional and typed-statement coverage only. It does not
  claim Golden-Thompson, Lieb, the full trace-mgf master theorem, the real RHS
  bridge, or Matrix Bernstein.

## MB-S9-Tropp-master-typed-primitive Coverage

- `HighDimProbTest/RandomMatrixTraceExpAPI.lean` checks
  `troppMasterTraceMGFStep_statement`.
- The focused example applies an explicit
  `hTropp : troppMasterTraceMGFStep_statement (P := P) A Y` hypothesis to
  explicit self-adjointness, random self-adjointness, trace-exp integrability,
  matrix-exponential entrywise integrability, self-adjoint expected
  exponential, and strict-positive expected exponential assumptions.
- Coverage is typed-statement usage only. It does not claim Lieb concavity,
  Golden-Thompson, the trace-mgf provider, the full trace-mgf master theorem,
  the real RHS bridge, or Matrix Bernstein.

## MB-S9-single-summand-mgf-typed-primitive Coverage

- `HighDimProbTest/RandomMatrixTraceExpAPI.lean` checks
  `singleSummandMatrixMGFVarianceProxy_statement`.
- `HighDimProbJudge/RandomMatrix/TraceExpUse.lean` exposes a minimal
  `Prop` example for the typed primitive.
- Coverage is typed-statement usage only. It does not claim the
  scalar-to-matrix functional-calculus bridge, matrix-valued expectation
  monotonicity, operator-norm-to-spectral-interval bridge, trace-mgf provider,
  Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S9-bernstein-cfc-typed-primitive Coverage

- `HighDimProbTest/RandomMatrixTraceExpAPI.lean` checks
  `bernsteinMatrixExp_le_quadratic_statement`.
- `HighDimProbJudge/RandomMatrix/TraceExpUse.lean` exposes a minimal
  `Prop` example for the typed primitive.
- Coverage is typed-statement usage only. It does not claim the
  functional-calculus proof, single-summand MGF theorem,
  operator-norm-to-spectral-interval bridge, trace-mgf provider,
  Golden-Thompson, Lieb, or Matrix Bernstein.

## MB-S9-PSD-expectation-proof Coverage

- `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean` checks
  `integrableRandomMatrix_sub`, `matrixExpect_sub`,
  `isPSDMatrix_matrixExpect_of_pointwise_isPSD`, and
  `matrixExpect_matrixLE_of_pointwise_matrixLE`.
- Focused examples pass explicit entrywise integrability, pointwise PSD, and
  pointwise `MatrixLE` assumptions.
- Coverage proves no single-summand MGF, functional calculus, trace-mgf
  provider, Golden-Thompson, Lieb, or Matrix Bernstein theorem.

## MB-S9-expectation-linearity-proof Coverage

- `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean` and
  `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean` check
  `integrableRandomMatrix_add`, `integrableRandomMatrix_smul`,
  `integrableRandomMatrix_zero`, `integrableRandomMatrix_const`,
  `matrixExpect_add`, `matrixExpect_smul`, `matrixExpect_zero`,
  `matrixExpect_const`, `matrixExpect_const_of_isProbabilityMeasure`, and
  `matrixExpect_one_of_isProbabilityMeasure`.
- Focused examples pass explicit entrywise integrability, finite-measure, and
  probability-measure assumptions where the public declarations require them.
- Coverage proves no single-summand MGF, functional calculus, trace-mgf
  provider, Golden-Thompson, Lieb, or Matrix Bernstein theorem.

## MB-S9-matrixle-algebra-proof Coverage

- `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean` and
  `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean` check
  `matrixQuadraticForm_add`, `matrixQuadraticForm_smul`,
  `isPSDMatrix_zero`, `isPSDMatrix_add`,
  `isPSDMatrix_smul_of_nonneg`, `matrixLE_refl`, `matrixLE_of_eq`,
  `matrixLE_trans`, `matrixLE_add`, `matrixLE_add_left`,
  `matrixLE_add_right`, and `matrixLE_smul_of_nonneg`.
- Focused examples use reflexivity, transitivity, addition monotonicity, and
  nonnegative scalar multiplication for `MatrixLE`.
- Coverage proves no single-summand MGF, Bernstein CFC primitive,
  trace-mgf provider, Golden-Thompson, Lieb, or Matrix Bernstein theorem.

## MB-S9-bernstein-coefficient-proof Coverage

- `HighDimProbTest/RandomMatrixTraceExpAPI.lean` checks
  `bernsteinCoefficient_nonneg` and applies it to an explicit
  `abs theta * R < 3` hypothesis.
- Coverage proves no single-summand MGF provider, Bernstein CFC primitive,
  downstream matrix exponential lower bound, trace-mgf provider,
  Golden-Thompson, Lieb, or Matrix Bernstein theorem.

## MB-S9-exp-lower-bound-proof Coverage

- `HighDimProbTest/RandomMatrixTraceExpAPI.lean` checks
  `matrixLE_one_add_self_le_matrixExp_of_selfAdjoint` and
  `matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint`.
- Focused examples apply both the generic lower bound and scalar-multiple
  wrapper to explicit self-adjointness hypotheses.
- Coverage proves no single-summand MGF provider, Bernstein CFC primitive,
  trace-mgf provider, Golden-Thompson, Lieb, or Matrix Bernstein theorem.

## MB-S9-single-summand-provider-under-cfc Coverage

- `HighDimProbTest/RandomMatrixTraceExpAPI.lean` checks
  `singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic`.
- The focused example passes an explicit pointwise
  `bernsteinMatrixExp_le_quadratic_statement` assumption plus all assumptions
  exposed by `singleSummandMatrixMGFVarianceProxy_statement`.
- `HighDimProbJudge/RandomMatrix/TraceExpUse.lean` mirrors the downstream
  usage shape with fully qualified names.
- Coverage proves no Bernstein CFC primitive, Tropp/Lieb primitive,
  trace-mgf provider, Golden-Thompson, Lieb, or Matrix Bernstein theorem.

## MB-S9-rhs-normalization-proof Coverage

- `HighDimProbTest/RandomMatrixTraceExpAPI.lean` checks
  `bernsteinMGFCoeff`, `bernsteinMGFCoeff_nonneg`,
  `TraceMGFBernsteinVarianceProxyBound`,
  `TraceMGFBernsteinVarianceProxyBoundLIntegral`, and
  `traceMGFBernsteinVarianceProxyBound_statement`.
- `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean` checks
  `matrixBernsteinTraceMGFWithBernsteinCoeff_statement`.
- `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`,
  `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`,
  `HighDimProbJudge/RandomMatrix/StatementUse.lean`, and
  `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean` mirror the bounded
  Bernstein RHS target.
- Coverage proves no trace-mgf provider, Bernstein CFC primitive,
  Tropp/Lieb primitive, Golden-Thompson, Lieb, or Matrix Bernstein theorem.

## MB-S9-tropp-shape-refactor Coverage

- `HighDimProbTest/RandomMatrixTraceExpAPI.lean` checks
  `troppMasterTraceMGFFiniteFamily_statement` and its finite-family typed
  `Prop` instantiation.
- `HighDimProbJudge/RandomMatrix/TraceExpUse.lean` checks
  `HighDimProb.troppMasterTraceMGFFiniteFamily_statement`.
- Coverage preserves `troppMasterTraceMGFStep_statement` and proves no Lieb,
  Golden-Thompson, trace-mgf provider, or Matrix Bernstein theorem.
## MB-S9 Trace-MGF Thin Wrapper Coverage

- `HighDimProbTest/RandomMatrixTraceExpAPI.lean` checks
  `traceMGFBernsteinVarianceProxyBound_of_troppMasterTraceMGFFiniteFamily`.
- `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean` checks
  `matrixBernsteinTraceMGFWithBernsteinCoeff_of_troppMasterTraceMGFFiniteFamily`.
- These are API checks only; they do not prove Tropp/Lieb, the Bernstein CFC
  primitive, or Matrix Bernstein.

## MB-S9 Matrix Bernstein Trace-MGF Under Primitives Coverage

- `HighDimProbTest/RandomMatrixConcentrationAPI.lean` checks
  `matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives`.
- This coverage confirms the public wrapper is exported. It does not prove
  Tropp/Lieb, the Bernstein CFC primitive, or the Matrix Bernstein tail
  theorem.
