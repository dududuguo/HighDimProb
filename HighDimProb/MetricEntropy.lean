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

/-- Select, for each point of a subset, a nearby center from an internal net. -/
theorem exists_parentMap_of_subset_of_isInternalEpsilonNet {α : Type*}
    [PseudoMetricSpace α] {A K B : Set α} {ε : ℝ}
    (hA : A ⊆ K) (hB : IsInternalEpsilonNet K B ε) (hε : 0 < ε) :
    ∃ parent : A → K,
      ∀ x : A, (parent x : α) ∈ B ∧ dist (x : α) (parent x : α) ≤ ε := by
  classical
  have hcover : ∀ x : A, ∃ y : K,
      (y : α) ∈ B ∧ dist (x : α) (y : α) ≤ ε := by
    intro x
    obtain ⟨y, hyB, hxy⟩ := hB.2 (hA x.2)
    refine ⟨⟨y, hB.1 hyB⟩, hyB, ?_⟩
    have hxy' : nndist (x : α) y ≤ epsilonRadius ε :=
      (edist_le_coe).mp hxy
    have hxy'' : (nndist (x : α) y : ℝ) ≤ (epsilonRadius ε : ℝ) :=
      NNReal.coe_le_coe.mpr hxy'
    simpa [epsilonRadius, Real.toNNReal_of_nonneg hε.le] using hxy''
  refine ⟨fun x => Classical.choose (hcover x), ?_⟩
  intro x
  exact Classical.choose_spec (hcover x)

/-- Extend the layerwise parent maps to total ambient functions. -/
theorem exists_finset_parentMap_of_internalLevels {α : Type*}
    [PseudoMetricSpace α] {K : Set α} {L : Nat}
    {levels : Fin (L + 1) → Finset α} {ε : ℝ}
    (hPrev : ∀ k : Fin L,
      IsInternalEpsilonNet K (levels (Fin.castSucc k) : Set α) ε)
    (hNext : ∀ k : Fin L,
      (levels (Fin.succ k) : Set α) ⊆ K)
    (hε : 0 < ε) :
    ∃ parent : Fin L → α → α,
      (∀ k x, x ∈ levels (Fin.succ k) →
        parent k x ∈ levels (Fin.castSucc k)) ∧
      (∀ k x, x ∈ levels (Fin.succ k) →
        dist x (parent k x) ≤ ε) := by
  classical
  have hParents : ∀ k : Fin L,
      ∃ p : (levels (Fin.succ k) : Set α) → K,
        ∀ x, (p x : α) ∈ (levels (Fin.castSucc k) : Set α) ∧
          dist (x : α) (p x : α) ≤ ε := by
    intro k
    exact exists_parentMap_of_subset_of_isInternalEpsilonNet
      (hNext k) (hPrev k) hε
  let parents : ∀ k : Fin L,
      (levels (Fin.succ k) : Set α) → K :=
    fun k => Classical.choose (hParents k)
  have hParents_spec : ∀ k x, (parents k x : α) ∈
      (levels (Fin.castSucc k) : Set α) ∧
        dist (x : α) (parents k x : α) ≤ ε := by
    intro k x
    exact Classical.choose_spec (hParents k) x
  let parent : Fin L → α → α := fun k x =>
    if hx : x ∈ (levels (Fin.succ k) : Set α) then
      (parents k ⟨x, hx⟩ : α)
    else x
  refine ⟨parent, ?_, ?_⟩
  · intro k x hx
    simpa [parent, hx] using (hParents_spec k ⟨x, hx⟩).1
  · intro k x hx
    simpa [parent, hx] using (hParents_spec k ⟨x, hx⟩).2

/-- A terminal point in finite levels has a compatible path to the base level. -/
theorem exists_finset_path_of_parentMap {α : Type*} [PseudoMetricSpace α]
    {L : Nat} {levels : Fin (L + 1) → Finset α}
    {parent : Fin L → α → α} {r : Fin L → ℝ}
    (hmem : ∀ k x, x ∈ levels (Fin.succ k) →
      parent k x ∈ levels (Fin.castSucc k))
    (hdist : ∀ k x, x ∈ levels (Fin.succ k) →
      dist x (parent k x) ≤ r k)
    {x : α} (hx : x ∈ levels (Fin.last L)) :
    ∃ path : Fin (L + 1) → α,
      path (Fin.last L) = x ∧
      (∀ j, path j ∈ levels j) ∧
      (∀ k : Fin L,
        path (Fin.castSucc k) = parent k (path (Fin.succ k)) ∧
        dist (path (Fin.succ k))
          (parent k (path (Fin.succ k))) ≤ r k) := by
  let path : Fin (L + 1) → α :=
    Fin.reverseInduction x (fun i yi => parent i yi)
  have hpath_mem : ∀ i : Fin (L + 1), path i ∈ levels i := by
    intro i
    induction i using Fin.reverseInduction with
    | last => simpa [path] using hx
    | cast i ih =>
        simpa [path] using hmem i (path i.succ) ih
  have hpath_parent : ∀ k : Fin L,
      path (Fin.castSucc k) = parent k (path (Fin.succ k)) := by
    intro k
    simp [path]
  refine ⟨path, ?_, hpath_mem, ?_⟩
  · simp [path]
  · intro k
    exact ⟨hpath_parent k,
      hdist k (path (Fin.succ k)) (hpath_mem (Fin.succ k))⟩

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

/-- A totally bounded set has a finite internal epsilon-net obtained from
Mathlib's minimal cover, with exact `ENNReal` and `toNat` cardinalities. -/
theorem exists_finset_isInternalEpsilonNet_of_totallyBounded {α : Type*}
    [PseudoMetricSpace α] {K : Set α} {ε : ℝ}
    (hε : 0 < ε) (hK : TotallyBounded K) :
    ∃ N : Finset α,
      IsInternalEpsilonNet K (N : Set α) ε ∧
        coveringNumber K ε = (N.card : ENat) ∧
        N.card = (coveringNumber K ε).toNat := by
  have hε_pos : 0 < epsilonRadius ε := (Real.toNNReal_pos).2 hε
  have hε_ne : epsilonRadius ε ≠ 0 := ne_of_gt hε_pos
  obtain ⟨C, hCK, hCfin, hCcover⟩ :=
    Metric.exists_finite_isCover_of_totallyBounded hε_ne hK
  have hcover_le : Metric.coveringNumber (epsilonRadius ε) K ≤ C.encard :=
    Metric.IsCover.coveringNumber_le_encard hCK hCcover
  have hcover_ne_top : Metric.coveringNumber (epsilonRadius ε) K ≠ ⊤ :=
    ne_top_of_le_ne_top (ne_top_of_lt hCfin.encard_lt_top) hcover_le
  let N : Finset α :=
    (Metric.finite_minimalCover (A := K) (ε := epsilonRadius ε)).toFinset
  have hN_coe :
      (N : Set α) = Metric.minimalCover (epsilonRadius ε) K := by
    dsimp [N]
    exact Set.Finite.coe_toFinset
      (Metric.finite_minimalCover (A := K) (ε := epsilonRadius ε))
  have hN_internal : IsInternalEpsilonNet K (N : Set α) ε := by
    refine ⟨?_, ?_⟩
    · rw [hN_coe]
      exact Metric.minimalCover_subset
    · rw [hN_coe]
      exact Metric.isCover_minimalCover hcover_ne_top
  have hcard :
      (Metric.minimalCover (epsilonRadius ε) K).encard = (N.card : ENat) := by
    dsimp [N]
    exact Set.Finite.encard_eq_coe_toFinset_card
      (Metric.finite_minimalCover (A := K) (ε := epsilonRadius ε))
  have hcover_eq : coveringNumber K ε = (N.card : ENat) := by
    change Metric.coveringNumber (epsilonRadius ε) K = (N.card : ENat)
    exact (Metric.encard_minimalCover hcover_ne_top).symm.trans hcard
  have htoNat : ((coveringNumber K ε).toNat : ENat) = coveringNumber K ε := by
    exact ENat.coe_toNat hcover_ne_top
  refine ⟨N, hN_internal, hcover_eq, ?_⟩
  apply ENat.coe_inj.mp
  exact hcover_eq.symm.trans htoNat.symm

end

end HighDimProb
