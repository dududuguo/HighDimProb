# Milestone 1

## Summary

HighDimProb now has a stable probability object layer, a theorem atlas, an API regression testsuite, experimental high-dimensional object vocabulary, and Mathlib-backed metric entropy wrappers.

Milestone 1 closes the initial infrastructure phase. The package is ready to continue with focused v0.2 object/theorem-statement work, while deeper theorem proofs remain deferred.

## Stable v0.1 API

Stable root modules:
- `HighDimProb.Basic`
- `HighDimProb.ProbabilitySpace`
- `HighDimProb.RandomVariable`
- `HighDimProb.Distribution`
- `HighDimProb.Expectation`
- `HighDimProb.Tail`
- `HighDimProb.Lp`
- `HighDimProb.Moment`
- `HighDimProb.Orlicz`
- `HighDimProb.SubGaussian`
- `HighDimProb.SubExponential`
- `HighDimProb.BookStatements`

Stable concepts:
- probability-space convention
- real-valued random variables
- law/distribution
- expectation
- tail events and tail probabilities
- tail-event measurability
- Lp membership and Lp seminorm vocabulary
- moment vocabulary
- Orlicz / ψ₁ / ψ₂ bounds
- scalar subGaussian predicate forms
- scalar subExponential predicate forms
- typed theorem statement layer

## Experimental v0.2 API

Experimental modules:
- `HighDimProb.RandomVector`
- `HighDimProb.Covariance`
- `HighDimProb.Isotropic`
- `HighDimProb.SubGaussianVector`
- `HighDimProb.Nets`
- `HighDimProb.MetricEntropy`
- `HighDimProb.RandomMatrix`
- `HighDimProb.RandomProcess`
- `HighDimProb.GaussianWidth`
- `HighDimProb.EmpiricalProcess`
- `HighDimProb.SignalRecovery`
- `HighDimProb.Tactic`

Experimental concepts:
- random vectors as `Ω → Fin n → ℝ`
- coordinate random variables
- directional marginals
- direction norm / scale
- mean vector
- centered vector
- covariance matrix
- second moment matrix
- isotropic predicate forms
- high-dimensional subGaussian vector predicate forms
- ε-net wrappers
- covering number wrappers
- packing number wrappers

## What is not proved yet

- subGaussian equivalence theorem
- subExponential equivalence theorem
- Hoeffding
- Bernstein
- covariance identities
- isotropic equivalence theorems
- vector norm concentration
- packing-covering inequalities
- Euclidean ball covering bounds
- ε-net operator norm theorem
- random matrix bounds
- Hanson-Wright
- Johnson-Lindenstrauss
- Dudley/generic chaining
- empirical process bounds
- signal recovery guarantees

## Build and test status

This milestone requires both commands to pass:

```bash
lake build
lake test
```

