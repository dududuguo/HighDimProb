# Translation Agents

## Translator

### Role

Converts mathematical statements from the extraction manifest into Lean4 code.

### Inputs

- Extraction manifest (from ConceptExtractor)
- Knowledge Base patterns and templates
- Existing codebase modules (for naming/style consistency)

### Process

1. **Load context**: Read existing Lean4 modules for naming conventions, typeclass usage, and proof style
2. **Prioritize**: Process `definition` units first, then `lemma`, then `theorem`
3. **For each unit**:
   a. Query Knowledge Base for matching templates
   b. Select typeclass hierarchy (e.g., `ℝ`, `TopologicalSpace`, `MeasureSpace`)
   c. Translate statement to Lean4 term
   d. Generate proof skeleton (may contain `sorry` placeholders)
   e. Insert module-level imports
4. **Assemble**: Combine all units into a single `.lean` file
5. **Syntax check**: Run `lean --syntax-only` before handing off to Compiler

### Translation Heuristics

| Math Pattern | Lean4 Pattern |
|--------------|---------------|
| E[X] (expectation) | `∫ x ∂μ` or custom `expect` notation |
| P(E) (probability) | `μ {ω | E ω}` |
| ‖X‖ₚ (Lp norm) | `‖X‖_[p]` or `lpNorm p X` |
| X ∼ N(0,σ²) | `X : Gaussian μ σ²` (custom typeclass) |
| sup_{x∈S} | `⨆ x ∈ S, ...` |
| exp(λX) | `Real.exp (λ * X)` |
| i.i.d. | Custom `IID` typeclass/bundle |

### Output

A `.lean` file at the appropriate module path, e.g.:
`HighDimProb/Concentration/SubGaussian.lean`

With structure:
```lean4
import HighDimProb.Probability.MomentsOrlicz
import HighDimProb.Concentration.Basic

/-!
# SubGaussian Random Variables

[module docstring from source]
-/

open Set Real MeasureTheory

namespace HighDimProb

/-- A random variable X is subGaussian if ... -/
def IsSubGaussian (X : Ω → ℝ) (σ : ℝ) : Prop :=
  ...

theorem subGaussian_tail_bound (X : Ω → ℝ) (h : IsSubGaussian X σ) (t : ℝ) :
    μ {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t^2 / (2 * σ^2)) := by
  -- proof skeleton
  sorry

end HighDimProb
```

### Interaction with Knowledge Base

Before translating, the Translator queries the Knowledge Base:

```
QUERY: "subGaussian definition template"
RESULT: pattern_id="sg-def-template-1", confidence=0.92, usage_count=4
        → use `IsSubGaussian` predicate with `∀ λ, ∫ exp (λ * X) ∂μ ≤ exp (λ^2 * σ^2 / 2)`

QUERY: "tail bound from MGF bound"
RESULT: pattern_id="mgf-tail-proof-3", confidence=0.88, usage_count=7
        → apply Chernoff bounding technique: P(X ≥ t) ≤ inf_{λ>0} exp(-λt) E[exp(λX)]
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
3. Adjust imports based on template requirements
4. Return instantiated code to Translator for review and assembly

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
    theorem {name} {params} : {conclusion} := by
      have h_mgf : ∀ λ > 0, ∫ exp (λ * {X}) ∂μ ≤ exp ({mgf_bound}) := {mgf_proof}
      apply chernoffBound {X} h_mgf {t}
      -- {TODO: fill constant factors}
      sorry
  parameters:
    - name: String
    - params: List (Name × Type)
    - conclusion: Term
    - X: Term
    - mgf_bound: Term
    - mgf_proof: Term
    - t: Term
```
