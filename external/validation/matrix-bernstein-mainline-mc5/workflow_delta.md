# Workflow Delta - MC5

Status: recorded

## Observed Pattern

MC5 confirmed that matrix concentration translation needs a dedicated Mathlib
API survey before theorem translation. Spectral and trace-exponential names are
not stable enough to assume direct theorem names such as `lambdaMax`,
Golden-Thompson, Lieb, or trace-mgf bounds.

## Proposed FSM / Workflow Learning

Add a lightweight survey guard before matrix analytic translation, either as a
new state or as an explicit checklist inside `REUSE_SOURCE_VALIDATING`.

Suggested state:

```text
MATHLIB_API_SURVEY
```

Suggested checklist items:

- `spectral_api_check`: find lambda-max/eigenvalue/Rayleigh/operator-norm
  support and decide whether the branch uses true eigenvalue wrappers or
  quadratic-form events.
- `trace_exp_api_check`: find matrix exponential, trace, trace-mgf,
  Golden-Thompson, Lieb, and Hermitian functional-calculus APIs.
- `fallback_statement_check`: if exact analytic APIs are missing, create only
  meaningful typed statements over existing objects, never `Prop := True`.

## Existing Workflow Changes Present

The repository already contains useful learned-pattern edits from the prior
matrix sprint:

- `external/multi-agent-system/fsm/growth.md` records a domain prerequisite
  pattern for structural PSD/order stages before matrix Laplace work.
- `external/multi-agent-system/workflows/formalize-concept.md` records the
  finite-sum PSD algebra proof pattern.

MC5 does not require further mandatory FSM patching beyond the proposed API
survey guard above.

## Practical Rule For Future Matrix Stages

Before attempting matrix Bernstein proper:

1. prove or wrap Rayleigh/lambda-max endpoint facts;
2. prove the self-adjoint operator-norm event reduction;
3. prove a trace-exponential comparison theorem;
4. only then translate the scalar Chernoff/Laplace calculation.
