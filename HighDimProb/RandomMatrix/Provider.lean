import HighDimProb.RandomMatrix.Provider.Analysis
import HighDimProb.RandomMatrix.Provider.Conditioning
import HighDimProb.RandomMatrix.Provider.Concentration

/-!
# RandomMatrix internal provider facade

This is the broad expert import for provider-proof development in the supported
finite-dimensional RandomMatrix theorem pipeline. The internal implementation
is split into three dependency-ordered layers:

* `Provider.Analysis`: deterministic matrix analysis;
* `Provider.Conditioning`: conditional expectation and natural histories;
* `Provider.Concentration`: trace-MGF, tail, and Matrix Bernstein assembly.

Ordinary matrix-concentration applications and downstream users should import
`HighDimProb.RandomMatrix.Concentration`, not this provider hierarchy. Expert
proof development should import the narrowest provider layer it needs.
`HighDimProb.RandomMatrix.LiebProvider` remains the historical broad
compatibility import and owns no new API.
-/
