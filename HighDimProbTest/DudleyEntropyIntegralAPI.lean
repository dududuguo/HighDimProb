import HighDimProb.Concentration.Dudley
import HighDimProb.Concentration.DudleyEntropyIntegral

namespace HighDimProbTest

open HighDimProb MeasureTheory

set_option autoImplicit false

#check @HighDimProb.Dudley.entropyIntegrand
#check @HighDimProb.Dudley.entropyIntegral
#check @HighDimProb.dudleyEntropyIntegral

example {alpha : Type*} [PseudoMetricSpace alpha]
    (K : Set alpha) (R : Real) :
    Dudley.entropyIntegral K R =
      ∫ t in 0..R, Dudley.entropyIntegrand K t :=
  rfl

example
    {Omega alpha : Type*} [MeasurableSpace Omega] [PseudoMetricSpace alpha]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {X : RandomProcess Omega alpha Real} {K : Set alpha} {R sigma : Real}
    (u : Nat -> K) (hu : DenseRange u) (anchor : K)
    (hAnchorNet : IsInternalEpsilonNet K ({(anchor : alpha)} : Set alpha) R)
    (hK : TotallyBounded K)
    (hXMeas : forall x, Measurable (X x))
    (hX : HasSubGaussianMGFIncrements P X sigma)
    (hSigma : 0 < sigma) (hR : 0 < R)
    (hPathCont : forall omega : Omega, Continuous
      (fun x : K => X (x : alpha) omega))
    (hPathBdd : forall omega : Omega, BddAbove
      (Set.range (fun x : K => |X (x : alpha) omega - X (anchor : alpha) omega|)))
    (hFullIntegrable : IntegrableRealRandomVariable P
      (fun omega => ⨆ x : K, |X (x : alpha) omega - X (anchor : alpha) omega|))
    (hEntropyIntegrable : IntervalIntegrable
      (fun t => Real.sqrt (2 * Real.log
        (2 * ((coveringNumber K t).toNat : Real)))) volume 0 R) :
    expect P (fun omega => ⨆ x : K,
        |X (x : alpha) omega - X (anchor : alpha) omega|) <=
      4 * sigma *
        (∫ t in (0 : Real)..R,
          Real.sqrt (2 * Real.log
            (2 * ((coveringNumber K t).toNat : Real)))) := by
  exact dudleyEntropyIntegral u hu anchor hAnchorNet hK hXMeas hX hSigma hR
    hPathCont hPathBdd hFullIntegrable hEntropyIntegrable

end HighDimProbTest
