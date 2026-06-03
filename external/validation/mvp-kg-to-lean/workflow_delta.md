# Workflow/FSM Delta

Run id: `mvp-kg-to-lean`

## What Went Wrong

- The requested theorem-level KG nodes were not present as exact nodes. The KG represented this area as broad concept clusters.
- The first codebase-memory indexing attempt reported success but was not visible to follow-up queries.
- Graph extraction did not reliably expose every existing Lean theorem declaration, even after the second index.
- Source markdown contains OCR artifacts and should not be used as a final theorem authority without Lean/Mathlib or stronger source checks.

## What Worked

- Reading `docs/Status.md`, `docs/TheoremAtlas.md`, and `docs/ScalarImplicationGraph.md` quickly identified that all three MVP concepts were already proven.
- Mathlib-first search confirmed the correct reuse story:
  - Markov uses Mathlib lintegral Markov.
  - Chebyshev uses Mathlib variance Chebyshev.
  - Orlicz-to-tail uses Mathlib lintegral Markov plus HighDimProb project predicates.
- Existing focused API tests were already present for the selected declarations.
- The second codebase-memory index created a usable graph project and persistent artifact.

## New Guardrail

Add an explicit "reuse and source validation packet" guard before `TRANSLATING`.

Required packet fields:

- requested concept;
- exact KG node if available;
- closest KG mapping if exact node is absent;
- existing HighDimProb declarations;
- Mathlib search terms and results;
- source markdown references;
- source trust tier;
- action classification: already implemented, wrapper needed, new declaration needed, typed statement only, docs only, blocked, or source error.

The translator must not write Lean code until this packet exists.

## Proposed New State

Insert a state between `EXTRACTED` and `TRANSLATING`:

```text
EXTRACTED -> REUSE_SOURCE_VALIDATING -> TRANSLATING
```

State: `REUSE_SOURCE_VALIDATING`

Entry criteria:

- extraction manifest exists;
- one concept cluster selected;
- source locations are resolvable.

Exit criteria:

- Mathlib reuse report exists;
- KG-to-Lean mapping exists;
- source trust tier is recorded;
- any source mismatch is recorded in `kg_corrections.jsonl`;
- action classification is recorded for each selected unit.

Failure transitions:

- if exact KG node is absent and no closest mapping can be justified, transition to `DEFERRED`;
- if source and Lean/Mathlib statements conflict materially, transition to `DEFERRED` or `NEEDS_HUMAN`;
- if codebase-memory MCP cannot be used, proceed with targeted local fallback and require a memory delta file.

## Proposed Transition Guard Updates

Add to `TRANSLATING -> TRANSLATED`:

- `reuse_report_exists: true`
- `source_validation_complete: true`
- `kg_mapping_recorded: true`

Add to `VERIFYING -> VERIFIED`:

- `no_duplicate_of_mathlib_or_highdimprob: true`
- `source_corrections_logged_or_empty: true`

Add to `INTEGRATING -> INTEGRATED`:

- `codebase_memory_reindexed_or_delta_written: true`
- `workflow_delta_written_if_learning_observed: true`

## Source Validation Lesson

For broad KG concepts, the source-validation gate should validate the theorem-level Lean action, not merely the broad KG title. In this run, the source title "Markov, Chebyshev, Chernoff and exponential tail tools" was too broad to be the statement authority.

## Mathlib Reuse Lesson

The right reuse outcome is sometimes "do nothing": when HighDimProb already has a wrapper around a Mathlib theorem, adding another wrapper increases API noise without improving formal coverage.

## Codebase-Memory Synchronization Lesson

The MCP project name should be discovered after indexing and recorded in the run artifacts. If indexing reports success but queries cannot find the project, retry indexing once with a normalized repository path, then record both attempts in the memory delta.

## Suggested Patch Targets

Direct edits to the multi-agent system are not applied in this validation run. Proposed documentation targets:

- `external/multi-agent-system/fsm/states.md`: add `REUSE_SOURCE_VALIDATING`.
- `external/multi-agent-system/fsm/transitions.md`: insert the transition and guards above.
- `external/multi-agent-system/workflows/formalize-concept.md`: require the reuse/source validation packet before translation.
- `external/multi-agent-system/workflows/fix-compile-error.md`: no immediate compile-error taxonomy change needed, because no compile error occurred.
- `external/multi-agent-system/workflows/continuous-learning.md`: record this as a post-integration source/reuse guardrail lesson.

