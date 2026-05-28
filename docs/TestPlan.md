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
- `HighDimProbTest/ProbabilityObjectAPI.lean`: downstream-style probability object examples.
- `HighDimProbTest/TailAPI.lean`: downstream-style tail event and tail probability examples.
- `HighDimProbTest/TailProofsAPI.lean`: checks the tail probability monotonicity proof-pilot declarations.
- `HighDimProbTest/LpMomentAPI.lean`: downstream-style Lp and moment vocabulary examples.
- `HighDimProbTest/OrliczAPI.lean`: downstream-style Orlicz and ψ-bound vocabulary examples.
- `HighDimProbTest/SubGaussianAPI.lean`: downstream-style subGaussian predicate-form examples.
- `HighDimProbTest/SubExponentialAPI.lean`: downstream-style subExponential predicate-form examples.
- `HighDimProbTest/ConcentrationAPI.lean`: checks scalar concentration bridge lemmas, Markov/Chebyshev wrappers, and probability-facing concentration aliases.
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
- Every random matrix submodule must have its own API test file before theorem work depends on it.
- Tests should import public modules the way downstream users would.
- Tests should catch broken names, broken imports, wrong abstraction choices, and unusable APIs.
- Keep tests separate from main package code.
- `lake build` and `lake test` are mandatory for every round.
- Future lint and import minimization are planned, but must not replace build and test checks.

## Current Limits

No theorem-heavy tests before the object layer stabilizes. Do not test Hoeffding, Bernstein, subGaussian equivalences, random matrix bounds, Johnson-Lindenstrauss, Hanson-Wright, generic chaining, empirical process bounds, or signal recovery guarantees yet.

## Future Lint

TODO: enable `lake lint` and import-minimization checks later with the Batteries/mathlib linter once the object layer and style conventions are stable.
