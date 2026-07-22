import HighDimProb.Analysis.NetSupremum

open HighDimProb Filter

set_option autoImplicit false

#check @HighDimProb.bddAbove_image_of_uniformContinuousOn_of_isInternalEpsilonNet
#check @HighDimProb.tendsto_finset_sup'_of_isInternalEpsilonNet
#check @HighDimProb.tendsto_finset_sup'_of_uniformContinuousOn_of_isInternalEpsilonNet
#check @HighDimProb.tendsto_finset_sup'_abs_sub_of_uniformContinuousOn_of_isInternalEpsilonNet

example {alpha : Type*} [PseudoMetricSpace alpha]
    {K : Set alpha} {T : Nat -> Finset alpha} {eps : Nat -> Real}
    {f : alpha -> Real}
    (hK : K.Nonempty)
    (hT : forall n, (T n).Nonempty)
    (hnet : forall n, IsInternalEpsilonNet K (T n : Set alpha) (eps n))
    (heps_pos : forall n, 0 < eps n)
    (heps : Tendsto eps atTop (nhds 0))
    (hf : UniformContinuousOn f K) :
    Tendsto (fun n => (T n).sup' (hT n) f) atTop
      (nhds (sSup (f '' K))) :=
  tendsto_finset_sup'_of_uniformContinuousOn_of_isInternalEpsilonNet
    hK hT hnet heps_pos heps hf

example {alpha : Type*} [PseudoMetricSpace alpha]
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
      (nhds (sSup ((fun t => abs (f t - f t0)) '' K))) :=
  tendsto_finset_sup'_abs_sub_of_uniformContinuousOn_of_isInternalEpsilonNet
    ht0 hT hnet heps_pos heps hf
