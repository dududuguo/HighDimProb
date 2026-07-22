import HighDimProb.Concentration

/-!
# Full Dudley usage

This example uses the bundled public consumer. Finite nets, parent maps, and
chaining certificates remain implementation details of the concentration
branch.
-/

namespace HighDimProb.Examples.DudleyUsage

open MeasureTheory

set_option autoImplicit false

noncomputable section

/-- A downstream process enters the full Dudley theorem through one input
bundle and receives measurability, integrability, and the entropy bound. -/
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

end

end HighDimProb.Examples.DudleyUsage
