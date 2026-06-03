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
- `HighDimProbTest/RandomMatrixOperatorNormAPI.lean`: checks the experimental L2 operator-norm wrapper.
- `HighDimProbTest/RandomMatrixStatementsAPI.lean`: checks random-matrix theorem statement declarations that are currently honest to type.
- `HighDimProbTest/RandomMatrixProofsAPI.lean`: checks small random-matrix proof declarations such as Frobenius-square nonnegativity, sample-covariance diagonal nonnegativity, row-dot helpers, and the sample-covariance quadratic-form algebra/nonnegativity bridge.
- `HighDimProbTest/LimitTheoremsAPI.lean`: checks experimental limit-theorem sample mean vocabulary, finite-sum measurability/integrability bridges, independence/iid assumption wrappers, and weak-law typed statements.
- `HighDimProbTest/NetsMetricEntropyAPI.lean`: downstream-style Mathlib-backed nets, covering, and packing examples.
- `HighDimProbTest/NetsProofsAPI.lean`: checks the first net proof-pilot declarations.
- `HighDimProbTest/BookStatements.lean`: checks typed statement specifications.
- `HighDimProbTest/NoDeepMathYet.lean`: policy marker for theorem-heavy tests deferred to later layers.

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
- Future lint and import minimization are planned, but must not replace build and test checks.

## Current Limits

No theorem-heavy tests before the object layer stabilizes. The weighted Rademacher Hoeffding specialization, finite bounded-variable Hoeffding theorem, subExponential finite-sum MGF scaffold, max-scale/variance-proxy infrastructure, Bernstein typed statements, local quadratic Bernstein corollary, scalar Bernstein min-form theorem, deterministic weighted scalar Bernstein theorem, and scalar concentration closeout import surface are now tested; do not test full subGaussian/subExponential equivalences, random matrix bounds, Johnson-Lindenstrauss, Hanson-Wright, generic chaining, empirical process bounds, or signal recovery guarantees yet.

## Future Lint

TODO: enable `lake lint` and import-minimization checks later with the Batteries/mathlib linter once the object layer and style conventions are stable.
