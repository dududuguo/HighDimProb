import HighDimProb.RandomMatrix.Action

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable {m n : Nat}
variable (A : RandomMatrix Omega m n)
variable (x : Fin n -> Real)
variable (y : Fin m -> Real)
variable (hA : IsRandomMatrix P A)

#check matVec
#check vecMat
#check matVec_apply
#check vecMat_apply
#check isRandomVector_matVec
#check isRandomVector_vecMat

#check (matVec A x : RandomVector Omega m)
#check (vecMat A y : RandomVector Omega n)
#check (isRandomVector_matVec hA x : IsRandomVector P (matVec A x))
#check (isRandomVector_vecMat hA y : IsRandomVector P (vecMat A y))
