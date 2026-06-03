# Translation Agents

## Translator

### Role

Converts mathematical statements from the extraction manifest into Lean4 code
only when the result is honest under the main HighDimProb rules. Translation is
not allowed to manufacture unproved theorems or new canonical APIs.

### Inputs

- Extraction manifest (from ConceptExtractor)
- Knowledge Base patterns and templates
- Existing codebase modules (for naming/style consistency)

### Process

1. **Load context**: Read `docs/Workflow.md`, `docs/Status.md`, `README.md`,
   `ORGANISATION.md`, and the relevant existing Lean modules before translating
2. **Prioritize**: Process reusable vocabulary and small bridge lemmas first;
   classify theorem-heavy units as `typed-prop`, `blocked`, or `future` unless
   the full proof is already available
3. **For each unit**:
   a. Query Knowledge Base for matching templates
   b. Select existing Mathlib/HighDimProb objects and typeclasses
   c. Translate to one of: a definition, a complete theorem proof, a typed
      `Prop` statement specification, or a documentation-only blocked entry
   d. Reject any translation that would need `sorry`, `admit`, or an axiom
   e. Insert the smallest existing imports needed for the chosen module
4. **Assemble**: Keep edits inside the current branch/module policy. Do not
   invent `HighDimProb.H.*` modules in the main Lean tree.
5. **Check**: Run the relevant Lean module build, then full `lake build` and
   `lake test` before the work can be accepted.

### Translation Heuristics

| Math Pattern | Lean4 Pattern |
|--------------|---------------|
| E[X] (expectation) | Existing `expect P X` wrapper or Mathlib integral |
| P(E) (probability) | Existing event/tail wrappers such as `absTailProb` |
| Lp norm | Existing `realLpNorm` / Mathlib `eLpNorm` wrappers |
| subGaussian forms | Existing `SubGaussianTail`, `SubGaussianMoment`, `CenteredSubGaussianMGF`, `SubGaussianOrlicz` |
| sup_{x∈S} | `⨆ x ∈ S, ...` |
| exp(λX) | `Real.exp (λ * X)` |
| i.i.d. | Existing Mathlib independence API or HighDimProb assumption wrappers |

### Output

A patch against an existing or explicitly approved module path, e.g.
`HighDimProb/SubGaussian.lean` for stable predicate vocabulary or
`HighDimProb/Concentration/MGF.lean` for experimental proof bridges.

Permitted structure for a proved theorem:
```lean4
import HighDimProb.Concentration.MGF

/-!
# MGF implication example
-/

namespace HighDimProb

-- A theorem declaration is allowed only when the proof term is complete.
#check subGaussianTail_of_centeredSubGaussianMGF

end HighDimProb
```

Permitted structure for a theorem that is not ready:

```lean4
/-- Typed target only; not a theorem placeholder. -/
abbrev boundedCenteredHoeffdingStatement ... : Prop :=
  ...
```

### Interaction with Knowledge Base

Before translating, the Translator queries the Knowledge Base:

```
QUERY: "subGaussian predicate form"
RESULT: pattern_id="sg-existing-forms", confidence=0.99
        → use the existing formulation-specific predicates; do not create
          a canonical `SubGaussian` name

QUERY: "tail bound from MGF bound"
RESULT: pattern_id="mgf-tail-proof-3", confidence=0.88, usage_count=7
        → first search for existing theorems such as
          `subGaussianTail_of_centeredSubGaussianMGF`; prove a new theorem only
          if the proof is complete and in scope
```

---

## TemplateInstantiator

### Role

Applies known templates from the Knowledge Base to accelerate translation.
Reduces the Translator's work from "generate from scratch" to "instantiate parameters."

### Inputs

- Unit from extraction manifest
- Matching template from Knowledge Base
- Parameter mapping (math symbols → Lean4 identifiers)

### Process

1. Match unit type and signature against template library
2. If match confidence > 0.8, instantiate template with concrete parameters
3. Reject templates that introduce forbidden placeholders, invented APIs, or
   module paths outside the current branch policy
4. Adjust imports based on existing modules only
5. Return instantiated code to Translator for review and assembly

### Template Example

```yaml
template:
  id: "mgf-tail-proof-3"
  description: "Chernoff bound: MGF control → exponential tail"
  applicability:
    unit_type: theorem
    statement_pattern: "P(X ≥ t) ≤ ... exp(...)"
    requires:
      - mgf_bound: "E[exp(λX)] ≤ exp(...)"
  code_template: |
    -- This template is usable only when `{complete_proof}` is a real proof,
    -- not a placeholder.
    theorem {name} {params} : {conclusion} := by
      have h_mgf : ∀ λ > 0, ∫ exp (λ * {X}) ∂μ ≤ exp ({mgf_bound}) := {mgf_proof}
      exact {complete_proof}
  parameters:
    - name: String
    - params: List (Name × Type)
    - conclusion: Term
    - X: Term
    - mgf_bound: Term
    - mgf_proof: Term
    - t: Term
    - complete_proof: Term
```
