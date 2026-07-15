import HighDimProb.MetricEntropy

open HighDimProb
open scoped NNReal ENNReal

#check HighDimProb.epsilonRadius
#check HighDimProb.IsInternalEpsilonNet
#check HighDimProb.coveringNumber_le_card_of_isInternalEpsilonNet
#check HighDimProb.exists_nat_eq_coveringNumber_of_isInternalEpsilonNet
#check HighDimProb.exists_finset_isInternalEpsilonNet_of_totallyBounded
#check Metric.minimalCover
#check Metric.minimalCover_subset
#check Metric.finite_minimalCover
#check Metric.isCover_minimalCover
#check Metric.encard_minimalCover

example {alpha : Type*} [PseudoMetricSpace alpha]
    {K N : Set alpha} {eps : Real}
    (hN : IsInternalEpsilonNet K N eps) (hNfinite : N.Finite) :
    ∃ m : Nat, coveringNumber K eps = (m : ENat) ∧ m <= N.ncard := by
  exact exists_nat_eq_coveringNumber_of_isInternalEpsilonNet hN hNfinite

example {alpha : Type*} [PseudoMetricSpace alpha]
    (eps : NNReal) (K : Set alpha)
    (hfinite : Metric.coveringNumber eps K ≠ ⊤) :
    (Metric.minimalCover eps K).encard = Metric.coveringNumber eps K := by
  exact Metric.encard_minimalCover hfinite

example {alpha : Type*} [PseudoMetricSpace alpha]
    {K : Set alpha} {eps : Real} (heps : 0 < eps)
    (hK : TotallyBounded K) :
    ∃ N : Finset alpha,
      IsInternalEpsilonNet K (N : Set alpha) eps ∧
        coveringNumber K eps = (N.card : ENat) ∧
        N.card = (coveringNumber K eps).toNat := by
  exact exists_finset_isInternalEpsilonNet_of_totallyBounded heps hK
