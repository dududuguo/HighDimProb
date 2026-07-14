import HighDimProb.Concentration.FiniteMax

namespace HighDimProbTest

open HighDimProb
open MeasureTheory

#check exp_mul_processSup_le_sum
#check expect_le_log_mgf
#check expect_processSup_le_of_cgf_bound_at

noncomputable section

example {Omega T : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {X : RandomProcess Omega T Real} {s : Finset T} (hs : s.Nonempty)
    {theta a : Real} (hTheta : 0 < theta)
    (hXMeas : forall t, t ∈ s -> Measurable (X t))
    (hXInt : forall t, t ∈ s -> IntegrableRealRandomVariable P (X t))
    (hXCgf : forall t, t ∈ s -> ProbabilityTheory.cgf (X t) P theta <= a)
    (hXExpInt : forall t, t ∈ s ->
      IntegrableRealRandomVariable P
        (fun omega => Real.exp (theta * X t omega))) :
    expect P (processSup X s hs) <=
      (1 / theta) * (Real.log (s.card : Real) + a) :=
  expect_processSup_le_of_cgf_bound_at hs hTheta hXMeas hXInt hXCgf hXExpInt

end

end HighDimProbTest
