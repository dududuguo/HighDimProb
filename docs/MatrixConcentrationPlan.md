# Matrix Concentration Plan

This is the active plan index. Old stage notes were collapsed into
[`archive.md`](archive.md); use git history for exact old wording.

## Current Route

The current RandomMatrix route is supported within its documented
finite-dimensional theorem contracts. The Matrix Bernstein endpoint remains
scoped by explicit primitive assumptions. The useful surface is:

- trace-MGF wrapper under primitives;
- quadratic-form upper-tail wrappers;
- optimized scalar RHS helpers;
- self-adjoint operator-norm wrappers for positive thresholds;
- generated-history centered-rank-one and exact-row sample-covariance endpoints;
- named negative-family adapters where they have been proved.

## Core Files

- [`HighDimProb/RandomMatrix/ConcentrationStatements.lean`](../HighDimProb/RandomMatrix/ConcentrationStatements.lean)
- [`HighDimProb/RandomMatrix/Assumptions.lean`](../HighDimProb/RandomMatrix/Assumptions.lean)
- [`HighDimProb/RandomMatrix/VarianceProxy.lean`](../HighDimProb/RandomMatrix/VarianceProxy.lean)
- [`HighDimProb/RandomMatrix/Spectral.lean`](../HighDimProb/RandomMatrix/Spectral.lean)
- [`HighDimProb/RandomMatrix/TraceExp.lean`](../HighDimProb/RandomMatrix/TraceExp.lean)
- [`HighDimProb/Examples/RandomMatrix`](../HighDimProb/Examples/RandomMatrix)

## Current Boundaries

- Bernstein CFC and the finite-dimensional left/right Lieb/Epstein route are proved.
- Arbitrary-history conditioning and unconditional full Matrix Bernstein are not proved.
- Positive-threshold operator-norm wrappers are the honest arbitrary-dimension route; the nonnegative zero-dimensional endpoint is intentionally not claimed.
- `MatrixBernstein.sampleCovarianceExactRow` closes the row-specific normalized
  tail, and `MatrixBernstein.sampleCovarianceExactRowHighProbability` supplies
  its canonical `1 - delta` specialization. The reusable
  `iIndepFun_centeredRankOne` bridge transfers raw vector-family independence.
  Measurability, `MemLp 2`, boundedness, and parameter-domain hypotheses remain
  explicit; older wrappers retain explicit primitives only as compatibility
  surfaces.
- New promotions must preserve the provider layer boundaries and explicit contracts.

## Next Safe Work

- Add a reader-facing exact-row example only where its sharper rate is materially
  used.
- Derive Loewner and spectral high-probability corollaries from the normalized
  operator-norm event without duplicating the Bernstein proof.
- Keep legacy Tropp bundles documented as compatibility surfaces.
