import HighDimProb.RandomMatrix.MatrixOrder
import Mathlib.Analysis.Matrix.Order
import Mathlib.LinearAlgebra.Matrix.SchurComplement
import Mathlib.LinearAlgebra.Matrix.Vec

/-!
# Left/right relative-entropy integrand provider

This focused provider module ports only the finite-dimensional inverse-
perspective and left/right integrand leaf used by the Lindblad/Effros relative-
entropy route. It proves the concrete fixed-`t` joint-convexity theorem
`RelativeEntropy.leftRightRelativeEntropyIntegrand_jointConvex` and the minimal
supporting inverse-perspective wrappers behind it.

It does not prove density integrability, the left/right integral representation,
relative-entropy joint convexity, Epstein, Lieb, or Tropp.
-/

namespace HighDimProb

noncomputable section

open scoped MatrixOrder

/-- The Schur-complement block matrix witnessing the inverse perspective is PSD. -/
theorem inversePerspectiveBlock_posSemidef
    {m k : Type*} [Fintype m] [DecidableEq m] [Fintype k] [DecidableEq k]
    (B : Matrix m k Real) {D : Matrix k k Real} (hD : D.PosDef) :
    (Matrix.fromBlocks (B * D⁻¹ * B.conjTranspose) B B.conjTranspose D).PosSemidef := by
  cases hD.isUnit.nonempty_invertible
  rw [Matrix.PosDef.fromBlocks₂₂ (A := B * D⁻¹ * B.conjTranspose) B hD]
  simpa using Matrix.PosSemidef.zero

private theorem convexCombo_posDef_of_posDef_fintype
    {n : Type*} [Fintype n] [DecidableEq n]
    (A B : Matrix n n Real) (hA : A.PosDef) (hB : B.PosDef)
    {theta : Real} (h0 : 0 <= theta) (h1 : theta <= 1) :
    (((1 - theta) • A) + theta • B).PosDef := by
  by_cases htheta0 : theta = 0
  · subst htheta0
    simpa using hA
  · by_cases htheta1 : theta = 1
    · subst htheta1
      simpa using hB
    · have hLeft : 0 < 1 - theta := sub_pos.mpr (lt_of_not_ge fun h =>
        htheta1 (le_antisymm h1 h))
      have hRight : 0 < theta := lt_of_le_of_ne h0 (Ne.symm htheta0)
      simpa [sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using
        (hA.smul hLeft).add (hB.smul hRight)

/--
Joint convexity of the matrix inverse perspective `(B, D) |-> B D^-1 B*`.

This is the Schur-complement form of the standard perspective theorem for the
operator-convex inverse, specialized to concrete finite-dimensional real
matrices.
-/
theorem inversePerspective_jointConvex
    {m k : Type*} [Fintype m] [DecidableEq m] [Fintype k] [DecidableEq k]
    {B1 B2 : Matrix m k Real} {D1 D2 : Matrix k k Real}
    (hD1 : D1.PosDef) (hD2 : D2.PosDef)
    {a b : Real} (ha : 0 <= a) (hb : 0 <= b) (hab : a + b = 1) :
    let B := a • B1 + b • B2
    let D := a • D1 + b • D2
    B * D⁻¹ * B.conjTranspose <=
      a • (B1 * D1⁻¹ * B1.conjTranspose) + b • (B2 * D2⁻¹ * B2.conjTranspose) := by
  intro B D
  let A1 := B1 * D1⁻¹ * B1.conjTranspose
  let A2 := B2 * D2⁻¹ * B2.conjTranspose
  let A := a • A1 + b • A2
  have hb_le_one : b <= 1 := by
    linarith
  have ha_eq : a = 1 - b := by
    linarith
  have hD : D.PosDef := by
    simpa [D, ha_eq] using
      convexCombo_posDef_of_posDef_fintype D1 D2 hD1 hD2 hb hb_le_one
  have hblock1 : (Matrix.fromBlocks A1 B1 B1.conjTranspose D1).PosSemidef :=
    inversePerspectiveBlock_posSemidef B1 hD1
  have hblock2 : (Matrix.fromBlocks A2 B2 B2.conjTranspose D2).PosSemidef :=
    inversePerspectiveBlock_posSemidef B2 hD2
  have hblock_combo :
      (a • Matrix.fromBlocks A1 B1 B1.conjTranspose D1 +
        b • Matrix.fromBlocks A2 B2 B2.conjTranspose D2).PosSemidef :=
    (hblock1.smul ha).add (hblock2.smul hb)
  have hblock : (Matrix.fromBlocks A B B.conjTranspose D).PosSemidef := by
    convert hblock_combo using 1
    simp [A, B, D, Matrix.fromBlocks_add, Matrix.fromBlocks_smul]
  cases hD.isUnit.nonempty_invertible
  have hschur : (A - B * D⁻¹ * B.conjTranspose).PosSemidef :=
    (Matrix.PosDef.fromBlocks₂₂ (A := A) B hD).mp hblock
  rw [Matrix.le_iff]
  simpa [A, A1, A2] using hschur

private def traceRightMulLinearMap
    {n : Type*} [Fintype n] [DecidableEq n] (Y : Matrix n n Real) :
    Matrix n n Real →ₗ[Real] Real where
  toFun X := Matrix.trace (X * Y)
  map_add' X Z := by
    simp [Matrix.add_mul, Matrix.trace_add]
  map_smul' c X := by
    simp [Matrix.trace_smul]

private theorem traceRightMulLinearMap_apply
    {n : Type*} [Fintype n] [DecidableEq n] (Y X : Matrix n n Real) :
    traceRightMulLinearMap Y X = Matrix.trace (X * Y) := rfl

private theorem trace_mul_nonneg_of_posSemidef
    {n : Type*} [Fintype n] [DecidableEq n] {K C : Matrix n n Real}
    (hK : K.PosSemidef) (hC : C.PosSemidef) :
    0 <= Matrix.trace (K * C) := by
  obtain ⟨D, rfl⟩ := CStarAlgebra.nonneg_iff_eq_star_mul_self.mp hC.nonneg
  have hProdPSD := hK.mul_mul_conjTranspose_same D
  calc
    0 <= Matrix.trace (D * K * star D) := by
      simpa [Matrix.mul_assoc] using hProdPSD.trace_nonneg
    _ = Matrix.trace (star D * D * K) := by
      simpa [Matrix.mul_assoc] using Matrix.trace_mul_cycle D K (star D)
    _ = Matrix.trace (K * star D * D) := by
      simpa [Matrix.mul_assoc] using Matrix.trace_mul_cycle (star D) D K
    _ = Matrix.trace (K * (star D * D)) := by
      simp [Matrix.mul_assoc]

private theorem traceRightMulLinearMap_mono_of_posSemidef
    {n : Type*} [Fintype n] [DecidableEq n] {X Y Z : Matrix n n Real}
    (hX : X.PosSemidef) (hYZ : Y <= Z) :
    traceRightMulLinearMap Y X <= traceRightMulLinearMap Z X := by
  rw [traceRightMulLinearMap_apply, traceRightMulLinearMap_apply]
  have hdiff : (Z - Y).PosSemidef := Matrix.le_iff.mp hYZ
  have hnonneg : 0 <= Matrix.trace (X * (Z - Y)) :=
    trace_mul_nonneg_of_posSemidef hX hdiff
  have htrace_sub :
      Matrix.trace (X * (Z - Y)) = Matrix.trace (X * Z) - Matrix.trace (X * Y) := by
    simp [Matrix.mul_sub, Matrix.trace_sub]
  linarith

/-- Trace-paired scalar form of joint convexity of the matrix inverse perspective. -/
theorem trace_inversePerspective_jointConvex
    {m k : Type*} [Fintype m] [DecidableEq m] [Fintype k] [DecidableEq k]
    {X : Matrix m m Real} (hX : X.PosSemidef)
    {B1 B2 : Matrix m k Real} {D1 D2 : Matrix k k Real}
    (hD1 : D1.PosDef) (hD2 : D2.PosDef)
    {a b : Real} (ha : 0 <= a) (hb : 0 <= b) (hab : a + b = 1) :
    let B := a • B1 + b • B2
    let D := a • D1 + b • D2
    Matrix.trace (X * (B * D⁻¹ * B.conjTranspose)) <=
      a * Matrix.trace (X * (B1 * D1⁻¹ * B1.conjTranspose)) +
        b * Matrix.trace (X * (B2 * D2⁻¹ * B2.conjTranspose)) := by
  intro B D
  have hpersp :=
    inversePerspective_jointConvex (m := m) (k := k)
      (B1 := B1) (B2 := B2) (D1 := D1) (D2 := D2) hD1 hD2 ha hb hab
  change B * D⁻¹ * B.conjTranspose <=
      a • (B1 * D1⁻¹ * B1.conjTranspose) + b • (B2 * D2⁻¹ * B2.conjTranspose)
    at hpersp
  have htrace :=
    traceRightMulLinearMap_mono_of_posSemidef (X := X) hX hpersp
  simpa [traceRightMulLinearMap_apply, Matrix.mul_add, Matrix.mul_smul,
    Matrix.trace_add, Matrix.trace_smul] using htrace

open scoped Kronecker MatrixOrder

namespace RelativeEntropy

/--
Trace-paired inverse-perspective integrand.

In the left/right denominator route, this is the scalar integrand after the
denominator has been represented as a positive-definite matrix `D` and the
numerator as `B`.
-/
def tracePairedInversePerspectiveIntegrand
    {m k : Type*} [Fintype m] [DecidableEq m] [Fintype k] [DecidableEq k]
    (X : Matrix m m Real) (B : Matrix m k Real) (D : Matrix k k Real) : Real :=
  Matrix.trace (X * (B * D⁻¹ * B.conjTranspose))

/--
Joint convexity of the trace-paired inverse-perspective integrand.

This is the SLT-facing scalar wrapper around
`trace_inversePerspective_jointConvex`; the remaining relative-entropy work is
to identify the left/right denominator integral with `traceMatrixRelativeEntropyPlain`.
-/
theorem tracePairedInversePerspectiveIntegrand_jointConvex
    {m k : Type*} [Fintype m] [DecidableEq m] [Fintype k] [DecidableEq k]
    {X : Matrix m m Real} (hX : X.PosSemidef)
    {B1 B2 : Matrix m k Real} {D1 D2 : Matrix k k Real}
    (hD1 : D1.PosDef) (hD2 : D2.PosDef)
    {a b : Real} (ha : 0 <= a) (hb : 0 <= b) (hab : a + b = 1) :
    let B := a • B1 + b • B2
    let D := a • D1 + b • D2
    tracePairedInversePerspectiveIntegrand X B D <=
      a * tracePairedInversePerspectiveIntegrand X B1 D1 +
        b * tracePairedInversePerspectiveIntegrand X B2 D2 := by
  intro B D
  simpa [tracePairedInversePerspectiveIntegrand] using
    (trace_inversePerspective_jointConvex (m := m) (k := k) (X := X)
      hX (B1 := B1) (B2 := B2) (D1 := D1) (D2 := D2) hD1 hD2 ha hb hab)

/--
The Kronecker matrix for the left/right multiplication operator
`X |-> A * X + t • (X * B)` under `Matrix.vec`.
-/
def leftRightDenominatorMatrix
    {n : Type*} [Fintype n] [DecidableEq n]
    (A B : Matrix n n Real) (t : Real) : Matrix (n × n) (n × n) Real :=
  (1 : Matrix n n Real) ⊗ₖ A + t • (B.transpose ⊗ₖ (1 : Matrix n n Real))

/-- The left/right denominator is positive definite for positive-definite inputs. -/
theorem leftRightDenominatorMatrix_posDef
    {n : Type*} [Fintype n] [DecidableEq n]
    {A B : Matrix n n Real} (hA : A.PosDef) (hB : B.PosDef)
    {t : Real} (ht : 0 <= t) :
    (leftRightDenominatorMatrix A B t).PosDef := by
  have hleft : ((1 : Matrix n n Real) ⊗ₖ A).PosDef :=
    Matrix.PosDef.one.kronecker hA
  have hright : (B.transpose ⊗ₖ (1 : Matrix n n Real)).PosSemidef :=
    hB.transpose.posSemidef.kronecker Matrix.PosDef.one.posSemidef
  exact hleft.add_posSemidef (hright.smul ht)

/-- The left/right denominator is affine in the pair of matrices. -/
theorem leftRightDenominatorMatrix_affine
    {n : Type*} [Fintype n] [DecidableEq n]
    (A1 A2 B1 B2 : Matrix n n Real) (t a b : Real) :
    leftRightDenominatorMatrix (a • A1 + b • A2) (a • B1 + b • B2) t =
      a • leftRightDenominatorMatrix A1 B1 t +
        b • leftRightDenominatorMatrix A2 B2 t := by
  ext ij kl
  simp [leftRightDenominatorMatrix, Matrix.kroneckerMap_apply]
  ring

private def rowMatrixOfVec {ι : Type*} (v : ι -> Real) : Matrix Unit ι Real :=
  fun _ j => v j

/--
The operator-level integrand in the noncommutative relative-entropy
representation, written as an inverse perspective after vectorizing the
left/right multiplication operator.
-/
def leftRightRelativeEntropyIntegrand
    {n : Type*} [Fintype n] [DecidableEq n]
    (t : Real) (A B : Matrix n n Real) : Real :=
  tracePairedInversePerspectiveIntegrand
    (1 : Matrix Unit Unit Real)
    (rowMatrixOfVec (Matrix.vec (A - B)))
    (leftRightDenominatorMatrix A B t)

/--
The concrete left/right integrand is jointly convex. This is the first
SLT-style denominator layer feeding the later integral representation.
-/
theorem leftRightRelativeEntropyIntegrand_jointConvex
    {n : Type*} [Fintype n] [DecidableEq n]
    {A1 A2 B1 B2 : Matrix n n Real}
    (hA1 : A1.PosDef) (hA2 : A2.PosDef)
    (hB1 : B1.PosDef) (hB2 : B2.PosDef)
    {t : Real} (ht : 0 <= t)
    {a b : Real} (ha : 0 <= a) (hb : 0 <= b) (hab : a + b = 1) :
    leftRightRelativeEntropyIntegrand t
        (a • A1 + b • A2) (a • B1 + b • B2) <=
      a * leftRightRelativeEntropyIntegrand t A1 B1 +
        b * leftRightRelativeEntropyIntegrand t A2 B2 := by
  let N1 : Matrix Unit (n × n) Real := rowMatrixOfVec (Matrix.vec (A1 - B1))
  let N2 : Matrix Unit (n × n) Real := rowMatrixOfVec (Matrix.vec (A2 - B2))
  let D1 : Matrix (n × n) (n × n) Real := leftRightDenominatorMatrix A1 B1 t
  let D2 : Matrix (n × n) (n × n) Real := leftRightDenominatorMatrix A2 B2 t
  have hD1 : D1.PosDef := by
    simpa [D1] using leftRightDenominatorMatrix_posDef hA1 hB1 ht
  have hD2 : D2.PosDef := by
    simpa [D2] using leftRightDenominatorMatrix_posDef hA2 hB2 ht
  have hpersp :=
    tracePairedInversePerspectiveIntegrand_jointConvex
      (m := Unit) (k := n × n)
      (X := (1 : Matrix Unit Unit Real)) Matrix.PosDef.one.posSemidef
      (B1 := N1) (B2 := N2) (D1 := D1) (D2 := D2)
      hD1 hD2 ha hb hab
  have hnum :
      a • N1 + b • N2 =
        rowMatrixOfVec
          (Matrix.vec ((a • A1 + b • A2) - (a • B1 + b • B2))) := by
    ext u ij
    cases u
    change
      a * ((A1 - B1) ij.2 ij.1) + b * ((A2 - B2) ij.2 ij.1) =
        ((a • A1 + b • A2) - (a • B1 + b • B2)) ij.2 ij.1
    simp [Matrix.sub_apply, Matrix.add_apply, Matrix.smul_apply]
    ring
  have hden :
      a • D1 + b • D2 =
        leftRightDenominatorMatrix
          (a • A1 + b • A2) (a • B1 + b • B2) t := by
    simpa [D1, D2] using
      (leftRightDenominatorMatrix_affine A1 A2 B1 B2 t a b).symm
  rw [hnum, hden] at hpersp
  simpa [leftRightRelativeEntropyIntegrand, N1, N2, D1, D2] using hpersp

end RelativeEntropy

end

end HighDimProb
