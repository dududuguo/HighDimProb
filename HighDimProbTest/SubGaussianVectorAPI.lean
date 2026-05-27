import HighDimProb.SubGaussianVector

open MeasureTheory
open HighDimProb

open scoped BigOperators

noncomputable section

variable {Ω : Type*} [MeasurableSpace Ω]
variable {P : Measure Ω} [IsProbabilityMeasure P]
variable {n : ℕ}
variable (X : RandomVector Ω n)
variable (a : Fin n → ℝ)
variable (K : ℝ)

#check marginal
#check isRealRandomVariable_marginal
#check directionNorm
#check directionScale
#check SubGaussianVectorOrlicz
#check HasSubGaussianVectorOrlicz
#check SubGaussianVectorTail
#check SubGaussianVectorMoment
#check CenteredSubGaussianVectorMGF

example :
    marginal X a = linearForm X a :=
  rfl

example :
    directionNorm a = Real.sqrt (∑ i, (a i) ^ 2) :=
  rfl

example :
    directionScale K a = K * directionNorm a :=
  rfl

example :
    SubGaussianVectorOrlicz P X K =
      (0 < K ∧
        ∀ a : Fin n → ℝ, a ≠ 0 →
          SubGaussianOrlicz P (marginal X a) (directionScale K a)) :=
  rfl

example :
    HasSubGaussianVectorOrlicz P X =
      (∃ K : ℝ, SubGaussianVectorOrlicz P X K) :=
  rfl

example :
    SubGaussianVectorTail P X K =
      (0 < K ∧
        ∀ a : Fin n → ℝ, a ≠ 0 →
          SubGaussianTail P (marginal X a) (directionScale K a)) :=
  rfl

example :
    SubGaussianVectorMoment P X K =
      (0 < K ∧
        ∀ a : Fin n → ℝ, a ≠ 0 →
          SubGaussianMoment P (marginal X a) (directionScale K a)) :=
  rfl

example :
    CenteredSubGaussianVectorMGF P X K =
      (0 < K ∧
        ∀ a : Fin n → ℝ, a ≠ 0 →
          CenteredSubGaussianMGF P (marginal X a) (directionScale K a)) :=
  rfl

example (hX : IsRandomVector P X) :
    IsRealRandomVariable P (marginal X a) :=
  isRealRandomVariable_marginal hX a

end
