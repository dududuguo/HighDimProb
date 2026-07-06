import HighDimProb.RandomMatrix.InverseConvexityProvider
import HighDimProb.RandomMatrix.TraceResolventPerspectiveProvider

/-!
# Fixed-numerator trace-resolvent convexity provider

This module packages the honest convexity leaf available from the current
inverse-convexity API: the numerator stays fixed and PSD while the shifted
denominator moves along a convex segment.

It does not prove mixed-numerator joint convexity, relative-entropy joint
convexity, Epstein, or Lieb.
-/

namespace HighDimProb

noncomputable section

open scoped MatrixOrder

private theorem add_const_posDef_of_posDef
    {n : Nat} {A : Matrix (Fin n) (Fin n) Real}
    (hA : A.PosDef) {s : Real} (hs : 0 <= s) :
    (A + s • (1 : Matrix (Fin n) (Fin n) Real)).PosDef := by
  by_cases hs0 : s = 0
  · simpa [hs0, zero_smul, add_zero] using hA
  · have hsPos : 0 < s := lt_of_le_of_ne hs (Ne.symm hs0)
    have hShift : (Matrix.diagonal fun _ : Fin n => s).PosDef :=
      Matrix.PosDef.diagonal (fun _ => hsPos)
    have hShiftEq :
        s • (1 : Matrix (Fin n) (Fin n) Real) =
          Matrix.diagonal (fun _ : Fin n => s) := by
      ext i j
      by_cases hij : i = j
      · subst hij
        simp [Matrix.diagonal]
      · simp [Matrix.diagonal, hij]
    simpa [hShiftEq] using hA.add hShift

/-- Fixed PSD numerators preserve convexity of shifted trace-resolvents along
positive-definite matrix segments. -/
theorem trace_mul_inv_add_const_convex_combo_le
    {n : Nat} (T A0 A1 : Matrix (Fin n) (Fin n) Real)
    (hT : IsPSDMatrix T)
    (hA0 : IsStrictlyPositive A0) (hA1 : IsStrictlyPositive A1)
    {theta s : Real} (h0 : 0 <= theta) (h1 : theta <= 1) (hs : 0 <= s) :
    Matrix.trace
        (T * Inv.inv ((((1 - theta) • A0) + theta • A1) +
          s • (1 : Matrix (Fin n) (Fin n) Real))) <=
      (1 - theta) * Matrix.trace
          (T * Inv.inv (A0 + s • (1 : Matrix (Fin n) (Fin n) Real))) +
        theta * Matrix.trace
          (T * Inv.inv (A1 + s • (1 : Matrix (Fin n) (Fin n) Real))) := by
  let A0s : Matrix (Fin n) (Fin n) Real := A0 + s • (1 : Matrix (Fin n) (Fin n) Real)
  let A1s : Matrix (Fin n) (Fin n) Real := A1 + s • (1 : Matrix (Fin n) (Fin n) Real)
  have hA0pd : A0.PosDef := Matrix.isStrictlyPositive_iff_posDef.mp hA0
  have hA1pd : A1.PosDef := Matrix.isStrictlyPositive_iff_posDef.mp hA1
  have hA0s : A0s.PosDef := add_const_posDef_of_posDef hA0pd hs
  have hA1s : A1s.PosDef := add_const_posDef_of_posDef hA1pd hs
  have hInv :
      MatrixLE (Inv.inv (((1 - theta) • A0s) + theta • A1s))
        (((1 - theta) • Inv.inv A0s) + theta • Inv.inv A1s) :=
    inv_matrixLE_convex_combo_le_of_posDef A0s A1s hA0s hA1s h0 h1
  have hTrace := trace_mul_mono_right_of_matrixLE_of_isPSDMatrix hT hInv
  have hShiftCombo :
      ((1 - theta) • A0s) + theta • A1s =
        (((1 - theta) • A0) + theta • A1) +
          s • (1 : Matrix (Fin n) (Fin n) Real) := by
    ext i j
    by_cases hij : i = j
    · subst hij
      simp [A0s, A1s]
      ring_nf
    · simp [A0s, A1s, hij]
  calc
    Matrix.trace
        (T * Inv.inv ((((1 - theta) • A0) + theta • A1) +
          s • (1 : Matrix (Fin n) (Fin n) Real)))
      = Matrix.trace (T * Inv.inv (((1 - theta) • A0s) + theta • A1s)) := by
          rw [hShiftCombo]
    _ <= Matrix.trace (T * (((1 - theta) • Inv.inv A0s) + theta • Inv.inv A1s)) :=
      hTrace
    _ = Matrix.trace (T * ((1 - theta) • Inv.inv A0s) + T * (theta • Inv.inv A1s)) := by
          rw [Matrix.mul_add]
    _ = Matrix.trace (((1 - theta) • (T * Inv.inv A0s)) + theta • (T * Inv.inv A1s)) := by
          apply congrArg Matrix.trace
          rw [show T * ((1 - theta) • Inv.inv A0s) = (1 - theta) • (T * Inv.inv A0s) by
                simp]
          rw [show T * (theta • Inv.inv A1s) = theta • (T * Inv.inv A1s) by
                simp]
    _ = Matrix.trace ((1 - theta) • (T * Inv.inv A0s)) +
          Matrix.trace (theta • (T * Inv.inv A1s)) := by
          rw [Matrix.trace_add]
    _ = (1 - theta) * Matrix.trace (T * Inv.inv A0s) +
          theta * Matrix.trace (T * Inv.inv A1s) := by
          simp [Matrix.trace_smul]
    _ = (1 - theta) * Matrix.trace
          (T * Inv.inv (A0 + s • (1 : Matrix (Fin n) (Fin n) Real))) +
        theta * Matrix.trace
          (T * Inv.inv (A1 + s • (1 : Matrix (Fin n) (Fin n) Real))) := by
          rfl

end

end HighDimProb