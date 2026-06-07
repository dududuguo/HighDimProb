# MB-S6 Source Lookup Log

## Files Enumerated

- `external/theory-roadmap/sources/High-Dimensional_Probability.md`
- `external/theory-roadmap/sources/Topics_in_Random_Matrix_Theory.md`
- `external/theory-roadmap/sources/Concentration_inequalities.md`
- `external/theory-roadmap/roadmap/roadmap_digest.md`
- Prior validation notes under `external/validation/matrix-bernstein-mainline-mb-s2`
  through `external/validation/matrix-bernstein-mainline-mb-s5`

## Keyword Searches

- `matrix bernstein`
- `matrix laplace`
- `trace exponential`
- `trace exp`
- `lambda max`
- `largest eigenvalue`
- `quadratic form`
- `rayleigh`
- `min-max`
- `Golden-Thompson`
- `Lieb`

## Source Excerpts Read

- `external/theory-roadmap/sources/High-Dimensional_Probability.md`,
  around lines 6824-7050:
  - Section 5.4, Matrix Bernstein inequality.
  - Section 5.4.1, matrix calculus and Loewner order.
  - Section 5.4.2, trace inequalities.
  - Section 5.4.3, proof of matrix Bernstein, Step 1.
- `external/theory-roadmap/sources/High-Dimensional_Probability.md`,
  around lines 4560-4710:
  - Section 4.1.2, min-max theorem.
  - Section 4.1.4, matrix norms and spectrum.
- `external/theory-roadmap/sources/Topics_in_Random_Matrix_Theory.md`,
  around lines 1090-1175:
  - Theorem 1.3.1, spectral theorem.
  - Theorem 1.3.2, Courant-Fischer min-max theorem.
- `external/theory-roadmap/roadmap/roadmap_digest.md`, around lines 815-950:
  - Roadmap headings locating Section 5.4 Matrix Bernstein inequality and
    trace inequalities in the source.
- `external/validation/matrix-bernstein-mainline-mb-s2/codebase_memory_delta.md`:
  - Existing blockers for endpoint/Rayleigh bridge and trace-mgf machinery.
- `external/validation/matrix-bernstein-mainline-mb-s5/final_report.md`:
  - MB-S5 conditional bridge status and remaining event-subset blocker.

## Search Result

- Found source support for the book-level largest-eigenvalue route:
  `P {lambda_max(S) >= t}` is bounded by Markov, and
  `lambda_max(exp(lambda S))` is bounded by `tr exp(lambda S)`.
- Found source support for the spectral/min-max background connecting largest
  eigenvalues and unit-vector quadratic forms.
- Did not find a source statement phrased directly as the current HighDimProb
  API event subset
  `quadraticFormUpperTailEvent Y t subset traceExpThresholdEvent Y theta t`.
- Did not find source support for proving this subset without spectral theorem,
  Rayleigh/min-max, and matrix-function eigenvalue/trace machinery.
