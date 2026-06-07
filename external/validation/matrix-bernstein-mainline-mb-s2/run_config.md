# Matrix Bernstein Mainline MB-S2 Run Config

Project root: `C:/Users/11388/reserach/HighDimProb`

Sprint: Matrix Bernstein Mainline Sprint MB-S2

Task: spectral, Rayleigh, trace-exponential, and matrix Laplace bridge

External systems:

- `external/codebase-memory`
- `external/multi-agent-system`
- `external/theory-roadmap`
- `external/validation`

Agent roles used:

- orchestrator: stage sequencing, scope control, and blocker routing
- knowledge: Mathlib and roadmap/API search
- translation: Lean/source/document edits
- verification: build, test, judge, policy, and diff checks
- review: theorem-honesty and documentation consistency audit

Hard constraints:

- No `sorry`, `admit`, `axiom`, or `unsafe`
- No theorem-like True-bodied `Prop`
- No optional dependencies
- No silent theorem-meaning changes
- Keep old scalar concentration, Hoeffding, Bernstein, and RandomMatrix APIs compatible
- Add tests for all new public declarations
- Unproved theorem targets must be meaningful typed `abbrev ... : Prop := ...`
  or docs-only TODOs

Validation gates after each stage:

- `lake build`
- `lake test`
- `lake build HighDimProbJudge`
- `python scripts/judge_policy_check.py`
- `git diff --check`
