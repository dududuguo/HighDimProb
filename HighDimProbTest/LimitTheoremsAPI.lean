import HighDimProb.LimitTheorems

namespace HighDimProbTest

open HighDimProb
open MeasureTheory

noncomputable section

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable {n : Nat}
variable (X : Fin n -> RealRandomVariable Omega)
variable (Y : Nat -> RealRandomVariable Omega)
variable (hX : forall i : Fin n, IsRealRandomVariable P (X i))
variable (hX_int : forall i : Fin n, IntegrableRealRandomVariable P (X i))
variable (mu sigmaSq eps : Real)

#check sampleSum
#check sampleMean
#check sampleMeanCentered
#check isRealRandomVariable_sampleSum
#check isRealRandomVariable_sampleMean
#check isRealRandomVariable_sampleMeanCentered
#check integrable_sampleSum
#check integrable_sampleMean
#check integrable_sampleMeanCentered
#check IndependentSample
#check PairwiseIndependentFinSample
#check IdenticallyDistributedSample
#check IidSample
#check IndependentFinSample
#check IdenticallyDistributedFinSample
#check IidFinSample
#check IndependentSequence
#check IdenticallyDistributedSequence
#check IidSequence
#check weakLawChebyshevBoundStatement
#check weakLawFiniteVarianceStatement

#check (sampleSum X : RealRandomVariable Omega)
#check (sampleMean X : RealRandomVariable Omega)
#check (sampleMeanCentered X mu : RealRandomVariable Omega)
#check (isRealRandomVariable_sampleSum (P := P) (X := X) hX :
  IsRealRandomVariable P (sampleSum X))
#check (isRealRandomVariable_sampleMean (P := P) (X := X) hX :
  IsRealRandomVariable P (sampleMean X))
#check (integrable_sampleSum (P := P) (X := X) hX_int :
  IntegrableRealRandomVariable P (sampleSum X))
#check (integrable_sampleMean (P := P) (X := X) hX_int :
  IntegrableRealRandomVariable P (sampleMean X))
#check (IndependentFinSample P X : Prop)
#check (PairwiseIndependentFinSample P X : Prop)
#check (IdenticallyDistributedFinSample P X : Prop)
#check (IidFinSample P X : Prop)
#check (IndependentSequence P Y : Prop)
#check (IdenticallyDistributedSequence P Y : Prop)
#check (IidSequence P Y : Prop)
#check (weakLawChebyshevBoundStatement P X mu sigmaSq eps : Prop)

end

end HighDimProbTest
