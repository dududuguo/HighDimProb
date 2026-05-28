import HighDimProb.RandomMatrix.Norms

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable {m n : Nat}
variable (A : RandomMatrix Omega m n)
variable (hA : IsRandomMatrix P A)

#check frobeniusSq
#check frobeniusNorm
#check entrywiseMaxAbs
#check frobeniusSq_apply
#check frobeniusNorm_apply
#check entrywiseMaxAbs_apply
#check isRealRandomVariable_frobeniusSq
#check isRealRandomVariable_frobeniusNorm

#check (frobeniusSq A : RealRandomVariable Omega)
#check (frobeniusNorm A : RealRandomVariable Omega)
#check (entrywiseMaxAbs A : RealRandomVariable Omega)
#check (isRealRandomVariable_frobeniusSq hA :
  IsRealRandomVariable P (frobeniusSq A))
#check (isRealRandomVariable_frobeniusNorm hA :
  IsRealRandomVariable P (frobeniusNorm A))
