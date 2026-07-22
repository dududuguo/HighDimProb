import HighDimProb.Concentration

namespace HighDimProbTest

open HighDimProb MeasureTheory

set_option autoImplicit false

#check @HighDimProb.Dudley.supremum
#check @HighDimProb.Dudley.entropyIntegrand
#check @HighDimProb.Dudley.entropyIntegral
#check @HighDimProb.Dudley.Inputs
#check @HighDimProb.Dudley.fullBound
#check @HighDimProb.Dudley.Inputs.bound

example
    {Omega alpha : Type*} [MeasurableSpace Omega] [PseudoMetricSpace alpha]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {X : RandomProcess Omega alpha Real}
    {K : Set alpha} {t0 : alpha} {R sigma : Real}
    (hK : TotallyBounded K) (ht0 : t0 ∈ K) (hR : 0 < R)
    (hdist : forall t, t ∈ K -> dist t t0 ≤ R)
    (hXMeas : forall t, Measurable (X t))
    (hX : HasSubGaussianMGFIncrements P X sigma) (hsigma : 0 < sigma)
    (hPath : HasUniformlyContinuousSamplePathsOn
      (fun t omega => X t omega) K)
    (hEntropy : IntervalIntegrable (Dudley.entropyIntegrand K) volume 0 R) :
    Measurable (Dudley.supremum X K t0) ∧
      Integrable (Dudley.supremum X K t0) P ∧
        expect P (Dudley.supremum X K t0) ≤
          4 * sigma * Dudley.entropyIntegral K R :=
  Dudley.fullBound hK ht0 hR hdist hXMeas hX hsigma hPath hEntropy

example
    {Omega alpha : Type*} [MeasurableSpace Omega] [PseudoMetricSpace alpha]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {X : RandomProcess Omega alpha Real}
    {K : Set alpha} {t0 : alpha} {R sigma : Real}
    (h : Dudley.Inputs P X K t0 R sigma) :
    Measurable (Dudley.supremum X K t0) ∧
      Integrable (Dudley.supremum X K t0) P ∧
        expect P (Dudley.supremum X K t0) ≤
          4 * sigma * Dudley.entropyIntegral K R :=
  h.bound

end HighDimProbTest
