import HighDimProb.Concentration

#check HighDimProb.subGaussianMoment_of_psi2Bound
#check HighDimProb.subGaussianTail_of_centeredSubGaussianMGF

#check
  (HighDimProb.subGaussianTail_of_centeredSubGaussianMGF :
    {Omega : Type*} -> [MeasurableSpace Omega] ->
      {P : MeasureTheory.Measure Omega} ->
      {X : HighDimProb.RealRandomVariable Omega} -> {K : Real} ->
        HighDimProb.IsRealRandomVariable P X ->
          HighDimProb.CenteredSubGaussianMGF P X K ->
            HighDimProb.SubGaussianTail P X (2 * K))

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {X : HighDimProb.RealRandomVariable Omega} {K : Real}
    (hX : HighDimProb.IsRealRandomVariable P X)
    (hpsi : HighDimProb.Psi2Bound P X K) :
    HighDimProb.SubGaussianMoment P X (8 * K) := by
  exact HighDimProb.subGaussianMoment_of_psi2Bound (P := P) hX hpsi

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega}
    {X : HighDimProb.RealRandomVariable Omega} {K : Real}
    (hX : HighDimProb.IsRealRandomVariable P X)
    (hMGF : HighDimProb.CenteredSubGaussianMGF P X K) :
    HighDimProb.SubGaussianTail P X (2 * K) := by
  exact HighDimProb.subGaussianTail_of_centeredSubGaussianMGF hX hMGF
