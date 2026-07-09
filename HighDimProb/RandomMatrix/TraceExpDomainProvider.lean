import HighDimProb.RandomMatrix.Assumptions
import HighDimProb.RandomMatrix.TraceExp
import HighDimProb.RandomMatrix.VarianceProxy
import Mathlib.Analysis.Matrix.Order

/-!
# Matrix-exponential expectation positivity

This module owns the finite-dimensional domain bridge used by trace-exp
conditioning: if a random matrix is pointwise self-adjoint and its matrix
exponential is entrywise integrable, then the expectation of that matrix
exponential is strictly positive.
-/

namespace HighDimProb

open MeasureTheory
open scoped ProbabilityTheory MatrixOrder Matrix.Norms.L2Operator

noncomputable section

/-- Entrywise integrability of a random matrix implies integrability of every
fixed quadratic form. -/
theorem matrixQuadraticForm_integrable_of_integrableRandomMatrix
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {A : RandomMatrix Omega n n} (hA : IntegrableRandomMatrix P A)
    (x : Fin n -> Real) :
    Integrable (fun omega => matrixQuadraticForm (A omega) x) P := by
  unfold matrixQuadraticForm
  exact integrable_finset_sum Finset.univ fun i _ =>
    integrable_finset_sum Finset.univ fun j _ =>
      ((hA i j).const_mul (x i)).mul_const (x j)

/-- HighDimProb's explicit quadratic-form normal form agrees with Mathlib's
star-dot-product matrix-vector form over real matrices. -/
theorem matrixQuadraticForm_eq_star_dotProduct_mulVec
    {n : Nat} (A : Matrix (Fin n) (Fin n) Real) (x : Fin n -> Real) :
    matrixQuadraticForm A x = dotProduct (star x) (Matrix.mulVec A x) := by
  simp [matrixQuadraticForm, dotProduct, Matrix.mulVec,
    Finset.mul_sum, mul_assoc]

/-- The matrix exponential of a real self-adjoint matrix is strictly positive. -/
theorem matrixExp_isStrictlyPositive_of_selfAdjoint {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : IsSelfAdjointMatrix A) :
    IsStrictlyPositive (matrixExp A) := by
  have hNonneg : 0 <= matrixExp A := by
    simpa [matrixExp] using IsSelfAdjoint.exp_nonneg hA.isSelfAdjoint
  have hUnit : IsUnit (matrixExp A) := by
    simpa [matrixExp] using Matrix.isUnit_exp A
  exact hUnit.isStrictlyPositive hNonneg

/-- The expectation of `matrixExp Z` is strictly positive for a pointwise
self-adjoint random matrix `Z`, under entrywise integrability of `matrixExp Z`.

This is the trace-exp domain fact used before applying matrix logarithms to
matrix-exponential means. -/
theorem isStrictlyPositive_matrixExpect_matrixExp_of_randomSelfAdjoint
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {n : Nat} {Z : RandomMatrix Omega n n}
    (hZSA : RandomSelfAdjointMatrix P Z)
    (hExpInt : IntegrableRandomMatrix P (fun omega => matrixExp (Z omega))) :
    IsStrictlyPositive (matrixExpect P (fun omega => matrixExp (Z omega))) := by
  let A : RandomMatrix Omega n n := fun omega => matrixExp (Z omega)
  have hMeanSA : IsSelfAdjointMatrix (matrixExpect P A) := by
    apply isSelfAdjointMatrix_matrixExpect_of_randomSelfAdjoint
    intro omega
    exact isSelfAdjointMatrix_matrixExp (hZSA omega)
  rw [Matrix.isStrictlyPositive_iff_posDef]
  refine Matrix.PosDef.of_dotProduct_mulVec_pos hMeanSA ?_
  intro x hx
  let q : Omega -> Real := fun omega => matrixQuadraticForm (A omega) x
  have hq_int : Integrable q P := by
    change Integrable (fun omega => matrixQuadraticForm (A omega) x) P
    exact
      matrixQuadraticForm_integrable_of_integrableRandomMatrix
        (P := P) (A := A) hExpInt x
  have hq_nonneg : 0 ≤ᵐ[P] q := by
    exact ae_of_all P fun omega => by
      dsimp [q, A]
      exact matrixQuadraticForm_nonneg_of_posSemidef
        (matrixExp_posSemidef_of_selfAdjoint (hZSA omega)) x
  have hq_pos_ae : ∀ᵐ omega ∂P, 0 < q omega := by
    exact ae_of_all P fun omega => by
      have hpd : (matrixExp (Z omega)).PosDef :=
        Matrix.isStrictlyPositive_iff_posDef.mp
          (matrixExp_isStrictlyPositive_of_selfAdjoint (hZSA omega))
      have hdot := Matrix.PosDef.dotProduct_mulVec_pos hpd hx
      change 0 < matrixQuadraticForm (matrixExp (Z omega)) x
      rw [matrixQuadraticForm_eq_star_dotProduct_mulVec]
      exact hdot
  have hsupport_ae : Set.univ ≤ᵐ[P] Function.support q := by
    filter_upwards [hq_pos_ae] with _ hpos _
    exact hpos.ne'
  have hsupport_pos : 0 < P (Function.support q) := by
    have hmono : P Set.univ ≤ P (Function.support q) := measure_mono_ae hsupport_ae
    have h_univ_pos : 0 < P Set.univ := by simp
    exact lt_of_lt_of_le h_univ_pos hmono
  have hq_integral_pos : 0 < ∫ omega, q omega ∂P :=
    (MeasureTheory.integral_pos_iff_support_of_nonneg_ae hq_nonneg hq_int).2 hsupport_pos
  have hquad_pos : 0 < matrixQuadraticForm (matrixExpect P A) x := by
    rw [matrixQuadraticForm_matrixExpect (P := P) (A := A) hExpInt x]
    change 0 < ∫ omega, q omega ∂P
    exact hq_integral_pos
  rw [← matrixQuadraticForm_eq_star_dotProduct_mulVec]
  exact hquad_pos

end

end HighDimProb
