import HighDimProb.Covariance

open MeasureTheory
open HighDimProb

open scoped ProbabilityTheory

noncomputable section

variable {Ω : Type*} [MeasurableSpace Ω]
variable {P : Measure Ω} [IsProbabilityMeasure P]
variable {n : ℕ}
variable (X Y : Ω → ℝ)
variable (V : Ω → Fin n → ℝ)
variable (i j : Fin n) (ω : Ω)

#check mean
#check centered
#check Centered
#check variance
#check covariance
#check secondMoment
#check meanVector
#check centeredVector
#check CenteredVector
#check secondMomentMatrixEntry
#check secondMomentMatrix
#check covarianceMatrixEntry
#check covarianceMatrix
#check isRealRandomVariable_centered
#check isRandomVector_centeredVector

example :
    mean P X = expect P X :=
  rfl

example :
    centered P X = (fun ω => X ω - mean P X) :=
  rfl

example :
    Centered P X = (mean P X = 0) :=
  rfl

example :
    variance P X = ProbabilityTheory.variance X P :=
  rfl

example :
    covariance P X Y = ProbabilityTheory.covariance X Y P :=
  rfl

example :
    covariance P X Y = ∫ ω, (X ω - mean P X) * (Y ω - mean P Y) ∂P :=
  rfl

example :
    secondMoment P X Y = expect P (fun ω => X ω * Y ω) :=
  rfl

example (hX : IsRealRandomVariable P X) :
    IsRealRandomVariable P (centered P X) :=
  isRealRandomVariable_centered hX

example :
    meanVector P V i = mean P (coord V i) :=
  rfl

example :
    centeredVector P V ω i = V ω i - meanVector P V i :=
  rfl

example :
    CenteredVector P V = (∀ i : Fin n, Centered P (coord V i)) :=
  rfl

example :
    secondMomentMatrixEntry P V i j = secondMoment P (coord V i) (coord V j) :=
  rfl

example :
    secondMomentMatrix P V i j = secondMoment P (coord V i) (coord V j) :=
  rfl

example :
    covarianceMatrixEntry P V i j = covariance P (coord V i) (coord V j) :=
  rfl

example :
    covarianceMatrix P V i j = covariance P (coord V i) (coord V j) :=
  rfl

example (hV : IsRandomVector P V) :
    IsRandomVector P (centeredVector P V) :=
  isRandomVector_centeredVector hV

end
