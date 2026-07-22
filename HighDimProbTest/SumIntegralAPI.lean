import HighDimProb.Analysis.SumIntegral

open MeasureTheory Set
open scoped BigOperators Interval Topology

namespace HighDimProbTest

#check HighDimProb.tendsto_intervalIntegral_of_leftEndpoint_tendsto
#check HighDimProb.le_intervalIntegral_of_le_residual_add_of_tendsto_zero

example {f : ℝ → ℝ} {a : Nat → ℝ} {R : ℝ}
    (hR : 0 ≤ R)
    (ha_nonneg : ∀ n : Nat, 0 ≤ a n)
    (ha_le : ∀ n : Nat, a n ≤ R)
    (ha_tendsto : Filter.Tendsto a Filter.atTop (𝓝 0))
    (hf : IntervalIntegrable f volume 0 R) :
    Filter.Tendsto (fun n : Nat => ∫ t in a n..R, f t)
      Filter.atTop (𝓝 (∫ t in (0 : ℝ)..R, f t)) := by
  exact HighDimProb.tendsto_intervalIntegral_of_leftEndpoint_tendsto
    hR ha_nonneg ha_le ha_tendsto hf

example {f : ℝ → ℝ} {a residual : Nat → ℝ} {B R : ℝ}
    (hR : 0 ≤ R)
    (ha_nonneg : ∀ n : Nat, 0 ≤ a n)
    (ha_le : ∀ n : Nat, a n ≤ R)
    (ha_tendsto : Filter.Tendsto a Filter.atTop (𝓝 0))
    (hf : IntervalIntegrable f volume 0 R)
    (hresidual_tendsto : Filter.Tendsto residual Filter.atTop (𝓝 0))
    (hbound : ∀ n : Nat, B ≤ residual n + ∫ t in a n..R, f t) :
    B ≤ ∫ t in (0 : ℝ)..R, f t := by
  exact HighDimProb.le_intervalIntegral_of_le_residual_add_of_tendsto_zero
    hR ha_nonneg ha_le ha_tendsto hf hresidual_tendsto hbound

example :
    (∑ k ∈ (Finset.Ico 2 2 : Finset ℕ), ((k : ℝ) - k) * (0 : ℝ)) ≤
      ∫ x in (0 : ℝ)..0, x := by
  have h :=
    HighDimProb.sum_mul_sub_le_intervalIntegral_of_antitoneOn
      (f := fun x : ℝ => x)
      (a := fun _ : ℕ => (0 : ℝ))
      (m := 2) (n := 2)
      (by norm_num)
      (by simp)
      (by
        intro x hx y hy hxy
        have hx0 : x = 0 := by linarith [hx.1, hx.2]
        have hy0 : y = 0 := by linarith [hy.1, hy.2]
        simp [hx0, hy0])
  exact h

example :
    (∑ k ∈ (Finset.Ico 0 2 : Finset ℕ),
      ((3 - (k : ℝ)) - (3 - ((k + 1 : ℕ) : ℝ))) *
        (5 - (3 - (k : ℝ)))) ≤
      ∫ x in (3 - ((2 : ℕ) : ℝ))..(3 - ((0 : ℕ) : ℝ)), 5 - x := by
  simpa using
    (HighDimProb.sum_mul_sub_le_intervalIntegral_of_antitoneOn
      (f := fun x : ℝ => 5 - x)
      (a := fun k : ℕ => 3 - (k : ℝ))
      (m := 0) (n := 2)
      (by norm_num)
      (by
        intro k hk
        norm_num [Nat.cast_add, Nat.cast_one]
        linarith)
      (by
        intro x hx y hy hxy
        dsimp
        linarith))

example :
    (∑ k ∈ (Finset.Ico 1 4 : Finset ℕ),
      ((4 - (min k 2 : ℝ)) - (4 - (min (k + 1) 2 : ℝ))) *
        (5 - (4 - (min k 2 : ℝ)))) ≤
      ∫ x in (4 - (min 4 2 : ℝ))..(4 - (min 1 2 : ℝ)), 5 - x := by
  simpa using
    (HighDimProb.sum_mul_sub_le_intervalIntegral_of_antitoneOn
      (f := fun x : ℝ => 5 - x)
      (a := fun k : ℕ => 4 - (min k 2 : ℝ))
      (m := 1) (n := 4)
      (by norm_num)
      (by
        intro k hk
        dsimp
        have hmin : min (k : ℝ) 2 ≤ min ((k : ℝ) + 1) 2 :=
          min_le_min (by linarith) le_rfl
        norm_num [Nat.cast_add, Nat.cast_one]
        have hmin' : min (k : ℝ) 2 ≤ min ((k : ℝ) + 1) 2 := hmin
        linarith)
      (by
        intro x hx y hy hxy
        dsimp
        linarith))

end HighDimProbTest
