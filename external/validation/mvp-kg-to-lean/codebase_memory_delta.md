# Codebase-Memory Delta

Run id: `mvp-kg-to-lean`

## MCP Result

The codebase-memory MCP interface was available after re-indexing.

Indexing observations:

- Initial project list was empty.
- A first fast index reported a project name, but follow-up graph queries could not find it.
- A second moderate index succeeded with project `C-Users-User-research-HighDimProb`.
- The graph reported 729 nodes and 1889 edges before validation artifacts were added.
- Persistent artifact written: `.codebase-memory/graph.db.zst`.

Because graph extraction did not reliably expose all Lean theorem declarations, this delta also records targeted local declaration-search fallback evidence.

## Declarations Touched

No Lean declarations were changed.

Declarations observed and linked to the MVP:

- `markov_inequality_nonneg`
- `markov_inequality`
- `markov_inequality_ae_nonneg`
- `chebyshev_inequality`
- `chebyshev_inequality_prob`
- `Psi2Bound`
- `SubGaussianTail`
- `lintegral_exp_sq_div_le_two_of_psi2Bound`
- `subGaussianTail_of_psi2Bound`

## Files Touched

Validation artifacts added under:

- `external/validation/mvp-kg-to-lean/run_config.md`
- `external/validation/mvp-kg-to-lean/selected_nodes.json`
- `external/validation/mvp-kg-to-lean/run_log.md`
- `external/validation/mvp-kg-to-lean/mathlib_reuse_report.md`
- `external/validation/mvp-kg-to-lean/kg_corrections.jsonl`
- `external/validation/mvp-kg-to-lean/codebase_memory_delta.md`
- `external/validation/mvp-kg-to-lean/workflow_delta.md`
- `external/validation/mvp-kg-to-lean/final_report.md`

Codebase-memory artifact:

- `.codebase-memory/graph.db.zst`

No Lean source files were modified.

## Theorem Status

| KG concept | Lean declaration | Status |
|---|---|---|
| `concept:basic-concentration` | `markov_inequality_nonneg` | proven |
| `concept:basic-concentration` | `markov_inequality` | proven wrapper |
| `concept:basic-concentration` | `markov_inequality_ae_nonneg` | proven |
| `concept:basic-concentration` | `chebyshev_inequality` | proven |
| `concept:basic-concentration` | `chebyshev_inequality_prob` | proven wrapper |
| `concept:subgaussian-subexponential` + `concept:moments-lp-orlicz` | `subGaussianTail_of_psi2Bound` | proven |

## Mathlib Dependencies

- `MeasureTheory.meas_ge_le_lintegral_div`
- `ProbabilityTheory.meas_ge_le_variance_div_sq`
- `ProbabilityTheory.HasSubgaussianMGF`
- `ProbabilityTheory.HasSubgaussianMGF.const_mul`
- `ProbabilityTheory.HasSubgaussianMGF.sum_of_iIndepFun`

## HighDimProb Dependencies

- `RealRandomVariable`
- `IsRealRandomVariable`
- `IntegrableRealRandomVariable`
- `MemLpRealRandomVariable`
- `expect`
- `upperTailProb`
- `absTailProb`
- `centered`
- `variance`
- `Psi2Bound`
- `SubGaussianTail`

## Branch Membership

- Markov and Chebyshev live in the experimental `HighDimProb.Concentration` branch.
- `Psi2Bound` lives in the scalar Orlicz layer.
- `SubGaussianTail` lives in the scalar subGaussian predicate layer.
- `subGaussianTail_of_psi2Bound` lives in `HighDimProb.Concentration.OrliczToTail`.

## Proof And Blocker Notes

- No new proof blockers were introduced.
- No Lean proof obligations were opened in this run.
- Existing proof blockers remain outside this MVP: full real-exponent `SubGaussianMoment`, reverse/source MGF links, finite-gauge variants, and canonical subGaussian equivalence packaging.

## KG Linkage

- Markov inequality maps to `concept:basic-concentration`.
- Chebyshev inequality maps to `concept:basic-concentration`.
- Orlicz psi2 bound implies subGaussian tail maps to `concept:subgaussian-subexponential`, with `concept:moments-lp-orlicz` as the Orlicz support concept.

## Post-Run Sync

Completed after verification:

- re-indexed repository with project `C-Users-User-research-HighDimProb`;
- final reported graph count: 729 nodes and 1889 edges;
- persistent artifact refreshed at `.codebase-memory/graph.db.zst`;
- added an ADR-style memory note through `manage_adr(mode="update")`.

The graph node/edge count did not change after adding markdown validation artifacts, which is acceptable for this run because no Lean declarations changed.
