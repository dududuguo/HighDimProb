# Workflow: Fix Compile Error

Specialized workflow for the `FIXING` state. This is the most frequently
traversed recovery path, so it's optimized for speed.

## Trigger

Compiler returns non-zero exit code.

## Flow

```
┌──────────────────────────────────────────────────────────────┐
│ 1. ERROR PARSING                                             │
│    Parse `lake build` output into error list                 │
│    Each error: {line, col, class, message, context}          │
└────────────────────────────┬─────────────────────────────────┘
                             │
                             ▼
┌──────────────────────────────────────────────────────────────┐
│ 2. ERROR CLASSIFICATION                                      │
│    Match against KNOWN_ERROR_TYPES                           │
│    if all classified → proceed                               │
│    if any unclassified → log to FSMUpdater, tag as STUCK     │
└────────────────────────────┬─────────────────────────────────┘
                             │
              ┌──────────────┴──────────────┐
              │ all classified               │ any unclassified
              ▼                              ▼
┌────────────────────────────┐  ┌──────────────────────────────┐
│ 3. SELECT FIX STRATEGY     │  │ UNCLASSIFIED HANDLER         │
│    Per error class:        │  │                               │
│    - type_mismatch →       │  │ 1. Extract error pattern      │
│      insert_coercion       │  │ 2. Search KB for similar      │
│    - unknown_identifier →  │  │ 3. Attempt LLM-based fix      │
│      add_import / qualify  │  │ 4. If successful → classify   │
│    - synthesize_placeholder│  │    and add to error taxonomy   │
│      → add_instance        │  │ 5. If not → escalate to       │
│    - unsolved_goals →      │  │    NEEDS_HUMAN               │
│      fill_tactic_gap       │  │                               │
│    - import_error →        │  │                               │
│      update_lakefile       │  │                               │
│    - tactic_failure →      │  │                               │
│      replace_tactic        │  │                               │
└──────────────┬─────────────┘  └──────────────────────────────┘
               │
               ▼
┌──────────────────────────────────────────────────────────────┐
│ 4. APPLY FIXES                                               │
│    Apply fixes in dependency order (leaf errors first)       │
│    Each fix:                                                  │
│      - Edit the .lean file                                    │
│      - Record the edit in fix_history                         │
│      - Increment fix counter for this error class             │
└────────────────────────────┬─────────────────────────────────┘
                             │
                             ▼
┌──────────────────────────────────────────────────────────────┐
│ 5. RE-COMPILE                                                │
│    Run `lake build` again                                    │
│    Compare error list with previous:                         │
│      - No errors → COMPILED                                  │
│      - Fewer errors → repeat from 2 (increment cycle)        │
│      - Same errors → fix didn't work, try alternative        │
│      - New errors → regression, log & diagnose               │
│      - More errors → fix introduced new issues, revert last  │
└────────────────────────────┬─────────────────────────────────┘
                             │
              ┌──────────────┴──────────────┐
              │ no errors                   │ still errors
              ▼                             ▼
┌──────────────────────┐    ┌──────────────────────────────────┐
│ → COMPILED (exit)    │    │ Check cycles_remaining            │
│                      │    │ if > 0 → back to 2               │
│                      │    │ if = 0 → NEEDS_HUMAN             │
└──────────────────────┘    └──────────────────────────────────┘
```

## Fix History Tracking

Every fix is logged for pattern learning:

```yaml
fix_history:
  concept: "subgaussian-subexponential"
  cycle: 1
  fixes:
    - error: {class: "unknown_identifier", message: "unknown identifier 'mgfBound'"}
      strategy: add_import
      action: "Added `import HighDimProb.Concentration.MGF`"
      result: resolved
    - error: {class: "type_mismatch", line: 45, col: 12}
      strategy: insert_coercion
      action: "Changed `X` to `(X : ℝ)`"
      result: resolved
    - error: {class: "synthesize_placeholder", line: 67, col: 5}
      strategy: add_instance
      action: "Added `[MeasureSpace Ω]` to theorem arguments"
      result: resolved
  outcome: COMPILED
```

## Regression Detection

If a fix introduces new errors:

1. Revert the last fix
2. Mark it as `regression: true`
3. Try the next strategy in the priority list
4. If all strategies exhausted for this error → NEEDS_HUMAN

## Known Error Types (Seed)

| Error Class | Pattern | Strategy Priority |
|-------------|---------|-------------------|
| `type_mismatch` | `has type {A} but is expected to have type {B}` | 1. coercion 2. change signature 3. insert conversion |
| `unknown_identifier` | `unknown identifier '{name}'` | 1. add import 2. qualify name 3. define local |
| `synthesize_placeholder` | `failed to synthesize instance {Class}` | 1. add arg 2. open namespace 3. add instance |
| `unsolved_goals` | `unsolved goals: {goals}` | 1. add proof 2. add hypothesis 3. restructure theorem |
| `tactic_failure` | `{tactic} failed to find a contradiction` | 1. add hypotheses 2. use different tactic 3. restructure |
| `import_error` | `module not found` | 1. add to lakefile 2. check path 3. check spelling |
| `kernel_error` | `type mismatch in definition` | 1. check recursive calls 2. add type annotation 3. restructure |
| `structural_mismatch` | Wrong argument count / binder mismatch | 1. restructure call 2. re-translate from source |

This taxonomy grows as the FSMUpdater discovers new error classes.
