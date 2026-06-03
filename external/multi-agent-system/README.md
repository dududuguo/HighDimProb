# Multi-Agent System for Theory-to-Lean4 Transcription

## Overview

This directory defines a multi-agent system (MAS) that guides the systematic
transcription of mathematical theory into verified Lean4 code, driven by the
theory roadmap (`external/theory-roadmap/`) and validated against the codebase
knowledge graph (`external/codebase-memory/`).

The system treats Lean4 formalization as a **pipeline** with well-defined
states, where a **growable finite state machine (FSM)** orchestrates agent
behavior and learns from repeated execution.

## Authority and Trust Boundary

This directory is an external planning sketch, not a source of project law.
When it conflicts with the main repository, the main repository wins. Agents
must read and obey, in this order:

1. `docs/Workflow.md`
2. `docs/Status.md`
3. `README.md`
4. `ORGANISATION.md`
5. `CONTRIBUTING.md`

The examples in this directory are non-normative. They may illustrate an idea,
but they must not be copied into Lean code until they have been checked against
the current HighDimProb API, import boundaries, and theorem-atlas policy.

Hard constraints for this repository:

- Do not add `sorry`, `admit`, axioms, or unproved theorem/lemma declarations.
- Do not create custom probability universes or custom random-variable
  structures.
- Reuse Mathlib and existing HighDimProb declarations before introducing names.
- Keep stable and experimental imports separated.
- Treat `external/theory-roadmap/` as a submodule and do not write into it
  automatically.
- Run `lake build` and `lake test` before a change is considered integrated.

Mandatory project-tracking workflow:

1. Read `docs/Status.md` and `docs/Workflow.md`.
2. Process exactly one concept cluster.
3. Search Mathlib and the existing HighDimProb code before defining anything.
4. Classify work as existing Mathlib, wrapper/alias, new definition, complete
   theorem proof, typed statement, or blocker.
5. Add focused API/proof tests for public declarations.
6. Update the required tracking docs: `docs/TermMap.md`,
   `docs/BookProgress.md`, `docs/AbstractionLog.md`, `docs/TODO.md`, and
   `docs/Status.md`, or explicitly justify why a file is unchanged.
7. Run `lake build` and `lake test`.

## Directory Layout

```
multi-agent-system/
├── README.md                  ← this file
├── fsm/                       ← finite state machine definition
│   ├── states.md              ← state catalogue
│   ├── transitions.md         ← transition rules and guards
│   └── growth.md              ← FSM growth/evolution mechanism
├── agents/                    ← agent definitions
│   ├── orchestrator.md        ← task dispatch and progress tracking
│   ├── extraction.md          ← concept/theorem extraction agents
│   ├── translation.md         ← math → Lean4 translation agents
│   ├── verification.md        ← compilation and proof verification
│   ├── review.md              ← multi-dimensional review agents
│   └── knowledge.md           ← pattern learning and knowledge base
├── workflows/                 ← agent interaction workflows
│   ├── formalize-concept.md   ← end-to-end concept formalization
│   ├── fix-compile-error.md   ← error diagnosis and repair
│   └── continuous-learning.md ← pattern extraction and FSM growth
└── integration/               ← integration points
    ├── theory-roadmap.md      ← how to consume the theory roadmap
    └── codebase-memory.md     ← how to query and update the code graph
```

## Core Design Principle

> Lean4 transcription is a **highly repetitive workflow** with a small set of
> failure modes. The FSM encodes these modes as states, and agents operate
> within well-defined state transitions. The FSM **grows** by observing
> successful and failed transitions, refining its state space over time.

## Architecture at a Glance

```
┌─────────────────────────────────────────────────────────────┐
│                     Theory Roadmap                           │
│  (topological sort: 22 concepts, 8 layers, dependencies)    │
└──────────────────────────┬──────────────────────────────────┘
                           │ next concept
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                    ORCHESTRATOR                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              Growable Finite State Machine            │   │
│  │  QUEUED → EXTRACT → TRANSLATE → COMPILE → REVIEW →   │   │
│  │  VERIFY → INTEGRATE → DONE                           │   │
│  │              ↑↓  error recovery loops                │   │
│  └──────────────────────────────────────────────────────┘   │
└──────────┬──────────┬──────────┬──────────┬─────────────────┘
           │          │          │          │
           ▼          ▼          ▼          ▼
    ┌──────────┐ ┌────────┐ ┌────────┐ ┌────────────┐
    │EXTRACTION│ │TRANSLAT│ │VERIFIC.│ │  REVIEW     │
    │ Agents   │ │ -ION   │ │ Agents │ │  Agents     │
    │          │ │ Agents │ │        │ │             │
    │·Concept  │ │·Transl.│ │·Compile│ │·MathReview  │
    │ Extractor│ │·Templ. │ │·Fixer  │ │·StyleReview │
    │·Theorem  │ │ Inst.  │ │·Proof  │ │·CoverageRev │
    │ Locator  │ │        │ │ Compl. │ │·DependencyR │
    └──────────┘ └────────┘ └────────┘ └────────────┘
           │          │          │          │
           └──────────┴──────────┴──────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │    KNOWLEDGE BASE      │
              │  · patterns            │
              │  · templates           │
              │  · known solutions     │
              │  · failure → fix map   │
              └────────────┬───────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │    FSM UPDATER         │
              │  · learns new states   │
              │  · refines transitions │
              │  · prunes dead paths   │
              └────────────────────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │   Codebase Memory      │
              │   (knowledge graph)    │
              │   1209 nodes, 2721 edg.│
              └────────────────────────┘
```

## Key Design Decisions

1. **FSM is data, not code**: States, transitions, and guards are stored in
   Markdown/JSON. Agents read them at runtime. This enables growth without
   re-engineering.

2. **Layered defense**: Translation → Compilation → Review → Verification.
   Each layer catches different error classes before they propagate.

3. **Pattern library is subordinate to compiled code**: The Knowledge Base
   agent may learn only from reviewed, compiling HighDimProb declarations.
   Templates that contain forbidden placeholders or invented APIs are invalid.

4. **Human-in-the-loop at quality gates**: The FSM can transition to
   `NEEDS_HUMAN` when confidence is low or all automatic fixes are exhausted.

5. **Roadmap sync is report-first**: Progress can be summarized for the
   theory roadmap, but writes to the roadmap submodule require an explicit,
   reviewed patch.
