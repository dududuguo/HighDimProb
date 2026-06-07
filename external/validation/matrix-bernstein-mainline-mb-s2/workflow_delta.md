# MB-S2 Workflow Delta

## New Proof Pattern

Matrix Bernstein analytic work should use a bridge sprint between structural
PSD algebra and theorem proving:

1. Audit Mathlib spectral, Rayleigh, trace, and matrix exponential APIs.
2. Separate true spectral wrappers from proof-friendly quadratic-form event
   predicates.
3. Prove small definitional lemmas such as monotonicity and event inclusion.
4. Keep unproved Rayleigh, operator-norm, trace-exp, lintegral, and Laplace
   reductions as meaningful typed `abbrev ... : Prop := ...` targets.
5. Add focused API tests and judge files immediately.

## Blocker Learned

The major missing bridge is not PSD algebra anymore. The active blockers are:

- Mathlib spectral endpoint/Rayleigh APIs have to be connected to the explicit
  HighDimProb unit-vector representation.
- Trace-exp nonnegativity and lintegral conversion must be proved before the
  clean Markov/Laplace route can be promoted from statement to theorem.
- Trace-mgf inequalities remain outside the currently proved infrastructure.

## FSM / Workflow Updates

Updated:

- `external/multi-agent-system/workflows/formalize-concept.md`
- `external/multi-agent-system/fsm/growth.md`

Change:

- Added a spectral / trace-exp API audit and statement-honesty pattern for
  future matrix concentration work.

New FSM state:

- Not required yet. The existing `REUSE_SOURCE_VALIDATING` state is sufficient
  if it explicitly records spectral and trace-exp API audit artifacts.
