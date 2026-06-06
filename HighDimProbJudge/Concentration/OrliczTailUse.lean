import HighDimProb.Concentration

#check HighDimProb.subGaussianTail_of_psi2Bound
#check HighDimProb.psi2Bound_of_subGaussianTail
#check HighDimProb.subExponentialTail_of_psi1Bound
#check HighDimProb.psi1Bound_of_subExponentialTail

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {X : HighDimProb.RealRandomVariable Omega} {K : Real}
    (hX : HighDimProb.IsRealRandomVariable P X)
    (hpsi : HighDimProb.Psi2Bound P X K) :
    HighDimProb.SubGaussianTail P X K := by
  exact HighDimProb.subGaussianTail_of_psi2Bound hX hpsi

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {X : HighDimProb.RealRandomVariable Omega} {K : Real}
    (hX : HighDimProb.IsRealRandomVariable P X)
    (hpsi : HighDimProb.Psi1Bound P X K) :
    HighDimProb.SubExponentialTail P X K := by
  exact HighDimProb.subExponentialTail_of_psi1Bound hX hpsi
