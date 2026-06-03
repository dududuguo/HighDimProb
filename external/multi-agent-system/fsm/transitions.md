# Finite State Machine — Transition Rules

## Transition Table

```
QUEUED ──[assign]──▶ EXTRACTING
EXTRACTING ──[manifest ready]──▶ EXTRACTED
EXTRACTING ──[timeout]──▶ STUCK
EXTRACTED ──[dispatch]──▶ TRANSLATING
TRANSLATING ──[file(s) written]──▶ TRANSLATED
TRANSLATING ──[timeout / empty output]──▶ STUCK
TRANSLATED ──[dispatch]──▶ COMPILING
COMPILING ──[build ok]──▶ COMPILED
COMPILING ──[build fail]──▶ COMPILE_ERROR
COMPILING ──[timeout]──▶ STUCK
COMPILE_ERROR ──[error classified]──▶ FIXING
COMPILE_ERROR ──[unclassified error]──▶ STUCK
FIXING ──[fix applied]──▶ COMPILING
FIXING ──[retries exhausted]──▶ NEEDS_HUMAN
COMPILED ──[dispatch reviewers]──▶ REVIEWING
REVIEWING ──[all approved]──▶ APPROVED
REVIEWING ──[changes requested]──▶ CHANGES_REQUESTED
REVIEWING ──[timeout / partial]──▶ NEEDS_HUMAN
CHANGES_REQUESTED ──[changes applied]──▶ TRANSLATING
CHANGES_REQUESTED ──[cycles exhausted]──▶ NEEDS_HUMAN
APPROVED ──[dispatch]──▶ VERIFYING
VERIFYING ──[policy + proof checks pass]──▶ VERIFIED
VERIFYING ──[placeholder / incomplete theorem / policy breach]──▶ PROOF_GAP
VERIFYING ──[timeout]──▶ STUCK
PROOF_GAP ──[complete proof or downgraded statement]──▶ VERIFYING
PROOF_GAP ──[cycles exhausted]──▶ NEEDS_HUMAN
VERIFIED ──[dispatch]──▶ INTEGRATING
INTEGRATING ──[build+test+docs accepted]──▶ INTEGRATED
INTEGRATING ──[integration conflict]──▶ STUCK
INTEGRATED ──[pattern extraction]──▶ PATTERN_EXTRACTED
PATTERN_EXTRACTED ──[done]──▶ (terminal)

BLOCKED ──[deps resolved]──▶ QUEUED
DEFERRED ──[re-queued]──▶ QUEUED
STUCK ──[diagnosed + fixed]──▶ QUEUED (retry) / NEEDS_HUMAN (escalate)
NEEDS_HUMAN ──[human resolved]──▶ QUEUED (retry) / DEFERRED
SKIPPED ──[re-queued]──▶ QUEUED
```

## Guard Conditions

### EXTRACTING → EXTRACTED
```yaml
guard:
  - manifest_non_empty: count(units) > 0
  - source_locations_valid: all(unit.source_ref is resolvable)
  - no_duplicates: len(units) == len(set(unit.statement_hash for unit in units))
```

### TRANSLATING → TRANSLATED
```yaml
guard:
  - files_exist: all(file.path.exists() for file in output_files)
  - syntax_check: run `lean --syntax-only` → exit 0
  - imports_valid: all(imports resolve through the current Lake module graph)
```

### COMPILING → COMPILED
```yaml
guard:
  - build_ok: lake build {module} → exit 0
  - no_warnings_policy: warning_count <= max_warnings
```

### COMPILE_ERROR → FIXING
```yaml
guard:
  - error_classified: error_type in KNOWN_ERROR_TYPES
  - confidence >= 0.6: classifier.confidence >= threshold
  - retries_remaining: fix_attempts < max_retries
```

### REVIEWING → APPROVED
```yaml
guard:
  - all_dimensions_pass:
      math_review: approved
      style_review: approved
      coverage_review: approved
      dependency_review: approved
      integration_review: approved
```

### VERIFYING → VERIFIED
```yaml
guard:
  - no_sorry: no `sorry` token in Lean sources
  - no_admit: no `admit` token in Lean sources
  - no_axiom: no new axioms
  - no_fake_theorem: unproved book results are not declared as theorem/lemma
  - workflow_docs_checked: docs/Workflow.md and docs/Status.md were read
  - one_cluster_only: change stays within the selected concept cluster
  - mathlib_first: existing Mathlib and HighDimProb APIs were searched first
```

### INTEGRATING → INTEGRATED
```yaml
guard:
  - status_updated: docs/Status.md updated with stage/result/next safe task
  - docs_updated: relevant TermMap/BookProgress/AbstractionLog/TODO updates made or explicitly justified as unnecessary
  - tests_added: public declarations have focused #check/example tests
  - build_ok: lake build -> exit 0
  - test_ok: lake test -> exit 0
  - stable_boundary_ok: stable root imports changed only after audit
  - submodule_clean: external submodules are not dirtied unless explicitly approved
```

### Any state → NEEDS_HUMAN
```yaml
guard:
  - max_retries_exhausted OR confidence_below_threshold(0.3) OR unclassified_error
```

## Transition Hooks

Hooks execute at transition boundaries for logging, learning, and notification:

| Hook point | Action |
|------------|--------|
| `on_enter(state)` | Log timestamp, notify Orchestrator, update progress tracker |
| `on_exit(state)` | Log duration, record metrics, feed PatternLearner if successful |
| `on_error(state, error)` | Log error, increment retry counter, notify FSMUpdater |
| `on_escalate(state, reason)` | Log reason, notify human channel, save context for handoff |
| `on_cycle(state)` | Increment cycle counter, check against max cycles |

## Metrics Collected Per Transition

```yaml
transition_metrics:
  - from_state
  - to_state
  - duration_ms
  - agent_used
  - retry_count
  - error_type (if any)
  - concept_id
  - depth (from toposort)
  - source_document
```

These metrics feed the FSMUpdater for growth decisions.
