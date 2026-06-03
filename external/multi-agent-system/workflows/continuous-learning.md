# Workflow: Continuous Learning

This workflow runs **after** each successful integration and periodically
as a batch process. It is the mechanism by which the system improves over time.

Learning is advisory. It cannot relax `docs/Workflow.md`, skip mandatory
reviews, skip documentation tracking, or replace `lake build` / `lake test`.

## Trigger

- Post-integration: after any concept reaches `INTEGRATED`
- Periodic: every 5 concepts, or every 24 hours of wall-clock time

## Flow

```
┌──────────────────────────────────────────────────────────────┐
│ 1. COLLECT                                                    │
│    Gather all artifacts from the just-completed concept:     │
│      - Extraction manifest                                   │
│      - Mathlib reuse report                                  │
│      - Existing declaration search notes                     │
│      - Source validation report                              │
│      - Action classification manifest                        │
│      - KG corrections or quarantines                         │
│      - Generated .lean file                                  │
│      - Compile history (all attempts)                        │
│      - Fix history (all fixes applied)                       │
│      - Review results (all dimensions)                       │
│      - Proof completion history                              │
│      - Transition timing metrics                             │
└────────────────────────────┬─────────────────────────────────┘
                             │
                             ▼
┌──────────────────────────────────────────────────────────────┐
│ 2. PATTERN EXTRACTION (PatternLearner)                       │
│                                                              │
│  2a. Proof Pattern Extraction                                │
│      Scan successful proofs for recurring structures:        │
│        - `apply` → `linarith` chains                         │
│        - `calc` blocks                                       │
│        - Induction patterns                                  │
│        - Case analysis patterns                              │
│      Abstract concrete symbols → parameterized patterns      │
│      Check against KB for duplicates                         │
│      Store new patterns in KB                                │
│                                                              │
│  2b. Definition Pattern Extraction                           │
│      Scan definitions for typeclass recipes:                 │
│        - existing subGaussian predicate forms → usage rules  │
│        - `HasMGF` → structure + proof                        │
│      Generalize to parameterized templates                   │
│                                                              │
│  2c. Fix Strategy Validation                                 │
│      For each fix in fix_history:                            │
│        - If strategy worked → increment success_count        │
│        - If strategy failed → decrement, re-evaluate         │
│        - If success_rate drops below 0.5 → deprecate strategy│
│                                                              │
│  2d. Anti-Pattern Extraction                                 │
│      Scan failed attempts for recurring failure patterns:    │
│        - "always fails when... [condition]"                  │
│      Tag patterns with confidence                            │
│      Store as anti-patterns (negative examples)              │
│                                                              │
│  2e. Reuse/Source Gate Learning                              │
│      Compare action classification with final integration:   │
│        - existing mapping reused                             │
│        - wrapper/test/docs action sufficient                 │
│        - source correction or quarantine needed              │
│      Store successful gate patterns without relaxing reviews │
└────────────────────────────┬─────────────────────────────────┘
                             │
                             ▼
┌──────────────────────────────────────────────────────────────┐
│ 3. FSM EVALUATION (FSMUpdater)                               │
│                                                              │
│  3a. Transition Metrics Update                                │
│      Update per-transition statistics:                       │
│        - duration distribution (mean, median, p95)           │
│        - success_rate                                        │
│        - escalation_rate                                     │
│                                                              │
│  3b. Bottleneck Detection                                    │
│      Rank states by median duration × frequency              │
│      Identify top bottleneck                                  │
│      if bottleneck > threshold → propose split/insert        │
│                                                              │
│  3c. Escalation Hotspot Detection                            │
│      Rank transitions by escalation_rate                     │
│      if rate > 0.4 → propose new substate or fix strategy     │
│                                                              │
│  3d. Fast-Path Detection                                     │
│      Rank transitions by first-attempt success rate          │
│      if rate > 0.9 for ≥5 consecutive → preload context      │
│      Future concepts still pass all mandatory repo gates      │
│                                                              │
│  3e. Generate Growth Proposals                               │
│      Bundle proposals with evidence                          │
│      Submit to Orchestrator for review                       │
└────────────────────────────┬─────────────────────────────────┘
                             │
                             ▼
┌──────────────────────────────────────────────────────────────┐
│ 4. KB MAINTENANCE                                            │
│                                                              │
│  4a. Prune Stale Entries                                     │
│      Patterns unused for >20 concepts → deprecate            │
│      Templates with success_rate < 0.3 → review/deprecate    │
│                                                              │
│  4b. Merge Similar Patterns                                  │
│      Cluster patterns by embedding similarity                │
│      If two patterns have cosine_sim > 0.9 → merge           │
│      Keep the one with higher success_rate                   │
│                                                              │
│  4c. Re-rank Strategies                                      │
│      For each error class, re-order fix strategies by        │
│      success_rate × speed                                    │
└──────────────────────────────────────────────────────────────┘
```

## Post-Integration Hook

```yaml
post_integration:
  on: INTEGRATED
  actions:
    - pattern_learner.extract_patterns(concept_id)
    - fsm_updater.update_metrics(concept_id)
    - knowledge_base.prune_check()
    - orchestator.unblock_dependents(concept_id)
    - verify_workflow_artifacts(
        docs_status_updated=true,
        mathlib_reuse_report_present=true,
        source_validation_report_present=true,
        action_manifest_present=true,
        kg_corrections_checked=true,
        lake_build_passed=true,
        lake_test_passed=true
      )
```

## Periodic Batch

```yaml
periodic_batch:
  interval: "every 5 concepts OR every 24 hours"
  actions:
    - fsm_updater.full_evaluation()
    - knowledge_base.deep_merge()
    - fsm_updater.generate_growth_proposals()
    - orchestator.review_growth_proposals()
```

## Learning Metrics

| Metric | Initial | Target | Measures |
|--------|---------|--------|----------|
| First-attempt compile rate | 0.30 | 0.70 | Translator + Template quality |
| Fix success rate | 0.60 | 0.90 | Fix strategy quality |
| Review pass rate (first cycle) | 0.40 | 0.80 | Overall translation fidelity |
| Proof auto-completion rate | 0.20 | 0.60 | ProofCompleter + pattern quality |
| Escalation rate | 0.50 | 0.15 | System maturity |
| Time per concept | 3h | 45m | Pipeline efficiency |

These targets represent a mature system after processing ~50 concepts.
