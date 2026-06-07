# MB-S2 Mathlib Reuse Report

## Spectral / Eigenvalue APIs

Mathlib files inspected:

- `.lake/packages/mathlib/Mathlib/Analysis/Matrix/Spectrum.lean`
- `.lake/packages/mathlib/Mathlib/Analysis/InnerProductSpace/Spectrum.lean`
- `.lake/packages/mathlib/Mathlib/Analysis/InnerProductSpace/Rayleigh.lean`

Useful APIs found:

- `Matrix.IsHermitian.eigenvalues`
- `Matrix.IsHermitian.eigenvalues₀_antitone`
- `LinearMap.IsSymmetric.eigenvalues_antitone`
- `ContinuousLinearMap.rayleighQuotient`
- `ContinuousLinearMap.norm_eq_iSup_rayleighQuotient`
- `ContinuousLinearMap.spectralRadius_eq_nnnorm`

Reuse decision:

- Keep `lambdaMax` and `lambdaMin` as narrow wrappers around
  `Matrix.IsHermitian.eigenvalues` for nonempty finite dimensions.
- Do not use them as largest/smallest eigenvalue theorems until the endpoint
  ordering and Rayleigh bridge are proved in HighDimProb terms.
- Use `QuadraticFormUpperBound`, `QuadraticFormLowerBound`, and
  `twoSidedQuadraticFormTailEvent` as proof-friendly vocabulary in the interim.

Blocker:

- The exact bridge from Mathlib Hermitian eigenvalue/Rayleigh APIs to
  HighDimProb's explicit `IsUnitVector` plus `matrixQuadraticForm` predicate
  remains unproved.

## Matrix Exponential and Trace APIs

Mathlib files inspected:

- `.lake/packages/mathlib/Mathlib/Analysis/Normed/Algebra/MatrixExponential.lean`
- matrix trace APIs through imported Mathlib matrix modules.

Useful APIs found:

- `NormedSpace.exp` on matrix algebras.
- `Matrix.IsHermitian.exp`
- `Matrix.trace`
- `Matrix.exp_conjTranspose`

Reuse decision:

- Keep HighDimProb wrappers `matrixExp`, `matrixTrace`, and `traceMatrixExp`.
- Reuse `Matrix.IsHermitian.exp` for the proved
  `isSelfAdjointMatrix_matrixExp` theorem.
- Add `traceExpMomentLIntegral` for future ENNReal Markov/Laplace arguments.

Blocker:

- No ready-made Golden-Thompson, Lieb, or trace-mgf theorem was found.
- Trace-exp nonnegativity and the real-expectation/lintegral bridge remain
  typed targets.

## Measure / Laplace APIs

Useful APIs already in use:

- `Measure`
- `ENNReal.ofReal`
- `lintegral`
- `Real.exp`
- HighDimProb tail-event and trace-exp wrappers.

Reuse decision:

- Add lintegral RHS and statement targets rather than forcing a real-valued
  expectation route before the required nonnegativity/integrability bridge is
  proved.

Blocker:

- The matrix Laplace transform theorem remains unproved. Future proof work
  needs trace-exp positivity, trace-mgf bounds, and spectral/operator-norm tail
  reductions.
