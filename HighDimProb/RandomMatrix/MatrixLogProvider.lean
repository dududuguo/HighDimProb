import HighDimProb.RandomMatrix.CStarOrderTransport
import HighDimProb.RandomMatrix.HardboneStatements
import HighDimProb.RandomMatrix.Spectral
import Mathlib.Analysis.CStarAlgebra.CStarMatrix
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Instances
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Unique
import Mathlib.Analysis.Matrix.HermitianFunctionalCalculus
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.ExpLog.Basic
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.ExpLog.Order

/-!
# Real-matrix logarithm monotonicity provider

This module proves HighDimProb's real-matrix operator-log monotonicity
statement by transporting real matrices through `CStarMatrix`, applying
Mathlib's C-star functional-calculus theorem `CFC.log_le_log`, and reflecting
matrix order back to HighDimProb's `MatrixLE` vocabulary.

It deliberately does not prove Lieb concavity, Golden-Thompson, Tropp's
trace-MGF theorem, or Matrix Bernstein. The only hard theorem consumed here is
Mathlib's C-star logarithm monotonicity theorem.
-/

namespace HighDimProb

noncomputable section

open scoped ComplexOrder MatrixOrder Matrix.Norms.Operator

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

set_option maxHeartbeats 2000000 in
/-- Provider proof of HighDimProb's real-matrix operator-log monotonicity
statement. -/
theorem operatorLogMonotoneOnPositiveMatrices {n : Nat}
    (M N : Matrix (Fin n) (Fin n) Real) :
    HighDimProb.operatorLogMonotoneOnPositiveMatrices_statement M N := by
  intro hM hMpos hN hNpos hMN
  have hCOrder :
      HighDimProb.realMatrixToCStarMatrix M <= HighDimProb.realMatrixToCStarMatrix N :=
    realMatrixToCStar_matrixLE hMN
  have hCPos : IsStrictlyPositive (HighDimProb.realMatrixToCStarMatrix M) :=
    realMatrixToCStar_strictlyPositive hMpos
  have hCLog :
      CFC.log (HighDimProb.realMatrixToCStarMatrix M) <=
        CFC.log (HighDimProb.realMatrixToCStarMatrix N) :=
    CFC.log_le_log hCOrder hCPos
  have hBackM :
      HighDimProb.realMatrixToCStarMatrix (CFC.log M) =
        CFC.log (HighDimProb.realMatrixToCStarMatrix M) :=
    realMatrixToCStar_log hM hMpos
  have hBackN :
      HighDimProb.realMatrixToCStarMatrix (CFC.log N) =
        CFC.log (HighDimProb.realMatrixToCStarMatrix N) :=
    realMatrixToCStar_log hN hNpos
  have hImageOrder :
      HighDimProb.realMatrixToCStarMatrix (CFC.log M) <=
        HighDimProb.realMatrixToCStarMatrix (CFC.log N) := by
    simpa [hBackM, hBackN] using hCLog
  exact matrixLE_of_realMatrixToCStar_matrixLE hImageOrder

end

end HighDimProb