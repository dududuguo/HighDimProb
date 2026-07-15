import HighDimProb.MetricEntropy

open HighDimProb
open scoped NNReal ENNReal

#check HighDimProb.epsilonRadius
#check HighDimProb.IsEpsilonNet
#check HighDimProb.IsInternalEpsilonNet
#check HighDimProb.coveringNumber
#check HighDimProb.coveringNumber_le_encard_of_isInternalEpsilonNet
#check HighDimProb.coveringNumber_le_card_of_isInternalEpsilonNet
#check HighDimProb.exists_nat_eq_coveringNumber_of_isInternalEpsilonNet
#check HighDimProb.exists_finset_isInternalEpsilonNet_of_totallyBounded
#check HighDimProb.exists_parentMap_of_subset_of_isInternalEpsilonNet
#check HighDimProb.exists_finset_parentMap_of_internalLevels

-- A nonpositive real radius is represented by the zero NNReal radius.
example : epsilonRadius (-1) = 0 := by
  simp [epsilonRadius]

example {alpha : Type*} [PseudoMetricSpace alpha]
    {K N : Set alpha} {eps : Real}
    (hN : IsInternalEpsilonNet K N eps) (hNfinite : N.Finite) :
    coveringNumber K eps <= (N.ncard : ENat) :=
  coveringNumber_le_card_of_isInternalEpsilonNet hN hNfinite

example {alpha : Type*} [PseudoMetricSpace alpha]
    {K N : Set alpha} {eps : Real}
    (hN : IsInternalEpsilonNet K N eps) (hNfinite : N.Finite) :
    ∃ m : Nat, coveringNumber K eps = (m : ENat) ∧ m <= N.ncard :=
  exists_nat_eq_coveringNumber_of_isInternalEpsilonNet hN hNfinite

example {alpha : Type*} [PseudoMetricSpace alpha]
    {K : Set alpha} {eps : Real} (heps : 0 < eps)
    (hK : TotallyBounded K) :
    ∃ N : Finset alpha,
      IsInternalEpsilonNet K (N : Set alpha) eps ∧
        coveringNumber K eps = (N.card : ENat) ∧
        N.card = (coveringNumber K eps).toNat := by
  exact exists_finset_isInternalEpsilonNet_of_totallyBounded heps hK

example {alpha : Type*} [PseudoMetricSpace alpha] {eps : Real}
    (heps : 0 < eps) :
    ∃ N : Finset alpha,
      IsInternalEpsilonNet (∅ : Set alpha) (N : Set alpha) eps ∧
        coveringNumber (∅ : Set alpha) eps = (N.card : ENat) := by
  obtain ⟨N, hN, hcard, _⟩ :=
    exists_finset_isInternalEpsilonNet_of_totallyBounded
      (K := (∅ : Set alpha)) heps totallyBounded_empty
  exact ⟨N, hN, hcard⟩

example {alpha : Type*} [PseudoMetricSpace alpha]
    {A K B : Set alpha} {eps : Real}
    (hA : A ⊆ K) (hB : IsInternalEpsilonNet K B eps) (heps : 0 < eps) :
    ∃ parent : A → K,
      ∀ x : A, (parent x : alpha) ∈ B ∧
        dist (x : alpha) (parent x : alpha) ≤ eps := by
  exact exists_parentMap_of_subset_of_isInternalEpsilonNet hA hB heps

example {alpha : Type*} [PseudoMetricSpace alpha]
    {K : Set alpha} {L : Nat}
    {levels : Fin (L + 1) → Finset alpha} {eps : Real}
    (hPrev : ∀ k : Fin L,
      IsInternalEpsilonNet K (levels (Fin.castSucc k) : Set alpha) eps)
    (hNext : ∀ k : Fin L,
      (levels (Fin.succ k) : Set alpha) ⊆ K) (heps : 0 < eps) :
    ∃ parent : Fin L → alpha → alpha,
      (∀ k x, x ∈ levels (Fin.succ k) →
        parent k x ∈ levels (Fin.castSucc k)) ∧
      (∀ k x, x ∈ levels (Fin.succ k) →
        dist x (parent k x) ≤ eps) := by
  exact exists_finset_parentMap_of_internalLevels hPrev hNext heps

-- Mathlib's minimal-cover primitives remain available for lower-level audits;
-- the HighDimProb Finset/internal-net adapter is checked above.
#check Metric.minimalCover
#check Metric.minimalCover_subset
#check Metric.finite_minimalCover
#check Metric.isCover_minimalCover
#check Metric.encard_minimalCover

example {alpha : Type*} [PseudoMetricSpace alpha]
    (eps : NNReal) (K : Set alpha) :
    Metric.minimalCover eps K ⊆ K := by
  exact Metric.minimalCover_subset

example {alpha : Type*} [PseudoMetricSpace alpha]
    (eps : NNReal) (K : Set alpha)
    (hfinite : Metric.coveringNumber eps K ≠ ⊤) :
    Metric.IsCover eps K (Metric.minimalCover eps K) := by
  exact Metric.isCover_minimalCover hfinite

example {alpha : Type*} [PseudoMetricSpace alpha]
    (eps : NNReal) (K : Set alpha)
    (hfinite : Metric.coveringNumber eps K ≠ ⊤) :
    (Metric.minimalCover eps K).encard = Metric.coveringNumber eps K := by
  exact Metric.encard_minimalCover hfinite
