import HighDimProb.RandomMatrix.Basic

/-!
# Norm vocabulary for random matrices
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators NNReal

noncomputable section

/-- Squared Frobenius norm random variable, represented entrywise. -/
def frobeniusSq {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) : RealRandomVariable Omega :=
  fun omega => Finset.univ.sum fun i : Fin m =>
    Finset.univ.sum fun j : Fin n => (A omega i j) ^ 2

/-- Frobenius norm random variable. -/
def frobeniusNorm {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) : RealRandomVariable Omega :=
  fun omega => Real.sqrt (frobeniusSq A omega)

/-- Entrywise maximum absolute value, using `0` on empty index products. -/
def entrywiseMaxAbs {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) : RealRandomVariable Omega :=
  fun omega =>
    ((Finset.univ.product Finset.univ).sup
      (fun ij : Fin m × Fin n => nnnorm (A omega ij.1 ij.2)) : NNReal)

@[simp]
theorem frobeniusSq_apply {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (omega : Omega) :
    frobeniusSq A omega = Finset.univ.sum fun i : Fin m =>
      Finset.univ.sum fun j : Fin n => (A omega i j) ^ 2 :=
  rfl

@[simp]
theorem frobeniusNorm_apply {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (omega : Omega) :
    frobeniusNorm A omega = Real.sqrt (frobeniusSq A omega) :=
  rfl

@[simp]
theorem entrywiseMaxAbs_apply {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (omega : Omega) :
    entrywiseMaxAbs A omega =
      ((Finset.univ.product Finset.univ).sup
        (fun ij : Fin m × Fin n => nnnorm (A omega ij.1 ij.2)) : NNReal) :=
  rfl

/-- Squared Frobenius norm of an `IsRandomMatrix` is a real random variable. -/
theorem isRealRandomVariable_frobeniusSq {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {A : RandomMatrix Omega m n}
    (hA : IsRandomMatrix P A) :
    IsRealRandomVariable P (frobeniusSq A) := by
  dsimp [IsRealRandomVariable, IsRandomVariable, frobeniusSq]
  exact Finset.measurable_sum _ fun i _ =>
    Finset.measurable_sum _ fun j _ => (hA i j).pow_const 2

/-- Frobenius norm of an `IsRandomMatrix` is a real random variable. -/
theorem isRealRandomVariable_frobeniusNorm {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {A : RandomMatrix Omega m n}
    (hA : IsRandomMatrix P A) :
    IsRealRandomVariable P (frobeniusNorm A) := by
  dsimp [IsRealRandomVariable, IsRandomVariable, frobeniusNorm]
  exact (isRealRandomVariable_frobeniusSq hA).sqrt

end

end HighDimProb
