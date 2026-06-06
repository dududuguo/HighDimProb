import HighDimProb.RandomMatrix

#check HighDimProb.sampleCovariance
#check HighDimProb.sampleCovarianceEntry
#check HighDimProb.isPSD_sampleCovariance
#check HighDimProb.randomPSDMatrix_sampleCovariance
#check HighDimProb.quadraticForm_sampleCovariance_eq_sum_sq
#check HighDimProb.quadraticForm_sampleCovariance_eq_scaled_sum_rowDot_sq
#check HighDimProb.quadraticForm_sampleCovariance_nonneg
#check HighDimProb.sampleCovarianceEntry_diag_nonneg

example {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : HighDimProb.RandomMatrix Omega m n) (omega : Omega) :
    HighDimProb.IsPSDMatrix (HighDimProb.sampleCovariance A omega) := by
  exact HighDimProb.isPSD_sampleCovariance A omega

example {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : HighDimProb.RandomMatrix Omega m n) (x : Fin n -> Real) (omega : Omega) :
    0 <= HighDimProb.quadraticForm (HighDimProb.sampleCovariance A) x omega := by
  exact HighDimProb.quadraticForm_sampleCovariance_nonneg A x omega
