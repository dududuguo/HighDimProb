import HighDimProb.RandomVector
import HighDimProb.SubGaussian

/-!
# High-dimensional subGaussian random-vector predicate forms

This file defines vector-level subGaussian vocabulary through one-dimensional
linear marginals. It does not choose a canonical `SubGaussianVector` predicate
and does not prove equivalence between the directional formulations.
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators ENNReal NNReal

noncomputable section

/-- Concrete Euclidean length of a deterministic coefficient vector. -/
def directionNorm {n : ℕ} (a : Fin n → ℝ) : ℝ :=
  Real.sqrt (∑ i, (a i) ^ 2)

/-- Directional scale `K * ||a||₂` for vector subGaussian predicates. -/
def directionScale {n : ℕ} (K : ℝ) (a : Fin n → ℝ) : ℝ :=
  K * directionNorm a

/--
Directional Orlicz/`ψ₂` subGaussian vector formulation.

The zero direction is excluded because the scalar `SubGaussianOrlicz` predicate
expects a positive scale.
-/
def SubGaussianVectorOrlicz {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) (K : ℝ) : Prop :=
  0 < K ∧
    ∀ a : Fin n → ℝ, a ≠ 0 →
      SubGaussianOrlicz P (marginal X a) (directionScale K a)

/-- Finite directional Orlicz/`ψ₂` vector subGaussianity. -/
def HasSubGaussianVectorOrlicz {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) : Prop :=
  ∃ K : ℝ, SubGaussianVectorOrlicz P X K

/-- Directional tail-form subGaussian vector predicate. -/
def SubGaussianVectorTail {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) (K : ℝ) : Prop :=
  0 < K ∧
    ∀ a : Fin n → ℝ, a ≠ 0 →
      SubGaussianTail P (marginal X a) (directionScale K a)

/-- Directional moment-growth subGaussian vector predicate. -/
def SubGaussianVectorMoment {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) (K : ℝ) : Prop :=
  0 < K ∧
    ∀ a : Fin n → ℝ, a ≠ 0 →
      SubGaussianMoment P (marginal X a) (directionScale K a)

/-- Directional centered-MGF subGaussian vector predicate. -/
def CenteredSubGaussianVectorMGF {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) (K : ℝ) : Prop :=
  0 < K ∧
    ∀ a : Fin n → ℝ, a ≠ 0 →
      CenteredSubGaussianMGF P (marginal X a) (directionScale K a)

theorem subGaussianVectorOrlicz_iff {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) (K : ℝ) :
    SubGaussianVectorOrlicz P X K ↔
      0 < K ∧
        ∀ a : Fin n → ℝ, a ≠ 0 →
          SubGaussianOrlicz P (marginal X a) (directionScale K a) :=
  Iff.rfl

theorem hasSubGaussianVectorOrlicz_iff {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) :
    HasSubGaussianVectorOrlicz P X ↔
      ∃ K : ℝ, SubGaussianVectorOrlicz P X K :=
  Iff.rfl

theorem subGaussianVectorTail_iff {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) (K : ℝ) :
    SubGaussianVectorTail P X K ↔
      0 < K ∧
        ∀ a : Fin n → ℝ, a ≠ 0 →
          SubGaussianTail P (marginal X a) (directionScale K a) :=
  Iff.rfl

theorem subGaussianVectorMoment_iff {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) (K : ℝ) :
    SubGaussianVectorMoment P X K ↔
      0 < K ∧
        ∀ a : Fin n → ℝ, a ≠ 0 →
          SubGaussianMoment P (marginal X a) (directionScale K a) :=
  Iff.rfl

theorem centeredSubGaussianVectorMGF_iff {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) (K : ℝ) :
    CenteredSubGaussianVectorMGF P X K ↔
      0 < K ∧
        ∀ a : Fin n → ℝ, a ≠ 0 →
          CenteredSubGaussianMGF P (marginal X a) (directionScale K a) :=
  Iff.rfl

end

end HighDimProb
