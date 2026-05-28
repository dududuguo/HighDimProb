import HighDimProb.RandomMatrix.OperatorNorm

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable {m n : Nat}
variable (A : RandomMatrix Omega m n)

#check operatorNorm
#check operatorNorm_apply

#check (operatorNorm A : RealRandomVariable Omega)
