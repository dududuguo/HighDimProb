# MVP KG-to-Lean v1 Run Config

Run date: 2026-06-03

Workspace: `C:\Users\User\research\HighDimProb`

Run directory: `external/validation/mvp-kg-to-lean-v1/`

## Objective

Exercise a stronger KG-to-Lean workflow on three selected nodes:

- A: Chebyshev inequality, expected to map to existing proven Lean.
- B: finite union bound / Boole inequality, forced to produce a real repository action.
- C: Hoeffding inequality, used as source-validation stress only.

## Scope Rules

- Do not prove general Hoeffding in MVP-1.
- Prefer existing Mathlib and existing HighDimProb declarations before defining or proving anything.
- Produce `mathlib_reuse_report.md` before any Lean modification.
- Produce `source_validation_report.md` before trusting OCR theorem statements.
- If an OCR/KG statement is wrong, log a correction or quarantine in `kg_corrections.jsonl`.
- Patch the multi-agent FSM/workflow files, not only this validation report.
- Run `lake build`, `lake test`, and a forbidden-token audit on Lean sources.

## Planned Real Repo Action

The finite union bound is already proven as `HighDimProb.measure_biUnion_le`, so MVP-1 will add a focused union-bound API test module and wire it into the test aggregate.

Expected Lean edits:

- Add `HighDimProbTest/UnionBoundAPI.lean`.
- Update `HighDimProbTest.lean`.

Expected docs/workflow edits:

- Update `docs/TestPlan.md` for the new focused test module.
- Patch:
  - `external/multi-agent-system/fsm/states.md`
  - `external/multi-agent-system/fsm/transitions.md`
  - `external/multi-agent-system/workflows/formalize-concept.md`
  - `external/multi-agent-system/workflows/continuous-learning.md`

