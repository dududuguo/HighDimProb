import HighDimProb.RandomMatrix.RelativeEntropyJointConvexityRouteProvider
import HighDimProb.RandomMatrix.RelativeEntropyLeftRightScalarProvider
import Mathlib.LinearAlgebra.UnitaryGroup
import Mathlib.MeasureTheory.Function.L1Space.Integrable
import Mathlib.Tactic

/-!
# Left/right integral representation for plain trace relative entropy

This module closes the main repository's left/right relative-entropy route. It
adds the quadratic and spectral-overlap normal forms for the concrete integrand,
proves the density integrability and matrix left/right integral representation
premises, and then composes them with the existing route assembly to obtain
unconditional relative-entropy joint convexity, Lieb, and Epstein facades.

It does not prove Tropp, Golden-Thompson, Matrix Bernstein, or the downstream
finite-family conditioning/variance-proxy chain.
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators ComplexOrder Kronecker MatrixOrder Matrix.Norms.Operator Matrix.Norms.L2Operator

noncomputable section

namespace RelativeEntropy

/-- The trace of a real rank-one row sandwich is the corresponding quadratic form. -/
theorem trace_rowMatrixOfVec_mul_mul_conjTranspose
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (v : ι → Real) (M : Matrix ι ι Real) :
    Matrix.trace (rowMatrixOfVec v * M * (rowMatrixOfVec v).conjTranspose) =
      dotProduct v (Matrix.mulVec M v) := by
  simp [rowMatrixOfVec, Matrix.trace, Matrix.diag, Matrix.mul_apply, dotProduct,
    Matrix.mulVec, Finset.univ_unique, Finset.mul_sum, Finset.sum_mul, mul_assoc]
  rw [Finset.sum_comm]

/-- The concrete left/right integrand as a direct row-trace expression. -/
theorem leftRightRelativeEntropyIntegrand_eq_rowTrace
    {n : Type*} [Fintype n] [DecidableEq n]
    (t : Real) (A B : Matrix n n Real) :
    leftRightRelativeEntropyIntegrand t A B =
      Matrix.trace
        (rowMatrixOfVec (Matrix.vec (A - B)) *
          (leftRightDenominatorMatrix A B t)⁻¹ *
          (rowMatrixOfVec (Matrix.vec (A - B))).conjTranspose) := by
  simp [leftRightRelativeEntropyIntegrand, tracePairedInversePerspectiveIntegrand]

/-- The concrete left/right integrand as the quadratic form of the inverse denominator. -/
theorem leftRightRelativeEntropyIntegrand_eq_quadratic
    {n : Type*} [Fintype n] [DecidableEq n]
    (t : Real) (A B : Matrix n n Real) :
    leftRightRelativeEntropyIntegrand t A B =
      dotProduct (Matrix.vec (A - B))
        (Matrix.mulVec (leftRightDenominatorMatrix A B t)⁻¹ (Matrix.vec (A - B))) := by
  rw [leftRightRelativeEntropyIntegrand_eq_rowTrace,
    trace_rowMatrixOfVec_mul_mul_conjTranspose]

private theorem leftRightDenominatorMatrix_mulVec_vec
    {n : Nat} (A B X : Matrix (Fin n) (Fin n) Real) (t : Real) :
    Matrix.mulVec (leftRightDenominatorMatrix A B t) (Matrix.vec X) =
      Matrix.vec (A * X + t • (X * B)) := by
  unfold leftRightDenominatorMatrix
  rw [Matrix.add_mulVec, Matrix.smul_mulVec]
  rw [← Matrix.vec_mul_eq_mulVec A X, Matrix.kronecker_mulVec_vec]
  simp [Matrix.transpose_transpose]

private theorem leftRightDenominatorMatrix_twoSidedUnitary_mulVec_vec
    {n : Nat}
    (U V : Matrix.unitaryGroup (Fin n) Real)
    (A B X : Matrix (Fin n) (Fin n) Real) (t : Real) :
    Matrix.mulVec
        (leftRightDenominatorMatrix
          (Unitary.conjStarAlgAut Real _ U A)
          (Unitary.conjStarAlgAut Real _ V B) t)
        (Matrix.vec ((U : Matrix (Fin n) (Fin n) Real) * X * star (V : Matrix (Fin n) (Fin n) Real))) =
      Matrix.vec
        ((U : Matrix (Fin n) (Fin n) Real) * (A * X + t • (X * B)) *
          star (V : Matrix (Fin n) (Fin n) Real)) := by
  rw [leftRightDenominatorMatrix_mulVec_vec]
  apply congrArg Matrix.vec
  calc
    Unitary.conjStarAlgAut Real _ U A *
          ((U : Matrix (Fin n) (Fin n) Real) * X * star (V : Matrix (Fin n) (Fin n) Real)) +
        t • (((U : Matrix (Fin n) (Fin n) Real) * X * star (V : Matrix (Fin n) (Fin n) Real)) *
          Unitary.conjStarAlgAut Real _ V B)
      = (U : Matrix (Fin n) (Fin n) Real) * (A * X) * star (V : Matrix (Fin n) (Fin n) Real) +
          t • ((U : Matrix (Fin n) (Fin n) Real) * (X * B) * star (V : Matrix (Fin n) (Fin n) Real)) := by
          have hcancelU : ∀ Y : Matrix (Fin n) (Fin n) Real,
              star (U : Matrix (Fin n) (Fin n) Real) *
                  ((U : Matrix (Fin n) (Fin n) Real) * Y) = Y := by
            intro Y
            rw [← Matrix.mul_assoc, Unitary.coe_star_mul_self, Matrix.one_mul]
          have hcancelV : ∀ Y : Matrix (Fin n) (Fin n) Real,
              star (V : Matrix (Fin n) (Fin n) Real) *
                  ((V : Matrix (Fin n) (Fin n) Real) * Y) = Y := by
            intro Y
            rw [← Matrix.mul_assoc, Unitary.coe_star_mul_self, Matrix.one_mul]
          simp [Unitary.conjStarAlgAut_apply, Matrix.mul_assoc, hcancelU, hcancelV]
    _ = (U : Matrix (Fin n) (Fin n) Real) * (A * X + t • (X * B)) *
          star (V : Matrix (Fin n) (Fin n) Real) := by
        rw [Matrix.mul_add, Matrix.add_mul]
        simp [Matrix.mul_assoc]

private theorem leftRightDenominatorMatrix_twoSidedUnitary_diagonal_solve_mulVec_vec
    {n : Nat}
    (U V : Matrix.unitaryGroup (Fin n) Real)
    {d e : Fin n → Real}
    (hd : ∀ i, 0 < d i) (he : ∀ i, 0 < e i)
    {t : Real} (ht : 0 <= t) (Y : Matrix (Fin n) (Fin n) Real) :
    let W : Matrix (Fin n) (Fin n) Real := fun i j => Y i j / (d i + t * e j)
    Matrix.mulVec
        (leftRightDenominatorMatrix
          (Unitary.conjStarAlgAut Real _ U (Matrix.diagonal d))
          (Unitary.conjStarAlgAut Real _ V (Matrix.diagonal e)) t)
        (Matrix.vec ((U : Matrix (Fin n) (Fin n) Real) * W * star (V : Matrix (Fin n) (Fin n) Real))) =
      Matrix.vec ((U : Matrix (Fin n) (Fin n) Real) * Y * star (V : Matrix (Fin n) (Fin n) Real)) := by
  intro W
  rw [leftRightDenominatorMatrix_twoSidedUnitary_mulVec_vec]
  apply congrArg Matrix.vec
  congr 2
  ext i j
  have hden : d i + t * e j ≠ 0 := by
    exact ne_of_gt (add_pos_of_pos_of_nonneg (hd i) (mul_nonneg ht (le_of_lt (he j))))
  simp [W, Matrix.diagonal_mul, Matrix.mul_diagonal, div_eq_mul_inv]
  calc
    d i * (Y i j * (d i + t * e j)⁻¹) +
        t * (Y i j * (d i + t * e j)⁻¹ * e j)
      = (d i + t * e j) * (Y i j * (d i + t * e j)⁻¹) := by
          ring
    _ = Y i j := by
          field_simp [hden]

private theorem leftRightDenominatorMatrix_posDef_spectral_solve_mulVec_vec
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : A.PosDef) (hB : B.PosDef) {t : Real} (ht : 0 <= t) :
    let U := hA.isHermitian.eigenvectorUnitary
    let V := hB.isHermitian.eigenvectorUnitary
    let d := hA.isHermitian.eigenvalues
    let e := hB.isHermitian.eigenvalues
    let Y : Matrix (Fin n) (Fin n) Real := star (U : Matrix (Fin n) (Fin n) Real) * (A - B) *
      (V : Matrix (Fin n) (Fin n) Real)
    let W : Matrix (Fin n) (Fin n) Real := fun i j => Y i j / (d i + t * e j)
    Matrix.mulVec (leftRightDenominatorMatrix A B t)
        (Matrix.vec ((U : Matrix (Fin n) (Fin n) Real) * W * star (V : Matrix (Fin n) (Fin n) Real))) =
      Matrix.vec (A - B) := by
  intro U V d e Y W
  have hspecA : A = Unitary.conjStarAlgAut Real _ U (Matrix.diagonal d) := by
    simpa [U, d, Unitary.conjStarAlgAut_apply] using hA.isHermitian.spectral_theorem
  have hspecB : B = Unitary.conjStarAlgAut Real _ V (Matrix.diagonal e) := by
    simpa [V, e, Unitary.conjStarAlgAut_apply] using hB.isHermitian.spectral_theorem
  calc
    Matrix.mulVec (leftRightDenominatorMatrix A B t)
        (Matrix.vec ((U : Matrix (Fin n) (Fin n) Real) * W * star (V : Matrix (Fin n) (Fin n) Real)))
      = Matrix.mulVec
          (leftRightDenominatorMatrix
            (Unitary.conjStarAlgAut Real (Matrix (Fin n) (Fin n) Real) U (Matrix.diagonal d))
            (Unitary.conjStarAlgAut Real (Matrix (Fin n) (Fin n) Real) V (Matrix.diagonal e)) t)
          (Matrix.vec ((U : Matrix (Fin n) (Fin n) Real) * W * star (V : Matrix (Fin n) (Fin n) Real))) := by
            rw [hspecA, hspecB]
    _ = Matrix.vec ((U : Matrix (Fin n) (Fin n) Real) * Y * star (V : Matrix (Fin n) (Fin n) Real)) := by
          exact leftRightDenominatorMatrix_twoSidedUnitary_diagonal_solve_mulVec_vec
            U V
            (fun i => by simpa [d, U] using hA.eigenvalues_pos i)
            (fun i => by simpa [e, V] using hB.eigenvalues_pos i)
            ht Y
    _ = Matrix.vec (A - B) := by
          apply congrArg Matrix.vec
          rw [show Y = star (U : Matrix (Fin n) (Fin n) Real) * (A - B) *
                (V : Matrix (Fin n) (Fin n) Real) from rfl]
          rw [Matrix.mul_assoc (star (U : Matrix (Fin n) (Fin n) Real)) (A - B)
            (V : Matrix (Fin n) (Fin n) Real)]
          rw [← Matrix.mul_assoc (U : Matrix (Fin n) (Fin n) Real)
            (star (U : Matrix (Fin n) (Fin n) Real)) ((A - B) * (V : Matrix (Fin n) (Fin n) Real))]
          rw [show (U : Matrix (Fin n) (Fin n) Real) * star (U : Matrix (Fin n) (Fin n) Real) = 1 by
            exact Unitary.coe_mul_star_self U]
          simp [Matrix.mul_assoc]

private theorem leftRightDenominatorMatrix_posDef_inv_mulVec_spectral_solve
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : A.PosDef) (hB : B.PosDef) {t : Real} (ht : 0 <= t) :
    let U := hA.isHermitian.eigenvectorUnitary
    let V := hB.isHermitian.eigenvectorUnitary
    let d := hA.isHermitian.eigenvalues
    let e := hB.isHermitian.eigenvalues
    let Y : Matrix (Fin n) (Fin n) Real := star (U : Matrix (Fin n) (Fin n) Real) * (A - B) *
      (V : Matrix (Fin n) (Fin n) Real)
    let W : Matrix (Fin n) (Fin n) Real := fun i j => Y i j / (d i + t * e j)
    Matrix.mulVec (leftRightDenominatorMatrix A B t)⁻¹ (Matrix.vec (A - B)) =
      Matrix.vec ((U : Matrix (Fin n) (Fin n) Real) * W * star (V : Matrix (Fin n) (Fin n) Real)) := by
  intro U V d e Y W
  let D : Matrix (Fin n × Fin n) (Fin n × Fin n) Real := leftRightDenominatorMatrix A B t
  let z : Fin n × Fin n → Real :=
    Matrix.vec ((U : Matrix (Fin n) (Fin n) Real) * W * star (V : Matrix (Fin n) (Fin n) Real))
  have hsolve : Matrix.mulVec D z = Matrix.vec (A - B) := by
    simpa [D, z, U, V, d, e, Y, W] using
      leftRightDenominatorMatrix_posDef_spectral_solve_mulVec_vec hA hB ht
  have hD_pos : D.PosDef := by
    simpa [D] using leftRightDenominatorMatrix_posDef hA hB ht
  have hdet : IsUnit D.det := by
    exact (ne_of_gt hD_pos.det_pos).isUnit
  calc
    Matrix.mulVec D⁻¹ (Matrix.vec (A - B)) = Matrix.mulVec D⁻¹ (Matrix.mulVec D z) := by
      rw [hsolve]
    _ = Matrix.mulVec (D⁻¹ * D) z := by
      rw [Matrix.mulVec_mulVec]
    _ = z := by
      rw [Matrix.nonsing_inv_mul D hdet, Matrix.one_mulVec]

private theorem vec_dotProduct_twoSidedUnitary
    {n : Nat}
    (U V : Matrix.unitaryGroup (Fin n) Real)
    (X W : Matrix (Fin n) (Fin n) Real) :
    dotProduct (Matrix.vec X)
        (Matrix.vec ((U : Matrix (Fin n) (Fin n) Real) * W * star (V : Matrix (Fin n) (Fin n) Real))) =
      dotProduct
        (Matrix.vec (star (U : Matrix (Fin n) (Fin n) Real) * X * (V : Matrix (Fin n) (Fin n) Real)))
        (Matrix.vec W) := by
  rw [Matrix.vec_dotProduct_vec, Matrix.vec_dotProduct_vec]
  simp only [Matrix.star_eq_conjTranspose, Matrix.conjTranspose_eq_transpose_of_trivial,
    Matrix.transpose_transpose, Matrix.transpose_mul]
  have htrace :
      Matrix.trace
          (X.transpose *
            (((U : Matrix (Fin n) (Fin n) Real) * W) * (V : Matrix (Fin n) (Fin n) Real).transpose)) =
        Matrix.trace
          ((V : Matrix (Fin n) (Fin n) Real).transpose *
            (X.transpose * ((U : Matrix (Fin n) (Fin n) Real) * W))) := by
    rw [show X.transpose *
          (((U : Matrix (Fin n) (Fin n) Real) * W) * (V : Matrix (Fin n) (Fin n) Real).transpose) =
        (X.transpose * ((U : Matrix (Fin n) (Fin n) Real) * W)) *
          (V : Matrix (Fin n) (Fin n) Real).transpose by
      simp [Matrix.mul_assoc]]
    rw [Matrix.trace_mul_comm]
  rw [htrace]
  simp [Matrix.mul_assoc]

/-- Rewrite the concrete left/right integrand into the double sum over the
spectral coordinates of the conjugated difference matrix. -/
theorem leftRightRelativeEntropyIntegrand_posDef_spectral
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : A.PosDef) (hB : B.PosDef)
    {t : Real} (ht : 0 <= t) :
    let U := hA.isHermitian.eigenvectorUnitary
    let V := hB.isHermitian.eigenvectorUnitary
    let d := hA.isHermitian.eigenvalues
    let e := hB.isHermitian.eigenvalues
    let Y : Matrix (Fin n) (Fin n) Real := star (U : Matrix (Fin n) (Fin n) Real) * (A - B) *
      (V : Matrix (Fin n) (Fin n) Real)
    leftRightRelativeEntropyIntegrand t A B =
      ∑ i, ∑ j, (Y i j) ^ 2 / (d i + t * e j) := by
  intro U V d e Y
  let W : Matrix (Fin n) (Fin n) Real := fun i j => Y i j / (d i + t * e j)
  rw [leftRightRelativeEntropyIntegrand_eq_quadratic]
  rw [leftRightDenominatorMatrix_posDef_inv_mulVec_spectral_solve hA hB ht]
  change dotProduct (Matrix.vec (A - B))
      (Matrix.vec ((U : Matrix (Fin n) (Fin n) Real) * W * star (V : Matrix (Fin n) (Fin n) Real))) =
    ∑ i, ∑ j, (Y i j) ^ 2 / (d i + t * e j)
  rw [vec_dotProduct_twoSidedUnitary U V (A - B) W]
  have hY : star (U : Matrix (Fin n) (Fin n) Real) * (A - B) * (V : Matrix (Fin n) (Fin n) Real) = Y :=
    rfl
  rw [hY]
  simp [dotProduct, Matrix.vec, W, pow_two, div_eq_mul_inv, Fintype.sum_prod_type, mul_assoc]
  rw [Finset.sum_comm]

/-- Compute the spectral coordinates of `A - B` in the two-sided eigenbasis of
positive-definite `A` and `B`. -/
theorem posDef_spectral_difference_twoSided_entries
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : A.PosDef) (hB : B.PosDef) :
    let U := hA.isHermitian.eigenvectorUnitary
    let V := hB.isHermitian.eigenvectorUnitary
    let d := hA.isHermitian.eigenvalues
    let e := hB.isHermitian.eigenvalues
    let C : Matrix (Fin n) (Fin n) Real := star (U : Matrix (Fin n) (Fin n) Real) *
      (V : Matrix (Fin n) (Fin n) Real)
    ∀ i j,
      (star (U : Matrix (Fin n) (Fin n) Real) * (A - B) * (V : Matrix (Fin n) (Fin n) Real)) i j =
        (d i - e j) * C i j := by
  intro U V d e C i j
  have hspecA : A = Unitary.conjStarAlgAut Real _ U (Matrix.diagonal d) := by
    simpa [U, d, Unitary.conjStarAlgAut_apply] using hA.isHermitian.spectral_theorem
  have hspecB : B = Unitary.conjStarAlgAut Real _ V (Matrix.diagonal e) := by
    simpa [V, e, Unitary.conjStarAlgAut_apply] using hB.isHermitian.spectral_theorem
  have hC : C = star (U : Matrix (Fin n) (Fin n) Real) * (V : Matrix (Fin n) (Fin n) Real) := rfl
  have hcancelU : ∀ Y : Matrix (Fin n) (Fin n) Real,
      star (U : Matrix (Fin n) (Fin n) Real) * ((U : Matrix (Fin n) (Fin n) Real) * Y) = Y := by
    intro Y
    rw [← Matrix.mul_assoc, Unitary.coe_star_mul_self, Matrix.one_mul]
  have hleft :
      star (U : Matrix (Fin n) (Fin n) Real) * A * (V : Matrix (Fin n) (Fin n) Real) =
        Matrix.diagonal d * C := by
    rw [hspecA]
    simp [hC, Unitary.conjStarAlgAut_apply, Matrix.mul_assoc, hcancelU]
  have hright :
      star (U : Matrix (Fin n) (Fin n) Real) * B * (V : Matrix (Fin n) (Fin n) Real) =
        C * Matrix.diagonal e := by
    rw [hspecB]
    simp [hC, Unitary.conjStarAlgAut_apply, Matrix.mul_assoc]
  calc
    (star (U : Matrix (Fin n) (Fin n) Real) * (A - B) * (V : Matrix (Fin n) (Fin n) Real)) i j
      = (star (U : Matrix (Fin n) (Fin n) Real) * A * (V : Matrix (Fin n) (Fin n) Real) -
          star (U : Matrix (Fin n) (Fin n) Real) * B * (V : Matrix (Fin n) (Fin n) Real)) i j := by
          simp [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_assoc]
    _ = (Matrix.diagonal d * C - C * Matrix.diagonal e) i j := by
          rw [hleft, hright]
    _ = (d i - e j) * C i j := by
          simp [Matrix.diagonal_mul, Matrix.mul_diagonal]
          ring

/-- Rewrite the concrete left/right integrand as the overlap-weighted spectral
sum carried by the eigenvector overlap matrix of `A` and `B`. -/
theorem leftRightRelativeEntropyIntegrand_posDef_spectral_overlap
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : A.PosDef) (hB : B.PosDef)
    {t : Real} (ht : 0 <= t) :
    let d := hA.isHermitian.eigenvalues
    let e := hB.isHermitian.eigenvalues
    leftRightRelativeEntropyIntegrand t A B =
      ∑ i, ∑ j,
        overlapWeight hA.isHermitian hB.isHermitian i j *
          ((d j - e i) ^ 2 / (d j + t * e i)) := by
  intro d e
  let U := hA.isHermitian.eigenvectorUnitary
  let V := hB.isHermitian.eigenvectorUnitary
  let C : Matrix (Fin n) (Fin n) Real := star (U : Matrix (Fin n) (Fin n) Real) *
    (V : Matrix (Fin n) (Fin n) Real)
  have hraw :
      leftRightRelativeEntropyIntegrand t A B =
        ∑ i, ∑ j, (C i j) ^ 2 * ((d i - e j) ^ 2 / (d i + t * e j)) := by
    rw [leftRightRelativeEntropyIntegrand_posDef_spectral hA hB ht]
    change
      ∑ i, ∑ j,
          ((star (U : Matrix (Fin n) (Fin n) Real) * (A - B) *
              (V : Matrix (Fin n) (Fin n) Real)) i j) ^ 2 /
            (d i + t * e j) =
        ∑ i, ∑ j, (C i j) ^ 2 * ((d i - e j) ^ 2 / (d i + t * e j))
    have hentry :
        ∀ i j,
          (star (U : Matrix (Fin n) (Fin n) Real) * (A - B) * (V : Matrix (Fin n) (Fin n) Real)) i j =
            (d i - e j) * C i j := by
      simpa [U, V, d, e, C] using posDef_spectral_difference_twoSided_entries hA hB
    refine Finset.sum_congr rfl ?_
    intro i hi
    refine Finset.sum_congr rfl ?_
    intro j hj
    rw [hentry i j]
    ring
  calc
    leftRightRelativeEntropyIntegrand t A B
      = ∑ i, ∑ j, (C i j) ^ 2 * ((d i - e j) ^ 2 / (d i + t * e j)) := hraw
    _ = ∑ i, ∑ j,
          overlapWeight hA.isHermitian hB.isHermitian i j *
            ((d j - e i) ^ 2 / (d j + t * e i)) := by
          rw [Finset.sum_comm]
          simp [C, U, V, overlapWeight]

end RelativeEntropy

/-- The weighted left/right integrand is integrable on `(0, inf)` for every
positive-definite pair. -/
theorem leftRightRelativeEntropyIntegrandDensityIntegrable :
    LeftRightRelativeEntropyIntegrandDensityIntegrable := by
  intro n A B hA hB
  let d := hA.isHermitian.eigenvalues
  let e := hB.isHermitian.eigenvalues
  let f : Fin n → Fin n → Real → Real :=
    fun i j t =>
      RelativeEntropy.overlapWeight hA.isHermitian hB.isHermitian i j *
        (((d j - e i) ^ 2 * t) / ((d j + t * e i) * (1 + t) ^ 2))
  have hd : ∀ j, 0 < d j := by
    intro j
    simpa [d] using hA.eigenvalues_pos j
  have he : ∀ i, 0 < e i := by
    intro i
    simpa [e] using hB.eigenvalues_pos i
  have hf : IntegrableOn (fun t : Real => ∑ i, ∑ j, f i j t) (Set.Ioi (0 : Real)) := by
    rw [IntegrableOn]
    exact integrable_finset_sum Finset.univ fun i hi =>
      integrable_finset_sum Finset.univ fun j hj =>
        (RelativeEntropy.real_relativeEntropy_integrand_integrableOn
          (a := d j) (b := e i) (hd j) (he i)).const_mul
            (RelativeEntropy.overlapWeight hA.isHermitian hB.isHermitian i j)
  refine hf.congr_fun ?_ measurableSet_Ioi
  intro t ht
  change (∑ i, ∑ j, f i j t) =
    (t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t A B
  rw [RelativeEntropy.leftRightRelativeEntropyIntegrand_posDef_spectral_overlap
    hA hB (le_of_lt ht)]
  simp only [f]
  rw [Finset.mul_sum]
  refine (Finset.sum_congr rfl ?_).symm
  intro i hi
  rw [Finset.mul_sum]
  refine (Finset.sum_congr rfl ?_).symm
  intro j hj
  have hden₁ : d j + t * e i ≠ 0 := by
    exact
      (add_pos_of_pos_of_nonneg (hd j) (mul_nonneg (le_of_lt ht) (le_of_lt (he i)))).ne'
  have hden₂ : (1 + t) ^ 2 ≠ 0 := by
    have h1t_pos : 0 < 1 + t := by
      linarith [show 0 < t from ht]
    exact pow_ne_zero 2 h1t_pos.ne'
  field_simp [hden₁, hden₂]
  ring

namespace RelativeEntropy

private theorem integral_leftRightRelativeEntropyIntegrand_posDef_spectral_overlap_density
    {n : Nat} {T A : Matrix (Fin n) (Fin n) Real}
    (hT : T.PosDef) (hA : A.PosDef) :
    ∫ t in Set.Ioi (0 : Real),
        (t / (1 + t) ^ 2) * leftRightRelativeEntropyIntegrand t T A =
      ∑ i, ∑ j,
        overlapWeight hT.isHermitian hA.isHermitian i j *
          (hT.isHermitian.eigenvalues j *
              (Real.log (hT.isHermitian.eigenvalues j) -
                Real.log (hA.isHermitian.eigenvalues i)) -
            (hT.isHermitian.eigenvalues j - hA.isHermitian.eigenvalues i)) := by
  let d := hT.isHermitian.eigenvalues
  let e := hA.isHermitian.eigenvalues
  let f : Fin n → Fin n → Real → Real :=
    fun i j t =>
      overlapWeight hT.isHermitian hA.isHermitian i j *
        ((t / (1 + t) ^ 2) * ((d j - e i) ^ 2 / (d j + t * e i)))
  have hd : ∀ j, 0 < d j := by
    intro j
    simpa [d] using hT.eigenvalues_pos j
  have he : ∀ i, 0 < e i := by
    intro i
    simpa [e] using hA.eigenvalues_pos i
  calc
    ∫ t in Set.Ioi (0 : Real),
        (t / (1 + t) ^ 2) * leftRightRelativeEntropyIntegrand t T A
      = ∫ t in Set.Ioi (0 : Real), ∑ i, ∑ j, f i j t := by
          refine setIntegral_congr_fun measurableSet_Ioi ?_
          intro t ht
          change
            (t / (1 + t) ^ 2) * leftRightRelativeEntropyIntegrand t T A =
              ∑ i, ∑ j, f i j t
          rw [leftRightRelativeEntropyIntegrand_posDef_spectral_overlap hT hA (le_of_lt ht)]
          simp only [f, d, e]
          rw [Finset.mul_sum]
          refine Finset.sum_congr rfl ?_
          intro i hi
          rw [Finset.mul_sum]
          refine Finset.sum_congr rfl ?_
          intro j hj
          ring
    _ = ∑ i, ∫ t in Set.Ioi (0 : Real), ∑ j, f i j t := by
      rw [integral_finset_sum]
      intro i hi
      exact integrable_finset_sum Finset.univ fun j hj => by
        have hbaseEq :
            Set.EqOn
              (fun t : Real =>
                (t / (1 + t) ^ 2) * ((d j - e i) ^ 2 / (d j + t * e i)))
              (fun t : Real =>
                ((d j - e i) ^ 2 * t) / ((d j + t * e i) * (1 + t) ^ 2))
              (Set.Ioi (0 : Real)) := by
          intro t ht
          have hden₁ : d j + t * e i ≠ 0 := by
            exact
              (add_pos_of_pos_of_nonneg (hd j) (mul_nonneg (le_of_lt ht) (le_of_lt (he i)))).ne'
          have hden₂ : (1 + t) ^ 2 ≠ 0 := by
            have h1t_pos : 0 < 1 + t := by
              linarith [show 0 < t from ht]
            exact pow_ne_zero 2 h1t_pos.ne'
          field_simp [hden₁, hden₂]
        have hbaseInt :
            IntegrableOn
              (fun t : Real =>
                (t / (1 + t) ^ 2) * ((d j - e i) ^ 2 / (d j + t * e i)))
              (Set.Ioi (0 : Real)) := by
          exact
            (real_relativeEntropy_integrand_integrableOn
              (a := d j) (b := e i) (hd j) (he i)).congr_fun
                hbaseEq.symm measurableSet_Ioi
        change IntegrableOn
          (fun t : Real =>
            overlapWeight hT.isHermitian hA.isHermitian i j *
              ((t / (1 + t) ^ 2) * ((d j - e i) ^ 2 / (d j + t * e i))))
          (Set.Ioi (0 : Real))
        exact hbaseInt.const_mul (overlapWeight hT.isHermitian hA.isHermitian i j)
    _ = ∑ i, ∑ j, ∫ t in Set.Ioi (0 : Real), f i j t := by
      refine Finset.sum_congr rfl ?_
      intro i hi
      rw [integral_finset_sum]
      intro j hj
      have hbaseEq :
          Set.EqOn
            (fun t : Real =>
              (t / (1 + t) ^ 2) * ((d j - e i) ^ 2 / (d j + t * e i)))
            (fun t : Real =>
              ((d j - e i) ^ 2 * t) / ((d j + t * e i) * (1 + t) ^ 2))
            (Set.Ioi (0 : Real)) := by
        intro t ht
        have hden₁ : d j + t * e i ≠ 0 := by
          exact
            (add_pos_of_pos_of_nonneg (hd j) (mul_nonneg (le_of_lt ht) (le_of_lt (he i)))).ne'
        have hden₂ : (1 + t) ^ 2 ≠ 0 := by
          have h1t_pos : 0 < 1 + t := by
            linarith [show 0 < t from ht]
          exact pow_ne_zero 2 h1t_pos.ne'
        field_simp [hden₁, hden₂]
      have hbaseInt :
          IntegrableOn
            (fun t : Real =>
              (t / (1 + t) ^ 2) * ((d j - e i) ^ 2 / (d j + t * e i)))
            (Set.Ioi (0 : Real)) := by
        exact
          (real_relativeEntropy_integrand_integrableOn
            (a := d j) (b := e i) (hd j) (he i)).congr_fun
              hbaseEq.symm measurableSet_Ioi
      change IntegrableOn
        (fun t : Real =>
          overlapWeight hT.isHermitian hA.isHermitian i j *
            ((t / (1 + t) ^ 2) * ((d j - e i) ^ 2 / (d j + t * e i))))
        (Set.Ioi (0 : Real))
      exact hbaseInt.const_mul (overlapWeight hT.isHermitian hA.isHermitian i j)
    _ = ∑ i, ∑ j,
          overlapWeight hT.isHermitian hA.isHermitian i j *
            (hT.isHermitian.eigenvalues j *
                (Real.log (hT.isHermitian.eigenvalues j) -
                  Real.log (hA.isHermitian.eigenvalues i)) -
              (hT.isHermitian.eigenvalues j - hA.isHermitian.eigenvalues i)) := by
      refine Finset.sum_congr rfl ?_
      intro i hi
      refine Finset.sum_congr rfl ?_
      intro j hj
      simp [d, e, f, integral_const_mul,
        real_relativeEntropy_integral_representation_density (a := d j) (b := e i) (hd j) (he i)]

private theorem traceMatrixRelativeEntropyPlain_kleinCorrection_integral
    {n : Nat} {T A : Matrix (Fin n) (Fin n) Real}
    (hT : T.PosDef) (hA : A.PosDef) :
    Matrix.trace (T * CFC.log T) - Matrix.trace (T * CFC.log A) - Matrix.trace T + Matrix.trace A =
      ∫ t in Set.Ioi (0 : Real),
        (t / (1 + t) ^ 2) * leftRightRelativeEntropyIntegrand t T A := by
  let d := hT.isHermitian.eigenvalues
  let e := hA.isHermitian.eigenvalues
  have hKlein :
      Matrix.trace (T * CFC.log T) - Matrix.trace (T * CFC.log A) - Matrix.trace T + Matrix.trace A =
        ∑ i, ∑ j,
          overlapWeight hT.isHermitian hA.isHermitian i j *
            (d j * (Real.log (d j) - Real.log (e i)) - (d j - e i)) := by
    calc
      Matrix.trace (T * CFC.log T) - Matrix.trace (T * CFC.log A) - Matrix.trace T + Matrix.trace A
        = ∑ i, ∑ j,
            overlapWeight hT.isHermitian hA.isHermitian i j *
              (d j * Real.log (d j / e i) - d j + e i) := by
            simpa [d, e] using
              fullMatrixKlein_eq_weightedSpectralSum_of_isHermitian_of_strictlyPositive
                hT.isHermitian hA.isHermitian
                (Matrix.isStrictlyPositive_iff_posDef.mpr hT)
                (Matrix.isStrictlyPositive_iff_posDef.mpr hA)
      _ = ∑ i, ∑ j,
            overlapWeight hT.isHermitian hA.isHermitian i j *
              (d j * (Real.log (d j) - Real.log (e i)) - (d j - e i)) := by
            refine Finset.sum_congr rfl ?_
            intro i hi
            refine Finset.sum_congr rfl ?_
            intro j hj
            rw [Real.log_div (ne_of_gt (hT.eigenvalues_pos j)) (ne_of_gt (hA.eigenvalues_pos i))]
            ring
  rw [hKlein, integral_leftRightRelativeEntropyIntegrand_posDef_spectral_overlap_density hT hA]

end RelativeEntropy

/-- The plain trace relative entropy is the affine trace term plus the weighted
left/right integral under positive-definite inputs. -/
theorem traceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation :
    TraceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation := by
  intro n T A hT hA
  have hcorr := RelativeEntropy.traceMatrixRelativeEntropyPlain_kleinCorrection_integral hT hA
  have hcorr' :
      (Matrix.trace (T * CFC.log T) - Matrix.trace (T * CFC.log A) - Matrix.trace T +
          Matrix.trace A) +
        (Matrix.trace T - Matrix.trace A) =
      (∫ t in Set.Ioi (0 : Real),
          (t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T A) +
        (Matrix.trace T - Matrix.trace A) := by
    exact congrArg (fun x => x + (Matrix.trace T - Matrix.trace A)) hcorr
  calc
    RelativeEntropy.traceMatrixRelativeEntropyPlain T A
      = Matrix.trace (T * CFC.log T) - Matrix.trace (T * CFC.log A) := by
          simp [RelativeEntropy.traceMatrixRelativeEntropyPlain, Matrix.mul_sub, Matrix.trace_sub]
    _ = (Matrix.trace (T * CFC.log T) - Matrix.trace (T * CFC.log A) - Matrix.trace T + Matrix.trace A) +
          (Matrix.trace T - Matrix.trace A) := by
            ring
    _ = (∫ t in Set.Ioi (0 : Real),
          (t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T A) +
          (Matrix.trace T - Matrix.trace A) := by
            exact hcorr'
    _ = (Matrix.trace T - Matrix.trace A) +
        ∫ t in Set.Ioi (0 : Real),
          (t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T A := by
            rw [add_comm]
    _ = Matrix.trace (T - A) +
        ∫ t in Set.Ioi (0 : Real),
          (t / (1 + t) ^ 2) * RelativeEntropy.leftRightRelativeEntropyIntegrand t T A := by
            rw [Matrix.trace_sub]

/-- The proved density integrability and left/right integral representation
discharge the ambient plain trace-entropy joint-convexity contract. -/
theorem traceMatrixRelativeEntropyPlain_jointConvex_of_leftRight :
    TraceMatrixRelativeEntropyPlainJointConvexity :=
  traceMatrixRelativeEntropyPlain_jointConvex_of_leftRight_density_integral_representation
    leftRightRelativeEntropyIntegrandDensityIntegrable
    traceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation

/-- The left/right route proves the carrier relative-entropy joint-convexity
contract used by the Gibbs-to-Epstein bridge. -/
theorem relativeEntropyJointConvexity_of_leftRight :
    RelativeEntropyJointConvexity :=
  relativeEntropyJointConvexity_of_leftRight_density_integral_representation
    leftRightRelativeEntropyIntegrandDensityIntegrable
    traceMatrixRelativeEntropyPlainLeftRightIntegralRepresentation

namespace RelativeEntropy

/-- Carrier Lieb concavity from the proved left/right relative-entropy route
and full matrix Klein. -/
theorem fullKlein_liebCarrierConcavity_of_leftRight :
    forall {n : Nat} (H : Matrix (Fin n) (Fin n) Real),
      IsSelfAdjointMatrix H ->
        ConcaveOn Real (selfAdjointStrictlyPositiveSet n)
          (fun A : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
            traceMatrixExp (H + CFC.log (A : Matrix (Fin n) (Fin n) Real))) :=
  fullKlein_liebCarrierConcavity relativeEntropyJointConvexity_of_leftRight

/-- Provider Lieb concavity theorem obtained by the left/right relative-entropy
route and full matrix Klein. -/
theorem fullKlein_liebConcavity_of_leftRight
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real) :
    liebTraceExpConcavity_statement H :=
  fullKlein_liebConcavity relativeEntropyJointConvexity_of_leftRight H

/-- Provider Epstein affine-line concavity obtained by the left/right
relative-entropy route and full matrix Klein. -/
theorem fullKlein_epsteinConcavity_of_leftRight : EpsteinAffineLineConcavity :=
  fullKlein_epsteinConcavity relativeEntropyJointConvexity_of_leftRight

end RelativeEntropy

/-- Root-level provider Lieb concavity theorem obtained by the left/right
relative-entropy route and full matrix Klein. -/
theorem liebTraceExpConcavity_statement_of_leftRight
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real) :
    liebTraceExpConcavity_statement H :=
  RelativeEntropy.fullKlein_liebConcavity_of_leftRight H

/-- Root-level provider Epstein affine-line concavity theorem obtained by the
left/right relative-entropy route and full matrix Klein. -/
theorem epsteinAffineLineConcavity_of_leftRight : EpsteinAffineLineConcavity :=
  RelativeEntropy.fullKlein_epsteinConcavity_of_leftRight

end

end HighDimProb
