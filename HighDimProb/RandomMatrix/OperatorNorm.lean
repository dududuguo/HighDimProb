import Mathlib.Analysis.CStarAlgebra.Matrix
import HighDimProb.RandomMatrix.Action
import HighDimProb.RandomMatrix.UnitSphere

/-!
# Operator norm vocabulary for random matrices

This module uses Mathlib's `Matrix.Norms.L2Operator` scoped norm, i.e. the norm transported from
continuous linear maps between finite-dimensional Euclidean spaces. It is kept in its own
experimental submodule so the rest of the random-matrix layer does not accidentally depend on a
matrix norm convention.
-/

namespace HighDimProb

open MeasureTheory
open scoped Matrix.Norms.L2Operator

noncomputable section

/-- The scoped L2 operator-norm topology on finite real matrices has open sets
measurable for the existing product measurable-space convention. -/
instance instOpensMeasurableSpaceMatrixL2Operator {m n : Nat} :
    OpensMeasurableSpace (Matrix (Fin m) (Fin n) Real) := by
  change OpensMeasurableSpace (Fin m -> Fin n -> Real)
  infer_instance

/-- Spectral/operator norm random variable for a real random matrix. -/
def operatorNorm {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) : RealRandomVariable Omega :=
  fun omega => ‖A omega‖

@[simp]
theorem operatorNorm_apply {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (omega : Omega) :
    operatorNorm A omega = ‖A omega‖ :=
  rfl

/-- Deterministic version of the scoped L2 matrix operator norm. -/
def deterministicOperatorNorm {m n : Nat}
    (A : Matrix (Fin m) (Fin n) Real) : Real :=
  norm A

@[simp]
theorem deterministicOperatorNorm_apply {m n : Nat}
    (A : Matrix (Fin m) (Fin n) Real) :
    deterministicOperatorNorm A = norm A :=
  rfl

/-- Squared Euclidean norm of the deterministic matrix-vector product. -/
def matVecSqNorm {m n : Nat} (A : Matrix (Fin m) (Fin n) Real)
    (x : Fin n -> Real) : Real :=
  vectorSqNorm (fun i : Fin m => Finset.univ.sum fun j : Fin n => A i j * x j)

@[simp]
theorem matVecSqNorm_apply {m n : Nat} (A : Matrix (Fin m) (Fin n) Real)
    (x : Fin n -> Real) :
    matVecSqNorm A x =
      Finset.univ.sum fun i : Fin m =>
        (Finset.univ.sum fun j : Fin n => A i j * x j) ^ 2 :=
  rfl

theorem matVecSqNorm_nonneg {m n : Nat} (A : Matrix (Fin m) (Fin n) Real)
    (x : Fin n -> Real) :
    0 <= matVecSqNorm A x :=
  vectorSqNorm_nonneg _

/-- Explicit matrix-vector squared norm agrees with Mathlib's L2 norm after
viewing the output vector as Euclidean space. -/
theorem matVecSqNorm_eq_norm_sq_toLp_mulVec {m n : Nat}
    (A : Matrix (Fin m) (Fin n) Real) (x : Fin n -> Real) :
    matVecSqNorm A x =
      norm ((EuclideanSpace.equiv (Fin m) Real).symm (Matrix.mulVec A x) :
        EuclideanSpace Real (Fin m)) ^ 2 := by
  rw [EuclideanSpace.real_norm_sq_eq]
  simp [matVecSqNorm, vectorSqNorm, Matrix.mulVec, dotProduct]

theorem norm_sq_toLp_mulVec_eq_matVecSqNorm {m n : Nat}
    (A : Matrix (Fin m) (Fin n) Real) (x : Fin n -> Real) :
    norm ((EuclideanSpace.equiv (Fin m) Real).symm (Matrix.mulVec A x) :
      EuclideanSpace Real (Fin m)) ^ 2 = matVecSqNorm A x :=
  (matVecSqNorm_eq_norm_sq_toLp_mulVec A x).symm

/-- Random-variable version of deterministic matrix-vector squared norm. -/
def randomMatVecSqNorm {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (x : Fin n -> Real) : RealRandomVariable Omega :=
  fun omega => matVecSqNorm (A omega) x

@[simp]
theorem randomMatVecSqNorm_apply {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (A : RandomMatrix Omega m n) (x : Fin n -> Real)
    (omega : Omega) :
    randomMatVecSqNorm A x omega = matVecSqNorm (A omega) x :=
  rfl

/-- The explicit random-vector squared norm of `matVec` is the deterministic
matrix-vector squared norm at each sample. -/
theorem sqNorm_matVec_eq_matVecSqNorm {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (A : RandomMatrix Omega m n) (x : Fin n -> Real)
    (omega : Omega) :
    sqNorm (matVec A x) omega = matVecSqNorm (A omega) x :=
  rfl

theorem isRealRandomVariable_randomMatVecSqNorm {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {A : RandomMatrix Omega m n}
    (hA : IsRandomMatrix P A) (x : Fin n -> Real) :
    IsRealRandomVariable P (randomMatVecSqNorm A x) := by
  simpa [randomMatVecSqNorm] using isRealRandomVariable_sqNorm (isRandomVector_matVec hA x)

/-- Explicit squared operator-norm upper-bound predicate, avoiding the exact
Mathlib operator-norm bridge. -/
def OperatorNormBoundSq {m n : Nat} (A : Matrix (Fin m) (Fin n) Real)
    (L : Real) : Prop :=
  0 <= L /\ forall x : Fin n -> Real, IsUnitVector x -> matVecSqNorm A x <= L ^ 2

/-- Pointwise explicit squared operator-norm upper-bound predicate for random matrices. -/
def RandomOperatorNormBoundSq {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (A : RandomMatrix Omega m n) (L : Real) : Prop :=
  forall omega, OperatorNormBoundSq (A omega) L

theorem operatorNormBoundSq_nonneg {m n : Nat}
    {A : Matrix (Fin m) (Fin n) Real} {L : Real}
    (hA : OperatorNormBoundSq A L) :
    0 <= L :=
  hA.1

theorem matVecSqNorm_le_of_operatorNormBoundSq {m n : Nat}
    {A : Matrix (Fin m) (Fin n) Real} {L : Real}
    (hA : OperatorNormBoundSq A L) {x : Fin n -> Real}
    (hx : IsUnitVector x) :
    matVecSqNorm A x <= L ^ 2 :=
  hA.2 x hx

/-- Mathlib's scoped L2 matrix operator-norm bound implies the explicit
squared unit-vector bound predicate. -/
theorem operatorNormBoundSq_of_operatorNorm_le {m n : Nat}
    {A : Matrix (Fin m) (Fin n) Real} {L : Real}
    (hL_nonneg : 0 <= L) (hA : deterministicOperatorNorm A <= L) :
    OperatorNormBoundSq A L := by
  refine ⟨hL_nonneg, ?_⟩
  intro x hx
  have hxnorm :
      norm (WithLp.toLp 2 x : EuclideanSpace Real (Fin n)) = 1 :=
    norm_toLp_eq_one_of_isUnitVector hx
  have hmul :=
    Matrix.l2_opNorm_mulVec A (WithLp.toLp 2 x : EuclideanSpace Real (Fin n))
  have hnorm :
      norm ((EuclideanSpace.equiv (Fin m) Real).symm (Matrix.mulVec A x) :
        EuclideanSpace Real (Fin m)) <= L := by
    have hnormA : norm A <= L := by
      simpa [deterministicOperatorNorm] using hA
    have hmul' :
        norm ((EuclideanSpace.equiv (Fin m) Real).symm (Matrix.mulVec A x) :
          EuclideanSpace Real (Fin m)) <= norm A := by
      simpa [hxnorm] using hmul
    exact hmul'.trans hnormA
  rw [matVecSqNorm_eq_norm_sq_toLp_mulVec]
  have hnonneg :
      0 <= norm ((EuclideanSpace.equiv (Fin m) Real).symm (Matrix.mulVec A x) :
        EuclideanSpace Real (Fin m)) :=
    norm_nonneg _
  nlinarith

/-- The explicit squared unit-vector bound predicate controls Mathlib's scoped
L2 matrix operator norm. -/
theorem operatorNorm_le_of_operatorNormBoundSq {m n : Nat}
    {A : Matrix (Fin m) (Fin n) Real} {L : Real}
    (hA : OperatorNormBoundSq A L) :
    deterministicOperatorNorm A <= L := by
  rw [deterministicOperatorNorm, Matrix.l2_opNorm_def]
  refine ContinuousLinearMap.opNorm_le_of_unit_norm hA.1 fun x hx => ?_
  have hxUnit : IsUnitVector (WithLp.ofLp x) := by
    apply isUnitVector_of_norm_toLp_eq_one
    simpa using hx
  have hsq :
      norm ((EuclideanSpace.equiv (Fin m) Real).symm
          (Matrix.mulVec A (WithLp.ofLp x)) : EuclideanSpace Real (Fin m)) ^ 2 <=
        L ^ 2 := by
    rw [norm_sq_toLp_mulVec_eq_matVecSqNorm]
    exact hA.2 _ hxUnit
  have htarget :
      norm (((Matrix.toEuclideanLin (𝕜 := Real) (m := Fin m) (n := Fin n)).trans
          LinearMap.toContinuousLinearMap) A x) ^ 2 <= L ^ 2 := by
    simpa [Matrix.toLpLin_apply] using hsq
  exact le_of_sq_le_sq htarget hA.1

/-- Entrywise random-matrix measurability makes the scoped L2 operator norm a
real random variable. -/
theorem isRealRandomVariable_operatorNorm {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {A : RandomMatrix Omega m n}
    (hA : IsRandomMatrix P A) :
    IsRealRandomVariable P (operatorNorm A) := by
  dsimp [IsRealRandomVariable, IsRandomVariable, operatorNorm]
  exact measurable_norm.comp (measurable_randomMatrix_of_isRandomMatrix hA)

/-- Typed target for the future exact bridge from explicit squared bounds to
Mathlib's scoped L2 operator norm. -/
def operatorNorm_le_of_operatorNormBoundSqStatement {m n : Nat}
    (A : Matrix (Fin m) (Fin n) Real) (L : Real) : Prop :=
  OperatorNormBoundSq A L -> deterministicOperatorNorm A <= L

/-- Typed target for the future reverse bridge from Mathlib's scoped L2 operator
norm to explicit squared unit-vector bounds. -/
def operatorNormBoundSq_of_operatorNorm_leStatement {m n : Nat}
    (A : Matrix (Fin m) (Fin n) Real) (L : Real) : Prop :=
  0 <= L -> deterministicOperatorNorm A <= L -> OperatorNormBoundSq A L

/-- Typed target for the future measurability bridge for Mathlib's scoped L2
operator norm. -/
def operatorNormMeasurabilityStatement {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (P : Measure Omega) (A : RandomMatrix Omega m n) : Prop :=
  IsRandomMatrix P A -> IsRealRandomVariable P (operatorNorm A)

end

end HighDimProb
