import HighDimProb.RandomMatrix.MatrixOrder
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Order.ConditionallyCompleteLattice.Basic

/-!
# Inverse-convexity variational provider

Quadratic-form variational subleaf behind finite-dimensional inverse operator
convexity. This module proves the affine upper bound and supremum identity for
positive-definite real matrices, together with the scalar segment inequality
and its explicit `MatrixLE` packaging. It does not prove full operator
convexity of inverse or relative entropy joint convexity.
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

/-- Positive-definite convex combinations remain positive definite. -/
theorem convexCombo_posDef_of_posDef
    {n : Nat} (A B : Matrix (Fin n) (Fin n) Real)
    (hA : A.PosDef) (hB : B.PosDef)
    {theta : Real} (h0 : 0 <= theta) (h1 : theta <= 1) :
    (((1 - theta) • A) + theta • B).PosDef := by
  by_cases htheta0 : theta = 0
  case pos =>
    subst htheta0
    simpa using hA
  case neg =>
    by_cases htheta1 : theta = 1
    case pos =>
      subst htheta1
      simpa using hB
    case neg =>
      have hLeft : 0 < 1 - theta := sub_pos.mpr (lt_of_not_ge fun h =>
        htheta1 (le_antisymm h1 h))
      have hRight : 0 < theta := lt_of_le_of_ne h0 (Ne.symm htheta0)
      simpa [sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using
        (hA.smul hLeft).add (hB.smul hRight)

/-- Scalar quadratic-form segment inequality behind inverse operator convexity. -/
theorem inv_quadraticForm_convex_combo_le_of_posDef
    {n : Nat} (A B : Matrix (Fin n) (Fin n) Real)
    (hA : A.PosDef) (hB : B.PosDef)
    {theta : Real} (h0 : 0 <= theta) (h1 : theta <= 1)
    (v : Fin n -> Real) :
    HighDimProb.matrixQuadraticForm
        (Inv.inv (((1 - theta) • A) + theta • B)) v <=
      (1 - theta) * HighDimProb.matrixQuadraticForm (Inv.inv A) v +
        theta * HighDimProb.matrixQuadraticForm (Inv.inv B) v := by
  let C : Matrix (Fin n) (Fin n) Real := (1 - theta) • A + theta • B
  have hC : C.PosDef := convexCombo_posDef_of_posDef A B hA hB h0 h1
  have hSup :
      HighDimProb.matrixQuadraticForm (Inv.inv C) v =
        sSup {r : Real | Exists fun w : Fin n -> Real =>
          r = 2 * dotProduct w v - HighDimProb.matrixQuadraticForm C w} :=
    inv_quadraticForm_iSup_affine_of_posDef C hC v
  calc
    HighDimProb.matrixQuadraticForm
        (Inv.inv (((1 - theta) • A) + theta • B)) v
        = sSup {r : Real | Exists fun w : Fin n -> Real =>
            r = 2 * dotProduct w v -
              HighDimProb.matrixQuadraticForm (((1 - theta) • A) + theta • B) w} := by
          simpa [C] using hSup
    _ <= (1 - theta) * HighDimProb.matrixQuadraticForm (Inv.inv A) v +
          theta * HighDimProb.matrixQuadraticForm (Inv.inv B) v := by
          apply csSup_le
          · refine ⟨0, ?_⟩
            refine ⟨fun _ => 0, ?_⟩
            simp [HighDimProb.matrixQuadraticForm]
          · intro r hr
            rcases hr with ⟨w, rfl⟩
            have hAffA := inv_quadraticForm_affine_le_of_posDef A hA v w
            have hAffB := inv_quadraticForm_affine_le_of_posDef B hB v w
            rw [HighDimProb.matrixQuadraticForm_add,
              HighDimProb.matrixQuadraticForm_smul,
              HighDimProb.matrixQuadraticForm_smul]
            nlinarith

/-- Matrix-order packaging of the inverse-convexity scalar segment theorem. -/
theorem inv_matrixLE_convex_combo_le_of_posDef
    {n : Nat} (A B : Matrix (Fin n) (Fin n) Real)
    (hA : A.PosDef) (hB : B.PosDef)
    {theta : Real} (h0 : 0 <= theta) (h1 : theta <= 1) :
    HighDimProb.MatrixLE
      (Inv.inv (((1 - theta) • A) + theta • B))
      (((1 - theta) • Inv.inv A) + theta • Inv.inv B) := by
  let convexCombo : Matrix (Fin n) (Fin n) Real := ((1 - theta) • A) + theta • B
  let lhs : Matrix (Fin n) (Fin n) Real := Inv.inv convexCombo
  let rhs : Matrix (Fin n) (Fin n) Real := ((1 - theta) • Inv.inv A) + theta • Inv.inv B
  have hConvexCombo : convexCombo.PosDef :=
    convexCombo_posDef_of_posDef A B hA hB h0 h1
  have hHermitian : (rhs - lhs).IsHermitian := by
    have hAinv : (Inv.inv A).IsHermitian := (hA.inv).isHermitian
    have hBinv : (Inv.inv B).IsHermitian := (hB.inv).isHermitian
    have hSelfLeft : IsSelfAdjoint (1 - theta) := by
      change star (1 - theta) = (1 - theta)
      simp
    have hSelfTheta : IsSelfAdjoint theta := by
      change star theta = theta
      simp
    have hRhs : rhs.IsHermitian := by
      dsimp [rhs]
      exact (hAinv.smul hSelfLeft).add (hBinv.smul hSelfTheta)
    have hLhs : lhs.IsHermitian := by
      simpa [lhs] using hConvexCombo.inv.isHermitian
    exact hRhs.sub hLhs
  have hQuad :
      forall x : Fin n -> Real, 0 <= HighDimProb.matrixQuadraticForm (rhs - lhs) x := by
    intro x
    have hx := inv_quadraticForm_convex_combo_le_of_posDef A B hA hB h0 h1 x
    rw [HighDimProb.matrixQuadraticForm_sub]
    apply sub_nonneg.mpr
    change HighDimProb.matrixQuadraticForm (Inv.inv (((1 - theta) • A) + theta • B)) x <=
      HighDimProb.matrixQuadraticForm (((1 - theta) • Inv.inv A) + theta • Inv.inv B) x
    rw [HighDimProb.matrixQuadraticForm_add, HighDimProb.matrixQuadraticForm_smul,
      HighDimProb.matrixQuadraticForm_smul]
    simpa using hx
  apply HighDimProb.matrixLE_of_mathlib_le
  rw [Matrix.le_iff]
  refine (Matrix.posSemidef_iff_dotProduct_mulVec).2 ?_
  constructor
  · exact hHermitian
  · intro x
    simpa [HighDimProb.matrixQuadraticForm, dotProduct, Matrix.mulVec,
      Finset.mul_sum, Finset.sum_mul, mul_assoc] using hQuad x

end

end HighDimProb
