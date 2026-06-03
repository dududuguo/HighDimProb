# MVP KG-to-Lean Validation Run Config

Run id: `mvp-kg-to-lean`

Date: 2026-06-03

Project root: `C:/Users/User/research/HighDimProb`

Run directory: `external/validation/mvp-kg-to-lean/`

## Objective

Run a minimal end-to-end validation of the three-loop system:

- Loop 1: select a small theory-roadmap concept cluster and map it to Lean definitions, theorems, wrappers, tests, or documentation.
- Loop 2: synchronize codebase-memory after the Lean/repository action.
- Loop 3: record failures, repairs, source-validation lessons, Mathlib reuse decisions, and workflow/FSM learning.

This run is intentionally not a full formalization run.

## Selected MVP Concepts

Requested concepts:

1. Markov inequality
2. Chebyshev inequality
3. Orlicz psi2 bound implies subGaussian tail

The theory KG is mostly concept-level rather than theorem-level. The selected closest KG equivalents are:

- `concept:basic-concentration` - "Markov, Chebyshev, Chernoff and exponential tail tools"
- `concept:moments-lp-orlicz` - "moments, Lp norms and Orlicz controls"
- `concept:subgaussian-subexponential` - "subGaussian and subExponential random variables"

## Gates

- Mathlib reuse report must exist before Lean changes.
- Source validation must compare roadmap/KG with source markdown and prefer Tier 0 Lean/Mathlib proof facts when available.
- No optional dependencies.
- No new Lean theorem surface unless clearly needed.
- Keep `lake build` and `lake test` passing.

## Lean Action Policy For This Run

All three selected theorem-level concepts are already implemented and tested in HighDimProb. The intended Lean action is therefore:

- do not duplicate any theorem;
- do not create new definitions;
- record reuse and validation evidence;
- leave existing focused `#check` tests in place;
- add only run artifacts under `external/validation/mvp-kg-to-lean/`.

## Required Inputs Read

- `docs/Status.md`
- `docs/TheoremAtlas.md`
- `docs/ScalarImplicationGraph.md`
- `docs/BranchRegistry.md`
- `docs/ModuleTree.md`
- `docs/Workflow.md`
- `external/theory-roadmap/roadmap/theory_kg.json`
- `external/theory-roadmap/roadmap/lean_toposort.json`
- `external/theory-roadmap/roadmap/roadmap_digest.md`
- `external/theory-roadmap/roadmap/KnowledgeGraph.md`
- selected `external/theory-roadmap/sources/*.md` source excerpts
- `external/multi-agent-system/integration/codebase-memory.md`
- `external/multi-agent-system/workflows/formalize-concept.md`
- `external/multi-agent-system/workflows/fix-compile-error.md`
- `external/multi-agent-system/workflows/continuous-learning.md`
- `external/multi-agent-system/fsm/states.md`
- `external/multi-agent-system/fsm/transitions.md`
- `external/multi-agent-system/fsm/growth.md`

## Verification Commands

- `lake build`
- `lake test`

