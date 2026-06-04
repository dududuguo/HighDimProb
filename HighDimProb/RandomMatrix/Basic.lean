import HighDimProb.RandomVector

/-!
# Basic random matrix vocabulary
-/

namespace HighDimProb

open MeasureTheory

/-- Product measurable-space structure for finite matrices. -/
instance instMeasurableSpaceMatrix {m n alpha : Type*} [MeasurableSpace alpha] :
    MeasurableSpace (Matrix m n alpha) := by
  change MeasurableSpace (m -> n -> alpha)
  infer_instance

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

/-- Entrywise measurability gives measurability of the matrix-valued map. -/
theorem measurable_randomMatrix_of_isRandomMatrix {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {A : RandomMatrix Omega m n}
    (hA : IsRandomMatrix P A) : Measurable A := by
  change Measurable fun omega => fun i : Fin m => fun j : Fin n => A omega i j
  exact measurable_pi_lambda (fun omega i => fun j : Fin n => A omega i j) fun i =>
    measurable_pi_lambda (fun omega j => A omega i j) fun j => hA i j

end HighDimProb
