import HighDimProb.SubExponential

open MeasureTheory
open HighDimProb

open scoped ENNReal NNReal

variable {Ω : Type*} [MeasurableSpace Ω]
variable {P : Measure Ω} [IsProbabilityMeasure P]
variable (X : Ω → ℝ) (K : ℝ)

#check SubExponentialTail
#check SubExponentialMoment
#check CenteredSubExponentialMGF
#check SubExponentialOrlicz
#check HasSubExponentialOrlicz

example :
    SubExponentialTail P X K =
      (0 < K ∧
        ∀ t : ℝ, 0 ≤ t →
          absTailProb P X t ≤ ENNReal.ofReal (2 * Real.exp (-(t / K)))) :=
  rfl

example :
    SubExponentialMoment P X K =
      (0 < K ∧
        ∀ p : ENNReal, 1 ≤ p → p ≠ ∞ →
          realLpNorm P X p ≤ ENNReal.ofReal (K * ENNReal.toReal p)) :=
  rfl

example :
    CenteredSubExponentialMGF P X K =
      (0 < K ∧
        ∀ lam : ℝ, |lam| ≤ 1 / K →
          expect P (fun ω => Real.exp (lam * X ω)) ≤ Real.exp (K ^ 2 * lam ^ 2)) :=
  rfl

example : SubExponentialOrlicz P X K ↔ Psi1Bound P X K :=
  Iff.rfl

example : HasSubExponentialOrlicz P X ↔ HasFinitePsi1 P X :=
  Iff.rfl
