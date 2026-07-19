import HighDimProb.Analysis.CompactApproximation

open Filter Set Topology
open HighDimProb

#check HighDimProb.tendstoUniformlyOn_abs_sub_of_isCompact
#check HighDimProb.tendsto_toReal_edist_uniformFun_abs_sub_of_isCompact

example {ι α : Type*} [PseudoMetricSpace α]
    {l : Filter ι} {K : Set α} {f : α → ℝ} {p : ι → α → α}
    (hK : IsCompact K) (hf : ContinuousOn f K)
    (hp : TendstoUniformlyOn p id l K)
    (hpK : ∀ᶠ n in l, ∀ x ∈ K, p n x ∈ K) :
    TendstoUniformlyOn
      (fun n x => |f x - f (p n x)|) (fun _ => 0) l K := by
  exact tendstoUniformlyOn_abs_sub_of_isCompact hK hf hp hpK
