# Workflow

HighDimProb is a Mathlib-compatible ergonomic layer for high-dimensional probability. Reuse Mathlib first, then add thin wrappers, aliases, predicates, bridge lemmas, examples, and documentation. The reference notes are a roadmap for vocabulary, not a theorem-proving target.

## Mandatory Round Workflow

Step 1. Read `docs/Status.md`.

Step 2. Read the relevant part of the reference notes.

Step 3. Extract one concept cluster only.

Step 4. Search Mathlib before defining anything.

Step 5. Classify each concept as:
- existing in Mathlib
- wrapper/alias needed
- new HighDimProb definition needed
- theorem TODO
- blocked

Step 6. Implement only the current allowed object-level task.

Step 7. Add tiny examples.

Step 8. Update docs:
- `TermMap.md`
- `BookProgress.md`
- `AbstractionLog.md`
- `TODO.md`
- `Status.md`

Step 9. Run:
- `lake build`
- `lake test`

Step 10. Report:
- files changed
- declarations added
- Mathlib objects reused
- book concepts processed
- build status
- test status
- blockers
- exactly one next safe task

## Hard Rules

- no linear translation of the book
- no deep theorem proving before the object layer is stable
- no custom probability universe
- no custom random variable structure unless explicitly approved
- no optional dependencies unless explicitly approved
- no fake Lean declarations for hard theorems
- keep `lake build` passing after every round
- keep `lake test` passing after every round
- if `lake test` fails, fix tests or code before continuing
