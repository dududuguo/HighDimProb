import HighDimProb.Concentration.LayerCake

open HighDimProb
open MeasureTheory

#check lintegral_ofReal_eq_lintegral_tail
#check lintegral_half_exp_neg_three_quarters_le_one
#check lintegral_two_thirds_exp_neg_two_thirds_le_one
#check integral_quarter_exp_quarter
#check integral_third_exp_third
#check lintegral_exp_quarter_sub_one_le_of_exp_tail
#check lintegral_exp_third_sub_one_le_of_exp_tail

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega}
variable {Z : RealRandomVariable Omega}

#check fun (hZ_nonneg : forall omega, 0 <= Z omega)
    (hZ : IsRealRandomVariable P Z)
    (hTail :
      forall s : Real, 0 <= s ->
        P {omega : Omega | s <= Z omega} <= ENNReal.ofReal (2 * Real.exp (-s))) =>
  lintegral_exp_quarter_sub_one_le_of_exp_tail
    (P := P) (Z := Z) hZ_nonneg hZ hTail

#check fun (hZ_nonneg : forall omega, 0 <= Z omega)
    (hZ : IsRealRandomVariable P Z)
    (hTail :
      forall s : Real, 0 <= s ->
        P {omega : Omega | s <= Z omega} <= ENNReal.ofReal (2 * Real.exp (-s))) =>
  lintegral_exp_third_sub_one_le_of_exp_tail
    (P := P) (Z := Z) hZ_nonneg hZ hTail
