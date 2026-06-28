import HighDimProb.RandomMatrix.Spectral
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Order

/-!
# Ordered spectral endpoint monotonicity provider

This module proves the finite nonempty ordered-eigenvalue endpoint bridges: if
two real matrices are self-adjoint and `A <= B` in HighDimProb's matrix order,
then both the ordered top and ordered bottom eigenvalues of `A` are bounded by
the corresponding endpoints of `B`.

This is a partial spectral bridge only. It does not prove componentwise ordered
eigenvalue monotonicity, trace-exp monotonicity, or any Lieb/Tropp statement.
-/

namespace HighDimProb

noncomputable section

open scoped MatrixOrder

private theorem lambdaMaxOrdered_mem_spectrum_real_provider {n : Nat}
    {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) :
    lambdaMaxOrdered A hA ∈ spectrum Real A := by
  classical
  let e : Fin (Fintype.card (Fin (n + 1))) ≃ Fin (n + 1) :=
    Fintype.equivOfCardEq (by simp)
  have hmem := hA.eigenvalues_mem_spectrum_real (e 0)
  simpa [lambdaMaxOrdered, Matrix.IsHermitian.eigenvalues, e] using hmem

/-- Finite top-eigenvalue monotonicity under HighDimProb matrix order.

The proof is a short spectral sandwich:
`A <= B <= lambdaMaxOrdered B * I`, then every spectral value of `A` is at most
`lambdaMaxOrdered B`, and the ordered top eigenvalue is itself a spectral value.
-/
theorem lambdaMaxOrdered_le_of_matrixLE_selfAdjoint {n : Nat}
    {A B : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A)
    (hB : IsSelfAdjointMatrix B)
    (hAB : MatrixLE A B) :
    lambdaMaxOrdered A hA <= lambdaMaxOrdered B hB := by
  have hBupper :
      B <= lambdaMaxOrdered B hB •
        (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) := by
    rw [Matrix.le_iff]
    simpa [SpectralUpperBound, Algebra.algebraMap_eq_smul_one] using
      (lambdaMaxOrdered_spectralUpperBound (A := B) hB)
  have hAupper :
      A <= lambdaMaxOrdered B hB •
        (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) := by
    exact le_trans (mathlib_le_of_matrixLE hAB) hBupper
  have hAupper' :
      A <= algebraMap Real (Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
        (lambdaMaxOrdered B hB) := by
    simpa [Algebra.algebraMap_eq_smul_one] using hAupper
  have hSpecLE :
      ∀ x ∈ spectrum Real A, x <= lambdaMaxOrdered B hB :=
    (le_algebraMap_iff_spectrum_le (a := A)
      (r := lambdaMaxOrdered B hB) (ha := hA)).mp hAupper'
  exact hSpecLE _ (lambdaMaxOrdered_mem_spectrum_real_provider hA)

private theorem lambdaMinOrdered_mem_spectrum_real_provider {n : Nat}
    {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) :
    lambdaMinOrdered A hA ∈ spectrum Real A := by
  classical
  let e : Fin (Fintype.card (Fin (n + 1))) ≃ Fin (n + 1) :=
    Fintype.equivOfCardEq (by simp)
  have hmem :=
    hA.eigenvalues_mem_spectrum_real (e (Fin.cast (by simp) (Fin.last n)))
  simpa [lambdaMinOrdered, Matrix.IsHermitian.eigenvalues, e] using hmem

private theorem spectrum_real_ge_lambdaMinOrdered_provider {n : Nat}
    {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) {x : Real}
    (hx : x ∈ spectrum Real A) :
    lambdaMinOrdered A hA <= x := by
  classical
  rw [hA.spectrum_real_eq_range_eigenvalues] at hx
  rcases hx with ⟨i, rfl⟩
  let e : Fin (Fintype.card (Fin (n + 1))) ≃ Fin (n + 1) :=
    Fintype.equivOfCardEq (by simp)
  simpa [lambdaMinOrdered, Matrix.IsHermitian.eigenvalues, e] using
    (lambdaMinOrdered_is_least_eigenvalue A hA (e.symm i))

/-- Finite bottom-eigenvalue monotonicity under HighDimProb matrix order.

The proof is the lower spectral mirror of the top-end route:
`lambdaMinOrdered A * I <= A <= B`, then every spectral value of `B` is at least
`lambdaMinOrdered A`, and the ordered bottom eigenvalue of `B` is itself a
spectral value.
-/
theorem lambdaMinOrdered_le_of_matrixLE_selfAdjoint {n : Nat}
    {A B : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A)
    (hB : IsSelfAdjointMatrix B)
    (hAB : MatrixLE A B) :
    lambdaMinOrdered A hA <= lambdaMinOrdered B hB := by
  have hAlow :
      algebraMap Real (Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
        (lambdaMinOrdered A hA) <= A := by
    refine (algebraMap_le_iff_le_spectrum (a := A)
        (r := lambdaMinOrdered A hA) (ha := hA)).2 ?_
    intro x hx
    exact spectrum_real_ge_lambdaMinOrdered_provider hA hx
  have hAlow' :
      algebraMap Real (Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
        (lambdaMinOrdered A hA) <= B := by
    exact le_trans hAlow (mathlib_le_of_matrixLE hAB)
  have hBlow :
      ∀ x ∈ spectrum Real B, lambdaMinOrdered A hA <= x :=
    (algebraMap_le_iff_le_spectrum (a := B)
      (r := lambdaMinOrdered A hA) (ha := hB)).1 hAlow'
  exact hBlow _ (lambdaMinOrdered_mem_spectrum_real_provider hB)

end

end HighDimProb
