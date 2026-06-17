# Matrix Concentration Plan

This is the active plan index. Old stage notes were collapsed into
[`archive.md`](archive.md); use git history for exact old wording.

## Current Route

The current RandomMatrix route is an experimental Matrix Bernstein API under
explicit primitive assumptions. The useful surface is:

- trace-MGF wrapper under primitives;
- quadratic-form upper-tail wrappers;
- optimized scalar RHS helpers;
- self-adjoint operator-norm wrappers for positive thresholds;
- sample-covariance wrappers with explicit variance proxy or bounded-row crude variance proxy;
- named negative-family adapters where they have been proved.

## Core Files

- [`HighDimProb/RandomMatrix/ConcentrationStatements.lean`](../HighDimProb/RandomMatrix/ConcentrationStatements.lean)
- [`HighDimProb/RandomMatrix/Assumptions.lean`](../HighDimProb/RandomMatrix/Assumptions.lean)
- [`HighDimProb/RandomMatrix/VarianceProxy.lean`](../HighDimProb/RandomMatrix/VarianceProxy.lean)
- [`HighDimProb/RandomMatrix/Spectral.lean`](../HighDimProb/RandomMatrix/Spectral.lean)
- [`HighDimProb/RandomMatrix/TraceExp.lean`](../HighDimProb/RandomMatrix/TraceExp.lean)
- [`HighDimProb/Examples/RandomMatrix`](../HighDimProb/Examples/RandomMatrix)

## Current Boundaries

- The full Tropp/Lieb/CFC Matrix Bernstein proof is not in the library.
- Positive-threshold operator-norm wrappers are the honest arbitrary-dimension route; the nonnegative zero-dimensional endpoint is intentionally not claimed.
- Sample-covariance wrappers may still expose primitive assumptions when no adapter has been proved.
- Stable promotion should wait for clear tests, docs, and import-boundary checks.

## Next Safe Work

- Reduce remaining negative-side assumption duplication with named adapters.
- Add only thin wrappers that remove real repetition.
- Keep examples synced with the current API surface.
