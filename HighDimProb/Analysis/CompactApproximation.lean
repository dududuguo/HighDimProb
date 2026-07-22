import Mathlib.Analysis.Normed.Group.Continuity
import Mathlib.Topology.MetricSpace.Pseudo.Basic
import Mathlib.Topology.MetricSpace.UniformConvergence
import Mathlib.Topology.Instances.ENNReal.Lemmas
import Mathlib.Topology.Order.Compact
import Mathlib.Topology.UniformSpace.HeineCantor

set_option autoImplicit false

namespace HighDimProb

open Filter Set Topology

/-!
# Compact approximation residuals

This module packages the deterministic compact-index residual passage used by
the small-scale part of Dudley arguments.
-/

/-- Uniformly identity-approximating maps on a compact set have vanishing
continuous real-valued sample residuals. -/
theorem tendstoUniformlyOn_abs_sub_of_isCompact
    {ι α : Type*} [PseudoMetricSpace α]
    {l : Filter ι} {K : Set α} (hK : IsCompact K)
    {f : α → ℝ} (hf : ContinuousOn f K)
    {p : ι → α → α}
    (hp : TendstoUniformlyOn p id l K)
    (hpK : ∀ᶠ n in l, ∀ x ∈ K, p n x ∈ K) :
    TendstoUniformlyOn
      (fun n x => |f x - f (p n x)|) (fun _ => 0) l K := by
  have hf_uniform : UniformContinuousOn f K :=
    hK.uniformContinuousOn_of_continuous hf
  have hcomp : TendstoUniformlyOn (fun n x => f (p n x)) f l K := by
    simpa only [id_eq] using
      hf_uniform.comp_tendstoUniformlyOn_eventually hpK
        (fun x hx => hx) hp
  rw [Metric.tendstoUniformlyOn_iff]
  intro ε hε
  filter_upwards [Metric.tendstoUniformlyOn_iff.mp hcomp ε hε] with n hn
  intro x hx
  simpa [Real.dist_eq] using hn x hx

/-- Compact approximation makes the extended uniform sample residual vanish. -/
theorem tendsto_edist_uniformFun_abs_sub_of_isCompact
    {ι α : Type*} [PseudoMetricSpace α]
    {l : Filter ι} {K : Set α} (hK : IsCompact K)
    {f : α → ℝ} (hf : ContinuousOn f K)
    {p : ι → α → α}
    (hp : TendstoUniformlyOn p id l K)
    (hpK : ∀ᶠ n in l, ∀ x ∈ K, p n x ∈ K) :
    Tendsto
      (fun n =>
        edist
          (UniformFun.ofFun (fun x : K => |f x - f (p n x)|))
          (UniformFun.ofFun (fun _ : K => (0 : ℝ))))
      l (𝓝 0) := by
  have hres :=
    tendstoUniformlyOn_abs_sub_of_isCompact hK hf hp hpK
  have hres_subtype :
      TendstoUniformly
        (fun n (x : K) => |f x - f (p n x)|) (fun _ : K => 0) l :=
    tendstoUniformlyOn_iff_tendstoUniformly_comp_coe.mp hres
  have hfun :
      Tendsto
        (fun n => UniformFun.ofFun (fun x : K => |f x - f (p n x)|)) l
        (𝓝 (UniformFun.ofFun (fun _ : K => (0 : ℝ)))) := by
    rw [UniformFun.tendsto_iff_tendstoUniformly]
    simpa only [Function.comp_apply, UniformFun.toFun_ofFun] using hres_subtype
  have hzero :
      Tendsto
        (fun _ : ι => UniformFun.ofFun (fun _ : K => (0 : ℝ))) l
        (𝓝 (UniformFun.ofFun (fun _ : K => (0 : ℝ)))) :=
    tendsto_const_nhds
  simpa using hfun.edist hzero

private theorem edist_uniformFun_abs_sub_ne_top_of_mapsTo
    {α : Type*} [PseudoMetricSpace α]
    {K : Set α} (hK : IsCompact K)
    {f : α → ℝ} (hf : ContinuousOn f K)
    {p : α → α} (hpK : MapsTo p K K) :
    (edist
      (UniformFun.ofFun (fun x : K => |f x - f (p x)|))
      (UniformFun.ofFun (fun _ : K => (0 : ℝ)))) ≠ ⊤ := by
  rcases hK.bddAbove_image hf.norm with ⟨C, hC⟩
  have hed_le :
      edist
        (UniformFun.ofFun (fun x : K => |f x - f (p x)|))
        (UniformFun.ofFun (fun _ : K => (0 : ℝ))) ≤
      ENNReal.ofReal (2 * C) := by
    apply UniformFun.edist_le.mpr
    intro x
    have hfx : ‖f x‖ ≤ C := hC ⟨x, x.property, rfl⟩
    have hfpx : ‖f (p x)‖ ≤ C := hC ⟨p x, hpK x.property, rfl⟩
    have hres : |f x - f (p x)| ≤ 2 * C := by
      calc
        |f x - f (p x)| = ‖f x - f (p x)‖ := by simp [Real.norm_eq_abs]
        _ ≤ ‖f x‖ + ‖f (p x)‖ := norm_sub_le _ _
        _ ≤ C + C := add_le_add hfx hfpx
        _ = 2 * C := by ring
    simpa [UniformFun.toFun_ofFun, edist_dist, Real.dist_eq] using
      ENNReal.ofReal_le_ofReal hres
  exact (hed_le.trans_lt ENNReal.ofReal_lt_top).ne

/-- If every approximation level preserves the compact set, the real-valued
uniform sample residual tends to zero. The all-level mapping hypothesis makes
the extended uniform distance finite before applying `ENNReal.toReal`. -/
theorem tendsto_toReal_edist_uniformFun_abs_sub_of_isCompact
    {ι α : Type*} [PseudoMetricSpace α]
    {l : Filter ι} {K : Set α} (hK : IsCompact K)
    {f : α → ℝ} (hf : ContinuousOn f K)
    {p : ι → α → α}
    (hp : TendstoUniformlyOn p id l K)
    (hpK : ∀ n, MapsTo (p n) K K) :
    Tendsto
      (fun n =>
        (edist
          (UniformFun.ofFun (fun x : K => |f x - f (p n x)|))
          (UniformFun.ofFun (fun _ : K => (0 : ℝ)))).toReal)
      l (𝓝 0) := by
  have hed_tendsto :=
    tendsto_edist_uniformFun_abs_sub_of_isCompact
      hK hf hp (Filter.Eventually.of_forall hpK)
  refine (ENNReal.tendsto_toReal_zero_iff ?_).2 hed_tendsto
  intro n
  exact edist_uniformFun_abs_sub_ne_top_of_mapsTo hK hf (hpK n)

end HighDimProb
