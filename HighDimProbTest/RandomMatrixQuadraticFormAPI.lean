import HighDimProb.RandomMatrix.QuadraticForm

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable {m n : Nat}
variable (A : RandomMatrix Omega m n)
variable (B : RandomMatrix Omega n n)
variable (x : Fin n -> Real)
variable (y : Fin m -> Real)
variable (z : Fin n -> Real)
variable (hA : IsRandomMatrix P A)
variable (hB : IsRandomMatrix P B)

#check quadraticForm
#check bilinearForm
#check quadraticForm_apply
#check bilinearForm_apply
#check isRealRandomVariable_quadraticForm
#check isRealRandomVariable_bilinearForm

#check (quadraticForm B x : RealRandomVariable Omega)
#check (bilinearForm A y z : RealRandomVariable Omega)
#check (isRealRandomVariable_quadraticForm hB x :
  IsRealRandomVariable P (quadraticForm B x))
#check (isRealRandomVariable_bilinearForm hA y z :
  IsRealRandomVariable P (bilinearForm A y z))
