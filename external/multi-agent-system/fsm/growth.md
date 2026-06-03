# FSM Growth Mechanism

The FSM is **not static**. It evolves as the system accumulates experience
formalizing concepts. This document defines how growth happens.

## Why Growth?

1. **Repetitive failure patterns** reveal missing states or transitions
2. **Successful shortcuts** suggest transition optimizations
3. **New error classes** discovered during formalization need new recovery paths
4. **Project conventions** solidify over time and need encoding as guards

Growth is advisory in this repository. It must not weaken the main workflow:
`docs/Status.md` and `docs/Workflow.md` are still read first, docs tracking is
still updated, and `lake build` plus `lake test` remain mandatory.

## Growth Triggers

### 1. Repeated State Pairs

When the same `(from_state, error_type, to_state)` tuple is observed ≥ N times:

```
TRIGGER: (COMPILE_ERROR, "type_mismatch", FIXING) × 5
ACTION:  Split COMPILE_ERROR → TYPE_MISMATCH_ERROR + OTHER_COMPILE_ERROR
         Each subtype gets a specialized fixer agent.
```

### 2. High-Latency States

When a state's median duration exceeds a threshold:

```
TRIGGER: median_duration(TRANSLATING) > 45 min for 10 consecutive concepts
ACTION:  Insert PRE_TRANSLATING state for template pre-selection
         or split TRANSLATING into HEAD_TRANSLATE + BODY_TRANSLATE
```

### 3. Frequent Escalation

When a transition pair frequently escalates to NEEDS_HUMAN:

```
TRIGGER: (PROOF_GAP → NEEDS_HUMAN) rate > 40%
ACTION:  Add SPECIALIZED_PROOF state with domain-specific proof strategies
         or insert PROOF_DECOMPOSITION state before PROOF_GAP
```

### 4. New Error Class Discovery

When an unclassified error appears:

```
TRIGGER: COMPILE_ERROR with unknown error_type
ACTION:  Classify error, add to KNOWN_ERROR_TYPES
         Create specialized FIXING substate if error is recurrent
```

### 5. Successful Pattern Emergence

When a transition path dominates for similar concepts:

```
TRIGGER: (TRANSLATING → TRANSLATED → COMPILING → COMPILED) on first attempt
         for 3+ concepts of same depth
ACTION:  Mark path as "fast track" for that depth
         Preload known context and candidate lemmas
         Do not skip review, docs, build, or test gates
```

## Growth Operations

### split_state(state, substates, discriminator)

Split a monolithic state into specialized substates:

```yaml
split_state:
  parent: REVIEWING
  substates:
    - MATH_REVIEWING      # mathematical correctness
    - STYLE_REVIEWING     # naming and conventions
    - COVERAGE_REVIEWING  # source completeness
    - DEPENDENCY_REVIEWING # import hygiene
    - INTEGRATION_REVIEWING # codebase consistency
  discriminator: review_dimension
  concurrency: parallel  # all substates run concurrently
```

### merge_states(state_a, state_b, new_state)

Merge states that are rarely distinct in practice:

```yaml
merge_states:
  inputs: [TRANSLATED, COMPILING]
  output: TRANSLATE_AND_COMPILE
  reason: "Translator now runs syntax check inline; separate COMPILING is overhead"
```

### insert_state(before, after, new_state)

Insert a new state between two existing states:

```yaml
insert_state:
  before: EXTRACTED
  after: TRANSLATING
  new_state: TEMPLATE_MATCHING
  reason: "Template pre-selection reduces translation time by 40%"
  guard: len(known_templates) > 0
```

### add_transition(from, to, guard_condition)

Add a new allowable transition:

```yaml
add_transition:
  from: COMPILE_ERROR
  to: TRANSLATING
  guard: error_type == "structural_mismatch"  # needs re-translation, not fix
  reason: "Some errors require re-thinking the translation, not patching"
```

### deprecate_path(from, to)

Remove a transition that never succeeds:

```yaml
deprecate_path:
  from: STUCK
  to: QUEUED
  condition: consecutive_failures >= 5
  replacement: STUCK → NEEDS_HUMAN
```

## Growth Log

All growth operations are logged to `fsm/growth_log.json`:

```json
{
  "version": 1,
  "operations": [
    {
      "timestamp": "2026-06-03T00:00:00Z",
      "operation": "insert_state",
      "params": {
        "before": "EXTRACTED",
        "after": "TRANSLATING",
        "new_state": "TEMPLATE_MATCHING"
      },
      "trigger": {
        "type": "high_latency",
        "state": "TRANSLATING",
        "median_duration_ms": 3000000,
        "threshold_ms": 2700000,
        "sample_size": 10
      },
      "approved_by": "Orchestrator",
      "status": "active"
    }
  ]
}
```

## Manual vs Automatic Growth

| Operation | Automatic? | Requires Approval? |
|-----------|------------|---------------------|
| `split_state` | Semi-auto | Yes (human reviews split) |
| `merge_states` | No | Yes |
| `insert_state` | Semi-auto | Yes (structural change) |
| `add_transition` | No | Yes |
| `deprecate_path` | No | Yes |

## Growth Constraints

1. **Max states**: ≤ 50 (prevent FSM bloat)
2. **Max depth**: ≤ 10 transitions from QUEUED to INTEGRATED
3. **Convergence**: After each growth operation, run full repository checks and
   validate on focused examples
4. **Reversibility**: Every growth operation must be reversible (store previous FSM version)
5. **No silent removal**: States can be deprecated but never deleted without human sign-off
6. **No workflow weakening**: Growth cannot remove mandatory status/doc updates,
   reviews, `lake build`, or `lake test`
