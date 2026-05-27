import HighDimProb.RandomVariable

/-!
# Finite-dimensional random vectors

The concrete model is `Ω → Fin n → ℝ`. Coordinates, finite linear
marginals, and norm random variables are exposed as unbundled functions.
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators

noncomputable section

/-- An `n`-dimensional real random vector. -/
abbrev RandomVector (Ω : Type*) [MeasurableSpace Ω] (n : ℕ) :=
  RandomVariable Ω (Fin n → ℝ)

/-- Coordinatewise measurability predicate for finite-dimensional random vectors. -/
abbrev IsRandomVector {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) : Prop :=
  ∀ i : Fin n, IsRealRandomVariable P (fun ω => X ω i)

/-- Coordinate random variable of a finite-dimensional random vector. -/
def coord {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (X : RandomVector Ω n) (i : Fin n) : RealRandomVariable Ω :=
  fun ω => X ω i

/-- Backward-compatible name for `coord`. -/
abbrev coordinate {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (X : RandomVector Ω n) (i : Fin n) : RealRandomVariable Ω :=
  coord X i

@[simp]
theorem coord_apply {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (X : RandomVector Ω n) (i : Fin n) (ω : Ω) :
    coord X i ω = X ω i :=
  rfl

@[simp]
theorem coordinate_apply {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (X : RandomVector Ω n) (i : Fin n) (ω : Ω) :
    coordinate X i ω = X ω i :=
  rfl

/-- Coordinates of an `IsRandomVector` are real random variables. -/
theorem isRealRandomVariable_coord {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    {n : ℕ} {X : RandomVector Ω n} (hX : IsRandomVector P X) (i : Fin n) :
    IsRealRandomVariable P (coord X i) :=
  hX i

/-- Compatibility version for the older `coordinate` name. -/
theorem isRealRandomVariable_coordinate {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    {n : ℕ} {X : RandomVector Ω n} (hX : IsRandomVector P X) (i : Fin n) :
    IsRealRandomVariable P (coordinate X i) :=
  hX i

/-- Finite linear marginal `ω ↦ ∑ i, a i * X ω i`. -/
def linearForm {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (X : RandomVector Ω n) (a : Fin n → ℝ) : RealRandomVariable Ω :=
  fun ω => ∑ i, a i * X ω i

/-- User-facing synonym for the finite linear marginal of a random vector. -/
abbrev marginal {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (X : RandomVector Ω n) (a : Fin n → ℝ) : RealRandomVariable Ω :=
  linearForm X a

@[simp]
theorem linearForm_apply {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (X : RandomVector Ω n) (a : Fin n → ℝ) (ω : Ω) :
    linearForm X a ω = ∑ i, a i * X ω i :=
  rfl

@[simp]
theorem marginal_apply {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (X : RandomVector Ω n) (a : Fin n → ℝ) (ω : Ω) :
    marginal X a ω = ∑ i, a i * X ω i :=
  rfl

/-- Finite linear marginals of an `IsRandomVector` are real random variables. -/
theorem isRealRandomVariable_linearForm {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    {n : ℕ} {X : RandomVector Ω n} (hX : IsRandomVector P X) (a : Fin n → ℝ) :
    IsRealRandomVariable P (linearForm X a) := by
  dsimp [IsRealRandomVariable, IsRandomVariable, linearForm]
  exact Finset.measurable_sum _ (fun i _ => (hX i).const_mul (a i))

/-- Marginals of an `IsRandomVector` are real random variables. -/
theorem isRealRandomVariable_marginal {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    {n : ℕ} {X : RandomVector Ω n} (hX : IsRandomVector P X) (a : Fin n → ℝ) :
    IsRealRandomVariable P (marginal X a) :=
  isRealRandomVariable_linearForm hX a

/-- Squared Euclidean norm random variable, represented by the coordinate sum. -/
def sqNorm {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (X : RandomVector Ω n) : RealRandomVariable Ω :=
  fun ω => ∑ i, (X ω i) ^ 2

@[simp]
theorem sqNorm_apply {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (X : RandomVector Ω n) (ω : Ω) :
    sqNorm X ω = ∑ i, (X ω i) ^ 2 :=
  rfl

/-- Euclidean norm random variable `ω ↦ sqrt (sqNorm X ω)`. -/
def euclideanNorm {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (X : RandomVector Ω n) : RealRandomVariable Ω :=
  fun ω => Real.sqrt (sqNorm X ω)

@[simp]
theorem euclideanNorm_apply {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (X : RandomVector Ω n) (ω : Ω) :
    euclideanNorm X ω = Real.sqrt (sqNorm X ω) :=
  rfl

/-- Squared norm of an `IsRandomVector` is a real random variable. -/
theorem isRealRandomVariable_sqNorm {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    {n : ℕ} {X : RandomVector Ω n} (hX : IsRandomVector P X) :
    IsRealRandomVariable P (sqNorm X) := by
  dsimp [IsRealRandomVariable, IsRandomVariable, sqNorm]
  exact Finset.measurable_sum _ (fun i _ => (hX i).pow_const 2)

/-- Euclidean norm of an `IsRandomVector` is a real random variable. -/
theorem isRealRandomVariable_euclideanNorm {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    {n : ℕ} {X : RandomVector Ω n} (hX : IsRandomVector P X) :
    IsRealRandomVariable P (euclideanNorm X) := by
  dsimp [IsRealRandomVariable, IsRandomVariable, euclideanNorm]
  exact (isRealRandomVariable_sqNorm hX).sqrt

end

end HighDimProb
