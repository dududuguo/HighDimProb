import HighDimProb.Expectation
import HighDimProb.Orlicz
import HighDimProb.Tail

/-!
# SubExponential predicate forms

This file records separate real-valued subExponential predicate forms. It does
not define a canonical `SubExponential` predicate and does not prove equivalence
between formulations.
-/

namespace HighDimProb

open MeasureTheory

open scoped ENNReal NNReal

noncomputable section

/-- Two-sided exponential tail decay with scale `K`. -/
def SubExponentialTail {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (K : ℝ) : Prop :=
  0 < K ∧
    ∀ t : ℝ, 0 ≤ t →
      absTailProb P X t ≤ ENNReal.ofReal (2 * Real.exp (-(t / K)))

/--
Moment-growth subExponential predicate.

The exponent is kept in Mathlib's `ENNReal` form to match `realLpNorm`.
-/
def SubExponentialMoment {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (K : ℝ) : Prop :=
  0 < K ∧
    ∀ p : ENNReal, 1 ≤ p → p ≠ ∞ →
      realLpNorm P X p ≤ ENNReal.ofReal (K * ENNReal.toReal p)

/--
Centered local-MGF subExponential predicate.

Centering and integrability are not proved here; this is only the predicate
interface for later theorem work.
-/
def CenteredSubExponentialMGF {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (K : ℝ) : Prop :=
  0 < K ∧
    ∀ lam : ℝ, |lam| ≤ 1 / K →
      expect P (fun ω => Real.exp (lam * X ω)) ≤ Real.exp (K ^ 2 * lam ^ 2)

/-- The Orlicz `psi_1` formulation, exposed under subExponential vocabulary. -/
abbrev SubExponentialOrlicz {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (K : ℝ) : Prop :=
  Psi1Bound P X K

/-- Finite `psi_1` Orlicz size, exposed under subExponential vocabulary. -/
abbrev HasSubExponentialOrlicz {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) : Prop :=
  HasFinitePsi1 P X

@[simp]
theorem subExponentialOrlicz_iff {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (K : ℝ) :
    SubExponentialOrlicz P X K ↔ Psi1Bound P X K :=
  Iff.rfl

@[simp]
theorem hasSubExponentialOrlicz_iff {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) :
    HasSubExponentialOrlicz P X ↔ HasFinitePsi1 P X :=
  Iff.rfl

end

end HighDimProb
