import HighDimProb.RandomMatrix.Algebra

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable {m n : Nat}
variable (A : RandomMatrix Omega m n)
variable (i j : Fin n)
variable (r s : Fin m)
variable (hA : IsRandomMatrix P A)
variable (hRowsInt : forall k : Fin m,
  IntegrableRandomMatrix P (rankOneRandomMatrix (rowVector A k)))

#check gramMatrixEntry
#check gramMatrix
#check rowGramMatrixEntry
#check rowGramMatrix
#check sampleCovarianceEntry
#check sampleCovariance
#check gramMatrixEntry_apply
#check gramMatrix_apply
#check rowGramMatrixEntry_apply
#check rowGramMatrix_apply
#check sampleCovarianceEntry_apply
#check sampleCovariance_apply
#check sampleCovarianceRowRankOneSum
#check sampleCovarianceRowRankOneFamily
#check centeredSampleCovarianceRowRankOneFamily
#check normalizedSampleCovarianceRowRankOneSum
#check centeredSampleCovarianceRowRankOneSum
#check normalizedCenteredSampleCovarianceRowRankOneSum
#check sampleCovarianceRowRankOneFamily_apply
#check centeredSampleCovarianceRowRankOneFamily_apply
#check sampleCovariance_eq_normalized_rowRankOne_sum
#check sampleCovariance_deviation_eq_normalized_centered_rowRankOne_sum
#check isRealRandomVariable_gramMatrixEntry
#check isRealRandomVariable_rowGramMatrixEntry
#check isRealRandomVariable_sampleCovarianceEntry

#check (gramMatrixEntry A i j : RealRandomVariable Omega)
#check (gramMatrix A : RandomMatrix Omega n n)
#check (rowGramMatrixEntry A r s : RealRandomVariable Omega)
#check (rowGramMatrix A : RandomMatrix Omega m m)
#check (sampleCovarianceEntry A i j : RealRandomVariable Omega)
#check (sampleCovariance A : RandomMatrix Omega n n)
#check (sampleCovarianceRowRankOneFamily A :
  Fin m -> RandomMatrix Omega n n)
#check (centeredSampleCovarianceRowRankOneFamily (P := P) A :
  Fin m -> RandomMatrix Omega n n)
#check (sampleCovarianceRowRankOneSum A : RandomMatrix Omega n n)
#check (normalizedSampleCovarianceRowRankOneSum A : RandomMatrix Omega n n)
#check (centeredSampleCovarianceRowRankOneSum (P := P) A :
  RandomMatrix Omega n n)
#check (normalizedCenteredSampleCovarianceRowRankOneSum (P := P) A :
  RandomMatrix Omega n n)
#check (sampleCovariance_eq_normalized_rowRankOne_sum A :
  sampleCovariance A = normalizedSampleCovarianceRowRankOneSum A)
#check (sampleCovariance_deviation_eq_normalized_centered_rowRankOne_sum A hRowsInt :
  centeredRandomMatrix P (sampleCovariance A) =
    normalizedCenteredSampleCovarianceRowRankOneSum (P := P) A)
#check (isRealRandomVariable_gramMatrixEntry hA i j :
  IsRealRandomVariable P (gramMatrixEntry A i j))
#check (isRealRandomVariable_rowGramMatrixEntry hA r s :
  IsRealRandomVariable P (rowGramMatrixEntry A r s))
#check (isRealRandomVariable_sampleCovarianceEntry hA i j :
  IsRealRandomVariable P (sampleCovarianceEntry A i j))
