# Roadmap

HighDimProb advances in staged layers. Each stage should keep `lake build` and `lake test` passing.

## M1: Stable Scalar Probability Object Layer

Status: complete.

Scope:
- probability spaces,
- real random variables,
- laws,
- expectation,
- tails,
- Lp and moment vocabulary,
- Orlicz and scalar subGaussian/subExponential predicates.

## M2: Experimental High-Dimensional Object Layer

Status: active/partial.

Scope:
- random vectors,
- covariance and centeredness,
- isotropicity,
- high-dimensional subGaussian predicates,
- nets and metric entropy vocabulary.

## M3: Random Matrix and Process Object Layer

Status: active/partial.

Scope:
- random matrices,
- rows, columns, actions, norms, assumptions,
- sample covariance,
- random processes,
- Gaussian width,
- empirical process vocabulary.

## M4: Scalar Concentration Proof Layer

Status: future.

Scope:
- Markov/Chebyshev-style pilots,
- scalar concentration statements,
- expectation and tail bridge lemmas,
- subGaussian/subExponential proof infrastructure.

## M5: Random Matrix Theorem Statement Layer

Status: future.

Scope:
- random matrix norm statement specifications,
- covariance estimation statement specifications,
- Hanson-Wright statement specifications,
- Johnson-Lindenstrauss statement specifications,
- matrix Bernstein statement specifications.

## M6: Selected High-Dimensional Theorem Proofs

Status: future.

Scope:
- only selected theorem proofs after object layers, statement layers, and bridge lemmas are ready.
- no broad theorem push before dependencies are explicit in `docs/TheoremAtlas.md`.
