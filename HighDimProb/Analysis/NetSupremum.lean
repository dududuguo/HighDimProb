import HighDimProb.Nets

set_option autoImplicit false

namespace HighDimProb

open Filter

private theorem exists_mem_dist_le_of_isInternalEpsilonNet
    {alpha : Type*} [PseudoMetricSpace alpha]
    {K N : Set alpha} {eps : Real}
    (hnet : IsInternalEpsilonNet K N eps) (heps : 0 <= eps)
    {x : alpha} (hx : x ∈ K) :
    ∃ y, y ∈ N ∧ dist x y <= eps := by
  obtain ⟨y, hy, hxy⟩ := hnet.2 hx
  refine ⟨y, hy, ?_⟩
  change edist x y ≤ (epsilonRadius eps : ENNReal) at hxy
  rw [edist_le_coe] at hxy
  have hxy' : (nndist x y : Real) <= (epsilonRadius eps : Real) :=
    NNReal.coe_le_coe.mpr hxy
  rw [Real.coe_toNNReal eps heps, ← dist_nndist] at hxy'
  exact hxy'

/-- A shrinking positive internal-net family makes the image of a uniformly
continuous real function bounded above. The bound is supplied by one finite
net at a scale below the continuity modulus for tolerance `1`. -/
theorem bddAbove_image_of_uniformContinuousOn_of_isInternalEpsilonNet
    {alpha : Type*} [PseudoMetricSpace alpha]
    {K : Set alpha} {T : Nat -> Finset alpha} {eps : Nat -> Real}
    {f : alpha -> Real}
    (hT : forall n, (T n).Nonempty)
    (hnet : forall n, IsInternalEpsilonNet K (T n : Set alpha) (eps n))
    (heps_pos : forall n, 0 < eps n)
    (heps : Tendsto eps atTop (nhds 0))
    (hf : UniformContinuousOn f K) :
    BddAbove (f '' K) := by
  obtain ⟨delta, hdelta, hdelta_f⟩ :=
    (Metric.uniformContinuousOn_iff.mp hf) 1 zero_lt_one
  have hsmall : ∀ᶠ n in atTop, eps n < delta :=
    (tendsto_order.1 heps).2 delta hdelta
  obtain ⟨n, hn⟩ := Filter.Eventually.exists hsmall
  refine ⟨(T n).sup' (hT n) f + 1, ?_⟩
  rintro _ ⟨x, hx, rfl⟩
  obtain ⟨y, hy, hxy⟩ :=
    exists_mem_dist_le_of_isInternalEpsilonNet (hnet n) (le_of_lt (heps_pos n)) hx
  have hxy_lt : dist x y < delta := lt_of_le_of_lt hxy hn
  have hdist_f := hdelta_f x hx y ((hnet n).1 hy) hxy_lt
  have habs : abs (f x - f y) < 1 := by
    simpa [Real.dist_eq] using hdist_f
  have hfx : f x < f y + 1 := by
    have hupper_diff : f x - f y < 1 := (abs_lt.mp habs).2
    linarith
  have hy_sup : f y <= (T n).sup' (hT n) f :=
    Finset.le_sup' f (Finset.mem_coe.mp hy)
  linarith

/-- Finite internal-net suprema converge to the supremum on `K`. The
`BddAbove` premise is explicit because uniform continuity alone does not
bound a function on an arbitrary set. -/
theorem tendsto_finset_sup'_of_isInternalEpsilonNet
    {alpha : Type*} [PseudoMetricSpace alpha]
    {K : Set alpha} {T : Nat -> Finset alpha} {eps : Nat -> Real}
    {f : alpha -> Real}
    (hK : K.Nonempty)
    (hT : forall n, (T n).Nonempty)
    (hnet : forall n, IsInternalEpsilonNet K (T n : Set alpha) (eps n))
    (heps_pos : forall n, 0 < eps n)
    (heps : Tendsto eps atTop (nhds 0))
    (hf : UniformContinuousOn f K)
    (hfbdd : BddAbove (f '' K)) :
    Tendsto (fun n => (T n).sup' (hT n) f) atTop
      (nhds (sSup (f '' K))) := by
  let s : Real := sSup (f '' K)
  change Tendsto (fun n => (T n).sup' (hT n) f) atTop (nhds s)
  have himage : (f '' K).Nonempty := hK.image f
  have hupper : forall n, (T n).sup' (hT n) f <= s := by
    intro n
    apply Finset.sup'_le (hT n) f
    intro x hx
    apply le_csSup hfbdd
    exact ⟨x, (hnet n).1 (Finset.mem_coe.mp hx), rfl⟩
  apply tendsto_order.2
  constructor
  · intro a ha
    have hex : ∃ x, x ∈ K ∧ (a + s) / 2 < f x := by
      by_contra h
      have hle : forall x, x ∈ K -> f x <= (a + s) / 2 := by
        intro x hx
        exact le_of_not_gt (fun hxf => h ⟨x, hx, hxf⟩)
      have hs_le : s <= (a + s) / 2 := by
        apply csSup_le himage
        rintro _ ⟨x, hx, rfl⟩
        exact hle x hx
      linarith
    obtain ⟨x, hx, hxval⟩ := hex
    have heta : 0 < (s - a) / 2 := by linarith
    obtain ⟨delta, hdelta, hdelta_f⟩ :=
      (Metric.uniformContinuousOn_iff.mp hf) ((s - a) / 2) heta
    have hsmall : ∀ᶠ n in atTop, eps n < delta :=
      (tendsto_order.1 heps).2 delta hdelta
    filter_upwards [hsmall] with n hn
    obtain ⟨y, hy, hxy⟩ :=
      exists_mem_dist_le_of_isInternalEpsilonNet
        (hnet n) (le_of_lt (heps_pos n)) hx
    have hxy_lt : dist x y < delta := lt_of_le_of_lt hxy hn
    have hdist_f := hdelta_f x hx y ((hnet n).1 hy) hxy_lt
    have habs : abs (f x - f y) < (s - a) / 2 := by
      simpa [Real.dist_eq] using hdist_f
    have hfy : a < f y := by
      have hlower : f x - (s - a) / 2 < f y := by
        have hupper_diff : f x - f y < (s - a) / 2 := (abs_lt.mp habs).2
        linarith
      linarith
    exact lt_of_lt_of_le hfy (Finset.le_sup' f (Finset.mem_coe.mp hy))
  · intro b hb
    exact Filter.Eventually.of_forall (fun n => lt_of_le_of_lt (hupper n) hb)

/-- The bounded-above premise in the core theorem follows from uniform
continuity and the same shrinking positive internal-net family. -/
theorem tendsto_finset_sup'_of_uniformContinuousOn_of_isInternalEpsilonNet
    {alpha : Type*} [PseudoMetricSpace alpha]
    {K : Set alpha} {T : Nat -> Finset alpha} {eps : Nat -> Real}
    {f : alpha -> Real}
    (hK : K.Nonempty)
    (hT : forall n, (T n).Nonempty)
    (hnet : forall n, IsInternalEpsilonNet K (T n : Set alpha) (eps n))
    (heps_pos : forall n, 0 < eps n)
    (heps : Tendsto eps atTop (nhds 0))
    (hf : UniformContinuousOn f K) :
    Tendsto (fun n => (T n).sup' (hT n) f) atTop
      (nhds (sSup (f '' K))) := by
  exact tendsto_finset_sup'_of_isInternalEpsilonNet
    hK hT hnet heps_pos heps hf
    (bddAbove_image_of_uniformContinuousOn_of_isInternalEpsilonNet
      hT hnet heps_pos heps hf)

/-- Apply the supremum convergence theorem to the increment modulus rooted at
`t0 ∈ K`. -/
theorem tendsto_finset_sup'_abs_sub_of_uniformContinuousOn_of_isInternalEpsilonNet
    {alpha : Type*} [PseudoMetricSpace alpha]
    {K : Set alpha} {T : Nat -> Finset alpha} {eps : Nat -> Real}
    {f : alpha -> Real} {t0 : alpha}
    (ht0 : t0 ∈ K)
    (hT : forall n, (T n).Nonempty)
    (hnet : forall n, IsInternalEpsilonNet K (T n : Set alpha) (eps n))
    (heps_pos : forall n, 0 < eps n)
    (heps : Tendsto eps atTop (nhds 0))
    (hf : UniformContinuousOn f K) :
    Tendsto
      (fun n => (T n).sup' (hT n) (fun t => abs (f t - f t0))) atTop
      (nhds (sSup ((fun t => abs (f t - f t0)) '' K))) := by
  have hmod : UniformContinuousOn (fun t => abs (f t - f t0)) K := by
    apply Metric.uniformContinuousOn_iff.2
    intro eta heta
    obtain ⟨delta, hdelta, hdelta_f⟩ :=
      (Metric.uniformContinuousOn_iff.mp hf) eta heta
    refine ⟨delta, hdelta, ?_⟩
    intro x hx y hy hxy
    calc
      dist (abs (f x - f t0)) (abs (f y - f t0)) =
          abs (abs (f x - f t0) - abs (f y - f t0)) := Real.dist_eq _ _
      _ <= abs ((f x - f t0) - (f y - f t0)) :=
        abs_abs_sub_abs_le_abs_sub _ _
      _ = dist (f x) (f y) := by
        rw [Real.dist_eq]
        congr 1
        ring
      _ < eta := hdelta_f x hx y hy hxy
  exact tendsto_finset_sup'_of_uniformContinuousOn_of_isInternalEpsilonNet
    (K := K) (T := T) (eps := eps)
    (f := fun t => abs (f t - f t0))
    ⟨t0, ht0⟩ hT hnet heps_pos heps hmod

end HighDimProb
