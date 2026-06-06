import HighDimProb.Concentration

#check HighDimProb.markov_inequality
#check HighDimProb.chebyshev_inequality
#check HighDimProb.chebyshev_inequality_prob
#check HighDimProb.measure_biUnion_le
#check HighDimProb.upperTailProb_antitone
#check HighDimProb.lowerTailProb_monotone
#check HighDimProb.absTailProb_antitone

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega}
    (X : HighDimProb.RealRandomVariable Omega)
    (hX : HighDimProb.IntegrableRealRandomVariable P X)
    (hX_nonneg : forall omega, 0 <= X omega)
    {a : Real} (ha : 0 < a) :
    HighDimProb.upperTailProb P X a <=
      ENNReal.ofReal (HighDimProb.expect P X / a) := by
  exact HighDimProb.markov_inequality X hX hX_nonneg ha

example {Omega : Type*} [MeasurableSpace Omega]
    (P : MeasureTheory.Measure Omega)
    (X : HighDimProb.RealRandomVariable Omega)
    {s t : Real} (hst : s <= t) :
    HighDimProb.upperTailProb P X t <= HighDimProb.upperTailProb P X s := by
  exact HighDimProb.upperTailProb_antitone P X hst
