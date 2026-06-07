# MB-S6 Source Digest

## Source Files Checked

- `external/theory-roadmap/sources/High-Dimensional_Probability.md`
- `external/theory-roadmap/sources/Topics_in_Random_Matrix_Theory.md`
- `external/theory-roadmap/sources/Concentration_inequalities.md`
- `external/theory-roadmap/roadmap/roadmap_digest.md`
- `external/validation/matrix-bernstein-mainline-mb-s2/codebase_memory_delta.md`
- `external/validation/matrix-bernstein-mainline-mb-s5/final_report.md`
- `external/validation/matrix-bernstein-mainline-mb-s5/mathlib_laplace_survey.md`

## Relevant Source Statements

### Source Statement 1

- Path: `external/theory-roadmap/sources/High-Dimensional_Probability.md`
- Section / name: Section 5.4.3, Proof of matrix Bernstein inequality,
  Step 1: Reduction to MGF.
- Statement summary: For a symmetric matrix sum `S` and scalar `lambda >= 0`,
  the book bounds the largest-eigenvalue event by applying Markov to
  `exp(lambda * lambda_max(S))`. It then uses that the eigenvalues of
  `exp(lambda S)` are `exp(lambda * lambda_i(S))`, so
  `lambda_max(exp(lambda S)) <= tr exp(lambda S)` because all those eigenvalues
  are positive.
- Assumptions: symmetric matrix sum `S`; largest eigenvalue
  `lambda_max(S)`; scalar `lambda >= 0`; trace of the matrix exponential.
- Depends on: Markov inequality; spectral decomposition / matrix functions;
  positivity of eigenvalues of a matrix exponential; trace as sum of
  eigenvalues.
- Formalization recommendation: explicit hypothesis for the current
  HighDimProb `quadraticFormUpperTailEvent` API. The source statement is not
  directly the current event subset, and direct formalization requires
  spectral/eigenvalue machinery not yet connected in HighDimProb.

### Source Statement 2

- Path: `external/theory-roadmap/sources/High-Dimensional_Probability.md`
- Section / name: Section 4.1.2, Theorem 4.1.6, Min-max theorem for
  eigenvalues.
- Statement summary: The kth largest eigenvalue of a symmetric matrix is
  characterized by extrema of the quadratic form over unit spheres in
  subspaces. The case `k = 1` is the largest-eigenvalue/Rayleigh route.
- Assumptions: finite-dimensional real symmetric matrix; Euclidean unit
  sphere; spectral decomposition.
- Depends on: spectral decomposition; min-max theorem; unit-vector quadratic
  forms.
- Formalization recommendation: typed statement only or explicit hypothesis in
  MB-S6. HighDimProb currently records the Rayleigh/lambda-max bridge as
  typed targets, not proved theorems.

### Source Statement 3

- Path: `external/theory-roadmap/sources/Topics_in_Random_Matrix_Theory.md`
- Section / name: Theorem 1.3.1, Spectral theorem; Theorem 1.3.2,
  Courant-Fischer min-max theorem.
- Statement summary: Hermitian/self-adjoint matrices have an orthonormal
  eigenbasis with real eigenvalues, and eigenvalues satisfy Courant-Fischer
  min-max formulae over unit vectors in subspaces.
- Assumptions: finite-dimensional complex Hilbert space / Hermitian matrix;
  real symmetric case is a specialization noted by the source.
- Depends on: spectral theorem; min-max/Rayleigh quotient machinery.
- Formalization recommendation: typed statement only or explicit hypothesis in
  MB-S6. This source supports the mathematical dependency, but not a short
  direct Lean proof in the existing HighDimProb API.

### Source Statement 4

- Path: `external/validation/matrix-bernstein-mainline-mb-s2/codebase_memory_delta.md`
- Section / name: Blockers.
- Statement summary: Prior MB-S2 validation records that the endpoint/Rayleigh
  bridge from Mathlib Hermitian eigenvalues to explicit HighDimProb
  unit-vector quadratic forms is a blocker.
- Assumptions: current HighDimProb API state at MB-S2/MB-S5.
- Depends on: Mathlib Hermitian eigenvalues and HighDimProb explicit unit
  vectors.
- Formalization recommendation: do not prove the hard spectral bridge in
  MB-S6 unless an exact Mathlib API proof is found. Use an explicit hypothesis.

### Source Statement 5

- Path: `external/validation/matrix-bernstein-mainline-mb-s5/final_report.md`
- Section / name: Blockers / Exactly One Next Safe Task.
- Statement summary: MB-S5 proved only the conditional lintegral
  Markov/Laplace bridge and left the pointwise event-subset bridge from
  `quadraticFormUpperTailEvent Y t` into `traceExpThresholdEvent Y theta t`
  as the next blocker.
- Assumptions: current MB-S5 Lean API.
- Depends on: `traceExpThresholdEvent`, `quadraticFormUpperTailEvent`, and
  MB-S5 conditional theorem.
- Formalization recommendation: expose the event-subset bridge as an explicit
  hypothesis/predicate and derive conditional consequences from MB-S5.

## Facts Not Found

- No external source statement was found in the exact current API form:
  `quadraticFormUpperTailEvent Y t subset traceExpThresholdEvent Y theta t`.
- No external source statement was found that proves this current API subset
  without using spectral theorem / Rayleigh / min-max and matrix exponential
  eigenvalue machinery.
- No external source statement was found that allows proving full
  `matrixLaplaceTransformStatement` without the trace-mgf and trace-inequality
  machinery.

## Recommendation

- `USE_EXPLICIT_HYPOTHESIS`

Recommended Lean shape:

- Define an honest predicate naming the missing dominance assumption:
  `TraceExpDominatesQuadraticFormUpperTail Y theta t`.
- Optionally add a typed statement only for a future source-backed spectral
  dominance theorem under self-adjointness and nonnegative `theta`.
- Prove only tautological/conditional consequences that expose this predicate
  as an explicit hypothesis and then reuse the MB-S5 conditional theorem.
- Do not prove full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, or Matrix
  Bernstein in MB-S6.
