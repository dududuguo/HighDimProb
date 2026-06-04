import Mathlib.Analysis.InnerProductSpace.PiL2
import HighDimProb.RandomMatrix.Basic

/-!
# Unit-vector vocabulary for random-matrix norm statements

This module uses the existing explicit finite-sum Euclidean convention instead
of introducing a full topological sphere API.
-/

namespace HighDimProb

open scoped BigOperators

noncomputable section

/-- Squared Euclidean norm of a deterministic finite vector. -/
def vectorSqNorm {n : Nat} (x : Fin n -> Real) : Real :=
  Finset.univ.sum fun i : Fin n => x i ^ 2

@[simp]
theorem vectorSqNorm_apply {n : Nat} (x : Fin n -> Real) :
    vectorSqNorm x = Finset.univ.sum fun i : Fin n => x i ^ 2 :=
  rfl

theorem vectorSqNorm_nonneg {n : Nat} (x : Fin n -> Real) :
    0 <= vectorSqNorm x :=
  Finset.sum_nonneg fun i _ => sq_nonneg (x i)

/-- Explicit squared norm agrees with Mathlib's L2 norm on `EuclideanSpace`. -/
theorem vectorSqNorm_eq_norm_sq_toLp {n : Nat} (x : Fin n -> Real) :
    vectorSqNorm x = norm (WithLp.toLp 2 x : EuclideanSpace Real (Fin n)) ^ 2 := by
  rw [EuclideanSpace.real_norm_sq_eq]
  simp [vectorSqNorm]

theorem norm_sq_toLp_eq_vectorSqNorm {n : Nat} (x : Fin n -> Real) :
    norm (WithLp.toLp 2 x : EuclideanSpace Real (Fin n)) ^ 2 = vectorSqNorm x :=
  (vectorSqNorm_eq_norm_sq_toLp x).symm

/-- Explicit unit-vector predicate: squared Euclidean norm is one. -/
def IsUnitVector {n : Nat} (x : Fin n -> Real) : Prop :=
  vectorSqNorm x = 1

/-- Unit sphere as a set of deterministic finite vectors. -/
def unitSphere (n : Nat) : Set (Fin n -> Real) :=
  {x | IsUnitVector x}

theorem mem_unitSphere_iff {n : Nat} (x : Fin n -> Real) :
    x ∈ unitSphere n ↔ IsUnitVector x :=
  Iff.rfl

theorem vectorSqNorm_eq_one_of_isUnitVector {n : Nat} {x : Fin n -> Real}
    (hx : IsUnitVector x) :
    vectorSqNorm x = 1 :=
  hx

theorem isUnitVector_vectorSqNorm_nonneg {n : Nat} {x : Fin n -> Real}
    (_hx : IsUnitVector x) :
    0 <= vectorSqNorm x :=
  vectorSqNorm_nonneg x

theorem norm_toLp_eq_one_of_isUnitVector {n : Nat} {x : Fin n -> Real}
    (hx : IsUnitVector x) :
    norm (WithLp.toLp 2 x : EuclideanSpace Real (Fin n)) = 1 := by
  have hsq : norm (WithLp.toLp 2 x : EuclideanSpace Real (Fin n)) ^ 2 = 1 := by
    rw [norm_sq_toLp_eq_vectorSqNorm, hx]
  have hnonneg : 0 <= norm (WithLp.toLp 2 x : EuclideanSpace Real (Fin n)) :=
    norm_nonneg _
  nlinarith

theorem isUnitVector_of_norm_toLp_eq_one {n : Nat} {x : Fin n -> Real}
    (hx : norm (WithLp.toLp 2 x : EuclideanSpace Real (Fin n)) = 1) :
    IsUnitVector x := by
  rw [IsUnitVector, vectorSqNorm_eq_norm_sq_toLp, hx]
  norm_num

end

end HighDimProb
