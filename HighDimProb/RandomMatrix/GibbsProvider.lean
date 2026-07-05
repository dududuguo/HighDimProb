import HighDimProb.RandomMatrix.RelativeEntropyProvider
import HighDimProb.RandomMatrix.HardboneStatements

/-!
# Gibbs variational provider MVPs

Operational Gibbs inequalities for the relative-entropy route. The upper bound
keeps the Klein-style premise explicit; this module does not prove full Klein, a
supremum theorem, Epstein, Lieb, or Tropp.
-/

namespace HighDimProb

open scoped ComplexOrder MatrixOrder Matrix.Norms.Operator

/-- Gibbs objective upper bound from a Klein-style relative-entropy premise
against `matrixExp L`. -/
theorem gibbsObjective_le_traceMatrixExp_of_kleinPremise
    {n : Nat} (L T : Matrix (Fin n) (Fin n) Real)
    (hL : IsSelfAdjointMatrix L)
    (hKlein :
      0 <= Matrix.trace (T * CFC.log T)
        - Matrix.trace (T * CFC.log (matrixExp L))
        - Matrix.trace T
        + Matrix.trace (matrixExp L)) :
    Matrix.trace (T * L)
      - Matrix.trace (T * CFC.log T)
      + Matrix.trace T
      <= traceMatrixExp L := by
  rw [show traceMatrixExp L = Matrix.trace (matrixExp L) by rfl]
  rw [matrixExpLogSelfAdjointNormalization L hL] at hKlein
  linarith

/-- The Gibbs objective attains `traceMatrixExp L` at the witness
`T = matrixExp L`. -/
theorem gibbsObjective_eq_traceMatrixExp_at_matrixExp
    {n : Nat} (L : Matrix (Fin n) (Fin n) Real)
    (hL : IsSelfAdjointMatrix L) :
    Matrix.trace (matrixExp L * L)
      - Matrix.trace (matrixExp L * CFC.log (matrixExp L))
      + Matrix.trace (matrixExp L)
      = traceMatrixExp L := by
  rw [show traceMatrixExp L = Matrix.trace (matrixExp L) by rfl]
  rw [matrixExpLogSelfAdjointNormalization L hL]
  ring

end HighDimProb