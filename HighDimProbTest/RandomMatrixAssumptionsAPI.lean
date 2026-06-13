import HighDimProb.RandomMatrix.Assumptions

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable {I : Type*}
variable {m n : Nat}
variable (A : RandomMatrix Omega m n)
variable (B : I -> RandomMatrix Omega m n)
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
#check BoundedOperatorNorm_centered_of_bound_expect_bound
#check PointwiseOperatorNormBound_centered_of_bound_expect_bound
#check PointwiseOperatorNormBound_centered_of_bound_expect_bound_same

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
#check (BoundedOperatorNorm_centered_of_bound_expect_bound
  (P := P) (X := A) (R := R) (Rexp := K) :
  BoundedOperatorNorm A R ->
  deterministicOperatorNorm (matrixExpect P A) <= K ->
  BoundedOperatorNorm (centeredRandomMatrix P A) (R + K))
#check (PointwiseOperatorNormBound_centered_of_bound_expect_bound
  (P := P) (X := B) (R := R) (Rexp := K) :
  PointwiseOperatorNormBound B R ->
  (forall i, deterministicOperatorNorm (matrixExpect P (B i)) <= K) ->
  PointwiseOperatorNormBound (fun i => centeredRandomMatrix P (B i)) (R + K))
#check (PointwiseOperatorNormBound_centered_of_bound_expect_bound_same
  (P := P) (X := B) (R := R) :
  PointwiseOperatorNormBound B R ->
  (forall i, deterministicOperatorNorm (matrixExpect P (B i)) <= R) ->
  PointwiseOperatorNormBound (fun i => centeredRandomMatrix P (B i)) (R + R))
