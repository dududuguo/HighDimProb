# HighDimProb

HighDimProb is a Lean4 extension package for high-dimensional probability foundations. It is a Mathlib-compatible ergonomic layer, not a replacement for Mathlib probability.

HighDimProb is currently at Milestone 1 / v0.1-alpha. The stable probability object layer is usable, the high-dimensional layer is experimental, and deep theorem proving has not started yet.

Contributors should start from `docs/Status.md` and `docs/Workflow.md`.

## Project Goal

HighDimProb translates high-dimensional probability vocabulary into Lean-compatible infrastructure. The first goal is object language and API design, not deep theorem proving.

The book/reference notes guide concept extraction and theorem atlas construction. Deep results are first recorded as theorem atlas entries or typed `Prop` statements, then proved only when the required infrastructure is ready.

## Design Philosophy

- Reuse Mathlib first.
- Add thin wrappers, aliases, predicates, bridge lemmas, and examples only when useful.
- Do not create a custom probability universe.
- Do not create a custom random variable structure unless explicitly justified.
- Keep every stage compiling.
- Keep tests passing after every stage.
- Separate stable API from experimental scaffold modules.

## Installation / Build

Lake dependency example:

```lean
require HighDimProb from git
  "https://github.com/<OWNER>/HighDimProb.git" @ "v0.1.0-alpha"
```

Use the project locally with:

```bash
lake build
lake test
```

`lake build` checks the package. `lake test` checks API regression tests.

## Stable Public API

Users should normally import:

```lean
import HighDimProb
```

Current stable modules:

- `HighDimProb.Basic`
- `HighDimProb.ProbabilitySpace`
- `HighDimProb.RandomVariable`
- `HighDimProb.Distribution`
- `HighDimProb.Expectation`
- `HighDimProb.Lp`
- `HighDimProb.Moment`
- `HighDimProb.Orlicz`
- `HighDimProb.Tail`
- `HighDimProb.SubGaussian`
- `HighDimProb.SubExponential`
- `HighDimProb.BookStatements`

Current stable concepts:

- probability-space convention
- real-valued random variables
- law/distribution wrapper
- expectation wrapper
- Lp membership and extended Lp seminorm wrappers
- integrability vocabulary
- finite moment vocabulary
- Orlicz function vocabulary
- Orlicz bound predicates
- ψ₁ and ψ₂ bound predicates
- subGaussian tail, moment, MGF, and Orlicz predicate forms
- subExponential tail, moment, local-MGF, and Orlicz predicate forms
- upper/lower/absolute tail events
- tail probability wrappers
- tail-event measurability bridge lemmas
- theorem statement/specification layer

## Experimental API

Future/scaffold modules are available through:

```lean
import HighDimProb.Experimental
```

Experimental modules are not yet stable public API. `RandomVector`, `Covariance`, `Isotropic`, `SubGaussianVector`, `Nets`, and `MetricEntropy` currently have reviewed v0.2 object vocabulary, while the remaining modules are still scaffolds or future vocabulary:

- RandomVector
- Covariance
- Isotropic
- SubGaussianVector
- Nets
- MetricEntropy
- RandomMatrix
- RandomProcess
- GaussianWidth
- EmpiricalProcess
- SignalRecovery
- Tactic

## Current Workflow

1. Read `docs/Status.md`.
2. Read the relevant concept cluster from the reference notes.
3. Search Mathlib before defining anything.
4. Classify concepts as:
   - existing in Mathlib
   - wrapper/alias needed
   - new HighDimProb definition needed
   - theorem TODO
   - blocked
5. Implement only the current stage.
6. Add tiny examples.
7. Update documentation:
   - `docs/TermMap.md`
   - `docs/BookProgress.md`
   - `docs/AbstractionLog.md`
   - `docs/TODO.md`
   - `docs/Status.md`
8. Run:

```bash
lake build
lake test
```

9. Report:
   - files changed
   - declarations added
   - Mathlib objects reused
   - book concepts processed
   - build status
   - test status
   - blockers
   - exactly one next safe task

## Test Policy

- Every new public module needs a test file.
- Every new public declaration needs at least one `#check` or tiny example.
- Stable API is tested through `import HighDimProb`.
- Experimental API is tested through `import HighDimProb.Experimental`.
- Tests are API regression tests, not deep theorem tests.

## Theorem Atlas

Book results are first recorded in `docs/TheoremAtlas.md`.

Unproved book results must not be written as Lean `theorem` or `lemma`. Unproved results may be written as documentation entries or typed `abbrev ...Statement : Prop`. A result becomes a Lean theorem only when it has a proof.

The theorem atlas is used to expose missing infrastructure.

## Roadmap

### v0.1 — Probability object layer

- probability-space conventions
- real-valued random variables
- law/distribution
- expectation
- tail events and tail probabilities
- tail-event measurability
- Lp and moment vocabulary
- Orlicz / ψ₁ / ψ₂ definitions
- subGaussian and subExponential predicates as separate formulations

### v0.2 — High-dimensional object layer

- random vectors
- coordinates and one-dimensional marginals
- norm random variables
- covariance and second moment vocabulary
- centered and isotropic random vectors
- high-dimensional subGaussian vector predicates
- ε-nets
- covering numbers
- packing numbers
- metric entropy
- random matrices

### v0.3 — Process and application vocabulary

- random processes
- Gaussian processes vocabulary
- Gaussian width
- Gaussian complexity
- empirical processes
- VC vocabulary
- signal recovery vocabulary

### v1.0 — Selected theorem layer

Only after object language is stable. Potential theorem families:

- classical inequalities
- tail integral identity
- subGaussian equivalence theorem
- subExponential equivalence theorem
- Hoeffding
- Bernstein
- Hanson-Wright
- Johnson-Lindenstrauss
- covariance estimation
- random matrix norm bounds
- Dudley / generic chaining
- empirical process bounds
- signal recovery via M* bound

## Current Status

- Package builds.
- Tests pass.
- Milestone 1 is closed in `docs/Milestone1.md`.
- The v0.1 probability object layer is complete.
- Stable root import is separated from experimental scaffold modules.
- Lp and moment vocabulary are stable public API.
- Orlicz / ψ₁ / ψ₂ bound vocabulary is stable public API.
- SubGaussian formulation predicates are stable public API.
- SubExponential formulation predicates are stable public API.
- Random-vector object vocabulary is available through `HighDimProb.Experimental`.
- Covariance and centered-vector vocabulary is available through `HighDimProb.Experimental`.
- Isotropic random-vector vocabulary is available through `HighDimProb.Experimental`.
- High-dimensional subGaussian vector predicate vocabulary is available through `HighDimProb.Experimental`.
- Theorem atlas exists.
- Nets and metric entropy vocabulary is available through `HighDimProb.Experimental`.
- The metric entropy real-log wrapper is deferred pending a finite/infinite convention for `ℕ∞`.
- Next safe implementation stage is Stage 5B: covering/packing theorem statement layer.

## Future Work

1. Stage 5B: Covering/packing theorem statement layer.
2. Stage 6A: Random matrix object layer.
3. Stage 6B: Sample covariance vocabulary.
4. Stage 7: Random processes, Gaussian width, empirical process vocabulary.
5. Stage 8: Selected theorem proofs.
