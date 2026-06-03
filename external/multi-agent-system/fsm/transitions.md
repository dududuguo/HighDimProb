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
VERIFYING ──[no sorry]──▶ VERIFIED
VERIFYING ──[sorry found]──▶ PROOF_GAP
VERIFYING ──[timeout]──▶ STUCK
PROOF_GAP ──[gap filled]──▶ VERIFYING
PROOF_GAP ──[cycles exhausted]──▶ NEEDS_HUMAN
VERIFIED ──[dispatch]──▶ INTEGRATING
INTEGRATING ──[merged]──▶ INTEGRATED
INTEGRATING ──[merge conflict]──▶ STUCK
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
  - imports_valid: all(import is resolvable in lakefile)
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
  - no_sorry: grep -c "sorry" {module} == 0
  - no_admit: grep -c "admit" {module} == 0
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
