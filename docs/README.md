# Documentation

The Lean source, tests, judge files, and root `README.md` are the source of truth. This directory is intentionally user-facing: it gives route maps, current status, and contribution policy, not a duplicate theorem database.

Start here:

- `APIOverview.md`: import layers, main API areas, and the preferred example route.
- `Status.md`: current repository state, caveats, and next safe task.
- `RandomMatrixAPI.md`: RandomMatrix and Matrix Bernstein public names.
- `TermMap.md`: compact concept-to-source map.
- `TheoremAtlas.md`: theorem-family status without full signatures.
- `STATEMENTS.md`: developer-facing hardbone statement ledger for provider targets.
- `TestPlan.md`: checks contributors should run.
- `Workflow.md`: contribution and cleanup rules.
- `TODO.md`: short active task list.

Developer references:

- `AssumptionVocabulary.md`: assumption predicates and theorem-interface adapters.
- `JudgeSystem.md`: downstream-style API judge suite.
- `LeanTooling.md`: local Lean, doc-gen4, and import-graph tooling.
- `ModuleTree.md`: module layout and import boundaries.
- `BranchRegistry.md`: compact branch/import status.
- `BookProgress.md`: short milestone index.
- `archive.md`: why old detailed docs were removed; use git history for exact old wording.

Avoid adding new long progress logs. Put stable API facts in source/docs, proof-frontier evidence in `external/validation`, and usage demonstrations in examples.

`STATEMENTS.md` is the exception to the user-facing rule: it is a developer
ledger for precise hard assumptions that independent provider work is expected
to discharge later. Downstream users should prefer `APIOverview.md`,
`RandomMatrixAPI.md`, and examples; names recorded only in `STATEMENTS.md` are
not promoted as stable caller-facing API.
