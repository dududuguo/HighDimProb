import HighDimProb.RandomMatrix.Basic

/-!
# Sample covariance vocabulary for random matrices
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators

noncomputable section

/-- Entry of the Gram matrix `A(omega)^T A(omega)`, written as an explicit row sum. -/
def gramMatrixEntry {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (i j : Fin n) : RealRandomVariable Omega :=
  fun omega => Finset.univ.sum fun k : Fin m => A omega k i * A omega k j

/-- Gram matrix `omega |-> A(omega)^T A(omega)`, represented entrywise. -/
def gramMatrix {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) : RandomMatrix Omega n n :=
  fun omega i j => gramMatrixEntry A i j omega

/-- Entry of the row Gram matrix `A(omega) A(omega)^T`, written as an explicit column sum. -/
def rowGramMatrixEntry {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (i j : Fin m) : RealRandomVariable Omega :=
  fun omega => Finset.univ.sum fun k : Fin n => A omega i k * A omega j k

/-- Row Gram matrix `omega |-> A(omega) A(omega)^T`, represented entrywise. -/
def rowGramMatrix {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) : RandomMatrix Omega m m :=
  fun omega i j => rowGramMatrixEntry A i j omega

/-- Entry of the uncentered sample covariance `(1 / m) A(omega)^T A(omega)`. -/
def sampleCovarianceEntry {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (i j : Fin n) : RealRandomVariable Omega :=
  fun omega => (1 / (m : Real)) * gramMatrixEntry A i j omega

/-- Uncentered sample covariance matrix with rows interpreted as samples. -/
def sampleCovariance {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) : RandomMatrix Omega n n :=
  fun omega i j => sampleCovarianceEntry A i j omega

@[simp]
theorem gramMatrixEntry_apply {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (i j : Fin n) (omega : Omega) :
    gramMatrixEntry A i j omega =
      Finset.univ.sum fun k : Fin m => A omega k i * A omega k j :=
  rfl

@[simp]
theorem gramMatrix_apply {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (omega : Omega) (i j : Fin n) :
    gramMatrix A omega i j = gramMatrixEntry A i j omega :=
  rfl

@[simp]
theorem rowGramMatrixEntry_apply {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (i j : Fin m) (omega : Omega) :
    rowGramMatrixEntry A i j omega =
      Finset.univ.sum fun k : Fin n => A omega i k * A omega j k :=
  rfl

@[simp]
theorem rowGramMatrix_apply {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (omega : Omega) (i j : Fin m) :
    rowGramMatrix A omega i j = rowGramMatrixEntry A i j omega :=
  rfl

@[simp]
theorem sampleCovarianceEntry_apply {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (i j : Fin n) (omega : Omega) :
    sampleCovarianceEntry A i j omega =
      (1 / (m : Real)) * Finset.univ.sum
        (fun k : Fin m => A omega k i * A omega k j) :=
  rfl

@[simp]
theorem sampleCovariance_apply {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (omega : Omega) (i j : Fin n) :
    sampleCovariance A omega i j = sampleCovarianceEntry A i j omega :=
  rfl

/-- Gram-matrix entries of an `IsRandomMatrix` are real random variables. -/
theorem isRealRandomVariable_gramMatrixEntry {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {A : RandomMatrix Omega m n}
    (hA : IsRandomMatrix P A) (i j : Fin n) :
    IsRealRandomVariable P (gramMatrixEntry A i j) := by
  dsimp [IsRealRandomVariable, IsRandomVariable, gramMatrixEntry]
  exact Finset.measurable_sum _ fun k _ => (hA k i).mul (hA k j)

/-- Row-Gram entries of an `IsRandomMatrix` are real random variables. -/
theorem isRealRandomVariable_rowGramMatrixEntry {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {A : RandomMatrix Omega m n}
    (hA : IsRandomMatrix P A) (i j : Fin m) :
    IsRealRandomVariable P (rowGramMatrixEntry A i j) := by
  dsimp [IsRealRandomVariable, IsRandomVariable, rowGramMatrixEntry]
  exact Finset.measurable_sum _ fun k _ => (hA i k).mul (hA j k)

/-- Sample covariance entries of an `IsRandomMatrix` are real random variables. -/
theorem isRealRandomVariable_sampleCovarianceEntry {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {A : RandomMatrix Omega m n}
    (hA : IsRandomMatrix P A) (i j : Fin n) :
    IsRealRandomVariable P (sampleCovarianceEntry A i j) := by
  dsimp [IsRealRandomVariable, IsRandomVariable, sampleCovarianceEntry]
  exact (isRealRandomVariable_gramMatrixEntry hA i j).const_mul (1 / (m : Real))

/-- Diagonal entries of the uncentered sample covariance are nonnegative. -/
theorem sampleCovarianceEntry_diag_nonneg {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (A : RandomMatrix Omega m n) (i : Fin n) (omega : Omega) :
    0 <= sampleCovarianceEntry A i i omega := by
  dsimp [sampleCovarianceEntry, gramMatrixEntry]
  exact mul_nonneg (one_div_nonneg.mpr (Nat.cast_nonneg m))
    (Finset.sum_nonneg fun k _ => by
      simpa [pow_two] using sq_nonneg (A omega k i))

end

end HighDimProb
