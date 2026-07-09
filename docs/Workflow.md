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
- update only the focused current docs touched by the change;
- keep stable background short and point to source/tests;
- do not expand `archive.md` into another status log.

Step 9. Run:
- `python .github/scripts/check_text_quality.py`
- `python scripts/judge_policy_check.py`
- `lake build`
- `lake build HighDimProbJudge`
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
- no `s[o]rry`
- no `a[d]mit`
- no `a[x]iom`s
- keep `lake build` passing after every round
- keep `lake test` passing after every round
- if `lake test` fails, fix tests or code before continuing

## Model-Assisted Cleanup Checklist

Use this checklist before committing model-assisted cleanup or open-source
preparation work.

1. Start from the working tree:
   - run `git status --short`;
   - separate real project changes from local/generated files;
   - do not touch unrelated dirty paths such as `external/` submodules.

2. Search before abstracting:
   - use the code graph or `rg` to find existing objects, bridges, and family
     adapters before adding new names;
   - if a proof, example, or test repeats the same expanded right-hand side,
     prefer a named object or wrapper;
   - avoid rebuilding an API that already exists under another module name.

3. Keep public APIs named:
   - avoid anonymous `fun omega => ...` expressions in public theorem
     conclusions when a reusable definition can name the object;
   - examples, tests, and judge files should use the named API, not a copied
     expansion;
   - add focused `#check`s for every new public declaration.

4. Clean generated or unrelated scaffolding:
   - do not commit local databases, binaries, installer notes, or tool-specific
     harness files unless the repository actually ships and documents that
     tool;
   - do not add instructions that require unavailable commands or private
     workflows;
   - remove stale local artifacts before the final status check.

5. Update all progress documents, not just `Status.md`:
   - update the API index, term map, theorem atlas, TODO/proof-plan docs, and
     progress log only when the change affects them;
   - search old next-task names and old "future support" language after each
     stage update;
   - say clearly what was proved and what remains unproved.

6. Keep comments useful:
   - comments should identify mathematical intent, scaling conventions,
     hypotheses, and boundary of the result;
   - avoid debug notes, temporary wording, or implementation diary text in
     Lean comments.

7. Rebuild in dependency order:
   - rebuild the changed upstream module before checking downstream examples if
     direct `lake env lean` sees stale declarations;
   - run `python scripts/judge_policy_check.py`;
   - run `git diff --check`;
   - run `lake build HighDimProbJudge`;
   - run `lake test`.

## Stable vs Experimental Policy

- Stable v0.1 modules are imported through `import HighDimProb`.
- Experimental v0.2+ modules are imported through `import HighDimProb.Experimental`.
- No module is promoted from experimental to stable without tests, docs, a `docs/Status.md` update, and a stable root import audit.

## Theorem Atlas Policy

- Unproved book results are documentation entries or typed `Prop` specifications.
- Unproved book results are never Lean `theorem` or `lemma` declarations.
- Theorem atlas status must be one of: `raw`, `informal`, `typed-prop`, `blocked`, `proven`.
