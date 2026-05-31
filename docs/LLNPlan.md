# LLN Plan

Stage LLN0-LLN1 prepares the finite-variance weak law of large numbers through
sample-mean vocabulary and typed statement targets only.

## Current Vocabulary

- `sampleSum X := fun omega => sum i : Fin n, X i omega`
- `sampleMean X := fun omega => (1 / (n : Real)) * sum i : Fin n, X i omega`
- `sampleMeanCentered X mu := fun omega => sampleMean X omega - mu`
- `IndependentFinSample`, `PairwiseIndependentFinSample`, and `IidFinSample`
  wrap Mathlib scalar sample independence/iid vocabulary.
- `IndependentSequence`, `IdenticallyDistributedSequence`, and `IidSequence`
  provide sequence-indexed scalar assumption vocabulary.

The definitions do not assume `0 < n`. Lean's total division convention handles
`n = 0`; later theorem statements should add positive-sample-size assumptions
when they need statistical denominators.

## Bridges Implemented

- `isRealRandomVariable_sampleSum`
- `isRealRandomVariable_sampleMean`
- `isRealRandomVariable_sampleMeanCentered`
- `integrable_sampleSum`
- `integrable_sampleMean`
- `integrable_sampleMeanCentered`

The centered integrability bridge requires `[IsFiniteMeasure P]` because it
subtracts a constant random variable.

## Typed Statement Targets

- `weakLawChebyshevBoundStatement`
- `weakLawFiniteVarianceStatement`

These are `abbrev ... : Prop` declarations, not theorem claims. The convergence
statement uses Mathlib `MeasureTheory.TendstoInMeasure` as the current
convergence-in-probability vocabulary.

## Proof Dependencies For WLLN

- sample mean and centered sample mean vocabulary
- measurability and integrability of finite sums
- square-integrability bridge for finite sample means
- expectation of finite sums / sample means
- variance of finite sums
- covariance-zero or independence assumptions
- iid or common-mean/common-variance assumptions
- positive sample-size bookkeeping
- convergence-in-probability statement convention

## Current Blockers

- scalar independence vocabulary is wrapped only as thin aliases; no theorem bridge uses it yet
- scalar iid vocabulary exists only as unbundled assumptions, without common mean or variance fields
- variance-of-sum theorem is missing
- covariance-zero assumptions are not packaged
- expectation-of-sum and mean-of-sample-mean bridge lemmas are missing
- square-integrability of sample means from coordinate assumptions is missing
- convergence-in-probability has no HighDimProb-facing alias yet

## Out Of Scope

- strong law of large numbers
- Kolmogorov SLLN
- Borel-Cantelli
- measure-theoretic convergence theorem proofs
- Hoeffding, Bernstein, or concentration theorem families
