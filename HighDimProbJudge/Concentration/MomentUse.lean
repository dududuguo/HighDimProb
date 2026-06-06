import HighDimProb.Concentration

#check HighDimProb.subGaussianMoment_of_psi2Bound
#check HighDimProb.subGaussianMoment_of_subGaussianTail
#check HighDimProb.subExponentialMoment_of_psi1Bound
#check HighDimProb.subExponentialMoment_of_subExponentialTail
#check HighDimProb.realLpNorm_le_sqrt_of_psi2Bound
#check HighDimProb.realLpNorm_le_sqrt_of_subGaussianTail
#check HighDimProb.realLpNorm_le_linear_of_psi1Bound
#check HighDimProb.realLpNorm_le_linear_of_subExponentialTail
#check HighDimProb.realLpNorm_nat_le_sqrt_of_psi2Bound
#check HighDimProb.realLpNorm_nat_le_linear_of_psi1Bound

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {X : HighDimProb.RealRandomVariable Omega} {K : Real}
    (hX : HighDimProb.IsRealRandomVariable P X)
    (hpsi : HighDimProb.Psi1Bound P X K) :
    HighDimProb.SubExponentialMoment P X (16 * K) := by
  exact HighDimProb.subExponentialMoment_of_psi1Bound hX hpsi

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {X : HighDimProb.RealRandomVariable Omega} {K : Real}
    (hX : HighDimProb.IsRealRandomVariable P X)
    (htail : HighDimProb.SubGaussianTail P X K) :
    HighDimProb.SubGaussianMoment P X (16 * K) := by
  exact HighDimProb.subGaussianMoment_of_subGaussianTail hX htail
