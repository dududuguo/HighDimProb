# MVP KG-to-Lean Run Log

## 2026-06-03

Started minimal validation run for the selected cluster:

- Markov inequality
- Chebyshev inequality
- Orlicz psi2 bound implies subGaussian tail

## Repository Status Read

Read the required status and structure documents:

- `docs/Status.md`
- `docs/TheoremAtlas.md`
- `docs/ScalarImplicationGraph.md`
- `docs/BranchRegistry.md`
- `docs/ModuleTree.md`
- `docs/Workflow.md`

Key status finding:

- Markov inequality is already proven as `markov_inequality_nonneg`, `markov_inequality`, and `markov_inequality_ae_nonneg`.
- Chebyshev inequality is already proven as `chebyshev_inequality` and `chebyshev_inequality_prob`.
- The psi2 Orlicz-to-tail implication is already proven as `subGaussianTail_of_psi2Bound`.
- Existing focused API tests already check these declarations.

## Theory Roadmap Read

Read or searched the required roadmap files:

- `external/theory-roadmap/roadmap/theory_kg.json`
- `external/theory-roadmap/roadmap/lean_toposort.json`
- `external/theory-roadmap/roadmap/roadmap_digest.md`
- `external/theory-roadmap/roadmap/KnowledgeGraph.md`

The KG is concept-level for this cluster. The exact theorem-level nodes requested by the MVP were not present as distinct KG nodes.

## Codebase-Memory

Initial `list_projects` returned no indexed project. A first fast indexing attempt reported success but was not visible to follow-up queries. A second moderate indexing pass reported:

- project: `C-Users-User-research-HighDimProb`
- nodes: 729
- edges: 1889
- artifact: `.codebase-memory/graph.db.zst`

After the second index, `list_projects` and `search_graph` worked. Exact Lean theorem extraction was still incomplete for some theorem declarations, so targeted local declaration search was used as a fallback and recorded in `codebase_memory_delta.md`.

## Mathlib Reuse Search

Searched Mathlib locally under `.lake/packages/mathlib/Mathlib`.

Mathlib reuse evidence:

- Markov wrapper reuses `MeasureTheory.meas_ge_le_lintegral_div`.
- Chebyshev wrapper reuses `ProbabilityTheory.meas_ge_le_variance_div_sq`.
- Mathlib has `ProbabilityTheory.HasSubgaussianMGF` and finite independent sum MGF lemmas, but no direct Mathlib theorem for the HighDimProb `Psi2Bound -> SubGaussianTail` predicate implication. The HighDimProb proof uses Mathlib's lintegral Markov inequality and project-specific `Psi2Bound` / `SubGaussianTail` wrappers.

## Source Validation

Compared the selected KG concepts with source markdown excerpts:

- `High-Dimensional_Probability.md:950-953` states Markov's inequality.
- `High-Dimensional_Probability.md:972-975` states Chebyshev's inequality.
- `High-Dimensional_Probability.md:1821-1839` states equivalent subGaussian properties including tail and square-exponential MGF.
- `High-Dimensional_Probability.md:1873-1877` derives tail decay from square-exponential control via Markov.
- `High-Dimensional_Probability.md:1919-1922` defines the psi2 norm via square-exponential control.
- `High-Dimensional_Probability.md:1947-1953` records subGaussian bounds.

No correction record was needed. The KG was broad but not false for this MVP.

## Lean Action

No Lean file changes were made. The selected concepts are already proven and already tested, so duplicating wrappers would be counter to the Mathlib-first and no-duplication gates.

## Verification

Completed:

- `lake build` passed with exit code 0.
- `lake test` passed with exit code 0.

## Post-Run Codebase-Memory Sync

Re-indexed repository after validation artifacts were present.

Result:

- project: `C-Users-User-research-HighDimProb`
- status: indexed
- nodes: 729
- edges: 1889
- persistent artifact: `.codebase-memory/graph.db.zst`

Added an ADR-style memory note through `manage_adr(mode="update")` summarizing the selected KG concepts, Lean mappings, verification result, and reuse/source-validation lesson.
