# Contributing to HighDimProb

HighDimProb is a Mathlib-compatible ergonomic layer for high-dimensional probability foundations. Contributions should be small, dependency-first, documented, and tested.

## Project Status

HighDimProb is currently Milestone 1 / v0.1-alpha.

- The stable root import is intentionally small.
- The scalar concentration branch is the most stable theorem surface.
- RandomMatrix, Matrix Bernstein, and limit-theorem modules are experimental.
- RandomMatrix theorem work is active, but several Matrix Bernstein results are
  still conditional on explicit primitive assumptions. See
  `docs/Status.md` and `docs/RandomMatrixAPI.md` before contributing there.

## Verification

```bash
lake build
lake build HighDimProbJudge
lake test
python .github/scripts/check_text_quality.py
python scripts/judge_policy_check.py
```

## Contribution Workflow

1. Read `docs/Status.md`.
2. Read `docs/Workflow.md`.
3. Pick exactly one small task.
4. Search Mathlib first.
5. Implement only object-level definitions or wrappers unless the task explicitly says theorem proof.
6. Add tests.
7. Update the focused current docs touched by the change.
8. Run the verification commands above.

For model-assisted contributions, read `docs/Workflow.md` first.

## PR Title Categories

Use one of these prefixes:

- `feat:` for new object-layer vocabulary or wrappers.
- `proof:` for proved theorem or bridge-lemma work.
- `doc:` for documentation-only updates.
- `test:` for test-only updates.
- `refactor:` for code movement that should preserve behavior.
- `chore:` for repository maintenance.
- `fix:` for bug fixes.

Examples:

- `feat(random-matrix): add sample covariance vocabulary`
- `proof(tail): prove tail monotonicity`
- `doc(atlas): add Hanson-Wright dependencies`
- `test(orlicz): add psi2 API tests`

## Coordination Policy

Open an issue before major changes, including:

- new abstractions,
- new notation,
- new theorem families,
- major refactors,
- new optional dependencies.

Optional dependencies require explicit approval before implementation.

## Stable vs Experimental API

Stable v0.1 modules are imported through:

```lean
import HighDimProb
```

Experimental modules are imported through:

```lean
import HighDimProb.Experimental
```

Active branch aggregates, such as RandomMatrix, may also be imported directly
while they remain experimental:

```lean
import HighDimProb.RandomMatrix
```

No module is promoted from experimental to stable without tests, docs, a
`docs/Status.md` update, and a stable root import audit.

## Hard Rules

- No `sorry`.
- No `admit`.
- No axioms.
- No optional dependencies without approval.
- No custom probability universe.
- No custom random variable structure.
- No linear translation of the book.
- No theorem PR that skips the required object layer or Mathlib search.
- Every public declaration needs a test.
- Docs must be updated together with code.
- Public RandomMatrix/example signatures should use named family adapters
  instead of anonymous negated-family lambdas.
- Active docs should stay short; use source, generated docs, and git history
  instead of keeping long stage logs current.

## Theorem Policy

Unproved book results belong in `docs/TheoremAtlas.md` or, when all dependencies exist, as typed `Prop` specifications. Unproved book results must never be introduced as Lean `theorem` or `lemma` declarations.
