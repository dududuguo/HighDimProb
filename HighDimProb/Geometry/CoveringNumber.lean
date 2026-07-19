import HighDimProb.MetricEntropy
import Mathlib.MeasureTheory.Measure.Lebesgue.VolumeOfBalls

/-!
# Volumetric covering bounds

Finite-dimensional Euclidean balls have the standard volumetric covering bound.
The l1-ball bound below is obtained from its Euclidean-ball containment.
-/

namespace HighDimProb

open scoped BigOperators ENNReal NNReal Topology

noncomputable section

private lemma volume_disjoint_union_closedBalls
    {ι : Type*} [Fintype ι] {t : Finset (EuclideanSpace ℝ ι)} {eps : ℝ}
    (hsep : ∀ x ∈ t, ∀ y ∈ t, x ≠ y -> eps < dist x y) :
    MeasureTheory.volume (⋃ x ∈ t, Metric.closedBall x (eps / 2)) =
      ∑ x ∈ t, MeasureTheory.volume (Metric.closedBall x (eps / 2)) := by
  apply MeasureTheory.measure_biUnion_finset
  · intro x hx y hy hxy
    apply Metric.closedBall_disjoint_closedBall
    linarith [hsep x hx y hy hxy]
  · intro x hx
    exact measurableSet_closedBall

private lemma packing_card_bound
    {ι : Type*} [Nonempty ι] [Fintype ι]
    {t : Finset (EuclideanSpace ℝ ι)} {R eps : ℝ}
    (hR : 0 ≤ R) (heps : 0 < eps)
    (hsub : (t : Set (EuclideanSpace ℝ ι)) ⊆ Metric.closedBall 0 R)
    (hsep : ∀ x ∈ t, ∀ y ∈ t, x ≠ y -> eps < dist x y) :
    (t.card : ℝ) ≤ (1 + 2 * R / eps) ^ Fintype.card ι := by
  have hsub_union : (⋃ x ∈ t, Metric.closedBall x (eps / 2)) ⊆
      Metric.closedBall (0 : EuclideanSpace ℝ ι) (R + eps / 2) := by
    intro z hz
    rw [Set.mem_iUnion₂] at hz
    obtain ⟨x, hx, hzx⟩ := hz
    have hxR := hsub hx
    rw [Metric.mem_closedBall] at hxR hzx ⊢
    simp only [dist_zero_right] at hxR ⊢
    calc
      ‖z‖ = ‖z - x + x‖ := by rw [sub_add_cancel]
      _ ≤ ‖z - x‖ + ‖x‖ := norm_add_le _ _
      _ = dist z x + ‖x‖ := by rw [dist_eq_norm]
      _ ≤ eps / 2 + R := by linarith
      _ = R + eps / 2 := by ring
  have hvol_le :
      MeasureTheory.volume (⋃ x ∈ t, Metric.closedBall x (eps / 2)) ≤
        MeasureTheory.volume
          (Metric.closedBall (0 : EuclideanSpace ℝ ι) (R + eps / 2)) :=
    MeasureTheory.measure_mono hsub_union
  have hvol_eq := volume_disjoint_union_closedBalls hsep
  have hc : 0 < Real.sqrt Real.pi ^ Fintype.card ι /
      Real.Gamma (Fintype.card ι / 2 + 1) := by
    apply div_pos
    · exact pow_pos (Real.sqrt_pos.mpr Real.pi_pos) _
    · have hd : 0 < (Fintype.card ι : ℝ) / 2 + 1 := by positivity
      exact Real.Gamma_pos_of_pos hd
  let c : ℝ := Real.sqrt Real.pi ^ Fintype.card ι /
      Real.Gamma (Fintype.card ι / 2 + 1)
  have hvol (x : EuclideanSpace ℝ ι) {r : ℝ} (hr : 0 ≤ r) :
      MeasureTheory.volume (Metric.closedBall x r) =
        ENNReal.ofReal (r ^ Fintype.card ι * c) := by
    have hpow : ENNReal.ofReal r ^ Fintype.card ι =
        ENNReal.ofReal (r ^ Fintype.card ι) := by
      induction Fintype.card ι with
      | zero => simp
      | succ n ih =>
          rw [pow_succ, pow_succ, ih]
          rw [mul_comm (ENNReal.ofReal _ ) (ENNReal.ofReal r)]
          rw [← ENNReal.ofReal_mul hr]
          rw [mul_comm r (r ^ n)]
    rw [EuclideanSpace.volume_closedBall, hpow]
    dsimp [c]
    rw [← ENNReal.ofReal_mul (pow_nonneg hr _)]
  have heps2 : 0 ≤ eps / 2 := by linarith
  have hR2 : 0 ≤ R + eps / 2 := by linarith
  have hvol_le' :
      (t.card : ℝ) * ((eps / 2) ^ Fintype.card ι * c) ≤
        (R + eps / 2) ^ Fintype.card ι * c := by
    have hvol_sum : ∑ x ∈ t, MeasureTheory.volume
        (Metric.closedBall x (eps / 2)) =
        (t.card : ENNReal) * ENNReal.ofReal ((eps / 2) ^ Fintype.card ι * c) := by
      simp_rw [hvol _ heps2]
      rw [Finset.sum_const]
      simp only [nsmul_eq_mul]
    have hvol_le'' := hvol_le
    rw [hvol_eq, hvol_sum, hvol 0 hR2] at hvol_le''
    rw [← ENNReal.ofReal_natCast,
      ← ENNReal.ofReal_mul (Nat.cast_nonneg _)] at hvol_le''
    exact (ENNReal.ofReal_le_ofReal_iff (mul_nonneg
      (pow_nonneg hR2 _) hc.le)).mp hvol_le''
  have hsmall_pos : 0 < (eps / 2) ^ Fintype.card ι * c :=
    mul_pos (pow_pos (by linarith) _) hc
  have hcancel : (t.card : ℝ) ≤
      (R + eps / 2) ^ Fintype.card ι / (eps / 2) ^ Fintype.card ι := by
    have hne : (eps / 2) ^ Fintype.card ι * c ≠ 0 := ne_of_gt hsmall_pos
    calc
      (t.card : ℝ) =
          (t.card : ℝ) * ((eps / 2) ^ Fintype.card ι * c) /
            ((eps / 2) ^ Fintype.card ι * c) := by
              rw [mul_div_cancel_right₀ _ hne]
      _ ≤ ((R + eps / 2) ^ Fintype.card ι * c) /
            ((eps / 2) ^ Fintype.card ι * c) := by
              exact div_le_div_of_nonneg_right hvol_le' hsmall_pos.le
      _ = (R + eps / 2) ^ Fintype.card ι /
            (eps / 2) ^ Fintype.card ι := by
              rw [mul_div_mul_right _ _ (ne_of_gt hc)]
  calc
    (t.card : ℝ) ≤ (R + eps / 2) ^ Fintype.card ι /
        (eps / 2) ^ Fintype.card ι := hcancel
    _ = ((R + eps / 2) / (eps / 2)) ^ Fintype.card ι := by rw [← div_pow]
    _ = (1 + 2 * R / eps) ^ Fintype.card ι := by
      field_simp
      ring

/-- The finite-dimensional coordinatewise l1-ball of radius `R`.

The definition itself also covers the empty index type; the covering theorem
below uses `[Nonempty ι]` for the Euclidean volume formula.
-/
def l1Ball {ι : Type*} [Fintype ι] (R : ℝ) : Set (EuclideanSpace ℝ ι) :=
  {x | ∑ i, ‖x i‖ ≤ R}

private lemma l1Ball_subset_closedBall
    {ι : Type*} [Fintype ι] {R : ℝ} (hR : 0 ≤ R) :
    l1Ball R ⊆ Metric.closedBall (0 : EuclideanSpace ℝ ι) R := by
  intro x hx
  rw [Metric.mem_closedBall]
  simp only [dist_zero_right]
  rw [EuclideanSpace.norm_eq]
  have hsum : ∑ i, ‖x i‖ ^ 2 ≤ (∑ i, ‖x i‖) ^ 2 := by
    calc
      ∑ i, ‖x i‖ ^ 2 ≤ ∑ i, ‖x i‖ * ∑ j, ‖x j‖ := by
        apply Finset.sum_le_sum
        intro i hi
        simpa [pow_two] using mul_le_mul_of_nonneg_left
          (Finset.single_le_sum (fun j hj => norm_nonneg (x j)) (Finset.mem_univ i))
          (norm_nonneg (x i))
      _ = (∑ i, ‖x i‖) ^ 2 := by
        rw [← Finset.sum_mul]
        ring
  have hsqrt : 0 ≤ Real.sqrt (∑ i, ‖x i‖ ^ 2) := Real.sqrt_nonneg _
  have hsqrt_sq : (Real.sqrt (∑ i, ‖x i‖ ^ 2)) ^ 2 = ∑ i, ‖x i‖ ^ 2 := by
    rw [Real.sq_sqrt]
    exact Finset.sum_nonneg fun i hi => sq_nonneg _
  have hxR : ∑ i, ‖x i‖ ≤ R := hx
  have hsum_nonneg : 0 ≤ ∑ i, ‖x i‖ :=
    Finset.sum_nonneg fun i hi => norm_nonneg (x i)
  have hsum_sq : (∑ i, ‖x i‖) ^ 2 ≤ R ^ 2 := by
    nlinarith
  nlinarith

private lemma packingNumber_closedBall_ne_top
    {ι : Type*} [Nonempty ι] [Fintype ι] {R eps : ℝ}
    (heps : 0 < eps) :
    packingNumber (Metric.closedBall (0 : EuclideanSpace ℝ ι) R) eps ≠ ⊤ := by
  let K : Set (EuclideanSpace ℝ ι) := Metric.closedBall 0 R
  obtain ⟨N, _, hNcover, _⟩ :=
    exists_finset_isInternalEpsilonNet_of_totallyBounded (K := K)
      (by linarith : 0 < eps / 2)
      (by simpa [K] using
        (isCompact_closedBall (0 : EuclideanSpace ℝ ι) R).totallyBounded)
  have hcover : coveringNumber K (eps / 2) ≠ ⊤ := by
    rw [hNcover]
    exact ENat.coe_ne_top _
  have hle : packingNumber K (2 * (eps / 2)) ≤ coveringNumber K (eps / 2) :=
    (packingCoveringInequality K (eps / 2)).1
  rw [show 2 * (eps / 2) = eps by ring] at hle
  exact ne_top_of_le_ne_top hcover hle

/-- Internal covering number of a Euclidean closed ball is at most
`ceil ((1 + 2 * R / eps)^card)`.

The `[Nonempty ι]` hypothesis is the deliberate boundary of this volumetric
leaf, matching Mathlib's `EuclideanSpace.volume_closedBall` API.
-/
theorem coveringNumber_euclideanBall_le
    {ι : Type*} [Nonempty ι] [Fintype ι] {R eps : ℝ}
    (hR : 0 ≤ R) (heps : 0 < eps) :
    coveringNumber (Metric.closedBall (0 : EuclideanSpace ℝ ι) R) eps ≤
      (Nat.ceil ((1 + 2 * R / eps) ^ Fintype.card ι) : ENat) := by
  let K : Set (EuclideanSpace ℝ ι) := Metric.closedBall 0 R
  have hpack := packingNumber_closedBall_ne_top (ι := ι) (R := R) (eps := eps) heps
  let S := Metric.maximalSeparatedSet (epsilonRadius eps) K
  have hSsub : S ⊆ K := Metric.maximalSeparatedSet_subset
  have hSsep : Metric.IsSeparated (epsilonRadius eps : ENNReal) S :=
    Metric.isSeparated_maximalSeparatedSet
  have hSencard : S.encard = packingNumber K eps := by
    change S.encard = Metric.packingNumber (epsilonRadius eps) K
    exact Metric.encard_maximalSeparatedSet hpack
  have hSfin : S.Finite := Set.encard_ne_top_iff.mp (by
    rw [hSencard]
    exact hpack)
  let T : Finset (EuclideanSpace ℝ ι) := hSfin.toFinset
  have hTcoe : (T : Set (EuclideanSpace ℝ ι)) = S := by
    exact Set.Finite.coe_toFinset hSfin
  have hTsub : (T : Set (EuclideanSpace ℝ ι)) ⊆ K := by
    rw [hTcoe]
    exact hSsub
  have hTsep : ∀ x ∈ T, ∀ y ∈ T, x ≠ y -> eps < dist x y := by
    intro x hx y hy hxy
    have hxy' : (epsilonRadius eps : ENNReal) < edist x y := by
      exact hSsep (hTcoe ▸ hx) (hTcoe ▸ hy) hxy
    simpa [epsilonRadius, edist_dist, Real.toNNReal_of_nonneg heps.le] using hxy'
  have hcard_real : (T.card : ℝ) ≤
      (1 + 2 * R / eps) ^ Fintype.card ι :=
    packing_card_bound hR heps hTsub hTsep
  have hcard : T.card ≤ Nat.ceil ((1 + 2 * R / eps) ^ Fintype.card ι) := by
    exact_mod_cast hcard_real.trans (Nat.le_ceil _)
  calc
    coveringNumber K eps ≤ packingNumber K eps :=
      (packingCoveringInequality K eps).2
    _ = (T.card : ENat) := by
      rw [← hSencard]
      simpa [T] using hSfin.encard_eq_coe_toFinset_card
    _ ≤ (Nat.ceil ((1 + 2 * R / eps) ^ Fintype.card ι) : ENat) := by
      exact_mod_cast hcard

/-- Internal covering number of an l1-ball is at most
`ceil ((1 + 4 * R / eps)^card)` by Euclidean-ball containment.

The `[Nonempty ι]` hypothesis is the deliberate boundary of this volumetric
bound; the constant `4` comes from the subset comparison at radius `eps / 2`.
-/
theorem coveringNumber_l1Ball_le
    {ι : Type*} [Nonempty ι] [Fintype ι] {R eps : ℝ}
    (hR : 0 ≤ R) (heps : 0 < eps) :
    coveringNumber (l1Ball (ι := ι) R) eps ≤
      (Nat.ceil ((1 + 4 * R / eps) ^ Fintype.card ι) : ENat) := by
  have hsub : l1Ball (ι := ι) R ⊆ Metric.closedBall (0 : EuclideanSpace ℝ ι) R :=
    l1Ball_subset_closedBall hR
  have hhalf := coveringNumber_euclideanBall_le (ι := ι) (R := R) (eps := eps / 2)
    hR (by linarith : 0 < eps / 2)
  have hsubset : coveringNumber (l1Ball (ι := ι) R) eps ≤
      coveringNumber (Metric.closedBall (0 : EuclideanSpace ℝ ι) R) (eps / 2) := by
    have hscale : epsilonRadius (eps / 2) = epsilonRadius eps / 2 := by
      change (eps / 2).toNNReal = eps.toNNReal / (2 : NNReal)
      rw [Real.toNNReal_div heps.le]
      norm_num
    change Metric.coveringNumber (epsilonRadius eps) (l1Ball (ι := ι) R) ≤
      Metric.coveringNumber (epsilonRadius (eps / 2))
        (Metric.closedBall (0 : EuclideanSpace ℝ ι) R)
    rw [hscale]
    exact Metric.coveringNumber_subset_le hsub
  calc
    coveringNumber (l1Ball (ι := ι) R) eps ≤
        coveringNumber (Metric.closedBall (0 : EuclideanSpace ℝ ι) R) (eps / 2) := hsubset
    _ ≤ (Nat.ceil ((1 + 2 * R / (eps / 2)) ^ Fintype.card ι) : ENat) := hhalf
    _ = (Nat.ceil ((1 + 4 * R / eps) ^ Fintype.card ι) : ENat) := by
      congr 2
      congr 1
      field_simp
      ring

end
end HighDimProb
