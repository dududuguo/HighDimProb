# Archive

This file is intentionally small. It is not a second status document and it is not a place to keep old full snapshots.

For exact current facts, read the Lean source, tests, generated docs, and the focused active docs. For exact old wording, use git history.

## Stable Surfaces

The stable scalar/probability-facing surface is mature enough that this archive does not track its old stage history. Read the source, tests, and judge files instead:

- [`HighDimProb`](../../HighDimProb)
- [`HighDimProbTest`](../../HighDimProbTest)
- [`HighDimProbJudge`](../../HighDimProbJudge)
- [`docs/maintainers/TestPlan.md`](../maintainers/TestPlan.md)

## Current Active Areas

- RandomMatrix and Matrix Bernstein remain experimental.
- Sample-covariance wrappers are useful, but still expose real primitive assumptions when no adapter theorem has been proved.
- Documentation should stay short: current files carry current facts; this file only records why old detail disappeared.

## Collapsed Historical Groups

The old long docs were collapsed into short current-facing files:

| Old pressure point | Current file | What remains |
|---|---|---|
| Status stage logs | [`Status.md`](../user/Status.md) | Current development status and verification commands. |
| Abstraction notes | [`AbstractionLog.md`](../maintainers/AbstractionLog.md) | Active abstraction rules only. |
| TODO logs | [`TODO.md`](../maintainers/TODO.md) | Current short task list. |
| Matrix concentration plan | [`MatrixConcentrationPlan.md`](MatrixConcentrationPlan.md) | Current route and boundaries. |
| Matrix Bernstein proof plan | [`MatrixBernsteinProofPlan.md`](MatrixBernsteinProofPlan.md) | Current proof boundary. |
| Book progress | [`BookProgress.md`](BookProgress.md) | Short milestone summary. |
| Branch registry | [`BranchRegistry.md`](../architecture/BranchRegistry.md) | Current branch map. |
| Theorem atlas | [`TheoremAtlas.md`](../reference/TheoremAtlas.md) | Compact theorem-family index. |
| Term map | [`TermMap.md`](../reference/TermMap.md) | Compact term/source map. |
| RandomMatrix API notes | [`RandomMatrixAPI.md`](../user/RandomMatrixAPI.md) | Current RandomMatrix API names and caveats. |
| Test-plan history | [`TestPlan.md`](../maintainers/TestPlan.md) | Current commands and policy surfaces. |

## Removed Long Docs

The following files were retired because they duplicated source/tests/judge coverage or kept historical milestone detail in the active docs tree:

- `ConcentrationLeafAudit.md`
- `ConcentrationTestCoverage.md`
- `DependencyMap.md`
- `HoeffdingMilestone.md`
- `IndependencePlan.md`
- `LLNPlan.md`
- `Milestone-ScalarConcentration.md`
- `PhysicalMigrationPlan.md`
- `RademacherMilestone.md`
- `RademacherPlan.md`
- `ScalarConcentrationMilestone.md`
- `ScalarConcentrationTheoremIndex.md`
- `ScalarImplicationGraph.md`

## Removed Intermediate Examples

The following example files were retired because they only exposed lower-level bridge or alias routes already covered by source, tests, judge files, or a higher-level example route:

- `BoundedRowSampleCovarianceOperatorNormUsage.lean`
- `PrefixStateTroppUsage.lean`
- `ConditionalStateEndpointUsage.lean`
- `ReindexedTroppBridgeUsage.lean`
- `NegativeFamilyTwoSidedUsage.lean`
- `RankOneKernelNullspaceUsage.lean`
- `ExpectationOperatorNormBoundUsage.lean`
- `KernelNullspaceUsage.lean`
- `NTKGramDecompositionUsage.lean`
- `HardboneStatementAtlasUsage.lean`

Use `HighDimProb.Examples.RandomMatrix.StatementRoutes` as the build-checked index of public RandomMatrix example routes.

## RandomMatrix Milestones Kept As Names

Older RandomMatrix notes were reduced to milestone names because the Lean source is the source of truth:

- MC1/MC2: random-matrix vocabulary, operator-norm and unit-sphere bridges.
- MC3/MC4/MC5: variance proxy, statement honesty, spectral/trace-exp/Laplace vocabulary.
- MB-S1 to MB-S9: PSD variance-proxy algebra, spectral/Laplace bridge, trace-exp positivity, conditional Laplace route, Tropp/CFC typed primitives, trace-MGF wrapper, and Matrix Bernstein under-primitives wrapper.
- RM-S0 to RM-S7: centered families, rank-one adapters, sample-covariance algebra, variance-proxy route, two-sided quadratic-form route, and operator-norm wrappers.
- RM-ON: positive-threshold arbitrary-dimensional operator-norm route.

## Scalar Milestones Kept As Names

The scalar concentration history is considered stable background. Old stage detail is not repeated here:

- Tail events, Markov, Chebyshev.
- Orlicz-to-tail and tail-to-Orlicz bridges.
- Natural and real-exponent moment bridges.
- Rademacher and Hoeffding routes.
- Scalar Bernstein routes.

## Current Caveats Worth Remembering

- A proved wrapper under explicit primitives is not a proof of the primitive itself.
- The arbitrary operator-norm Matrix Bernstein route is positive-threshold; the zero-dimensional `t = 0` endpoint is intentionally not claimed.
- Avoid anonymous negated-family public signatures; introduce named adapters.
- Prefer shared RHS helpers over copied exponential formulas.

## Where To Look First

- Current status: [`Status.md`](../user/Status.md)
- Current API route map: [`APIOverview.md`](../user/APIOverview.md)
- Current RandomMatrix API: [`RandomMatrixAPI.md`](../user/RandomMatrixAPI.md)
- Current abstraction rules: [`AbstractionLog.md`](../maintainers/AbstractionLog.md)
- Current term/source map: [`TermMap.md`](../reference/TermMap.md)
- Current test policy: [`TestPlan.md`](../maintainers/TestPlan.md)