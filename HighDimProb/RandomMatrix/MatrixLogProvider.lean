import HighDimProb.RandomMatrix.CStarBridge
import HighDimProb.RandomMatrix.CStarOrderTransport
import HighDimProb.RandomMatrix.HardboneStatements

/-!
# Matrix-log provider facade

This module is the provider-layer import path for real-matrix logarithm order
facts.  The proof owners remain the lower-level modules:

- `CStarBridge` owns real-to-`CStarMatrix` transport and CFC log transport.
- `HardboneStatements` owns the public hardbone witnesses
  `operatorLogMonotoneOnPositiveMatrices`, `matrixExpLogDomainForSelfAdjoint`,
  and `matrixLog_le_of_le_matrixExp`.

Keeping this file as a facade prevents the provider layer from duplicating the
core declarations while giving downstream Lieb/Tropp modules a stable import.
-/

namespace HighDimProb

open scoped ComplexOrder MatrixOrder Matrix.Norms.Operator

noncomputable section

end

end HighDimProb