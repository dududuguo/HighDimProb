import HighDimProb.Concentration.SubGaussianMax

namespace HighDimProbTest

open HighDimProb
open MeasureTheory

noncomputable section

#check expect_processSup_le_of_centeredSubGaussianMGF

example {Omega T : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {X : RandomProcess Omega T Real} {s : Finset T} (hs : s.Nonempty)
    (hs_card : 2 ≤ s.card)
    {K : Real}
    (hXMeas : ∀ t, t ∈ s → Measurable (X t))
    (hXSG : ∀ t, t ∈ s → CenteredSubGaussianMGF P (X t) K) :
    expect P (processSup X s hs) <=
      K * Real.sqrt (2 * Real.log (s.card : Real)) := by
  exact expect_processSup_le_of_centeredSubGaussianMGF
    hs hs_card hXMeas hXSG

end

end HighDimProbTest
