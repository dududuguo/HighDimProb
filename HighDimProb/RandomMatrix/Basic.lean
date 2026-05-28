import HighDimProb.RandomVector

/-!
# Basic random matrix vocabulary
-/

namespace HighDimProb

open MeasureTheory

/-- An `m x n` real random matrix with concrete finite dimensions. -/
abbrev RandomMatrix (Omega : Type*) [MeasurableSpace Omega] (m n : Nat) :=
  Omega -> Matrix (Fin m) (Fin n) Real

/-- Entry random variable of a random matrix. -/
def matrixEntry {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (i : Fin m) (j : Fin n) : RealRandomVariable Omega :=
  fun omega => A omega i j

/-- Entrywise measurability predicate for random matrices. -/
abbrev IsRandomMatrix {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) : Prop :=
  forall i : Fin m, forall j : Fin n, IsRealRandomVariable P (matrixEntry A i j)

@[simp]
theorem matrixEntry_apply {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (i : Fin m) (j : Fin n) (omega : Omega) :
    matrixEntry A i j omega = A omega i j :=
  rfl

/-- Entries of an `IsRandomMatrix` are real random variables. -/
theorem isRealRandomVariable_matrixEntry {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {A : RandomMatrix Omega m n}
    (hA : IsRandomMatrix P A) (i : Fin m) (j : Fin n) :
    IsRealRandomVariable P (matrixEntry A i j) :=
  hA i j

end HighDimProb
