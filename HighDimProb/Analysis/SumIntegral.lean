import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic

open MeasureTheory Set
open scoped BigOperators Interval

namespace HighDimProb

/-- A finite decreasing real partition gives a left-endpoint rectangle sum below
the interval integral of an antitone function. -/
theorem sum_mul_sub_le_intervalIntegral_of_antitoneOn
    {f : ℝ → ℝ} {a : ℕ → ℝ} {m n : ℕ}
    (hmn : m ≤ n)
    (hdec : ∀ k ∈ Finset.Ico m n, a (k + 1) ≤ a k)
    (hf : AntitoneOn f (Set.Icc (a n) (a m))) :
    ∑ k ∈ Finset.Ico m n, (a k - a (k + 1)) * f (a k)
      ≤ ∫ x in a n..a m, f x := by
  have hstep : ∀ k, m ≤ k → k + 1 ≤ n → a (k + 1) ≤ a k := by
    intro k hmk hkn
    exact hdec k (Finset.mem_Ico.mpr ⟨hmk, Nat.lt_of_succ_le hkn⟩)
  have hmono : ∀ i, m ≤ i → ∀ j, i ≤ j → j ≤ n → a j ≤ a i := by
    intro i him j hij
    induction hij with
    | refl =>
        intro _
        exact le_rfl
    | @step j hij ih =>
        intro hjn
        exact (hstep j (le_trans him hij) hjn).trans
          (ih (le_trans (Nat.le_succ j) hjn))
  have hrect : ∀ k ∈ Finset.Ico m n,
      (a k - a (k + 1)) * f (a k) ≤
        ∫ x in a (k + 1)..a k, f x := by
    intro k hk
    have hk' : m ≤ k ∧ k < n := Finset.mem_Ico.mp hk
    have hmk : m ≤ k := hk'.1
    have hkn : k + 1 ≤ n := Nat.succ_le_of_lt hk'.2
    have hleft : a n ≤ a (k + 1) :=
      hmono (k + 1) (le_trans hmk (Nat.le_succ k)) n hkn le_rfl
    have hright : a k ≤ a m :=
      hmono m le_rfl k hmk (Nat.le_of_lt hk'.2)
    have hnext : a (k + 1) ≤ a k := hdec k hk
    have hsegment : Set.uIcc (a (k + 1)) (a k) ⊆ Set.Icc (a n) (a m) := by
      rw [Set.uIcc_of_le hnext]
      intro x hx
      exact ⟨hleft.trans hx.1, hx.2.trans hright⟩
    have hf_segment : AntitoneOn f (Set.uIcc (a (k + 1)) (a k)) := by
      intro x hx y hy hxy
      exact hf (hsegment hx) (hsegment hy) hxy
    have hf_segment_int : IntervalIntegrable f volume (a (k + 1)) (a k) :=
      hf_segment.intervalIntegrable
    have hconst_int :
        IntervalIntegrable
          (fun _ : ℝ => f (a k)) volume
          (a (k + 1)) (a k) :=
      intervalIntegrable_const
    have hmono_int :=
      intervalIntegral.integral_mono_on hnext hconst_int hf_segment_int
        (by
          intro x hx
          have hx' : x ∈ Set.uIcc (a (k + 1)) (a k) := by
            simpa [Set.uIcc_of_le hnext] using hx
          have hak : a k ∈ Set.Icc (a n) (a m) :=
            ⟨hleft.trans hnext, hright⟩
          exact hf (hsegment hx') hak hx.2)
    simpa [intervalIntegral.integral_const, smul_eq_mul] using hmono_int
  have hsum_rect :
      (∑ k ∈ Finset.Ico m n, (a k - a (k + 1)) * f (a k)) ≤
        ∑ k ∈ Finset.Ico m n, ∫ x in a (k + 1)..a k, f x := by
    exact Finset.sum_le_sum (fun k hk => hrect k hk)
  calc
    ∑ k ∈ Finset.Ico m n, (a k - a (k + 1)) * f (a k)
        ≤ ∑ k ∈ Finset.Ico m n, ∫ x in a (k + 1)..a k, f x := hsum_rect
    _ = -∑ k ∈ Finset.Ico m n, ∫ x in a k..a (k + 1), f x := by
      calc
        ∑ k ∈ Finset.Ico m n, ∫ x in a (k + 1)..a k, f x
            = ∑ k ∈ Finset.Ico m n, -(∫ x in a k..a (k + 1), f x) := by
                apply Finset.sum_congr rfl
                intro k hk
                rw [intervalIntegral.integral_symm]
        _ = -∑ k ∈ Finset.Ico m n, ∫ x in a k..a (k + 1), f x := by
          simp
    _ = -∫ x in a m..a n, f x := by
      rw [intervalIntegral.sum_integral_adjacent_intervals_Ico hmn]
      intro k hk
      have hk' : m ≤ k ∧ k < n := hk
      have hmk : m ≤ k := hk'.1
      have hkn : k + 1 ≤ n := Nat.succ_le_of_lt hk'.2
      have hleft : a n ≤ a (k + 1) :=
        hmono (k + 1) (le_trans hmk (Nat.le_succ k)) n hkn le_rfl
      have hright : a k ≤ a m :=
        hmono m le_rfl k hmk (Nat.le_of_lt hk'.2)
      have hnext : a (k + 1) ≤ a k := hdec k (Finset.mem_Ico.mpr hk')
      have hsegment : Set.uIcc (a (k + 1)) (a k) ⊆ Set.Icc (a n) (a m) := by
        rw [Set.uIcc_of_le hnext]
        intro x hx
        exact ⟨hleft.trans hx.1, hx.2.trans hright⟩
      have hf_segment : AntitoneOn f (Set.uIcc (a (k + 1)) (a k)) := by
        intro x hx y hy hxy
        exact hf (hsegment hx) (hsegment hy) hxy
      exact ⟨hf_segment.intervalIntegrable.2, hf_segment.intervalIntegrable.1⟩
    _ = ∫ x in a n..a m, f x := by
      rw [intervalIntegral.integral_symm]
      simp

end HighDimProb
