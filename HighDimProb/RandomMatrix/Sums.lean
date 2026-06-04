import HighDimProb.RandomMatrix.SelfAdjoint

/-!
# Finite sums of random matrices

This leaf keeps finite matrix sums as explicit pointwise sums over `Finset.univ`.
It is separate from concentration statements so later matrix Bernstein
infrastructure can reuse the sum vocabulary without importing tail statements.
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators

noncomputable section

/-- Pointwise sum of a finite family of random matrices. -/
def randomMatrixSum {Omega : Type*} [MeasurableSpace Omega] {I : Type*}
    [Fintype I] {m n : Nat} (A : I -> RandomMatrix Omega m n) :
    RandomMatrix Omega m n :=
  fun omega => Finset.univ.sum fun i : I => A i omega

@[simp]
theorem randomMatrixSum_apply {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} [Fintype I] {m n : Nat}
    (A : I -> RandomMatrix Omega m n) (omega : Omega) :
    randomMatrixSum A omega = Finset.univ.sum fun i : I => A i omega :=
  rfl

@[simp]
theorem randomMatrixSum_entry {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} [Fintype I] {m n : Nat}
    (A : I -> RandomMatrix Omega m n) (omega : Omega)
    (r : Fin m) (c : Fin n) :
    randomMatrixSum A omega r c = Finset.univ.sum fun i : I => A i omega r c := by
  simpa [randomMatrixSum] using
    Matrix.sum_apply r c Finset.univ (fun i : I => A i omega)

/-- Finite sums of matrix-valued random variables are matrix-valued random variables. -/
theorem isRandomMatrix_sum {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {I : Type*} [Fintype I] {m n : Nat}
    {A : I -> RandomMatrix Omega m n}
    (hA : forall i, IsRandomMatrix P (A i)) :
    IsRandomMatrix P (randomMatrixSum A) := by
  intro r c
  dsimp [IsRealRandomVariable, IsRandomVariable, matrixEntry]
  change Measurable fun omega => randomMatrixSum A omega r c
  simpa [Matrix.sum_apply] using
    Finset.measurable_sum Finset.univ fun i _ => hA i r c

/-- A finite sum of self-adjoint deterministic matrices is self-adjoint. -/
theorem isSelfAdjointMatrix_sum {I : Type*} [Fintype I] {n : Nat}
    {A : I -> Matrix (Fin n) (Fin n) Real}
    (hA : forall i, IsSelfAdjointMatrix (A i)) :
    IsSelfAdjointMatrix (Finset.univ.sum fun i : I => A i) := by
  apply Matrix.IsHermitian.ext
  intro r c
  calc
    star ((Finset.univ.sum fun i : I => A i) c r)
        = Finset.univ.sum fun i : I => star (A i c r) := by
          rw [Matrix.sum_apply]
          simp
    _ = Finset.univ.sum fun i : I => A i r c := by
          exact Finset.sum_congr rfl fun i _ => Matrix.IsHermitian.apply (hA i) r c
    _ = (Finset.univ.sum fun i : I => A i) r c := by
          rw [Matrix.sum_apply]

/-- A finite pointwise sum of self-adjoint random matrices is self-adjoint. -/
theorem randomSelfAdjointMatrix_sum {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {I : Type*} [Fintype I] {n : Nat}
    {A : I -> RandomMatrix Omega n n}
    (hA : forall i, RandomSelfAdjointMatrix P (A i)) :
    RandomSelfAdjointMatrix P (randomMatrixSum A) := by
  intro omega
  exact isSelfAdjointMatrix_sum fun i => hA i omega

end

end HighDimProb
