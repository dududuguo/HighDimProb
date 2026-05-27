import HighDimProb.Basic

/-!
# Nets and separated sets

Wrappers in this file reuse Mathlib's metric covering and separated-set APIs.
Real radii are converted to nonnegative radii by `Real.toNNReal`.
-/

namespace HighDimProb

open scoped NNReal ENNReal

/-- Nonnegative Mathlib radius associated to a real radius. -/
abbrev epsilonRadius (ε : ℝ) : ℝ≥0 :=
  Real.toNNReal ε

/-- Extended nonnegative Mathlib radius associated to a real radius. -/
abbrev epsilonERadius (ε : ℝ) : ℝ≥0∞ :=
  ↑(epsilonRadius ε)

/--
`N` is an `ε`-net/cover for `K`, using Mathlib's `Metric.IsCover`.

Mathlib's cover predicate allows centers in `N` to lie outside `K`.
-/
abbrev IsEpsilonNet {α : Type*} [PseudoMetricSpace α]
    (K N : Set α) (ε : ℝ) : Prop :=
  Metric.IsCover (epsilonRadius ε) K N

/-- Internal `ε`-net: a Mathlib cover whose centers lie in `K`. -/
abbrev IsInternalEpsilonNet {α : Type*} [PseudoMetricSpace α]
    (K N : Set α) (ε : ℝ) : Prop :=
  N ⊆ K ∧ IsEpsilonNet K N ε

/-- A set is `ε`-separated, using Mathlib's `Metric.IsSeparated`. -/
abbrev IsEpsilonSeparated {α : Type*} [PseudoMetricSpace α]
    (N : Set α) (ε : ℝ) : Prop :=
  Metric.IsSeparated (epsilonERadius ε) N

theorem isEpsilonNet_iff {α : Type*} [PseudoMetricSpace α]
    (K N : Set α) (ε : ℝ) :
    IsEpsilonNet K N ε ↔ Metric.IsCover (epsilonRadius ε) K N :=
  Iff.rfl

theorem isInternalEpsilonNet_iff {α : Type*} [PseudoMetricSpace α]
    (K N : Set α) (ε : ℝ) :
    IsInternalEpsilonNet K N ε ↔ N ⊆ K ∧ IsEpsilonNet K N ε :=
  Iff.rfl

theorem isEpsilonSeparated_iff {α : Type*} [PseudoMetricSpace α]
    (N : Set α) (ε : ℝ) :
    IsEpsilonSeparated N ε ↔ Metric.IsSeparated (epsilonERadius ε) N :=
  Iff.rfl

end HighDimProb
