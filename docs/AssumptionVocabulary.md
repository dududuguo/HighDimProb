# Assumption Vocabulary

This audit records which mathematical assumptions already have HighDimProb
declarations and which are still missing. It is a planning document only.

## Scalar

| Assumption | Existing declaration | Missing declaration | Mathlib object | Target module | Priority | Blockers |
| --- | --- | --- | --- | --- | --- | --- |
| pointwise nonnegative | direct hypothesis `∀ ω, 0 ≤ X ω` | named predicate optional | order on `ℝ` | `HighDimProb.Concentration.Basic` | low | Current direct hypothesis is usable for Markov. |
| a.e. nonnegative | none | `AEStronglyNonnegative` or wrapper | `0 ≤ᵐ[P] X` | `HighDimProb.Concentration.Basic` | medium | Need policy for pointwise vs a.e. APIs. |
| integrable | `IntegrableRealRandomVariable P X` | none | `Integrable X P` | `HighDimProb.Expectation` | done | Existing wrapper works. |
| square-integrable | `MemLpRealRandomVariable P X 2` | optional named alias | `MemLp X 2 P` | `HighDimProb.Lp` | low | Chebyshev uses the current wrapper. |
| centered | `Centered P X` | none | integral zero | `HighDimProb.Scalar.Centering` | done | Scalar centering is re-exported for concentration. |
| variance finite | none | named finite-variance predicate | `MemLp X 2 P` / variance | `HighDimProb.Scalar.Variance` | medium | Decide whether finite variance is `MemLp 2` or a variance-specific predicate. |

## Vector

| Assumption | Existing declaration | Missing declaration | Mathlib object | Target module | Priority | Blockers |
| --- | --- | --- | --- | --- | --- | --- |
| centered vector | `CenteredVector P X` | none | coordinate functions | `HighDimProb.Covariance` | done | Coordinate bridge is proven. |
| isotropic vector | `IsotropicSecondMoment`, `IsotropicCovariance`, `IsotropicMarginal` | canonical isotropic predicate policy | matrix equality / covariance | `HighDimProb.Isotropic` | medium | Formulation choice remains separate. |
| subGaussian vector | `SubGaussianVectorOrlicz`, `SubGaussianVectorTail`, `SubGaussianVectorMoment` | implication graph | scalar formulations over marginals | `HighDimProb.SubGaussianVector` | medium | Scalar implication graph exists; vector lifting is future work. |
| independent coordinates | none | `IndependentCoords` | Mathlib independence APIs | future `HighDimProb.Vector.Independence` | high | Need finite-family independence policy. |
| iid coordinates | none | `IIDCoords` | `IdentDistrib`, independence | future `HighDimProb.Vector.Independence` | high | Depends on coordinate independence and distribution wrappers. |

## Matrix

| Assumption | Existing declaration | Missing declaration | Mathlib object | Target module | Priority | Blockers |
| --- | --- | --- | --- | --- | --- | --- |
| centered entries | `CenteredEntries P A` | none | scalar `Centered` | `HighDimProb.RandomMatrix.Assumptions` | done | Entrywise centeredness exists. |
| independent entries | none | `IndependentEntries` | Mathlib finite-family independence | future `HighDimProb.RandomMatrix.Independence` | high | Need policy for entry-indexed families. |
| iid entries | none | `IIDEntries` | independence + identical distribution | future `HighDimProb.RandomMatrix.Independence` | high | Depends on `IndependentEntries` and distribution equality. |
| independent rows | none | `IndependentRows` | Mathlib finite-family independence | future `HighDimProb.RandomMatrix.Independence` | high | Needed for sample covariance and matrix deviation statements. |
| iid rows | none | `IIDRows` | independence + row laws | future `HighDimProb.RandomMatrix.Independence` | high | Needs row-vector distribution vocabulary. |
| isotropic rows | `IsotropicRowsSecondMoment`, `IsotropicRowsCovariance` | none | row-vector isotropic predicates | `HighDimProb.RandomMatrix.Assumptions` | done | Existing row predicates are sufficient for statement prerequisites. |
| subGaussian rows | `SubGaussianRowsOrlicz` | tail/moment row variants optional | scalar/vector subGaussian predicates | `HighDimProb.RandomMatrix.Assumptions` | done/medium | Orlicz row form exists; other formulations can be added after vector implication lifting. |
| bounded operator norm | `operatorNorm A` as random variable | predicate `BoundedOperatorNorm` | Mathlib matrix norm | `HighDimProb.RandomMatrix.OperatorNorm` | medium | Need measurability bridge and threshold convention. |
| symmetric random matrix | none | `SymmetricRandomMatrix` | matrix transpose / symmetric predicate | future `HighDimProb.RandomMatrix.Symmetric` | high | Needed for matrix Bernstein and PSD/order statements. |
| PSD random matrix | none | `PSDRandomMatrix` | Mathlib PSD matrix APIs | future `HighDimProb.RandomMatrix.Order` | high | Need matrix order convention and positivity API choice. |

## Immediate Consequences

- Random matrix theorem statements depending on independence should remain
  blocked in `docs/TheoremAtlas.md`.
- The next implementation branch should add random-matrix independence
  vocabulary before matrix concentration statements are promoted to Lean.
- Scalar concentration can continue toward moment/MGF links without depending
  on the matrix assumption layer.
