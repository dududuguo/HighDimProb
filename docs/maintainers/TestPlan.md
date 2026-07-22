# Test Plan

The test suite exists to catch public API regressions, import-boundary breaks,
policy violations, and text encoding damage.

## Main Commands

```bash
python3 .github/scripts/check_text_quality.py
python3 scripts/judge_append_only_check.py
python3 -m unittest scripts.test_judge_append_only_check
python3 scripts/judge_policy_check.py
lake build
lake build HighDimProb.Examples
lake build HighDimProbJudge
lake test
```

For docs-only edits, run at least:

```bash
python3 .github/scripts/check_text_quality.py
python3 scripts/judge_policy_check.py
git diff --check
```

## Important Test Surfaces

- Root import smoke tests: `HighDimProbTest/Smoke.lean`, `PublicImports.lean`, `BranchImports.lean`, `ExperimentalImports.lean`.
- Scalar API tests: probability, tail, Lp/moment, Orlicz, subGaussian, subExponential, real-inequality helpers, and scalar concentration files under `HighDimProbTest`.
- Focused Hanson-Wright checks: `HighDimProbTest/HansonWrightAPI.lean` and
  `HighDimProbJudge/Concentration/HansonWrightExplicitUse.lean`; run
  `lake build HighDimProb.Concentration.HansonWright`,
  `lake build HighDimProbTest.HansonWrightAPI`, and the focused Judge target
  when changing the finite real-matrix endpoint, its public constant, or names.
- Random-family and process API checks: `HighDimProbTest/RandomFamilyAPI.lean` plus `BranchImports.lean` and `ExperimentalImports.lean`.
- Focused subGaussian-process API check: `HighDimProbTest/SubGaussianProcessAPI.lean`; run `lake build HighDimProbTest.SubGaussianProcessAPI` when changing `HighDimProb.SubGaussianProcess` or its public names.
- Focused SubGaussian maximum/chaining API check: `HighDimProbTest/SubGaussianMaxAPI.lean`; it covers `finiteEntropySum`, the `Fin`-indexed single-path bounds, the D1 finite anchored supremum bound with a supplied common-anchor path family and explicit integrable terminal-residual envelope, the D3 supplied dense-sequence/full-supremum expectation passage, and the D2-to-D3 assembly bridge under supplied prefix bounds and supplied residual expectation convergence. Run `lake build HighDimProbTest.SubGaussianMaxAPI` when changing `HighDimProb.Concentration.SubGaussianMax` or its public names.
- Focused full Dudley checks: `DudleySupportAPI`,
  `DudleyEntropyIntegralAPI`, `DudleyFullAPI`, and `DudleyAPI`.
  The last two consume `Dudley.fullBound` and `Dudley.Inputs.bound` through
  `HighDimProb.Concentration`; `HighDimProbJudge/Concentration/DudleyUse.lean`
  is the append-only downstream case.
- Focused covering-number API check: `HighDimProbTest/CoveringNumberAPI.lean`; it imports the public facade `HighDimProb.Geometry` and checks `l1Ball`, the Euclidean and l1 volumetric internal `ENat` bounds, and the existing totally-bounded-to-exact-finite internal-net facade. Run `lake build HighDimProb.Geometry.CoveringNumber` and then `lake build HighDimProbTest.CoveringNumberAPI` when changing this surface.
- Focused finite-chaining and metric-entropy API checks: `HighDimProbTest/ChainingAPI.lean`, `HighDimProbTest/NetsMetricEntropyAPI.lean`, `HighDimProbTest/SumIntegralAPI.lean`, `HighDimProbTest/MetricEntropyAPI.lean`, and `HighDimProbTest/SubGaussianProcessAPI.lean`; they cover internal-net parent maps, finite endpoint paths, common-anchor residual/step-bound composition including the zero-level boundary, positive-radius net families, explicit `Nat` cardinality data, the generic arbitrary-partition sum/integral adapter, the truncated dyadic entropy comparison, the D2 deterministic lower-endpoint/full-integral convergence bridge and supplied residual-limit inequality, and the D3 passage from uniformly bounded dense-sequence prefixes to the full anchored supremum. Run `lake build HighDimProbTest.DudleyAPI HighDimProbTest.SubGaussianMaxAPI HighDimProbTest.ChainingAPI HighDimProbTest.NetsMetricEntropyAPI HighDimProbTest.SumIntegralAPI HighDimProbTest.MetricEntropyAPI HighDimProbTest.SubGaussianProcessAPI HighDimProbJudge.Analysis.SumIntegralD2Use HighDimProbJudge.Analysis.CompactApproximationUse HighDimProbJudge.Concentration.SubGaussianProcessUse HighDimProbJudge.Concentration.SubGaussianMaxD2D3Use` after changing these public surfaces. Existing immutable Judge leaves cover D1-D3 contracts; `DudleyAPI.lean` covers the assembled endpoint.
- Focused compact-residual and expectation-convergence API checks: `HighDimProbTest/CompactApproximationAPI.lean` checks the three compact residual bridges, while `HighDimProbTest/ExpectationConvergenceAPI.lean` checks `MeasureTheory.tendsto_integral_filter_of_dominated_convergence` directly without a duplicate project wrapper. Run `lake build HighDimProb.Analysis.CompactApproximation HighDimProbTest.CompactApproximationAPI HighDimProbTest.ExpectationConvergenceAPI` after changing these surfaces.
- Gaussian-functional checks: `GaussianIntegrationByPartsAPI` and
  `GaussianAffineStabilityAPI`, with matching append-only Judge leaves.
- Feature-Gram and softmax checks: `RandomMatrixFeatureGramOperatorAPI`,
  `SoftmaxAPI`, and `ExamplesAPI`; the examples must consume public
  concentration abstractions and must not import provider modules directly.
- Focused deterministic dense-sup checks: `HighDimProbTest/DenseSupAPI.lean` and `HighDimProbJudge/Analysis/DenseSupUse.lean`; run `lake build HighDimProb.Analysis.DenseSup`, `lake build HighDimProbTest.DenseSupAPI`, and `lake build HighDimProbJudge.Analysis.DenseSupUse`. The theorem is a supplied dense-sequence, continuous, real-valued, explicitly bounded-above deterministic bridge only; open coverage follows [`TODO.md`](TODO.md).
- PrecisionDA application checks: `HighDimProbTest/PrecisionDAAPI.lean` covers
  the deterministic PrecisionDA object/provider surface, `HighDimProbTest/ExamplesAPI.lean`
  covers the reader-facing example import, and
  `HighDimProbJudge/PrecisionDA/CovarianceTraceExpansionUse.lean` covers the
  judge consumer. Focused commands: `lake build HighDimProb.Applications.PrecisionDA`,
  `lake build HighDimProbTest.PrecisionDAAPI`, and
  lake build HighDimProbJudge.PrecisionDA.CovarianceTraceExpansionUse.
- RandomMatrix API tests: variance proxy, spectral, trace-exp, hardbone
  statement targets, thin consumers, rank/support trace bridge, excess-support trace bridge, centered-square expectation expansion, PSD Loewner variance-proxy norm monotonicity, `MatrixExpSupportDomination`, `MatrixExpExcessSupportDomination`, trace-exp eigenvalue-sum bridge, effective-rank consumer, ambient trace certificate, ambient effective-rank wrapper, star-projection trace/rank/PSD certificate and rank consumer, Laplace, concentration, and example API
  checks.
- Focused RandomMatrix public concentration facade/API checks: run
  `lake build HighDimProb.RandomMatrix.Concentration` and
  `lake build HighDimProbTest.RandomMatrixPublicConcentrationAPI`.
  `HighDimProbTest/RandomMatrixPublicConcentrationAPI.lean` imports only the
  public facade `HighDimProb.RandomMatrix.Concentration`, so it detects public
  visibility regressions without relying on implementation-oriented provider
  imports.
- Focused conditional matrix sub-Gaussian API check:
  `HighDimProbTest/SubGaussianMatrixAPI.lean`; run
  `lake build HighDimProbTest.SubGaussianMatrixAPI`. It checks the four
  declarations exported through `HighDimProb.RandomMatrix.Concentration` and
  keeps the Tropp, random/self-adjoint/independence, variance-proxy, and
  unbounded exponential-integrability premises explicit. The append-only
  downstream consumer is
  `HighDimProbJudge/RandomMatrix/SubGaussianUse.lean`.
- Focused directional matrix sub-Gaussian checks:
  `HighDimProbTest/DirectionalSubGaussianMatrixAPI.lean` and
  `HighDimProbTest/DirectionalOperatorNormMatrixAPI.lean`; run
  `lake build HighDimProb.RandomMatrix.DirectionalSubGaussian`,
  `lake build HighDimProb.RandomMatrix.DirectionalOperatorNorm`, and the two
  test modules. They consume only `HighDimProb.RandomMatrix.Concentration` and
  keep the explicit finite-net, positive-dimension, radius, threshold,
  probability, and entrywise-integrability boundaries visible.
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
- Vector-level independence constructors and the generic centered self-adjoint
  observation consumer are covered in
  `HighDimProbTest/RandomMatrixPublicConcentrationAPI.lean` and the append-only
  `HighDimProbJudge/RandomMatrix/MatrixBernsteinConsumersUse.lean`.
- Variance-proxy and hardbone API coverage includes the centered second-moment
  comparison, rank-one second-moment consumer, exact row second-moment hardbone
  consumer, deterministic variance-proxy norm subadditivity, exact rank-one
  second-moment norm providers, the rank-one square-integrability four-product,
  `MemLp 4`, bounded-row, centered-family providers, and the row-specific exact-row sample-covariance hardbone consumer in
  `RandomMatrixVarianceProxyAPI`,
  `RandomMatrixHardboneStatementsAPI`, and the corresponding judge/example
  surfaces.
- Judge tests: `HighDimProbJudge`, `scripts/judge_policy_check.py`, and the
  append-only ledger checker. Existing entries in `.github/judge-lock.json`
  are immutable; add a new file with
  `python3 scripts/judge_append_only_check.py --add <new-file>`.

## Policy Checks

The policy script rejects non-comment `s[o]rry`, `a[d]mit`, `a[x]iom`, and `u[n]safe`,
forbids stable-root imports of `HighDimProb.Experimental`, checks judge import
boundaries, and rejects anonymous negated-family signatures in public RandomMatrix,
example, test, and judge files. It also verifies the current append-only ledger;
CI compares that ledger with the target Git revision to reject removal or mutation
of any previously merged Judge case.

## Maintenance Rule

Keep this file short. Add new details only when they change what contributors
must run or what CI enforces. Archive old stage-by-stage test history in
`archive.md`.

## Provider Architecture Check

Run the facade and import tests after changing provider ownership or imports:

```bash
lake build HighDimProb.RandomMatrix.Provider.Analysis HighDimProb.RandomMatrix.Provider.Conditioning HighDimProb.RandomMatrix.Provider.Concentration HighDimProb.RandomMatrix.Provider
lake build HighDimProbTest.RandomMatrix.Provider.AnalysisAPI HighDimProbTest.RandomMatrix.Provider.ConditioningAPI HighDimProbTest.RandomMatrix.Provider.ConcentrationAPI
```

Run the low-level provider check below after changing provider leaf declarations.

## Provider Leaf Check

ambient or self-adjoint carrier matrix-exp derivative surface, the
first-order `CFC.log` affine-line provider layer and its diagonal/trace-paired
spectral adapters, the finite-cutoff log-resolvent provider layer, the
inverse-convexity segment provider, the full-matrix-Klein relative-entropy
provider, the left/right relative-entropy integrand provider, the
density/integral-premise joint-convexity route provider, the scalar and
representation witnesses for the left/right route, the conditional
relative-entropy/Gibbs bridge, the derivative-level Epstein consumer layer,
Tropp one-step provider wrappers, the natural-history provider alias layer, or the
provider-compressed natural-state tail route:

```bash
lake build HighDimProb.RandomMatrix.MatrixExpDerivativeProvider HighDimProb.RandomMatrix.CFCLogDerivativeProvider HighDimProb.RandomMatrix.ResolventDerivativeProvider HighDimProb.RandomMatrix.LogResolventProvider HighDimProb.RandomMatrix.InverseConvexityProvider HighDimProb.RandomMatrix.RelativeEntropyProvider HighDimProb.RandomMatrix.RelativeEntropyLeftRightIntegrandProvider HighDimProb.RandomMatrix.RelativeEntropyLeftRightScalarProvider HighDimProb.RandomMatrix.RelativeEntropyJointConvexityRouteProvider HighDimProb.RandomMatrix.RelativeEntropyLeftRightRepresentationProvider HighDimProb.RandomMatrix.RelativeEntropyBridgeProvider HighDimProb.RandomMatrix.EpsteinDerivativeProvider HighDimProb.RandomMatrix.TraceExpTroppStepProvider HighDimProb.RandomMatrix.ConditioningExpectationProvider HighDimProb.RandomMatrix.ConcentrationStatements HighDimProb.RandomMatrix.TailEventTraceMGFBridgeProvider HighDimProb.RandomMatrix.TailEventProviderAssumptionBridgeProvider HighDimProb.RandomMatrix.TailEventNaturalStateBridgeProvider HighDimProb.RandomMatrix.LiebProvider HighDimProbTest.RandomMatrixMatrixExpDerivativeProviderAPI HighDimProbTest.RandomMatrixInverseConvexityProviderAPI HighDimProbTest.RandomMatrixRelativeEntropyProviderAPI HighDimProbTest.RandomMatrixConditioningExpectationProviderAPI HighDimProbTest.RandomMatrixLiebProviderAPI HighDimProbTest.RandomMatrixConcentrationAPI HighDimProbTest.RandomMatrixTailEventTraceMGFBridgeProviderAPI HighDimProbTest.RandomMatrixTailEventProviderAssumptionBridgeProviderAPI HighDimProbTest.RandomMatrixTailEventNaturalStateBridgeProviderAPI HighDimProbJudge.RandomMatrix.InverseConvexityProviderUse HighDimProbJudge.RandomMatrix.RelativeEntropyProviderUse HighDimProbJudge.RandomMatrix.ConditioningExpectationProviderUse HighDimProbJudge.RandomMatrix.LiebProviderUse HighDimProbJudge.RandomMatrix.MatrixBernsteinUse HighDimProbJudge.RandomMatrix.TailEventTraceMGFBridgeProviderUse HighDimProbJudge.RandomMatrix.TailEventProviderAssumptionBridgeProviderUse HighDimProbJudge.RandomMatrix.TailEventNaturalStateBridgeProviderUse
```
