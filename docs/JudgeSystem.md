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
  imports of `HighDimProb.Experimental`, complete judge-root imports, and no
  anonymous negated random-matrix families in checked public signatures.
  Introduce a named `def` or `abbrev` before exposing such a family in a theorem,
  structure field, test surface, judge surface, or downstream-facing adapter.

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
  moment, variance proxy, semantic variance-proxy bounds,
  variance-proxy norm, self-adjointness lemmas, matrix expectation PSD/order
  and add/smul/zero/constant normalization lemmas, PSD typed targets, and
  matrix Bernstein statement surface.
- `HighDimProbJudge/RandomMatrix/SpectralUse.lean`: lambda-max wrappers,
  ordered endpoint wrappers, quadratic-form bound predicates, monotonicity
  lemmas, two-sided tail events, and spectral tail event APIs.
- `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`: matrix exponential, trace,
  trace-exponential integrand/moment, lintegral trace-exponential moment,
  semantic trace-mgf predicates, trace-exp nonnegativity bridges under
  explicit hypotheses, self-adjoint matrix-exponential PSD and trace
  nonnegativity bridges, random self-adjoint trace-exp moment nonnegativity,
  real/lintegral bridge theorem, and remaining typed statement APIs.
- `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`: matrix Laplace RHS and
  lintegral RHS vocabulary, trace-exp threshold events, MB-S5 conditional
  Markov/Laplace bridge APIs, MB-S6 explicit-dominance conditional wrappers,
  MB-S7B-semantic trace-exp upper-bound dominance/event bridges, and typed
  Laplace/Chernoff/operator-norm Laplace statement APIs.
- `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`: proof-ready matrix
  Bernstein statement surface, `matrixBernsteinLaplacePrerequisitesStatement`,
  `matrixBernsteinTraceMGF_statement`, and its main structural/analytic
  dependencies.

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

MB-S9-tropp-shape-refactor adds focused judge coverage for
`HighDimProb.troppMasterTraceMGFFiniteFamily_statement` in
`HighDimProbJudge/RandomMatrix/TraceExpUse.lean`. The one-step
`troppMasterTraceMGFStep_statement` remains covered. The judge examples do not
prove Lieb, Golden-Thompson, the trace-mgf provider, or Matrix Bernstein.

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

MB-S7B-scalar-endpoint adds Spectral judge cases for
`lambdaMaxOrdered_smul_of_nonneg` with explicit `0 <= theta` and
self-adjointness hypotheses. The judge still does not claim the
`lambdaMaxOrdered` trace-exp provider theorem, exponential spectral mapping,
trace endpoint dominance, full matrix Laplace, trace-mgf, Golden-Thompson,
Lieb, or Matrix Bernstein.

MB-S7B-exp-spectral-mapping adds TraceExp judge cases for
`lambdaMaxOrdered_matrixExp` with explicit self-adjointness hypotheses. The
judge still does not claim the `lambdaMaxOrdered` trace-exp provider theorem,
trace endpoint dominance, full matrix Laplace, trace-mgf, Golden-Thompson,
Lieb, or Matrix Bernstein.

MB-S7B-trace-dominates-endpoint adds Spectral judge cases for
`lambdaMaxOrdered_le_trace_of_posSemidef` with explicit self-adjointness and
positive-semidefiniteness hypotheses. The judge still does not claim the
`lambdaMaxOrdered` trace-exp provider theorem, full matrix Laplace, trace-mgf,
Golden-Thompson, Lieb, or Matrix Bernstein.

MB-S7B-semantic adds Laplace judge cases for `TraceExpDominatesUpperBound`, the
upper-bound-tail to trace-exp threshold bridge, and the Rayleigh/spectral
semantic wrappers into `TraceExpDominatesQuadraticFormUpperTail`. The examples
keep `0 <= theta` and pointwise trace-exp dominance assumptions explicit. The
judge still does not claim the `lambdaMaxOrdered` trace-exp provider theorem,
spectral mapping, full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, or
Matrix Bernstein.

MB-S7B-provider-close adds a Laplace judge case for
`lambdaMaxOrdered_traceExpDominatesUpperBound` with explicit self-adjointness
and `0 <= theta` hypotheses. The judge still does not claim the concrete
random-matrix dominance assembly, full matrix Laplace, trace-mgf,
Golden-Thompson, Lieb, or Matrix Bernstein.

MB-S7C-assemble-dominance adds a Laplace judge case for
`traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint` with explicit
random self-adjointness and `0 <= theta` hypotheses. The judge still does not
claim full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, or Matrix
Bernstein.

MB-S8-laplace-assembly adds Laplace judge cases for
`matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint` and
`matrixLaplaceTransformLIntegral_of_randomSelfAdjoint` with explicit
trace-exp integrand a.e. measurability, random self-adjointness, and
`0 <= theta` hypotheses. The judge still does not claim the real RHS bridge,
trace-mgf, Golden-Thompson, Lieb, or Matrix Bernstein.

MB-S9-foundation adds TraceExp, VarianceProxy, MatrixBernstein, and Statement
judge cases for `TraceMGFBound`, `TraceMGFBoundLIntegral`,
`TraceMGFVarianceProxyBound`, `TraceMGFVarianceProxyBoundLIntegral`,
`MatrixVarianceProxyUpperBound`, `MatrixVarianceProxyNormBound`, and
`matrixBernsteinTraceMGF_statement`. The judge still does not claim
Golden-Thompson, Lieb, the full trace-mgf master theorem, the real RHS bridge,
or Matrix Bernstein.

MB-S9-Tropp-master-typed-primitive adds a TraceExp judge case for
`troppMasterTraceMGFStep_statement`. The example supplies the typed statement
as an explicit hypothesis and applies it to all visible assumptions. The judge
still does not claim Lieb concavity, Golden-Thompson, the trace-mgf provider,
the full trace-mgf master theorem, the real RHS bridge, or Matrix Bernstein.

MB-S9-single-summand-mgf-typed-primitive adds a TraceExp judge check and
minimal `Prop` example for `singleSummandMatrixMGFVarianceProxy_statement`.
The judge does not claim the scalar-to-matrix functional-calculus bridge,
operator-norm-to-spectral-interval bridge, the trace-mgf provider,
Golden-Thompson, Lieb, or Matrix Bernstein.

MB-S9-bernstein-cfc-typed-primitive adds a TraceExp judge check and minimal
`Prop` example for `bernsteinMatrixExp_le_quadratic_statement`. The judge does
not claim the functional-calculus proof, single-summand MGF theorem,
operator-norm-to-spectral-interval bridge, the trace-mgf provider,
Golden-Thompson, Lieb, or Matrix Bernstein.

MB-S9-PSD-expectation-proof adds variance-proxy judge checks for
`integrableRandomMatrix_sub`, `matrixExpect_sub`,
`isPSDMatrix_matrixExpect_of_pointwise_isPSD`, and
`matrixExpect_matrixLE_of_pointwise_matrixLE`. The examples supply explicit
integrability, PSD, and MatrixLE assumptions and do not claim the
single-summand MGF theorem, functional calculus, trace-mgf provider,
Golden-Thompson, Lieb, or Matrix Bernstein.

MB-S9-expectation-linearity-proof adds variance-proxy judge checks for
`integrableRandomMatrix_add`, `integrableRandomMatrix_smul`,
`integrableRandomMatrix_zero`, `integrableRandomMatrix_const`,
`matrixExpect_add`, `matrixExpect_smul`, `matrixExpect_zero`,
`matrixExpect_const`, `matrixExpect_const_of_isProbabilityMeasure`, and
`matrixExpect_one_of_isProbabilityMeasure`. The examples supply explicit
integrability, finite-measure, and probability-measure assumptions where
needed and do not claim the single-summand MGF theorem, functional calculus,
trace-mgf provider, Golden-Thompson, Lieb, or Matrix Bernstein.

MB-S9-matrixle-algebra-proof adds variance-proxy judge checks for
`matrixQuadraticForm_add`, `matrixQuadraticForm_smul`,
`isPSDMatrix_zero`, `isPSDMatrix_add`,
`isPSDMatrix_smul_of_nonneg`, `matrixLE_refl`, `matrixLE_of_eq`,
`matrixLE_trans`, `matrixLE_add`, `matrixLE_add_left`,
`matrixLE_add_right`, and `matrixLE_smul_of_nonneg`. The examples use only
explicit MatrixLE/PSD hypotheses and do not claim the single-summand MGF
theorem, Bernstein CFC proof, trace-mgf provider, Golden-Thompson, Lieb, or
Matrix Bernstein.

MB-S9-bernstein-coefficient-proof adds TraceExp judge coverage for
`bernsteinCoefficient_nonneg`. The example passes the explicit
`abs theta * R < 3` hypothesis and proves only the scalar coefficient
nonnegativity helper. It does not prove the single-summand provider, the
Bernstein CFC primitive, the downstream matrix exponential lower bound,
trace-mgf provider, Golden-Thompson, Lieb, or Matrix Bernstein.

MB-S9-exp-lower-bound-proof adds TraceExp judge coverage for
`matrixLE_one_add_self_le_matrixExp_of_selfAdjoint` and
`matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint`. The examples pass
explicit self-adjointness hypotheses and prove only the deterministic matrix
exponential lower bound plus scalar-multiple wrapper. They do not prove the
single-summand provider, the Bernstein CFC primitive, trace-mgf provider,
Golden-Thompson, Lieb, or Matrix Bernstein.

MB-S9-single-summand-provider-under-cfc adds TraceExp judge coverage for
`singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic`.
The example passes the pointwise typed Bernstein CFC primitive as an explicit
assumption, along with the typed single-summand assumptions. It does not prove
the Bernstein CFC primitive, Tropp/Lieb primitive, trace-mgf provider,
Golden-Thompson, Lieb, or Matrix Bernstein.

MB-S9-rhs-normalization-proof adds TraceExp and concentration statement judge
coverage for `bernsteinMGFCoeff`, `bernsteinMGFCoeff_nonneg`,
`TraceMGFBernsteinVarianceProxyBound`,
`TraceMGFBernsteinVarianceProxyBoundLIntegral`,
`traceMGFBernsteinVarianceProxyBound_statement`, and
`matrixBernsteinTraceMGFWithBernsteinCoeff_statement`. The bounded statement
uses the denominator coefficient `bernsteinMGFCoeff theta R`; the retained
`matrixBernsteinTraceMGF_statement` remains the old `theta ^ 2 / 2`
compatibility target. The examples do not prove the trace-mgf provider,
Bernstein CFC primitive, Tropp/Lieb primitive, Golden-Thompson, Lieb, or
Matrix Bernstein.

For a full stage verification run:

```bash
lake build
lake build HighDimProbJudge
lake test
python scripts/judge_policy_check.py
```
## MB-S9 Trace-MGF Thin Wrapper Judge Coverage

- `HighDimProbJudge/RandomMatrix/TraceExpUse.lean` checks
  `traceMGFBernsteinVarianceProxyBound_of_troppMasterTraceMGFFiniteFamily`.
- `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean` and
  `HighDimProbJudge/RandomMatrix/StatementUse.lean` check
  `matrixBernsteinTraceMGFWithBernsteinCoeff_of_troppMasterTraceMGFFiniteFamily`.
- The general arbitrary-index finite-family Tropp interface remains an explicit
  primitive assumption, while the narrow `Fin m` conditional-step provider and
  its trace-MGF wrapper are checked in `TraceExpUse.lean`. The judge checks
  public API availability and import boundaries.

## MB-S9 Matrix Bernstein Trace-MGF Under Primitives Judge Coverage

- `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean` checks
  `matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives`.
- The judge check confirms the bounded trace-MGF under-primitives theorem is
  public. The arbitrary-index finite-family Tropp provider and Bernstein CFC
  primitive remain open; the narrow `Fin m` conditional-step Tropp provider is
  checked separately in the trace-exp judge file.

## RM Negative Family Adapter Judge Coverage

- `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean` checks the generic
  negative-family adapters for measurability, entrywise integrability,
  self-adjoint/centered-self-adjoint structure, independence, and pointwise
  operator-norm bounds.
- The same judge file checks the sample-covariance negative row-rank-one
  adapters and
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_adapters`, the square-negation adapter declarations,
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_square_adapters`, and the opposite-parameter sample-covariance exp/trace/CFC provider-transfer adapters.
- The checks are import-boundary/API checks only; they do not prove
  exponential/trace integrability, Tropp/Lieb, Bernstein CFC, Golden-Thompson,
  full Matrix Bernstein, or unconditional sample-covariance concentration.
