import HighDimProb.RandomVector

/-!
# Basic random matrix vocabulary

Verified Wikipedia reference:
* Random matrix: https://en.wikipedia.org/wiki/Random_matrix
-/

namespace HighDimProb

open MeasureTheory

/--
Product measurable-space structure for finite matrices.

Formula reference: a random matrix is a matrix-valued random object; the
product measurable-space instance supplies the measurable side of that
vocabulary. See
https://en.wikipedia.org/wiki/Random_matrix
-/
instance instMeasurableSpaceMatrix {m n alpha : Type*} [MeasurableSpace alpha] :
    MeasurableSpace (Matrix m n alpha) := by
  change MeasurableSpace (m -> n -> alpha)
  infer_instance

/--
An `m x n` real random matrix with concrete finite dimensions.

Formula reference: this is the Lean type for a finite-dimensional random
matrix; see https://en.wikipedia.org/wiki/Random_matrix
-/
abbrev RandomMatrix (Omega : Type*) [MeasurableSpace Omega] (m n : Nat) :=
  Omega -> Matrix (Fin m) (Fin n) Real

/--
Entry random variable of a random matrix.

Formula reference: matrix-valued randomness is checked entrywise here; see
https://en.wikipedia.org/wiki/Random_matrix
-/
def matrixEntry {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (i : Fin m) (j : Fin n) : RealRandomVariable Omega :=
  fun omega => A omega i j

/--
Entrywise measurability predicate for random matrices.

Formula reference: this predicate records that each matrix entry is a real
random variable, matching the entrywise view of a random matrix; see
https://en.wikipedia.org/wiki/Random_matrix
-/
abbrev IsRandomMatrix {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) : Prop :=
  forall i : Fin m, forall j : Fin n, IsRealRandomVariable P (matrixEntry A i j)

/--
Formula reference: this unfolds the entry random variable `A_ij`; see
https://en.wikipedia.org/wiki/Random_matrix
-/
@[simp]
theorem matrixEntry_apply {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (i : Fin m) (j : Fin n) (omega : Omega) :
    matrixEntry A i j omega = A omega i j :=
  rfl

/--
Entries of an `IsRandomMatrix` are real random variables.

Formula reference: entrywise random-variable structure is the finite-matrix
specialization of random matrices; see
https://en.wikipedia.org/wiki/Random_matrix
-/
theorem isRealRandomVariable_matrixEntry {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {A : RandomMatrix Omega m n}
    (hA : IsRandomMatrix P A) (i : Fin m) (j : Fin n) :
    IsRealRandomVariable P (matrixEntry A i j) :=
  hA i j

/--
Entrywise measurability gives measurability of the matrix-valued map.

Formula reference: this upgrades entrywise measurable random variables to a
matrix-valued random object; see
https://en.wikipedia.org/wiki/Random_matrix
-/
theorem measurable_randomMatrix_of_isRandomMatrix {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {A : RandomMatrix Omega m n}
    (hA : IsRandomMatrix P A) : Measurable A := by
  change Measurable fun omega => fun i : Fin m => fun j : Fin n => A omega i j
  exact measurable_pi_lambda (fun omega i => fun j : Fin n => A omega i j) fun i =>
    measurable_pi_lambda (fun omega j => A omega i j) fun j => hA i j

end HighDimProb
