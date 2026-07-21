import HighDimProb.RandomProcess.PathRegularity

set_option autoImplicit false

namespace HighDimProbTest

open HighDimProb
open Bornology

#check HighDimProb.HasContinuousSamplePathsOn
#check HighDimProb.HasUniformlyContinuousSamplePathsOn
#check HighDimProb.anchoredAbsIncrement
#check HighDimProb.uniformlyContinuousOn_anchoredAbsIncrement
#check HighDimProb.anchoredAbsIncrement_nonneg
#check HighDimProb.TotallyBounded.isBounded_image_of_uniformContinuousOn
#check HighDimProb.isBounded_anchoredAbsIncrement_image
#check HighDimProb.bddAbove_anchoredAbsIncrement_image
#check HighDimProb.HasContinuousSamplePathsOn.uniformlyContinuousSamplePathsOn_of_isCompact

variable {Omega T : Type*} [MeasurableSpace Omega] [PseudoMetricSpace T]
variable (X : RandomProcess Omega T Real) (K : Set T) (t0 : T) (omega : Omega)
variable (hX : HasUniformlyContinuousSamplePathsOn (fun t omega => X t omega) K)

example :
    UniformContinuousOn (fun t => X t omega) K :=
  hX omega

example :
    UniformContinuousOn (anchoredAbsIncrement (fun t omega => X t omega) t0 omega) K :=
  uniformlyContinuousOn_anchoredAbsIncrement hX t0 omega

example (t : T) :
    0 <= anchoredAbsIncrement (fun t omega => X t omega) t0 omega t :=
  anchoredAbsIncrement_nonneg (fun t omega => X t omega) t0 omega t

example (hK : TotallyBounded K) :
    IsBounded (anchoredAbsIncrement (fun t omega => X t omega) t0 omega '' K) :=
  isBounded_anchoredAbsIncrement_image hK hX t0 omega

example (hK : TotallyBounded K) :
    BddAbove (anchoredAbsIncrement (fun t omega => X t omega) t0 omega '' K) :=
  bddAbove_anchoredAbsIncrement_image hK hX t0 omega

example
    (hXc : HasContinuousSamplePathsOn (fun t omega => X t omega) K)
    (hK : IsCompact K) :
    HasUniformlyContinuousSamplePathsOn (fun t omega => X t omega) K :=
  hXc.uniformlyContinuousSamplePathsOn_of_isCompact hK

end HighDimProbTest
