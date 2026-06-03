# Workflow: Formalize a Single Concept

End-to-end workflow for formalizing one concept from the theory roadmap.

This workflow is valid only as a specialization of the main repository
workflow. Every run must follow `docs/Workflow.md` exactly: read status first,
process one concept cluster only, search Mathlib before defining anything,
update project tracking docs, then run `lake build` and `lake test`.

## Trigger

Orchestrator selects a concept from the topological queue.

## Flow

```
┌──────────────────────────────────────────────────────────────┐
│ 1. REPOSITORY WORKFLOW CHECK                                 │
│    Read docs/Status.md and docs/Workflow.md                  │
│    Select exactly one concept cluster                        │
│    Search Mathlib and existing HighDimProb APIs first        │
│    if scope is too broad → DEFERRED / NEEDS_HUMAN            │
└────────────────────────────┬─────────────────────────────────┘
                             │ workflow ok
                             ▼
┌──────────────────────────────────────────────────────────────┐
│ 2. DEPENDENCY CHECK                                          │
│    DependencyResolver checks all deps are accepted in repo   │
│    if no → BLOCKED, return                                   │
└────────────────────────────┬─────────────────────────────────┘
                             │ deps ok
                             ▼
┌──────────────────────────────────────────────────────────────┐
│ 3. EXTRACTION                                                │
│    ConceptExtractor reads source documents                   │
│    TheoremLocator pinpoints exact theorem locations          │
│    → Produces: Formalization Manifest                        │
└────────────────────────────┬─────────────────────────────────┘
                             │ manifest
                             ▼
┌──────────────────────────────────────────────────────────────┐
│ 4. TRANSLATION                                               │
│    Translator loads context:                                 │
│      - Knowledge Base patterns & templates                   │
│      - Existing codebase style & conventions                 │
│      - Main repository rules and current Status              │
│    TemplateInstantiator pre-fills only trusted templates     │
│    Translator generates complete proofs, definitions, or     │
│    typed Prop statements; never placeholder theorems         │
│    → Produces: scoped patch proposal                         │
└────────────────────────────┬─────────────────────────────────┘
                             │ .lean file
                             ▼
┌──────────────────────────────────────────────────────────────┐
│ 5. COMPILATION                                               │
│    Compiler runs `lake build`                                │
│    if ok → COMPILED, go to 6                                │
│    if errors → COMPILE_ERROR, go to 5                       │
└────────────────────────────┬─────────────────────────────────┘
                             │
              ┌──────────────┴──────────────┐
              │ ok                          │ errors
              ▼                             ▼
┌──────────────────────┐    ┌──────────────────────────────────┐
│ 6. REVIEW            │    │ 5a. FIXING                       │
│                      │    │    SyntaxFixer classifies errors │
│                      │    │    Applies fix strategy           │
│                      │    │    → back to 4 (max 3 cycles)    │
│                      │    │    if exhausted → NEEDS_HUMAN    │
└──────────┬───────────┘    └──────────────────────────────────┘
           │
           ▼
┌──────────────────────────────────────────────────────────────┐
│ 6a. Parallel Review                                          │
│    ┌─────────────┐ ┌─────────────┐ ┌───────────────┐        │
│    │MathReviewer │ │StyleReviewer│ │CoverageReview.│        │
│    └──────┬──────┘ └──────┬──────┘ └───────┬───────┘        │
│           │               │                │                 │
│    ┌──────┴───────────────┴────────────────┴───────┐        │
│    │    ┌──────────────┐ ┌────────────────────┐    │        │
│    │    │DependencyRev.│ │IntegrationReviewer │    │        │
│    │    └──────────────┘ └────────────────────┘    │        │
│    └───────────────────────────────────────────────┘        │
│                                                              │
│    Orchestrator aggregates results:                          │
│    - All approved → APPROVED                                 │
│    - Any changes_requested → CHANGES_REQUESTED               │
└────────────────────────────┬─────────────────────────────────┘
                             │
              ┌──────────────┴──────────────┐
              │ approved                    │ changes_requested
              ▼                             ▼
┌──────────────────────┐    ┌──────────────────────────────────┐
│ 7. VERIFICATION      │    │ 6b. APPLY CHANGES                │
│                      │    │     Translator / Fixer apply     │
│                      │    │     review changes               │
│                      │    │     → back to 4 (max 3 cycles)  │
│                      │    │     if exhausted → NEEDS_HUMAN  │
└──────────┬───────────┘    └──────────────────────────────────┘
           │
           ▼
┌──────────────────────────────────────────────────────────────┐
│ 7a. Proof and policy verification                            │
│    ProofCompleter scans for forbidden placeholders, fake      │
│    theorems, invented APIs, and import-boundary breaches      │
│    if clean and proofs complete → VERIFIED                   │
│    if not → PROOF_GAP / CHANGES_REQUESTED                    │
│                                                              │
│    PROOF_GAP → complete proof or downgrade to typed Prop/doc │
│    if exhausted → NEEDS_HUMAN                                │
└────────────────────────────┬─────────────────────────────────┘
                             │ verified
                             ▼
┌──────────────────────────────────────────────────────────────┐
│ 8. PROJECT TRACKING AND INTEGRATION                          │
│    Update required tracking docs:                            │
│      docs/TermMap.md, docs/BookProgress.md,                  │
│      docs/AbstractionLog.md, docs/TODO.md, docs/Status.md    │
│    Add focused API/proof tests for public declarations       │
│    Run full `lake build` and `lake test`                     │
│    Optionally re-index codebase-memory graph                 │
│    Do not write to external submodules automatically         │
│    → INTEGRATED                                              │
└────────────────────────────┬─────────────────────────────────┘
                             │ integrated
                             ▼
┌──────────────────────────────────────────────────────────────┐
│ 9. LEARNING                                                  │
│    PatternLearner extracts patterns from success             │
│    FSMUpdater evaluates transition metrics                   │
│    Knowledge Base updated                                    │
│    → PATTERN_EXTRACTED → (terminal)                         │
└──────────────────────────────────────────────────────────────┘
```

## Agent Interaction Sequence

```
Orchestrator → DependencyResolver:  check_deps(concept)
  DependencyResolver → Orchestrator: {ok: true / blocked: [dep1, dep2]}

Orchestrator → ConceptExtractor:  extract(concept, source_docs)
  ConceptExtractor → TheoremLocator: locate(statement_hint)  [×N]
  TheoremLocator → ConceptExtractor: {location}              [×N]
  ConceptExtractor → Orchestrator:  {manifest}

Orchestrator → Translator:  translate(manifest)
  Translator → KnowledgeBase:  query(pattern_type, domain)    [×N]
  KnowledgeBase → Translator:  [matching patterns/templates]  [×N]
  Translator → Translator:  TemplateInstantiator.fill(template, params)  [×N]
  Translator → Orchestrator:  {lean_file_path}

Orchestrator → Compiler:  compile(lean_file_path)
  Compiler → Orchestrator:  {compile_result}

Orchestrator → SyntaxFixer:  fix(compile_result)  [if errors]
  SyntaxFixer → Orchestrator:  {fixed_file_path}
  Orchestrator → Compiler:  compile(fixed_file_path)  [retry]

Orchestrator → [MathReviewer, StyleReviewer, CoverageReviewer,
                DependencyReviewer, IntegrationReviewer]:  review(lean_file, manifest)
  [All] → Orchestrator:  {review_result}

Orchestrator → ProofCompleter:  verify(lean_file)
  ProofCompleter → Orchestrator:  {proof_status}

Orchestrator → (git):  integrate(lean_file)  [if verified]

Orchestrator → PatternLearner:  learn(concept, history)
  PatternLearner → KnowledgeBase:  store(pattern/template)
  PatternLearner → FSMUpdater:  evaluate_metrics(history)
  FSMUpdater → Orchestrator:  {growth_proposal}  [if triggered]
```

## Error Recovery Matrix

| Failure Point | Recovery | Max Retries | Escalation |
|---------------|----------|-------------|------------|
| Extraction timeout | Re-extract with narrower source scope | 2 | NEEDS_HUMAN |
| Translation produces empty file | Re-translate with different template selection | 2 | NEEDS_HUMAN |
| Compile error, known class | SyntaxFixer applies known fix | 3 | NEEDS_HUMAN |
| Compile error, unknown class | Classify → add to KB → retry | 2 | NEEDS_HUMAN |
| Review changes requested | Apply changes → re-translate | 3 | NEEDS_HUMAN |
| Proof gap, trivial | Complete the proof and recompile | 5 | convert to typed statement or NEEDS_HUMAN |
| Proof gap, deep | Decompose only if in current scope | 3 | typed statement / blocked doc entry / NEEDS_HUMAN |
| Integration conflict | Stop and ask for human direction before rebasing or merging | 1 | NEEDS_HUMAN |
