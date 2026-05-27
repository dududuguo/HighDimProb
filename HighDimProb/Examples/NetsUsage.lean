import HighDimProb.Nets

namespace HighDimProb

example {α : Type*} [PseudoMetricSpace α] (s net : Set α) (ε : ℝ) :
    IsEpsilonNet s net ε =
      Metric.IsCover (epsilonRadius ε) s net :=
  rfl

end HighDimProb
