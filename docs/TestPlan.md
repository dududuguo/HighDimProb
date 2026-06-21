# Test Plan

The test suite exists to catch public API regressions, import-boundary breaks,
policy violations, and text encoding damage.

## Main Commands

```bash
python .github/scripts/check_text_quality.py
python scripts/judge_policy_check.py
lake build
lake build HighDimProb.Examples
lake build HighDimProbJudge
lake test
```

For docs-only edits, run at least:

```bash
python .github/scripts/check_text_quality.py
python scripts/judge_policy_check.py
git diff --check
```

## Important Test Surfaces

- Root import smoke tests: `HighDimProbTest/Smoke.lean`, `PublicImports.lean`, `BranchImports.lean`, `ExperimentalImports.lean`.
- Scalar API tests: probability, tail, Lp/moment, Orlicz, subGaussian, subExponential, real-inequality helpers, and scalar concentration files under `HighDimProbTest`.
- Random-family and process API checks: `HighDimProbTest/RandomFamilyAPI.lean` plus `BranchImports.lean` and `ExperimentalImports.lean`.
- RandomMatrix API tests: variance proxy, spectral, trace-exp, hardbone
  statement targets, thin consumers, rank/support trace bridge, excess-support trace bridge, centered-square expectation expansion, PSD Loewner variance-proxy norm monotonicity, `MatrixExpSupportDomination`, `MatrixExpExcessSupportDomination`, trace-exp eigenvalue-sum bridge, effective-rank consumer, ambient trace certificate, ambient effective-rank wrapper, star-projection trace/rank/PSD certificate and rank consumer, Laplace, concentration, and example API
  checks.
- RandomMatrix bookkeeping checks: trace-exp endpoint wrappers and the
  natural-state TraceExp route are covered in
  `HighDimProbTest/RandomMatrixTraceExpAPI.lean` and
  `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`; example modules, including the `StatementRoutes` statement-route index, are covered
  through `lake build HighDimProb.Examples`.
- RandomMatrix hardbone statement-target checks, including the proved Bernstein
  CFC hardbone leaf, the proved matrix-exp/log normalization and log-domain leaves, the proved
  matrix log/order bridge leaf, the proved excess-support trace bridge leaf,
  the proved centered-square expectation bridge leaf, and the progress-first
  conditional finite-family trace-MGF assumption-composition consumer are covered in
  `HighDimProbTest/RandomMatrixHardboneStatementsAPI.lean`,
  `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`.
- RandomMatrix sample-covariance negative-side provider-transfer adapters, the
  compact `SampleCovarianceTailTarget` /
  `SampleCovarianceBoundedRowTroppAssumptions` route, bridge-layer exact-row
  centered-square wrappers/bundles, and CFC-free sample-covariance wrappers,
  including the positive-side exact-row variance-proxy quadratic-form wrapper,
  are covered in
  `HighDimProbTest/RandomMatrixConcentrationAPI.lean`,
  `HighDimProbTest/ExamplesAPI.lean`, and
  `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`.
- RandomMatrix CFC-free Matrix Bernstein assumption bundles and preferred
  `*_of_troppAssumptions` wrappers are covered in
  `HighDimProbTest/RandomMatrixConcentrationAPI.lean`,
  `HighDimProbTest/ExamplesAPI.lean`, and
  `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`.
- Variance-proxy and hardbone API coverage includes the centered second-moment
  comparison, rank-one second-moment consumer, exact row second-moment hardbone
  consumer, deterministic variance-proxy norm subadditivity, exact rank-one
  second-moment norm providers, the rank-one square-integrability four-product,
  `MemLp 4`, bounded-row, centered-family providers, and the row-specific exact-row sample-covariance hardbone consumer in
  `RandomMatrixVarianceProxyAPI`,
  `RandomMatrixHardboneStatementsAPI`, and the corresponding judge/example
  surfaces.
- Judge tests: `HighDimProbJudge` plus `scripts/judge_policy_check.py`.

## Policy Checks

The policy script rejects non-comment `sorry`, `admit`, `axiom`, and `unsafe`,
forbids stable-root imports of `HighDimProb.Experimental`, checks judge import
boundaries, and rejects anonymous negated-family signatures in public RandomMatrix,
example, test, and judge files.

## Maintenance Rule

Keep this file short. Add new details only when they change what contributors
must run or what CI enforces. Archive old stage-by-stage test history in
`archive.md`.
