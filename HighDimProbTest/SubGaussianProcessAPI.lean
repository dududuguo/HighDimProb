import HighDimProb.SubGaussianProcess
import HighDimProb.Concentration.SubGaussianMax

open MeasureTheory
open HighDimProb
open scoped NNReal

#check HighDimProb.HasSubGaussianMGFIncrements
#check HighDimProb.HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le
#check HighDimProb.expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF
#check HighDimProb.expect_abs_sub_chain_le_sum_of_level_sup_of_centeredSubGaussianMGF_of_card_le
#check HighDimProb.expect_abs_sub_chain_le_sum_of_level_sup_of_subGaussianMGFIncrements

example {Omega T : Type*} [MeasurableSpace Omega] [PseudoMetricSpace T]
    {P : Measure Omega} {X : RandomProcess Omega T Real} {sigma : Real} {s t : T}
    (hX : HasSubGaussianMGFIncrements P X sigma) :
    ProbabilityTheory.HasSubgaussianMGF (X s - X t)
      (⟨(sigma * dist s t) ^ 2, sq_nonneg (sigma * dist s t)⟩ : NNReal) P :=
  hX s t

-- Equal indices are a zero-proxy boundary of the increment API.
example {T : Type*} [PseudoMetricSpace T] {sigma : Real} (s : T) :
    (⟨(sigma * dist s s) ^ 2, sq_nonneg (sigma * dist s s)⟩ : NNReal) = 0 := by
  simp

example {Omega T : Type*} [MeasurableSpace Omega] [PseudoMetricSpace T]
    {P : Measure Omega} {X : RandomProcess Omega T Real} {sigma radius : Real} {s t : T}
    (hX : HasSubGaussianMGFIncrements P X sigma)
    (hsigma : 0 < sigma) (hradius : 0 < radius) (hdist : dist s t <= radius) :
    CenteredSubGaussianMGF P (X s - X t) (sigma * radius) :=
  HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le
    hX hsigma hradius hdist

example {Omega T : Type*} [MeasurableSpace Omega] [PseudoMetricSpace T]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {X : RandomProcess Omega T Real} {sigma radius : Real}
    (hX : HasSubGaussianMGFIncrements P X sigma)
    (hXMeas : forall t, Measurable (X t))
    (hsigma : 0 < sigma) (hradius : 0 < radius)
    (gamma : Nat -> T) (nextLevel : Fin 1 -> Finset T)
    (parent : Fin 1 -> T -> T)
    (hmem : forall k : Fin 1, gamma ((k : Nat) + 1) ∈ nextLevel k)
    (hparent : forall k : Fin 1,
      gamma (k : Nat) = parent k (gamma ((k : Nat) + 1)))
    (hdist : forall k : Fin 1, forall x, x ∈ nextLevel k ->
      dist x (parent k x) <= radius) :
    expect P (fun omega => |X (gamma 1) omega - X (gamma 0) omega|) <=
      Finset.univ.sum (fun k : Fin 1 =>
        (sigma * radius) * Real.sqrt
          (2 * Real.log (2 * ((nextLevel k).card : Real)))) := by
  refine expect_abs_sub_chain_le_sum_of_level_sup_of_subGaussianMGFIncrements
    gamma 1 nextLevel parent sigma (fun _ => radius) hmem hparent ?_ hX hsigma ?_ ?_
  · intro k x hx
    exact (hXMeas x).sub (hXMeas (parent k x))
  · intro _
    exact hradius
  · exact hdist
