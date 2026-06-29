# Review Agents

Review is a **multi-dimensional gate** that runs after compilation succeeds.
All review dimensions execute in **parallel**, and every dimension must return
`approved` for the concept to proceed to verification.

This gate is mandatory. A fast path may preload context, but it must not skip
math review, dependency review, placeholder checks, documentation tracking, or
the required build/test commands.

---

## MathReviewer

### Role

Verifies that the Lean4 code is **mathematically equivalent** to the source
statements. This is the highest-stakes review dimension.

### Checks

| Check | Description | Severity |
|-------|-------------|----------|
| Statement fidelity | Does the Lean4 statement match the source theorem? | Critical |
| Assumption completeness | Are all hypotheses from the source present? | Critical |
| Quantifier order | Is ∀/∃ nesting correct? | Critical |
| Index ranges | Are sum/product/sup bounds correct? | High |
| Constant factors | Are constants (1/2, √(2π), etc.) correct? | High |
| Non-emptiness | Are required non-emptiness conditions asserted? | Medium |
| Measurability | Are measurability assumptions explicit? | Medium |

### Process

1. Load source statement from extraction manifest
2. Parse Lean4 statement into AST
3. Compare: source statement ↔ Lean4 statement
   - Check term structure correspondence
   - Check bound variable correspondence
   - Check logical connective correspondence
4. Flag discrepancies with confidence scores
5. Return `approved | changes_requested` + change list

### Output

```yaml
math_review:
  status: changes_requested
  confidence: 0.72
  findings:
    - unit_id: "sg-thm-1"
      severity: High
      location: "HighDimProb/Concentration/SubGaussian.lean:45"
      issue: "Tail bound missing factor of 2 in exponent"
      source: "P(|X| ≥ t) ≤ 2 exp(-t²/(2σ²))"
      lean: "μ {ω | |X ω| ≥ t} ≤ Real.exp (-t^2 / (σ^2))"
      fix: "Change σ^2 to 2*σ^2 in denominator"
    - unit_id: "sg-def-1"
      severity: Critical
      location: "HighDimProb/Concentration/SubGaussian.lean:12"
      issue: "Quantifier for λ: source says ∀λ>0, Lean has ∀λ"
      source: "for all λ > 0"
      lean: "∀ λ : ℝ"
      fix: "Add hypothesis hλpos : λ > 0"
  approved_units: ["sg-prop-1"]
```

---

## StyleReviewer

### Role

Ensures code follows project conventions: naming, formatting, structure,
and idiom usage.

### Checks

| Check | Description | Severity |
|-------|-------------|----------|
| Naming convention | PascalCase/UpperCamelCase for theorems/definitions? | High |
| Module docstring | Is there a `/-! ... -/` module docstring? | Medium |
| Theorem docstring | Is every theorem/definition documented with `/-- ... -/`? | Medium |
| Namespace usage | Is `namespace` properly scoped? | Medium |
| Open scoping | Are `open` commands appropriately scoped? | Low |
| Line length | ≤ 100 characters? | Low |
| No placeholders | No `sorry`, `admit`, axioms, or fake theorem declarations anywhere | Critical |
| Explicit arguments | Are typeclass arguments explicit vs implicit? | Low |

### Process

1. Load project style guide (`ORGANISATION.md`, `CONTRIBUTING.md`)
2. Lint the `.lean` file for each check
3. Compare naming against existing codebase patterns with lean-local-search
4. Return `approved | changes_requested` + style fixes

---

## CoverageReviewer

### Role

Checks that all units in the extraction manifest are present in the generated
Lean4 code. No missing theorems, no missing definitions.

### Checks

| Check | Description | Severity |
|-------|-------------|----------|
| Manifest completeness | All manifest units have a corresponding Lean4 declaration | Critical |
| Proof coverage | Theorems have complete proofs; unproved results are typed `Prop` specs or docs | Critical |
| Extra definitions | Does the Lean code define things not in the manifest? | Low |
| Missing corollaries | Were corollaries skipped? | Medium |

### Process

1. Diff extraction manifest against Lean4 declarations
2. Report `missing`, `extra`, and `matched` units
3. For missing units, check if they were intentionally deferred

---

## DependencyReviewer

### Role

Ensures the module's import structure is correct and minimal.

### Checks

| Check | Description | Severity |
|-------|-------------|----------|
| Required imports present | All used symbols are imported | Critical |
| No unused imports | No imports for unused modules | Low |
| Circular dependency | Would this module create an import cycle? | Critical |
| Aggregate/import tests updated | Are root/branch aggregates and tests updated when needed? | High |
| Dependency order | Do imports follow project convention (outer→inner)? | Low |

### Process

1. Extract all free variables/symbols in the module
2. Resolve each to its defining module via lean-local-search
3. Check: imported modules ⊇ defining modules of all used symbols
4. Check: no import cycle using the Lean import graph and indexed imports

---

## IntegrationReviewer

### Role

Checks consistency with the existing codebase: no duplicate definitions,
no conflicting theorems, no naming collisions.

### Checks

| Check | Description | Severity |
|-------|-------------|----------|
| Name uniqueness | No declaration name collision with existing codebase | Critical |
| Statement consistency | If a theorem exists, does the new version match? | Critical |
| Typeclass coherence | Does this module's typeclass usage match existing patterns? | High |
| Notation compatibility | Do new notations conflict with existing ones? | High |
| Proof reuse | Can existing lemmas be used instead of re-proving? | Low |

### Process

1. Query lean-local-search: `search_graph(name_pattern="{name}")` for each declaration
2. For name collisions:
   - If statements are equivalent → avoid duplicate declaration
   - If statements differ → flag as conflict
3. Check notation declarations against lean-local-search and source search

---

## Review Aggregation

The Orchestrator collects all review results:

```yaml
aggregated_review:
  concept: "subgaussian-subexponential"
  dimensions:
    math_review: changes_requested
    style_review: approved
    coverage_review: approved
    dependency_review: approved
    integration_review: approved
  decision: changes_requested
  change_list:
    - {reviewer: MathReviewer, unit: "sg-thm-1", severity: High, fix: "..."}
    - {reviewer: MathReviewer, unit: "sg-def-1", severity: Critical, fix: "..."}
  next_state: CHANGES_REQUESTED
```

Decision rule:
- Any Critical severity finding -> `CHANGES_REQUESTED`
- Any placeholder, invented API, unproved theorem, stable/experimental boundary
  breach, or failed build/test -> `CHANGES_REQUESTED`
- Low-severity style findings may be warnings only when they do not affect
  mathematics, API boundaries, or repository policy
- All dimensions return `approved` -> `APPROVED`
