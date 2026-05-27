import HighDimProb.Isotropic

open MeasureTheory
open HighDimProb

open scoped BigOperators

noncomputable section

variable {Ω : Type*} [MeasurableSpace Ω]
variable {P : Measure Ω} [IsProbabilityMeasure P]
variable {n : ℕ}
variable (X : Ω → Fin n → ℝ)

#check IsotropicSecondMoment
#check IsotropicSecondMomentMatrix
#check IsotropicCovariance
#check IsotropicMarginal
#check IsIsotropic
#check isotropicSecondMoment_iff
#check isotropicSecondMomentMatrix_iff
#check isotropicCovariance_iff
#check isotropicMarginal_iff
#check isIsotropic_iff_isotropicCovariance

example :
    IsotropicSecondMoment P X =
      (∀ i j : Fin n, secondMomentMatrixEntry P X i j = if i = j then 1 else 0) :=
  rfl

example :
    IsotropicSecondMomentMatrix P X = (secondMomentMatrix P X = 1) :=
  rfl

example :
    IsotropicCovariance P X =
      (CenteredVector P X ∧
        ∀ i j : Fin n, covarianceMatrixEntry P X i j = if i = j then 1 else 0) :=
  rfl

example :
    IsotropicMarginal P X =
      (∀ a : Fin n → ℝ,
        secondMoment P (linearForm X a) (linearForm X a) = ∑ i, a i ^ 2) :=
  rfl

example :
    IsIsotropic P X ↔ IsotropicCovariance P X :=
  Iff.rfl

end
