import HighDimProb.Concentration.DudleyFull

namespace HighDimProbTest

open HighDimProb MeasureTheory

set_option autoImplicit false

#check @HighDimProb.dudleySupremum
#check @HighDimProb.dudley_full_supremum_bound

example
    {Omega alpha : Type*} [MeasurableSpace Omega] [PseudoMetricSpace alpha]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {X : RandomProcess Omega alpha Real}
    {K : Set alpha} {t0 : alpha} {R sigma : Real}
    (hK : TotallyBounded K) (ht0 : t0 ∈ K) (hR : 0 < R)
    (hdist : ∀ t ∈ K, dist t t0 ≤ R)
    (hXMeas : ∀ t, Measurable (X t))
    (hX : HasSubGaussianMGFIncrements P X sigma) (hsigma : 0 < sigma)
    (hPath : HasUniformlyContinuousSamplePathsOn
      (fun t omega => X t omega) K)
    (hEntropy : IntervalIntegrable (dudleyEntropyIntegrand K) volume 0 R) :
    Measurable (dudleySupremum X K t0) ∧
      Integrable (dudleySupremum X K t0) P ∧
        expect P (dudleySupremum X K t0) ≤
          4 * sigma * dudleyEntropyIntegral K R :=
  dudley_full_supremum_bound hK ht0 hR hdist hXMeas hX hsigma hPath hEntropy

end HighDimProbTest
