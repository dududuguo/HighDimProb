import HighDimProb.Expectation
import HighDimProb.Lp
import HighDimProb.RandomVector

/-!
# Means, centeredness, and covariance

Scalar covariance reuses Mathlib's probability covariance. Vector covariance
vocabulary is entrywise over the concrete `Fin n → ℝ` random-vector model.
-/

namespace HighDimProb

open MeasureTheory
open scoped ProbabilityTheory

noncomputable section

/-- Mean of a real random variable, as the HighDimProb expectation alias. -/
abbrev mean {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) : ℝ :=
  expect P X

/-- Centered version of a real random variable. -/
def centered {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) : RealRandomVariable Ω :=
  fun ω => X ω - mean P X

/-- A real random variable is centered when its mean is zero. -/
abbrev Centered {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) : Prop :=
  mean P X = 0

/-- Variance of a real random variable, reusing Mathlib's definition. -/
abbrev variance {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) : ℝ :=
  ProbabilityTheory.variance X P

/-- Covariance of two real random variables, reusing Mathlib's definition. -/
abbrev covariance {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X Y : RealRandomVariable Ω) : ℝ :=
  ProbabilityTheory.covariance X Y P

/-- Uncentered second moment of two real random variables. -/
abbrev secondMoment {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X Y : RealRandomVariable Ω) : ℝ :=
  expect P (fun ω => X ω * Y ω)

/-- Mean vector, represented coordinatewise. -/
def meanVector {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) : Fin n → ℝ :=
  fun i => mean P (coord X i)

/-- Centered version of a finite-dimensional random vector. -/
def centeredVector {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) : RandomVector Ω n :=
  fun ω i => X ω i - meanVector P X i

/-- Coordinatewise centered random vector predicate. -/
abbrev CenteredVector {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) : Prop :=
  ∀ i : Fin n, Centered P (coord X i)

theorem centeredVector_iff_forall_centered_coord {Ω : Type*} [MeasurableSpace Ω]
    {n : ℕ} (P : Measure Ω) (X : RandomVector Ω n) :
    CenteredVector P X ↔ ∀ i : Fin n, Centered P (coord X i) :=
  Iff.rfl

theorem centered_centered {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    [IsProbabilityMeasure P] (X : RealRandomVariable Ω)
    (hX : IntegrableRealRandomVariable P X) :
    Centered P (centered P X) := by
  dsimp [Centered, centered, mean, expect]
  rw [integral_sub hX (integrable_const (∫ ω, X ω ∂P))]
  simp

/-- Entry of the uncentered second moment matrix `E[X Xᵀ]`. -/
abbrev secondMomentMatrixEntry {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) (i j : Fin n) : ℝ :=
  secondMoment P (coord X i) (coord X j)

/-- Uncentered second moment matrix `E[X Xᵀ]`, represented entrywise. -/
def secondMomentMatrix {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) : Matrix (Fin n) (Fin n) ℝ :=
  fun i j => secondMomentMatrixEntry P X i j

/-- Entry of the covariance matrix. -/
abbrev covarianceMatrixEntry {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) (i j : Fin n) : ℝ :=
  covariance P (coord X i) (coord X j)

/-- Covariance matrix, represented entrywise. -/
def covarianceMatrix {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) : Matrix (Fin n) (Fin n) ℝ :=
  fun i j => covarianceMatrixEntry P X i j

@[simp]
theorem mean_def {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) :
    mean P X = expect P X :=
  rfl

@[simp]
theorem mean_eq_integral {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) :
    mean P X = ∫ ω, X ω ∂P :=
  rfl

@[simp]
theorem centered_apply {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (ω : Ω) :
    centered P X ω = X ω - mean P X :=
  rfl

@[simp]
theorem covariance_def {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X Y : RealRandomVariable Ω) :
    covariance P X Y = ProbabilityTheory.covariance X Y P :=
  rfl

@[simp]
theorem variance_def {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) :
    variance P X = ProbabilityTheory.variance X P :=
  rfl

@[simp]
theorem covariance_eq_integral {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X Y : RealRandomVariable Ω) :
    covariance P X Y = ∫ ω, (X ω - mean P X) * (Y ω - mean P Y) ∂P :=
  rfl

@[simp]
theorem secondMoment_def {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X Y : RealRandomVariable Ω) :
    secondMoment P X Y = expect P (fun ω => X ω * Y ω) :=
  rfl

@[simp]
theorem meanVector_apply {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) (i : Fin n) :
    meanVector P X i = mean P (coord X i) :=
  rfl

@[simp]
theorem centeredVector_apply {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) (ω : Ω) (i : Fin n) :
    centeredVector P X ω i = X ω i - meanVector P X i :=
  rfl

@[simp]
theorem coord_centeredVector {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) (i : Fin n) :
    coord (centeredVector P X) i = centered P (coord X i) :=
  rfl

@[simp]
theorem secondMomentMatrix_apply {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) (i j : Fin n) :
    secondMomentMatrix P X i j = secondMomentMatrixEntry P X i j :=
  rfl

@[simp]
theorem covarianceMatrix_apply {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) (i j : Fin n) :
    covarianceMatrix P X i j = covarianceMatrixEntry P X i j :=
  rfl

/-- Centering preserves real-random-variable measurability. -/
theorem isRealRandomVariable_centered {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    {X : RealRandomVariable Ω} (hX : IsRealRandomVariable P X) :
    IsRealRandomVariable P (centered P X) := by
  dsimp [IsRealRandomVariable, IsRandomVariable, centered]
  exact hX.sub measurable_const

/-- Centering preserves random-vector coordinatewise measurability. -/
theorem isRandomVector_centeredVector {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    {n : ℕ} {X : RandomVector Ω n} (hX : IsRandomVector P X) :
    IsRandomVector P (centeredVector P X) := by
  intro i
  change IsRealRandomVariable P (centered P (coord X i))
  exact isRealRandomVariable_centered (hX i)

end

end HighDimProb
