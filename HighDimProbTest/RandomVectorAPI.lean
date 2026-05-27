import HighDimProb.RandomVector

open MeasureTheory
open HighDimProb

open scoped BigOperators

noncomputable section

variable {Ω : Type*} [MeasurableSpace Ω]
variable {P : Measure Ω} [IsProbabilityMeasure P]
variable {n : ℕ}
variable (X : Ω → Fin n → ℝ) (i : Fin n) (a : Fin n → ℝ)

#check RandomVector
#check IsRandomVector
#check coord
#check coordinate
#check isRealRandomVariable_coord
#check isRealRandomVariable_coordinate
#check linearForm
#check isRealRandomVariable_linearForm
#check sqNorm
#check euclideanNorm
#check isRealRandomVariable_sqNorm
#check isRealRandomVariable_euclideanNorm

example : coord X i = (fun ω => X ω i) :=
  rfl

example : coordinate X i = coord X i :=
  rfl

example (hX : IsRandomVector P X) :
    IsRealRandomVariable P (coord X i) :=
  isRealRandomVariable_coord hX i

example (hX : IsRandomVector P X) :
    IsRealRandomVariable P (coordinate X i) :=
  isRealRandomVariable_coordinate hX i

example :
    linearForm X a = (fun ω => ∑ j, a j * X ω j) :=
  rfl

example (hX : IsRandomVector P X) :
    IsRealRandomVariable P (linearForm X a) :=
  isRealRandomVariable_linearForm hX a

example :
    sqNorm X = (fun ω => ∑ j, (X ω j) ^ 2) :=
  rfl

example :
    euclideanNorm X = (fun ω => Real.sqrt (sqNorm X ω)) :=
  rfl

example (hX : IsRandomVector P X) :
    IsRealRandomVariable P (sqNorm X) :=
  isRealRandomVariable_sqNorm hX

example (hX : IsRandomVector P X) :
    IsRealRandomVariable P (euclideanNorm X) :=
  isRealRandomVariable_euclideanNorm hX

end
