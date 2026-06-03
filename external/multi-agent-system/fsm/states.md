# Finite State Machine — State Catalogue

Each concept from the theory roadmap passes through this FSM.
States are identified by a short key; each has entry criteria, exit criteria,
responsible agents, and a timeout.

## Core Pipeline States

### QUEUED

| Property | Value |
|----------|-------|
| **Description** | Concept is in the ready queue, dependencies satisfied |
| **Entry criteria** | All `lean_toposort.json` dependencies are `INTEGRATED` |
| **Exit criteria** | Orchestrator assigns to an Extractor agent |
| **Responsible agent** | Orchestrator |
| **Timeout** | None (waiting on dependencies) |
| **On timeout** | N/A |

### EXTRACTING

| Property | Value |
|----------|-------|
| **Description** | Reading source documents, identifying formalizable units |
| **Entry criteria** | Concept is `QUEUED` and assigned |
| **Exit criteria** | Extraction manifest produced (list of theorems, definitions, lemmas with source locations) |
| **Responsible agent** | ConceptExtractor, TheoremLocator |
| **Timeout** | 30 min |
| **On timeout** | → `STUCK`, log: "extraction timed out for {concept}" |

### EXTRACTED

| Property | Value |
|----------|-------|
| **Description** | Formalizable units identified, ready for translation |
| **Entry criteria** | Extraction manifest is non-empty and validated |
| **Exit criteria** | Translator agent picks up the manifest |
| **Responsible agent** | Orchestrator (validation gate) |
| **Timeout** | None |
| **On timeout** | N/A |

### TRANSLATING

| Property | Value |
|----------|-------|
| **Description** | Generating Lean4 code for each unit in the manifest |
| **Entry criteria** | Manifest available; templates loaded from Knowledge Base |
| **Exit criteria** | `.lean` file(s) written; syntax check passed |
| **Responsible agent** | Translator, TemplateInstantiator |
| **Timeout** | 60 min per file |
| **On timeout** | → `STUCK`, partial output saved |

### TRANSLATED

| Property | Value |
|----------|-------|
| **Description** | Lean4 code generated, awaiting compilation |
| **Entry criteria** | At least one `.lean` file produced |
| **Exit criteria** | Compilation attempted |
| **Responsible agent** | Orchestrator (dispatch to Compiler) |
| **Timeout** | None |

### COMPILING

| Property | Value |
|----------|-------|
| **Description** | Running `lake build` on the translated module |
| **Entry criteria** | `.lean` file exists; imports resolvable |
| **Exit criteria** | Build result (success or error list) |
| **Responsible agent** | Compiler |
| **Timeout** | 15 min |
| **On timeout** | → `STUCK`, log build output |

### COMPILED

| Property | Value |
|----------|-------|
| **Description** | Module compiles without errors |
| **Entry criteria** | `lake build` exit code 0 |
| **Exit criteria** | Review dispatched |
| **Responsible agent** | Orchestrator |
| **Timeout** | None |

### COMPILE_ERROR

| Property | Value |
|----------|-------|
| **Description** | Compilation failed with errors |
| **Entry criteria** | `lake build` exit code ≠ 0 |
| **Exit criteria** | Error classified and fix strategy selected |
| **Responsible agent** | SyntaxFixer (classifies errors) |
| **Timeout** | None |

### FIXING

| Property | Value |
|----------|-------|
| **Description** | Applying fixes to resolve compilation errors |
| **Entry criteria** | Error classification available |
| **Exit criteria** | Fix applied; re-compilation queued |
| **Responsible agent** | SyntaxFixer, Translator (if re-translation needed) |
| **Max retries** | 3 per error class |
| **On max retries** | → `NEEDS_HUMAN` |

### REVIEWING

| Property | Value |
|----------|-------|
| **Description** | Multi-dimensional review of compiled code |
| **Entry criteria** | Code is `COMPILED` |
| **Exit criteria** | All review dimensions report pass or changes requested |
| **Responsible agent** | MathReviewer, StyleReviewer, CoverageReviewer, DependencyReviewer, IntegrationReviewer |
| **Timeout** | 45 min |
| **On timeout** | → `NEEDS_HUMAN` (review incomplete) |
| **Concurrency** | All reviewers run in parallel |

### APPROVED

| Property | Value |
|----------|-------|
| **Description** | All reviews passed |
| **Entry criteria** | All review dimensions return `approved` |
| **Exit criteria** | Verification dispatched |
| **Responsible agent** | QualityGate |
| **Timeout** | None |

### CHANGES_REQUESTED

| Property | Value |
|----------|-------|
| **Description** | One or more reviews requested changes |
| **Entry criteria** | Any review dimension returns `changes_requested` |
| **Exit criteria** | Change list compiled and prioritized |
| **Responsible agent** | Orchestrator (aggregates review feedback) |
| **Timeout** | None |
| **Max cycles** | 3 review cycles per concept |
| **On max cycles** | → `NEEDS_HUMAN` |

### VERIFYING

| Property | Value |
|----------|-------|
| **Description** | Proof verification: are there `sorry` gaps? |
| **Entry criteria** | Code is `APPROVED` |
| **Exit criteria** | Proof status determined (complete / gaps found) |
| **Responsible agent** | ProofCompleter (detects `sorry`) |
| **Timeout** | 30 min |
| **On timeout** | → `STUCK` |

### VERIFIED

| Property | Value |
|----------|-------|
| **Description** | All proofs are complete (no `sorry`) |
| **Entry criteria** | Zero `sorry` in module |
| **Exit criteria** | Integration dispatched |
| **Responsible agent** | QualityGate |
| **Timeout** | None |

### PROOF_GAP

| Property | Value |
|----------|-------|
| **Description** | Proofs contain `sorry` or incomplete reasoning |
| **Entry criteria** | `sorry` count > 0 |
| **Exit criteria** | Gap analysis produced; fix strategy selected |
| **Responsible agent** | ProofCompleter, Translator (gap filling) |
| **Max cycles** | 5 per gap |
| **On max cycles** | → `NEEDS_HUMAN` |

### INTEGRATING

| Property | Value |
|----------|-------|
| **Description** | Merging verified module into the codebase |
| **Entry criteria** | Code is `VERIFIED` |
| **Exit criteria** | PR created / branch merged; codebase-memory re-indexed |
| **Responsible agent** | Orchestrator, CodebaseMemory |
| **Timeout** | 20 min |
| **On timeout** | → `STUCK` |

### INTEGRATED

| Property | Value |
|----------|-------|
| **Description** | Module is part of the codebase |
| **Entry criteria** | Merge complete; knowledge graph updated |
| **Exit criteria** | End state; next concept unblocked |
| **Responsible agent** | Orchestrator (triggers dependency re-check) |
| **Timeout** | None |

---

## Meta States

### BLOCKED

| Property | Value |
|----------|-------|
| **Description** | Cannot proceed due to unsatisfied dependency |
| **Entry criteria** | Dependency check fails |
| **Exit criteria** | All dependencies reach `INTEGRATED` |
| **Responsible agent** | DependencyResolver |
| **Timeout** | None |

### SKIPPED

| Property | Value |
|----------|-------|
| **Description** | Intentionally skipped (e.g., out of scope for current milestone) |
| **Entry criteria** | Orchestrator marks concept as skip |
| **Exit criteria** | Manually re-queued |
| **Responsible agent** | Orchestrator |

### DEFERRED

| Property | Value |
|----------|-------|
| **Description** | Temporarily deferred (e.g., waiting on upstream math clarification) |
| **Entry criteria** | Translator or Reviewer identifies ambiguity |
| **Exit criteria** | Ambiguity resolved; re-enters `QUEUED` |
| **Responsible agent** | Orchestrator, human |

### STUCK

| Property | Value |
|----------|-------|
| **Description** | Automatic processing failed; diagnosis required |
| **Entry criteria** | Timeout, unexpected error, or unclassified failure |
| **Exit criteria** | Root cause identified; retry or escalate |
| **Responsible agent** | Orchestrator, FSMUpdater |
| **Max auto-retries** | 2 |
| **On max retries** | → `NEEDS_HUMAN` |

### NEEDS_HUMAN

| Property | Value |
|----------|-------|
| **Description** | Requires human intervention |
| **Entry criteria** | Max automatic retries exhausted, or confidence below threshold |
| **Exit criteria** | Human provides resolution |
| **Responsible agent** | Human |
| **Timeout** | None |

### PATTERN_EXTRACTED

| Property | Value |
|----------|-------|
| **Description** | Successful formalization analyzed; patterns saved to Knowledge Base |
| **Entry criteria** | Concept reaches `INTEGRATED` |
| **Exit criteria** | Patterns stored; FSM growth analysis triggered |
| **Responsible agent** | PatternLearner |
| **Timeout** | 15 min |

---

## State Priorities (for Orchestrator scheduling)

| Priority | States |
|----------|--------|
| P0 (blocking) | `FIXING`, `PROOF_GAP` — unblock in-progress concepts first |
| P1 (active) | `EXTRACTING`, `TRANSLATING`, `COMPILING`, `REVIEWING`, `VERIFYING`, `INTEGRATING` |
| P2 (ready) | `QUEUED`, `EXTRACTED`, `TRANSLATED`, `COMPILED`, `APPROVED`, `VERIFIED` |
| P3 (waiting) | `BLOCKED`, `DEFERRED`, `CHANGES_REQUESTED`, `COMPILE_ERROR`, `STUCK` |
| P4 (terminal) | `INTEGRATED`, `SKIPPED`, `NEEDS_HUMAN` |
