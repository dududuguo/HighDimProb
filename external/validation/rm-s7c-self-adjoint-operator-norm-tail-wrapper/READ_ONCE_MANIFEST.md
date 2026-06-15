# RM-S7C Read-Once Manifest

Round: `RM-S7C-self-adjoint-operator-norm-tail-wrapper`

## Governance Read

- `docs/Workflow.md`
- `docs/Status.md`
- `docs/TermMap.md`
- `docs/TestPlan.md`
- `external/multi-agent-system/agents/coder_agent.md`
- `external/multi-agent-system/agents/debugger_agent.md`
- `external/multi-agent-system/agents/docs_agent.md`
- `external/multi-agent-system/agents/project_manager_agent.md`
- `external/multi-agent-system/agents/reviewer_agent.md`
- `external/multi-agent-system/agents/tester_agent.md`
- `external/multi-agent-system/agents/theory_agent.md`
- `external/multi-agent-system/fsm/agent_protocol.md`
- `external/multi-agent-system/fsm/fsm_overview.md`
- `external/multi-agent-system/fsm/project_manager_fsm.md`
- `external/multi-agent-system/fsm/state_definitions.md`

## Prior RM-S7 Validation Read

- `external/validation/rm-s7-five-step-supervisor/`
- `external/validation/rm-s7-operator-norm-tail-contract/`
- `external/validation/rm-s7a-lambda-max-tail-bridge/`
- `external/validation/rm-s7b-two-sided-quadratic-form-tail-wrapper/`

## Source References Read

Only files under `external/theory-roadmap/sources/` were used for external
mathematical reference checks.

- `external/theory-roadmap/sources/High-Dimensional_Probability.md`
  - Matrix Bernstein theorem statement near the operator-norm tail bound.
  - Two-sided proof route via applying the one-sided argument to `-S`.
- `external/theory-roadmap/sources/Topics_in_Random_Matrix_Theory.md`
  - Operator-norm/random-matrix spectral tail context for noncommutative
    concentration.

## Code Discovery

- Codebase-memory MCP graph tools were available and used first for existing
  random-matrix spectral and concentration declarations.
- The graph index did not expose the newest RM-S7B names, so source reads and
  `rg` were used for current dirty-tree declarations.
