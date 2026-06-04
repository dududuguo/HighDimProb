import HighDimProb.RandomMatrix.Expectation
import HighDimProb.RandomMatrix.MatrixOrder
import HighDimProb.RandomMatrix.OperatorNorm
import HighDimProb.RandomMatrix.Sums

/-!
# Matrix variance proxy vocabulary

This leaf prepares the deterministic variance-proxy objects used by future
matrix Bernstein statements. Expectations remain entrywise through
`matrixExpect`, matching the current random-matrix object layer.
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators Matrix.Norms.L2Operator

noncomputable section

/-- Square of a deterministic square matrix. -/
def matrixSquare {n : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    Matrix (Fin n) (Fin n) Real :=
  A * A

@[simp]
theorem matrixSquare_apply {n : Nat} (A : Matrix (Fin n) (Fin n) Real)
    (i j : Fin n) :
    matrixSquare A i j = Finset.univ.sum fun k : Fin n => A i k * A k j := by
  simp [matrixSquare, Matrix.mul_apply]

/-- Pointwise square of a square random matrix. -/
def randomMatrixSquare {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega n n) : RandomMatrix Omega n n :=
  fun omega => matrixSquare (A omega)

@[simp]
theorem randomMatrixSquare_apply {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (A : RandomMatrix Omega n n) (omega : Omega) :
    randomMatrixSquare A omega = matrixSquare (A omega) :=
  rfl

/-- Entrywise measurability of the pointwise matrix square. -/
theorem isRandomMatrix_matrixSquare {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} {A : RandomMatrix Omega n n}
    (hA : IsRandomMatrix P A) :
    IsRandomMatrix P (randomMatrixSquare A) := by
  intro i j
  dsimp [IsRealRandomVariable, IsRandomVariable, matrixEntry, randomMatrixSquare]
  simpa [matrixSquare, Matrix.mul_apply] using
    Finset.measurable_sum Finset.univ fun k _ => (hA i k).mul (hA k j)

/-- Entrywise second-moment matrix `E[A^2]` for a square random matrix. -/
def matrixSecondMoment {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega n n) :
    Matrix (Fin n) (Fin n) Real :=
  matrixExpect P (randomMatrixSquare A)

@[simp]
theorem matrixSecondMoment_apply {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (P : Measure Omega) (A : RandomMatrix Omega n n)
    (i j : Fin n) :
    matrixSecondMoment P A i j =
      expect P (matrixEntry (randomMatrixSquare A) i j) :=
  rfl

/-- Matrix variance proxy candidate `sum_i E[A_i^2]`. -/
def matrixVarianceProxy {Omega : Type*} [MeasurableSpace Omega] {I : Type*}
    [Fintype I] {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) : Matrix (Fin n) (Fin n) Real :=
  Finset.univ.sum fun i : I => matrixSecondMoment P (A i)

@[simp]
theorem matrixVarianceProxy_apply {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) (r c : Fin n) :
    matrixVarianceProxy P A r c =
      Finset.univ.sum fun i : I => matrixSecondMoment P (A i) r c := by
  simpa [matrixVarianceProxy] using
    Matrix.sum_apply r c Finset.univ (fun i : I => matrixSecondMoment P (A i))

/-- Compatibility alias for the MC1 capitalized variance-proxy name. -/
abbrev MatrixVarianceProxy {Omega : Type*} [MeasurableSpace Omega] {I : Type*}
    [Fintype I] {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) : Matrix (Fin n) (Fin n) Real :=
  matrixVarianceProxy P A

/-- Upper bound on a matrix variance proxy in the explicit Loewner-style order. -/
def matrixVarianceProxyBound {n : Nat} (V : Matrix (Fin n) (Fin n) Real)
    (sigma2 : Real) : Prop :=
  MatrixLE V (Matrix.scalar (Fin n) sigma2)

/-- Compatibility alias for the MC1 capitalized variance-proxy bound name. -/
abbrev MatrixVarianceProxyBound {n : Nat} (V : Matrix (Fin n) (Fin n) Real)
    (sigma2 : Real) : Prop :=
  matrixVarianceProxyBound V sigma2

/-- Deterministic operator norm of a matrix variance proxy. -/
def deterministicMatrixVarianceProxyNorm {n : Nat}
    (V : Matrix (Fin n) (Fin n) Real) : Real :=
  deterministicOperatorNorm V

@[simp]
theorem deterministicMatrixVarianceProxyNorm_apply {n : Nat}
    (V : Matrix (Fin n) (Fin n) Real) :
    deterministicMatrixVarianceProxyNorm V = deterministicOperatorNorm V :=
  rfl

/-- Scalar variance proxy norm `‖sum_i E[A_i^2]‖`. -/
def matrixVarianceProxyNorm {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) : Real :=
  deterministicMatrixVarianceProxyNorm (matrixVarianceProxy P A)

@[simp]
theorem matrixVarianceProxyNorm_apply {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) :
    matrixVarianceProxyNorm P A =
      deterministicOperatorNorm (matrixVarianceProxy P A) :=
  rfl

/-- The square of a self-adjoint real matrix is self-adjoint. -/
theorem isSelfAdjointMatrix_matrixSquare_of_isSelfAdjointMatrix {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : IsSelfAdjointMatrix A) :
    IsSelfAdjointMatrix (matrixSquare A) := by
  apply Matrix.IsHermitian.ext
  intro i j
  calc
    star (matrixSquare A j i)
        = Finset.univ.sum fun k : Fin n => star (A j k * A k i) := by
          simp [matrixSquare, Matrix.mul_apply]
    _ = Finset.univ.sum fun k : Fin n => A i k * A k j := by
          apply Finset.sum_congr rfl
          intro k _
          have hki : star (A k i) = A i k := Matrix.IsHermitian.apply hA i k
          have hjk : star (A j k) = A k j := Matrix.IsHermitian.apply hA k j
          calc
            star (A j k * A k i) = star (A k i) * star (A j k) := by
              simpa using (star_mul (A j k) (A k i))
            _ = A i k * A k j := by
              rw [hki, hjk]
    _ = matrixSquare A i j := by
          simp [matrixSquare, Matrix.mul_apply]

end

end HighDimProb
