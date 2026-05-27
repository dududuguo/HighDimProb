import HighDimProb.Nets
import HighDimProb.MetricEntropy

open HighDimProb

noncomputable section

variable {α : Type*} [PseudoMetricSpace α]
variable (K N : Set α)
variable (ε : ℝ)

#check epsilonRadius
#check epsilonERadius
#check IsEpsilonNet
#check IsInternalEpsilonNet
#check IsEpsilonSeparated
#check externalCoveringNumber
#check coveringNumber
#check packingNumber

example :
    IsEpsilonNet K N ε = Metric.IsCover (epsilonRadius ε) K N :=
  rfl

example :
    IsInternalEpsilonNet K N ε = (N ⊆ K ∧ IsEpsilonNet K N ε) :=
  rfl

example :
    IsEpsilonSeparated N ε = Metric.IsSeparated (epsilonERadius ε) N :=
  rfl

example :
    externalCoveringNumber K ε = Metric.externalCoveringNumber (epsilonRadius ε) K :=
  rfl

example :
    coveringNumber K ε = Metric.coveringNumber (epsilonRadius ε) K :=
  rfl

example :
    packingNumber K ε = Metric.packingNumber (epsilonRadius ε) K :=
  rfl

end
