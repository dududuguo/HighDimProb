# Matrix Bernstein Mainline MB-S3 Run Config

Project root: `C:/Users/11388/reserach/HighDimProb`

Sprint: Matrix Bernstein Mainline Sprint MB-S3

Task: trace-exponential positivity bridge for self-adjoint matrices

External systems:

- `external/codebase-memory`
- `external/multi-agent-system`
- `external/theory-roadmap`
- `external/validation`

Agent roles:

- orchestrator: stage sequencing and scope control
- knowledge: Mathlib API survey
- translation: Lean/docs/test edits
- verification: build/test/judge/policy/diff checks
- review: theorem honesty and documentation consistency
- continuous-learning: memory/FSM updates if a proof pattern or blocker appears

Hard constraints:

- No `sorry`, `admit`, `axiom`, or `unsafe`
- No theorem-like True-bodied `Prop`
- No optional dependencies
- No matrix Bernstein, Hanson-Wright, or theorem-meaning changes
- Keep scalar concentration and RandomMatrix APIs compatible

Stage gates:

- `lake build`
- `lake test`
- `lake build HighDimProbJudge`
- `python scripts/judge_policy_check.py`
- `git diff --check`
