# Integration: Codebase Memory Graph

How the multi-agent system queries and updates the codebase knowledge graph
at `external/codebase-memory/HighDimProb.db`.

## Query Patterns

### 1. Dependency Resolution (DependencyResolver)

Check if a dependency is already formalized:

```
search_graph(
  project="workspace-projects-HighDimProb",
  name_pattern="IsSubGaussian",
  label="Function"
)
→ if result_count > 0: dependency is INTEGRATED
```

### 2. Name Collision Detection (IntegrationReviewer)

Before integrating a new declaration, check for name conflicts:

```
search_graph(
  project="workspace-projects-HighDimProb",
  name_pattern="{new_declaration_name}",
  label="Function"
)
→ if result_count > 0: potential collision
   → compare statements via get_code_snippet
```

### 3. Style Conformance (StyleReviewer)

Sample existing declarations to infer naming conventions:

```
search_graph(
  project="workspace-projects-HighDimProb",
  label="Function",
  is_exported=true,
  limit=20
)
→ analyze naming patterns: UpperCamelCase, prefix conventions, etc.
```

### 4. Import Resolution (DependencyReviewer)

Find which module defines a used symbol:

```
query_graph(
  project="workspace-projects-HighDimProb",
  query="MATCH (f:Function {name: 'chernoffBound'})-[r:DEFINES]-(m:Module) RETURN m.name"
)
→ "HighDimProb.Concentration.Basic"
```

### 5. Proof Reuse (IntegrationReviewer)

Find existing lemmas that could be used instead of re-proving:

```
trace_path(
  project="workspace-projects-HighDimProb",
  function_name="{goal_conclusion}",
  direction="inbound",
  depth=2
)
→ if callers exist: someone already proved this
   if no callers: check semantically_related nodes
```

### 6. Impact Analysis (QualityGate)

Before integrating, check what existing code depends on the new module's
dependencies (to ensure no breakage):

```
trace_path(
  project="workspace-projects-HighDimProb",
  function_name="{dependency_name}",
  direction="inbound",
  depth=3
)
→ all callers need to still compile after the change
```

### 7. Coverage Gap Detection (CoverageReviewer)

Cross-reference the extraction manifest with the codebase graph:

```
For each unit in manifest:
  search_graph(name_pattern=unit.statement_hash_derived_name)

Missing units → coverage gaps
Present units → already formalized (skip or compare)
```

### 8. Architecture Conformance

Check that the new module's layer matches the architecture:

```
get_architecture(project="workspace-projects-HighDimProb", aspects=["layers"])
→ new module should be in the expected layer (entry, core, internal)
```

---

## Update Patterns

After a concept is `INTEGRATED`, the codebase graph must be re-indexed:

### Re-Index Trigger

```yaml
post_integration:
  - action: index_repository
    project: "workspace-projects-HighDimProb"
    path: "/workspace/projects/HighDimProb"
    reason: "New module {lean_module} integrated"
```

This ensures the knowledge graph reflects the updated codebase.

### Graph Mutation Tracking

The system maintains a log of graph changes:

```yaml
graph_mutation_log:
  - timestamp: "2026-06-03T..."
    concept: "subgaussian-subexponential"
    action: reindex
    before:
      total_nodes: 1209
      total_edges: 2721
    after:
      total_nodes: 1245
      total_edges: 2810
    delta:
      new_nodes: 36
      new_edges: 89
```

---

## Bidirectional Graph Enrichment

The MAS can also enrich the codebase graph with metadata:

### Adding Theory Links

```
manage_adr(
  mode="update",
  entries=[{
    "concept": "subgaussian-subexponential",
    "source_document": "Concentration_inequalities.md",
    "source_section": "2.1",
    "lean_module": "HighDimProb.Concentration.SubGaussian",
    "status": "formalized"
  }]
)
```

This creates a traceable link: **source theorem → Lean4 formalization**.

### Cross-Referencing

For each formalized theorem, add a comment in the Lean code pointing
back to the source:

```lean4
/--
Theorem 2.1 from [Concentration Inequalities].
Source: `external/theory-roadmap/sources/Concentration_inequalities.md:5145`

SubGaussian tail bound: P(|X| ≥ t) ≤ 2 exp(-t²/(2σ²))
-/
theorem subGaussian_tail_bound ...
```

The codebase-memory graph can then search for these annotations:

```
search_code(
  project="workspace-projects-HighDimProb",
  pattern="Concentration_inequalities.md"
)
→ all formalizations derived from that source
```

---

## Consistency Validation

Periodically validate that the codebase graph and theory roadmap are consistent:

```yaml
consistency_check:
  frequency: "after every 5 integrations"
  checks:
    - all_integrated_concepts_have_graph_nodes: true
    - no_orphan_nodes: true  # no graph nodes without a theory roadmap concept
    - import_closure_valid: true  # no broken import chains
    - layer_assignment_consistent: true  # architecture layers match design
```
