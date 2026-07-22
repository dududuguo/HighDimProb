import HighDimProb.Concentration

open HighDimProb
open MeasureTheory

set_option autoImplicit false

#check @HighDimProb.Dudley.supremum
#check @HighDimProb.Dudley.entropyIntegrand
#check @HighDimProb.Dudley.entropyIntegral
#check @HighDimProb.Dudley.Inputs
#check @HighDimProb.Dudley.fullBound
#check @HighDimProb.Dudley.Inputs.bound

/-- External-user view: finite nets and chaining certificates are hidden
behind the bundled full-Dudley input contract. -/
example
    {Omega alpha : Type*} [MeasurableSpace Omega] [PseudoMetricSpace alpha]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {X : RandomProcess Omega alpha Real}
    {K : Set alpha} {t0 : alpha} {R sigma : Real}
    (h : HighDimProb.Dudley.Inputs P X K t0 R sigma) :
    Measurable (HighDimProb.Dudley.supremum X K t0) ∧
      Integrable (HighDimProb.Dudley.supremum X K t0) P ∧
        expect P (HighDimProb.Dudley.supremum X K t0) ≤
          4 * sigma * HighDimProb.Dudley.entropyIntegral K R :=
  h.bound
