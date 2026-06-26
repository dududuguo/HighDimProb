import HighDimProb.RandomMatrix.CStarBridge
import Mathlib.Analysis.CStarAlgebra.CStarMatrix
import Mathlib.Analysis.Matrix.Order

/-!
# CStar order transport providers

This module proves the first representation bridges needed to reuse Mathlib's
CStar functional-calculus order theorems from HighDimProb's matrix layer.

The key point is that ordinary `Matrix` order and `CStarMatrix` spectral order
are not definitionally equal. We therefore transport positivity through the
`StarOrderedRing.nonneg_iff` positive-cone characterization instead of trying to
rewrite one order instance into the other.
-/

namespace HighDimProb

noncomputable section

open scoped ComplexOrder MatrixOrder

private theorem cstarMatrixOfMatrix_mem_positiveCone_of_mem_positiveCone {n : Nat}
    {A : Matrix (Fin n) (Fin n) Complex}
    (hA : A ∈ AddSubmonoid.closure
      (Set.range fun B : Matrix (Fin n) (Fin n) Complex => star B * B)) :
    (CStarMatrix.ofMatrix A : CStarMatrix (Fin n) (Fin n) Complex) ∈
      AddSubmonoid.closure
        (Set.range fun B : CStarMatrix (Fin n) (Fin n) Complex => star B * B) := by
  induction hA using AddSubmonoid.closure_induction with
  | zero =>
      simp
  | add X Y hX hY ihX ihY =>
      simpa [CStarMatrix.of_add_of] using AddSubmonoid.add_mem _ ihX ihY
  | mem X hX =>
      rcases hX with ⟨B, rfl⟩
      refine AddSubmonoid.subset_closure ?_
      refine ⟨(CStarMatrix.ofMatrix B : CStarMatrix (Fin n) (Fin n) Complex), ?_⟩
      ext i j
      simp [CStarMatrix.mul_apply, CStarMatrix.star_apply, Matrix.mul_apply]

/-- Ordinary complex-matrix positive semidefiniteness transports to the
`CStarMatrix` spectral order. -/
theorem cstarMatrixOfMatrix_nonneg_of_posSemidef {n : Nat}
    (A : Matrix (Fin n) (Fin n) Complex) (hA : A.PosSemidef) :
    0 <= (CStarMatrix.ofMatrix A : CStarMatrix (Fin n) (Fin n) Complex) := by
  rw [StarOrderedRing.nonneg_iff]
  exact cstarMatrixOfMatrix_mem_positiveCone_of_mem_positiveCone
    ((StarOrderedRing.nonneg_iff).mp (Matrix.PosSemidef.nonneg hA))

private theorem cstarMatrixOfMatrix_isUnit_of_isUnit {n : Nat}
    {A : Matrix (Fin n) (Fin n) Complex} (hA : IsUnit A) :
    IsUnit (CStarMatrix.ofMatrix A : CStarMatrix (Fin n) (Fin n) Complex) := by
  obtain ⟨B, hAB, hBA⟩ := isUnit_iff_exists.mp hA
  refine isUnit_iff_exists.mpr
    ⟨(CStarMatrix.ofMatrix B : CStarMatrix (Fin n) (Fin n) Complex), ?_, ?_⟩
  · simpa using congrArg CStarMatrix.ofMatrix hAB
  · simpa using congrArg CStarMatrix.ofMatrix hBA

/-- Ordinary complex-matrix Loewner order transports to the `CStarMatrix`
spectral order. -/
theorem cstarMatrixOfMatrix_le_of_matrix_le {n : Nat}
    {A B : Matrix (Fin n) (Fin n) Complex} (hAB : A <= B) :
    (CStarMatrix.ofMatrix A : CStarMatrix (Fin n) (Fin n) Complex) <=
      (CStarMatrix.ofMatrix B : CStarMatrix (Fin n) (Fin n) Complex) := by
  rw [← sub_nonneg]
  have hPSD : (B - A).PosSemidef := Matrix.le_iff.mp hAB
  have hNonneg :
      0 <= (CStarMatrix.ofMatrix (B - A) :
        CStarMatrix (Fin n) (Fin n) Complex) :=
    cstarMatrixOfMatrix_nonneg_of_posSemidef (B - A) hPSD
  simpa [CStarMatrix.of_sub_of] using hNonneg

/-- Ordinary complex-matrix positive definiteness transports to strict
positivity of the corresponding `CStarMatrix`. -/
theorem cstarMatrixOfMatrix_strictlyPositive_of_posDef {n : Nat}
    (A : Matrix (Fin n) (Fin n) Complex) (hA : A.PosDef) :
    IsStrictlyPositive
      (CStarMatrix.ofMatrix A : CStarMatrix (Fin n) (Fin n) Complex) := by
  have hNonneg :
      0 <= (CStarMatrix.ofMatrix A : CStarMatrix (Fin n) (Fin n) Complex) :=
    cstarMatrixOfMatrix_nonneg_of_posSemidef A hA.posSemidef
  have hUnitCStar :
      IsUnit (CStarMatrix.ofMatrix A : CStarMatrix (Fin n) (Fin n) Complex) :=
    cstarMatrixOfMatrix_isUnit_of_isUnit hA.isUnit
  exact hUnitCStar.isStrictlyPositive hNonneg

end

end HighDimProb