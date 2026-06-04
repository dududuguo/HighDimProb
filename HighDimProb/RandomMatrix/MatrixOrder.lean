import HighDimProb.RandomMatrix.Algebra
import HighDimProb.RandomMatrix.SelfAdjoint

/-!
# Explicit matrix PSD and Loewner-style vocabulary

This module deliberately does not install a global order instance on matrices.
For the matrix concentration statement layer, `IsPSDMatrix` means symmetric
plus nonnegative quadratic form in the existing HighDimProb double-sum normal
form. `MatrixLE A B` is the corresponding Loewner-style predicate
`IsPSDMatrix (B - A)`.
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators

noncomputable section

/-- Deterministic quadratic form `x^T A x` in HighDimProb's double-sum normal form. -/
def matrixQuadraticForm {n : Nat} (A : Matrix (Fin n) (Fin n) Real)
    (x : Fin n -> Real) : Real :=
  Finset.univ.sum fun i : Fin n =>
    Finset.univ.sum fun j : Fin n => x i * A i j * x j

@[simp]
theorem matrixQuadraticForm_apply {n : Nat} (A : Matrix (Fin n) (Fin n) Real)
    (x : Fin n -> Real) :
    matrixQuadraticForm A x =
      Finset.univ.sum fun i : Fin n =>
        Finset.univ.sum fun j : Fin n => x i * A i j * x j :=
  rfl

/-- PSD predicate used by the current matrix concentration scaffolding:
symmetric plus nonnegative quadratic form. -/
def IsPSDMatrix {n : Nat} (A : Matrix (Fin n) (Fin n) Real) : Prop :=
  IsSymmetricMatrix A /\ forall x : Fin n -> Real, 0 <= matrixQuadraticForm A x

/-- Pointwise PSD random square matrix. -/
def RandomPSDMatrix {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (_P : Measure Omega) (A : RandomMatrix Omega n n) : Prop :=
  forall omega, IsPSDMatrix (A omega)

/-- Loewner-style comparison without declaring a global matrix order instance. -/
def MatrixLE {n : Nat} (A B : Matrix (Fin n) (Fin n) Real) : Prop :=
  IsPSDMatrix (B - A)

theorem matrixQuadraticForm_sub {n : Nat}
    (B A : Matrix (Fin n) (Fin n) Real) (x : Fin n -> Real) :
    matrixQuadraticForm (B - A) x =
      matrixQuadraticForm B x - matrixQuadraticForm A x := by
  simp [matrixQuadraticForm]
  rw [<- Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro i _
  rw [<- Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro j _
  ring

theorem isPSDMatrix_quadraticForm_nonneg {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : IsPSDMatrix A)
    (x : Fin n -> Real) :
    0 <= matrixQuadraticForm A x :=
  hA.2 x

/-- Loewner-style matrix comparison implies quadratic-form comparison. -/
theorem quadraticForm_le_of_matrixLE {n : Nat}
    {A B : Matrix (Fin n) (Fin n) Real} (hAB : MatrixLE A B)
    (x : Fin n -> Real) :
    matrixQuadraticForm A x <= matrixQuadraticForm B x := by
  have hnonneg := isPSDMatrix_quadraticForm_nonneg hAB x
  rw [matrixQuadraticForm_sub] at hnonneg
  exact sub_nonneg.mp hnonneg

/-- Pointwise random-matrix version of `quadraticForm_le_of_matrixLE`. -/
theorem quadraticForm_apply_le_of_matrixLE {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} {A B : RandomMatrix Omega n n}
    (hAB : forall omega, MatrixLE (A omega) (B omega))
    (x : Fin n -> Real) (omega : Omega) :
    quadraticForm A x omega <= quadraticForm B x omega := by
  simpa [quadraticForm, matrixQuadraticForm] using
    quadraticForm_le_of_matrixLE (hAB omega) x

theorem randomPSDMatrix_apply {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} {A : RandomMatrix Omega n n}
    (hA : RandomPSDMatrix P A) (omega : Omega) :
    IsPSDMatrix (A omega) :=
  hA omega

/-- The uncentered sample covariance matrix is symmetric pointwise. -/
theorem isSymmetricMatrix_sampleCovariance {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (A : RandomMatrix Omega m n) (omega : Omega) :
    IsSymmetricMatrix (sampleCovariance A omega) := by
  apply Matrix.IsSymm.ext
  intro i j
  dsimp [sampleCovariance, sampleCovarianceEntry, gramMatrixEntry]
  congr 1
  exact Finset.sum_congr rfl fun k _ => by ring

/-- The uncentered sample covariance matrix is PSD pointwise. -/
theorem isPSD_sampleCovariance {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (A : RandomMatrix Omega m n) (omega : Omega) :
    IsPSDMatrix (sampleCovariance A omega) := by
  exact And.intro (isSymmetricMatrix_sampleCovariance A omega) (by
    intro x
    simpa [matrixQuadraticForm, quadraticForm] using
      quadraticForm_sampleCovariance_nonneg A x omega)

/-- The sample covariance random matrix is pointwise PSD. -/
theorem randomPSDMatrix_sampleCovariance {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} (A : RandomMatrix Omega m n) :
    RandomPSDMatrix P (sampleCovariance A) := by
  intro omega
  exact isPSD_sampleCovariance A omega

end

end HighDimProb
