import HighDimProb.Applications.PrecisionDA

/-!
# PrecisionDA covariance trace-expansion judge usage

This judge file checks that downstream users can consume the deterministic
covariance-input trace expansion through the named PrecisionDA error and RHS
wrappers.  It intentionally does not introduce probability or concentration
assumptions.
-/

namespace HighDimProbJudge.PrecisionDA.CovarianceTraceExpansionUse

open HighDimProb.PrecisionDA

noncomputable section

/-- Downstream use of the covariance-input deterministic trace expansion. -/
theorem shrinkage_covariance_trace_expansion_judge_use {d n : Nat}
    (X : DataMatrix d n) (Sigma : SquareMatrix d) (lam : Real)
    (hSigma : Sigma.IsSymm) :
    shrinkageQuadraticError_of_covariance X Sigma lam =
      shrinkageQuadraticErrorTraceRHS_of_covariance X Sigma lam :=
  shrinkageQuadraticErrorTraceExpansion_of_covariance X Sigma lam hSigma

#check shrinkage_covariance_trace_expansion_judge_use
#check HighDimProb.PrecisionDA.shrinkageQuadraticErrorTraceExpansion_of_covariance

end

end HighDimProbJudge.PrecisionDA.CovarianceTraceExpansionUse