import HighDimProb.Basic

/-!
# Signal recovery vocabulary

Verified Wikipedia references:
* Signal processing: https://en.wikipedia.org/wiki/Signal_processing
* Compressed sensing: https://en.wikipedia.org/wiki/Compressed_sensing

Note: wiki.md listed `https://en.wikipedia.org/wiki/Signal_recovery`, but this
was not verified as a dedicated Wikipedia page.
-/

namespace HighDimProb

/--
A measurement map from signals to observations.

Formula reference: compressed sensing models recovering signals from
measurements; see https://en.wikipedia.org/wiki/Compressed_sensing
-/
abbrev MeasurementMap (Signal Observation : Type*) := Signal → Observation

/--
A reconstruction map from observations back to signals.

Formula reference: reconstruction maps observations back to candidate signals;
see https://en.wikipedia.org/wiki/Signal_processing
-/
abbrev ReconstructionMap (Observation Signal : Type*) := Observation → Signal

end HighDimProb
