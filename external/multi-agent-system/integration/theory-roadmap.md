# Integration: Theory Roadmap

How the multi-agent system consumes and updates the theory roadmap
at `external/theory-roadmap/`.

## Consuming the Roadmap

### Input: Topological Sort

The Orchestrator reads `roadmap/lean_toposort.json` to build the work queue:

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
| `lean_module` | Target `.lean` file path |
| `depth` | Scheduling priority within same layer; fast-path eligibility |
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
  lean_module: "HighDimProb.H.Concentration.SubGaussian"
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

## Updating the Roadmap

After a concept reaches `INTEGRATED`, the Orchestrator writes back status:

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

This status file enables:
1. **Resume**: If the system restarts, it can pick up where it left off
2. **Visualization**: The theory roadmap can render progress badges
3. **Gap analysis**: Compare planned vs actual formalization coverage

### Bi-Directional Sync

```
theory-roadmap/roadmap/lean_toposort.json  ──read──▶  Orchestrator work queue
                                                         │
                                                         │ after integration
                                                         ▼
theory-roadmap/roadmap/formalization_status.json  ◀──write──  Orchestrator
```
