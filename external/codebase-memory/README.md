# Code Knowledge Graph

This folder contains generated codebase-memory artifacts for HighDimProb.

They are useful for maintainers and agent workflows, but they are not required
to build or use the Lean package.

## Contents

- `HighDimProb.db`: SQLite knowledge graph database.
- `metadata.json`: graph statistics and schema summary.
- `graphviz/`: rendered or renderable graph views.

The compressed team artifact is also kept at `.codebase-memory/graph.db.zst`.

## Boundary

Generated graph files can be stale. When there is a conflict, trust the Lean
source and the public docs, not this directory.

## Regeneration

The helper scripts live in `.github/scripts/`:

```bash
python .github/scripts/codebase_memory_update.py --repo . --cache-dir .codebase-memory/cache --mode full
python .github/scripts/codebase_memory_graphviz.py --render
```

If Graphviz is not installed, omit `--render`; the script can still write DOT
files.
