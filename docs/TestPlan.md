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
- Scalar API tests: probability, tail, Lp/moment, Orlicz, subGaussian, subExponential, and scalar concentration files under `HighDimProbTest`.
- RandomMatrix API tests: variance proxy, spectral, trace-exp, hardbone
  statement targets, Laplace, concentration, and example API checks.
- RandomMatrix bookkeeping checks: trace-exp endpoint wrappers and the
  natural-state TraceExp route are covered in
  `HighDimProbTest/RandomMatrixTraceExpAPI.lean` and
  `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`; example modules are covered
  through `lake build HighDimProb.Examples`.
- RandomMatrix hardbone statement-target checks, including the proved Bernstein
  CFC hardbone leaf, are covered in
  `HighDimProbTest/RandomMatrixHardboneStatementsAPI.lean`,
  `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`, and the
  `HardboneStatementAtlasUsage` example.
- RandomMatrix sample-covariance negative-side provider-transfer adapters and
  CFC-free sample-covariance wrappers are covered in
  `HighDimProbTest/RandomMatrixConcentrationAPI.lean`,
  `HighDimProbTest/ExamplesAPI.lean`, and
  `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`.
- RandomMatrix CFC-free Matrix Bernstein assumption bundles and preferred
  `*_of_troppAssumptions` wrappers are covered in
  `HighDimProbTest/RandomMatrixConcentrationAPI.lean`,
  `HighDimProbTest/ExamplesAPI.lean`, and
  `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`.
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
