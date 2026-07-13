import HighDimProb.RandomMatrix.Assumptions

open MeasureTheory
open HighDimProb
open scoped Matrix.Norms.L2Operator

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable {I : Type*}
variable {m n : Nat}
variable (A : RandomMatrix Omega m n)
variable (B : I -> RandomMatrix Omega m n)
variable (S : RandomMatrix Omega n n)
variable (T : I -> RandomMatrix Omega n n)
variable (X : I -> Omega -> Fin n -> Real)
variable (i : I)
variable (x : Fin n -> Real)
variable (K R : Real)

#check SubGaussianEntriesOrlicz
#check SubGaussianEntriesTail
#check SubGaussianRowsOrlicz
#check IsotropicRowsSecondMoment
#check IsotropicRowsCovariance
#check CenteredEntries
#check BoundedOperatorNorm_rankOneRandomMatrix_of_sqNorm_bound
#check PointwiseOperatorNormBound_rankOneRandomMatrix_of_sqNorm_bound
#check rankOneRandomMatrixFamily
#check BoundedOperatorNorm_centered_of_bound_expect_bound
#check PointwiseOperatorNormBound_centered_of_bound_expect_bound
#check PointwiseOperatorNormBound_centered_of_bound_expect_bound_same
#check matrixExpect_eq_integral_l2Operator
#check matrixExpect_eq_integral
#check integrable_matrix_of_integrableRandomMatrix
#check deterministicOperatorNorm_matrixExpect_le_of_boundedOperatorNorm
#check BoundedOperatorNorm_centered_of_boundedOperatorNorm
#check PointwiseOperatorNormBound_centered_of_pointwiseOperatorNormBound
#check PointwiseOperatorNormBound_centered_of_pointwiseOperatorNormBound_same
#check BoundedOperatorNorm_centeredRankOneRandomMatrix_of_sqNorm_bound
#check PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound
#check isRandomMatrix_centeredRandomMatrix
#check integrableRandomMatrix_centeredRandomMatrix
#check centeredRankOneRandomMatrix
#check centeredRankOneRandomMatrixFamily
#check iIndepFun_centeredRankOne
#check isSelfAdjointMatrix_matrixExpect_of_randomSelfAdjoint
#check randomSelfAdjointMatrix_centeredRandomMatrix
#check matrixExpect_centeredRandomMatrix
#check selfAdjointRandomMatrixFamily_centeredRandomMatrixFamily
#check centeredSelfAdjointRandomMatrixFamily_centeredRandomMatrixFamily
#check isSelfAdjointMatrix_rankOneMatrix
#check randomSelfAdjointMatrix_rankOneRandomMatrix
#check centeredRankOneRandomMatrix_isRandomMatrix
#check centeredRankOneRandomMatrix_integrable_of_memLp_two
#check centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two
#check expectationOperatorNormBound_of_pointwiseOperatorNormBound

#check (SubGaussianEntriesOrlicz P A K : Prop)
#check (SubGaussianEntriesTail P A K : Prop)
#check (SubGaussianRowsOrlicz P A K : Prop)
#check (IsotropicRowsSecondMoment P A : Prop)
#check (IsotropicRowsCovariance P A : Prop)
#check (CenteredEntries P A : Prop)
#check (matrixExpect_eq_integral_l2Operator
  (P := P) (A := A) :
  Integrable A P ->
  matrixExpect P A = ∫ omega, A omega ∂P)
#check (PointwiseOperatorNormBound_rankOneRandomMatrix_of_sqNorm_bound
  (X := X) (R := R) :
  (forall i omega, vectorSqNorm (X i omega) <= R) ->
  PointwiseOperatorNormBound
    (rankOneRandomMatrixFamily X) R)
#check (BoundedOperatorNorm_centered_of_bound_expect_bound
  (P := P) (X := A) (R := R) (Rexp := K) :
  BoundedOperatorNorm A R ->
  deterministicOperatorNorm (matrixExpect P A) <= K ->
  BoundedOperatorNorm (centeredRandomMatrix P A) (R + K))
#check (PointwiseOperatorNormBound_centered_of_bound_expect_bound
  (P := P) (X := B) (R := R) (Rexp := K) :
  PointwiseOperatorNormBound B R ->
  (forall i, deterministicOperatorNorm (matrixExpect P (B i)) <= K) ->
  PointwiseOperatorNormBound (centeredRandomMatrixFamily P B) (R + K))
#check (PointwiseOperatorNormBound_centered_of_bound_expect_bound_same
  (P := P) (X := B) (R := R) :
  PointwiseOperatorNormBound B R ->
  (forall i, deterministicOperatorNorm (matrixExpect P (B i)) <= R) ->
  PointwiseOperatorNormBound (centeredRandomMatrixFamily P B) (R + R))
#check (matrixExpect_eq_integral
  (P := P) (A := A) :
  IntegrableRandomMatrix P A ->
  matrixExpect P A = ∫ omega, A omega ∂P)
#check (integrable_matrix_of_integrableRandomMatrix
  (P := P) (A := A) :
  IntegrableRandomMatrix P A ->
  Integrable A P)
#check (deterministicOperatorNorm_matrixExpect_le_of_boundedOperatorNorm
  (P := P) (X := A) (R := R) :
  IsRandomMatrix P A ->
  IntegrableRandomMatrix P A ->
  BoundedOperatorNorm A R ->
  0 <= R ->
  deterministicOperatorNorm (matrixExpect P A) <= R)
#check (BoundedOperatorNorm_centered_of_boundedOperatorNorm
  (P := P) (X := A) (R := R) :
  IsRandomMatrix P A ->
  IntegrableRandomMatrix P A ->
  BoundedOperatorNorm A R ->
  0 <= R ->
  BoundedOperatorNorm (centeredRandomMatrix P A) (2 * R))
#check (PointwiseOperatorNormBound_centered_of_pointwiseOperatorNormBound
  (P := P) (X := B) (R := R) :
  (forall i, IsRandomMatrix P (B i)) ->
  (forall i, IntegrableRandomMatrix P (B i)) ->
  PointwiseOperatorNormBound B R ->
  0 <= R ->
  PointwiseOperatorNormBound (centeredRandomMatrixFamily P B) (2 * R))
#check (PointwiseOperatorNormBound_centered_of_pointwiseOperatorNormBound_same
  (P := P) (X := B) (R := R) :
  (forall i, IsRandomMatrix P (B i)) ->
  (forall i, IntegrableRandomMatrix P (B i)) ->
  PointwiseOperatorNormBound B R ->
  0 <= R ->
  PointwiseOperatorNormBound (centeredRandomMatrixFamily P B) (R + R))
#check (BoundedOperatorNorm_centeredRankOneRandomMatrix_of_sqNorm_bound
  (P := P) (X := X i) (R := R) :
  IsRandomVector P (X i) ->
  (forall j : Fin n, MemLpRealRandomVariable P (coord (X i) j) 2) ->
  (forall omega, vectorSqNorm (X i omega) <= R) ->
  0 <= R ->
  BoundedOperatorNorm
    (centeredRankOneRandomMatrix P (X i)) (2 * R))
#check (PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound
  (P := P) (X := X) (R := R) :
  (forall i, IsRandomVector P (X i)) ->
  (forall i, forall j : Fin n, MemLpRealRandomVariable P (coord (X i) j) 2) ->
  (forall i omega, vectorSqNorm (X i omega) <= R) ->
  0 <= R ->
  PointwiseOperatorNormBound
    (centeredRankOneRandomMatrixFamily P X) (2 * R))
#check (isRandomMatrix_centeredRandomMatrix
  (P := P) (A := A) :
  IsRandomMatrix P A ->
  IsRandomMatrix P (centeredRandomMatrix P A))
#check (integrableRandomMatrix_centeredRandomMatrix
  (P := P) (A := A) :
  IntegrableRandomMatrix P A ->
  IntegrableRandomMatrix P (centeredRandomMatrix P A))
#check (isSelfAdjointMatrix_matrixExpect_of_randomSelfAdjoint
  (P := P) (A := S) :
  RandomSelfAdjointMatrix P S ->
  IsSelfAdjointMatrix (matrixExpect P S))
#check (randomSelfAdjointMatrix_centeredRandomMatrix
  (P := P) (A := S) :
  RandomSelfAdjointMatrix P S ->
  RandomSelfAdjointMatrix P (centeredRandomMatrix P S))
#check (matrixExpect_centeredRandomMatrix
  (P := P) (A := A) :
  IntegrableRandomMatrix P A ->
  matrixExpect P (centeredRandomMatrix P A) = 0)
#check (selfAdjointRandomMatrixFamily_centeredRandomMatrixFamily
  (P := P) (A := T) :
  SelfAdjointRandomMatrixFamily P T ->
  SelfAdjointRandomMatrixFamily P (centeredRandomMatrixFamily P T))
#check (centeredSelfAdjointRandomMatrixFamily_centeredRandomMatrixFamily
  (P := P) (A := T) :
  SelfAdjointRandomMatrixFamily P T ->
  (forall i, IntegrableRandomMatrix P (T i)) ->
  CenteredSelfAdjointRandomMatrixFamily P (centeredRandomMatrixFamily P T))
#check (isSelfAdjointMatrix_rankOneMatrix x :
  IsSelfAdjointMatrix (rankOneMatrix x))
#check (randomSelfAdjointMatrix_rankOneRandomMatrix
  (P := P) (X := X i) :
  RandomSelfAdjointMatrix P (rankOneRandomMatrix (X i)))
#check (centeredRankOneRandomMatrix_isRandomMatrix
  (P := P) (X := X i) :
  IsRandomVector P (X i) ->
  IsRandomMatrix P (centeredRankOneRandomMatrix P (X i)))
#check (centeredRankOneRandomMatrix_integrable_of_memLp_two
  (P := P) (X := X i) :
  (forall j : Fin n, MemLpRealRandomVariable P (coord (X i) j) 2) ->
  IntegrableRandomMatrix P (centeredRankOneRandomMatrix P (X i)))
#check (centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two
  (P := P) (X := X) :
  (forall i, IsRandomVector P (X i)) ->
  (forall i, forall j : Fin n, MemLpRealRandomVariable P (coord (X i) j) 2) ->
  CenteredSelfAdjointRandomMatrixFamily P
    (centeredRankOneRandomMatrixFamily P X))
#check (expectationOperatorNormBound_of_pointwiseOperatorNormBound
  (P := P) (X := B) (R := R) :
  (forall i, IsRandomMatrix P (B i)) ->
  (forall i, IntegrableRandomMatrix P (B i)) ->
  PointwiseOperatorNormBound B R ->
  0 <= R ->
  forall i, deterministicOperatorNorm (matrixExpect P (B i)) <= R)
