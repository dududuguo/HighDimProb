import HighDimProb.RandomMatrix.TraceExp
import Mathlib.Data.Real.StarOrdered

namespace HighDimProb

noncomputable section

theorem mb_s4_probe_matrixExp_posSemidef_of_selfAdjoint {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real}
    (hA : IsSelfAdjointMatrix A) :
    Matrix.PosSemidef (matrixExp A) := by
  let B : Matrix (Fin n) (Fin n) Real := matrixExp ((1 / 2 : Real) • A)
  have hhalf :
      (1 / 2 : Real) • A + (1 / 2 : Real) • A = A := by
    ext i j
    simp
    ring
  have hcomm : Commute ((1 / 2 : Real) • A) ((1 / 2 : Real) • A) :=
    Commute.refl _
  have hexp : matrixExp A = B * B := by
    dsimp [B]
    calc
      matrixExp A =
          matrixExp (((1 / 2 : Real) • A) + ((1 / 2 : Real) • A)) := by
            rw [hhalf]
      _ =
          matrixExp ((1 / 2 : Real) • A) *
            matrixExp ((1 / 2 : Real) • A) := by
            simpa [matrixExp] using
              (Matrix.exp_add_of_commute ((1 / 2 : Real) • A)
                ((1 / 2 : Real) • A) hcomm)
  have hBherm : IsSelfAdjointMatrix B := by
    dsimp [B]
    exact isSelfAdjointMatrix_matrixExp
      (isSelfAdjointMatrix_smul (1 / 2 : Real) hA)
  have hBstar : star B = B := hBherm.eq
  have hpsd : Matrix.PosSemidef (B * star B) := by
    simpa using Matrix.posSemidef_self_mul_conjTranspose B
  have hpsdBB : Matrix.PosSemidef (B * B) := by
    simpa [hBstar] using hpsd
  rw [hexp]
  exact hpsdBB

end

end HighDimProb
