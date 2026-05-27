import HighDimProb.Covariance

/-!
# Isotropic random vectors
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators

noncomputable section

/-- Entrywise second-moment isotropicity: `E[X_i X_j]` is the identity matrix. -/
def IsotropicSecondMoment {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) : Prop :=
  ∀ i j : Fin n, secondMomentMatrixEntry P X i j = if i = j then 1 else 0

/-- Matrix-form second-moment isotropicity. The entrywise predicate is the primary API. -/
def IsotropicSecondMomentMatrix {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) : Prop :=
  secondMomentMatrix P X = 1

/-- Covariance-form isotropicity: centered coordinates and identity covariance matrix. -/
def IsotropicCovariance {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) : Prop :=
  CenteredVector P X ∧
    ∀ i j : Fin n,
      covarianceMatrixEntry P X i j = if i = j then 1 else 0

/-- Marginal-form isotropicity: every linear marginal has second moment `∑ i, a i ^ 2`. -/
def IsotropicMarginal {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) : Prop :=
  ∀ a : Fin n → ℝ,
    secondMoment P (linearForm X a) (linearForm X a) = ∑ i, a i ^ 2

/-- Compatibility alias for the older scaffold name. Prefer `IsotropicCovariance`. -/
abbrev IsIsotropic {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) : Prop :=
  IsotropicCovariance P X

theorem isotropicSecondMoment_iff {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) :
    IsotropicSecondMoment P X ↔
      ∀ i j : Fin n, secondMomentMatrixEntry P X i j = if i = j then 1 else 0 :=
  Iff.rfl

theorem isotropicSecondMomentMatrix_iff {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) :
    IsotropicSecondMomentMatrix P X ↔ secondMomentMatrix P X = 1 :=
  Iff.rfl

theorem isotropicCovariance_iff {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) :
    IsotropicCovariance P X ↔
      CenteredVector P X ∧
        ∀ i j : Fin n, covarianceMatrixEntry P X i j = if i = j then 1 else 0 :=
  Iff.rfl

theorem isotropicMarginal_iff {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) :
    IsotropicMarginal P X ↔
      ∀ a : Fin n → ℝ,
        secondMoment P (linearForm X a) (linearForm X a) = ∑ i, a i ^ 2 :=
  Iff.rfl

theorem isIsotropic_iff_isotropicCovariance {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (P : Measure Ω) (X : RandomVector Ω n) :
    IsIsotropic P X ↔ IsotropicCovariance P X :=
  Iff.rfl

end

end HighDimProb
