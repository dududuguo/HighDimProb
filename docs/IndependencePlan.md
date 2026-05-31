# Independence Plan

Stage C1 adds a small `HighDimProb.LimitTheorems.Assumptions` leaf for
Mathlib-backed scalar sample assumptions. The goal is vocabulary only, not
independence theorem development.

## Mathlib Objects Found

- `ProbabilityTheory.iIndepFun`: independence for indexed families of random variables.
- `ProbabilityTheory.iIndepFun_pi`: coordinate/transformed-coordinate independence under a finite product measure.
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

## Rademacher Product Family

Stage H2A proves the concrete coordinate-family independence theorem
`iIndepFun_rademacherCoord` for the product measure
`rademacherVectorMeasure n`.

Stage H2B proves that deterministic scalar transformations preserve the
coordinate independence needed for weighted signs:
`iIndepFun_weightedRademacherTerms`.  The weighted-sum MGF proof then reuses
Mathlib's `ProbabilityTheory.HasSubgaussianMGF.sum_of_iIndepFun`; no custom
product-expectation factorization lemma was needed.

This is not a general replacement for the scalar sample wrappers above. It is
a distribution-specific atom for the Hoeffding/Rademacher branch and reuses
Mathlib's product-measure theorem directly.

## Independent SubGaussian Sums

Stage H5 uses the direct Mathlib assumption
`ProbabilityTheory.iIndepFun X P` for a scalar family
`X : ι -> RealRandomVariable Omega`.

The general finite-sum MGF layer is now proved in
`HighDimProb.Concentration.SubGaussianSums`:

- unweighted sums use scale `sqrt (sum_i K_i^2)`;
- weighted sums use scale `sqrt (sum_i (a_i*K_i)^2)`;
- both have Finset helper theorems and `[Fintype ι]` user-facing wrappers;
- tail corollaries are derived by composing with the existing MGF-to-tail
  theorem.

No custom independence wrapper was added in this stage. The direct Mathlib
assumption is proof-friendly and keeps the theorem compatible with the LLN
assumption vocabulary.

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
