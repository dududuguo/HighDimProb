import HighDimProb.Covariance

open MeasureTheory
open HighDimProb

noncomputable section

variable {Ω : Type*} [MeasurableSpace Ω]
variable {n : ℕ}
variable (P : Measure Ω)
variable (X : RandomVector Ω n)

#check centeredVector_iff_forall_centered_coord
#check centered_centered
#check integrable_centered
#check variance_nonneg
#check variance_centered_eq_variance
#check (centeredVector_iff_forall_centered_coord P X :
  CenteredVector P X ↔ ∀ i : Fin n, Centered P (coord X i))

end
