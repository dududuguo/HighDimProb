import HighDimProb.Nets
import HighDimProb.Analysis.SumIntegral

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

/-- Extend finite parent selection to a level-dependent positive radius family. -/
theorem exists_finset_parentMap_of_internalRadiusLevels {α : Type*}
    [PseudoMetricSpace α] {K : Set α} {L : Nat}
    {levels : Fin (L + 1) → Finset α} {rho : Fin (L + 1) → ℝ}
    (hPrev : ∀ k : Fin L,
      IsInternalEpsilonNet K (levels (Fin.castSucc k) : Set α)
        (rho (Fin.castSucc k)))
    (hNext : ∀ k : Fin L,
      (levels (Fin.succ k) : Set α) ⊆ K)
    (hρ : ∀ k : Fin L, 0 < rho (Fin.castSucc k)) :
    ∃ parent : Fin L → α → α,
      (∀ k x, x ∈ levels (Fin.succ k) →
        parent k x ∈ levels (Fin.castSucc k)) ∧
      (∀ k x, x ∈ levels (Fin.succ k) →
        dist x (parent k x) ≤ rho (Fin.castSucc k)) := by
  classical
  have hParents : ∀ k : Fin L,
      ∃ p : (levels (Fin.succ k) : Set α) → K,
        ∀ x, (p x : α) ∈ (levels (Fin.castSucc k) : Set α) ∧
          dist (x : α) (p x : α) ≤ rho (Fin.castSucc k) := by
    intro k
    exact exists_parentMap_of_subset_of_isInternalEpsilonNet
      (hNext k) (hPrev k) (hρ k)
  let parents : ∀ k : Fin L,
      (levels (Fin.succ k) : Set α) → K :=
    fun k => Classical.choose (hParents k)
  have hParents_spec : ∀ k x, (parents k x : α) ∈
      (levels (Fin.castSucc k) : Set α) ∧
        dist (x : α) (parents k x : α) ≤ rho (Fin.castSucc k) := by
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

/-- Choose finite internal nets independently at finitely many positive radii. -/
theorem exists_finset_internalNetFamily_of_totallyBounded {α : Type*}
    [PseudoMetricSpace α] {K : Set α} {L : Nat}
    {rho : Fin (L + 1) → ℝ}
    (hρ : ∀ i, 0 < rho i) (hK : TotallyBounded K) :
    ∃ levels : Fin (L + 1) → Finset α,
      (∀ i, IsInternalEpsilonNet K (levels i : Set α) (rho i)) ∧
      (∀ i, coveringNumber K (rho i) = (levels i).card) ∧
      (∀ i, (levels i).card = (coveringNumber K (rho i)).toNat) := by
  have hex : ∀ i : Fin (L + 1), ∃ N : Finset α,
      IsInternalEpsilonNet K (N : Set α) (rho i) ∧
        coveringNumber K (rho i) = (N.card : ENat) ∧
        N.card = (coveringNumber K (rho i)).toNat := by
    intro i
    exact exists_finset_isInternalEpsilonNet_of_totallyBounded (hρ i) hK
  choose levels hlevels using hex
  refine ⟨levels, ?_, ?_, ?_⟩
  · intro i
    exact (hlevels i).1
  · intro i
    exact (hlevels i).2.1
  · intro i
    exact (hlevels i).2.2

/-- Package a finite positive-radius net family with its adjacent parent maps. -/
theorem exists_finset_internalNetFamily_parentMap_of_totallyBounded
    {α : Type*} [PseudoMetricSpace α] {K : Set α} {L : Nat}
    {rho : Fin (L + 1) → ℝ}
    (hρ : ∀ i, 0 < rho i) (hK : TotallyBounded K) :
    ∃ levels : Fin (L + 1) → Finset α,
      ∃ parent : Fin L → α → α,
        (∀ i, IsInternalEpsilonNet K (levels i : Set α) (rho i)) ∧
        (∀ i, coveringNumber K (rho i) = (levels i).card) ∧
        (∀ i, (levels i).card = (coveringNumber K (rho i)).toNat) ∧
        (∀ k x, x ∈ levels (Fin.succ k) →
          parent k x ∈ levels (Fin.castSucc k)) ∧
        (∀ k x, x ∈ levels (Fin.succ k) →
          dist x (parent k x) ≤ rho (Fin.castSucc k)) := by
  obtain ⟨levels, hlevels, hcard, htoNat⟩ :=
    exists_finset_internalNetFamily_of_totallyBounded hρ hK
  obtain ⟨parent, hparent_mem, hparent_dist⟩ :=
    exists_finset_parentMap_of_internalRadiusLevels
      (fun k => hlevels (Fin.castSucc k))
      (fun k => (hlevels (Fin.succ k)).1)
      (fun k => hρ (Fin.castSucc k))
  exact ⟨levels, parent, hlevels, hcard, htoNat, hparent_mem, hparent_dist⟩

/-- Add a finite compatible path for every endpoint in the terminal net. -/
theorem exists_finset_internalNetFamily_parentMap_path_of_totallyBounded
    {α : Type*} [PseudoMetricSpace α] {K : Set α} {L : Nat}
    {rho : Fin (L + 1) → ℝ}
    (hρ : ∀ i, 0 < rho i) (hK : TotallyBounded K) :
    ∃ levels : Fin (L + 1) → Finset α,
      ∃ parent : Fin L → α → α,
        (∀ i, IsInternalEpsilonNet K (levels i : Set α) (rho i)) ∧
        (∀ i, coveringNumber K (rho i) = (levels i).card) ∧
        (∀ i, (levels i).card = (coveringNumber K (rho i)).toNat) ∧
        (∀ k x, x ∈ levels (Fin.succ k) →
          parent k x ∈ levels (Fin.castSucc k)) ∧
        (∀ k x, x ∈ levels (Fin.succ k) →
          dist x (parent k x) ≤ rho (Fin.castSucc k)) ∧
        (∀ x, x ∈ levels (Fin.last L) →
          ∃ path : Fin (L + 1) → α,
            path (Fin.last L) = x ∧
            (∀ j, path j ∈ levels j) ∧
            (∀ k : Fin L,
              path (Fin.castSucc k) = parent k (path (Fin.succ k)) ∧
              dist (path (Fin.succ k))
                (parent k (path (Fin.succ k))) ≤ rho (Fin.castSucc k))) := by
  obtain ⟨levels, parent, hlevels, hcard, htoNat, hparent_mem, hparent_dist⟩ :=
    exists_finset_internalNetFamily_parentMap_of_totallyBounded hρ hK
  refine ⟨levels, parent, hlevels, hcard, htoNat, hparent_mem, hparent_dist, ?_⟩
  intro x hx
  exact exists_finset_path_of_parentMap hparent_mem
    (fun k y hy => hparent_dist k y hy) hx

/-- The standard positive dyadic radius schedule at base scale `R`. -/
def dyadicRadius (R : ℝ) (i : Nat) : ℝ := R / (2 : ℝ) ^ i

theorem dyadicRadius_pos {R : ℝ} (hR : 0 < R) (i : Nat) :
    0 < dyadicRadius R i := by
  dsimp [dyadicRadius]
  positivity

/-- The finite entropy sum for an explicit natural cardinality family. -/
def finiteEntropySum {L : Nat}
    (rho : Fin (L + 1) → ℝ) (N : Fin L → Nat) (sigma : ℝ) : ℝ :=
  ∑ k : Fin L,
    (sigma * rho (Fin.castSucc k)) * Real.sqrt
      (2 * Real.log
        (2 * (N k : ℝ)))

/-- The dyadic finite entropy sum is bounded by the covering-number entropy
integral, with the first dyadic interval retained in the integral. -/
theorem finiteEntropySum_dyadic_le_four_mul_intervalIntegral_coveringNumber
    {α : Type*} [PseudoMetricSpace α]
    {K : Set α} {L : Nat} {R sigma : ℝ}
    (hR : 0 < R) (hsigma : 0 ≤ sigma) (N : Fin L → Nat)
    (hN : ∀ k : Fin L,
      coveringNumber K (dyadicRadius R ((k : Nat) + 1)) = (N k : ENat))
    (hfinite : coveringNumber K (dyadicRadius R (L + 1)) ≠ ⊤) :
    finiteEntropySum (fun i : Fin (L + 1) => dyadicRadius R (i : Nat)) N sigma ≤
      4 * sigma *
        (∫ t in dyadicRadius R (L + 1)..R,
          Real.sqrt (2 * Real.log
            (2 * ((coveringNumber K t).toNat : ℝ)))) := by
  classical
  let f : ℝ → ℝ := fun t =>
    Real.sqrt (2 * Real.log
      (2 * ((coveringNumber K t).toNat : ℝ)))
  let a : Nat → ℝ := fun k => dyadicRadius R (k + 1)
  have hRadius : ∀ {i j : Nat}, i ≤ j →
      dyadicRadius R j ≤ dyadicRadius R i := by
    intro i j hij
    rw [dyadicRadius, dyadicRadius]
    apply (div_le_div_iff_of_pos_left hR (by positivity) (by positivity)).2
    exact pow_le_pow_right₀ (by norm_num) hij
  have hdyadic : ∀ k : Nat,
      dyadicRadius R k = 4 *
        (dyadicRadius R (k + 1) - dyadicRadius R ((k + 1) + 1)) := by
    intro k
    rw [dyadicRadius, dyadicRadius, dyadicRadius]
    field_simp
    simp [pow_succ]
    ring
  have haL0 : a L ≤ a 0 := by
    dsimp [a]
    apply hRadius
    omega
  have ha0R : a 0 ≤ R := by
    dsimp [a]
    have h := hRadius (i := 0) (j := 1) (by omega)
    simpa [dyadicRadius] using h
  have haLR : a L ≤ R := haL0.trans ha0R
  have hfinite_on : ∀ t ∈ Set.Icc (dyadicRadius R (L + 1)) R,
      coveringNumber K t ≠ ⊤ := by
    intro t ht
    apply ne_top_of_le_ne_top hfinite
    change Metric.coveringNumber (epsilonRadius t) K ≤
      Metric.coveringNumber (epsilonRadius (dyadicRadius R (L + 1))) K
    exact Metric.coveringNumber_anti (Real.toNNReal_mono ht.1)
  have hf_anti : AntitoneOn f
      (Set.Icc (dyadicRadius R (L + 1)) R) := by
    intro x hx y hy hxy
    dsimp [f]
    have hcx := hfinite_on x hx
    have hcy := hfinite_on y hy
    have hcover : coveringNumber K y ≤ coveringNumber K x := by
      change Metric.coveringNumber (epsilonRadius y) K ≤
        Metric.coveringNumber (epsilonRadius x) K
      exact Metric.coveringNumber_anti (Real.toNNReal_mono hxy)
    have hnat : (coveringNumber K y).toNat ≤
        (coveringNumber K x).toNat :=
      ENat.toNat_le_toNat hcover hcx
    have hreal : ((coveringNumber K y).toNat : ℝ) ≤
        ((coveringNumber K x).toNat : ℝ) :=
      Nat.cast_le.mpr hnat
    by_cases hyzero : coveringNumber K y = 0
    · have hytoNat : (coveringNumber K y).toNat = 0 := by
        simp [hyzero]
      rw [hytoNat]
      simp
    · have hytoNat_ne : (coveringNumber K y).toNat ≠ 0 := by
        intro hytoNat
        apply hyzero
        rw [← ENat.coe_toNat hcy, hytoNat]
        simp
      have hypos : 0 < ((coveringNumber K y).toNat : ℝ) :=
        Nat.cast_pos.mpr (Nat.pos_of_ne_zero hytoNat_ne)
      apply Real.sqrt_le_sqrt
      apply mul_le_mul_of_nonneg_left
        (Real.log_le_log (by positivity) (by nlinarith : 2 *
          ((coveringNumber K y).toNat : ℝ) ≤
          2 * ((coveringNumber K x).toNat : ℝ)))
        (by norm_num)
  have hf_anti_u : AntitoneOn f
      (Set.uIcc (dyadicRadius R (L + 1)) R) := by
    rw [Set.uIcc_of_le haLR]
    exact hf_anti
  have hf_int : IntervalIntegrable f MeasureTheory.volume
      (dyadicRadius R (L + 1)) R :=
    hf_anti_u.intervalIntegrable
  have hanti_short : AntitoneOn f (Set.Icc (a L) (a 0)) := by
    apply hf_anti.mono
    intro x hx
    exact ⟨hx.1, hx.2.trans ha0R⟩
  have hrect := sum_mul_sub_le_intervalIntegral_of_antitoneOn
      (f := f) (a := a) (m := 0) (n := L)
      (by omega)
      (by
        intro k hk
        dsimp [a]
        apply hRadius
        omega)
      (by simpa [a] using hanti_short)
  have hfi_short : IntervalIntegrable f MeasureTheory.volume (a L) (a 0) :=
    hf_int.mono_set (by
      rw [Set.uIcc_of_le haL0, Set.uIcc_of_le haLR]
      exact Set.Icc_subset_Icc le_rfl ha0R)
  have hfi_first : IntervalIntegrable f MeasureTheory.volume (a 0) R :=
    hf_int.mono_set (by
      rw [Set.uIcc_of_le ha0R, Set.uIcc_of_le haLR]
      exact Set.Icc_subset_Icc haL0 le_rfl)
  have hfirst_nonneg : 0 ≤ ∫ x in a 0..R, f x :=
    intervalIntegral.integral_nonneg ha0R (fun x hx => Real.sqrt_nonneg _)
  have hrect_full : (∫ x in a L..a 0, f x) ≤
      ∫ x in a L..R, f x := by
    rw [← intervalIntegral.integral_add_adjacent_intervals hfi_short hfi_first]
    exact le_add_of_nonneg_right hfirst_nonneg
  have hindex {g : Nat → ℝ} :
      (∑ k : Fin L, g (k : Nat)) =
        ∑ k ∈ Finset.Ico 0 L, g k := by
    rw [Finset.sum_fin_eq_sum_range, Nat.Ico_zero_eq_range]
    apply Finset.sum_congr rfl
    intro k hk
    have hk' : k < L := Finset.mem_range.mp hk
    simp [hk']
  have hterm (k : Fin L) :
      (sigma * dyadicRadius R (k : Nat)) *
          Real.sqrt (2 * Real.log (2 * (N k : ℝ))) =
        (4 * sigma) *
          ((a (k : Nat) - a ((k : Nat) + 1)) * f (a (k : Nat))) := by
    have htoNat : (coveringNumber K (dyadicRadius R ((k : Nat) + 1))).toNat =
        N k := by
      have := congrArg ENat.toNat (hN k)
      simpa using this
    dsimp [a, f]
    rw [htoNat]
    rw [hdyadic]
    ring
  calc
    finiteEntropySum (fun i : Fin (L + 1) => dyadicRadius R (i : Nat)) N sigma =
        ∑ k : Fin L,
          (sigma * dyadicRadius R (k : Nat)) *
            Real.sqrt (2 * Real.log (2 * (N k : ℝ))) := by
      simp [finiteEntropySum]
    _ = ∑ k : Fin L,
          (4 * sigma) *
            ((a (k : Nat) - a ((k : Nat) + 1)) * f (a (k : Nat))) := by
      apply Finset.sum_congr rfl
      intro k hk
      exact hterm k
    _ = (4 * sigma) *
          (∑ k ∈ Finset.Ico 0 L,
            (a k - a (k + 1)) * f (a k)) := by
      calc
        (∑ k : Fin L,
            (4 * sigma) *
              ((a (k : Nat) - a ((k : Nat) + 1)) * f (a (k : Nat)))) =
            (4 * sigma) *
              (∑ k : Fin L,
                (a (k : Nat) - a ((k : Nat) + 1)) * f (a (k : Nat))) := by
          rw [Finset.mul_sum]
        _ = (4 * sigma) *
              (∑ k ∈ Finset.Ico 0 L,
                (a k - a (k + 1)) * f (a k)) := by
          exact congrArg (fun z : ℝ => (4 * sigma) * z)
            (hindex (g := fun k =>
              (a k - a (k + 1)) * f (a k)))
    _ ≤ (4 * sigma) * (∫ x in a L..a 0, f x) := by
      exact mul_le_mul_of_nonneg_left hrect (by positivity)
    _ ≤ (4 * sigma) * (∫ x in a L..R, f x) := by
      exact mul_le_mul_of_nonneg_left hrect_full (by positivity)
    _ = 4 * sigma *
          (∫ t in dyadicRadius R (L + 1)..R,
            Real.sqrt (2 * Real.log
              (2 * ((coveringNumber K t).toNat : ℝ)))) := by
      simp [a, f]

end

end HighDimProb
