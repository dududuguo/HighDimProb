# Mathlib Reuse Report - MC5

## Spectral / Eigenvalue APIs

Useful Mathlib files found:

- `Mathlib.Analysis.Matrix.Spectrum`
- `Mathlib.Analysis.Matrix.PosDef`
- `Mathlib.Analysis.InnerProductSpace.Rayleigh`
- `Mathlib.Analysis.CStarAlgebra.Matrix`

Relevant APIs observed:

- Hermitian matrix eigenvalues:
  - `Matrix.IsHermitian.eigenvalues`
  - `Matrix.IsHermitian.eigenvalues₀`
  - `Matrix.IsHermitian.eigenvalues_mem_spectrum_real`
  - `Matrix.IsHermitian.spectrum_real_eq_range_eigenvalues`
- PSD/eigenvalue bridge:
  - `Matrix.IsHermitian.posSemidef_iff_eigenvalues_nonneg`
  - `Matrix.IsHermitian.eigenvalues_nonneg`
- Spectral-radius / norm bridge for self-adjoint operators:
  - `IsSelfAdjoint.spectralRadius_eq_nnnorm`
  - `IsSelfAdjoint.toReal_spectralRadius_eq_norm`
- Rayleigh quotient infrastructure:
  - `rayleighQuotient`
  - finite-dimensional self-adjoint max/min Rayleigh quotient APIs.

Direct `lambdaMax` / `lambdaMin` wrapper names were not found. The likely path is to wrap Hermitian eigenvalues for nonempty finite dimensions or use proof-friendly quadratic-form bound predicates.

## Operator Norm APIs

Useful Mathlib files found:

- `Mathlib.Analysis.CStarAlgebra.Matrix`
- `Mathlib.Analysis.Normed.Operator.Matrix`

Relevant APIs observed:

- `Matrix.Norms.L2Operator` scoped norm instance.
- `Matrix.l2_opNorm_def`
- `Matrix.l2_opNorm_mulVec`
- `Matrix.l2_opNorm_mul`
- `Matrix.toLpLin`
- `Matrix.toEuclideanLin`
- `ContinuousLinearMap.opNorm`

The project already bridges its explicit unit-vector predicate to Mathlib's L2 operator norm in `HighDimProb/RandomMatrix/OperatorNorm.lean`.

## Trace / Matrix Exponential APIs

Useful Mathlib files found:

- `Mathlib.Analysis.Normed.Algebra.MatrixExponential`
- `Mathlib.LinearAlgebra.Matrix.Trace`
- `Mathlib.Analysis.Matrix.Spectrum`
- `Mathlib.Analysis.Matrix.Order`
- `Mathlib.Analysis.Matrix.HermitianFunctionalCalculus`

Relevant APIs observed:

- `NormedSpace.exp` on matrices.
- `Matrix.exp_conjTranspose`
- `Matrix.IsHermitian.exp`
- `Matrix.exp_add_of_commute`
- `Matrix.exp_sum_of_commute`
- `Matrix.trace`
- `Matrix.traceLinearMap`
- `Matrix.trace_sum`
- `Matrix.trace_mul_comm`
- `Matrix.trace_mul_cycle`
- Hermitian trace/eigenvalue relation: `Matrix.IsHermitian.trace_eq_sum_eigenvalues`
- Hermitian continuous functional calculus is available and may support defining a matrix exponential for self-adjoint matrices.

The direct matrix exponential route is available through `NormedSpace.exp` plus
the matrix-exponential lemmas above. Broad search did not find a named
Golden-Thompson theorem, Lieb theorem, or ready-made matrix trace-mgf theorem.
MC5.2 therefore wraps matrix exponential and trace-exponential moments, while
leaving the analytic trace-mgf inequalities as typed targets or proof-plan
blockers.

## Laplace / Chernoff APIs

Useful existing project APIs reused:

- `RandomSelfAdjointMatrix`
- `quadraticFormUpperTailEvent`
- `SelfAdjointOperatorNormTailEvent`
- `traceExpMoment`
- `ENNReal.ofReal`
- `Measure` applied to measurable-set-style event predicates

Mathlib supplies scalar `Real.exp` and measure-valued inequalities, but MC5 did
not find a ready matrix Laplace transform theorem or trace Chernoff theorem for
random self-adjoint matrices.

MC5 therefore adds meaningful typed statements:

- `matrixLaplaceTransformStatement`
- `matrixChernoffFromTraceExpStatement`
- `selfAdjointOperatorNormLaplaceStatement`

These statements are deliberately phrased over the existing quadratic-form
event vocabulary until the lambda-max/Rayleigh bridge is proved.
