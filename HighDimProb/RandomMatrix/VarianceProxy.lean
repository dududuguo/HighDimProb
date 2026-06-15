import HighDimProb.RandomMatrix.Expectation
import HighDimProb.RandomMatrix.MatrixOrder
import HighDimProb.RandomMatrix.OperatorNorm
import HighDimProb.RandomMatrix.Sums

/-!
# Matrix variance proxy vocabulary

Verified Wikipedia references:
* Variance: https://en.wikipedia.org/wiki/Variance
* Random matrix: https://en.wikipedia.org/wiki/Random_matrix
* Matrix multiplication: https://en.wikipedia.org/wiki/Matrix_multiplication
* Operator norm: https://en.wikipedia.org/wiki/Operator_norm

Note: Wikipedia does not provide a dedicated `variance proxy` page; this file
uses the standard matrix-concentration proxy `sum_i E[A_i^2]`.

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

/-- Crude scalar RHS for variance-proxy norm control from a pointwise
operator-norm bound. -/
abbrev pointwiseOperatorNormVarianceProxyNormRHS {I : Type*} [Fintype I]
    (R : Real) : Real :=
  (Fintype.card I : Real) * R ^ 2

/-- The deterministic operator norm of a matrix square is bounded by the square
of the deterministic operator norm. -/
theorem deterministicOperatorNorm_matrixSquare_le_sq {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) :
    deterministicOperatorNorm (matrixSquare A) <=
      deterministicOperatorNorm A ^ 2 := by
  simpa [deterministicOperatorNorm, matrixSquare, pow_two] using norm_mul_le A A

/-- A deterministic operator-norm bound controls the operator norm of the matrix
square with the squared radius. -/
theorem deterministicOperatorNorm_matrixSquare_le_sq_of_le {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} {R : Real}
    (hA : deterministicOperatorNorm A <= R) (hR : 0 <= R) :
    deterministicOperatorNorm (matrixSquare A) <= R ^ 2 := by
  have hsq :
      deterministicOperatorNorm (matrixSquare A) <=
        deterministicOperatorNorm A ^ 2 :=
    deterministicOperatorNorm_matrixSquare_le_sq A
  have hnorm_nonneg : 0 <= deterministicOperatorNorm A := by
    exact norm_nonneg A
  have hsqR : deterministicOperatorNorm A ^ 2 <= R ^ 2 := by
    nlinarith
  exact hsq.trans hsqR

/-- A pointwise operator-norm bound on a random matrix controls the operator
norm of its matrix second moment, provided the squared random matrix is
entrywise integrable. -/
theorem deterministicOperatorNorm_matrixSecondMoment_le_sq_of_forall
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {n : Nat} {A : RandomMatrix Omega n n}
    {R : Real}
    (hInt : IntegrableRandomMatrix P (randomMatrixSquare A))
    (hBound : forall omega, deterministicOperatorNorm (A omega) <= R)
    (hR : 0 <= R) :
    deterministicOperatorNorm (matrixSecondMoment P A) <= R ^ 2 := by
  have hBridge :
      matrixSecondMoment P A =
        MeasureTheory.integral P (fun omega => randomMatrixSquare A omega) := by
    exact matrixExpect_eq_integral (P := P) (A := randomMatrixSquare A) hInt
  calc
    deterministicOperatorNorm (matrixSecondMoment P A)
        = norm (matrixSecondMoment P A) := rfl
    _ =
        norm (MeasureTheory.integral P (fun omega => randomMatrixSquare A omega)) := by
          rw [hBridge]
    _ <= R ^ 2 * P.real Set.univ := by
          apply MeasureTheory.norm_integral_le_of_norm_le_const
          filter_upwards with omega
          have hsq :
              deterministicOperatorNorm (matrixSquare (A omega)) <= R ^ 2 :=
            deterministicOperatorNorm_matrixSquare_le_sq_of_le (hBound omega) hR
          simpa [randomMatrixSquare, deterministicOperatorNorm] using hsq
    _ = R ^ 2 := by
          simp

/-- A pointwise operator-norm bound on every summand controls the scalar norm of
the matrix variance proxy by the crude finite-family bound
`cardinality * R^2`. -/
theorem matrixVarianceProxyNorm_le_pointwiseOperatorNormVarianceProxyNormRHS
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    {A : I -> RandomMatrix Omega n n} {R : Real}
    (hInt : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i)))
    (hBound : forall i omega, deterministicOperatorNorm (A i omega) <= R)
    (hR : 0 <= R) :
    matrixVarianceProxyNorm P A <=
      pointwiseOperatorNormVarianceProxyNormRHS (I := I) R := by
  dsimp [matrixVarianceProxyNorm, deterministicMatrixVarianceProxyNorm,
    matrixVarianceProxy, pointwiseOperatorNormVarianceProxyNormRHS]
  calc
    norm (Finset.univ.sum fun i : I => matrixSecondMoment P (A i))
        <= Finset.univ.sum fun i : I => norm (matrixSecondMoment P (A i)) := by
          exact norm_sum_le _ _
    _ <= Finset.univ.sum fun _i : I => R ^ 2 := by
          apply Finset.sum_le_sum
          intro i _
          exact deterministicOperatorNorm_matrixSecondMoment_le_sq_of_forall
            (P := P) (A := A i) (R := R) (hInt i) (hBound i) hR
    _ = (Fintype.card I : Real) * R ^ 2 := by
          simp

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

/-- Entrywise integrability is closed under pointwise matrix subtraction. -/
theorem integrableRandomMatrix_sub {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {A B : RandomMatrix Omega m n}
    (hA : IntegrableRandomMatrix P A)
    (hB : IntegrableRandomMatrix P B) :
    IntegrableRandomMatrix P (fun omega => B omega - A omega) := by
  intro i j
  change Integrable (fun omega => B omega i j - A omega i j) P
  exact (hB i j).sub (hA i j)

/-- Entrywise integrability is closed under pointwise matrix addition. -/
theorem integrableRandomMatrix_add {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {A B : RandomMatrix Omega m n}
    (hA : IntegrableRandomMatrix P A)
    (hB : IntegrableRandomMatrix P B) :
    IntegrableRandomMatrix P (fun omega => A omega + B omega) := by
  intro i j
  change Integrable (fun omega => A omega i j + B omega i j) P
  exact (hA i j).add (hB i j)

/-- Entrywise integrability is closed under deterministic scalar multiplication. -/
theorem integrableRandomMatrix_smul {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} (c : Real)
    {A : RandomMatrix Omega m n} (hA : IntegrableRandomMatrix P A) :
    IntegrableRandomMatrix P (fun omega => c • A omega) := by
  intro i j
  change Integrable (fun omega => c * A omega i j) P
  exact (hA i j).const_mul c

/-- The zero random matrix is entrywise integrable. -/
theorem integrableRandomMatrix_zero {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} :
    IntegrableRandomMatrix P (fun _omega => (0 : Matrix (Fin m) (Fin n) Real)) := by
  intro i j
  change Integrable (fun _omega : Omega => (0 : Real)) P
  exact MeasureTheory.integrable_zero Omega Real P

/-- Constant random matrices are entrywise integrable over finite measures. -/
theorem integrableRandomMatrix_const {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsFiniteMeasure P] {m n : Nat}
    (A : Matrix (Fin m) (Fin n) Real) :
    IntegrableRandomMatrix P (fun _omega => A) := by
  intro i j
  change Integrable (fun _omega : Omega => A i j) P
  exact MeasureTheory.integrable_const (A i j)

/-- Entrywise matrix expectation commutes with pointwise matrix subtraction. -/
theorem matrixExpect_sub {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {A B : RandomMatrix Omega m n}
    (hA : IntegrableRandomMatrix P A)
    (hB : IntegrableRandomMatrix P B) :
    matrixExpect P (fun omega => B omega - A omega) =
      matrixExpect P B - matrixExpect P A := by
  ext i j
  simp [matrixExpect, expect, matrixEntry, Matrix.sub_apply]
  exact MeasureTheory.integral_sub (hB i j) (hA i j)

/-- Entrywise matrix expectation commutes with pointwise matrix addition. -/
theorem matrixExpect_add {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {A B : RandomMatrix Omega m n}
    (hA : IntegrableRandomMatrix P A)
    (hB : IntegrableRandomMatrix P B) :
    matrixExpect P (fun omega => A omega + B omega) =
      matrixExpect P A + matrixExpect P B := by
  ext i j
  simp [matrixExpect, expect, matrixEntry, Matrix.add_apply]
  exact MeasureTheory.integral_add (hA i j) (hB i j)

/-- Entrywise matrix expectation commutes with deterministic scalar multiplication. -/
theorem matrixExpect_smul {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} (c : Real)
    {A : RandomMatrix Omega m n} :
    matrixExpect P (fun omega => c • A omega) =
      c • matrixExpect P A := by
  ext i j
  simp [matrixExpect, expect, matrixEntry, Matrix.smul_apply]
  exact MeasureTheory.integral_smul c (fun omega => A omega i j)

/-- The expectation of the zero random matrix is zero. -/
theorem matrixExpect_zero {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} :
    matrixExpect P (fun _omega => (0 : Matrix (Fin m) (Fin n) Real)) = 0 := by
  ext i j
  simp [matrixExpect, expect, matrixEntry]

/-- Entrywise expectation of a constant random matrix. -/
theorem matrixExpect_const {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} (A : Matrix (Fin m) (Fin n) Real) :
    matrixExpect P (fun _omega => A) = (P.real Set.univ) • A := by
  ext i j
  simp [matrixExpect, expect, matrixEntry, Matrix.smul_apply]

/-- Entrywise expectation of a constant matrix over a probability measure. -/
theorem matrixExpect_const_of_isProbabilityMeasure {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {m n : Nat} (A : Matrix (Fin m) (Fin n) Real) :
    matrixExpect P (fun _omega => A) = A := by
  rw [matrixExpect_const]
  ext i j
  simp [Matrix.smul_apply]

/-- Entrywise expectation of the identity matrix over a probability measure. -/
theorem matrixExpect_one_of_isProbabilityMeasure {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {n : Nat} :
    matrixExpect P (fun _omega => (1 : Matrix (Fin n) (Fin n) Real)) = 1 := by
  simpa using
    (matrixExpect_const_of_isProbabilityMeasure
      (P := P) (A := (1 : Matrix (Fin n) (Fin n) Real)))

/-- Entrywise expectation preserves pointwise PSD matrices. -/
theorem isPSDMatrix_matrixExpect_of_pointwise_isPSD {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega}
    {n : Nat} {A : RandomMatrix Omega n n}
    (hInt : IntegrableRandomMatrix P A)
    (hPSD : forall omega, IsPSDMatrix (A omega)) :
    IsPSDMatrix (matrixExpect P A) := by
  refine ⟨?_, ?_⟩
  · apply Matrix.IsSymm.ext
    intro i j
    dsimp [matrixExpect, expect]
    refine integral_congr_ae ?_
    filter_upwards with omega
    exact isSymmetricMatrix_apply (hPSD omega).1 i j
  · intro x
    rw [matrixQuadraticForm_matrixExpect hInt x]
    change 0 <= ∫ omega, matrixQuadraticForm (A omega) x ∂P
    exact MeasureTheory.integral_nonneg fun omega => (hPSD omega).2 x

/-- Entrywise matrix expectation is monotone for the explicit matrix order. -/
theorem matrixExpect_matrixLE_of_pointwise_matrixLE {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega}
    {n : Nat} {A B : RandomMatrix Omega n n}
    (hIntA : IntegrableRandomMatrix P A)
    (hIntB : IntegrableRandomMatrix P B)
    (hLE : forall omega, MatrixLE (A omega) (B omega)) :
    MatrixLE (matrixExpect P A) (matrixExpect P B) := by
  unfold MatrixLE
  have hIntSub : IntegrableRandomMatrix P (fun omega => B omega - A omega) :=
    integrableRandomMatrix_sub hIntA hIntB
  have hPSD :
      IsPSDMatrix (matrixExpect P (fun omega => B omega - A omega)) :=
    isPSDMatrix_matrixExpect_of_pointwise_isPSD hIntSub hLE
  have hSub :
      matrixExpect P (fun omega => B omega - A omega) =
        matrixExpect P B - matrixExpect P A :=
    matrixExpect_sub hIntA hIntB
  rw [← hSub]
  exact hPSD

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
