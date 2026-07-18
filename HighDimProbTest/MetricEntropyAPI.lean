import HighDimProb.MetricEntropy

open HighDimProb
open Filter
open MeasureTheory Set
open scoped NNReal ENNReal Topology
open scoped BigOperators Interval

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
#check HighDimProb.exists_finset_path_of_parentMap
#check HighDimProb.exists_finset_parentMap_of_internalRadiusLevels
#check HighDimProb.exists_finset_internalNetFamily_of_totallyBounded
#check HighDimProb.exists_finset_internalNetFamily_parentMap_of_totallyBounded
#check HighDimProb.exists_finset_internalNetFamily_parentMap_path_of_totallyBounded
#check HighDimProb.finiteEntropySum
#check HighDimProb.dyadicRadius
#check HighDimProb.dyadicRadius_pos
#check HighDimProb.tendsto_dyadicRadius_atTop
#check HighDimProb.tendsto_intervalIntegral_dyadicRadius_atTop
#check HighDimProb.finiteEntropySum_dyadic_le_four_mul_intervalIntegral_coveringNumber

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

example {alpha : Type*} [PseudoMetricSpace alpha]
    {K : Set alpha} {L : Nat} {rho : Fin (L + 1) → Real}
    (hrho : ∀ i, 0 < rho i) (hK : TotallyBounded K) :
    ∃ levels : Fin (L + 1) → Finset alpha,
      (∀ i, IsInternalEpsilonNet K (levels i : Set alpha) (rho i)) ∧
      (∀ i, coveringNumber K (rho i) = (levels i).card) ∧
      (∀ i, (levels i).card = (coveringNumber K (rho i)).toNat) := by
  exact exists_finset_internalNetFamily_of_totallyBounded hrho hK

example {R : Real} (hR : 0 < R) (i : Nat) :
    0 < dyadicRadius R i := by
  exact dyadicRadius_pos hR i

example (R : Real) :
    Tendsto (dyadicRadius R) atTop (𝓝 0) := by
  exact tendsto_dyadicRadius_atTop R

example {f : Real → Real} {R : Real} (hR : 0 ≤ R)
    (hf : IntervalIntegrable f volume 0 R) :
    Tendsto (fun L : Nat => ∫ t in dyadicRadius R (L + 1)..R, f t)
      atTop (𝓝 (∫ t in (0 : Real)..R, f t)) := by
  exact tendsto_intervalIntegral_dyadicRadius_atTop hR hf

example {alpha : Type*} [PseudoMetricSpace alpha]
    {K : Set alpha} {L : Nat} {R sigma : Real}
    (hR : 0 < R) (hsigma : 0 <= sigma) (N : Fin L -> Nat)
    (hN : forall k : Fin L,
      coveringNumber K (dyadicRadius R ((k : Nat) + 1)) = (N k : ENat))
    (hfinite : coveringNumber K (dyadicRadius R (L + 1)) ≠ ⊤) :
    finiteEntropySum (fun i : Fin (L + 1) => dyadicRadius R (i : Nat)) N sigma <=
      4 * sigma *
        (∫ t in dyadicRadius R (L + 1)..R,
          Real.sqrt (2 * Real.log
            (2 * ((coveringNumber K t).toNat : Real)))) := by
  exact finiteEntropySum_dyadic_le_four_mul_intervalIntegral_coveringNumber
    hR hsigma N hN hfinite

example {alpha : Type*} [PseudoMetricSpace alpha]
    {K : Set alpha} {R sigma : Real}
    (hR : 0 < R) (hsigma : 0 <= sigma)
    (hfinite : coveringNumber K (dyadicRadius R 1) ≠ ⊤) :
    finiteEntropySum (fun i : Fin 1 => dyadicRadius R (i : Nat))
        (fun i : Fin 0 => i.elim0) sigma <=
      4 * sigma *
        (∫ t in dyadicRadius R 1..R,
          Real.sqrt (2 * Real.log
            (2 * ((coveringNumber K t).toNat : Real)))) := by
  exact finiteEntropySum_dyadic_le_four_mul_intervalIntegral_coveringNumber
    hR hsigma (fun i : Fin 0 => i.elim0) (by simp) hfinite

example {alpha : Type*} [PseudoMetricSpace alpha] {L : Nat} {R : Real}
    (hR : 0 < R) :
    finiteEntropySum (fun i : Fin (L + 1) => dyadicRadius R (i : Nat))
        (fun _ => 0) 0 ≤
      4 * 0 *
        (∫ t in dyadicRadius R (L + 1)..R,
          Real.sqrt (2 * Real.log
            (2 * ((coveringNumber (∅ : Set alpha) t).toNat : Real)))) := by
  exact finiteEntropySum_dyadic_le_four_mul_intervalIntegral_coveringNumber
    hR (by norm_num) (fun _ => 0) (by simp) (by simp)

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
