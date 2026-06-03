# Verification Agents

## Compiler

### Role

Runs `lake build` on the module and captures the full error/warning output.

### Process

1. Ensure module is registered in `lakefile.lean`
2. Run `lake build HighDimProb.Concentration.SubGaussian`
3. Parse output:
   - Exit code 0 → `COMPILED`
   - Exit code ≠ 0 → `COMPILE_ERROR`, extract error list
4. Classify each error (see error taxonomy below)

### Error Taxonomy

| Error Class | Example | Typical Fix Agent |
|-------------|---------|-------------------|
| `type_mismatch` | `has type ℝ but is expected to have type ℕ` | SyntaxFixer |
| `unknown_identifier` | `unknown identifier 'subGaussian'` | SyntaxFixer (add import) |
| `synthesize_placeholder` | `failed to synthesize instance ToAdd` | SyntaxFixer |
| `unsolved_goals` | `unsolved goals: ⊢ 0 < σ` | ProofCompleter |
| `structural_mismatch` | Wrong number of arguments | Translator (re-translate) |
| `tactic_failure` | `linarith failed to find a contradiction` | ProofCompleter |
| `kernel_error` | Definitional equality failure | Translator |
| `import_error` | Module not found in lakefile | DependencyReviewer |
| `unclassified` | Unknown error pattern | FSMUpdater (learn new error type) |

### Output

```yaml
compile_result:
  status: compile_error
  exit_code: 1
  errors:
    - line: 45
      column: 12
      class: type_mismatch
      message: "has type ℝ but is expected to have type ℕ"
      context: "..."
      confidence_in_classification: 0.95
    - line: 67
      column: 5
      class: unknown_identifier
      message: "unknown identifier 'mgfExpectation'"
      context: "..."
      confidence_in_classification: 0.99
  warnings:
    - line: 23
      message: "unused variable `h`"
      class: unused_variable
```

---

## SyntaxFixer

### Role

Fixes compilation errors that are syntactic or type-level (not proof gaps).

### Strategy by Error Class

| Error Class | Fix Strategy |
|-------------|-------------|
| `type_mismatch` | Insert explicit type coercion (`(X : ℝ)`) |
| `unknown_identifier` | Add missing `import` or qualify name |
| `synthesize_placeholder` | Add typeclass instance argument, or open namespace |
| `unknown_identifier` (typo) | Fuzzy-match against known identifiers (codebase-memory), suggest correction |

### Process

1. For each error in the compile result:
   a. If error class has a known fix strategy, apply it
   b. If not, attempt LLM-based fix with 3 attempts
2. Write fixed file
3. Return for re-compilation

### Max Retries

- Per error class: 3 attempts
- Total fixing cycles: 5 per concept
- After exhaustion → `NEEDS_HUMAN`

---

## ProofCompleter

### Role

Fills in `sorry` gaps in proofs. Triggered at `VERIFYING` state.

### Process

1. Scan module for `sorry` and `admit`
2. For each gap:
   a. Extract the goal type
   b. Extract the local context (hypotheses available)
   c. Search Knowledge Base for similar proof patterns
   d. Attempt to fill using tactic synthesis
   e. If gap has nested `sorry`, recurse from innermost
3. Re-compile to verify
4. Repeat until `sorry` count is 0 or retries exhausted

### Gap Prioritization

| Gap Type | Priority | Strategy |
|----------|----------|----------|
| Trivial (e.g., `0 ≤ σ` from `hσ : σ > 0`) | P0 | `apply` or `linarith` |
| Structural (e.g., unpack a definition) | P1 | `unfold` + `simp` |
| Algebraic (e.g., re-arrange inequality) | P2 | `nlinarith` or `positivity` |
| Analytical (e.g., integral bound) | P3 | Decompose with known lemmas |
| Deep (e.g., novel proof idea needed) | P4 | `NEEDS_HUMAN` |

### Max Cycles

- 3 cycles per concept
- 5 attempts per individual gap
- After exhaustion → `NEEDS_HUMAN`

### Output

```yaml
proof_status:
  status: proof_gap
  sorry_count: 3
  admit_count: 0
  gaps:
    - location: "SubGaussian.lean:78:4"
      goal: "∫ exp (λ * X) ∂μ ≤ exp (λ^2 * σ^2 / 2)"
      context: ["hX : IsSubGaussian X σ", "hλpos : λ > 0"]
      attempts: 2
      max_attempts: 5
      difficulty: "analytical"
      suggestion: "Use `hX` definition and non-negativity of exp"
```
