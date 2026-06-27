import Mathlib.Analysis.Calculus.Deriv.MeanValue
import HighDimProb.RandomMatrix.MatrixOrder
import HighDimProb.RandomMatrix.TraceExp
import HighDimProb.RandomMatrix.TraceExpDerivative

/-!
# Trace-exponential monotonicity

This module proves deterministic trace-exponential monotonicity along Loewner
ordered self-adjoint directions. It is a local analytic bridge for the
RandomMatrix hardbone log/order chain; it does not prove Lieb concavity,
Golden-Thompson, Tropp trace-MGF, or Matrix Bernstein.
-/

namespace HighDimProb

noncomputable section

open scoped MatrixOrder

private theorem isSelfAdjointMatrix_add_smul
    {n : Nat} (X C : Matrix (Fin n) (Fin n) Real) (t : Real)
    (hX : IsSelfAdjointMatrix X)
    (hC : IsSelfAdjointMatrix C) :
    IsSelfAdjointMatrix (X + SMul.smul t C) := by
  have ht : IsSelfAdjoint t := by
    simp [IsSelfAdjoint]
  change (X + SMul.smul t C).IsHermitian
  exact hX.add (hC.smul ht)

/-- Minimal PSD/self-adjoint trace-exponential product bridge.

If `C` is nonnegative in HighDimProb's explicit matrix order and `X` is
self-adjoint, then the trace of `C * exp X` is nonnegative. -/
theorem matrixTrace_mul_matrixExp_nonneg_of_selfAdjoint_of_nonneg_left
    {n : Nat} (X C : Matrix (Fin n) (Fin n) Real)
    (hX : IsSelfAdjointMatrix X)
    (hC0 : MatrixLE 0 C) :
    0 <= Matrix.trace (C * matrixExp X) := by
  have hCmath : (0 : Matrix (Fin n) (Fin n) Real) <= C :=
    mathlib_le_of_matrixLE hC0
  have hCPSD : Matrix.PosSemidef C := by
    simpa [Matrix.le_iff] using hCmath
  have hExpPSD : Matrix.PosSemidef (matrixExp X) :=
    matrixExp_posSemidef_of_selfAdjoint hX
  obtain ⟨B, rfl⟩ :=
    CStarAlgebra.nonneg_iff_eq_star_mul_self.mp hCPSD.nonneg
  have hProdPSD := hExpPSD.mul_mul_conjTranspose_same B
  calc
    0 <= Matrix.trace (B * matrixExp X * star B) := by
      simpa using hProdPSD.trace_nonneg
    _ = Matrix.trace (star B * B * matrixExp X) := by
      simpa using Matrix.trace_mul_cycle B (matrixExp X) (star B)
    _ = Matrix.trace ((star B * B) * matrixExp X) := by
      rfl

/-- Affine-line monotonicity for the trace exponential along a PSD direction. -/
theorem monotone_traceMatrixExp_add_smul_of_selfAdjoint_of_nonneg_direction
    {n : Nat} (X C : Matrix (Fin n) (Fin n) Real)
    (hX : IsSelfAdjointMatrix X)
    (hC : IsSelfAdjointMatrix C)
    (hC0 : MatrixLE 0 C) :
    Monotone (fun t : Real => traceMatrixExp (X + SMul.smul t C)) := by
  refine monotone_of_hasDerivAt_nonneg
      (f' := fun t : Real => Matrix.trace (C * matrixExp (X + SMul.smul t C))) ?_ ?_
  · intro t
    simpa [traceMatrixExp, matrixTrace, matrixExp] using
      hasDerivAt_trace_exp_add_smul_const X C t
  · change ∀ t : Real, 0 <= Matrix.trace (C * matrixExp (X + SMul.smul t C))
    intro t
    exact matrixTrace_mul_matrixExp_nonneg_of_selfAdjoint_of_nonneg_left
      (X + SMul.smul t C) C
      (isSelfAdjointMatrix_add_smul X C t hX hC) hC0

private theorem isSelfAdjointMatrix_sub
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : IsSelfAdjointMatrix A)
    (hB : IsSelfAdjointMatrix B) :
    IsSelfAdjointMatrix (B - A) := by
  change (B - A).IsHermitian
  exact hB.sub hA

private theorem matrixLE_zero_sub_of_matrixLE
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hAB : MatrixLE A B) :
    MatrixLE 0 (B - A) := by
  unfold MatrixLE at *
  simpa using hAB

private theorem traceMatrixExp_endpoint_zero
    {n : Nat} (H A B : Matrix (Fin n) (Fin n) Real) :
    (H + A) + SMul.smul (0 : Real) (B - A) = H + A := by
  change (H + A) + (0 : Real) • (B - A) = H + A
  simp

private theorem traceMatrixExp_endpoint_one
    {n : Nat} (H A B : Matrix (Fin n) (Fin n) Real) :
    (H + A) + SMul.smul (1 : Real) (B - A) = H + B := by
  change (H + A) + (1 : Real) • (B - A) = H + B
  rw [one_smul]
  abel

/-- Trace-exponential monotonicity after adding a self-adjoint history term.

This is the direct theorem behind the hardbone statement
`traceMatrixExp_mono_add_selfAdjoint_statement`. -/
theorem traceMatrixExp_mono_add_selfAdjoint_of_matrixLE {n : Nat}
    (H A B : Matrix (Fin n) (Fin n) Real)
    (hH : IsSelfAdjointMatrix H)
    (hA : IsSelfAdjointMatrix A)
    (hB : IsSelfAdjointMatrix B)
    (hAB : MatrixLE A B) :
    traceMatrixExp (H + A) <= traceMatrixExp (H + B) := by
  have hX : IsSelfAdjointMatrix (H + A) := by
    change (H + A).IsHermitian
    exact hH.add hA
  have hC : IsSelfAdjointMatrix (B - A) :=
    isSelfAdjointMatrix_sub hA hB
  have hC0 : MatrixLE 0 (B - A) :=
    matrixLE_zero_sub_of_matrixLE hAB
  have hmono := monotone_traceMatrixExp_add_smul_of_selfAdjoint_of_nonneg_direction
    (X := H + A) (C := B - A) hX hC hC0
  have hle := hmono (show (0 : Real) <= 1 by norm_num)
  simpa [traceMatrixExp, matrixTrace,
    traceMatrixExp_endpoint_zero H A B, traceMatrixExp_endpoint_one H A B] using hle

end

end HighDimProb