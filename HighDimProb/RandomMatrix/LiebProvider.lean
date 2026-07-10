import HighDimProb.RandomMatrix.Provider

/-!
# Legacy provider umbrella

This broad import is retained for compatibility with existing provider-era
consumers. New code should import `HighDimProb.RandomMatrix.Provider.Analysis`,
`HighDimProb.RandomMatrix.Provider.Conditioning`, or
`HighDimProb.RandomMatrix.Provider.Concentration` according to ownership, and
use `HighDimProb.RandomMatrix.Provider` only when all layers are required.

This compatibility module re-exports `HighDimProb.RandomMatrix.Provider` and
therefore preserves the previous analysis, conditioning, and concentration
surface. It owns no declarations and does not widen any theorem contract.
-/
