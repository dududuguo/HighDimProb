# HighDimProb Judge System

The HighDimProb judge suite is a lightweight compile-time OJ-style layer. It
checks that downstream users can import selected public APIs and apply important
theorems or typed statements without relying on local test internals.

## What It Checks

- Stable root imports through `import HighDimProb`.
- Experimental branch imports such as `import HighDimProb.Concentration` and
  `import HighDimProb.RandomMatrix`.
- Public theorem names for basic scalar concentration, Orlicz/tail bridges,
  moment bridges, Rademacher, finite sums, Hoeffding, Bernstein, random-matrix
  PSD/order, sample covariance, variance proxies, operator-norm measurability,
  and matrix concentration statements.
- Repository policy through `scripts/judge_policy_check.py`:
  no forbidden Lean tokens in source/tests/judge files, no theorem-like
  True-bodied declarations including multi-line declarations, no accidental
  stable-root import of `HighDimProb.Experimental`, no non-experimental judge
  imports of `HighDimProb.Experimental`, and complete judge-root imports.

## Current Coverage

- `HighDimProbJudge/Smoke.lean`: minimal stable API smoke checks.
- `HighDimProbJudge/StableImports.lean`: stable root import surface.
- `HighDimProbJudge/Concentration/BasicUse.lean`: Markov, Chebyshev, Boole,
  and scalar tail monotonicity.
- `HighDimProbJudge/Concentration/OrliczTailUse.lean`: subGaussian and
  subExponential Orlicz/tail bridges.
- `HighDimProbJudge/Concentration/MomentUse.lean`: full real-exponent
  subGaussian/subExponential moment bridges and `realLpNorm` growth APIs.
- `HighDimProbJudge/Concentration/RademacherUse.lean`: Rademacher atom,
  weighted Rademacher sum, and Rademacher Hoeffding APIs.
- `HighDimProbJudge/Concentration/SumsUse.lean`: independent subGaussian sums,
  subExponential finite-sum MGF infrastructure, and weighted Bernstein APIs.
- `HighDimProbJudge/Concentration/HoeffdingUse.lean`: classical and weighted
  Hoeffding public theorem applications.
- `HighDimProbJudge/Concentration/BernsteinUse.lean`: scalar and weighted
  Bernstein min-form public theorem applications.
- `HighDimProbJudge/Concentration/SubGaussianUse.lean`: subGaussian moment and
  MGF-to-tail public theorem applications.
- `HighDimProbJudge/RandomMatrix/OperatorNormUse.lean`: operator-norm
  measurability.
- `HighDimProbJudge/RandomMatrix/StatementUse.lean`: matrix Bernstein typed
  statement surface.
- `HighDimProbJudge/RandomMatrix/PSDUse.lean`: explicit PSD/order and
  quadratic-form monotonicity APIs.
- `HighDimProbJudge/RandomMatrix/SampleCovarianceUse.lean`: sample covariance
  PSD and quadratic-form nonnegativity APIs.
- `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean`: matrix square, second
  moment, variance proxy, variance-proxy norm, self-adjointness lemmas, PSD
  typed targets, and matrix Bernstein statement surface.
- `HighDimProbJudge/RandomMatrix/SpectralUse.lean`: lambda-max wrappers,
  ordered endpoint wrappers, quadratic-form bound predicates, monotonicity
  lemmas, two-sided tail events, and spectral tail event APIs.
- `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`: matrix exponential, trace,
  trace-exponential integrand/moment, lintegral trace-exponential moment,
  trace-exp nonnegativity bridges under explicit hypotheses, self-adjoint
  matrix-exponential PSD and trace nonnegativity bridges, random
  self-adjoint trace-exp moment nonnegativity, real/lintegral bridge theorem,
  and remaining typed statement APIs.
- `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`: matrix Laplace RHS and
  lintegral RHS vocabulary, trace-exp threshold events, MB-S5 conditional
  Markov/Laplace bridge APIs, MB-S6 explicit-dominance conditional wrappers,
  and typed Laplace/Chernoff/operator-norm Laplace statement APIs.
- `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`: proof-ready matrix
  Bernstein statement surface, `matrixBernsteinLaplacePrerequisitesStatement`,
  and its main structural/analytic dependencies.

## How It Differs From Normal Tests

`HighDimProbTest` is the regular regression suite. It checks many internal API
surfaces and focused proof declarations.

`HighDimProbJudge` is smaller and user-facing. A judge file should look like a
downstream Lean file: import the public module, `#check` the expected name, and
include a small example when theorem application is readable.

## Assertion Levels

1. `#check theorem_name`
2. `#check (theorem_name : expected_type)`
3. `example ... : expected_conclusion := by exact theorem_name ...`

Use level 2 only when the type is short enough to remain maintainable. Prefer
level 3 examples for large concentration theorems.

## Adding A Judge Case

1. Add a focused file under `HighDimProbJudge/`.
2. Import only the public module a downstream user should import.
3. Add one or more level 1 checks.
4. Add a level 2 type assertion or level 3 application example.
5. Import the new file from `HighDimProbJudge.lean`.
6. Do not import `HighDimProb.Experimental` from ordinary judge files.
7. Run the commands below.

## Commands

```bash
lake build HighDimProbJudge
lake test
python scripts/judge_policy_check.py
```

## MB-S7A Spectral Judge Coverage

`HighDimProbJudge/RandomMatrix/SpectralUse.lean` checks the MB-S7A spectral
bridge split:

- `matrixQuadraticForm_le_lambdaMax_statement` as a typed `Prop`;
- `lambdaMaxUpperTailEvent`;
- the conditional quadratic-form-to-lambda-max bound and event subset helpers;
- zero-dimensional unit-sphere and upper-tail emptiness lemmas.

The judge does not claim the direct Rayleigh theorem, trace-exp spectral
dominance, full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, or Matrix
Bernstein.

## MB-S7A-fix Rayleigh Helper Judge Coverage

`HighDimProbJudge/RandomMatrix/SpectralUse.lean` also checks the MB-S7A-fix
helper bridge:

- `LambdaMaxPSDUpperBound`;
- `matrixQuadraticForm_nonneg_of_posSemidef`;
- `matrixQuadraticForm_smul_one_of_isUnitVector`;
- `matrixQuadraticForm_le_lambdaMax_of_lambdaMax_sub_posSemidef`.
- `matrixQuadraticForm_le_lambdaMax_of_lambdaMaxPSDUpperBound`.

The examples keep the endpoint PSD premise explicit. The judge still treats
`matrixQuadraticForm_le_lambdaMax_statement` as a typed statement, not a
proved direct Rayleigh theorem.

MB-S7A-order adds no new public declarations and therefore no new judge cases.
MB-S7A-index adds ordered endpoint judge cases for `lambdaMaxOrdered`,
`lambdaMaxOrdered_is_greatest_eigenvalue`, `LambdaMaxOrderedPSDUpperBound`, the
ordered PSD-premise-to-Rayleigh helper, and the ordered upper-tail event route.
MB-S7A-abstract adds semantic spectral judge cases for `SpectralUpperBound`,
`RayleighUpperBound`, `scalarUpperTailEvent`, `matrixUpperBoundTailEvent`,
`rayleighUpperBound_of_spectralUpperBound`, the generic quadratic-form
upper-tail subset bridges, and the lambda provider compatibility wrappers.
MB-S7A-provider adds ordered endpoint provider judge cases for
`lambdaMaxOrdered_spectralUpperBound`, `lambdaMaxOrderedPSDUpperBound`, and
`lambdaMaxOrdered_rayleighUpperBound`. The judge still does not claim trace-exp
spectral dominance, full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, or
Matrix Bernstein.

For a full stage verification run:

```bash
lake build
lake build HighDimProbJudge
lake test
python scripts/judge_policy_check.py
```
