import HighDimProb.RandomMatrix

namespace HighDimProb

open MeasureTheory

noncomputable section

variable {Omega : Type*} [MeasurableSpace Omega]
variable {m n : Nat}
variable (A : RandomMatrix Omega m n)
variable (omega : Omega)
variable (i : Fin n)
variable (k : Fin m)
variable (x : Fin n -> Real)

#check frobeniusSq_nonneg
#check sampleCovarianceEntry_diag_nonneg
#check rowDot
#check rowDot_apply
#check rowDot_sq_nonneg
#check sum_rowDot_sq_nonneg
#check quadraticForm_sampleCovariance_eq_sum_sq
#check quadraticForm_sampleCovariance_eq_scaled_sum_rowDot_sq
#check quadraticForm_sampleCovariance_nonneg

#check (rowDot A x k omega : Real)
#check (rowDot_apply A x k omega :
  rowDot A x k omega = Finset.univ.sum fun i : Fin n => A omega k i * x i)
#check (rowDot_sq_nonneg A x k omega :
  0 <= (rowDot A x k omega) ^ 2)
#check (sum_rowDot_sq_nonneg A x omega :
  0 <= Finset.univ.sum fun k : Fin m => (rowDot A x k omega) ^ 2)
#check (frobeniusSq_nonneg A omega : 0 <= frobeniusSq A omega)
#check (sampleCovarianceEntry_diag_nonneg A i omega :
  0 <= sampleCovarianceEntry A i i omega)

#check (quadraticForm_sampleCovariance_eq_sum_sq A x omega :
  quadraticForm (sampleCovariance A) x omega =
    (1 / (m : Real)) * Finset.univ.sum
      (fun k : Fin m => (Finset.univ.sum fun i : Fin n => A omega k i * x i) ^ 2))
#check (quadraticForm_sampleCovariance_eq_scaled_sum_rowDot_sq A x omega :
  quadraticForm (sampleCovariance A) x omega =
    (1 / (m : Real)) * Finset.univ.sum
      (fun k : Fin m => (rowDot A x k omega) ^ 2))
#check (quadraticForm_sampleCovariance_nonneg A x omega :
  0 <= quadraticForm (sampleCovariance A) x omega)

end

end HighDimProb
