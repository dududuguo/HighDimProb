import HighDimProb.Concentration.Dudley

namespace HighDimProbTest

open HighDimProb
open MeasureTheory

noncomputable section

#check HighDimProb.dudleyEntropyIntegral

example
    {Ω α : Type*} [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ} {K : Set α} {R σ : ℝ}
    (u : ℕ → K) (hu : DenseRange u) (anchor : K)
    (hAnchorNet : IsInternalEpsilonNet K ({(anchor : α)} : Set α) R)
    (hK : TotallyBounded K)
    (hXMeas : ∀ x, Measurable (X x))
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hσ : 0 < σ) (hR : 0 < R)
    (hPathCont : ∀ ω : Ω, Continuous
      (fun x : K => X (x : α) ω))
    (hPathBdd : ∀ ω : Ω, BddAbove
      (Set.range (fun x : K => |X (x : α) ω - X (anchor : α) ω|)))
    (hFullIntegrable : IntegrableRealRandomVariable P
      (fun ω => ⨆ x : K, |X (x : α) ω - X (anchor : α) ω|))
    (hEntropyIntegrable : IntervalIntegrable
      (fun t => Real.sqrt (2 * Real.log
        (2 * ((coveringNumber K t).toNat : ℝ)))) volume 0 R) :
    expect P (fun ω => ⨆ x : K, |X (x : α) ω - X (anchor : α) ω|) ≤
      4 * σ *
        (∫ t in (0 : ℝ)..R,
          Real.sqrt (2 * Real.log
            (2 * ((coveringNumber K t).toNat : ℝ)))) := by
  exact dudleyEntropyIntegral u hu anchor hAnchorNet hK hXMeas hX hσ hR
    hPathCont hPathBdd hFullIntegrable hEntropyIntegrable

end

end HighDimProbTest
