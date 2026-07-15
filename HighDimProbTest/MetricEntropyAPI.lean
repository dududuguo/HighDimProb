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

-- Mathlib's minimal-cover primitives are available, but no HighDimProb
-- Finset/internal-net adapter is assumed here.
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
