import HighDimProb.Chaining
import HighDimProb.Concentration.SubGaussianMax
import HighDimProb.MetricEntropy

/-!
# Truncated Dudley inequality for a finite terminal net with a fixed root

This module contains the finite, fixed-root, terminal-net-supremum form of the
truncated Dudley chaining inequality and the dense-sequence full-supremum
endpoint. The separate `DudleyFull` module builds a full consumer from
every-sample uniform continuity instead. This file proves no Gaussian
functional inequality.

The chain of arguments is:

* pointwise terminal-net chaining with a common root
  (`HighDimProb.sup'_abs_sub_root_le_sum_level_sup`), so the supremum bound is
  proved pointwise before any integration;
* integration by monotonicity, giving the expectation of the terminal-net
  supremum by the sum of the expected per-level suprema;
* the finite-maximum subGaussian bound on each level;
* a rooted dyadic net chain constructed internally from total boundedness, with
  base level the singleton `{t₀}` (an internal `R`-net of `K` by the radius
  hypothesis), minimal internal nets at the finer dyadic scales, and parent maps
  into the previous level;
* the existing dyadic finite-entropy-sum to truncated covering-number integral
  comparison.

The high-level consumer
`Dudley.truncatedBound` only asks
for the metric hypotheses on `K`, `t₀`, `R`, the subGaussian increment scale,
and measurability; the nets, parent maps, covering-number equalities, and
finiteness facts are constructed internally.

The module also retains the dense-sequence endpoint `dudleyEntropyIntegral`,
whose continuous-path contract is independent of the uniformly-continuous
finite-net endpoint exposed through `DudleyFull`.
-/

namespace HighDimProb

open MeasureTheory

noncomputable section

private theorem finitePrefixResidual
    {Ω α : Type*} [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ} {K : Set α} {R σ : ℝ}
    (u : ℕ → α) (n : ℕ) (huK : Set.range u ⊆ K)
    (anchor : α)
    (hAnchorNet : IsInternalEpsilonNet K ({anchor} : Set α) R)
    (hK : TotallyBounded K)
    (hXMeas : ∀ x, Measurable (X x))
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hσ : 0 < σ) (hR : 0 < R)
    (hEntropyIntegrable : IntervalIntegrable
      (fun t => Real.sqrt (2 * Real.log
        (2 * ((coveringNumber K t).toNat : ℝ)))) volume 0 R) :
    ∃ r : ℕ → ℝ,
      Filter.Tendsto r Filter.atTop (nhds 0) ∧
        ∀ m : ℕ,
          expect P (fun ω =>
            (Finset.range (n + 1)).sup' Finset.nonempty_range_add_one
              (fun k => |X (u k) ω - X anchor ω|)) ≤
            r m + 4 * σ *
              (∫ t in dyadicRadius R (m + 1)..R,
                Real.sqrt (2 * Real.log
                  (2 * ((coveringNumber K t).toNat : ℝ)))) := by
  classical
  let s : Finset α := (Finset.range (n + 1)).image u
  have hs : s.Nonempty := by
    refine ⟨u 0, ?_⟩
    exact Finset.mem_image.mpr ⟨0, by simp, rfl⟩
  have hsK : ∀ x ∈ s, x ∈ K := by
    intro x hx
    obtain ⟨k, hk, rfl⟩ := Finset.mem_image.mp hx
    exact huK ⟨k, rfl⟩
  let f : ℝ → ℝ := fun t =>
    Real.sqrt (2 * Real.log (2 * ((coveringNumber K t).toNat : ℝ)))
  let r : ℕ → ℝ := fun m =>
    σ * dyadicRadius R (m + 1) *
      Real.sqrt (2 * Real.log (2 * (s.card : ℝ)))
  have hr_tendsto : Filter.Tendsto r Filter.atTop (nhds 0) := by
    have hdyadic : Filter.Tendsto
        (fun m : ℕ => dyadicRadius R (m + 1))
        Filter.atTop (nhds 0) := by
      exact (tendsto_dyadicRadius_atTop R).comp
        (Filter.tendsto_add_atTop_nat 1)
    have hscale : Filter.Tendsto
        (fun m : ℕ => σ * dyadicRadius R (m + 1))
        Filter.atTop (nhds 0) := by
      simpa using (Filter.Tendsto.const_mul σ hdyadic)
    have hfactor : Filter.Tendsto
        (fun _ : ℕ => Real.sqrt (2 * Real.log (2 * (s.card : ℝ))))
        Filter.atTop (nhds (Real.sqrt (2 * Real.log (2 * (s.card : ℝ))))) :=
      tendsto_const_nhds
    simpa [r] using hscale.mul hfactor
  let I : ℕ → ℝ := fun j =>
    ∫ t in dyadicRadius R (j + 1)..R, f t
  have hI_tendsto : Filter.Tendsto I Filter.atTop
      (nhds (∫ t in (0 : ℝ)..R, f t)) := by
    simpa [I] using
      (tendsto_intervalIntegral_dyadicRadius_atTop
        (f := f) (R := R) (le_of_lt hR) hEntropyIntegrable)
  let residualBound : ℕ → ℝ := fun j =>
    r j + 4 * σ * (I (j + 1) - I j)
  have hResidualBound_tendsto :
      Filter.Tendsto residualBound Filter.atTop (nhds 0) := by
    have hshift : Filter.Tendsto (fun j : ℕ => I (j + 1))
        Filter.atTop (nhds (∫ t in (0 : ℝ)..R, f t)) :=
      hI_tendsto.comp (Filter.tendsto_add_atTop_nat 1)
    have hdiff : Filter.Tendsto
        (fun j : ℕ => I (j + 1) - I j) Filter.atTop (nhds 0) := by
      simpa using hshift.sub hI_tendsto
    have hscaled : Filter.Tendsto
        (fun j : ℕ => 4 * σ * (I (j + 1) - I j))
        Filter.atTop (nhds 0) := by
      simpa using (Filter.Tendsto.const_mul (4 * σ) hdiff)
    simpa [residualBound] using hr_tendsto.add hscaled
  refine ⟨residualBound, hResidualBound_tendsto, ?_⟩
  intro m
  obtain ⟨levels, qparent, hlevels, hcard, _, hparent_mem, hparent_dist,
      hterminalPath⟩ :=
    exists_finset_internalNetFamily_parentMap_path_of_totallyBounded
      (rho := fun i : Fin (m + 1) => dyadicRadius R ((i : ℕ) + 1))
      (fun i => by exact dyadicRadius_pos hR ((i : ℕ) + 1)) hK
  have hterminal :
      coveringNumber K (dyadicRadius R (m + 1 + 1)) ≠ ⊤ := by
    obtain ⟨N, _, hNum, _⟩ :=
      exists_finset_isInternalEpsilonNet_of_totallyBounded
        (dyadicRadius_pos hR (m + 1 + 1)) hK
    rw [hNum]
    exact ENat.coe_ne_top _
  obtain ⟨p, hp⟩ :=
    exists_parentMap_of_subset_of_isInternalEpsilonNet
      (A := K) (K := K) (B := (levels (Fin.last m) : Set α))
      (fun _ hx => hx) (hlevels (Fin.last m))
      (dyadicRadius_pos hR (m + 1))
  let proj : α → α := fun x =>
    if hx : x ∈ K then (p ⟨x, hx⟩ : α) else anchor
  have hproj_mem : ∀ x ∈ s, proj x ∈ levels (Fin.last m) := by
    intro x hx
    dsimp [proj]
    simp only [dif_pos (hsK x hx)]
    exact (hp ⟨x, hsK x hx⟩).1
  have hproj_dist : ∀ x ∈ s,
      dist x (proj x) ≤ dyadicRadius R (m + 1) := by
    intro x hx
    dsimp [proj]
    simp only [dif_pos (hsK x hx)]
    exact (hp ⟨x, hsK x hx⟩).2
  have hqexists : ∀ x ∈ s, ∃ qpath : Fin (m + 1) → α,
      qpath (Fin.last m) = proj x ∧
        (∀ j, qpath j ∈ levels j) ∧
        (∀ k : Fin m,
          qpath (Fin.castSucc k) = qparent k (qpath (Fin.succ k)) ∧
          dist (qpath (Fin.succ k))
            (qparent k (qpath (Fin.succ k))) ≤
              dyadicRadius R ((k : ℕ) + 1)) := by
    intro x hx
    exact hterminalPath (proj x) (hproj_mem x hx)
  let qpath : α → Fin (m + 1) → α := fun x =>
    if hx : x ∈ s then Classical.choose (hqexists x hx)
    else fun _ => anchor
  have hqspec : ∀ x ∈ s,
      qpath x (Fin.last m) = proj x ∧
        (∀ j, qpath x j ∈ levels j) ∧
        (∀ k : Fin m,
          qpath x (Fin.castSucc k) = qparent k (qpath x (Fin.succ k)) ∧
          dist (qpath x (Fin.succ k))
            (qparent k (qpath x (Fin.succ k))) ≤
              dyadicRadius R ((k : ℕ) + 1)) := by
    intro x hx
    dsimp [qpath]
    simp only [dif_pos hx]
    exact Classical.choose_spec (hqexists x hx)
  let nextLevel : Fin (m + 1) → Finset α := fun k => levels k
  let parent : Fin (m + 1) → α → α :=
    Fin.cases (fun _ => anchor) (fun k => qparent k)
  let path : α → Fin ((m + 1) + 1) → α := fun x =>
    Fin.cons anchor (qpath x)
  have hpath_last : ∀ x ∈ s,
      path x (Fin.last (m + 1)) = proj x := by
    intro x hx
    simpa [path] using (hqspec x hx).1
  have hmem : ∀ x ∈ s, ∀ k : Fin (m + 1),
      path x (Fin.succ k) ∈ nextLevel k := by
    intro x hx k
    simpa [path, nextLevel] using (hqspec x hx).2.1 k
  have hparent : ∀ x ∈ s, ∀ k : Fin (m + 1),
      path x (Fin.castSucc k) = parent k (path x (Fin.succ k)) := by
    intro x hx k
    refine Fin.cases ?_ (fun j => ?_) k
    · simp [path, parent]
    · simpa [path, parent] using ((hqspec x hx).2.2 j).1
  have hanchor : ∀ x ∈ s, path x 0 = anchor := by
    intro x hx
    simp [path]
  have hAnchorDist : ∀ x ∈ K, dist x anchor ≤ R := by
    intro x hx
    obtain ⟨y, hy, hxy⟩ := hAnchorNet.2 hx
    have hya : y = anchor := by simpa using hy
    subst y
    change edist x anchor ≤ epsilonRadius R at hxy
    have hxy' : nndist x anchor ≤ epsilonRadius R :=
      (edist_le_coe).mp hxy
    have hxy'' : (nndist x anchor : ℝ) ≤ (epsilonRadius R : ℝ) :=
      NNReal.coe_le_coe.mpr hxy'
    simpa [epsilonRadius, Real.toNNReal_of_nonneg hR.le] using hxy''
  have hXMeas' : ∀ k : Fin (m + 1), ∀ x ∈ nextLevel k,
      Measurable (fun ω => X x ω - X (parent k x) ω) := by
    intro k x hx
    exact (hXMeas x).sub (hXMeas (parent k x))
  have hdist : ∀ k : Fin (m + 1), ∀ x ∈ nextLevel k,
      dist x (parent k x) ≤ dyadicRadius R (Fin.castSucc k : ℕ) := by
    intro k
    refine Fin.cases (motive := fun k => ∀ x ∈ nextLevel k,
      dist x (parent k x) ≤ dyadicRadius R (Fin.castSucc k : ℕ))
      ?_ (fun j => ?_) k
    · intro x hx
      have hxK : x ∈ K := (hlevels 0).1 (by simpa [nextLevel] using hx)
      simpa [parent, dyadicRadius] using hAnchorDist x hxK
    · intro x hx
      have hx' : x ∈ levels (Fin.succ j) := by
        simpa [nextLevel] using hx
      simpa [parent, nextLevel] using hparent_dist j x hx'
  have hN : ∀ k : Fin (m + 1),
      coveringNumber K (dyadicRadius R ((k : ℕ) + 1)) =
        ((nextLevel k).card : ENat) := by
    intro k
    simpa [nextLevel] using hcard k
  let residual : RealRandomVariable Ω := fun ω =>
    s.sup' hs (fun x => |X x ω - X (proj x) ω|)
  let Y : RandomProcess Ω α ℝ := fun x ω => X x ω - X (proj x) ω
  have hYMeas : ∀ x ∈ s, Measurable (Y x) := by
    intro x hx
    exact (hXMeas x).sub (hXMeas (proj x))
  have hYSG : ∀ x ∈ s,
      CenteredSubGaussianMGF P (Y x)
        (σ * dyadicRadius R (m + 1)) := by
    intro x hx
    exact HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le
      hX hσ (dyadicRadius_pos hR (m + 1)) (hproj_dist x hx)
  have hresidualIntegrable :
      IntegrableRealRandomVariable P residual := by
    have hSup := integrable_processSup (P := P)
      (X := fun x ω => |Y x ω|) (s := s) hs (by
        intro x hx
        exact (hYSG x hx).2.integrable.abs)
    convert hSup using 1
    funext ω
    simp only [processSup, Finset.sup'_apply, residual, Y]
  have hresidualBound : expect P residual ≤ r m := by
    have hBound := expect_finset_sup'_abs_le_of_centeredSubGaussianMGF
      (P := P) (X := Y) (s := s) hs hYMeas hYSG
    simpa [residual, Y, r] using hBound
  have hresidualPointwise : ∀ x ∈ s, ∀ ω : Ω,
      |X x ω - X (path x (Fin.last (m + 1))) ω| ≤ residual ω := by
    intro x hx ω
    rw [hpath_last x hx]
    exact Finset.le_sup' (fun y => |X y ω - X (proj y) ω|) hx
  have htruncated := expect_finset_sup'_abs_sub_anchor_le_truncatedEntropyIntegral
    (P := P) (X := X) (K := K) (L := m + 1) (R := R) (σ := σ)
    s hs path nextLevel parent anchor residual hmem hparent hresidualPointwise
    hanchor hXMeas' hX hσ hR hdist hN hterminal hresidualIntegrable
  have hsBound : expect P (fun ω =>
      s.sup' hs (fun x => |X x ω - X anchor ω|)) ≤
      residualBound m + 4 * σ * I m := by
    calc
      expect P (fun ω => s.sup' hs
          (fun x => |X x ω - X anchor ω|)) ≤
          expect P residual + 4 * σ * I (m + 1) := by
        simpa [f, I] using htruncated
      _ = (expect P residual + 4 * σ *
            (I (m + 1) - I m)) + 4 * σ * I m := by ring
      _ ≤ (r m + 4 * σ * (I (m + 1) - I m)) +
            4 * σ * I m := by
        convert add_le_add_right hresidualBound
          (4 * σ * (I (m + 1) - I m) + 4 * σ * I m) using 1 <;> ring
      _ = residualBound m + 4 * σ * I m := by rfl
  have hsup_eq : ∀ ω : Ω,
      s.sup' hs (fun x => |X x ω - X anchor ω|) =
        (Finset.range (n + 1)).sup' Finset.nonempty_range_add_one
          (fun k => |X (u k) ω - X anchor ω|) := by
    intro ω
    dsimp [s] at hs ⊢
    apply le_antisymm
    · apply Finset.sup'_le hs
      intro x hx
      obtain ⟨k, hk, rfl⟩ := Finset.mem_image.mp hx
      exact Finset.le_sup'
        (fun k => |X (u k) ω - X anchor ω|) hk
    · apply Finset.sup'_le Finset.nonempty_range_add_one
      intro k hk
      exact Finset.le_sup' (fun x => |X x ω - X anchor ω|)
        (Finset.mem_image.mpr ⟨k, hk, rfl⟩)
  have hfun : (fun ω =>
      (Finset.range (n + 1)).sup' Finset.nonempty_range_add_one
        (fun k => |X (u k) ω - X anchor ω|)) =
      (fun ω => s.sup' hs (fun x => |X x ω - X anchor ω|)) := by
    funext ω
    exact (hsup_eq ω).symm
  rw [hfun]
  simpa [I, f] using hsBound

/--
Dudley's entropy-integral bound for the anchored supremum of a subGaussian
process over a totally bounded index set.

The theorem uses internal covering numbers. Its explicit boundary assumptions
are a dense sequence in `K`, an anchor whose singleton is an `R`-net for `K`,
sample-path continuity and boundedness on `K`, integrability of the full
anchored supremum, and interval integrability of the entropy integrand at zero.
-/
theorem dudleyEntropyIntegral
    {Ω α : Type*} [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ} {K : Set α} {R σ : ℝ}
    (u : ℕ → K) (hu : DenseRange u) (anchor : K)
    (hAnchorNet : IsInternalEpsilonNet K ({(anchor : α)} : Set α) R)
    (hK : TotallyBounded K)
    (hXMeas : ∀ x, Measurable (X x))
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hσ : 0 < σ) (hR : 0 < R)
    (hPathCont : ∀ ω : Ω, Continuous
      (fun x : K => X (x : α) ω))
    (hPathBdd : ∀ ω : Ω, BddAbove
      (Set.range (fun x : K => |X (x : α) ω - X (anchor : α) ω|)))
    (hFullIntegrable : IntegrableRealRandomVariable P
      (fun ω => ⨆ x : K, |X (x : α) ω - X (anchor : α) ω|))
    (hEntropyIntegrable : IntervalIntegrable
      (fun t => Real.sqrt (2 * Real.log
        (2 * ((coveringNumber K t).toNat : ℝ)))) volume 0 R) :
    expect P (fun ω => ⨆ x : K, |X (x : α) ω - X (anchor : α) ω|) ≤
      4 * σ *
        (∫ t in (0 : ℝ)..R,
          Real.sqrt (2 * Real.log
            (2 * ((coveringNumber K t).toNat : ℝ)))) := by
  let XK : RandomProcess Ω K ℝ := fun x ω => X (x : α) ω
  let f : ℝ → ℝ := fun t =>
    Real.sqrt (2 * Real.log (2 * ((coveringNumber K t).toNat : ℝ)))
  have hPrefix : ∀ n : ℕ, ∃ r : ℕ → ℝ,
      Filter.Tendsto r Filter.atTop (nhds 0) ∧
        ∀ m : ℕ,
          expect P (fun ω =>
            (Finset.range (n + 1)).sup' Finset.nonempty_range_add_one
              (fun k => |X (u k) ω - X anchor ω|)) ≤
            r m + 4 * σ *
              (∫ t in dyadicRadius R (m + 1)..R, f t) := by
    intro n
    have h := finitePrefixResidual (X := X) (K := K) (P := P)
      (fun k => (u k : α)) n
      (by
        intro x hx
        rcases hx with ⟨k, rfl⟩
        exact (u k).property)
      (anchor : α) hAnchorNet hK hXMeas hX hσ hR hEntropyIntegrable
    simpa [f] using h
  choose residual hResidualTendsto hPrefixBound using hPrefix
  have hAnchorMeas : Measurable (XK anchor) := by
    simpa [XK] using hXMeas (anchor : α)
  have hUmeas : ∀ n, Measurable (XK (u n)) := by
    intro n
    simpa [XK] using hXMeas (u n : α)
  have hPathCont' : ∀ ω : Ω, Continuous
      (fun x : K => |XK x ω - XK anchor ω|) := by
    intro ω
    have hsub : Continuous (fun x : K => XK x ω - XK anchor ω) :=
      (hPathCont ω).sub continuous_const
    exact hsub.abs
  have hPathBdd' : ∀ ω : Ω, BddAbove
      (Set.range (fun x : K => |XK x ω - XK anchor ω|)) := by
    intro ω
    simpa [XK] using hPathBdd ω
  have hFullIntegrable' : IntegrableRealRandomVariable P
      (fun ω => ⨆ x : K, |XK x ω - XK anchor ω|) := by
    change IntegrableRealRandomVariable P
      (fun ω => ⨆ x : K, |X (x : α) ω - X (anchor : α) ω|)
    exact hFullIntegrable
  have hBound :=
    expect_iSup_abs_sub_anchor_le_mul_intervalIntegral_of_denseRange_of_prefix_bound
      (X := XK) u hu anchor (4 * σ) R f residual hAnchorMeas hUmeas
      hPathCont' hPathBdd' hFullIntegrable' (le_of_lt hR)
      hEntropyIntegrable hResidualTendsto
      (by simpa [f] using hPrefixBound)
  simpa only [XK, f] using hBound

namespace Dudley

namespace Internal

/-- Expectation of the terminal-net supremum is bounded by the sum of the
expected per-level parent-increment suprema, with the fixed common root `t₀`.

The pointwise bound is established first
(`sup'_abs_sub_root_le_sum_level_sup`), then integrated by monotonicity. -/
theorem expect_sup'_abs_sub_root_le_sum_level_sup
    {Ω α : Type*} [MeasurableSpace Ω]
    {P : Measure Ω}
    {X : RandomProcess Ω α ℝ}
    {L : ℕ}
    {levels : Fin (L + 1) → Finset α} {parent : Fin L → α → α} {t₀ : α}
    (hroot : ∀ y ∈ levels 0, y = t₀)
    (hparent_mem : ∀ k x, x ∈ levels (Fin.succ k) →
      parent k x ∈ levels (Fin.castSucc k))
    (hne : ∀ k : Fin L, (levels (Fin.succ k)).Nonempty)
    (hT : (levels (Fin.last L)).Nonempty)
    (hLevelInt : ∀ k : Fin L,
      IntegrableRealRandomVariable P (fun ω =>
        (levels (Fin.succ k)).sup' (hne k)
          (fun y => |X y ω - X (parent k y) ω|))) :
    expect P
        (fun ω => (levels (Fin.last L)).sup' hT (fun x => |X x ω - X t₀ ω|)) ≤
      Finset.univ.sum (fun k : Fin L =>
        expect P (fun ω =>
          (levels (Fin.succ k)).sup' (hne k)
            (fun y => |X y ω - X (parent k y) ω|))) := by
  let upper : Fin L → Ω → ℝ := fun k ω =>
    (levels (Fin.succ k)).sup' (hne k)
      (fun y => |X y ω - X (parent k y) ω|)
  have hUpper : IntegrableRealRandomVariable P
      (fun ω => ∑ k : Fin L, upper k ω) := by
    unfold IntegrableRealRandomVariable IntegrableRandomVariable
    exact MeasureTheory.integrable_finset_sum Finset.univ
      (fun k _hk => hLevelInt k)
  have hPointwise : ∀ ω,
      (levels (Fin.last L)).sup' hT (fun x => |X x ω - X t₀ ω|) ≤
        ∑ k : Fin L, upper k ω := by
    intro ω
    exact sup'_abs_sub_root_le_sum_level_sup levels parent (fun t => X t ω) t₀
      hroot hparent_mem hne hT
  have hnonneg : ∀ ω,
      0 ≤ (levels (Fin.last L)).sup' hT (fun x => |X x ω - X t₀ ω|) := by
    intro ω
    obtain ⟨x, hx⟩ := hT
    exact (abs_nonneg _).trans
      (Finset.le_sup' (fun x => |X x ω - X t₀ ω|) hx)
  have hIntegral :
      expect P
          (fun ω => (levels (Fin.last L)).sup' hT
            (fun x => |X x ω - X t₀ ω|)) ≤
        expect P (fun ω => ∑ k : Fin L, upper k ω) := by
    rw [expect_def]
    exact MeasureTheory.integral_mono_of_nonneg
      (Filter.Eventually.of_forall hnonneg) hUpper
      (Filter.Eventually.of_forall hPointwise)
  calc
    expect P (fun ω => (levels (Fin.last L)).sup' hT
        (fun x => |X x ω - X t₀ ω|))
        ≤ expect P (fun ω => ∑ k : Fin L, upper k ω) := hIntegral
    _ = ∑ k : Fin L, expect P (upper k) := by
      exact expect_finset_sum (fun k _hk => hLevelInt k)
    _ = Finset.univ.sum (fun k : Fin L =>
        expect P (fun ω =>
          (levels (Fin.succ k)).sup' (hne k)
            (fun y => |X y ω - X (parent k y) ω|))) := by
      rfl

/-- Terminal-net supremum expectation bound for subGaussian-increment processes,
summed into the finite entropy sum of the level cardinalities. -/
theorem expect_sup'_abs_sub_root_le_finiteEntropySum
    {Ω α : Type*} [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ}
    {L : ℕ}
    {levels : Fin (L + 1) → Finset α} {parent : Fin L → α → α} {t₀ : α}
    {σ : ℝ} {rho : Fin (L + 1) → ℝ}
    (hroot : ∀ y ∈ levels 0, y = t₀)
    (hparent_mem : ∀ k x, x ∈ levels (Fin.succ k) →
      parent k x ∈ levels (Fin.castSucc k))
    (hparent_dist : ∀ k x, x ∈ levels (Fin.succ k) →
      dist x (parent k x) ≤ rho (Fin.castSucc k))
    (hne : ∀ k : Fin L, (levels (Fin.succ k)).Nonempty)
    (hT : (levels (Fin.last L)).Nonempty)
    (hXMeas : ∀ t, Measurable (X t))
    (hX : HasSubGaussianMGFIncrements P X σ)
    (hσ : 0 < σ)
    (hρ : ∀ j : Fin (L + 1), 0 < rho j) :
    expect P
        (fun ω => (levels (Fin.last L)).sup' hT (fun x => |X x ω - X t₀ ω|)) ≤
      finiteEntropySum rho (fun k => (levels (Fin.succ k)).card) σ := by
  have hXSG : ∀ k : Fin L, ∀ x ∈ levels (Fin.succ k),
      CenteredSubGaussianMGF P (fun ω => X x ω - X (parent k x) ω)
        (σ * rho (Fin.castSucc k)) := by
    intro k x hx
    exact HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le
      hX hσ (hρ (Fin.castSucc k)) (hparent_dist k x hx)
  have hLevelInt : ∀ k : Fin L,
      IntegrableRealRandomVariable P (fun ω =>
        (levels (Fin.succ k)).sup' (hne k)
          (fun y => |X y ω - X (parent k y) ω|)) := by
    intro k
    let Y : RandomProcess Ω α ℝ :=
      fun x ω => |X x ω - X (parent k x) ω|
    have hYIntegrable : ∀ x ∈ levels (Fin.succ k),
        IntegrableRealRandomVariable P (Y x) := by
      intro x hx
      simpa only [Y] using (hXSG k x hx).2.integrable.abs
    have hSup := integrable_processSup
      (P := P) (X := Y) (s := levels (Fin.succ k)) (hne k) hYIntegrable
    convert hSup using 1
    funext ω
    simp only [processSup, Finset.sup'_apply, Y]
  have hLevelBound : ∀ k : Fin L,
      expect P (fun ω =>
          (levels (Fin.succ k)).sup' (hne k)
            (fun y => |X y ω - X (parent k y) ω|)) ≤
        (σ * rho (Fin.castSucc k)) *
          Real.sqrt (2 * Real.log
            (2 * ((levels (Fin.succ k)).card : ℝ))) := by
    intro k
    exact expect_finset_sup'_abs_le_of_centeredSubGaussianMGF
      (P := P) (X := fun x ω => X x ω - X (parent k x) ω)
      (s := levels (Fin.succ k)) (hne k)
      (fun x _hx => (hXMeas x).sub (hXMeas (parent k x)))
      (fun x hx => hXSG k x hx)
  have hChain := expect_sup'_abs_sub_root_le_sum_level_sup
    (P := P) (X := X) hroot hparent_mem hne hT hLevelInt
  calc
    expect P (fun ω => (levels (Fin.last L)).sup' hT
        (fun x => |X x ω - X t₀ ω|))
        ≤ Finset.univ.sum (fun k : Fin L =>
          expect P (fun ω =>
            (levels (Fin.succ k)).sup' (hne k)
              (fun y => |X y ω - X (parent k y) ω|))) := hChain
    _ ≤ Finset.univ.sum (fun k : Fin L =>
        (σ * rho (Fin.castSucc k)) *
          Real.sqrt (2 * Real.log
            (2 * ((levels (Fin.succ k)).card : ℝ)))) := by
      exact Finset.sum_le_sum (fun k _hk => hLevelBound k)
    _ = finiteEntropySum rho (fun k => (levels (Fin.succ k)).card) σ := by
      rfl

end Internal

/-- Truncated Dudley inequality for a finite terminal net with a fixed root.

From totally bounded `K`, a root `t₀ ∈ K` within radius `R` of every point of
`K`, subGaussian increments of scale `σ > 0`, and measurability of the process,
there exists a finite internal terminal net `T` of `K` at scale
`dyadicRadius R L` such that the expected supremum of `|X t - X t₀|` over `T`
is bounded by the truncated covering-number entropy integral.

The chain is built internally: the base level is the singleton `{t₀}` (an
internal `R`-net of `K` by the radius hypothesis), the finer levels are minimal
internal dyadic nets (so their cardinalities equal the covering numbers), and
the parent maps point into the previous level. The caller supplies no paths,
parents, level cardinalities, or finiteness facts. -/
theorem truncatedBound
    {Ω α : Type*} [MeasurableSpace Ω] [PseudoMetricSpace α]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RandomProcess Ω α ℝ}
    {K : Set α} {t₀ : α} {R σ : ℝ} (L : ℕ)
    (hK : TotallyBounded K) (ht₀ : t₀ ∈ K) (hR : 0 < R)
    (hdist : ∀ t ∈ K, dist t t₀ ≤ R)
    (hXMeas : ∀ t, Measurable (X t))
    (hX : HasSubGaussianMGFIncrements P X σ) (hσ : 0 < σ) :
    ∃ T : Finset α, ∃ hT : T.Nonempty,
      (T : Set α) ⊆ K ∧
      IsInternalEpsilonNet K (T : Set α) (dyadicRadius R L) ∧
      expect P (fun ω => T.sup' hT (fun t => |X t ω - X t₀ ω|)) ≤
        4 * σ * (∫ t in dyadicRadius R (L + 1)..R,
          Real.sqrt (2 * Real.log
            (2 * ((coveringNumber K t).toNat : ℝ)))) := by
  obtain ⟨levels', hlevels', hcard', -⟩ :=
    exists_finset_internalNetFamily_of_totallyBounded
      (rho := fun i : Fin (L + 1) => dyadicRadius R (i : Nat))
      (fun i => dyadicRadius_pos hR i) hK
  let levels : Fin (L + 1) → Finset α :=
    fun i => if (i : Nat) = 0 then {t₀} else levels' i
  have hR0 : dyadicRadius R 0 = R := by simp [dyadicRadius]
  have hroot_net : IsInternalEpsilonNet K (({t₀} : Finset α) : Set α)
      (dyadicRadius R 0) := by
    rw [hR0]
    refine ⟨?_, ?_⟩
    · intro y hy
      simp only [Finset.coe_singleton, Set.mem_singleton_iff] at hy
      rw [hy]
      exact ht₀
    · intro x hx
      refine ⟨t₀, by simp, ?_⟩
      simp only [Set.mem_setOf_eq]
      rw [edist_le_coe]
      have hnndist : (nndist x t₀ : ℝ) ≤ (epsilonRadius R : ℝ) := by
        rw [Real.coe_toNNReal R hR.le, ← dist_nndist]
        exact hdist x hx
      exact NNReal.coe_le_coe.mp hnndist
  have hlevels : ∀ i : Fin (L + 1),
      IsInternalEpsilonNet K (levels i : Set α)
        (dyadicRadius R (i : Nat)) := by
    intro i
    by_cases hi : (i : Nat) = 0
    · have hli : levels i = {t₀} := if_pos hi
      rw [hli, hi]
      exact hroot_net
    · have hli : levels i = levels' i := if_neg hi
      rw [hli]
      exact hlevels' i
  obtain ⟨parent, hparent_mem, hparent_dist⟩ :=
    exists_finset_parentMap_of_internalRadiusLevels
      (rho := fun i : Fin (L + 1) => dyadicRadius R (i : Nat))
      (fun k => hlevels (Fin.castSucc k))
      (fun k => (hlevels (Fin.succ k)).1)
      (fun k => dyadicRadius_pos hR (Fin.castSucc k : Nat))
  have hne_levels : ∀ i : Fin (L + 1), (levels i).Nonempty := by
    intro i
    by_cases hi : (i : Nat) = 0
    · have hli : levels i = {t₀} := if_pos hi
      rw [hli]
      exact Finset.singleton_nonempty t₀
    · obtain ⟨y, hy, -⟩ := (hlevels i).2 ht₀
      exact ⟨y, Finset.mem_coe.mp hy⟩
  have hroot : ∀ y ∈ levels 0, y = t₀ := by
    intro y hy
    have hli : levels 0 = {t₀} := if_pos rfl
    rw [hli] at hy
    exact Finset.mem_singleton.mp hy
  have hN : ∀ k : Fin L,
      coveringNumber K (dyadicRadius R ((k : Nat) + 1)) =
        ((levels (Fin.succ k)).card : ENat) := by
    intro k
    have hneq : (Fin.succ k : Nat) ≠ 0 := by
      have hval : (Fin.succ k : Nat) = (k : Nat) + 1 := rfl
      omega
    have hli : levels (Fin.succ k) = levels' (Fin.succ k) := if_neg hneq
    rw [hli]
    exact hcard' (Fin.succ k)
  obtain ⟨Nf, -, hcoverNf, -⟩ :=
    exists_finset_isInternalEpsilonNet_of_totallyBounded
      (dyadicRadius_pos hR (L + 1)) hK
  have hfinite : coveringNumber K (dyadicRadius R (L + 1)) ≠ ⊤ := by
    rw [hcoverNf]
    exact ENat.coe_ne_top Nf.card
  refine ⟨levels (Fin.last L), hne_levels _, (hlevels _).1, ?_, ?_⟩
  · have hnet := hlevels (Fin.last L)
    rwa [Fin.val_last] at hnet
  · calc
      expect P (fun ω =>
          (levels (Fin.last L)).sup' (hne_levels _)
            (fun t => |X t ω - X t₀ ω|))
          ≤ finiteEntropySum
            (fun i : Fin (L + 1) => dyadicRadius R (i : Nat))
            (fun k => (levels (Fin.succ k)).card) σ :=
        Internal.expect_sup'_abs_sub_root_le_finiteEntropySum
          (P := P) (X := X) (σ := σ)
          (rho := fun i : Fin (L + 1) => dyadicRadius R (i : Nat))
          hroot hparent_mem hparent_dist
          (fun k => hne_levels _) (hne_levels _)
          hXMeas hX hσ (fun i => dyadicRadius_pos hR i)
      _ ≤ 4 * σ * (∫ t in dyadicRadius R (L + 1)..R,
          Real.sqrt (2 * Real.log
            (2 * ((coveringNumber K t).toNat : ℝ)))) :=
        finiteEntropySum_dyadic_le_four_mul_intervalIntegral_coveringNumber
          (K := K) (R := R) (sigma := σ) hR (le_of_lt hσ)
          (fun k => (levels (Fin.succ k)).card) hN hfinite

end Dudley

end

end HighDimProb
