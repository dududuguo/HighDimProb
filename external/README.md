# External Material

This directory holds support material that sits outside the public Lean API.

The source of truth for users is the Lean code in `HighDimProb/`, the public
imports, and the main documentation in `README.md` and `docs/`.

Current contents:

- `theory-roadmap/`: optional Git submodule with theory-side planning material.
- `codebase-memory/`: generated code knowledge-graph artifacts for agent and
  maintainer workflows.
- `multi-agent-system/`: experimental planning notes for theory-to-Lean work.
- `validation/`: selected validation and milestone logs from development runs.

Files here can be useful, but they should not define project policy on their
own. If something here conflicts with the Lean source, `CONTRIBUTING.md`, or the
workflow docs, the main repository wins.

New validation runs and generated artifacts should stay local by default. Commit
only short summaries or artifacts that are intentionally useful to future
contributors.
