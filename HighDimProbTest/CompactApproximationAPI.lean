import HighDimProb.Analysis.CompactApproximation

open HighDimProb
open Filter Set Topology

variable {ι α : Type*} [PseudoMetricSpace α]
variable {l : Filter ι} {K : Set α} {f : α → ℝ} {p : ι → α → α}

#check tendstoUniformlyOn_abs_sub_of_isCompact
#check tendsto_edist_uniformFun_abs_sub_of_isCompact
#check tendsto_toReal_edist_uniformFun_abs_sub_of_isCompact

example (hK : IsCompact K) (hf : ContinuousOn f K)
    (hp : TendstoUniformlyOn p id l K)
    (hpK : ∀ᶠ n in l, ∀ x ∈ K, p n x ∈ K) :
    TendstoUniformlyOn
      (fun n x => |f x - f (p n x)|) (fun _ => 0) l K :=
  tendstoUniformlyOn_abs_sub_of_isCompact hK hf hp hpK

example (hK : IsCompact K) (hf : ContinuousOn f K)
    (hp : TendstoUniformlyOn p id l K)
    (hpK : ∀ᶠ n in l, ∀ x ∈ K, p n x ∈ K) :
    Tendsto
      (fun n =>
        edist
          (UniformFun.ofFun (fun x : K => |f x - f (p n x)|))
          (UniformFun.ofFun (fun _ : K => (0 : ℝ))))
      l (𝓝 0) :=
  tendsto_edist_uniformFun_abs_sub_of_isCompact hK hf hp hpK

example (hK : IsCompact K) (hf : ContinuousOn f K)
    (hp : TendstoUniformlyOn p id l K)
    (hpK : ∀ n, MapsTo (p n) K K) :
    Tendsto
      (fun n =>
        (edist
          (UniformFun.ofFun (fun x : K => |f x - f (p n x)|))
          (UniformFun.ofFun (fun _ : K => (0 : ℝ)))).toReal)
      l (𝓝 0) :=
  tendsto_toReal_edist_uniformFun_abs_sub_of_isCompact hK hf hp hpK
