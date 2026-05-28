import HighDimProb.RandomMatrix.RowsCols
import HighDimProb.SubGaussianVector
import HighDimProb.Isotropic

/-!
# Random matrix assumption predicates
-/

namespace HighDimProb

open MeasureTheory

/-- Entrywise Orlicz subGaussian assumption with common scale `K`. -/
def SubGaussianEntriesOrlicz {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) (K : Real) : Prop :=
  forall i : Fin m, forall j : Fin n, SubGaussianOrlicz P (matrixEntry A i j) K

/-- Entrywise tail-form subGaussian assumption with common scale `K`. -/
def SubGaussianEntriesTail {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) (K : Real) : Prop :=
  forall i : Fin m, forall j : Fin n, SubGaussianTail P (matrixEntry A i j) K

/-- Rowwise Orlicz subGaussian assumption with common scale `K`. -/
def SubGaussianRowsOrlicz {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) (K : Real) : Prop :=
  forall i : Fin m, SubGaussianVectorOrlicz P (rowVector A i) K

/-- Each row is isotropic in the second-moment formulation. -/
def IsotropicRowsSecondMoment {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) : Prop :=
  forall i : Fin m, IsotropicSecondMoment P (rowVector A i)

/-- Each row is isotropic in the covariance formulation. -/
def IsotropicRowsCovariance {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) : Prop :=
  forall i : Fin m, IsotropicCovariance P (rowVector A i)

/-- Entrywise centeredness assumption. -/
def CenteredEntries {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) : Prop :=
  forall i : Fin m, forall j : Fin n, Centered P (matrixEntry A i j)

end HighDimProb
