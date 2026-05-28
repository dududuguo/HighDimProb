import HighDimProb.RandomMatrix.RowsCols

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable {m n : Nat}
variable (A : RandomMatrix Omega m n)
variable (i : Fin m) (j : Fin n)
variable (hA : IsRandomMatrix P A)

#check rowVector
#check colVector
#check rowVector_apply
#check colVector_apply
#check coord_rowVector
#check coord_colVector
#check isRandomVector_rowVector
#check isRandomVector_colVector

#check (rowVector A i : RandomVector Omega n)
#check (colVector A j : RandomVector Omega m)
#check (isRandomVector_rowVector hA i : IsRandomVector P (rowVector A i))
#check (isRandomVector_colVector hA j : IsRandomVector P (colVector A j))
