import HighDimProb.Concentration

open MeasureTheory ProbabilityTheory Real

set_option autoImplicit false

#check HighDimProb.HansonWright.hansonWrightUniversalConstant
#check HighDimProb.HansonWright.hansonWrightUniversalConstant_pos

example {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} [IsProbabilityMeasure mu]
    {n : Nat} {A : Matrix (Fin n) (Fin n) Real} {X : Fin n -> Omega -> Real}
    {K : Real} (hK : 0 < K)
    (hIndep : iIndepFun X mu)
    (hSubGaussian :
      forall i, HasSubgaussianMGF (X i) ⟨K ^ 2, sq_nonneg K⟩ mu) :
    forall t : Real, 0 <= t ->
      (mu {omega | t <=
        |HighDimProb.HansonWright.centeredQuadraticForm mu A X omega|}).toReal <=
        2 * exp (-HighDimProb.HansonWright.hansonWrightUniversalConstant *
          min
            (t ^ 2 /
              (K ^ 4 *
                HighDimProb.HansonWright.deterministicFrobeniusNorm A ^ 2))
            (t /
              (K ^ 2 * HighDimProb.deterministicOperatorNorm A))) := by
  exact
    HighDimProb.HansonWright.hanson_wright_inequality_hdp_explicit_constant
      hK hIndep hSubGaussian
