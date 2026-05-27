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

end

end HighDimProb
