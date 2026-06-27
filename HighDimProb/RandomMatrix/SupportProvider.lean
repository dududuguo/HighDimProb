import HighDimProb.RandomMatrix.HardboneStatements
import HighDimProb.RandomMatrix.Spectral
import HighDimProb.RandomMatrix.TraceExp
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.ExpLog.Basic

/-!
# Support-side trace-exponential providers

This module proves the first honest support certificate needed by the
support/effective-rank trace-exponential lane: the ambient identity matrix
already dominates `matrixExp A` after scaling by `exp (lambdaMaxOrdered A)`.

It does not construct smaller support projections, prove excess-support
certificates, or prove any Golden-Thompson, Lieb, or Matrix Bernstein fact.
-/

namespace HighDimProb

noncomputable section

open scoped MatrixOrder Matrix.Norms.Operator

private theorem spectrum_real_le_lambdaMaxOrdered {n : Nat}
    {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : HighDimProb.IsSelfAdjointMatrix A) {x : Real}
    (hx : x ∈ spectrum Real A) :
    x <= HighDimProb.lambdaMaxOrdered A hA := by
  classical
  let e : Fin (Fintype.card (Fin (n + 1))) ≃ Fin (n + 1) :=
    Fintype.equivOfCardEq (by simp)
  rw [hA.spectrum_real_eq_range_eigenvalues] at hx
  rcases hx with ⟨i, rfl⟩
  simpa [HighDimProb.lambdaMaxOrdered, Matrix.IsHermitian.eigenvalues, e] using
    hA.eigenvalues₀_antitone (Fin.zero_le (e.symm i))

/-- Ambient identity-support domination for the matrix exponential.

This is the smallest support-certificate provider in the support/effective-rank
lane. It reuses the ordered lambda-max endpoint from HighDimProb, applies the
scalar inequality `exp x <= exp lambdaMax` on the spectrum of one self-adjoint
matrix, lifts it through `cfc_mono`, and reflects the resulting Mathlib matrix
order back into HighDimProb's `MatrixLE` vocabulary. -/
theorem matrixExpSupportDomination_identity {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) :
    HighDimProb.matrixExpSupportDomination_identity_statement A := by
  intro hA
  unfold HighDimProb.MatrixExpSupportDomination
  have hle :
      HighDimProb.matrixExp A <=
        SMul.smul (Real.exp (HighDimProb.lambdaMaxOrdered A hA))
          (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) := by
    calc
      HighDimProb.matrixExp A = cfc Real.exp A := by
        symm
        simpa [HighDimProb.matrixExp] using
          (CFC.real_exp_eq_normedSpace_exp (a := A) hA.isSelfAdjoint)
      _ <= cfc (fun _ : Real => Real.exp (HighDimProb.lambdaMaxOrdered A hA)) A := by
        exact cfc_mono (a := A) (fun x hx =>
          Real.exp_le_exp.mpr (spectrum_real_le_lambdaMaxOrdered hA hx))
      _ = SMul.smul (Real.exp (HighDimProb.lambdaMaxOrdered A hA))
            (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) := by
        simpa [Algebra.algebraMap_eq_smul_one] using
          (cfc_const (R := Real)
            (r := Real.exp (HighDimProb.lambdaMaxOrdered A hA)) (a := A))
  exact HighDimProb.matrixLE_of_mathlib_le hle

end

end HighDimProb