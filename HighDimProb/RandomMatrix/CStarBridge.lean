import HighDimProb.RandomMatrix.MatrixOrder
import Mathlib.Analysis.CStarAlgebra.CStarMatrix
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Instances
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Unique
import Mathlib.Analysis.Matrix.HermitianFunctionalCalculus
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.ExpLog.Basic
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.ExpLog.Order
/-!
# Real matrix to CStarMatrix bridge

This module contains the representation bridge needed to reuse Mathlib's CStar
functional-calculus order API from the real-matrix RandomMatrix layer. The
transport lemmas below move strict positivity, matrix order, and CFC logarithms
between HighDimProb's real-matrix vocabulary and Mathlib's `CStarMatrix` model.
They deliberately do not prove Lieb, Golden-Thompson, Tropp trace-MGF, or Matrix
Bernstein.
-/

namespace HighDimProb

noncomputable section

open scoped ComplexOrder MatrixOrder Matrix.Norms.Operator

/-- Embed a real square matrix into Mathlib's complex `CStarMatrix` model.

The map is entrywise `Real -> Complex` followed by `CStarMatrix.ofMatrix`.
It is a representation bridge only; it does not change HighDimProb's public
real-matrix order or random-matrix vocabulary. -/
def realMatrixToCStarMatrix {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) :
    CStarMatrix (Fin n) (Fin n) Complex :=
  CStarMatrix.ofMatrix (A.map (algebraMap Real Complex))

@[simp]
theorem realMatrixToCStarMatrix_apply {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) (i j : Fin n) :
    realMatrixToCStarMatrix A i j = (A i j : Complex) :=
  rfl

@[simp]
theorem realMatrixToCStarMatrix_zero {n : Nat} :
    realMatrixToCStarMatrix (0 : Matrix (Fin n) (Fin n) Real) = 0 := by
  ext i j
  simp [realMatrixToCStarMatrix]

@[simp]
theorem realMatrixToCStarMatrix_add {n : Nat}
    (A B : Matrix (Fin n) (Fin n) Real) :
    realMatrixToCStarMatrix (A + B) =
      realMatrixToCStarMatrix A + realMatrixToCStarMatrix B := by
  ext i j
  simp [realMatrixToCStarMatrix]

@[simp]
theorem realMatrixToCStarMatrix_neg {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) :
    realMatrixToCStarMatrix (-A) = -realMatrixToCStarMatrix A := by
  ext i j
  simp [realMatrixToCStarMatrix]

@[simp]
theorem realMatrixToCStarMatrix_sub {n : Nat}
    (A B : Matrix (Fin n) (Fin n) Real) :
    realMatrixToCStarMatrix (A - B) =
      realMatrixToCStarMatrix A - realMatrixToCStarMatrix B := by
  ext i j
  simp [realMatrixToCStarMatrix, sub_eq_add_neg]

/-- Self-adjoint real matrices transport to self-adjoint CStar matrices. -/
theorem isSelfAdjoint_realMatrixToCStarMatrix {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : IsSelfAdjointMatrix A) :
    IsSelfAdjoint (realMatrixToCStarMatrix A) := by
  rw [IsSelfAdjoint]
  apply CStarMatrix.ext
  intro i j
  rw [CStarMatrix.star_apply]
  have hsym : A j i = A i j := by
    have h := Matrix.IsHermitian.apply hA j i
    simpa using h.symm
  simp [realMatrixToCStarMatrix, hsym]

local instance cstarMatrixRealCFC {n : Nat} :
    ContinuousFunctionalCalculus Real
      (CStarMatrix (Fin n) (Fin n) Complex) IsSelfAdjoint :=
  IsSelfAdjoint.instContinuousFunctionalCalculus

/-- The HighDimProb real-to-`CStarMatrix` representation as a real star-algebra hom. -/
def realMatrixToCStarStarAlgHom {n : Nat} :
    Matrix (Fin n) (Fin n) Real →⋆ₐ[Real]
      CStarMatrix (Fin n) (Fin n) Complex where
  toFun := HighDimProb.realMatrixToCStarMatrix
  map_zero' := by
    ext i j
    simp [HighDimProb.realMatrixToCStarMatrix]
  map_one' := by
    ext i j
    by_cases h : i = j
    · subst j
      simp [HighDimProb.realMatrixToCStarMatrix]
    · simp [HighDimProb.realMatrixToCStarMatrix, h]
  map_add' A B := by
    ext i j
    simp [HighDimProb.realMatrixToCStarMatrix]
  map_mul' A B := by
    ext i j
    simp [HighDimProb.realMatrixToCStarMatrix, CStarMatrix.mul_apply, Matrix.mul_apply]
  commutes' r := by
    ext i j
    by_cases h : i = j
    · subst j
      simp [HighDimProb.realMatrixToCStarMatrix, CStarMatrix.algebraMap_apply,
        Algebra.algebraMap_eq_smul_one]
    · simp [HighDimProb.realMatrixToCStarMatrix, CStarMatrix.algebraMap_apply,
        Algebra.algebraMap_eq_smul_one, h]
  map_star' A := by
    ext i j
    simp [HighDimProb.realMatrixToCStarMatrix, CStarMatrix.star_apply, Matrix.star_apply]

private theorem realMatrixToCStar_mem_positiveCone_of_mem_positiveCone {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real}
    (hA : A ∈ AddSubmonoid.closure
      (Set.range fun B : Matrix (Fin n) (Fin n) Real => star B * B)) :
    HighDimProb.realMatrixToCStarMatrix A ∈ AddSubmonoid.closure
      (Set.range fun B : CStarMatrix (Fin n) (Fin n) Complex => star B * B) := by
  induction hA using AddSubmonoid.closure_induction with
  | zero =>
      simp
  | add X Y _ _ ihX ihY =>
      simpa [map_add] using AddSubmonoid.add_mem _ ihX ihY
  | mem X hX =>
      rcases hX with ⟨B, rfl⟩
      refine AddSubmonoid.subset_closure ?_
      refine ⟨HighDimProb.realMatrixToCStarMatrix B, ?_⟩
      change star (realMatrixToCStarStarAlgHom (n := n) B) *
          realMatrixToCStarStarAlgHom (n := n) B =
        realMatrixToCStarStarAlgHom (n := n) (star B * B)
      rw [map_mul, map_star]

/-- Nonnegativity of a real matrix transports through the `CStarMatrix`
representation. -/
theorem realMatrixToCStar_nonneg {n : Nat} {A : Matrix (Fin n) (Fin n) Real}
    (hA : 0 <= A) :
    0 <= HighDimProb.realMatrixToCStarMatrix A := by
  rw [StarOrderedRing.nonneg_iff] at hA
  rw [StarOrderedRing.nonneg_iff]
  exact realMatrixToCStar_mem_positiveCone_of_mem_positiveCone hA

/-- Strict positivity of a real matrix transports through the `CStarMatrix`
representation. -/
theorem realMatrixToCStar_strictlyPositive {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : IsStrictlyPositive A) :
    IsStrictlyPositive (HighDimProb.realMatrixToCStarMatrix A) := by
  have hNonneg : 0 <= HighDimProb.realMatrixToCStarMatrix A :=
    realMatrixToCStar_nonneg hA.nonneg
  have hUnit : IsUnit (HighDimProb.realMatrixToCStarMatrix A) := by
    simpa [realMatrixToCStarStarAlgHom] using
      hA.isUnit.map (realMatrixToCStarStarAlgHom (n := n))
  exact hUnit.isStrictlyPositive hNonneg

/-- HighDimProb matrix order transports through the `CStarMatrix` representation. -/
theorem realMatrixToCStar_matrixLE {n : Nat}
    {A B : Matrix (Fin n) (Fin n) Real} (hAB : HighDimProb.MatrixLE A B) :
    HighDimProb.realMatrixToCStarMatrix A <= HighDimProb.realMatrixToCStarMatrix B := by
  have hAB' : A <= B := HighDimProb.mathlib_le_of_matrixLE hAB
  rw [← sub_nonneg] at hAB'
  rw [← sub_nonneg]
  have hC : 0 <= HighDimProb.realMatrixToCStarMatrix (B - A) :=
    realMatrixToCStar_nonneg hAB'
  simpa [HighDimProb.realMatrixToCStarMatrix_sub] using hC

set_option maxHeartbeats 2000000 in
/-- Strict-positive real functional-calculus logarithm commutes with the
`CStarMatrix` representation. -/
theorem realMatrixToCStar_log {n : Nat} {A : Matrix (Fin n) (Fin n) Real}
    (hA : IsSelfAdjoint A) (hApos : IsStrictlyPositive A) :
    HighDimProb.realMatrixToCStarMatrix (CFC.log A) =
      CFC.log (HighDimProb.realMatrixToCStarMatrix A) := by
  have hspec : ∀ x ∈ spectrum Real A, 0 < x :=
    (StarOrderedRing.isStrictlyPositive_iff_spectrum_pos (R := Real) A hA).mp hApos
  have hCont : ContinuousOn Real.log (spectrum Real A) :=
    Real.continuousOn_log.mono (by intro x hx; exact ne_of_gt (hspec x hx))
  have hMapEntries : Continuous (fun A : Matrix (Fin n) (Fin n) Real =>
      A.map (algebraMap Real Complex)) := by
    fun_prop
  have hMapCont : Continuous (realMatrixToCStarStarAlgHom (n := n)) := by
    change Continuous (fun A : Matrix (Fin n) (Fin n) Real =>
      CStarMatrix.ofMatrix (A.map (algebraMap Real Complex)))
    simpa [CStarMatrix.ofMatrix_eq_ofMatrixL] using
      (CStarMatrix.ofMatrixL : Matrix (Fin n) (Fin n) Complex ≃L[Complex]
        CStarMatrix (Fin n) (Fin n) Complex).continuous.comp hMapEntries
  simpa [CFC.log] using
    (StarAlgHom.map_cfc
      (φ := (realMatrixToCStarStarAlgHom (n := n)))
      (f := Real.log) (a := A)
      (hf := hCont)
      (hφ := hMapCont)
      (ha := hA)
      (hφa := HighDimProb.isSelfAdjoint_realMatrixToCStarMatrix hA))

/-- The CFC logarithm of a real self-adjoint matrix is self-adjoint in
HighDimProb's matrix vocabulary. -/
theorem isSelfAdjointMatrix_cfc_log {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real}
    (_hA : HighDimProb.IsSelfAdjointMatrix A) :
    HighDimProb.IsSelfAdjointMatrix (CFC.log A) := by
  exact (IsSelfAdjoint.log (a := A)).isHermitian

private theorem cstarMatrix_mem_positiveCone_reflect {n : Nat}
    {A : CStarMatrix (Fin n) (Fin n) Complex}
    (hA : A ∈ AddSubmonoid.closure
      (Set.range fun B : CStarMatrix (Fin n) (Fin n) Complex => star B * B)) :
    (CStarMatrix.ofMatrix.symm A : Matrix (Fin n) (Fin n) Complex) ∈
      AddSubmonoid.closure
        (Set.range fun B : Matrix (Fin n) (Fin n) Complex => star B * B) := by
  induction hA using AddSubmonoid.closure_induction with
  | zero =>
      change (0 : Matrix (Fin n) (Fin n) Complex) ∈
        AddSubmonoid.closure
          (Set.range fun B : Matrix (Fin n) (Fin n) Complex => star B * B)
      exact AddSubmonoid.zero_mem _
  | add X Y _ _ ihX ihY =>
      simpa using AddSubmonoid.add_mem _ ihX ihY
  | mem X hX =>
      rcases hX with ⟨B, rfl⟩
      refine AddSubmonoid.subset_closure ?_
      refine ⟨(CStarMatrix.ofMatrix.symm B : Matrix (Fin n) (Fin n) Complex), ?_⟩
      ext i j
      simp [CStarMatrix.mul_apply, CStarMatrix.star_apply, Matrix.mul_apply]

/-- Reflect `CStarMatrix` spectral nonnegativity back to ordinary complex
matrix positive semidefiniteness. -/
theorem cstarMatrixOfMatrix_posSemidef_of_nonneg {n : Nat}
    (A : Matrix (Fin n) (Fin n) Complex)
    (hA : 0 <= (CStarMatrix.ofMatrix A : CStarMatrix (Fin n) (Fin n) Complex)) :
    A.PosSemidef := by
  rw [StarOrderedRing.nonneg_iff] at hA
  have hCone := cstarMatrix_mem_positiveCone_reflect hA
  have hNonneg : 0 <= A := by
    rw [StarOrderedRing.nonneg_iff]
    simpa using hCone
  exact Matrix.nonneg_iff_posSemidef.mp hNonneg

/-- Reflect positive semidefiniteness of a complexification back to the real
matrix. -/
theorem posSemidef_of_complexification_posSemidef {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real}
    (hA : (A.map (algebraMap Real Complex)).PosSemidef) :
    A.PosSemidef := by
  have hHerm : A.IsHermitian := by
    exact Matrix.isHermitian_map_iff (A := A)
      (f := algebraMap Real Complex) (by intro x; simp) Complex.ofReal_injective |>.mp hA.isHermitian
  refine Matrix.PosSemidef.of_dotProduct_mulVec_nonneg hHerm ?_
  intro x
  have hqC := hA.dotProduct_mulVec_nonneg (fun i => (x i : Complex))
  have hcast :
      ((dotProduct (star x) (A.mulVec x) : Real) : Complex) =
        dotProduct (star fun i => (x i : Complex))
          ((A.map (algebraMap Real Complex)).mulVec fun i => (x i : Complex)) := by
    simp [dotProduct, Matrix.mulVec, Finset.mul_sum]
  have hqC' : 0 <= ((dotProduct (star x) (A.mulVec x) : Real) : Complex) := by
    rw [hcast]
    exact hqC
  exact (RCLike.ofReal_nonneg (K := Complex)).mp hqC'

/-- Reflect order of represented real matrices back to HighDimProb's explicit
`MatrixLE` vocabulary. -/
theorem matrixLE_of_realMatrixToCStar_matrixLE {n : Nat}
    {A B : Matrix (Fin n) (Fin n) Real}
    (hAB : HighDimProb.realMatrixToCStarMatrix A <=
      HighDimProb.realMatrixToCStarMatrix B) :
    HighDimProb.MatrixLE A B := by
  rw [← sub_nonneg] at hAB
  have hCSub : 0 <= HighDimProb.realMatrixToCStarMatrix (B - A) := by
    simpa [HighDimProb.realMatrixToCStarMatrix_sub] using hAB
  have hComplexPSD : ((B - A).map (algebraMap Real Complex)).PosSemidef := by
    exact cstarMatrixOfMatrix_posSemidef_of_nonneg
      ((B - A).map (algebraMap Real Complex))
      (by simpa [HighDimProb.realMatrixToCStarMatrix] using hCSub)
  have hRealPSD : (B - A).PosSemidef :=
    posSemidef_of_complexification_posSemidef hComplexPSD
  exact HighDimProb.matrixLE_of_mathlib_le (Matrix.le_iff.mpr hRealPSD)

end

end HighDimProb
