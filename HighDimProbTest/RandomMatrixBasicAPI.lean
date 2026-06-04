import HighDimProb.RandomMatrix.Basic

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable {m n : Nat}
variable (A : RandomMatrix Omega m n)
variable (i : Fin m) (j : Fin n)
variable (hA : IsRandomMatrix P A)

#check RandomMatrix
#check matrixEntry
#check IsRandomMatrix
#check matrixEntry_apply
#check isRealRandomVariable_matrixEntry
#check instMeasurableSpaceMatrix
#check measurable_randomMatrix_of_isRandomMatrix

#check (matrixEntry A i j : RealRandomVariable Omega)
#check (isRealRandomVariable_matrixEntry hA i j :
  IsRealRandomVariable P (matrixEntry A i j))
#check (measurable_randomMatrix_of_isRandomMatrix hA : Measurable A)
