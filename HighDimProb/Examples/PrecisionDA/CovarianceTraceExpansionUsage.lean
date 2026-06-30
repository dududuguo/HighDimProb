import HighDimProb.Applications.PrecisionDA

/-!
# PrecisionDA covariance trace-expansion usage

This example is a downstream-facing deterministic consumer of the covariance
input trace-expansion theorem.  It shows that a user can start from symmetry of
`Σ` and obtain the named normalized-error / named trace-RHS equality without
opening any probability or concentration layer.
-/

namespace HighDimProb.Examples.PrecisionDA.CovarianceTraceExpansionUsage

open HighDimProb.PrecisionDA

noncomputable section

/--
Use the covariance-input theorem directly to rewrite the named shrinkage error
as the named trace-expansion RHS.
-/
theorem shrinkage_covariance_trace_expansion_usage {d n : Nat}
    (X : DataMatrix d n) (Sigma : SquareMatrix d) (lam : Real)
    (hSigma : Sigma.IsSymm) :
    shrinkageQuadraticError_of_covariance X Sigma lam =
      shrinkageQuadraticErrorTraceRHS_of_covariance X Sigma lam :=
  shrinkageQuadraticErrorTraceExpansion_of_covariance X Sigma lam hSigma

#check shrinkage_covariance_trace_expansion_usage

end

end HighDimProb.Examples.PrecisionDA.CovarianceTraceExpansionUsage