import HighDimProb.Orlicz
import HighDimProb.Tail

/-!
# SubGaussian predicate forms

This file names the standard real-valued subGaussian formulations separately.
It does not choose a canonical `SubGaussian` predicate and does not prove
equivalence between formulations.
-/

namespace HighDimProb

open MeasureTheory

open scoped ENNReal NNReal

noncomputable section

/-- Two-sided subGaussian tail bound with scale `K`. -/
def SubGaussianTail {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (K : ℝ) : Prop :=
  0 < K ∧
    ∀ t : ℝ, 0 ≤ t →
      absTailProb P X t ≤ ENNReal.ofReal (2 * Real.exp (-(t ^ 2 / K ^ 2)))

/--
SubGaussian moment-growth formulation with Mathlib's `ENNReal` exponent type.

The condition is stated only for finite `p` with `1 ≤ p`; it is a predicate
interface, not a theorem relating moments to tails or Orlicz bounds.
-/
def SubGaussianMoment {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (K : ℝ) : Prop :=
  0 < K ∧
    ∀ p : ENNReal, 1 ≤ p → p ≠ ∞ →
      realLpNorm P X p ≤ ENNReal.ofReal (K * Real.sqrt (ENNReal.toReal p))

/--
Centered MGF-style subGaussian formulation with scale `K`.

This wraps Mathlib's `ProbabilityTheory.HasSubgaussianMGF`, which includes the
required exponential integrability assumptions. Centering is not proved here.
-/
def CenteredSubGaussianMGF {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (K : ℝ) : Prop :=
  0 < K ∧ ProbabilityTheory.HasSubgaussianMGF X (⟨K ^ 2, sq_nonneg K⟩ : ℝ≥0) P

/-- Orlicz `ψ₂` formulation, as a thin wrapper around `Psi2Bound`. -/
abbrev SubGaussianOrlicz {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (K : ℝ) : Prop :=
  Psi2Bound P X K

/-- Finite Orlicz `ψ₂` formulation, as a thin wrapper around `HasFinitePsi2`. -/
abbrev HasSubGaussianOrlicz {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) : Prop :=
  HasFinitePsi2 P X

@[simp]
theorem subGaussianOrlicz_iff {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (K : ℝ) :
    SubGaussianOrlicz P X K ↔ Psi2Bound P X K :=
  Iff.rfl

@[simp]
theorem hasSubGaussianOrlicz_iff {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) :
    HasSubGaussianOrlicz P X ↔ HasFinitePsi2 P X :=
  Iff.rfl

end

end HighDimProb
