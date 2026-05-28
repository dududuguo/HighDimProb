import HighDimProb.Isotropic

open MeasureTheory
open HighDimProb

noncomputable section

variable {Ω : Type*} [MeasurableSpace Ω]
variable {n : ℕ}
variable (P : Measure Ω)
variable (X : RandomVector Ω n)

#check isotropicSecondMomentMatrix_iff_isotropicSecondMoment
#check (isotropicSecondMomentMatrix_iff_isotropicSecondMoment P X :
  IsotropicSecondMomentMatrix P X ↔ IsotropicSecondMoment P X)

end
