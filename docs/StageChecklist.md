# Stage Checklist

Use this checklist for every future stage. A stage should advance exactly one concept cluster and keep the repository buildable.

## For Each New Stage

- Read `docs/Status.md`.
- Identify the concept cluster from the reference notes.
- Search Mathlib first.
- Update `docs/TermMap.md`.
- Update `docs/BookProgress.md`.
- Update `docs/AbstractionLog.md`.
- Update `docs/TheoremAtlas.md` if relevant.
- Implement only the current module.
- Add API tests.
- Run `lake build`.
- Run `lake test`.
- Update `docs/Status.md` with exactly one next safe task.

## For Each New Public Declaration

- Add one `#check` or tiny example test.

## For Each New Module

- Decide stable vs experimental.
- Update `HighDimProb.lean` or `HighDimProb.Experimental` accordingly.
- Add an import test.

## For Each Theorem From the Book

- First add an entry to `docs/TheoremAtlas.md`.
- Only add a typed `Prop` statement if dependencies exist.
- Only write a Lean `theorem` when a proof exists.
