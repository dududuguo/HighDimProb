import HighDimProb.Concentration

open scoped BigOperators

#check HighDimProb.bernstein_sum_subExponential
#check HighDimProb.bernstein_weighted_sum_subExponential
#check HighDimProb.bernsteinAdditiveTailThreshold
#check HighDimProb.bernsteinAdditiveTailThreshold_exponent_eq

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {X : I -> HighDimProb.RealRandomVariable Omega} {K : I -> Real}
    (hV : 0 < HighDimProb.varianceProxy K)
    (hB : 0 < HighDimProb.maxScale K)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hMGF : ∀ i : I,
      HighDimProb.CenteredSubExponentialMGFLIntegral P (X i) (K i))
    {t : Real} (ht : 0 <= t) :
    HighDimProb.absTailProb P (fun omega => ∑ i : I, X i omega) t <=
      ENNReal.ofReal
        (2 * Real.exp
          (-((1 / 4) *
            HighDimProb.subExponentialBernsteinRate
              t (HighDimProb.varianceProxy K) (HighDimProb.maxScale K)))) := by
  exact
    HighDimProb.bernstein_sum_subExponential
      (P := P) (X := X) (K := K) hV hB hIndep hMGF ht

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {X : I -> HighDimProb.RealRandomVariable Omega} {K c : I -> Real}
    (hV : 0 < HighDimProb.weightedVarianceProxy c K)
    (hB : 0 < HighDimProb.weightedMaxScale c K)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hMGF : ∀ i : I,
      HighDimProb.CenteredSubExponentialMGFLIntegral P (X i) (K i))
    {t : Real} (ht : 0 <= t) :
    HighDimProb.absTailProb P (fun omega => ∑ i : I, c i * X i omega) t <=
      ENNReal.ofReal
        (2 * Real.exp
          (-((1 / 4) *
            HighDimProb.subExponentialBernsteinRate
              t (HighDimProb.weightedVarianceProxy c K)
                (HighDimProb.weightedMaxScale c K)))) := by
  exact
    HighDimProb.bernstein_weighted_sum_subExponential
      (P := P) (X := X) (K := K) (c := c) hV hB hIndep hMGF ht
