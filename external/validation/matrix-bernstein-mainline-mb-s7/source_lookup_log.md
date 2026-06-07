# MB-S7.0 Source Lookup Log

FSM path:

- `SOURCE_EXTRACTING -> REVIEWING -> SOURCE_READY`

Searches performed:

- Repository source search for Matrix Bernstein, Laplace, trace exponential,
  largest eigenvalue, Rayleigh, Golden-Thompson, Lieb, and Chernoff.
- Mathlib local search for Rayleigh quotient, min-max, eigenvalue trace,
  matrix exponential eigenvalue, and PSD trace APIs.
- HighDimProb API search for `TraceExpDominatesQuadraticFormUpperTail`,
  `traceExpThresholdEvent`, `quadraticFormUpperTailEvent`, `lambdaMax`, and
  related statement wrappers.

Key source locations:

- `High-Dimensional_Probability.md:4609`: min-max theorem statement.
- `High-Dimensional_Probability.md:4709`: self-adjoint operator norm via
  eigenvalues / unit quadratic forms.
- `High-Dimensional_Probability.md:6968-6999`: Matrix Bernstein proof Step 1,
  MGF reduction through largest eigenvalue and trace exponential.
- `Topics_in_Random_Matrix_Theory.md:1058`: Rayleigh formula for the largest
  eigenvalue.
- `Topics_in_Random_Matrix_Theory.md:1097`: spectral theorem.
- `Topics_in_Random_Matrix_Theory.md:1123`: Courant-Fischer min-max theorem.

Key Mathlib candidates:

- `Mathlib/Analysis/InnerProductSpace/Rayleigh.lean`
- `Mathlib/Analysis/Matrix/Spectrum.lean`
- `Mathlib/Analysis/Matrix/PosDef.lean`
- `Mathlib/Analysis/InnerProductSpace/Trace.lean`

Conclusion:

- The mathematics is source-backed, but the direct current-API Lean proof needs
  a nontrivial bridge from HighDimProb explicit matrix/vector quadratic forms
  to Mathlib Rayleigh/eigenvalue APIs. No Lean source was edited.
