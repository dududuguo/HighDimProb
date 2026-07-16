import HighDimProb.MetricEntropy

open HighDimProb
open scoped NNReal ENNReal

#check HighDimProb.epsilonRadius
#check HighDimProb.IsInternalEpsilonNet
#check HighDimProb.coveringNumber_le_card_of_isInternalEpsilonNet
#check HighDimProb.exists_nat_eq_coveringNumber_of_isInternalEpsilonNet
#check HighDimProb.exists_finset_isInternalEpsilonNet_of_totallyBounded
#check HighDimProb.exists_parentMap_of_subset_of_isInternalEpsilonNet
#check HighDimProb.exists_finset_parentMap_of_internalLevels
#check HighDimProb.exists_finset_path_of_parentMap
#check HighDimProb.exists_finset_parentMap_of_internalRadiusLevels
#check HighDimProb.exists_finset_internalNetFamily_of_totallyBounded
#check HighDimProb.exists_finset_internalNetFamily_parentMap_of_totallyBounded
#check HighDimProb.exists_finset_internalNetFamily_parentMap_path_of_totallyBounded
#check HighDimProb.finiteEntropySum
#check HighDimProb.dyadicRadius
#check HighDimProb.dyadicRadius_pos
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

example {alpha : Type*} [PseudoMetricSpace alpha]
    {K : Set alpha} {L : Nat} {rho : Fin (L + 1) → Real}
    (hrho : ∀ i, 0 < rho i) (hK : TotallyBounded K) :
    ∃ levels : Fin (L + 1) → Finset alpha,
      (∀ i, IsInternalEpsilonNet K (levels i : Set alpha) (rho i)) ∧
      (∀ i, coveringNumber K (rho i) = (levels i).card) ∧
      (∀ i, (levels i).card = (coveringNumber K (rho i)).toNat) := by
  exact exists_finset_internalNetFamily_of_totallyBounded hrho hK

example {alpha : Type*} [PseudoMetricSpace alpha]
    {L : Nat} {rho : Fin (L + 1) → Real}
    {levels : Fin (L + 1) → Finset alpha} {sigma : Real} :
    finiteEntropySum rho
        (fun k : Fin L => (levels (Fin.succ k)).card) sigma =
      ∑ k : Fin L,
        (sigma * rho (Fin.castSucc k)) * Real.sqrt
          (2 * Real.log (2 * ((levels (Fin.succ k)).card : Real))) := by
  rfl

example {alpha : Type*} [PseudoMetricSpace alpha]
    {L : Nat} {levels : Fin (L + 1) → Finset alpha}
    {parent : Fin L → alpha → alpha} {radius : Fin L → Real}
    (hmem : ∀ k x, x ∈ levels (Fin.succ k) →
      parent k x ∈ levels (Fin.castSucc k))
    (hdist : ∀ k x, x ∈ levels (Fin.succ k) →
      dist x (parent k x) ≤ radius k)
    {x : alpha} (hx : x ∈ levels (Fin.last L)) :
    ∃ path : Fin (L + 1) → alpha,
      path (Fin.last L) = x ∧
      (∀ j, path j ∈ levels j) ∧
      (∀ k : Fin L,
        path (Fin.castSucc k) = parent k (path (Fin.succ k)) ∧
        dist (path (Fin.succ k))
          (parent k (path (Fin.succ k))) ≤ radius k) := by
  exact exists_finset_path_of_parentMap hmem hdist hx
