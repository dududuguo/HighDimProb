# Workflow: Formalize a Single Concept

End-to-end workflow for formalizing one concept from the theory roadmap.

## Trigger

Orchestrator selects a concept from the topological queue.

## Flow

```
┌──────────────────────────────────────────────────────────────┐
│ 1. DEPENDENCY CHECK                                          │
│    DependencyResolver checks all deps are INTEGRATED         │
│    if no → BLOCKED, return                                   │
└────────────────────────────┬─────────────────────────────────┘
                             │ deps ok
                             ▼
┌──────────────────────────────────────────────────────────────┐
│ 2. EXTRACTION                                                │
│    ConceptExtractor reads source documents                   │
│    TheoremLocator pinpoints exact theorem locations          │
│    → Produces: Formalization Manifest                        │
└────────────────────────────┬─────────────────────────────────┘
                             │ manifest
                             ▼
┌──────────────────────────────────────────────────────────────┐
│ 3. TRANSLATION                                               │
│    Translator loads context:                                 │
│      - Knowledge Base patterns & templates                   │
│      - Existing codebase style & conventions                 │
│    TemplateInstantiator pre-fills matching templates         │
│    Translator generates .lean file                           │
│    → Produces: .lean module(s)                               │
└────────────────────────────┬─────────────────────────────────┘
                             │ .lean file
                             ▼
┌──────────────────────────────────────────────────────────────┐
│ 4. COMPILATION                                               │
│    Compiler runs `lake build`                                │
│    if ok → COMPILED, go to 6                                │
│    if errors → COMPILE_ERROR, go to 5                       │
└────────────────────────────┬─────────────────────────────────┘
                             │
              ┌──────────────┴──────────────┐
              │ ok                          │ errors
              ▼                             ▼
┌──────────────────────┐    ┌──────────────────────────────────┐
│ 6. REVIEW            │    │ 5. FIXING                        │
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
│ 7a. Proof verification                                       │
│    ProofCompleter scans for `sorry`                           │
│    if none → VERIFIED                                        │
│    if sorry found → PROOF_GAP                                │
│                                                              │
│    PROOF_GAP → fill gaps → back to verification (max 5/gap)  │
│    if exhausted → NEEDS_HUMAN                                │
└────────────────────────────┬─────────────────────────────────┘
                             │ verified
                             ▼
┌──────────────────────────────────────────────────────────────┐
│ 8. INTEGRATION                                               │
│    Create branch, commit .lean file                          │
│    Run full `lake build` (all modules)                       │
│    Re-index codebase-memory graph                            │
│    Update theory roadmap status                              │
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
| Proof gap, trivial | ProofCompleter tactics | 5 | skip gap, flag |
| Proof gap, deep | Decompose → attempt sub-goals | 3 | NEEDS_HUMAN |
| Integration merge conflict | Rebase on current main | 3 | NEEDS_HUMAN |
