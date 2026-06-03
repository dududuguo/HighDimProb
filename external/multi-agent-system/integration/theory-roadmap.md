# Integration: Theory Roadmap

How the multi-agent system consumes and updates the theory roadmap
at `external/theory-roadmap/`.

`external/theory-roadmap/` is a Git submodule. The MAS may read it to identify
future concepts, but it must not write into it automatically. Status updates
for the main repository go through the main tracking docs first:
`docs/Status.md`, `docs/TermMap.md`, `docs/BookProgress.md`,
`docs/AbstractionLog.md`, and `docs/TODO.md`.

## Consuming the Roadmap

### Input: Topological Sort

The Orchestrator may read `roadmap/lean_toposort.json` to build a candidate
work queue:

```yaml
# Excerpt from lean_toposort.json
order:
  - index: 1
    concept: "sets-topology-metric"
    lean_module: "HighDimProb.H.Foundations.TopologyMetric"
    depth: 0
    dependencies: []
  - index: 2
    concept: "matrix-linear-algebra"
    lean_module: "HighDimProb.H.RandomMatrix.LinearAlgebra"
    depth: 1
    dependencies: ["sets-topology-metric"]
  ...
```

### Mapping to Agent Tasks

| Toposort Field | MAS Usage |
|----------------|-----------|
| `concept` | Unique ID for tracking through the FSM |
| `lean_module` | Theory-side target label; map to an existing or approved HighDimProb module before editing |
| `depth` | Scheduling priority within same layer; never a reason to skip workflow gates |
| `dependencies` | `DependencyResolver.check()` input |
| `title` | Human-readable label for logging |

### Source Document Resolution

When a concept needs extraction, the Orchestrator resolves source documents:

1. Query `roadmap/roadmap_digest.md` for the concept → document mapping
2. Read keyword hits to identify the most relevant source document sections
3. Pass document paths and byte ranges to the ConceptExtractor

### Example: Concept "subgaussian-subexponential"

```yaml
resolution:
  concept: "subgaussian-subexponential"
  roadmap_target: "HighDimProb.H.Concentration.SubGaussian"
  candidate_modules:
    - "HighDimProb.SubGaussian"
    - "HighDimProb.Concentration.MGF"
    - "HighDimProb.Concentration.Implications"
  sources:
    - path: "external/theory-roadmap/sources/Concentration_inequalities.md"
      relevance: high
      keyword_hits: 985
      sections: ["2.1 SubGaussian tails", "2.2 SubExponential tails"]
    - path: "external/theory-roadmap/sources/High-Dimensional_Probability.md"
      relevance: high
      keyword_hits: 985
      sections: ["2.5 SubGaussian random variables"]
  dependencies_integrated:
    - "basic-concentration"  # verified via codebase-memory
```

---

## Reporting Roadmap Progress

After a concept reaches `INTEGRATED`, the Orchestrator first updates the main
repository docs required by `docs/Workflow.md`. A roadmap status update can be
prepared as a separate patch for the submodule, but it is not written
automatically.

### Status File: `roadmap/formalization_status.json`

```json
{
  "updated_at": "2026-06-03T...",
  "concepts": {
    "sets-topology-metric": {
      "status": "integrated",
      "integrated_at": "2026-06-03T10:00:00Z",
      "lean_file": "HighDimProb/Foundations/TopologyMetric.lean",
      "declarations_count": 45,
      "proof_gaps": 0,
      "codebase_graph_nodes": 87
    },
    "matrix-linear-algebra": {
      "status": "in_progress",
      "fsm_state": "TRANSLATING",
      "started_at": "2026-06-03T11:00:00Z"
    },
    "measure-probability": {
      "status": "blocked",
      "blocked_by": ["sets-topology-metric"]
    }
  }
}
```

If a reviewed submodule patch later creates this status file, it enables:
1. **Resume**: If the system restarts, it can pick up where it left off
2. **Visualization**: The theory roadmap can render progress badges
3. **Gap analysis**: Compare planned vs actual formalization coverage

### Bi-Directional Sync

```
theory-roadmap/roadmap/lean_toposort.json  --read-->  Orchestrator work queue
                                                        |
                                                        | after integration,
                                                        | prepare reviewed patch only
                                                        v
theory-roadmap/roadmap/formalization_status.json  <--reviewed patch--  Orchestrator
```

For the current repository, the required write path is the main documentation
set, especially `docs/Status.md`; the submodule remains clean unless the user
explicitly requests and reviews a submodule update.
