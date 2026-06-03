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

Status: complete as an experimental branch.

Scope:
- Markov/Chebyshev/Boole core concentration,
- scalar Orlicz/tail/moment/MGF implication spine,
- Rademacher and Hoeffding theorem families,
- subGaussian and subExponential finite-sum infrastructure,
- full finite-`ENNReal` moment bridges for fixed-scale subGaussian and
  subExponential formulations,
- local, min-form, and weighted scalar Bernstein under the lintegral predicate.

Closure:
- `docs/Milestone-ScalarConcentration.md`
- `docs/ConcentrationLeafAudit.md`
- `docs/ScalarConcentrationTheoremIndex.md`
- `docs/ConcentrationTestCoverage.md`

Remaining blockers:
- reverse/source MGF links,
- subExponential equivalence package,
- raw-predicate Bernstein bridge.

## M5: Random Matrix Theorem Statement Layer

Status: future.

Scope:
- random matrix norm statement specifications,
- covariance estimation statement specifications,
- Hanson-Wright statement specifications,
- Johnson-Lindenstrauss statement specifications,
- matrix Bernstein statement specifications.

## Next Recommended Branch

Stage Branch-choice: select exactly one next major branch.

The scalar concentration branch now has fixed-scale Orlicz/tail/full-moment
bridges for both subGaussian and subExponential formulations. The remaining
scalar gaps are reverse/source MGF links, finite-gauge variants, raw-predicate
Bernstein, and optional equivalence packaging. The next major branch should be
chosen from matrix Bernstein, Hanson-Wright, or WLLN/SLLN based on project
direction.

## M6: Selected High-Dimensional Theorem Proofs

Status: future.

Scope:
- only selected theorem proofs after object layers, statement layers, and bridge lemmas are ready.
- no broad theorem push before dependencies are explicit in `docs/TheoremAtlas.md`.
