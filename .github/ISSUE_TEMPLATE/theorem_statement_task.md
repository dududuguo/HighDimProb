---
name: Theorem statement task
about: Theorem atlas entries, typed Prop specifications, or missing dependency analysis
title: "[Theorem statement] "
labels: theorem-statement
assignees: ""
---

## Theorem Family

Name the book result or theorem family.

## Scope

- Translate the result into `docs/reference/TheoremAtlas.md`.
- Add a typed `Prop` specification only if dependencies exist.
- Identify missing dependencies when the statement is blocked.

## Rule

Do not add unproved Lean `theorem` or `lemma` declarations.

## Checks

- [ ] `lake build`
- [ ] `lake test`
