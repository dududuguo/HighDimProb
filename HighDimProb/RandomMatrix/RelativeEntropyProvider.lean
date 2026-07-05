import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Tactic

/-!
# Relative-entropy scalar and diagonal provider

This module exposes the smallest stable relative-entropy/Klein MVPs used by the
provider-facing Lieb route: scalar nonnegativity and the diagonal spectral-data
sum. It does not prove the full matrix Klein inequality, relative-entropy joint
convexity, Epstein, or Lieb.
-/

namespace HighDimProb

open scoped BigOperators

namespace RelativeEntropy

/-- Scalar unnormalized relative-entropy integrand `x log (x / y) - x + y`. -/
noncomputable def scalarTerm (x y : Real) : Real :=
  x * Real.log (x / y) - x + y

/-- Diagonal/spectral-data version of the unnormalized relative entropy. -/
noncomputable def diagonalTerm {n : Nat} (t s : Fin n -> Real) : Real :=
  Finset.univ.sum (fun i => scalarTerm (t i) (s i))

/-- Scalar Klein inequality for the unnormalized relative-entropy integrand. -/
theorem scalarTerm_nonneg {x y : Real} (hx : 0 < x) (hy : 0 < y) :
    0 <= scalarTerm x y := by
  dsimp [scalarTerm]
  have hz : 0 < x / y := by
    positivity
  have hlog0 : 1 - Inv.inv (x / y) <= Real.log (x / y) :=
    Real.one_sub_inv_le_log_of_pos hz
  have hx_ne : Ne x 0 := ne_of_gt hx
  have hy_ne : Ne y 0 := ne_of_gt hy
  have hinv : Inv.inv (x / y) = y / x := by
    field_simp [hx_ne, hy_ne]
  have hlog : 1 - y / x <= Real.log (x / y) := by
    simpa [hinv] using hlog0
  have hmul : x * (1 - y / x) <= x * Real.log (x / y) := by
    exact mul_le_mul_of_nonneg_left hlog (le_of_lt hx)
  have hleft : x * (1 - y / x) = x - y := by
    field_simp [hx_ne]
  linarith

/-- Diagonal Klein inequality on explicit positive scalar spectral data. -/
theorem diagonalTerm_nonneg {n : Nat} (t s : Fin n -> Real)
    (ht : forall i, 0 < t i) (hs : forall i, 0 < s i) :
    0 <= diagonalTerm t s := by
  dsimp [diagonalTerm]
  refine Finset.sum_nonneg ?_
  intro i _hi
  exact scalarTerm_nonneg (ht i) (hs i)

end RelativeEntropy

/-- Scalar Klein inequality for the unnormalized relative-entropy integrand. -/
theorem kleinInequality_scalar_relativeEntropy_nonneg
    {x y : Real} (hx : 0 < x) (hy : 0 < y) :
    0 <= x * Real.log (x / y) - x + y := by
  simpa [RelativeEntropy.scalarTerm] using
    RelativeEntropy.scalarTerm_nonneg hx hy

/-- Diagonal/same-eigenbasis Klein inequality on explicit scalar spectral data.

This is a scalar-data MVP: it proves nonnegativity once the trace expression has
already been reduced to diagonal entries. It does not rewrite a general matrix
trace-log expression into this sum.
-/
theorem kleinInequality_relativeEntropy_nonneg_diagonal
    {n : Nat} (t s : Fin n -> Real)
    (ht : forall i, 0 < t i) (hs : forall i, 0 < s i) :
    0 <= Finset.univ.sum (fun i => t i * Real.log (t i / s i) - t i + s i) := by
  simpa [RelativeEntropy.diagonalTerm, RelativeEntropy.scalarTerm] using
    RelativeEntropy.diagonalTerm_nonneg t s ht hs

end HighDimProb