import HighDimProb.Concentration

open HighDimProb
open MeasureTheory

#check upperTailEvent_subset_of_le
#check lowerTailEvent_subset_of_le
#check absTailEvent_subset_of_le
#check expect_nonneg_of_nonneg
#check expect_nonneg_of_nonneg_integrable
#check lintegral_ofReal_eq_ofReal_expect
#check markov_inequality_nonneg
#check markov_inequality
#check integrable_centered
#check chebyshev_inequality
#check chebyshev_inequality_prob
#check centered_centered

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsFiniteMeasure P]
variable (X : RealRandomVariable Omega)

#check fun (hX : IntegrableRealRandomVariable P X) (hX_nonneg : forall omega, 0 <= X omega) =>
  markov_inequality_nonneg X hX hX_nonneg

#check fun (hX : IntegrableRealRandomVariable P X) (hX_nonneg : forall omega, 0 <= X omega) =>
  markov_inequality X hX hX_nonneg

#check fun (hX : MemLpRealRandomVariable P X 2) =>
  chebyshev_inequality X hX

variable [IsProbabilityMeasure P]

#check fun (hX : MemLpRealRandomVariable P X 2) =>
  chebyshev_inequality_prob X hX
