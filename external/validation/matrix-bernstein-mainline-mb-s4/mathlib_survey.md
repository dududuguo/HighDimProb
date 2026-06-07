# MB-S4 Mathlib Survey

## Target

```lean
theorem matrixExp_posSemidef_of_selfAdjoint {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real}
    (hA : IsSelfAdjointMatrix A) :
    Matrix.PosSemidef (matrixExp A)
```

## Current HighDimProb API

- `IsSelfAdjointMatrix A` is an abbrev for `A.IsHermitian` in
  `HighDimProb.RandomMatrix.SelfAdjoint`.
- `matrixExp A` is `NormedSpace.exp A` in
  `HighDimProb.RandomMatrix.TraceExp`.
- Existing theorem:
  `isSelfAdjointMatrix_matrixExp :
    IsSelfAdjointMatrix A -> IsSelfAdjointMatrix (matrixExp A)`,
  proved by `Matrix.IsHermitian.exp`.
- Existing trace bridge:
  `matrixTrace_nonneg_of_posSemidef :
    Matrix.PosSemidef A -> 0 <= matrixTrace A`.
- Existing trace-exp bridge:
  `traceMatrixExp_nonneg_of_matrixExp_posSemidef :
    Matrix.PosSemidef (matrixExp A) -> 0 <= traceMatrixExp A`.
- Existing target abbreviations:
  `matrixExp_posSemidef_of_selfAdjoint_statement` and
  `traceMatrixExp_nonneg_of_selfAdjoint_statement`.
- HighDimProb `IsPSDMatrix` is separate from Mathlib `Matrix.PosSemidef`;
  no local bridge between them was found.

## Direct Mathlib APIs Found

- `Matrix.IsHermitian.exp`:
  `(NormedSpace.exp A).IsHermitian` from `A.IsHermitian`.
- `IsSelfAdjoint.exp_nonneg`:
  `0 <= NormedSpace.exp a` from `IsSelfAdjoint a`.
- `Matrix.LE.le.posSemidef`:
  `0 <= A -> A.PosSemidef`.
- `Matrix.nonneg_iff_posSemidef`:
  `0 <= A <-> A.PosSemidef`.
- `Matrix.PosSemidef.nonneg`:
  `A.PosSemidef -> 0 <= A`.
- `Matrix.PosSemidef.trace_nonneg`:
  `A.PosSemidef -> 0 <= A.trace`.
- `Matrix.IsHermitian.isSelfAdjoint`:
  converts `A.IsHermitian` to root `IsSelfAdjoint A`.
- `IsSelfAdjoint.isHermitian`:
  converts root `IsSelfAdjoint A` back to `A.IsHermitian`.

## CFC / Order APIs

- `CFC.real_exp_eq_normedSpace_exp`:
  `cfc Real.exp a = NormedSpace.exp a`.
- `CFC.exp_eq_normedSpace_exp`:
  general RCLike version for `cfc NormedSpace.exp`.
- `cfc_nonneg`:
  proves `0 <= cfc f a` from pointwise nonnegativity on the spectrum.
- `cfc_nonneg_iff`:
  order iff for functional calculus values.
- `Matrix.instPreOrder`, `Matrix.instPartialOrder`,
  `Matrix.instStarOrderedRing`, and `Matrix.instNonnegSpectrumClass` are
  scoped under `MatrixOrder`.

## Matrix Exponential APIs

Checked from `Mathlib.Analysis.Normed.Algebra.MatrixExponential`:

- `Matrix.exp_conjTranspose`
- `Matrix.IsHermitian.exp`
- `Matrix.exp_add_of_commute`
- `Matrix.exp_sum_of_commute`
- `Matrix.exp_nsmul`
- `Matrix.exp_zsmul`
- `Matrix.exp_units_conj`
- `Matrix.exp_units_conj'`
- `Matrix.exp_conj`
- `Matrix.exp_conj'`
- `Matrix.exp_neg`
- `Matrix.isUnit_exp`

These are useful for fallback/spectral routes, but not needed for the shortest
PSD bridge.

## PSD / Gram APIs

Checked from `Mathlib.LinearAlgebra.Matrix.PosDef` and
`Mathlib.Analysis.Matrix.PosDef`:

- `Matrix.posSemidef_iff_dotProduct_mulVec`
- `Matrix.PosSemidef.of_dotProduct_mulVec_nonneg`
- `Matrix.PosSemidef.dotProduct_mulVec_nonneg`
- `Matrix.posSemidef_conjTranspose_mul_self`
- `Matrix.posSemidef_self_mul_conjTranspose`
- `Matrix.PosSemidef.conjTranspose_mul_mul_same`
- `Matrix.PosSemidef.mul_mul_conjTranspose_same`
- `Matrix.PosSemidef.eigenvalues_nonneg`
- `Matrix.IsHermitian.posSemidef_iff_eigenvalues_nonneg`
- `Matrix.posSemidef_iff_isHermitian_and_spectrum_nonneg`

## `toLin` / Operator APIs

Checked but not needed for the shortest route:

- `Matrix.toLin_conjTranspose`
- `LinearMap.toMatrix_adjoint`
- `LinearMap.toMatrixOrthonormal`
- `Matrix.isPositive_toEuclideanLin_iff`
- `LinearMap.posSemidef_toMatrix_iff`
- `LinearMap.nonneg_iff_isPositive`
- `LinearMap.le_def`
- `ContinuousLinearMap.nonneg_iff_isPositive`
- `ContinuousLinearMap.le_def`
- `ContinuousLinearMap.isSelfAdjoint_iff_isSymmetric`
- `LinearMap.isSelfAdjoint_toContinuousLinearMap_iff`
- `ContinuousLinearMap.isSelfAdjoint_toLinearMap_iff`

## Minimal Imports Tested

Standalone target proof checked with:

```lean
import Mathlib.Analysis.Matrix.Normed
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.ExpLog.Basic
```

The HighDimProb-shaped probe also checked with the current exponential import:

```lean
import Mathlib.Analysis.Normed.Algebra.MatrixExponential
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.ExpLog.Basic
```

Required scopes:

```lean
open scoped MatrixOrder
open scoped Matrix.Norms.Operator
```

For `TraceExp.lean`, `Mathlib.Analysis.Normed.Algebra.MatrixExponential` is
already imported, so the expected new imports are:

```lean
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.ExpLog.Basic
```

## Checked Proof Shape

```lean
open scoped MatrixOrder
open scoped Matrix.Norms.Operator

example {n : Nat} {A : Matrix (Fin n) (Fin n) Real}
    (hA : IsSelfAdjointMatrix A) :
    Matrix.PosSemidef (matrixExp A) := by
  rw [matrixExp]
  exact Matrix.LE.le.posSemidef
    (IsSelfAdjoint.exp_nonneg hA.isSelfAdjoint)
```

Trace nonnegativity then follows from the existing
`traceMatrixExp_nonneg_of_matrixExp_posSemidef`.

## Failed API Names / Failed Attempts

- `IsSelfAdjoint.exp_nonneg` is unknown with only
  `Mathlib.Analysis.Matrix.Order`; it needs
  `Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.ExpLog.Basic`.
- `NormedRing (Matrix (Fin n) (Fin n) Real)` fails without
  `open scoped Matrix.Norms.Operator`.
- `open scoped Norms.Operator` is the wrong scope outside the `Matrix`
  namespace; use `open scoped Matrix.Norms.Operator`.
- `IsSelfAdjoint.exp_nonneg hA` fails when
  `hA : A.IsHermitian`; use `hA.isSelfAdjoint`.
- `Matrix.isHermitian_iff` and
  `Matrix.IsHermitian.isSelfAdjoint_iff` were not found. Use the aliases
  `Matrix.IsHermitian.isSelfAdjoint` and `IsSelfAdjoint.isHermitian`.
- `Matrix.posSemidef_toMatrix_iff` was not found. The checked name is
  `LinearMap.posSemidef_toMatrix_iff`.
- Direct
  `Matrix.nonneg_iff_posSemidef.mp (IsSelfAdjoint.exp_nonneg ...)` can hit
  default heartbeat pressure if under-inferred. `Matrix.LE.le.posSemidef` checked
  cleanly.
- Importing `HighDimProb.RandomMatrix.TraceExp` from stdin failed before a
  build because `.lake/build/lib/lean/HighDimProb/RandomMatrix/MatrixOrder.olean`
  was missing. I did not run a build during the read-only survey stage.

## Most Promising Route

Use Mathlib's CFC/order bridge:

1. Rewrite `matrixExp` to `NormedSpace.exp`.
2. Convert `hA : A.IsHermitian` to `IsSelfAdjoint A` via `hA.isSelfAdjoint`.
3. Use `IsSelfAdjoint.exp_nonneg` to get matrix-order nonnegativity.
4. Convert `0 <= NormedSpace.exp A` to `Matrix.PosSemidef` using
   `Matrix.LE.le.posSemidef`.

This route avoids spectral decomposition, square-root factorization, and any
new HighDimProb `IsPSDMatrix` bridge.

## Integration Outcome

The direct CFC/order route was integrated in
`HighDimProb/RandomMatrix/TraceExp.lean` as
`matrixExp_posSemidef_of_selfAdjoint`.

The compiled proof uses:

```lean
Matrix.nonneg_iff_posSemidef.mp
  (by simpa [matrixExp] using IsSelfAdjoint.exp_nonneg hA.isSelfAdjoint)
```

## Blockers

- None for MB-S4 after integration.
- Matrix Laplace, trace-mgf comparison, Golden-Thompson/Lieb-style analytic
  inequalities, and Matrix Bernstein remain outside this stage.
