import HighDimProb.RandomMatrix.MatrixOrder
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Order.ConditionallyCompleteLattice.Basic

/-!
# Inverse-convexity variational provider

Quadratic-form variational subleaf behind finite-dimensional inverse operator
convexity. This module proves the affine upper bound and supremum identity for
positive-definite real matrices. It does not prove the scalar segment
inequality, MatrixLE packaging, full operator convexity of inverse, or relative
entropy joint convexity.
-/

namespace HighDimProb

noncomputable section

open scoped MatrixOrder

private theorem matrixQuadraticForm_eq_dotProduct_mulVec
    {n : Nat} (A : Matrix (Fin n) (Fin n) Real) (x : Fin n -> Real) :
    HighDimProb.matrixQuadraticForm A x = dotProduct x (Matrix.mulVec A x) := by
  simp [HighDimProb.matrixQuadraticForm, dotProduct, Matrix.mulVec,
    Finset.mul_sum, mul_assoc]

private theorem dotProduct_mulVec_swap_of_isHermitian
    {n : Nat} {A : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (u w : Fin n -> Real) :
    dotProduct u (Matrix.mulVec A w) = dotProduct w (Matrix.mulVec A u) := by
  simp only [dotProduct, Matrix.mulVec, Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro j _
  have hij : A i j = A j i := by
    simpa using (Matrix.IsHermitian.apply hA j i)
  rw [hij]
  ring

/-- Pointwise affine upper bound behind the inverse variational principle. -/
theorem inv_quadraticForm_affine_le_of_posDef
    {n : Nat} (A : Matrix (Fin n) (Fin n) Real) (hA : A.PosDef)
    (v w : Fin n -> Real) :
    2 * dotProduct w v - HighDimProb.matrixQuadraticForm A w
      <= HighDimProb.matrixQuadraticForm (Inv.inv A) v := by
  let u : Fin n -> Real := Matrix.mulVec (Inv.inv A) v
  letI : Invertible A := hA.isUnit.invertible
  have hAu : Matrix.mulVec A u = v := by
    simp [u, Matrix.mulVec_mulVec]
  have hInvQuad :
      HighDimProb.matrixQuadraticForm (Inv.inv A) v = dotProduct u v := by
    calc
      HighDimProb.matrixQuadraticForm (Inv.inv A) v
          = dotProduct v (Matrix.mulVec (Inv.inv A) v) :=
        matrixQuadraticForm_eq_dotProduct_mulVec (Inv.inv A) v
      _ = dotProduct u v := by
        simp [u, dotProduct_comm]
  have hExpand :
      dotProduct (w - u) (Matrix.mulVec A (w - u))
        = HighDimProb.matrixQuadraticForm A w
            - 2 * dotProduct w v
            + HighDimProb.matrixQuadraticForm (Inv.inv A) v := by
    calc
      dotProduct (w - u) (Matrix.mulVec A (w - u))
          = dotProduct w (Matrix.mulVec A w) - dotProduct u (Matrix.mulVec A w) -
              (dotProduct w (Matrix.mulVec A u) - dotProduct u (Matrix.mulVec A u)) := by
            simp [Matrix.mulVec_sub, sub_dotProduct, dotProduct_sub]
      _ = dotProduct w (Matrix.mulVec A w) - dotProduct w (Matrix.mulVec A u) -
              (dotProduct w (Matrix.mulVec A u) - dotProduct u (Matrix.mulVec A u)) := by
            have hswap := dotProduct_mulVec_swap_of_isHermitian hA.isHermitian u w
            linarith
      _ = dotProduct w (Matrix.mulVec A w) - dotProduct w v -
              (dotProduct w v - dotProduct u v) := by
            simp [hAu]
      _ = HighDimProb.matrixQuadraticForm A w
            - 2 * dotProduct w v
            + HighDimProb.matrixQuadraticForm (Inv.inv A) v := by
            rw [<- matrixQuadraticForm_eq_dotProduct_mulVec A w, hInvQuad]
            ring
  have hNonneg :
      0 <= dotProduct (w - u) (Matrix.mulVec A (w - u)) :=
    hA.posSemidef.dotProduct_mulVec_nonneg (w - u)
  rw [hExpand] at hNonneg
  nlinarith

/-- Quadratic-form variational principle for the inverse of a positive-definite matrix. -/
theorem inv_quadraticForm_iSup_affine_of_posDef
    {n : Nat} (A : Matrix (Fin n) (Fin n) Real) (hA : A.PosDef)
    (v : Fin n -> Real) :
    HighDimProb.matrixQuadraticForm (Inv.inv A) v =
      sSup {r : Real | Exists fun w : Fin n -> Real =>
        r = 2 * dotProduct w v - HighDimProb.matrixQuadraticForm A w} := by
  let u : Fin n -> Real := Matrix.mulVec (Inv.inv A) v
  let S : Set Real := fun r => Exists fun w : Fin n -> Real =>
    r = 2 * dotProduct w v - HighDimProb.matrixQuadraticForm A w
  have hQuadAtU :
      2 * dotProduct u v - HighDimProb.matrixQuadraticForm A u =
        HighDimProb.matrixQuadraticForm (Inv.inv A) v := by
    letI : Invertible A := hA.isUnit.invertible
    have hAu : Matrix.mulVec A u = v := by
      simp [u, Matrix.mulVec_mulVec]
    have hInvQuad :
        HighDimProb.matrixQuadraticForm (Inv.inv A) v = dotProduct u v := by
      calc
        HighDimProb.matrixQuadraticForm (Inv.inv A) v
            = dotProduct v (Matrix.mulVec (Inv.inv A) v) :=
          matrixQuadraticForm_eq_dotProduct_mulVec (Inv.inv A) v
        _ = dotProduct u v := by
          simp [u, dotProduct_comm]
    have hQuadU : HighDimProb.matrixQuadraticForm A u = dotProduct u v := by
      calc
        HighDimProb.matrixQuadraticForm A u = dotProduct u (Matrix.mulVec A u) :=
          matrixQuadraticForm_eq_dotProduct_mulVec A u
        _ = dotProduct u v := by rw [hAu]
    rw [hQuadU, hInvQuad]
    ring
  have hMem : S (HighDimProb.matrixQuadraticForm (Inv.inv A) v) := by
    exact Exists.intro u hQuadAtU.symm
  have hNonempty : Set.Nonempty S := by
    exact Exists.intro _ hMem
  have hBdd : BddAbove S := by
    refine Exists.intro (HighDimProb.matrixQuadraticForm (Inv.inv A) v) ?_
    intro r hr
    cases hr with
    | intro w hw =>
        rw [hw]
        exact inv_quadraticForm_affine_le_of_posDef A hA v w
  have hLe : sSup S <= HighDimProb.matrixQuadraticForm (Inv.inv A) v := by
    apply csSup_le hNonempty
    intro r hr
    cases hr with
    | intro w hw =>
        rw [hw]
        exact inv_quadraticForm_affine_le_of_posDef A hA v w
  exact le_antisymm (le_csSup hBdd hMem) (by simpa [S] using hLe)

end

end HighDimProb