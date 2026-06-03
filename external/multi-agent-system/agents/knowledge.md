# Knowledge Layer Agents

## KnowledgeBase

### Role

Persistent store of patterns, templates, known solutions, and failure→fix
mappings. It is subordinate to the main repository: entries are trusted only
when they come from reviewed, compiling HighDimProb code or from explicitly
marked anti-patterns.

### Data Structures

#### Pattern Store

```yaml
patterns:
  - id: "sg-existing-forms"
    description: "Existing scalar subGaussian predicate forms"
    domain: "concentration"
    unit_type: vocabulary
    math_pattern: "subGaussian control should choose an existing formulation"
    lean_template: |
      -- Use one of the existing names; do not introduce a canonical predicate.
      #check SubGaussianTail
      #check SubGaussianMoment
      #check CenteredSubGaussianMGF
      #check SubGaussianOrlicz
    usage_count: 4
    success_rate: 0.85
    added_at: "2026-06-03T00:00:00Z"
    last_used: "2026-06-03T12:00:00Z"
    tags: ["subGaussian", "MGF", "existing-api"]
```

Invalid entries must be stored as anti-patterns, not templates. Examples:
inventing `IsSubGaussian`, using `[MeasureSpace Ω]` in place of the current
`[MeasurableSpace Ω]` plus `Measure Ω` convention, adding `sorry`, or creating
custom probability/random-variable structures.

#### Template Store

Templates are parameterized code skeletons with slots for the Translator
to fill:

```yaml
templates:
  - id: "chernoff-tail-1"
    description: "Chernoff bounding: MGF → exponential tail"
    applicability:
      goal_pattern: "μ {ω | {X} ω ≥ {t}} ≤ {bound}"
      requires_hypothesis:
        - name: mgf_bound
          pattern: "∫ exp (λ * {X}) ∂μ ≤ exp({R}(λ))"
    code: |
      have h_chernoff : μ {ω | {X} ω ≥ {t}} ≤
          exp (-λ*{t}) * ∫ exp (λ * {X}) ∂μ := by
        apply chernoffBound (t := {t}) (λ := {λ}) {X}
      ...
    parameters: [X, t, bound, λ, R]
    usage_count: 7
```

#### Failure→Fix Map

```yaml
failure_fix_map:
  - error_class: type_mismatch
    error_pattern: "has type ℝ but is expected to have type ℕ"
    fix: insert_coercion
    success_rate: 0.92
    examples: [...]

  - error_class: unknown_identifier
    error_pattern: "unknown identifier '{name}'"
    fix: fuzzy_import_search
    success_rate: 0.78
    examples: [...]
```

### Query Interface

```
QUERY(pattern_type="definition", domain="concentration", math_pattern~="subGaussian")
  → [sg-existing-forms (0.99)]

QUERY(error_class="type_mismatch", context="ℝ vs ℕ")
  → [insert_coercion (0.92)]

QUERY(goal_type~="exp tail bound", context~="MGF")
  → [chernoff-tail-1 (0.88), chernoff-tail-2 (0.71)]
```

---

## PatternLearner

### Role

Observes successful formalizations and extracts reusable patterns.
Runs after a concept reaches `INTEGRATED`.

### Extraction Triggers

1. **Template extraction**: When the same proof structure appears ≥ 3 times
2. **Pattern extraction**: When a definition/theorem shape appears ≥ 2 times
3. **Fix strategy extraction**: When a compile error is fixed the same way ≥ 3 times
4. **Anti-pattern extraction**: When a specific pattern leads to failure ≥ 3 times

### Process

1. Load the successful `.lean` file and its compile/fix/review history
2. Diff against existing Knowledge Base entries and current Lean declarations
   to avoid duplicates and invented names
3. Abstract concrete identifiers into parameters
4. Assign confidence based on similarity to existing reviewed patterns
5. Reject anything containing forbidden placeholders or unapproved structures
6. Submit to Knowledge Base via `store_pattern` / `store_template`

### Pattern Generalization

```
Concrete:  CenteredSubGaussianMGF P X K
Abstract:  existing_predicate_form P X K

Match:     ∀ λ > 0, ∫ x, exp(λ * f x) ∂ν ≤ exp(λ^2 * C^2 / 2)
Abstract:  possible theorem target, but only if translated through existing
           HighDimProb vocabulary and fully proved
```

The generalized pattern captures the **structure** while the template
preserves the **domain-specific** parts.

---

## FSMUpdater

### Role

Monitors the FSM's performance and proposes growth operations.

### Process (runs periodically)

1. **Collect metrics**: Read transition metrics from the transition log
2. **Detect triggers**: Check each growth trigger condition (see `fsm/growth.md`)
3. **Propose operation**: If a trigger fires, generate a growth proposal
4. **Validate**: Simulate the proposed FSM on the last 10 concepts
5. **Submit**: Send proposal to Orchestrator for approval
6. **Apply**: If approved by a human maintainer, prepare an ordinary patch to
   `fsm/states.md` and `fsm/transitions.md`. The updater must not silently edit
   repository files.

### Monitoring Metrics

```yaml
fsm_health:
  total_concepts_processed: 5
  avg_time_to_integrate: "2h 15min"
  success_rate: 0.72
  escalation_rate: 0.28
  avg_cycles_per_concept: 2.1
  most_frequent_escalation: "PROOF_GAP → NEEDS_HUMAN"
  bottleneck_state: "TRANSLATING"  # highest median duration
  state_counts:
    INTEGRATED: 3
    NEEDS_HUMAN: 1
    STUCK: 1
    QUEUED: 17
```

### Proposal Template

```yaml
growth_proposal:
  id: "prop-001"
  trigger: "frequent_escalation"
  metric: "PROOF_GAP → NEEDS_HUMAN rate = 0.45 (threshold: 0.40)"
  operation: insert_state
  params:
    before: VERIFYING
    after: PROOF_GAP
    new_state: PROOF_DECOMPOSITION
    reason: "Decompose complex goals into sub-goals before attempting proof"
  validation:
    simulation_results: "success_rate improved from 0.55 to 0.72"
    regression: false
    state_count_after: 22  # within max (50)
  submitted_at: "2026-06-03T..."
  confidence: 0.78
```
