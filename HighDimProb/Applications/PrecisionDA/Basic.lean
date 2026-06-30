import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Symmetric
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Tactic.NoncommRing
import Mathlib.Tactic.Ring

/-!
# Precision-matrix data augmentation object layer

This experimental namespace records the deterministic matrix objects used by
Morisset-Hardy-Durmus, "Non-Asymptotic Analysis Of Data Augmentation For
Precision Matrix Estimation".

The first layer deliberately contains only paper-facing deterministic
vocabulary: data matrices, square matrices, the uncentered sample covariance in
paper orientation `X Xᵀ / n`, and the shrinkage resolvent.  It does not prove
Theorem 1, Theorem 2, deterministic equivalents, or concentration estimates.
-/

namespace HighDimProb
namespace PrecisionDA

open scoped BigOperators

noncomputable section

/-- Paper-oriented data matrix with `d` coordinates and `n` samples. -/
abbrev DataMatrix (d n : Nat) := Matrix (Fin d) (Fin n) Real

/-- Square real matrix in ambient dimension `d`. -/
abbrev SquareMatrix (d : Nat) := Matrix (Fin d) (Fin d) Real

/--
Uncentered sample covariance in the paper's column-sample orientation.

For `X : ℝ^{d × n}`, this is `(1 / n) • (X * Xᵀ)`.  This is a deterministic
paper-facing wrapper; the existing `HighDimProb.sampleCovariance` uses the
row-sample random-matrix convention `(1 / m) Aᵀ A`.
-/
def sampleCovariance {d n : Nat} (X : DataMatrix d n) : SquareMatrix d :=
  (1 / (n : Real)) • (X * X.transpose)

/-- Outer product of the `k`-th sample column `x_k x_kᵀ`. -/
def sampleOuterProduct {d n : Nat} (X : DataMatrix d n) (k : Fin n) : SquareMatrix d :=
  fun i j => X i k * X j k

/-- Contraction of a matrix row against the selected sample column. -/
def sampleLeftAction {d n : Nat} (A : SquareMatrix d) (X : DataMatrix d n)
    (k : Fin n) (i : Fin d) : Real :=
  Finset.univ.sum fun l : Fin d => A i l * X l k

/-- Contraction of the selected sample column against a matrix column. -/
def sampleRightAction {d n : Nat} (X : DataMatrix d n) (k : Fin n)
    (B : SquareMatrix d) (j : Fin d) : Real :=
  Finset.univ.sum fun l : Fin d => X l k * B l j

/-- Scalar quadratic contraction `x_kᵀ A x_k` for the selected sample column. -/
def sampleQuadraticAction {d n : Nat} (X : DataMatrix d n) (k : Fin n)
    (A : SquareMatrix d) : Real :=
  Finset.univ.sum fun i : Fin d => X i k * sampleLeftAction A X k i

/-- The selected sample column as a `d × 1` matrix. -/
def sampleColumn {d n : Nat} (X : DataMatrix d n) (k : Fin n) :
    Matrix (Fin d) Unit Real :=
  fun i _ => X i k

/-- The selected sample row as a `1 × d` matrix. -/
def sampleRow {d n : Nat} (X : DataMatrix d n) (k : Fin n) :
    Matrix Unit (Fin d) Real :=
  fun _ j => X j k

/-- One-dimensional Woodbury weight matrix carrying the sample normalization `1 / n`. -/
def sampleWeightMatrix (n : Nat) : Matrix Unit Unit Real :=
  fun _ _ => 1 / (n : Real)

/--
Leave-one-out sample covariance with the `k`-th sample column removed, keeping
the original `1 / n` normalization used by `sampleCovariance`.
-/
def leaveOneOutSampleCovariance {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) : SquareMatrix d :=
  fun i j =>
    (1 / (n : Real)) *
      (Finset.univ.erase k).sum (fun l : Fin n => X i l * X j l)

/-- Entrywise sum form of the paper-oriented sample covariance. -/
theorem sampleCovariance_apply {d n : Nat} (X : DataMatrix d n) (i j : Fin d) :
    sampleCovariance X i j =
      (1 / (n : Real)) * Finset.univ.sum (fun l : Fin n => X i l * X j l) := by
  simp [sampleCovariance, Matrix.mul_apply]

/-- Entrywise form of the selected sample outer product. -/
theorem sampleOuterProduct_apply {d n : Nat} (X : DataMatrix d n) (k : Fin n)
    (i j : Fin d) :
    sampleOuterProduct X k i j = X i k * X j k := by
  rfl

/--
Multiplication on the left of a sample outer product factors through the
selected sample column.
-/
theorem mul_sampleOuterProduct_apply {d n : Nat} (A : SquareMatrix d)
    (X : DataMatrix d n) (k : Fin n) (i j : Fin d) :
    (A * sampleOuterProduct X k) i j = sampleLeftAction A X k i * X j k := by
  calc
    (A * sampleOuterProduct X k) i j
        = Finset.univ.sum (fun l : Fin d => A i l * (X l k * X j k)) := by
            simp [Matrix.mul_apply, sampleOuterProduct]
    _ = sampleLeftAction A X k i * X j k := by
            simp [sampleLeftAction, Finset.sum_mul, mul_assoc]

/--
Multiplication on the right of a sample outer product factors through the
selected sample column.
-/
theorem sampleOuterProduct_mul_apply {d n : Nat} (X : DataMatrix d n) (k : Fin n)
    (B : SquareMatrix d) (i j : Fin d) :
    (sampleOuterProduct X k * B) i j = X i k * sampleRightAction X k B j := by
  calc
    (sampleOuterProduct X k * B) i j
        = Finset.univ.sum (fun l : Fin d => (X i k * X l k) * B l j) := by
            simp [Matrix.mul_apply, sampleOuterProduct]
    _ = X i k * sampleRightAction X k B j := by
            simp [sampleRightAction, Finset.mul_sum, mul_assoc]

/--
A sample outer-product sandwich is the product of the two sample-column
contractions.
-/
theorem mul_sampleOuterProduct_mul_apply {d n : Nat} (A : SquareMatrix d)
    (X : DataMatrix d n) (k : Fin n) (B : SquareMatrix d) (i j : Fin d) :
    (A * sampleOuterProduct X k * B) i j =
      sampleLeftAction A X k i * sampleRightAction X k B j := by
  calc
    (A * sampleOuterProduct X k * B) i j
        = Finset.univ.sum (fun l : Fin d => (A * sampleOuterProduct X k) i l * B l j) := by
            rw [Matrix.mul_apply]
    _ = Finset.univ.sum (fun l : Fin d => (sampleLeftAction A X k i * X l k) * B l j) := by
            apply Finset.sum_congr rfl
            intro l _
            rw [mul_sampleOuterProduct_apply]
    _ = sampleLeftAction A X k i * sampleRightAction X k B j := by
            simp [sampleRightAction, Finset.mul_sum, mul_assoc]

/--
Scaled sample outer-product sandwiches expose the scalar separately.  This is
the form needed for later `n⁻¹ x_k x_kᵀ` perturbation RHS terms.
-/
theorem mul_smul_sampleOuterProduct_mul_apply {d n : Nat} (A : SquareMatrix d)
    (X : DataMatrix d n) (k : Fin n) (B : SquareMatrix d) (c : Real) (i j : Fin d) :
    (A * (c • sampleOuterProduct X k) * B) i j =
      c * sampleLeftAction A X k i * sampleRightAction X k B j := by
  calc
    (A * (c • sampleOuterProduct X k) * B) i j
        = Finset.univ.sum
            (fun l : Fin d => (A * (c • sampleOuterProduct X k)) i l * B l j) := by
            rw [Matrix.mul_apply]
    _ = Finset.univ.sum
            (fun l : Fin d => (c * sampleLeftAction A X k i * X l k) * B l j) := by
            apply Finset.sum_congr rfl
            intro l _
            have hleft :
                (A * (c • sampleOuterProduct X k)) i l =
                  c * sampleLeftAction A X k i * X l k := by
              calc
                (A * (c • sampleOuterProduct X k)) i l
                    = Finset.univ.sum
                        (fun a : Fin d => A i a * (c * (X a k * X l k))) := by
                        simp [Matrix.mul_apply, sampleOuterProduct]
                _ = c * sampleLeftAction A X k i * X l k := by
                        simp [sampleLeftAction, Finset.mul_sum, mul_left_comm, mul_comm]
            rw [hleft]
    _ = c * (sampleLeftAction A X k i * sampleRightAction X k B j) := by
            simp [sampleRightAction, Finset.mul_sum, mul_assoc, mul_left_comm, mul_comm]
    _ = c * sampleLeftAction A X k i * sampleRightAction X k B j := by ring

/--
The matrix-shaped `d × 1`, `1 × 1`, `1 × d` Woodbury perturbation is the same
rank-one sample update as `n⁻¹ x_k x_kᵀ`.
-/
theorem sampleColumn_mul_weight_mul_sampleRow {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) :
    sampleColumn X k * sampleWeightMatrix n * sampleRow X k =
      (1 / (n : Real)) • sampleOuterProduct X k := by
  ext i j
  simp [sampleColumn, sampleWeightMatrix, sampleRow, sampleOuterProduct, Matrix.mul_apply]
  ring

/-- Entrywise sum form of the leave-one-out sample covariance. -/
theorem leaveOneOutSampleCovariance_apply {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (i j : Fin d) :
    leaveOneOutSampleCovariance X k i j =
      (1 / (n : Real)) *
        (Finset.univ.erase k).sum (fun l : Fin n => X i l * X j l) := by
  rfl

/--
Deterministic leave-one-out update:
`C_X = C_X^{(-k)} + n⁻¹ x_k x_kᵀ`.

This is purely finite-dimensional algebra for the paper-oriented column-sample
covariance and keeps the original `1 / n` normalization on the leave-one-out
matrix.
-/
theorem sampleCovariance_eq_leaveOneOut_add_sampleOuter {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) :
    sampleCovariance X =
      leaveOneOutSampleCovariance X k + (1 / (n : Real)) • sampleOuterProduct X k := by
  ext i j
  rw [sampleCovariance_apply]
  simp [leaveOneOutSampleCovariance, sampleOuterProduct]
  ring

/--
The leave-one-out covariance differs from the full covariance by the negative
scaled removed rank-one sample term.
-/
theorem leaveOneOutSampleCovariance_sub_sampleCovariance_eq_neg_sampleOuter {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) :
    leaveOneOutSampleCovariance X k - sampleCovariance X =
      (-(1 / (n : Real))) • sampleOuterProduct X k := by
  rw [sampleCovariance_eq_leaveOneOut_add_sampleOuter X k]
  ext i j
  simp

/-- The paper-oriented deterministic sample covariance is symmetric. -/
theorem sampleCovariance_isSymm {d n : Nat} (X : DataMatrix d n) :
    (sampleCovariance X).IsSymm := by
  unfold sampleCovariance
  apply Matrix.IsSymm.smul
  show (X * X.transpose).IsSymm
  rw [Matrix.IsSymm]
  rw [Matrix.transpose_mul, Matrix.transpose_transpose]

/-- Shifted covariance matrix `C + λ I` used before taking the shrinkage resolvent. -/
def shiftedMatrix {d : Nat} (C : SquareMatrix d) (lam : Real) : SquareMatrix d :=
  C + lam • (1 : SquareMatrix d)

/-- Shifted full-sample covariance matrix `C_X + λ I`. -/
def shrinkageShiftedMatrix {d n : Nat} (X : DataMatrix d n) (lam : Real) :
    SquareMatrix d :=
  shiftedMatrix (sampleCovariance X) lam

/-- Shifted leave-one-out covariance matrix `C_X^{(-k)} + λ I`. -/
def leaveOneOutShiftedMatrix {d n : Nat} (X : DataMatrix d n) (k : Fin n)
    (lam : Real) : SquareMatrix d :=
  shiftedMatrix (leaveOneOutSampleCovariance X k) lam

/-- Subtracting equally shifted matrices cancels the common `λI` term. -/
theorem shiftedMatrix_sub_eq_sub {d : Nat} (A B : SquareMatrix d) (lam : Real) :
    shiftedMatrix A lam - shiftedMatrix B lam = A - B := by
  ext i j
  simp [shiftedMatrix]

/--
The full-sample shifted covariance differs from the leave-one-out shifted
covariance by the removed rank-one sample term.
-/
theorem shrinkageShiftedMatrix_sub_leaveOneOutShiftedMatrix {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) :
    shrinkageShiftedMatrix X lam - leaveOneOutShiftedMatrix X k lam =
      (1 / (n : Real)) • sampleOuterProduct X k := by
  unfold shrinkageShiftedMatrix leaveOneOutShiftedMatrix
  rw [shiftedMatrix_sub_eq_sub]
  rw [sampleCovariance_eq_leaveOneOut_add_sampleOuter X k]
  simp

/-- Shrinkage precision resolvent `(C + λ I)⁻¹` for a deterministic covariance matrix. -/
def precisionResolvent {d : Nat} (C : SquareMatrix d) (lam : Real) : SquareMatrix d :=
  (shiftedMatrix C lam)⁻¹

/-- Symmetry provider for deterministic shrinkage precision resolvents. -/
theorem precisionResolvent_isSymm {d : Nat} (C : SquareMatrix d) (lam : Real) :
    C.IsSymm -> (precisionResolvent C lam).IsSymm := by
  intro hC
  unfold precisionResolvent
  apply Matrix.IsSymm.inv
  apply Matrix.IsSymm.add hC
  exact Matrix.IsSymm.smul Matrix.isSymm_one lam

/-- Shrinkage resolvent built from the paper-oriented sample covariance. -/
def shrinkageResolvent {d n : Nat} (X : DataMatrix d n) (lam : Real) : SquareMatrix d :=
  precisionResolvent (sampleCovariance X) lam

/-- Shrinkage resolvent built from the leave-one-out sample covariance. -/
def leaveOneOutShrinkageResolvent {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) : SquareMatrix d :=
  precisionResolvent (leaveOneOutSampleCovariance X k) lam

/-- The shrinkage resolvent from the paper-oriented sample covariance is symmetric. -/
theorem shrinkageResolvent_isSymm {d n : Nat} (X : DataMatrix d n) (lam : Real) :
    (shrinkageResolvent X lam).IsSymm := by
  exact precisionResolvent_isSymm (sampleCovariance X) lam (sampleCovariance_isSymm X)

/-- Symmetry provider for inverse covariance matrices. -/
theorem inverseCovariance_isSymm {d : Nat} (Sigma : SquareMatrix d) :
    Sigma.IsSymm -> (Sigma⁻¹).IsSymm := by
  intro hSigma
  exact hSigma.inv

/--
Squared Frobenius norm for deterministic square matrices, represented as an
entrywise sum of squares.

This is the deterministic analogue of the existing random-matrix
`HighDimProb.frobeniusSq`, specialized to the paper's square precision matrices.
-/
def frobeniusSq {d : Nat} (A : SquareMatrix d) : Real :=
  Finset.univ.sum fun i : Fin d =>
    Finset.univ.sum fun j : Fin d => (A i j) ^ 2

/-- Normalized squared Frobenius norm `d⁻¹ ‖A‖_F^2`. -/
def normalizedFrobeniusSq {d : Nat} (A : SquareMatrix d) : Real :=
  (1 / (d : Real)) * frobeniusSq A

/-- Trace of the self-product `A * A`, the first trace term in the error expansion. -/
def traceSelfProduct {d : Nat} (A : SquareMatrix d) : Real :=
  Matrix.trace (A * A)

/-- Trace of the mixed product `A * B`, used for cross terms in trace expansions. -/
def traceCross {d : Nat} (A B : SquareMatrix d) : Real :=
  Matrix.trace (A * B)

/--
Paper quadratic precision error `d⁻¹ ‖R - Σ⁻¹‖_F^2`, with the inverse covariance
passed in as an already named matrix.
-/
def precisionQuadraticError {d : Nat} (R SigmaInv : SquareMatrix d) : Real :=
  normalizedFrobeniusSq (R - SigmaInv)

/--
Shrinkage precision error `d⁻¹ ‖R_X(λ) - Σ⁻¹‖_F^2` for the paper-oriented
sample covariance/resolvent.
-/
def shrinkageQuadraticError {d n : Nat}
    (X : DataMatrix d n) (SigmaInv : SquareMatrix d) (lam : Real) : Real :=
  precisionQuadraticError (shrinkageResolvent X lam) SigmaInv

/--
Shrinkage precision error when the covariance matrix itself is supplied and the
precision target is `Σ⁻¹`.
-/
def shrinkageQuadraticError_of_covariance {d n : Nat}
    (X : DataMatrix d n) (Sigma : SquareMatrix d) (lam : Real) : Real :=
  shrinkageQuadraticError X Sigma⁻¹ lam

/--
Right-hand side of the deterministic resolvent identity:
`(A + λI)⁻¹ (B - A) (B + λI)⁻¹`.
-/
def precisionResolventIdentityRHS {d : Nat} (A B : SquareMatrix d) (lam : Real) :
    SquareMatrix d :=
  precisionResolvent A lam * (B - A) * precisionResolvent B lam

/--
Typed deterministic statement for the resolvent difference identity.

The determinant hypotheses make both shifted matrices invertible for mathlib's
`nonsing_inv` API.  This is finite-dimensional matrix algebra only; positivity,
randomness, concentration, and deterministic-equivalent estimates are outside
this statement.
-/
def precisionResolventIdentityStatement {d : Nat}
    (A B : SquareMatrix d) (lam : Real) : Prop :=
  IsUnit (shiftedMatrix A lam).det ->
    IsUnit (shiftedMatrix B lam).det ->
      precisionResolvent A lam - precisionResolvent B lam =
        precisionResolventIdentityRHS A B lam

/--
Deterministic resolvent identity for shifted covariance matrices:
`(A + λI)⁻¹ - (B + λI)⁻¹ = (A + λI)⁻¹ (B - A) (B + λI)⁻¹`.

The proof uses only `Matrix.nonsing_inv_mul`, `Matrix.mul_nonsing_inv`, and
noncommutative ring algebra after the two inverse equations are available.
-/
theorem precisionResolventIdentity {d : Nat} (A B : SquareMatrix d) (lam : Real) :
    precisionResolventIdentityStatement A B lam := by
  intro hA hB
  unfold precisionResolventIdentityRHS precisionResolvent
  let AShift : SquareMatrix d := shiftedMatrix A lam
  let BShift : SquareMatrix d := shiftedMatrix B lam
  change AShift⁻¹ - BShift⁻¹ = AShift⁻¹ * (B - A) * BShift⁻¹
  have hAunit : IsUnit AShift.det := by
    simpa [AShift] using hA
  have hBunit : IsUnit BShift.det := by
    simpa [BShift] using hB
  have hAinv : AShift⁻¹ * AShift = 1 := Matrix.nonsing_inv_mul AShift hAunit
  have hBinv : BShift * BShift⁻¹ = 1 := Matrix.mul_nonsing_inv BShift hBunit
  have hdiff : BShift - AShift = B - A := by
    ext i j
    simp [AShift, BShift, shiftedMatrix]
  calc
    AShift⁻¹ - BShift⁻¹ = AShift⁻¹ * 1 - 1 * BShift⁻¹ := by
      simp
    _ = AShift⁻¹ * (BShift * BShift⁻¹) - (AShift⁻¹ * AShift) * BShift⁻¹ := by
      rw [hBinv, hAinv]
    _ = AShift⁻¹ * (BShift - AShift) * BShift⁻¹ := by
      noncomm_ring
    _ = AShift⁻¹ * (B - A) * BShift⁻¹ := by
      rw [hdiff]

/--
Right-hand side of the full-sample versus leave-one-out shrinkage resolvent
identity.
-/
def shrinkageLeaveOneOutResolventIdentityRHS {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) : SquareMatrix d :=
  precisionResolventIdentityRHS (sampleCovariance X) (leaveOneOutSampleCovariance X k) lam

/--
Rank-one form of the full-sample versus leave-one-out shrinkage resolvent RHS:
`R_X(λ) * (-(1 / n) • x_k x_kᵀ) * R_X^{(-k)}(λ)`.
-/
def shrinkageLeaveOneOutRankOneRHS {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) : SquareMatrix d :=
  shrinkageResolvent X lam *
    ((-(1 / (n : Real))) • sampleOuterProduct X k) *
    leaveOneOutShrinkageResolvent X k lam

/--
The generic leave-one-out resolvent RHS is definitionally reducible, after the
covariance update, to the rank-one perturbation RHS.
-/
theorem shrinkageLeaveOneOutResolventIdentityRHS_eq_rankOne {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) :
    shrinkageLeaveOneOutResolventIdentityRHS X k lam =
      shrinkageLeaveOneOutRankOneRHS X k lam := by
  unfold shrinkageLeaveOneOutResolventIdentityRHS shrinkageLeaveOneOutRankOneRHS
    precisionResolventIdentityRHS shrinkageResolvent leaveOneOutShrinkageResolvent
  rw [leaveOneOutSampleCovariance_sub_sampleCovariance_eq_neg_sampleOuter X k]

/--
Entrywise rank-one expansion of the leave-one-out shrinkage resolvent RHS,
ready for later Sherman-Morrison/Woodbury scalar denominator work.
-/
theorem shrinkageLeaveOneOutRankOneRHS_apply {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) (i j : Fin d) :
    shrinkageLeaveOneOutRankOneRHS X k lam i j =
      (-(1 / (n : Real))) *
        sampleLeftAction (shrinkageResolvent X lam) X k i *
        sampleRightAction X k (leaveOneOutShrinkageResolvent X k lam) j := by
  unfold shrinkageLeaveOneOutRankOneRHS
  exact mul_smul_sampleOuterProduct_mul_apply
    (shrinkageResolvent X lam) X k (leaveOneOutShrinkageResolvent X k lam)
    (-(1 / (n : Real))) i j

/--
One-dimensional Woodbury middle matrix
`C⁻¹ + x_kᵀ R_{-k}(λ) x_k`, with `C = [1 / n]`.

This matrix-shaped form is the direct interface to mathlib's Woodbury theorem.
-/
def shrinkageLeaveOneOutWoodburyMiddle {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) : Matrix Unit Unit Real :=
  (sampleWeightMatrix n)⁻¹ +
    sampleRow X k * leaveOneOutShrinkageResolvent X k lam * sampleColumn X k

/-- Scalar Sherman-Morrison denominator `1 + n⁻¹ x_kᵀ R_{-k}(λ) x_k`. -/
def shrinkageLeaveOneOutWoodburyDenominator {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) : Real :=
  1 + (1 / (n : Real)) *
    sampleQuadraticAction X k (leaveOneOutShrinkageResolvent X k lam)

/-- Rank-one correction term in the scalar Sherman-Morrison RHS. -/
def shrinkageLeaveOneOutWoodburyCorrection {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) : SquareMatrix d :=
  leaveOneOutShrinkageResolvent X k lam *
    (((1 / (n : Real)) / shrinkageLeaveOneOutWoodburyDenominator X k lam) •
      sampleOuterProduct X k) *
    leaveOneOutShrinkageResolvent X k lam

/-- Candidate scalar Sherman-Morrison RHS for the full shrinkage resolvent. -/
def shrinkageLeaveOneOutWoodburyRHS {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) : SquareMatrix d :=
  leaveOneOutShrinkageResolvent X k lam -
    shrinkageLeaveOneOutWoodburyCorrection X k lam

/-- Entrywise expansion of the scalar Woodbury correction term. -/
theorem shrinkageLeaveOneOutWoodburyCorrection_apply {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) (i j : Fin d) :
    shrinkageLeaveOneOutWoodburyCorrection X k lam i j =
      ((1 / (n : Real)) / shrinkageLeaveOneOutWoodburyDenominator X k lam) *
        sampleLeftAction (leaveOneOutShrinkageResolvent X k lam) X k i *
        sampleRightAction X k (leaveOneOutShrinkageResolvent X k lam) j := by
  unfold shrinkageLeaveOneOutWoodburyCorrection
  exact mul_smul_sampleOuterProduct_mul_apply
    (leaveOneOutShrinkageResolvent X k lam) X k
    (leaveOneOutShrinkageResolvent X k lam)
    ((1 / (n : Real)) / shrinkageLeaveOneOutWoodburyDenominator X k lam) i j

/-- Full shifted matrix as the leave-one-out shifted matrix plus Woodbury rank-one data. -/
theorem shrinkageShiftedMatrix_eq_leaveOneOut_add_column_weight_row {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) :
    shrinkageShiftedMatrix X lam =
      leaveOneOutShiftedMatrix X k lam + sampleColumn X k * sampleWeightMatrix n * sampleRow X k := by
  ext i j
  simp [shrinkageShiftedMatrix, leaveOneOutShiftedMatrix, shiftedMatrix,
    sampleCovariance_eq_leaveOneOut_add_sampleOuter X k, sampleColumn,
    sampleWeightMatrix, sampleRow, sampleOuterProduct, Matrix.mul_apply]
  ring

/--
Matrix-shaped Woodbury RHS for the full shrinkage resolvent.

This keeps the `1 × 1` middle inverse explicit, matching mathlib's general
Woodbury identity before later scalar-denominator simplification.
-/
def shrinkageLeaveOneOutWoodburyMatrixRHS {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) : SquareMatrix d :=
  leaveOneOutShrinkageResolvent X k lam -
    leaveOneOutShrinkageResolvent X k lam * sampleColumn X k *
      (shrinkageLeaveOneOutWoodburyMiddle X k lam)⁻¹ *
      sampleRow X k * leaveOneOutShrinkageResolvent X k lam

/--
Woodbury RHS theorem for the full shrinkage resolvent.

The hypotheses are deterministic invertibility providers for the leave-one-out
shift, the one-dimensional normalization matrix, and the Woodbury middle
matrix.  No probabilistic positivity or concentration estimate is used here.
-/
theorem shrinkageResolvent_eq_leaveOneOutWoodburyMatrixRHS {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) :
    IsUnit (leaveOneOutShiftedMatrix X k lam).det ->
      IsUnit (sampleWeightMatrix n) ->
        IsUnit (shrinkageLeaveOneOutWoodburyMiddle X k lam) ->
          shrinkageResolvent X lam = shrinkageLeaveOneOutWoodburyMatrixRHS X k lam := by
  intro hLeave hWeight hMiddle
  change (shrinkageShiftedMatrix X lam)⁻¹ = shrinkageLeaveOneOutWoodburyMatrixRHS X k lam
  rw [shrinkageShiftedMatrix_eq_leaveOneOut_add_column_weight_row]
  simpa [shrinkageLeaveOneOutWoodburyMatrixRHS, shrinkageLeaveOneOutWoodburyMiddle,
    leaveOneOutShrinkageResolvent, precisionResolvent] using
    (Matrix.add_mul_mul_inv_eq_sub
      (leaveOneOutShiftedMatrix X k lam)
      (sampleColumn X k)
      (sampleWeightMatrix n)
      (sampleRow X k)
      ((Matrix.isUnit_iff_isUnit_det (leaveOneOutShiftedMatrix X k lam)).2 hLeave)
      hWeight
      hMiddle)

private theorem sampleRow_mul_matrix_mul_sampleColumn_apply {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (A : SquareMatrix d) :
    (sampleRow X k * A * sampleColumn X k) () () = sampleQuadraticAction X k A := by
  calc
    (sampleRow X k * A * sampleColumn X k) () ()
        = ∑ x : Fin d, (∑ x_1 : Fin d, X x_1 k * A x_1 x) * X x k := by
          simp [sampleRow, sampleColumn, Matrix.mul_apply]
    _ = ∑ x : Fin d, ∑ x_1 : Fin d, X x_1 k * A x_1 x * X x k := by
          simp [Finset.sum_mul, mul_assoc]
    _ = ∑ x_1 : Fin d, ∑ x : Fin d, X x_1 k * A x_1 x * X x k := by
          rw [Finset.sum_comm]
    _ = sampleQuadraticAction X k A := by
          simp [sampleQuadraticAction, sampleLeftAction, Finset.mul_sum, mul_assoc]

private theorem sampleWeightMatrix_inv_apply (n : Nat) :
    (sampleWeightMatrix n)⁻¹ () () = (n : Real) := by
  simp [sampleWeightMatrix]

/--
The one-dimensional Woodbury weight matrix is invertible whenever the sample
index `k : Fin n` exists.

This is a deterministic convenience provider: `k : Fin n` supplies `0 < n`,
so the scalar entry `1 / n` is nonzero.
-/
theorem sampleWeightMatrix_isUnit (n : Nat) (k : Fin n) :
    IsUnit (sampleWeightMatrix n) := by
  rw [Matrix.isUnit_iff_isUnit_det]
  simp [sampleWeightMatrix]
  exact (Fin.pos k).ne'

private theorem shrinkageLeaveOneOutWoodburyMiddle_apply {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) :
    shrinkageLeaveOneOutWoodburyMiddle X k lam () () =
      (n : Real) + sampleQuadraticAction X k (leaveOneOutShrinkageResolvent X k lam) := by
  simp [shrinkageLeaveOneOutWoodburyMiddle, sampleWeightMatrix,
    sampleRow_mul_matrix_mul_sampleColumn_apply]

/--
Convert the scalar Sherman-Morrison denominator nonzero condition into the
matrix-shaped `IsUnit` provider required by mathlib's Woodbury theorem.

No positivity or probabilistic lower-bound estimate is proved here; the
denominator nonzero fact remains an explicit deterministic input.
-/
theorem shrinkageLeaveOneOutWoodburyMiddle_isUnit_of_denominator_ne_zero {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) :
    shrinkageLeaveOneOutWoodburyDenominator X k lam ≠ 0 ->
      IsUnit (shrinkageLeaveOneOutWoodburyMiddle X k lam) := by
  intro hden
  rw [Matrix.isUnit_iff_isUnit_det]
  rw [Matrix.det_unique]
  rw [shrinkageLeaveOneOutWoodburyMiddle_apply]
  rw [isUnit_iff_ne_zero]
  intro hzero
  apply hden
  unfold shrinkageLeaveOneOutWoodburyDenominator
  calc
    1 + (1 / (n : Real)) *
        sampleQuadraticAction X k (leaveOneOutShrinkageResolvent X k lam)
        = (1 / (n : Real)) *
            ((n : Real) +
              sampleQuadraticAction X k (leaveOneOutShrinkageResolvent X k lam)) := by
          have hn : (n : Real) ≠ 0 := by
            exact_mod_cast (Fin.pos k).ne'
          field_simp [hn]
    _ = 0 := by
          rw [hzero]
          ring

private theorem shrinkageLeaveOneOutWoodburyMiddle_inv_apply {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) :
    (shrinkageLeaveOneOutWoodburyMiddle X k lam)⁻¹ () () =
      (1 / (n : Real)) / shrinkageLeaveOneOutWoodburyDenominator X k lam := by
  have hn : (n : Real) ≠ 0 := by
    exact_mod_cast (Fin.pos k).ne'
  rw [Matrix.inv_subsingleton]
  simp [shrinkageLeaveOneOutWoodburyMiddle_apply, shrinkageLeaveOneOutWoodburyDenominator]
  field_simp [hn]

private theorem mul_sampleColumn_mul_singleton_mul_sampleRow_mul_apply {d n : Nat}
    (A : SquareMatrix d) (X : DataMatrix d n) (k : Fin n)
    (M : Matrix Unit Unit Real) (B : SquareMatrix d) (i j : Fin d) :
    (A * sampleColumn X k * M * sampleRow X k * B) i j =
      sampleLeftAction A X k i * M () () * sampleRightAction X k B j := by
  simp [Matrix.mul_apply, sampleColumn, sampleRow, sampleLeftAction, sampleRightAction,
    Finset.mul_sum, mul_left_comm, mul_comm]

/--
The matrix-shaped Woodbury RHS is exactly the scalar Sherman-Morrison RHS.

This discharges the `1 × 1` middle inverse into the scalar denominator
`1 + n⁻¹ x_kᵀ R_{-k}(λ) x_k`.  The only nonzero fact used here is the
deterministic consequence `0 < n` from the index `k : Fin n`; no probability or
concentration argument is involved.
-/
theorem shrinkageLeaveOneOutWoodburyMatrixRHS_eq_scalarRHS {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) :
    shrinkageLeaveOneOutWoodburyMatrixRHS X k lam =
      shrinkageLeaveOneOutWoodburyRHS X k lam := by
  ext i j
  simp only [shrinkageLeaveOneOutWoodburyMatrixRHS, shrinkageLeaveOneOutWoodburyRHS]
  change leaveOneOutShrinkageResolvent X k lam i j -
      (leaveOneOutShrinkageResolvent X k lam * sampleColumn X k *
        (shrinkageLeaveOneOutWoodburyMiddle X k lam)⁻¹ * sampleRow X k *
        leaveOneOutShrinkageResolvent X k lam) i j =
    leaveOneOutShrinkageResolvent X k lam i j -
      shrinkageLeaveOneOutWoodburyCorrection X k lam i j
  rw [mul_sampleColumn_mul_singleton_mul_sampleRow_mul_apply]
  rw [shrinkageLeaveOneOutWoodburyMiddle_inv_apply]
  rw [shrinkageLeaveOneOutWoodburyCorrection_apply]
  ring

/--
Scalar Sherman-Morrison/Woodbury RHS theorem for the full shrinkage resolvent.

This is the scalar-denominator version of
`shrinkageResolvent_eq_leaveOneOutWoodburyMatrixRHS`; the assumptions remain
explicit deterministic invertibility providers.  It does not prove positivity,
probability, or concentration estimates.
-/
theorem shrinkageResolvent_eq_leaveOneOutWoodburyRHS {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) :
    IsUnit (leaveOneOutShiftedMatrix X k lam).det ->
      IsUnit (sampleWeightMatrix n) ->
        IsUnit (shrinkageLeaveOneOutWoodburyMiddle X k lam) ->
          shrinkageResolvent X lam = shrinkageLeaveOneOutWoodburyRHS X k lam := by
  intro hLeave hWeight hMiddle
  rw [shrinkageResolvent_eq_leaveOneOutWoodburyMatrixRHS X k lam hLeave hWeight hMiddle]
  exact shrinkageLeaveOneOutWoodburyMatrixRHS_eq_scalarRHS X k lam

/--
Scalar Sherman-Morrison/Woodbury RHS theorem with convenience invertibility
providers.

Compared with `shrinkageResolvent_eq_leaveOneOutWoodburyRHS`, this wrapper
automatically proves the one-dimensional sample-weight invertibility from
`k : Fin n` and converts a nonzero scalar denominator into the Woodbury middle
`IsUnit` provider.  The leave-one-out shifted determinant provider remains
explicit.
-/
theorem shrinkageResolvent_eq_leaveOneOutWoodburyRHS_of_denominator_ne_zero {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) :
    IsUnit (leaveOneOutShiftedMatrix X k lam).det ->
      shrinkageLeaveOneOutWoodburyDenominator X k lam ≠ 0 ->
        shrinkageResolvent X lam = shrinkageLeaveOneOutWoodburyRHS X k lam := by
  intro hLeave hden
  exact shrinkageResolvent_eq_leaveOneOutWoodburyRHS X k lam hLeave
    (sampleWeightMatrix_isUnit n k)
    (shrinkageLeaveOneOutWoodburyMiddle_isUnit_of_denominator_ne_zero X k lam hden)

/--
Typed deterministic statement for applying the resolvent identity to the
full-sample and leave-one-out shrinkage matrices.

The two determinant hypotheses are kept explicit provider inputs; this wrapper
does not prove positivity, invertibility, randomness, or concentration.
-/
def shrinkageLeaveOneOutResolventIdentityStatement {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) : Prop :=
  IsUnit (shrinkageShiftedMatrix X lam).det ->
    IsUnit (leaveOneOutShiftedMatrix X k lam).det ->
      shrinkageResolvent X lam - leaveOneOutShrinkageResolvent X k lam =
        shrinkageLeaveOneOutResolventIdentityRHS X k lam

/--
Deterministic provider wrapper for the resolvent identity between the
full-sample shrinkage resolvent and the leave-one-out shrinkage resolvent.
-/
theorem shrinkageLeaveOneOutResolventIdentity {d n : Nat}
    (X : DataMatrix d n) (k : Fin n) (lam : Real) :
    shrinkageLeaveOneOutResolventIdentityStatement X k lam := by
  intro hFull hLeave
  simpa [shrinkageLeaveOneOutResolventIdentityStatement,
    shrinkageLeaveOneOutResolventIdentityRHS, shrinkageShiftedMatrix,
    leaveOneOutShiftedMatrix, shrinkageResolvent, leaveOneOutShrinkageResolvent] using
    (precisionResolventIdentity (sampleCovariance X) (leaveOneOutSampleCovariance X k) lam
      hFull hLeave)

/--
Trace-expansion right-hand side for the paper precision error:
`d⁻¹ (tr(R R) - 2 tr(Σ⁻¹ R) + tr(Σ⁻¹ Σ⁻¹))`.

This is only the deterministic algebraic expression.  The equality with the
entrywise Frobenius error is recorded separately as a typed statement target,
with symmetry assumptions explicit.
-/
def precisionQuadraticErrorTraceRHS {d : Nat} (R SigmaInv : SquareMatrix d) : Real :=
  (1 / (d : Real)) *
    (traceSelfProduct R - 2 * traceCross SigmaInv R + traceSelfProduct SigmaInv)

/--
Typed deterministic statement target for rewriting the precision Frobenius
error as the trace-expansion RHS under symmetric precision/covariance-inverse
matrices.

This is the statement consumed by the proved deterministic algebra lemma below.
-/
def precisionQuadraticErrorTraceExpansionStatement {d : Nat}
    (R SigmaInv : SquareMatrix d) : Prop :=
  R.IsSymm ->
    SigmaInv.IsSymm ->
      precisionQuadraticError R SigmaInv = precisionQuadraticErrorTraceRHS R SigmaInv

private theorem frobeniusSq_eq_traceSelfProduct_of_isSymm {d : Nat} {A : SquareMatrix d}
    (hA : A.IsSymm) :
    frobeniusSq A = traceSelfProduct A := by
  simp [frobeniusSq, traceSelfProduct, Matrix.trace, Matrix.mul_apply, hA.apply, pow_two]

private theorem traceSelfProduct_sub_eq_trace_expansion {d : Nat} (R S : SquareMatrix d) :
    traceSelfProduct (R - S) =
      traceSelfProduct R - 2 * traceCross S R + traceSelfProduct S := by
  calc
    traceSelfProduct (R - S) =
        Matrix.trace (R * R) - Matrix.trace (R * S) - Matrix.trace (S * R) +
          Matrix.trace (S * S) := by
      simp [traceSelfProduct, Matrix.mul_sub, Matrix.sub_mul, Matrix.trace_sub]
      ring
    _ = traceSelfProduct R - 2 * traceCross S R + traceSelfProduct S := by
      rw [Matrix.trace_mul_comm R S]
      simp [traceSelfProduct, traceCross]
      ring

/--
Deterministic Frobenius/trace expansion for the precision quadratic error.

Under symmetry of `R` and `Σ⁻¹`, the entrywise normalized Frobenius error
equals the trace-expansion RHS.  This is purely finite-dimensional matrix
algebra; it does not use or imply any probability or concentration estimate.
-/
theorem precisionQuadraticErrorTraceExpansion {d : Nat} (R SigmaInv : SquareMatrix d) :
    precisionQuadraticErrorTraceExpansionStatement R SigmaInv := by
  intro hR hSigmaInv
  have hDiff : (R - SigmaInv).IsSymm := hR.sub hSigmaInv
  calc
    precisionQuadraticError R SigmaInv =
        (1 / (d : Real)) * traceSelfProduct (R - SigmaInv) := by
      simp [precisionQuadraticError, normalizedFrobeniusSq,
        frobeniusSq_eq_traceSelfProduct_of_isSymm hDiff]
    _ = precisionQuadraticErrorTraceRHS R SigmaInv := by
      rw [traceSelfProduct_sub_eq_trace_expansion R SigmaInv]
      simp [precisionQuadraticErrorTraceRHS]

/--
Trace-expansion RHS for the shrinkage resolvent
`R_X(λ) = (C_X + λ I)⁻¹`.
-/
def shrinkageQuadraticErrorTraceRHS {d n : Nat}
    (X : DataMatrix d n) (SigmaInv : SquareMatrix d) (lam : Real) : Real :=
  precisionQuadraticErrorTraceRHS (shrinkageResolvent X lam) SigmaInv

/--
Trace-expansion RHS for the shrinkage resolvent when the covariance matrix
itself is supplied and the precision target is `Σ⁻¹`.
-/
def shrinkageQuadraticErrorTraceRHS_of_covariance {d n : Nat}
    (X : DataMatrix d n) (Sigma : SquareMatrix d) (lam : Real) : Real :=
  shrinkageQuadraticErrorTraceRHS X Sigma⁻¹ lam

/--
Typed deterministic statement target for the shrinkage-resolvent precision
error trace expansion.  Probability and concentration estimates are outside
this object-layer API.
-/
def shrinkageQuadraticErrorTraceExpansionStatement {d n : Nat}
    (X : DataMatrix d n) (SigmaInv : SquareMatrix d) (lam : Real) : Prop :=
  precisionQuadraticErrorTraceExpansionStatement (shrinkageResolvent X lam) SigmaInv

/--
Typed deterministic statement target for the shrinkage trace expansion when the
covariance matrix itself is supplied and the precision target is `Σ⁻¹`.
-/
def shrinkageQuadraticErrorTraceExpansionStatement_of_covariance {d n : Nat}
    (X : DataMatrix d n) (Sigma : SquareMatrix d) (lam : Real) : Prop :=
  Sigma.IsSymm ->
    shrinkageQuadraticError_of_covariance X Sigma lam =
      shrinkageQuadraticErrorTraceRHS_of_covariance X Sigma lam

/--
Trace expansion for the shrinkage precision error.

The shrinkage-resolvent symmetry is supplied by
`shrinkageResolvent_isSymm`; users only provide symmetry of `Σ⁻¹`.  This remains
a deterministic matrix-algebra result, not a probability estimate.
-/
theorem shrinkageQuadraticErrorTraceExpansion {d n : Nat}
    (X : DataMatrix d n) (SigmaInv : SquareMatrix d) (lam : Real) :
    SigmaInv.IsSymm ->
      shrinkageQuadraticError X SigmaInv lam =
        shrinkageQuadraticErrorTraceRHS X SigmaInv lam := by
  intro hSigmaInv
  simpa [shrinkageQuadraticError, shrinkageQuadraticErrorTraceRHS] using
    precisionQuadraticErrorTraceExpansion (shrinkageResolvent X lam) SigmaInv
      (shrinkageResolvent_isSymm X lam) hSigmaInv

/--
Trace expansion for shrinkage precision error when the covariance matrix itself
is supplied.

The inverse-covariance symmetry hypothesis is discharged by
`inverseCovariance_isSymm`; this is still a deterministic matrix-algebra wrapper.
-/
theorem shrinkageQuadraticErrorTraceExpansion_of_covariance {d n : Nat}
    (X : DataMatrix d n) (Sigma : SquareMatrix d) (lam : Real) :
    shrinkageQuadraticErrorTraceExpansionStatement_of_covariance X Sigma lam := by
  intro hSigma
  exact shrinkageQuadraticErrorTraceExpansion X Sigma⁻¹ lam
    (inverseCovariance_isSymm Sigma hSigma)

end

end PrecisionDA
end HighDimProb

