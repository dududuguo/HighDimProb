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

/-- Semantic assertion that the variance proxy of a random matrix family is
bounded above by a deterministic matrix. -/
def MatrixVarianceProxyUpperBound {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) (V : Matrix (Fin n) (Fin n) Real) :
    Prop :=
  MatrixLE (matrixVarianceProxy P A) V

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

/-- Semantic scalar-norm bound for the variance proxy of a random matrix
family. This packages the scalar parameter used in Matrix Bernstein statements
without changing the underlying `matrixVarianceProxyNorm` definition. -/
def MatrixVarianceProxyNormBound {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) (sigma2 : Real) : Prop :=
  matrixVarianceProxyNorm P A <= sigma2

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

/-! ## PSD structure of matrix squares, second moments, and variance proxies -/

/-- Quadratic form of the square of a self-adjoint real matrix is the squared
Euclidean norm of the matrix-vector product. -/
theorem matrixQuadraticForm_matrixSquare_eq_matVecSqNorm_of_selfAdjoint {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : IsSelfAdjointMatrix A)
    (x : Fin n -> Real) :
    matrixQuadraticForm (matrixSquare A) x = matVecSqNorm A x := by
  have hsymm : forall i j : Fin n, A i j = A j i := by
    intro i j
    have h := Matrix.IsHermitian.apply hA i j
    simpa using h.symm
  have hsq : forall u : Fin n -> Real,
      (Finset.univ.sum fun i : Fin n =>
        Finset.univ.sum fun j : Fin n => u i * u j) =
        (Finset.univ.sum fun i : Fin n => u i) ^ 2 := by
    intro u
    rw [pow_two, Finset.sum_mul]
    apply Finset.sum_congr rfl
    intro i _
    rw [Finset.mul_sum]
  calc
    matrixQuadraticForm (matrixSquare A) x
        = Finset.univ.sum fun i : Fin n =>
            Finset.univ.sum fun j : Fin n =>
              (x i * Finset.univ.sum (fun k : Fin n => A i k * A k j)) * x j := by
          simp [matrixQuadraticForm, matrixSquare, Matrix.mul_apply]
    _ = Finset.univ.sum fun i : Fin n =>
          Finset.univ.sum fun j : Fin n =>
            Finset.univ.sum fun k : Fin n => (A k i * x i) * (A k j * x j) := by
          apply Finset.sum_congr rfl
          intro i _
          apply Finset.sum_congr rfl
          intro j _
          rw [Finset.mul_sum, Finset.sum_mul]
          apply Finset.sum_congr rfl
          intro k _
          rw [hsymm i k]
          ring
    _ = Finset.univ.sum fun k : Fin n =>
          Finset.univ.sum fun i : Fin n =>
            Finset.univ.sum fun j : Fin n => (A k i * x i) * (A k j * x j) := by
          calc
            (Finset.univ.sum fun i : Fin n =>
              Finset.univ.sum fun j : Fin n =>
                Finset.univ.sum fun k : Fin n => (A k i * x i) * (A k j * x j))
                = Finset.univ.sum fun i : Fin n =>
                    Finset.univ.sum fun k : Fin n =>
                      Finset.univ.sum fun j : Fin n => (A k i * x i) * (A k j * x j) := by
                  apply Finset.sum_congr rfl
                  intro i _
                  rw [Finset.sum_comm]
            _ = Finset.univ.sum fun k : Fin n =>
                  Finset.univ.sum fun i : Fin n =>
                    Finset.univ.sum fun j : Fin n => (A k i * x i) * (A k j * x j) := by
                  rw [Finset.sum_comm]
    _ = Finset.univ.sum fun k : Fin n =>
          (Finset.univ.sum fun i : Fin n => A k i * x i) ^ 2 := by
          apply Finset.sum_congr rfl
          intro k _
          exact hsq (fun i : Fin n => A k i * x i)
    _ = matVecSqNorm A x := by
          simp [matVecSqNorm, vectorSqNorm]

/-- The square of a self-adjoint real matrix is PSD in the explicit
HighDimProb quadratic-form order. -/
theorem isPSD_matrixSquare_of_selfAdjoint {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : IsSelfAdjointMatrix A) :
    IsPSDMatrix (matrixSquare A) := by
  refine ⟨?_, ?_⟩
  · have hsqAdj : IsSelfAdjointMatrix (matrixSquare A) :=
      isSelfAdjointMatrix_matrixSquare_of_isSelfAdjointMatrix hA
    apply Matrix.IsSymm.ext
    intro i j
    have h := Matrix.IsHermitian.apply hsqAdj i j
    simpa using h
  · intro x
    rw [matrixQuadraticForm_matrixSquare_eq_matVecSqNorm_of_selfAdjoint hA]
    exact matVecSqNorm_nonneg A x

/-- Entrywise matrix expectation commutes with the explicit quadratic form,
under entrywise integrability. -/
theorem matrixQuadraticForm_matrixExpect {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} {A : RandomMatrix Omega n n}
    (hA : IntegrableRandomMatrix P A) (x : Fin n -> Real) :
    matrixQuadraticForm (matrixExpect P A) x =
      expect P (fun omega => matrixQuadraticForm (A omega) x) := by
  calc
    matrixQuadraticForm (matrixExpect P A) x
        = Finset.univ.sum fun i : Fin n =>
            Finset.univ.sum fun j : Fin n =>
              x i * (∫ omega, A omega i j ∂P) * x j := by
          simp [matrixQuadraticForm, matrixExpect, expect, matrixEntry]
    _ = Finset.univ.sum fun i : Fin n =>
          Finset.univ.sum fun j : Fin n =>
            ∫ omega, x i * A omega i j * x j ∂P := by
          apply Finset.sum_congr rfl
          intro i _
          apply Finset.sum_congr rfl
          intro j _
          calc
            x i * (∫ omega, A omega i j ∂P) * x j
                = (∫ omega, x i * A omega i j ∂P) * x j := by
                  rw [MeasureTheory.integral_const_mul]
            _ = ∫ omega, (x i * A omega i j) * x j ∂P := by
                  rw [MeasureTheory.integral_mul_const]
            _ = ∫ omega, x i * A omega i j * x j ∂P := by
                  rfl
    _ = ∫ omega, Finset.univ.sum fun i : Fin n =>
          Finset.univ.sum fun j : Fin n => x i * A omega i j * x j ∂P := by
          have houter :
              (∫ omega, Finset.univ.sum fun i : Fin n =>
                Finset.univ.sum fun j : Fin n => x i * A omega i j * x j ∂P) =
                Finset.univ.sum fun i : Fin n =>
                  ∫ omega, Finset.univ.sum fun j : Fin n => x i * A omega i j * x j ∂P :=
            MeasureTheory.integral_finset_sum Finset.univ fun i _ =>
              integrable_finset_sum Finset.univ fun j _ =>
                ((hA i j).const_mul (x i)).mul_const (x j)
          rw [houter]
          apply Finset.sum_congr rfl
          intro i _
          have hinner :
              (∫ omega, Finset.univ.sum fun j : Fin n => x i * A omega i j * x j ∂P) =
                Finset.univ.sum fun j : Fin n =>
                  ∫ omega, x i * A omega i j * x j ∂P :=
            MeasureTheory.integral_finset_sum Finset.univ fun j _ =>
              ((hA i j).const_mul (x i)).mul_const (x j)
          rw [hinner]
    _ = expect P (fun omega => matrixQuadraticForm (A omega) x) := by
          simp [expect, matrixQuadraticForm]

/-- Typed target: the square of a self-adjoint real matrix is PSD.

The proof requires the identity `xᵀ A² x = (Ax)ᵀ (Ax) = ‖Ax‖² ≥ 0`.
When A is self-adjoint, `A² = Aᵀ A`, and `xᵀ Aᵀ A x = ‖Ax‖²` is true
for any real matrix A by expanding the finite sums and using
`Finset.sum_comm` and `Finset.mul_sum`.

The corresponding theorem `isPSD_matrixSquare_of_selfAdjoint` is now proved. -/
abbrev isPSD_matrixSquare_of_selfAdjoint_statement {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (_hA : IsSelfAdjointMatrix A) : Prop :=
  IsPSDMatrix (matrixSquare A)

/-- The second moment matrix of a self-adjoint random matrix family is self-adjoint.
This is proven: each `(A ω)^2` is self-adjoint, and entrywise expectation preserves
self-adjointness because `star` is identity on ℝ and the integral is linear. -/
theorem isSelfAdjointMatrix_matrixSecondMoment {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} {A : RandomMatrix Omega n n}
    (hA : RandomSelfAdjointMatrix P A) :
    IsSelfAdjointMatrix (matrixSecondMoment P A) := by
  apply Matrix.IsHermitian.ext
  intro i j
  -- For real matrices, star = id.
  -- We need: (E[A^2])_ji = (E[A^2])_ij
  dsimp [matrixSecondMoment, matrixExpect, expect]
  -- Goal: (∫ ω, (randomMatrixSquare A) ω j i ∂P) = (∫ ω, (randomMatrixSquare A) ω i j ∂P)
  have h_entry_eq : ∀ ω, (randomMatrixSquare A) ω j i = (randomMatrixSquare A) ω i j := by
    intro ω
    simp [randomMatrixSquare]
    have h_sq_herm : IsSelfAdjointMatrix (matrixSquare (A ω)) :=
      isSelfAdjointMatrix_matrixSquare_of_isSelfAdjointMatrix (hA ω)
    -- h_sq_herm : IsHermitian (A ω)^2, so (A ω)^2_{ji} = (A ω)^2_{ij} (real case)
    have h_eq := Matrix.IsHermitian.apply h_sq_herm j i
    -- h_eq : star ((A ω)^2_{i j}) = (A ω)^2_{j i}
    -- For ℝ, star = id, so this gives (A ω)^2_{ij} = (A ω)^2_{ji}
    -- Goal: (A ω)^2_{ji} = (A ω)^2_{ij}, which is h_eq.symm
    simpa using h_eq.symm
  -- Now the two functions are equal pointwise, so their integrals are equal
  refine integral_congr_ae ?_
  filter_upwards with ω
  exact h_entry_eq ω

/-- The second moment matrix `E[A^2]` of a self-adjoint random matrix is PSD,
provided the squared random matrix is entrywise integrable. -/
theorem isPSD_matrixSecondMoment_of_selfAdjoint {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} {A : RandomMatrix Omega n n}
    (hA : RandomSelfAdjointMatrix P A)
    (hInt : IntegrableRandomMatrix P (randomMatrixSquare A)) :
    IsPSDMatrix (matrixSecondMoment P A) := by
  refine ⟨?_, ?_⟩
  · have hAdj : IsSelfAdjointMatrix (matrixSecondMoment P A) :=
      isSelfAdjointMatrix_matrixSecondMoment hA
    apply Matrix.IsSymm.ext
    intro i j
    have h := Matrix.IsHermitian.apply hAdj i j
    simpa using h
  · intro x
    change 0 <= matrixQuadraticForm (matrixExpect P (randomMatrixSquare A)) x
    rw [matrixQuadraticForm_matrixExpect hInt]
    change 0 <= ∫ omega, matrixQuadraticForm (randomMatrixSquare A omega) x ∂P
    exact MeasureTheory.integral_nonneg fun omega => by
      simpa [randomMatrixSquare] using
        (isPSD_matrixSquare_of_selfAdjoint (hA omega)).2 x

/-- Typed target: the second moment matrix `E[A^2]` of a self-adjoint random matrix is PSD.

The proof requires: `matrixQuadraticForm (E[A^2]) x = E[matrixQuadraticForm(A^2) x]`
(linearity of expectation over finite sums), and then pointwise nonnegativity
of `matrixQuadraticForm (A ω^2) x` gives the result.

The corresponding theorem `isPSD_matrixSecondMoment_of_selfAdjoint` is now
proved with the explicit additional assumption
`IntegrableRandomMatrix P (randomMatrixSquare A)`. -/
abbrev isPSD_matrixSecondMoment_of_selfAdjoint_statement {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat} {A : RandomMatrix Omega n n}
    (_hA : RandomSelfAdjointMatrix P A) : Prop :=
  IsPSDMatrix (matrixSecondMoment P A)

/-- The matrix variance proxy `sum_i E[A_i^2]` is self-adjoint when each term is. -/
theorem isSelfAdjointMatrix_matrixVarianceProxy {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega)
    {A : I -> RandomMatrix Omega n n}
    (hA : forall i, RandomSelfAdjointMatrix P (A i)) :
    IsSelfAdjointMatrix (matrixVarianceProxy P A) := by
  apply isSelfAdjointMatrix_sum
  intro i
  exact isSelfAdjointMatrix_matrixSecondMoment (hA i)

/-- The matrix variance proxy `sum_i E[A_i^2]` is PSD when every summand is
self-adjoint and every squared summand is entrywise integrable. -/
theorem isPSD_matrixVarianceProxy_of_selfAdjoint {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega)
    {A : I -> RandomMatrix Omega n n}
    (hA : forall i, RandomSelfAdjointMatrix P (A i))
    (hInt : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i))) :
    IsPSDMatrix (matrixVarianceProxy P A) := by
  dsimp [matrixVarianceProxy]
  apply isPSDMatrix_sum
  intro i
  exact isPSD_matrixSecondMoment_of_selfAdjoint (hA i) (hInt i)

/-- Typed target: the matrix variance proxy `sum_i E[A_i^2]` is PSD.

The proof follows from each `E[A_i^2]` being PSD and the fact that
`matrixQuadraticForm` is linear in the matrix, distributing over finite sums.

The corresponding theorem `isPSD_matrixVarianceProxy_of_selfAdjoint` is now
proved with explicit per-summand square-integrability assumptions. -/
abbrev isPSD_matrixVarianceProxy_of_selfAdjoint_statement {Omega : Type*}
    [MeasurableSpace Omega] {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega)
    {A : I -> RandomMatrix Omega n n}
    (_hA : forall i, RandomSelfAdjointMatrix P (A i)) : Prop :=
  IsPSDMatrix (matrixVarianceProxy P A)



end

end HighDimProb
