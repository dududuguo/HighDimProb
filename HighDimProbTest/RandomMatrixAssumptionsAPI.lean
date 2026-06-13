import HighDimProb.RandomMatrix.Assumptions

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable {I : Type*}
variable {m n : Nat}
variable (A : RandomMatrix Omega m n)
variable (X : I -> Omega -> Fin n -> Real)
variable (K R : Real)

#check SubGaussianEntriesOrlicz
#check SubGaussianEntriesTail
#check SubGaussianRowsOrlicz
#check IsotropicRowsSecondMoment
#check IsotropicRowsCovariance
#check CenteredEntries
#check BoundedOperatorNorm_rankOne_of_sqNorm_bound
#check PointwiseOperatorNormBound_rankOne_of_sqNorm_bound

#check (SubGaussianEntriesOrlicz P A K : Prop)
#check (SubGaussianEntriesTail P A K : Prop)
#check (SubGaussianRowsOrlicz P A K : Prop)
#check (IsotropicRowsSecondMoment P A : Prop)
#check (IsotropicRowsCovariance P A : Prop)
#check (CenteredEntries P A : Prop)
#check (PointwiseOperatorNormBound_rankOne_of_sqNorm_bound
  (X := X) (R := R) :
  0 <= R ->
  (forall i omega, vectorSqNorm (X i omega) <= R) ->
  PointwiseOperatorNormBound
    (fun i omega a b => X i omega a * X i omega b) R)
