import HighDimProb.RandomMatrix.TraceExp

/-!
# Reindexed Tropp bridge usage

This examples-only file shows how to transport an existing finite-family Tropp
statement from the canonical `Fin (Fintype.card I)` indexing back to an
arbitrary finite index type. It does not prove the Tropp primitive.
-/

namespace HighDimProb.Examples.RandomMatrix.ReindexedTroppBridgeUsage

open MeasureTheory

noncomputable section

/-- Example-local name for the canonical `Fin (Fintype.card I)` reindexing of
an arbitrary finite random-matrix family. -/
abbrev reindexedRandomMatrixFamily {Omega I : Type*} [MeasurableSpace Omega]
    [Fintype I] {n : Nat}
    (X : I -> RandomMatrix Omega n n) :
    Fin (Fintype.card I) -> RandomMatrix Omega n n :=
  fun j => X ((Fintype.equivFin I).symm j)

/-- Example-local name for the canonical `Fin (Fintype.card I)` reindexing of
an arbitrary finite deterministic comparison family. -/
abbrev reindexedComparisonMatrixFamily {I : Type*} [Fintype I] {n : Nat}
    (K : I -> Matrix (Fin n) (Fin n) Real) :
    Fin (Fintype.card I) -> Matrix (Fin n) (Fin n) Real :=
  fun j => K ((Fintype.equivFin I).symm j)

/-- Transport a reindexed-`Fin` Tropp primitive through the existing bridge. -/
theorem reindexedTroppBridge_usage {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {I : Type*} [Fintype I] {n : Nat}
    (X : I -> RandomMatrix Omega n n)
    (K : I -> Matrix (Fin n) (Fin n) Real)
    (V : Matrix (Fin n) (Fin n) Real) (theta R : Real)
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement (P := P)
        (reindexedRandomMatrixFamily X)
        (reindexedComparisonMatrixFamily K)
        V theta R) :
    troppMasterTraceMGFFiniteFamily_statement (P := P) X K V theta R := by
  exact
    troppMasterTraceMGFFiniteFamily_statement_of_reindexedFin
      X K V theta R hTropp

end

end HighDimProb.Examples.RandomMatrix.ReindexedTroppBridgeUsage
