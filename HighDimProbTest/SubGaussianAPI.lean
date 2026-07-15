import HighDimProb.SubGaussian

open MeasureTheory
open HighDimProb

open scoped ENNReal NNReal

variable {Ω : Type*} [MeasurableSpace Ω]
variable {P : Measure Ω} [IsProbabilityMeasure P]
variable (X : Ω → ℝ) (K : ℝ)

#check SubGaussianTail
#check SubGaussianMoment
#check CenteredSubGaussianMGF
#check CenteredSubGaussianMGF.neg
#check SubGaussianOrlicz
#check HasSubGaussianOrlicz

example {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    {X : RealRandomVariable Ω} {K : ℝ}
    (h : CenteredSubGaussianMGF P X K) :
    CenteredSubGaussianMGF P (-X) K :=
  h.neg

example :
    SubGaussianTail P X K =
      (0 < K ∧
        ∀ t : ℝ, 0 ≤ t →
          absTailProb P X t ≤ ENNReal.ofReal (2 * Real.exp (-(t ^ 2 / K ^ 2)))) :=
  rfl

example :
    SubGaussianMoment P X K =
      (0 < K ∧
        ∀ p : ENNReal, 1 ≤ p → p ≠ ∞ →
          realLpNorm P X p ≤ ENNReal.ofReal (K * Real.sqrt (ENNReal.toReal p))) :=
  rfl

example :
    CenteredSubGaussianMGF P X K =
      (0 < K ∧
        ProbabilityTheory.HasSubgaussianMGF X (⟨K ^ 2, sq_nonneg K⟩ : ℝ≥0) P) :=
  rfl

example : SubGaussianOrlicz P X K ↔ Psi2Bound P X K :=
  Iff.rfl

example : HasSubGaussianOrlicz P X ↔ HasFinitePsi2 P X :=
  Iff.rfl
