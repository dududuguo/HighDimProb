# Agent Instructions

<!-- lean-local-search-mcp:start -->
# Lean Local Search MCP

Use `lean-local-search` MCP before broad text search for Lean/mathlib/HighDimProb API discovery.

## Priority Order

1. `index_repository` / `index_status` after switching repos or meaningful edits.
2. `search_theorems` for theorem and lemma discovery.
3. `search_graph` for non-theorem declarations and module-level structure.
4. `theorem_card`, `get_context`, and `get_code_snippet` before editing a proof leaf.
5. `proof_probe` for import, name, and typeclass checks before adding source code.
6. `consumer_fit` and `cross_repo_lookup` when matching provider APIs to HighDimProb consumers.
7. Fall back to `rg` for docs, configs, string literals, and MCP coverage gaps.

## Validation Rule

Lean MCP helps find and probe APIs; it does not validate proofs. Every source change still needs the narrow `lake build` target first, then broader `lake build` / `lake test` when appropriate.

Do not rely on `.codebase-memory`; it is intentionally retired for this repository.
<!-- lean-local-search-mcp:end -->

## Append-Only Judge

Files already recorded in `.github/judge-lock.json` are permanent public
regressions. Never modify, delete, rename, move, or re-hash one. Preserve an old
public API with an alias when a newer name is introduced so its existing Judge
case continues to compile.

Add each new Judge leaf as a new `.lean` file under `HighDimProbJudge/`. After
the file is complete, register it with:

```bash
python3 scripts/judge_append_only_check.py --add HighDimProbJudge/<Area>/<Leaf>Use.lean
```

The command adds the immutable hash and aggregate import. Do not edit existing
manifest entries by hand. Run the policy checker, `lake build HighDimProbJudge`,
and `lake test` before committing.
