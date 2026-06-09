# Multi-Agent System Notes

This directory contains experimental planning notes for theory-to-Lean work.

It is not required for `lake build`, `lake test`, or normal use of the
HighDimProb Lean package. Treat it as maintainer background material.

## Boundary

The main repository wins over anything in this directory. In particular, trust
the Lean source, `README.md`, `CONTRIBUTING.md`, and `docs/Workflow.md` before
these notes.

Hard rules for actual repository changes:

- Do not add `sorry`, `admit`, axioms, or fake theorem bodies.
- Search Mathlib and existing HighDimProb declarations before adding names.
- Keep stable and experimental imports separated.
- Do not write into `external/theory-roadmap/` automatically.
- Run the relevant Lake builds and tests before considering a change integrated.

## Layout

- `agents/`: rough agent role descriptions.
- `fsm/`: finite-state-machine planning notes.
- `integration/`: notes on theory-roadmap and codebase-memory integration.
- `workflows/`: draft workflows for formalization and repair tasks.

These files are allowed to be rough. They are not public API documentation.
