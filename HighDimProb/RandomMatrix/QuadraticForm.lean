import HighDimProb.RandomMatrix.Basic

/-!
# Quadratic and bilinear form vocabulary for random matrices
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators

noncomputable section

/-- Quadratic form `omega |-> x^T A(omega) x`, represented by an explicit double sum. -/
def quadraticForm {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega n n) (x : Fin n -> Real) : RealRandomVariable Omega :=
  fun omega => Finset.univ.sum fun i : Fin n =>
    Finset.univ.sum fun j : Fin n => x i * A omega i j * x j

/-- Bilinear form `omega |-> x^T A(omega) y`, represented by an explicit double sum. -/
def bilinearForm {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (x : Fin m -> Real) (y : Fin n -> Real) :
    RealRandomVariable Omega :=
  fun omega => Finset.univ.sum fun i : Fin m =>
    Finset.univ.sum fun j : Fin n => x i * A omega i j * y j

@[simp]
theorem quadraticForm_apply {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega n n) (x : Fin n -> Real) (omega : Omega) :
    quadraticForm A x omega =
      Finset.univ.sum fun i : Fin n =>
        Finset.univ.sum fun j : Fin n => x i * A omega i j * x j :=
  rfl

@[simp]
theorem bilinearForm_apply {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (x : Fin m -> Real) (y : Fin n -> Real)
    (omega : Omega) :
    bilinearForm A x y omega =
      Finset.univ.sum fun i : Fin m =>
        Finset.univ.sum fun j : Fin n => x i * A omega i j * y j :=
  rfl

/-- Quadratic forms of an `IsRandomMatrix` are real random variables. -/
theorem isRealRandomVariable_quadraticForm {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} {A : RandomMatrix Omega n n}
    (hA : IsRandomMatrix P A) (x : Fin n -> Real) :
    IsRealRandomVariable P (quadraticForm A x) := by
  dsimp [IsRealRandomVariable, IsRandomVariable, quadraticForm]
  exact Finset.measurable_sum _ fun i _ =>
    Finset.measurable_sum _ fun j _ => ((hA i j).const_mul (x i)).mul_const (x j)

/-- Bilinear forms of an `IsRandomMatrix` are real random variables. -/
theorem isRealRandomVariable_bilinearForm {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {A : RandomMatrix Omega m n}
    (hA : IsRandomMatrix P A) (x : Fin m -> Real) (y : Fin n -> Real) :
    IsRealRandomVariable P (bilinearForm A x y) := by
  dsimp [IsRealRandomVariable, IsRandomVariable, bilinearForm]
  exact Finset.measurable_sum _ fun i _ =>
    Finset.measurable_sum _ fun j _ => ((hA i j).const_mul (x i)).mul_const (y j)

end

end HighDimProb
