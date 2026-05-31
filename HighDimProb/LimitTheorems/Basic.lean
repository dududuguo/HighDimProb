import HighDimProb.Scalar

/-!
# Basic vocabulary for limit theorems

This module contains finite-sample scalar vocabulary used by weak-law
statements. It intentionally avoids independence and asymptotic theorem proofs.
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators

noncomputable section

/-- Finite sample sum indexed by `Fin n`. -/
def sampleSum {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (X : Fin n -> RealRandomVariable Omega) : RealRandomVariable Omega :=
  fun omega => Finset.univ.sum fun i : Fin n => X i omega

/-- Finite sample mean indexed by `Fin n`, using Lean's total division when `n = 0`. -/
def sampleMean {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (X : Fin n -> RealRandomVariable Omega) : RealRandomVariable Omega :=
  fun omega => (1 / (n : Real)) * Finset.univ.sum fun i : Fin n => X i omega

/-- Sample mean centered around a specified scalar `mu`. -/
def sampleMeanCentered {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (X : Fin n -> RealRandomVariable Omega) (mu : Real) : RealRandomVariable Omega :=
  fun omega => sampleMean X omega - mu

@[simp]
theorem sampleSum_apply {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (X : Fin n -> RealRandomVariable Omega) (omega : Omega) :
    sampleSum X omega = Finset.univ.sum fun i : Fin n => X i omega :=
  rfl

@[simp]
theorem sampleMean_apply {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (X : Fin n -> RealRandomVariable Omega) (omega : Omega) :
    sampleMean X omega =
      (1 / (n : Real)) * Finset.univ.sum fun i : Fin n => X i omega :=
  rfl

@[simp]
theorem sampleMeanCentered_apply {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (X : Fin n -> RealRandomVariable Omega) (mu : Real) (omega : Omega) :
    sampleMeanCentered X mu omega = sampleMean X omega - mu :=
  rfl

/-- A finite sample sum of real random variables is a real random variable. -/
theorem isRealRandomVariable_sampleSum {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} {X : Fin n -> RealRandomVariable Omega}
    (hX : forall i : Fin n, IsRealRandomVariable P (X i)) :
    IsRealRandomVariable P (sampleSum X) := by
  dsimp [IsRealRandomVariable, IsRandomVariable, sampleSum]
  exact Finset.measurable_sum _ fun i _ => hX i

/-- A finite sample mean of real random variables is a real random variable. -/
theorem isRealRandomVariable_sampleMean {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} {X : Fin n -> RealRandomVariable Omega}
    (hX : forall i : Fin n, IsRealRandomVariable P (X i)) :
    IsRealRandomVariable P (sampleMean X) := by
  dsimp [IsRealRandomVariable, IsRandomVariable, sampleMean]
  exact (Finset.measurable_sum _ fun i _ => hX i).const_mul _

/-- A sample mean centered around a scalar is a real random variable. -/
theorem isRealRandomVariable_sampleMeanCentered {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} {X : Fin n -> RealRandomVariable Omega} {mu : Real}
    (hX : forall i : Fin n, IsRealRandomVariable P (X i)) :
    IsRealRandomVariable P (sampleMeanCentered X mu) := by
  dsimp [IsRealRandomVariable, IsRandomVariable, sampleMeanCentered]
  exact (isRealRandomVariable_sampleMean (P := P) (X := X) hX).sub measurable_const

/-- A finite sample sum of integrable real random variables is integrable. -/
theorem integrable_sampleSum {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} {X : Fin n -> RealRandomVariable Omega}
    (hX : forall i : Fin n, IntegrableRealRandomVariable P (X i)) :
    IntegrableRealRandomVariable P (sampleSum X) := by
  dsimp [IntegrableRealRandomVariable, IntegrableRandomVariable, sampleSum]
  exact integrable_finset_sum Finset.univ fun i _ => hX i

/-- A finite sample mean of integrable real random variables is integrable. -/
theorem integrable_sampleMean {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} {X : Fin n -> RealRandomVariable Omega}
    (hX : forall i : Fin n, IntegrableRealRandomVariable P (X i)) :
    IntegrableRealRandomVariable P (sampleMean X) := by
  dsimp [IntegrableRealRandomVariable, IntegrableRandomVariable, sampleMean]
  exact (integrable_finset_sum Finset.univ fun i _ => hX i).const_mul _

/-- Centering a finite sample mean around a scalar preserves integrability over finite measures. -/
theorem integrable_sampleMeanCentered {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsFiniteMeasure P] {n : Nat}
    {X : Fin n -> RealRandomVariable Omega} {mu : Real}
    (hX : forall i : Fin n, IntegrableRealRandomVariable P (X i)) :
    IntegrableRealRandomVariable P (sampleMeanCentered X mu) := by
  dsimp [IntegrableRealRandomVariable, IntegrableRandomVariable, sampleMeanCentered]
  exact (integrable_sampleMean (P := P) (X := X) hX).sub (integrable_const mu)

end

end HighDimProb
