import HighDimProb.Basic

/-!
# Signal recovery vocabulary
-/

namespace HighDimProb

/-- A measurement map from signals to observations. -/
abbrev MeasurementMap (Signal Observation : Type*) := Signal → Observation

/-- A reconstruction map from observations back to signals. -/
abbrev ReconstructionMap (Observation Signal : Type*) := Observation → Signal

end HighDimProb
