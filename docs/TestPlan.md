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
- `HighDimProbTest/ExperimentalImports.lean`: imports experimental scaffold modules through `HighDimProb.Experimental`.
- `HighDimProbTest/ProbabilityObjectAPI.lean`: downstream-style probability object examples.
- `HighDimProbTest/TailAPI.lean`: downstream-style tail event and tail probability examples.
- `HighDimProbTest/LpMomentAPI.lean`: downstream-style Lp and moment vocabulary examples.
- `HighDimProbTest/OrliczAPI.lean`: downstream-style Orlicz and ψ-bound vocabulary examples.
- `HighDimProbTest/SubGaussianAPI.lean`: downstream-style subGaussian predicate-form examples.
- `HighDimProbTest/SubExponentialAPI.lean`: downstream-style subExponential predicate-form examples.
- `HighDimProbTest/RandomVectorAPI.lean`: downstream-style random-vector object-layer examples.
- `HighDimProbTest/CovarianceAPI.lean`: downstream-style covariance and centered-vector vocabulary examples.
- `HighDimProbTest/IsotropicAPI.lean`: downstream-style isotropic random-vector vocabulary examples.
- `HighDimProbTest/SubGaussianVectorAPI.lean`: downstream-style high-dimensional subGaussian vector predicate examples.
- `HighDimProbTest/NetsMetricEntropyAPI.lean`: downstream-style Mathlib-backed nets, covering, and packing examples.
- `HighDimProbTest/BookStatements.lean`: checks typed statement specifications.
- `HighDimProbTest/NoDeepMathYet.lean`: policy marker for theorem-heavy tests deferred to later layers.

## Milestone 1 Audit

- Stable v0.1 API coverage is checked by `HighDimProbTest/Smoke.lean`, `HighDimProbTest/PublicImports.lean`, and focused API files for probability objects, tails, Lp/moments, Orlicz, subGaussian, subExponential, and book statements.
- Experimental v0.2 API coverage is checked by `HighDimProbTest/ExperimentalImports.lean` and focused API files for random vectors, covariance, isotropicity, subGaussian vectors, nets, and metric entropy.
- Scaffold-only modules are checked through `import HighDimProb.Experimental`; they are not imported by stable public tests.

## API Regression Policy

- Stable public API is tested through `import HighDimProb`.
- Scaffold modules are tested only through `import HighDimProb.Experimental`.
- Every stage must promote modules from experimental to stable intentionally.
- Every new public module must get one test file or an explicit addition to an existing test file.
- Every new public declaration must get at least one `#check` or tiny example.
- Tests should import public modules the way downstream users would.
- Tests should catch broken names, broken imports, wrong abstraction choices, and unusable APIs.
- Keep tests separate from main package code.

## Current Limits

No theorem-heavy tests before the object layer stabilizes. Do not test Hoeffding, Bernstein, subGaussian equivalences, random matrix bounds, Johnson-Lindenstrauss, Hanson-Wright, generic chaining, empirical process bounds, or signal recovery guarantees yet.

## Future Lint

TODO: enable `lake lint` later with the Batteries/mathlib linter once the object layer and style conventions are stable.
