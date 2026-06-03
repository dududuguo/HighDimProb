# Workflow Delta

Status: completed.

## Patched Files

- `external/multi-agent-system/fsm/states.md`
- `external/multi-agent-system/fsm/transitions.md`
- `external/multi-agent-system/workflows/formalize-concept.md`
- `external/multi-agent-system/workflows/continuous-learning.md`

## New State

Added `REUSE_SOURCE_VALIDATING` after `EXTRACTED` and before `TRANSLATING`.

The state requires:

- Mathlib reuse report.
- Existing HighDimProb/codebase-memory declaration search.
- Source validation report against resolvable source locations.
- Action classification.
- KG correction/quarantine entry if needed.
- No Lean generation before the gate passes.

## Transition Changes

- `EXTRACTED` now dispatches to `REUSE_SOURCE_VALIDATING`.
- `REUSE_SOURCE_VALIDATING` reaches `TRANSLATING` only when reports and action classification are complete.
- Unsafe source/action mismatch routes to `DEFERRED`.
- Timeout routes to `STUCK`.

## Workflow Changes

- `formalize-concept.md` now inserts reuse/source validation after extraction and before translation.
- `continuous-learning.md` now collects reuse reports, source validation reports, action manifests, and KG corrections/quarantines as post-integration artifacts.
