import HighDimProb.Nets

/-!
# Metric entropy vocabulary

This file exposes HighDimProb-facing names for Mathlib's covering and packing
number APIs. The values are Mathlib `ℕ∞` cardinal numbers.

Verified Wikipedia reference:
https://en.wikipedia.org/wiki/Covering_number

Note: wiki.md listed `https://en.wikipedia.org/wiki/Metric_entropy`, but this
was not verified as a dedicated Wikipedia page. Covering-number vocabulary is
therefore linked to the verified covering-number page.
-/

namespace HighDimProb

open scoped NNReal ENNReal

noncomputable section

/--
External covering number: centers may lie outside `K`.

Formula reference: this is the external covering number `N_ext(K, epsilon)`,
the least number of radius-`epsilon` balls whose centers may lie outside `K`
and whose union covers `K`; see https://en.wikipedia.org/wiki/Covering_number
-/
abbrev externalCoveringNumber {α : Type*} [PseudoMetricSpace α]
    (K : Set α) (ε : ℝ) : ℕ∞ :=
  Metric.externalCoveringNumber (epsilonRadius ε) K

/--
Internal covering number: centers are constrained to lie in `K`.

Formula reference: this is the internal covering number `N(K, epsilon)`, the
least number of radius-`epsilon` balls with centers constrained to lie in `K`
whose union covers `K`; see https://en.wikipedia.org/wiki/Covering_number
-/
abbrev coveringNumber {α : Type*} [PseudoMetricSpace α]
    (K : Set α) (ε : ℝ) : ℕ∞ :=
  Metric.coveringNumber (epsilonRadius ε) K

/--
Packing number: maximal cardinality of an `epsilon`-separated subset of `K`.

Formula reference: this is the packing number `M(K, epsilon)`, the maximal
cardinality of a subset of `K` whose distinct points are pairwise separated at
scale `epsilon`; see https://en.wikipedia.org/wiki/Covering_number
-/
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

/-- The standard packing-covering comparison at scales `ε` and `2 * ε`. -/
theorem packingCoveringInequality {α : Type*} [PseudoMetricSpace α]
    (K : Set α) (ε : ℝ) :
    packingNumber K (2 * ε) ≤ coveringNumber K ε ∧
      coveringNumber K ε ≤ packingNumber K ε := by
  have hscale : epsilonRadius (2 * ε) = 2 * epsilonRadius ε := by
    change Real.toNNReal (2 * ε) = 2 * Real.toNNReal ε
    rw [Real.toNNReal_mul (by norm_num : (0 : ℝ) ≤ 2)]
    norm_num [epsilonRadius, Real.toNNReal_of_nonneg]
  constructor
  · change Metric.packingNumber (epsilonRadius (2 * ε)) K ≤
      Metric.coveringNumber (epsilonRadius ε) K
    rw [hscale]
    exact le_trans
      (Metric.packingNumber_two_mul_le_externalCoveringNumber (epsilonRadius ε) K)
      (Metric.externalCoveringNumber_le_coveringNumber (epsilonRadius ε) K)
  · change Metric.coveringNumber (epsilonRadius ε) K ≤
      Metric.packingNumber (epsilonRadius ε) K
    exact Metric.coveringNumber_le_packingNumber (epsilonRadius ε) K

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

/-- A finite internal epsilon-net makes the covering number a finite natural
number, bounded by the cardinality of the net. -/
theorem exists_nat_eq_coveringNumber_of_isInternalEpsilonNet {α : Type*}
    [PseudoMetricSpace α] {K N : Set α} {ε : ℝ}
    (hN : IsInternalEpsilonNet K N ε) (hN_fin : N.Finite) :
    ∃ m : Nat, coveringNumber K ε = (m : ENat) ∧ m ≤ N.ncard := by
  have hle := coveringNumber_le_card_of_isInternalEpsilonNet hN hN_fin
  have hfinite : coveringNumber K ε ≠ ⊤ :=
    ne_top_of_le_ne_top (ENat.coe_ne_top N.ncard) hle
  refine ⟨(coveringNumber K ε).toNat, ?_, ?_⟩
  · exact (ENat.coe_toNat hfinite).symm
  · apply ENat.coe_le_coe.mp
    rw [ENat.coe_toNat hfinite]
    exact hle

end

end HighDimProb
