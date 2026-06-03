# Extraction Agents

## ConceptExtractor

### Role

Reads source documents and produces a **formalization manifest** — a structured
list of all theorems, definitions, lemmas, and corollaries that need to be
translated into Lean4 for a given concept.

### Inputs

- Source documents (markdown) from `external/theory-roadmap/sources/`
- Concept descriptor from topology sort
- Source location hints from `roadmap/roadmap_digest.md`

### Process

1. Load the source documents relevant to the concept
2. Scan for theorem/lemma/proposition/definition environments
3. For each result found:
   - Extract the statement
   - Identify assumptions and conclusions
   - Note any cross-references
   - Hash the statement for deduplication
4. Classify each unit:
   - `definition` — defines a new mathematical object
   - `theorem` — main result requiring proof
   - `lemma` — auxiliary result
   - `corollary` — direct consequence
   - `proposition` — intermediate result
5. Assign priority within the concept:
   - P0: definitions (needed by everything else)
   - P1: lemmas used by multiple theorems
   - P2: main theorems
   - P3: corollaries

### Output: Formalization Manifest

```yaml
manifest:
  concept: "subgaussian-subexponential"
  lean_module: "HighDimProb.H.Concentration.SubGaussian"
  generated_at: "2026-06-03T..."
  source_documents:
    - "Concentration_inequalities.md"
    - "High-Dimensional_Probability.md"
  units:
    - id: "sg-def-1"
      type: definition
      statement: "A random variable X is subGaussian if E[exp(λX)] ≤ exp(λ²σ²/2) for all λ"
      source_location: "Concentration_inequalities.md:5120-5140"
      dependencies: []  # within this concept
      priority: P0
      statement_hash: "sha256:..."

    - id: "sg-thm-1"
      type: theorem
      statement: "SubGaussian tail bound: P(|X| ≥ t) ≤ 2 exp(-t²/(2σ²))"
      source_location: "Concentration_inequalities.md:5145-5170"
      dependencies: ["sg-def-1"]
      priority: P1
      statement_hash: "sha256:..."

    - id: "sg-prop-1"
      type: proposition
      statement: "Sum of independent subGaussian RVs is subGaussian"
      source_location: "High-Dimensional_Probability.md:3200-3230"
      dependencies: ["sg-def-1"]
      priority: P2
      statement_hash: "sha256:..."
```

### Success Criteria

- All units have resolvable source locations
- All intra-concept dependencies are acyclic
- Statement hashes are unique (no duplicates)

---

## TheoremLocator

### Role

Precise location of theorems within source documents.
Used when the ConceptExtractor needs to drill down on a specific location.

### Inputs

- Source document path
- Theorem keyword or statement substring
- Optional: approximate line range

### Process

1. Search source document for theorem-like environments
2. Extract preamble (assumptions) and conclusion
3. Identify referenced theorems/definitions
4. Return precise byte offsets

### Output

```yaml
location:
  source: "Concentration_inequalities.md"
  byte_start: 5120
  byte_end: 5170
  line_start: 142
  line_end: 148
  context_before: "Theorem 2.1 (SubGaussian tail bound). Let X be..."
  statement: "P(|X| ≥ t) ≤ 2 exp(-t²/(2σ²))"
  referenced_concepts: ["subGaussian", "tail probability"]
```
