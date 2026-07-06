import HighDimProb.RandomMatrix.LogResolventProvider

/-!
# Trace-resolvent weighted trace monotonicity provider

This module adds the smallest honest weighted trace leaf needed around the
resolvent perspective blocker: PSD numerators preserve Loewner monotonicity
after applying trace on the right.

It does not prove mixed-numerator joint convexity, fixed-numerator shifted
inverse convexity, relative-entropy joint convexity, Epstein, or Lieb.
-/

namespace HighDimProb

noncomputable section

open scoped MatrixOrder

private theorem trace_mul_nonneg_of_posSemidef
    {n : Nat} {K C : Matrix (Fin n) (Fin n) Real}
    (hK : K.PosSemidef) (hC : C.PosSemidef) :
    0 <= Matrix.trace (K * C) := by
  have hExists := CStarAlgebra.nonneg_iff_eq_star_mul_self.mp hC.nonneg
  cases hExists with
  | intro D hD =>
      rw [hD]
      have hProdPSD := hK.mul_mul_conjTranspose_same D
      calc
        0 <= Matrix.trace (D * K * star D) := by
          simpa [Matrix.mul_assoc] using hProdPSD.trace_nonneg
        _ = Matrix.trace (star D * D * K) := by
          simpa [Matrix.mul_assoc] using Matrix.trace_mul_cycle D K (star D)
        _ = Matrix.trace (K * star D * D) := by
          simpa [Matrix.mul_assoc] using Matrix.trace_mul_cycle (star D) D K
        _ = Matrix.trace (K * (star D * D)) := by
          simp [Matrix.mul_assoc]

/-- PSD numerators preserve Loewner monotonicity after applying trace on the
right. -/
theorem trace_mul_mono_right_of_matrixLE_of_isPSDMatrix
    {n : Nat} {T A B : Matrix (Fin n) (Fin n) Real}
    (hT : IsPSDMatrix T) (hAB : MatrixLE A B) :
    Matrix.trace (T * A) <= Matrix.trace (T * B) := by
  have hDiff : (B - A).PosSemidef := posSemidef_of_isPSDMatrix hAB
  have hTrace : 0 <= Matrix.trace (T * (B - A)) :=
    trace_mul_nonneg_of_posSemidef (posSemidef_of_isPSDMatrix hT) hDiff
  rw [Matrix.mul_sub, Matrix.trace_sub] at hTrace
  exact sub_nonneg.mp hTrace

end

end HighDimProb
