import HighDimProb.Nets

/-!
# Metric entropy vocabulary

This file exposes HighDimProb-facing names for Mathlib's covering and packing
number APIs. The values are Mathlib `ℕ∞` cardinal numbers.
-/

namespace HighDimProb

open scoped NNReal ENNReal

noncomputable section

/-- External covering number: centers may lie outside `K`. -/
abbrev externalCoveringNumber {α : Type*} [PseudoMetricSpace α]
    (K : Set α) (ε : ℝ) : ℕ∞ :=
  Metric.externalCoveringNumber (epsilonRadius ε) K

/-- Internal covering number: centers are constrained to lie in `K`. -/
abbrev coveringNumber {α : Type*} [PseudoMetricSpace α]
    (K : Set α) (ε : ℝ) : ℕ∞ :=
  Metric.coveringNumber (epsilonRadius ε) K

/-- Packing number: maximal cardinality of an `ε`-separated subset of `K`. -/
abbrev packingNumber {α : Type*} [PseudoMetricSpace α]
    (K : Set α) (ε : ℝ) : ℕ∞ :=
  Metric.packingNumber (epsilonRadius ε) K

theorem externalCoveringNumber_def {α : Type*} [PseudoMetricSpace α]
    (K : Set α) (ε : ℝ) :
    externalCoveringNumber K ε = Metric.externalCoveringNumber (epsilonRadius ε) K :=
  rfl

theorem coveringNumber_def {α : Type*} [PseudoMetricSpace α]
    (K : Set α) (ε : ℝ) :
    coveringNumber K ε = Metric.coveringNumber (epsilonRadius ε) K :=
  rfl

theorem packingNumber_def {α : Type*} [PseudoMetricSpace α]
    (K : Set α) (ε : ℝ) :
    packingNumber K ε = Metric.packingNumber (epsilonRadius ε) K :=
  rfl

/-- An explicit external epsilon-net bounds the external covering number. -/
theorem externalCoveringNumber_le_encard_of_isEpsilonNet {α : Type*}
    [PseudoMetricSpace α] {K N : Set α} {ε : ℝ}
    (hN : IsEpsilonNet K N ε) :
    externalCoveringNumber K ε <= N.encard := by
  exact Metric.IsCover.externalCoveringNumber_le_encard hN

/-- An explicit internal epsilon-net bounds the internal covering number. -/
theorem coveringNumber_le_encard_of_isInternalEpsilonNet {α : Type*}
    [PseudoMetricSpace α] {K N : Set α} {ε : ℝ}
    (hN : IsInternalEpsilonNet K N ε) :
    coveringNumber K ε <= N.encard := by
  exact Metric.IsCover.coveringNumber_le_encard hN.1 hN.2

/-- A finite explicit external epsilon-net bounds the external covering number by its cardinality. -/
theorem externalCoveringNumber_le_card_of_isEpsilonNet {α : Type*}
    [PseudoMetricSpace α] {K N : Set α} {ε : ℝ}
    (hN : IsEpsilonNet K N ε) (hN_fin : N.Finite) :
    externalCoveringNumber K ε <= (N.ncard : ENat) := by
  simpa [hN_fin.cast_ncard_eq] using
    externalCoveringNumber_le_encard_of_isEpsilonNet hN

/-- A finite explicit internal epsilon-net bounds the internal covering number by its cardinality. -/
theorem coveringNumber_le_card_of_isInternalEpsilonNet {α : Type*}
    [PseudoMetricSpace α] {K N : Set α} {ε : ℝ}
    (hN : IsInternalEpsilonNet K N ε) (hN_fin : N.Finite) :
    coveringNumber K ε <= (N.ncard : ENat) := by
  simpa [hN_fin.cast_ncard_eq] using
    coveringNumber_le_encard_of_isInternalEpsilonNet hN

end

end HighDimProb
