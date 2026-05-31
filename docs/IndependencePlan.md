# Independence Plan

Stage C1 adds a small `HighDimProb.LimitTheorems.Assumptions` leaf for
Mathlib-backed scalar sample assumptions. The goal is vocabulary only, not
independence theorem development.

## Mathlib Objects Found

- `ProbabilityTheory.iIndepFun`: independence for indexed families of random variables.
- `ProbabilityTheory.IndepFun`: independence for two random variables.
- `ProbabilityTheory.IdentDistrib`: identical distribution via equality of pushforward laws.
- `ProbabilityTheory.IndepFun.variance_sum`: variance of a finite sum under pairwise independence.
- `ProbabilityTheory.IndepFun.covariance_eq_zero`: covariance vanishes under independence and `MemLp 2`.
- `MeasureTheory.TendstoInMeasure`: current Mathlib convergence-in-probability vocabulary.

## Current HighDimProb Wrappers

- `IndependentSample`
- `PairwiseIndependentFinSample`
- `IdenticallyDistributedSample`
- `IidSample`
- `IndependentFinSample`
- `IdenticallyDistributedFinSample`
- `IidFinSample`
- `IndependentSequence`
- `IdenticallyDistributedSequence`
- `IidSequence`

These are aliases/wrappers only. They intentionally do not bundle
measurability, integrability, or common-mean/common-variance hypotheses.

## WLLN Blockers

- Independence/iid wrappers now exist only for scalar sample families; no row,
  vector, or random-matrix iid bundle has been selected.
- Variance of finite sample sums is not yet wrapped through HighDimProb's
  `variance` and `sampleSum` vocabulary.
- Covariance-zero and independence-to-zero-covariance bridge lemmas are not yet
  exposed in HighDimProb form.
- No HighDimProb alias for convergence in probability has been selected; the
  weak-law statement currently uses Mathlib `TendstoInMeasure` directly.
- The sample mean variance formula is not yet proved.
- The common mean and common variance-bound assumptions are still unbundled.

## Next Design Choice

The next WLLN-focused proof stage should decide whether to start from
`PairwiseIndependentFinSample` plus `MemLp 2` and use
`ProbabilityTheory.IndepFun.variance_sum`, or first add covariance-zero
vocabulary that can support weaker assumptions than full independence.
