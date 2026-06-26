import HighDimProb.RandomMatrix.MatrixLogProvider
import HighDimProb.RandomMatrix.HardboneStatements

/-!
# Log-order bridge for the Tropp trace-exp step

This module keeps the explicit provider-side log-order bridge used to decompose
the Tropp trace-exp step. The exact statement
`HighDimProb.matrixLog_le_of_le_matrixExp_statement` is already proved in the
main repository; the provider only keeps the hypothesis-level helper that
packages its operator-log contribution for downstream decomposition theorems.
-/

namespace HighDimProb

open scoped ComplexOrder MatrixOrder Matrix.Norms.Operator

noncomputable section

/-- Provider-side log-order bridge from `M <= exp K` to `log M <= K`.

This supplies HighDimProb's operator-log monotonicity premise from
`operatorLogMonotoneOnPositiveMatrices` and its log-domain premise from the main
`matrixExpLogDomainForSelfAdjoint`. It does not prove trace-exp monotonicity,
Lieb concavity, Golden-Thompson, or any Bernstein CFC fact. -/
theorem matrixLog_le_of_le_matrixExp_of_providerLogMonotone {n : Nat}
    (M K : Matrix (Fin n) (Fin n) Real)
    (hM : HighDimProb.IsSelfAdjointMatrix M)
    (hMpos : IsStrictlyPositive M)
    (hK : HighDimProb.IsSelfAdjointMatrix K)
    (hMK : HighDimProb.MatrixLE M (HighDimProb.matrixExp K)) :
    HighDimProb.MatrixLE (CFC.log M) K :=
  HighDimProb.matrixLog_le_of_le_matrixExp M K
    (operatorLogMonotoneOnPositiveMatrices M (HighDimProb.matrixExp K))
    (HighDimProb.matrixExpLogDomainForSelfAdjoint K)
    hM hMpos hK hMK

end

end HighDimProb