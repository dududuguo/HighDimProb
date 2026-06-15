import HighDimProb.RandomMatrix

#check HighDimProb.sampleCovariance
#check HighDimProb.sampleCovarianceEntry
#check HighDimProb.rankOneRandomMatrix
#check HighDimProb.isRandomMatrix_rankOneRandomMatrix
#check HighDimProb.integrableRandomMatrix_rankOneRandomMatrix_of_integrable_products
#check HighDimProb.integrableRandomMatrix_rankOneRandomMatrix_of_memLp_two
#check HighDimProb.isPSD_sampleCovariance
#check HighDimProb.randomPSDMatrix_sampleCovariance
#check HighDimProb.quadraticForm_sampleCovariance_eq_sum_sq
#check HighDimProb.quadraticForm_sampleCovariance_eq_scaled_sum_rowDot_sq
#check HighDimProb.quadraticForm_sampleCovariance_nonneg
#check HighDimProb.sampleCovarianceRowRankOneFamily
#check HighDimProb.centeredSampleCovarianceRowRankOneFamily
#check HighDimProb.sampleCovarianceRowRankOneSum
#check HighDimProb.normalizedSampleCovarianceRowRankOneSum
#check HighDimProb.centeredSampleCovarianceRowRankOneSum
#check HighDimProb.normalizedCenteredSampleCovarianceRowRankOneSum
#check HighDimProb.sampleCovarianceRowRankOneFamily_apply
#check HighDimProb.centeredSampleCovarianceRowRankOneFamily_apply
#check HighDimProb.sampleCovariance_eq_normalized_rowRankOne_sum
#check HighDimProb.sampleCovariance_deviation_eq_normalized_centered_rowRankOne_sum
#check HighDimProb.sampleCovarianceEntry_diag_nonneg

example {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : HighDimProb.RandomMatrix Omega m n) (omega : Omega) :
    HighDimProb.IsPSDMatrix (HighDimProb.sampleCovariance A omega) := by
  exact HighDimProb.isPSD_sampleCovariance A omega

example {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : HighDimProb.RandomMatrix Omega m n) (x : Fin n -> Real) (omega : Omega) :
    0 <= HighDimProb.quadraticForm (HighDimProb.sampleCovariance A) x omega := by
  exact HighDimProb.quadraticForm_sampleCovariance_nonneg A x omega

example {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : HighDimProb.RandomMatrix Omega m n) :
    HighDimProb.sampleCovariance A =
      HighDimProb.normalizedSampleCovarianceRowRankOneSum A := by
  exact HighDimProb.sampleCovariance_eq_normalized_rowRankOne_sum A

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} {m n : Nat}
    (A : HighDimProb.RandomMatrix Omega m n)
    (hInt : forall k : Fin m,
      HighDimProb.IntegrableRandomMatrix P
        (HighDimProb.rankOneRandomMatrix (HighDimProb.rowVector A k))) :
    HighDimProb.centeredRandomMatrix P (HighDimProb.sampleCovariance A) =
      HighDimProb.normalizedCenteredSampleCovarianceRowRankOneSum (P := P) A := by
  exact HighDimProb.sampleCovariance_deviation_eq_normalized_centered_rowRankOne_sum A hInt

example {Omega : Type*} [MeasurableSpace Omega] {P : MeasureTheory.Measure Omega}
    {n : Nat} {X : HighDimProb.RandomVector Omega n}
    (hX : HighDimProb.IsRandomVector P X) :
    HighDimProb.IsRandomMatrix P (HighDimProb.rankOneRandomMatrix X) := by
  exact HighDimProb.isRandomMatrix_rankOneRandomMatrix hX

example {Omega : Type*} [MeasurableSpace Omega] {P : MeasureTheory.Measure Omega}
    {n : Nat} {X : HighDimProb.RandomVector Omega n}
    (hProd : forall i : Fin n, forall j : Fin n,
      HighDimProb.IntegrableRealRandomVariable P
        (fun omega => X omega i * X omega j)) :
    HighDimProb.IntegrableRandomMatrix P (HighDimProb.rankOneRandomMatrix X) := by
  exact HighDimProb.integrableRandomMatrix_rankOneRandomMatrix_of_integrable_products hProd
