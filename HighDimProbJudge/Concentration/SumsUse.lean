import HighDimProb.Concentration

open scoped BigOperators

#check HighDimProb.centeredSubGaussianMGF_sum_of_iIndepFun_of_pos
#check HighDimProb.subGaussianTail_sum_of_iIndepFun_of_pos
#check HighDimProb.centeredSubGaussianMGF_weighted_sum_of_iIndepFun_of_pos
#check HighDimProb.subGaussianTail_weighted_sum_of_iIndepFun_of_pos
#check HighDimProb.centeredSubExponentialMGF_sum_mgf_bound_of_iIndepFun
#check HighDimProb.centeredSubExponentialMGF_sum_mgf_bound_of_iIndepFun_maxScale
#check HighDimProb.centeredSubExponentialMGFLIntegral_sum_mgf_bound_of_iIndepFun_maxScale
#check HighDimProb.centeredSubExponentialMGFLIntegral_weighted_sum_mgf_bound_of_iIndepFun_maxScale
#check HighDimProb.centeredSubExponentialMGF_sum_of_iIndepFun_of_pos
#check HighDimProb.centeredSubExponentialMGFLIntegral_sum_of_iIndepFun_statement
#check HighDimProb.bernstein_sum_subExponential
#check HighDimProb.bernstein_weighted_sum_subExponential

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {X : I -> HighDimProb.RealRandomVariable Omega} {K : I -> Real}
    (hpos : 0 < Finset.univ.sum (fun i : I => (K i) ^ 2))
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hMGF : forall i : I, HighDimProb.CenteredSubGaussianMGF P (X i) (K i)) :
    HighDimProb.CenteredSubGaussianMGF P
      (fun omega => Finset.univ.sum (fun i : I => X i omega))
      (Real.sqrt (Finset.univ.sum (fun i : I => (K i) ^ 2))) := by
  exact
    HighDimProb.centeredSubGaussianMGF_sum_of_iIndepFun_of_pos
      (P := P) (X := X) (K := K) hpos hIndep hMGF
