import HighDimProb.RandomMatrix.SampleCovariance
import HighDimProb.RandomMatrix.QuadraticForm

/-!
# Algebraic bridges for random matrices

Verified Wikipedia references:
* Dot product: https://en.wikipedia.org/wiki/Dot_product
* Quadratic form: https://en.wikipedia.org/wiki/Quadratic_form
* Sample mean and covariance: https://en.wikipedia.org/wiki/Sample_mean_and_covariance
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators

noncomputable section

/-- Dot product of one random-matrix row with a deterministic vector. -/
def rowDot {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (x : Fin n -> Real) (k : Fin m)
    (omega : Omega) : Real :=
  Finset.univ.sum fun i : Fin n => A omega k i * x i

@[simp]
theorem rowDot_apply {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (x : Fin n -> Real) (k : Fin m)
    (omega : Omega) :
    rowDot A x k omega = Finset.univ.sum fun i : Fin n => A omega k i * x i :=
  rfl

/-- A squared row marginal is nonnegative. -/
theorem rowDot_sq_nonneg {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (x : Fin n -> Real) (k : Fin m)
    (omega : Omega) :
    0 <= (rowDot A x k omega) ^ 2 :=
  sq_nonneg _

/-- A finite sum of squared row marginals is nonnegative. -/
theorem sum_rowDot_sq_nonneg {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (x : Fin n -> Real) (omega : Omega) :
    0 <= Finset.univ.sum fun k : Fin m => (rowDot A x k omega) ^ 2 :=
  Finset.sum_nonneg fun k _ => rowDot_sq_nonneg A x k omega

private theorem sum_sum_mul_eq_sq {n : Nat} (u : Fin n -> Real) :
    (Finset.univ.sum fun i : Fin n =>
      Finset.univ.sum fun j : Fin n => u i * u j) =
      (Finset.univ.sum fun i : Fin n => u i) ^ 2 := by
  rw [pow_two, Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro i _
  rw [Finset.mul_sum]

private theorem sum_sum_const_mul_eq_mul_sum_sq {n : Nat} (c : Real)
    (u : Fin n -> Real) :
    (Finset.univ.sum fun i : Fin n =>
      Finset.univ.sum fun j : Fin n => c * (u i * u j)) =
      c * (Finset.univ.sum fun i : Fin n => u i) ^ 2 := by
  calc
    (Finset.univ.sum fun i : Fin n =>
      Finset.univ.sum fun j : Fin n => c * (u i * u j))
        = Finset.univ.sum fun i : Fin n =>
            c * (Finset.univ.sum fun j : Fin n => u i * u j) := by
          apply Finset.sum_congr rfl
          intro i _
          rw [Finset.mul_sum]
    _ = c * (Finset.univ.sum fun i : Fin n =>
          Finset.univ.sum fun j : Fin n => u i * u j) := by
          rw [Finset.mul_sum]
    _ = c * (Finset.univ.sum fun i : Fin n => u i) ^ 2 := by
          rw [sum_sum_mul_eq_sq]

/--
Finite-sum algebra bridge for the uncentered sample covariance quadratic form.

The normal form keeps the row marginal explicit:
`sum k, (sum i, A omega k i * x i)^2`.
-/
theorem quadraticForm_sampleCovariance_eq_sum_sq {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (A : RandomMatrix Omega m n) (x : Fin n -> Real) (omega : Omega) :
    quadraticForm (sampleCovariance A) x omega =
      (1 / (m : Real)) * Finset.univ.sum
        (fun k : Fin m => (Finset.univ.sum fun i : Fin n => A omega k i * x i) ^ 2) := by
  calc
    quadraticForm (sampleCovariance A) x omega
        = Finset.univ.sum fun i : Fin n =>
            Finset.univ.sum fun j : Fin n =>
              x i * ((1 / (m : Real)) * Finset.univ.sum
                (fun k : Fin m => A omega k i * A omega k j)) * x j := by
          simp only [quadraticForm, sampleCovariance, sampleCovarianceEntry, gramMatrixEntry]
    _ = Finset.univ.sum fun i : Fin n =>
          Finset.univ.sum fun j : Fin n =>
            Finset.univ.sum fun k : Fin m =>
              (1 / (m : Real)) * ((A omega k i * x i) * (A omega k j * x j)) := by
          apply Finset.sum_congr rfl
          intro i _
          apply Finset.sum_congr rfl
          intro j _
          simp_rw [Finset.mul_sum, Finset.sum_mul]
          apply Finset.sum_congr rfl
          intro k _
          ring
    _ = Finset.univ.sum fun k : Fin m =>
          Finset.univ.sum fun i : Fin n =>
            Finset.univ.sum fun j : Fin n =>
              (1 / (m : Real)) * ((A omega k i * x i) * (A omega k j * x j)) := by
          calc
            (Finset.univ.sum fun i : Fin n =>
              Finset.univ.sum fun j : Fin n =>
                Finset.univ.sum fun k : Fin m =>
                  (1 / (m : Real)) * ((A omega k i * x i) * (A omega k j * x j)))
                = Finset.univ.sum fun i : Fin n =>
                    Finset.univ.sum fun k : Fin m =>
                      Finset.univ.sum fun j : Fin n =>
                        (1 / (m : Real)) * ((A omega k i * x i) * (A omega k j * x j)) := by
                  apply Finset.sum_congr rfl
                  intro i _
                  rw [Finset.sum_comm]
            _ = Finset.univ.sum fun k : Fin m =>
                  Finset.univ.sum fun i : Fin n =>
                    Finset.univ.sum fun j : Fin n =>
                      (1 / (m : Real)) * ((A omega k i * x i) * (A omega k j * x j)) := by
                  rw [Finset.sum_comm]
    _ = Finset.univ.sum fun k : Fin m =>
          (1 / (m : Real)) *
            (Finset.univ.sum fun i : Fin n => A omega k i * x i) ^ 2 := by
          apply Finset.sum_congr rfl
          intro k _
          exact sum_sum_const_mul_eq_mul_sum_sq (1 / (m : Real))
            (fun i : Fin n => A omega k i * x i)
    _ = (1 / (m : Real)) * Finset.univ.sum
          (fun k : Fin m => (Finset.univ.sum fun i : Fin n => A omega k i * x i) ^ 2) := by
          rw [Finset.mul_sum]

/-- Row-dot normal form for the uncentered sample covariance quadratic form. -/
theorem quadraticForm_sampleCovariance_eq_scaled_sum_rowDot_sq
    {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (x : Fin n -> Real) (omega : Omega) :
    quadraticForm (sampleCovariance A) x omega =
      (1 / (m : Real)) *
        Finset.univ.sum (fun k : Fin m => (rowDot A x k omega) ^ 2) := by
  simpa [rowDot] using quadraticForm_sampleCovariance_eq_sum_sq A x omega

/-- The uncentered sample covariance quadratic form is pointwise nonnegative. -/
theorem quadraticForm_sampleCovariance_nonneg {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (A : RandomMatrix Omega m n) (x : Fin n -> Real) (omega : Omega) :
    0 <= quadraticForm (sampleCovariance A) x omega := by
  rw [quadraticForm_sampleCovariance_eq_scaled_sum_rowDot_sq]
  exact mul_nonneg (one_div_nonneg.mpr (Nat.cast_nonneg m))
    (sum_rowDot_sq_nonneg A x omega)

end

end HighDimProb
