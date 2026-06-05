import HighDimProb.Expectation
import HighDimProb.Lp
import HighDimProb.RandomMatrix.Basic

/-!
# Entrywise matrix expectation vocabulary

Matrix-valued expectations are represented entrywise. This avoids committing to
a Bochner-integral API for matrix-valued random variables before the matrix
concentration proof layer needs it.
-/

namespace HighDimProb

open MeasureTheory

noncomputable section

/-- Entrywise expectation of a random matrix. -/
def matrixExpect {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) :
    Matrix (Fin m) (Fin n) Real :=
  fun i j => expect P (matrixEntry A i j)

/-- Entrywise integrability predicate for random matrices. -/
def IntegrableRandomMatrix {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) : Prop :=
  forall i : Fin m, forall j : Fin n,
    IntegrableRealRandomVariable P (matrixEntry A i j)

@[simp]
theorem matrixExpect_apply {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) (i : Fin m) (j : Fin n) :
    matrixExpect P A i j = expect P (matrixEntry A i j) :=
  rfl

/-- Entrywise centered random matrix `A - E A`. -/
def centeredRandomMatrix {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) :
    RandomMatrix Omega m n :=
  fun omega i j => A omega i j - matrixExpect P A i j

@[simp]
theorem centeredRandomMatrix_apply {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (P : Measure Omega) (A : RandomMatrix Omega m n)
    (omega : Omega) (i : Fin m) (j : Fin n) :
    centeredRandomMatrix P A omega i j = A omega i j - matrixExpect P A i j :=
  rfl

end

end HighDimProb
