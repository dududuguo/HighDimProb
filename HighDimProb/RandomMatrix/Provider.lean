import HighDimProb.RandomMatrix.Provider.Analysis
import HighDimProb.RandomMatrix.Provider.Conditioning
import HighDimProb.RandomMatrix.Provider.Concentration

/-!
# RandomMatrix provider facade

This is the broad provider-facing import for the supported finite-dimensional
RandomMatrix theorem pipeline. The implementation is split into three
dependency-ordered layers:

* `Provider.Analysis`: deterministic matrix analysis;
* `Provider.Conditioning`: conditional expectation and natural histories;
* `Provider.Concentration`: trace-MGF, tail, and Matrix Bernstein assembly.

Most downstream code should import the narrowest layer that owns the API it
uses. `HighDimProb.RandomMatrix.LiebProvider` remains the historical broad
compatibility import.
-/
