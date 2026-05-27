import HighDimProb.Orlicz

open MeasureTheory
open HighDimProb

variable {Ω : Type*} [MeasurableSpace Ω]
variable {P : Measure Ω} [IsProbabilityMeasure P]
variable (ψ : OrliczFunction) (X : Ω → ℝ) (K : ℝ)

#check OrliczFunction
#check psiPower
#check psi1Function
#check psi2Function
#check OrliczBound
#check Psi2Bound
#check Psi1Bound
#check HasFinitePsi2
#check HasFinitePsi1

example :
    OrliczBound P ψ X K =
      (0 < K ∧
        (∫⁻ ω, ENNReal.ofReal (ψ (|X ω| / K)) ∂P) ≤ (1 : ENNReal)) :=
  rfl

example :
    Psi2Bound P X K =
      (0 < K ∧
        (∫⁻ ω, ENNReal.ofReal (Real.exp ((|X ω| / K) ^ 2) - 1) ∂P)
          ≤ (1 : ENNReal)) :=
  rfl

example :
    Psi1Bound P X K =
      (0 < K ∧
        (∫⁻ ω, ENNReal.ofReal (Real.exp (|X ω| / K) - 1) ∂P) ≤ (1 : ENNReal)) :=
  rfl

example : HasFinitePsi2 P X ↔ ∃ K : ℝ, Psi2Bound P X K :=
  Iff.rfl

example : HasFinitePsi1 P X ↔ ∃ K : ℝ, Psi1Bound P X K :=
  Iff.rfl
