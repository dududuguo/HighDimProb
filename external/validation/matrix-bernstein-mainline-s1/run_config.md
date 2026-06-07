# Matrix Bernstein Mainline Sprint MB-S1 Run Config

Date: 2026-06-06

Project root: `C:/Users/11388/reserach/HighDimProb`

Sprint: Matrix Bernstein Mainline Sprint MB-S1

Scope:
- Return to the random-matrix mainline after MC4/J2.
- Audit statement honesty.
- Attempt PSD square, PSD second moment, and PSD variance-proxy algebra.
- Refine the matrix Bernstein typed statement/proof plan without proving matrix Bernstein.
- Keep build, tests, judge, and policy checks passing.

Hard constraints:
- No `sorry`, `admit`, `axiom`, or `unsafe`.
- No optional dependencies.
- No silent theorem-meaning changes.
- No deletion of existing theorem names.
- No scalar concentration regressions.
- No theorem-like `Prop := True`.

External system notes:
- Codebase-memory graph tools were not exposed during initial preflight, but
  were available on continuation for local declaration discovery.
- A manual codebase-memory delta is recorded, and a fast persistent MCP index
  refresh was run at MB6.
- FSM files confirm the `REUSE_SOURCE_VALIDATING` gate exists before `TRANSLATING`.
- Continuous-learning artifacts are recorded under this run directory.

Validation commands after each stage:
- `lake build`
- `lake test`
- `lake build HighDimProbJudge` when `HighDimProbJudge.lean` exists
- `python scripts/judge_policy_check.py` when the script exists

Final validation:
- all stage validation commands
- `git diff --check`
- forbidden-token audit over `HighDimProb/`, `HighDimProbTest/`, and `HighDimProbJudge/`
- `:= True` audit over Lean source/test/judge files
