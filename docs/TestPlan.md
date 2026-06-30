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
- Precision-matrix application API checks:
  `HighDimProbTest/PrecisionDAAPI.lean` covers the experimental
  paper-oriented deterministic object layer, including Frobenius/trace
  expansion vocabulary, deterministic symmetry providers, the shifted-resolvent
  difference identity, the common-shift subtraction lemma, the leave-one-out
  sample-covariance update, the specialized shifted leave-one-out rank-one
  difference lemma, rank-one sample outer-product entrywise/sandwich expansion
  lemmas and the scaled leave-one-out resolvent rank-one RHS wrapper, the
  sample-column/row/one-dimensional-weight Woodbury vocabulary, scalar
  Sherman-Morrison denominator/correction/RHS wrappers, the matrix-shaped
  Woodbury RHS theorem, the matrix-to-scalar RHS bridge, the scalar
  Woodbury RHS theorem, and the deterministic Woodbury invertibility-provider
  convenience wrappers for
  Sherman-Morrison/Woodbury RHS preparation, the shrinkage/leave-one-out
  shifted-resolvent identity wrapper, the covariance-input error,
  trace-expansion RHS and statement wrappers, and the H1 stochastic provider
  vocabulary (`RandomDataMatrix`, column/entry assumption predicates,
  `PaperH1SubGaussianModelStatement` /
  `PaperH1SubGaussianModelProvider`, and the H2 leave-one-out good-event
  wrappers `leaveOneOutCovarianceLowerBound`, `paperH2LeaveOneOutGoodEvent`,
  `PaperH2LeaveOneOutGoodEventStatement`,
  `PaperH2LeaveOneOutGoodEventProvider`, the H2 bad-event probability target
  (`PaperH2GoodEventProbabilityRHS`, `paperH2LeaveOneOutBadEvent`,
  `paperH2LeaveOneOutBadEvent_mem_iff`,
  `paperH2LeaveOneOutBadEvent_eq_compl`,
  `PaperH2LeaveOneOutBadEventMeasurabilityProvider`,
  `paperH2LeaveOneOutBadEvent_measurable_of_provider`,
  `PaperH2LeaveOneOutGoodEventProbabilityStatement`,
  `PaperH2LeaveOneOutGoodEventProbabilityProvider`,
  `paperH2LeaveOneOutGoodEventProbabilityStatement_of_provider`,
  `paperH2LeaveOneOutGoodEventProbability_bound_of_provider`,
  `PaperH2LeaveOneOutProbabilityConsumerStatement`,
  `paperH2LeaveOneOutProbabilityConsumerStatement_of_providers`,
  `paperH2LeaveOneOutProbabilityConsumer_bound_of_providers`, the eta-only
  lower-singular-value event layer (`paperH2LowerSingularValueGoodEvent`,
  `paperH2LowerSingularValueBadEvent`,
  `paperH2LowerSingularValueBadEvent_mem_iff`,
  `paperH2LowerSingularValueBadEvent_eq_compl`,
  `PaperH2LowerSingularValueStatement`,
  `PaperH2LowerSingularValueEventProvider`),
  `PaperH2LowerSingularValueProvider`,
  `paperH2LeaveOneOutBadEventMeasurabilityProvider_of_lowerSingularValueProvider`,
  `paperH2LeaveOneOutGoodEventProbabilityProvider_of_lowerSingularValueProvider`,
  `paperH2LeaveOneOutProbabilityConsumerStatement_of_lowerSingularValueProvider`,
  and their
  membership/complement/provider-projection rewrites /
  `bad_event_measurable` / `bad_event_probability` / `h2_probability`
  projections), the minimal
  `ShrinkageTheorem1Providers` H1/H2 bundle, and the typed Theorem 1 tail
  skeleton (`ShrinkageTheorem1BiasTerm`, `ShrinkageTheorem1TailRHS`,
  `shrinkageTheorem1TailEvent`, and `ShrinkageTheorem1TailStatement`), and the
  typed paper estimator/bias vocabulary (`paperShrinkageError`,
  `randomPaperShrinkageError`, `PaperShrinkageEstimator`, `PaperShrinkageBias`,
  `paperShrinkageEstimatedError`, `paperShrinkageBiasTerm`,
  `randomPaperShrinkageEstimatedError`, and `randomPaperShrinkageBiasTerm`),
  plus the paper-facing tail wrapper (`shrinkageTheorem1PaperTailEvent` and
  `ShrinkageTheorem1PaperTailStatement`) and paper-side tail RHS provider
  vocabulary (`PaperShrinkageTailRHS`, `paperShrinkageTailRHS`, and
  `ShrinkageTheorem1PaperTailRHSProvider`) and the pointwise
  `Delta_X(lambda)` bias-control provider
  (`PaperShrinkageBiasControlProvider` and its `pointwise_nonneg` projection),
  and the paper-tail event measurability provider
  (`ShrinkageTheorem1PaperTailMeasurabilityProvider` and its
  `tail_event_measurable` projection), and the bundled paper-tail provider
  surface (`ShrinkageTheorem1PaperTailProviders` and its `core`, `rhs`,
  `bias_control`, and `measurability` projections), the thin paper-tail H2
  probability consumer (`shrinkageTheorem1PaperTailH2Probability_of_providers`),
  the paper-tail H2 probability consumer-statement wrapper
  (`shrinkageTheorem1PaperTailH2ProbabilityConsumerStatement_of_providers`) and
  short-name alias (`shrinkageTheorem1PaperTailH2ProbabilityConsumer_of_providers`),
  the paper-tail H2 bad-event probability projection
  (`shrinkageTheorem1PaperTailH2ProbabilityConsumer_badEventProbability_of_providers`),
  and the thin paper-tail statement bridge
  (`shrinkageTheorem1PaperTailStatement_of_providers`), which
  checks that bundled providers plus explicit `0 < lam`, `0 <= t`, and
  `tail_bound` premises are consumable as `ShrinkageTheorem1PaperTailStatement`.
  The paper-tail H2 consumer-statement checks verify that bundled paper-tail
  providers, explicit H2 bad-event measurability, and the supplied H2 probability
  provider can be threaded into `PaperH2LeaveOneOutProbabilityConsumerStatement`
  and then project the packaged bad-event probability field without proving
  measurability, probability estimates, concentration, Theorem 1, or the
  closed-form RHS. The same file also checks bridge-result
  field projections from
  `shrinkageTheorem1PaperTailStatement_of_providers`: `providers`,
  `lambda_positive`, `threshold_nonnegative`, `tail_rhs_nonnegative`, and
  `tail_bound`. The H2 probability consumer check verifies that an explicit
  `PaperH2LeaveOneOutGoodEventProbabilityProvider` can be threaded alongside the
  paper-tail bundle without changing that bundle. The H2 probability consumer
  checks verify that explicit bad-event measurability and the supplied H2
  probability provider can be consumed through one statement boundary without
  proving measurability, probability estimates, concentration, Theorem 1, or
  the closed-form RHS.
  The eta-only lower-singular-value checks verify only the new event vocabulary,
  definitional complement shape, and statement/provider projections without
  adding lam-dependent resolvent conditions or proving measurability,
  probability, concentration, Theorem 1, or closed-form RHS results.
  The lower-singular-value provider checks verify that the named future H2
  proof-entry shell can be projected into the existing H2 bad-event
  measurability provider, H2 probability provider, and combined consumer
  statement without proving lower-singular-value, measurability, probability,
  concentration, Theorem 1, or closed-form RHS results.
  `HighDimProbTest/ExamplesAPI.lean` also checks the reader-facing deterministic
  PrecisionDA covariance trace-expansion consumer imported through
  `HighDimProb.Examples`. `HighDimProbJudge/PrecisionDA/CovarianceTraceExpansionUse.lean`
  checks that the same covariance-input trace expansion is directly consumable
  from the judge surface and is covered by `lake build HighDimProbJudge`.
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
  the proved centered-square expectation bridge leaf, the progress-first
  conditional finite-family trace-MGF assumption-composition consumer, and the
  S10 tail/conditioning assumption bundle wrapper are covered in
  `HighDimProbTest/RandomMatrixHardboneStatementsAPI.lean`,
  `HighDimProbTest/RandomMatrixConcentrationAPI.lean`,
  `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`, and
  `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`.
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

## Provider-focused RandomMatrix Check

Run this after changing the provider-facing Lieb/Tropp layer or the
provider-compressed natural-state tail route:

```bash
lake build HighDimProb.RandomMatrix.LiebProvider HighDimProbTest.RandomMatrixLiebProviderAPI HighDimProbJudge.RandomMatrix.LiebProviderUse
```
