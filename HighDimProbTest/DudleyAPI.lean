import HighDimProb.Concentration

namespace HighDimProbTest

open HighDimProb
open MeasureTheory

set_option autoImplicit false

#check @HighDimProb.Dudley.supremum
#check @HighDimProb.Dudley.entropyIntegral
#check @HighDimProb.Dudley.Inputs
#check @HighDimProb.Dudley.fullBound
#check @HighDimProb.Dudley.Inputs.bound

/-- Public-facade check for the bundled full-Dudley consumer. -/
example
    {Omega alpha : Type*} [MeasurableSpace Omega] [PseudoMetricSpace alpha]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {X : RandomProcess Omega alpha Real}
    {K : Set alpha} {t0 : alpha} {R sigma : Real}
    (h : HighDimProb.Dudley.Inputs P X K t0 R sigma) :
    Measurable (HighDimProb.Dudley.supremum X K t0) ∧
      Integrable (HighDimProb.Dudley.supremum X K t0) P ∧
        expect P (HighDimProb.Dudley.supremum X K t0) <=
          4 * sigma * HighDimProb.Dudley.entropyIntegral K R :=
  h.bound

end HighDimProbTest
