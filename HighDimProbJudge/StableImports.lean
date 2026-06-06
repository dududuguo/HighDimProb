import HighDimProb

#check HighDimProb.ProbabilityMeasure
#check HighDimProb.RealRandomVariable
#check HighDimProb.Psi2Bound
#check HighDimProb.Psi1Bound
#check HighDimProb.SubGaussianTail
#check HighDimProb.SubGaussianMoment
#check HighDimProb.SubExponentialTail
#check HighDimProb.SubExponentialMoment
#check HighDimProb.tailEventMeasurabilityStatement

example {Omega : Type*} [MeasurableSpace Omega]
    (P : MeasureTheory.Measure Omega) (X : HighDimProb.RealRandomVariable Omega)
    (K : Real) :
    (HighDimProb.SubGaussianTail P X K -> HighDimProb.SubGaussianTail P X K) :=
  fun h => h
