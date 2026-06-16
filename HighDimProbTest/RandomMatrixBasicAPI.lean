import HighDimProb.RandomMatrix.Basic

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable {m n : Nat}
variable (A : RandomMatrix Omega m n)
variable (X : RandomVector Omega n)
variable (x : Fin n -> Real)
variable (theta : Real)
variable (i : Fin m) (j : Fin n)
variable (a b : Fin n)
variable (hA : IsRandomMatrix P A)
variable (hX : IsRandomVector P X)

#check RandomMatrix
#check matrixEntry
#check IsRandomMatrix
#check matrixEntry_apply
#check scaledRandomMatrix
#check scaledRandomMatrix_apply
#check scaledRandomMatrixFamily
#check scaledRandomMatrixFamily_apply
#check scaledRandomMatrixFamily_apply_apply
#check isRandomMatrix_scaledRandomMatrix
#check isRandomMatrix_scaledRandomMatrixFamily
#check rankOneMatrix
#check rankOneMatrix_apply
#check rankOneRandomMatrix
#check rankOneRandomMatrix_apply
#check matrixEntry_rankOneRandomMatrix
#check isRealRandomVariable_matrixEntry
#check isRandomMatrix_rankOneRandomMatrix
#check instMeasurableSpaceMatrix
#check measurable_randomMatrix_of_isRandomMatrix

#check (matrixEntry A i j : RealRandomVariable Omega)
#check (scaledRandomMatrix theta A : RandomMatrix Omega m n)
#check (scaledRandomMatrix_apply theta A :
  forall omega, scaledRandomMatrix theta A omega = SMul.smul theta (A omega))
#check (scaledRandomMatrixFamily theta (fun _ : Unit => A) () :
  RandomMatrix Omega m n)
#check (isRandomMatrix_scaledRandomMatrix theta hA :
  IsRandomMatrix P (scaledRandomMatrix theta A))
#check (rankOneMatrix x : Matrix (Fin n) (Fin n) Real)
#check (rankOneMatrix_apply x : forall a b,
  rankOneMatrix x a b = x a * x b)
#check (rankOneRandomMatrix X : RandomMatrix Omega n n)
#check (rankOneRandomMatrix_apply X : forall omega a b,
  rankOneRandomMatrix X omega a b = X omega a * X omega b)
#check (matrixEntry_rankOneRandomMatrix X a b :
  forall omega, matrixEntry (rankOneRandomMatrix X) a b omega = X omega a * X omega b)
#check (isRealRandomVariable_matrixEntry hA i j :
  IsRealRandomVariable P (matrixEntry A i j))
#check (isRandomMatrix_rankOneRandomMatrix hX :
  IsRandomMatrix P (rankOneRandomMatrix X))
#check (measurable_randomMatrix_of_isRandomMatrix hA : Measurable A)
