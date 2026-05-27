---
name: Theorem statement task
about: Add documentation or typed Prop statements for future theorems
title: "[Theorem statement] "
labels: theorem-statement
assignees: ""
---

## Theorem Family

Name the book/result family.

## Dependencies

List the object-layer declarations needed to state it.

## Scope

- Do not add unproved `theorem` or `lemma` declarations.
- Use docs or typed `abbrev ...Statement : Prop` only when the vocabulary already exists.

## Checks

- [ ] `lake build`
- [ ] `lake test`

