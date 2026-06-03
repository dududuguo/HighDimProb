# Multi-Agent System for Theory-to-Lean4 Transcription

## Overview

This directory defines a multi-agent system (MAS) that guides the systematic
transcription of mathematical theory into verified Lean4 code, driven by the
theory roadmap (`external/theory-roadmap/`) and validated against the codebase
knowledge graph (`external/codebase-memory/`).

The system treats Lean4 formalization as a **pipeline** with well-defined
states, where a **growable finite state machine (FSM)** orchestrates agent
behavior and learns from repeated execution.

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

3. **Pattern library grows**: The Knowledge Base agent observes every
   successful formalization and extracts reusable patterns (lemma shapes,
   proof strategies, typeclass recipes). These become templates the
   TemplateInstantiator uses to accelerate future translations.

4. **Human-in-the-loop at quality gates**: The FSM can transition to
   `NEEDS_HUMAN` when confidence is low or all automatic fixes are exhausted.

5. **Bi-directional roadmap sync**: Progress updates flow back to the
   theory roadmap, marking concepts as formalized, partially formalized,
   or blocked.
