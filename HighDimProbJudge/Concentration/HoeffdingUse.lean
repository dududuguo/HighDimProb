import HighDimProb.Concentration

open scoped BigOperators

#check HighDimProb.hoeffding_sum_bounded
#check HighDimProb.hoeffding_weighted_sum_bounded

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {X : I -> HighDimProb.RealRandomVariable Omega} {a b : I -> Real}
    (hpos : 0 < ∑ i : I, (b i - a i) ^ 2)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hX : ∀ i : I, HighDimProb.IsRealRandomVariable P (X i))
    (hInt : ∀ i : I, HighDimProb.IntegrableRealRandomVariable P (X i))
    (hmem : ∀ i : I, ∀ᵐ omega ∂P, X i omega ∈ Set.Icc (a i) (b i))
    (hwidth : ∀ i : I, 0 < b i - a i)
    {t : Real} (ht : 0 <= t) :
    HighDimProb.absTailProb P
      (fun omega => (∑ i : I, X i omega) -
        HighDimProb.expect P (fun omega => ∑ i : I, X i omega)) t <=
      ENNReal.ofReal
        (2 * Real.exp (-(2 * t ^ 2 / ∑ i : I, (b i - a i) ^ 2))) := by
  exact
    HighDimProb.hoeffding_sum_bounded
      (P := P) (X := X) (a := a) (b := b)
      hpos hIndep hX hInt hmem hwidth ht

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {X : I -> HighDimProb.RealRandomVariable Omega} {a b c : I -> Real}
    (hpos : 0 < ∑ i : I, (c i) ^ 2 * (b i - a i) ^ 2)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hX : ∀ i : I, HighDimProb.IsRealRandomVariable P (X i))
    (hInt : ∀ i : I, HighDimProb.IntegrableRealRandomVariable P (X i))
    (hmem : ∀ i : I, ∀ᵐ omega ∂P, X i omega ∈ Set.Icc (a i) (b i))
    (hwidth : ∀ i : I, 0 < b i - a i)
    {t : Real} (ht : 0 <= t) :
    HighDimProb.absTailProb P
      (fun omega => (∑ i : I, c i * X i omega) -
        HighDimProb.expect P (fun omega => ∑ i : I, c i * X i omega)) t <=
      ENNReal.ofReal
        (2 * Real.exp
          (-(2 * t ^ 2 / ∑ i : I, (c i) ^ 2 * (b i - a i) ^ 2))) := by
  exact
    HighDimProb.hoeffding_weighted_sum_bounded
      (P := P) (X := X) (a := a) (b := b) (c := c)
      hpos hIndep hX hInt hmem hwidth ht
