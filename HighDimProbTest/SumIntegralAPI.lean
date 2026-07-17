import HighDimProb.Analysis.SumIntegral

open MeasureTheory Set
open scoped BigOperators Interval

namespace HighDimProbTest

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
