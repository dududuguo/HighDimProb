# Archive

This file is intentionally small. It is not a second status document and it is
not a place to keep old full snapshots.

For exact current facts, read the Lean source, tests, generated docs, and the
focused active docs. For exact old wording, use git history.

## Stable Surfaces

The stable scalar/probability-facing surface is mature enough that this archive
does not track its old stage history. Read the source and tests instead:

- [`HighDimProb`](../HighDimProb)
- [`HighDimProbTest`](../HighDimProbTest)
- [`docs/ScalarConcentrationTheoremIndex.md`](ScalarConcentrationTheoremIndex.md)
- [`docs/TestPlan.md`](TestPlan.md)

## Current Active Areas

- RandomMatrix and Matrix Bernstein remain experimental.
- Sample-covariance wrappers are useful, but still expose real primitive
  assumptions when no adapter theorem has been proved.
- Documentation should stay short: current files carry current facts; this file
  only records why old detail disappeared.

## Collapsed Historical Groups

The old long docs were collapsed into short current-facing files:

| Old pressure point | Current file | What remains |
|---|---|---|
| Status stage logs | [`Status.md`](Status.md) | Current development status and verification commands. |
| Abstraction notes | [`AbstractionLog.md`](AbstractionLog.md) | Active abstraction rules only. |
| TODO logs | [`TODO.md`](TODO.md) | Current short task list. |
| Matrix concentration plan | [`MatrixConcentrationPlan.md`](MatrixConcentrationPlan.md) | Current route and boundaries. |
| Matrix Bernstein proof plan | [`MatrixBernsteinProofPlan.md`](MatrixBernsteinProofPlan.md) | Current proof boundary. |
| Book progress | [`BookProgress.md`](BookProgress.md) | Short milestone summary. |
| Branch registry | [`BranchRegistry.md`](BranchRegistry.md) | Current branch map. |
| Theorem atlas | [`TheoremAtlas.md`](TheoremAtlas.md) | Compact theorem-family index. |
| Term map | [`TermMap.md`](TermMap.md) | Compact term/source map. |
| RandomMatrix API notes | [`RandomMatrixAPI.md`](RandomMatrixAPI.md) | Current RandomMatrix API names and caveats. |
| Test-plan history | [`TestPlan.md`](TestPlan.md) | Current commands and policy surfaces. |

## RandomMatrix Milestones Kept As Names

Older RandomMatrix notes were reduced to milestone names because the Lean source
is the source of truth:

- MC1/MC2: random-matrix vocabulary, operator-norm and unit-sphere bridges.
- MC3/MC4/MC5: variance proxy, statement honesty, spectral/trace-exp/Laplace
  vocabulary.
- MB-S1 to MB-S9: PSD variance-proxy algebra, spectral/Laplace bridge,
  trace-exp positivity, conditional Laplace route, Tropp/CFC typed primitives,
  trace-MGF wrapper, and Matrix Bernstein under-primitives wrapper.
- RM-S0 to RM-S7: centered families, rank-one adapters, sample-covariance
  algebra, variance-proxy route, two-sided quadratic-form route, and
  operator-norm wrappers.
- RM-ON: positive-threshold arbitrary-dimensional operator-norm route.

## Scalar Milestones Kept As Names

The scalar concentration history is considered stable background. Old stage
detail is not repeated here:

- Tail events, Markov, Chebyshev.
- Orlicz-to-tail and tail-to-Orlicz bridges.
- Natural and real-exponent moment bridges.
- Rademacher and Hoeffding routes.
- Scalar Bernstein routes.

## Current Caveats Worth Remembering

- A proved wrapper under explicit primitives is not a proof of the primitive
  itself.
- The arbitrary operator-norm Matrix Bernstein route is positive-threshold; the
  zero-dimensional `t = 0` endpoint is intentionally not claimed.
- Avoid anonymous negated-family public signatures; introduce named adapters.
- Prefer shared RHS helpers over copied exponential formulas.

## Where To Look First

- Current status: [`Status.md`](Status.md)
- Current RandomMatrix API: [`RandomMatrixAPI.md`](RandomMatrixAPI.md)
- Current abstraction rules: [`AbstractionLog.md`](AbstractionLog.md)
- Current term/source map: [`TermMap.md`](TermMap.md)
- Current test policy: [`TestPlan.md`](TestPlan.md)
