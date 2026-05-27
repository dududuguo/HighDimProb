# Contributing to HighDimProb

HighDimProb is a Mathlib-compatible ergonomic layer for high-dimensional probability foundations. Contributions should reuse Mathlib first and keep the package compiling after every change.

## Project Status

HighDimProb is currently Milestone 1 / v0.1-alpha. The stable v0.1 probability object layer is usable. The v0.2 high-dimensional object layer is experimental and partial. Deep theorem proving has not started yet.

## How to Build

```bash
lake build
```

## How to Test

```bash
lake test
```

## Contribution Workflow

1. Read `docs/Status.md`.
2. Read `docs/Workflow.md`.
3. Pick one small stage or issue.
4. Search Mathlib before defining anything.
5. Add tests for every public declaration.
6. Update docs.
7. Run `lake build` and `lake test`.

## Stable vs Experimental API

The stable API is exposed by:

```lean
import HighDimProb
```

Experimental and scaffold modules are exposed by:

```lean
import HighDimProb.Experimental
```

Do not promote experimental modules to the stable root import without an explicit stage decision.

## Theorem Atlas Policy

Book results belong first in `docs/TheoremAtlas.md` or as typed `Prop` statement layers when the required vocabulary already exists. Do not add unproved `theorem` or `lemma` declarations.

## Test Policy

Every public declaration needs a `#check` or tiny example test. Stable API tests should import `HighDimProb`; experimental API tests should import `HighDimProb.Experimental` or the specific experimental module.

## Hard Rules

- No `sorry`.
- No `admit`.
- No axioms.
- No optional dependencies without approval.
- No deep theorem PRs before the required object layer exists.
- No custom probability universe.
- No custom random variable structure.
- No linear translation of the book/reference notes.
- Every public declaration needs a `#check` or tiny example test.
- Docs must be updated with code changes.

