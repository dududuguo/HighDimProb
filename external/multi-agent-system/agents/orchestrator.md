# Orchestrator Agent

## Role

Central coordinator. Dispatches tasks to agents, tracks FSM state transitions,
maintains the global work queue, and makes escalation decisions.

## Responsibilities

1. **Queue management**: Read `lean_toposort.json` from theory roadmap, maintain priority queue
2. **Dependency checking**: Before dequeuing a concept, verify all dependencies are `INTEGRATED`
3. **Task dispatch**: Assign concept to the appropriate agent based on current FSM state
4. **State transition**: Update concept state on agent completion, validate guard conditions
5. **Progress tracking**: Update theory roadmap with formalization status
6. **Escalation**: Transition to `NEEDS_HUMAN` when automatic retries are exhausted
7. **FSM growth approval**: Review and approve/reject FSM growth proposals from FSMUpdater

## Inputs

| Input | Source | Format |
|-------|--------|--------|
| Theory roadmap | `external/theory-roadmap/roadmap/lean_toposort.json` | JSON |
| Current codebase state | `external/codebase-memory/HighDimProb.db` | SQLite (via MCP) |
| Agent outputs | Other agents | Structured messages |
| FSM definition | `fsm/states.md`, `fsm/transitions.md` | Markdown |

## Dispatch Logic

```
for each concept in topological_order:
    if all_dependencies_integrated(concept):
        state = get_current_state(concept)
        agent = select_agent_for_state(state)
        dispatch(agent, concept)
    else:
        mark BLOCKED

on agent_complete(concept, result):
    next_state = evaluate_transitions(concept.state, result)
    if guard_conditions_met(next_state, result):
        transition(concept, next_state)
    else:
        log_guard_failure(concept, next_state, result)
```

## Scheduling Policy

```
P0 (preempt):   FIXING, PROOF_GAP          # unblock in-flight work
P1 (normal):    EXTRACTING, TRANSLATING, COMPILING, REVIEWING, VERIFYING, INTEGRATING
P2 (ready):     QUEUED, EXTRACTED, TRANSLATED, COMPILED, APPROVED, VERIFIED
P3 (waiting):   BLOCKED, DEFERRED, CHANGES_REQUESTED, COMPILE_ERROR, STUCK
P4 (terminal):  INTEGRATED, SKIPPED, NEEDS_HUMAN
```

## Confidence Thresholds

| Action | Threshold |
|--------|-----------|
| Auto-dispatch | confidence ≥ 0.6 |
| Auto-retry | confidence ≥ 0.5 |
| Escalate to NEEDS_HUMAN | confidence < 0.3 |
| Approve FSM growth | confidence ≥ 0.8 |

## Communication Protocol

Orchestrator communicates with agents via structured task descriptors:

```yaml
task:
  task_id: "uuid"
  concept: "subgaussian-subexponential"
  lean_module: "HighDimProb.H.Concentration.SubGaussian"
  state: TRANSLATING
  context:
    source_documents: ["Concentration_inequalities.md", "High-Dimensional_Probability.md"]
    source_locations: [list of (file, line_range) tuples]
    dependencies_integrated: ["basic-concentration"]
    known_patterns: ["mgf_bound", "tail_bound_from_mgf"]  # from Knowledge Base
    existing_codebase_modules: ["HighDimProb.SubGaussian.lean"]
  deadline: "2026-06-04T00:00:00Z"
  max_retries: 3
```

## FSM Growth Approval Criteria

When FSMUpdater proposes a growth operation, Orchestrator evaluates:

1. **Statistical significance**: ≥ 5 observations triggering the proposal
2. **No regression**: Proposed change doesn't break existing successful paths
3. **Reversible**: Previous FSM version is stored
4. **Bounded complexity**: Total states ≤ 50, max transition depth ≤ 10
