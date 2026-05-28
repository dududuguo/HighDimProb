# Future Scaffold

This map organizes future stages. It is not an implementation plan for the current round.

## Stage 5B: Covering/Packing Theorem Statement Layer

- Goal: record HighDimProb-facing theorem statements for covering and packing relationships.
- Target files: `HighDimProb/BookStatements.lean`, `HighDimProb/MetricEntropy.lean`, `docs/TheoremAtlas.md`.
- Expected tests: typed statement `#check`s and import checks.
- Theorem atlas entries: covering-packing inequalities, maximal separated set is a net.
- Forbidden tasks: no proof of covering bounds, no Euclidean ball estimates, no operator norm net theorem.

## Stage 6A: Random Matrix Object Layer

- Goal: introduce random matrix vocabulary without theorem proving.
- Target files: `HighDimProb/RandomMatrix.lean`, `HighDimProb/Experimental.lean`, `HighDimProbTest/RandomMatrixAPI.lean`.
- Expected tests: matrix-valued random variable checks, entry and row/column access examples.
- Theorem atlas entries: random matrix norm bounds, Johnson-Lindenstrauss, Hanson-Wright.
- Forbidden tasks: no random matrix concentration, no independence theory, no stable root promotion.

## Stage 6B: Sample Covariance Vocabulary

- Goal: add vocabulary for samples and sample covariance objects.
- Target files: `HighDimProb/Covariance.lean`, `HighDimProb/RandomMatrix.lean`, experimental tests.
- Expected tests: `#check`s for empirical mean and sample covariance declarations.
- Theorem atlas entries: covariance estimation.
- Forbidden tasks: no covariance concentration proof, no matrix norm theorem.

## Stage 6C: Random Matrix Theorem Statement Layer

- Goal: add typed `Prop` specifications for random matrix theorem families when dependencies exist.
- Target files: `HighDimProb/BookStatements.lean`, `docs/TheoremAtlas.md`.
- Expected tests: statement elaboration tests.
- Theorem atlas entries: norm bounds, singular value bounds, Johnson-Lindenstrauss, Hanson-Wright.
- Forbidden tasks: no unproved Lean `theorem`, no proof attempts.

## Stage 7A: Random Process Vocabulary

- Goal: add object-level vocabulary for indexed random processes.
- Target files: `HighDimProb/RandomProcess.lean`, experimental tests.
- Expected tests: process declaration checks and finite-index examples.
- Theorem atlas entries: Dudley inequality, generic chaining.
- Forbidden tasks: no chaining functional proof, no supremum measurability theorem.

## Stage 7B: Gaussian Width / Gaussian Complexity Vocabulary

- Goal: introduce Gaussian width and Gaussian complexity vocabulary.
- Target files: `HighDimProb/GaussianWidth.lean`, experimental tests.
- Expected tests: declaration checks and simple type examples.
- Theorem atlas entries: Gaussian width comparison, M-star dependencies.
- Forbidden tasks: no width estimates, no Gordon theorem, no escape theorem.

## Stage 7C: Generic Chaining Theorem Statement Layer

- Goal: record typed statement specifications for chaining and entropy bounds.
- Target files: `HighDimProb/BookStatements.lean`, `docs/TheoremAtlas.md`.
- Expected tests: statement `#check`s.
- Theorem atlas entries: Dudley inequality, generic chaining.
- Forbidden tasks: no proof of Dudley, no gamma functional development beyond needed vocabulary.

## Stage 8A: Empirical Process Vocabulary

- Goal: introduce empirical process and empirical average vocabulary.
- Target files: `HighDimProb/EmpiricalProcess.lean`, experimental tests.
- Expected tests: declaration checks for empirical means and function-class deviations.
- Theorem atlas entries: empirical process bounds, symmetrization.
- Forbidden tasks: no concentration proofs, no VC theorem proof.

## Stage 8B: VC / Learning Theory Vocabulary

- Goal: add VC and learning-theory vocabulary needed to state later results.
- Target files: `HighDimProb/EmpiricalProcess.lean`, experimental tests, docs.
- Expected tests: `#check`s for VC and shattering vocabulary.
- Theorem atlas entries: VC dimension bounds, uniform convergence.
- Forbidden tasks: no Sauer-Shelah proof, no learning guarantee proof.

## Stage 9A: Signal Recovery Vocabulary

- Goal: add measurement, feasible set, and recovery vocabulary.
- Target files: `HighDimProb/SignalRecovery.lean`, experimental tests.
- Expected tests: declaration checks for measurement models and recovery maps.
- Theorem atlas entries: M-star bound, recovery theorem families.
- Forbidden tasks: no optimization theorem proof, no random matrix recovery proof.

## Stage 9B: M* Bound / Recovery Theorem Statement Layer

- Goal: record typed statement specifications for M-star and recovery results when dependencies exist.
- Target files: `HighDimProb/BookStatements.lean`, `docs/TheoremAtlas.md`.
- Expected tests: statement elaboration checks.
- Theorem atlas entries: M-star bound, escape theorem, signal recovery guarantees.
- Forbidden tasks: no theorem proof, no optional optimization dependency, no stable root promotion.
