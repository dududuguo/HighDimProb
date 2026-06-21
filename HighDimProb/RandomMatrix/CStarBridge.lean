import HighDimProb.RandomMatrix.MatrixOrder
import Mathlib.Analysis.CStarAlgebra.CStarMatrix
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.ExpLog.Order

/-!
# Real matrix to CStarMatrix bridge

This module contains the thin representation bridge needed to reuse Mathlib's
CStar functional-calculus order API from the real-matrix RandomMatrix layer.
It deliberately does not prove Lieb, Golden-Thompson, Bernstein CFC, or Matrix
Bernstein.  The positive/order/log transport targets at the end are explicit
statement surfaces for future proof leaves.
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

/-! ## Proved transport from explicit complexified premises -/

/-- Nonnegativity of the complexified matrix survives the `CStarMatrix` representation.

This is deliberately stated with the complexified matrix premise.  The separate
real-to-complex positivity bridge is not claimed here. -/
theorem realMatrixToCStarMatrix_nonneg_of_complexified_nonneg {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real)
    (hA : 0 <= A.map (algebraMap Real Complex)) :
    0 <= realMatrixToCStarMatrix A := by
  exact map_rel (CStarMatrix.ofMatrixStarAlgEquiv :
    Matrix (Fin n) (Fin n) Complex ≃⋆ₐ[Complex]
      CStarMatrix (Fin n) (Fin n) Complex) hA

/-- Loewner order of complexified matrices survives the `CStarMatrix` representation.

This is the proved CStar-side order transport contract.  It does not by itself
prove that a HighDimProb `MatrixLE A B` supplies the complexified order premise. -/
theorem realMatrixToCStarMatrixLE_of_complexified_le {n : Nat}
    (A B : Matrix (Fin n) (Fin n) Real)
    (hAB : A.map (algebraMap Real Complex) <= B.map (algebraMap Real Complex)) :
    realMatrixToCStarMatrix A <= realMatrixToCStarMatrix B := by
  exact map_rel (CStarMatrix.ofMatrixStarAlgEquiv :
    Matrix (Fin n) (Fin n) Complex ≃⋆ₐ[Complex]
      CStarMatrix (Fin n) (Fin n) Complex) hAB

/-- Strict positivity of the complexified matrix survives the `CStarMatrix` representation. -/
theorem realMatrixToCStarStrictlyPositive_of_complexified {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real)
    (hA : IsStrictlyPositive (A.map (algebraMap Real Complex))) :
    IsStrictlyPositive (realMatrixToCStarMatrix A) := by
  refine ⟨?_, ?_⟩
  · exact realMatrixToCStarMatrix_nonneg_of_complexified_nonneg A hA.nonneg
  · exact IsUnit.map (CStarMatrix.ofMatrixStarAlgEquiv :
      Matrix (Fin n) (Fin n) Complex ≃⋆ₐ[Complex]
        CStarMatrix (Fin n) (Fin n) Complex) hA.isUnit

/-! ## Statement targets for the remaining transport layer -/

/-- Target: strict positivity survives the real-to-CStar representation. -/
abbrev realMatrixToCStarStrictlyPositive_statement {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) : Prop :=
  IsStrictlyPositive A -> IsStrictlyPositive (realMatrixToCStarMatrix A)

/-- Target: HighDimProb `MatrixLE` survives the real-to-CStar representation. -/
abbrev realMatrixToCStarMatrixLE_statement {n : Nat}
    (A B : Matrix (Fin n) (Fin n) Real) : Prop :=
  MatrixLE A B -> realMatrixToCStarMatrix A <= realMatrixToCStarMatrix B

/-- Target: CStar logarithm commutes with the real-to-CStar representation. -/
abbrev realMatrixToCStarLogBack_statement {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) : Prop :=
  CFC.log (realMatrixToCStarMatrix A) =
    realMatrixToCStarMatrix (CFC.log A)

/-- Close the log-back statement when the log transport equality is supplied explicitly.

This wrapper is intentionally an assumption consumer, not a proof of CFC-log
compatibility for real-to-CStar transport. -/
theorem realMatrixToCStarLogBack_of_transport {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real)
    (hlog : CFC.log (realMatrixToCStarMatrix A) =
      realMatrixToCStarMatrix (CFC.log A)) :
    realMatrixToCStarLogBack_statement A :=
  hlog

end

end HighDimProb
