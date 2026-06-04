import Mathlib.LinearAlgebra.Matrix.Hermitian
import Mathlib.LinearAlgebra.Matrix.Symmetric
import HighDimProb.RandomMatrix.Basic

/-!
# Symmetric and self-adjoint real matrix vocabulary

This file keeps the real square-matrix vocabulary thin. `IsSymmetricMatrix`
wraps Mathlib's transpose equality `Matrix.IsSymm`, while
`IsSelfAdjointMatrix` wraps Mathlib's Hermitian/self-adjoint matrix predicate.
For the current real-valued branch these are kept as separate names so future
complex Hermitian work does not silently change theorem statements.
-/

namespace HighDimProb

open MeasureTheory

/-- Real square matrix symmetry, backed by Mathlib `Matrix.IsSymm`. -/
abbrev IsSymmetricMatrix {n : Nat} (A : Matrix (Fin n) (Fin n) Real) : Prop :=
  A.IsSymm

/-- Real square matrix self-adjointness, backed by Mathlib `Matrix.IsHermitian`. -/
abbrev IsSelfAdjointMatrix {n : Nat} (A : Matrix (Fin n) (Fin n) Real) : Prop :=
  A.IsHermitian

/-- Pointwise symmetric random square matrix. The measure parameter is present
for consistency with other HighDimProb random-matrix predicates. -/
def RandomSymmetricMatrix {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (_P : Measure Omega) (A : RandomMatrix Omega n n) : Prop :=
  forall omega, IsSymmetricMatrix (A omega)

/-- Pointwise self-adjoint random square matrix. The measure parameter is present
for consistency with other HighDimProb random-matrix predicates. -/
def RandomSelfAdjointMatrix {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (_P : Measure Omega) (A : RandomMatrix Omega n n) : Prop :=
  forall omega, IsSelfAdjointMatrix (A omega)

theorem isSymmetricMatrix_apply {n : Nat} {A : Matrix (Fin n) (Fin n) Real}
    (hA : IsSymmetricMatrix A) (i j : Fin n) :
    A j i = A i j :=
  Matrix.IsSymm.apply hA i j

theorem randomSymmetricMatrix_apply {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} {A : RandomMatrix Omega n n}
    (hA : RandomSymmetricMatrix P A) (omega : Omega) :
    IsSymmetricMatrix (A omega) :=
  hA omega

theorem randomSelfAdjointMatrix_apply {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} {A : RandomMatrix Omega n n}
    (hA : RandomSelfAdjointMatrix P A) (omega : Omega) :
    IsSelfAdjointMatrix (A omega) :=
  hA omega

end HighDimProb
