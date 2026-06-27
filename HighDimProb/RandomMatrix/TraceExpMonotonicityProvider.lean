import HighDimProb.RandomMatrix.HardboneStatements
import HighDimProb.RandomMatrix.TraceExpMonotonicity

/-!
# Trace-exponential monotonicity provider facade

This module is the provider-layer import path for deterministic trace-exponential
monotonicity.  The reusable analytic proof lives in `TraceExpMonotonicity`, and
the public hardbone witness `traceMatrixExp_mono_add_selfAdjoint` lives in
`HardboneStatements`.

The facade deliberately introduces no parallel theorem name: downstream modules
should reuse the existing public witness through this import path.
-/

namespace HighDimProb

open scoped MatrixOrder

noncomputable section

end

end HighDimProb