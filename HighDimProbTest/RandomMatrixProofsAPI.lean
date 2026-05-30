import HighDimProb.RandomMatrix

namespace HighDimProb

open MeasureTheory

noncomputable section

variable {Omega : Type*} [MeasurableSpace Omega]
variable {m n : Nat}
variable (A : RandomMatrix Omega m n)
variable (omega : Omega)
variable (i : Fin n)

#check frobeniusSq_nonneg
#check sampleCovarianceEntry_diag_nonneg

#check (frobeniusSq_nonneg A omega : 0 <= frobeniusSq A omega)
#check (sampleCovarianceEntry_diag_nonneg A i omega :
  0 <= sampleCovarianceEntry A i i omega)

end

end HighDimProb
