import HighDimProb.Concentration.DudleyEntropyIntegral

namespace HighDimProbTest

open HighDimProb MeasureTheory

set_option autoImplicit false

#check @HighDimProb.Dudley.entropyIntegrand
#check @HighDimProb.Dudley.entropyIntegral

example {alpha : Type*} [PseudoMetricSpace alpha]
    (K : Set alpha) (R : Real) :
    Dudley.entropyIntegral K R =
      ∫ t in 0..R, Dudley.entropyIntegrand K t :=
  rfl

end HighDimProbTest
