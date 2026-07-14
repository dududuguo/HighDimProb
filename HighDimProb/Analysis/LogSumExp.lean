import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Data.Finset.Lattice.Fold
import Mathlib.Tactic

set_option autoImplicit false

namespace HighDimProb

/-!
# Finite log-sum-exp bounds

Deterministic finite-family bounds for a nonempty `Finset`.  The supremum is
kept as `Finset.sup'` so no empty-family convention is introduced.
-/

/-- A finite sum of exponentials is positive on a nonempty index set. -/
theorem sum_exp_pos {ι : Type*} {s : Finset ι} (hs : s.Nonempty)
    (f : ι → Real) (theta : Real) :
    0 < s.sum (fun i => Real.exp (theta * f i)) := by
  exact Finset.sum_pos (fun i hi => Real.exp_pos _) hs

/-- The exponential of a finite supremum is bounded by the exponential sum.

This holds for every real `theta`: for nonnegative `theta` use a maximizing
index, while for nonpositive `theta` every index gives a lower bound. -/
theorem exp_mul_sup'_le_sum_exp {ι : Type*} {s : Finset ι} (hs : s.Nonempty)
    (f : ι → Real) (theta : Real) :
    Real.exp (theta * s.sup' hs f) <= s.sum (fun i => Real.exp (theta * f i)) := by
  rcases hs with ⟨j, hj⟩
  by_cases htheta : 0 <= theta
  · have hmem : ∃ i ∈ s, s.sup' ⟨j, hj⟩ f <= f i :=
      (Finset.le_sup'_iff ⟨j, hj⟩).mp le_rfl
    rcases hmem with ⟨i, hi, hsup⟩
    have h_eq : f i = s.sup' ⟨j, hj⟩ f :=
      le_antisymm (Finset.le_sup' f hi) hsup
    have hterm : Real.exp (theta * f i) <= s.sum (fun j => Real.exp (theta * f j)) :=
      Finset.single_le_sum
        (f := fun j => Real.exp (theta * f j))
        (fun j hj => (Real.exp_pos _).le) hi
    simpa [h_eq] using hterm
  · have htheta' : theta <= 0 := le_of_not_ge htheta
    have harg : theta * s.sup' ⟨j, hj⟩ f <= theta * f j :=
      mul_le_mul_of_nonpos_left (Finset.le_sup' f hj) htheta'
    calc
      Real.exp (theta * s.sup' ⟨j, hj⟩ f) <= Real.exp (theta * f j) :=
        Real.exp_le_exp.mpr harg
      _ <= s.sum (fun i => Real.exp (theta * f i)) :=
        Finset.single_le_sum
          (f := fun i => Real.exp (theta * f i))
          (fun i hi => (Real.exp_pos _).le) hj

/-- For positive `theta`, the finite supremum is below the scaled log-sum-exp. -/
theorem sup'_le_log_sum_exp_div {ι : Type*} {s : Finset ι} (hs : s.Nonempty)
    (f : ι → Real) {theta : Real} (htheta : 0 < theta) :
    s.sup' hs f <= Real.log (s.sum (fun i => Real.exp (theta * f i))) / theta := by
  have hsum_pos : 0 < s.sum (fun i => Real.exp (theta * f i)) :=
    sum_exp_pos hs f theta
  have hlog :
      theta * s.sup' hs f <= Real.log (s.sum (fun i => Real.exp (theta * f i))) :=
    (Real.le_log_iff_exp_le hsum_pos).2 (exp_mul_sup'_le_sum_exp hs f theta)
  rw [le_div_iff₀ htheta]
  nlinarith

/-- For positive `theta`, the log-sum-exp is bounded by the supremum and
the logarithm of the family size. -/
theorem log_sum_exp_le_log_card_add {ι : Type*} {s : Finset ι} (hs : s.Nonempty)
    (f : ι → Real) {theta : Real} (htheta : 0 < theta) :
    Real.log (s.sum (fun i => Real.exp (theta * f i))) <=
      Real.log (s.card : Real) + theta * s.sup' hs f := by
  have hsum_pos : 0 < s.sum (fun i => Real.exp (theta * f i)) :=
    sum_exp_pos hs f theta
  have hcard_pos : 0 < (s.card : Real) := by
    exact_mod_cast s.card_pos.mpr hs
  have hsum_le :
      s.sum (fun i => Real.exp (theta * f i)) <=
        (s.card : Real) * Real.exp (theta * s.sup' hs f) := by
    calc
      s.sum (fun i => Real.exp (theta * f i)) <=
          s.sum (fun i => Real.exp (theta * s.sup' hs f)) := by
        exact Finset.sum_le_sum (fun i hi =>
          Real.exp_le_exp.mpr
            (mul_le_mul_of_nonneg_left (Finset.le_sup' f hi) htheta.le))
      _ = (s.card : Real) * Real.exp (theta * s.sup' hs f) := by
        simp [Finset.sum_const, nsmul_eq_mul]
  calc
    Real.log (s.sum (fun i => Real.exp (theta * f i))) <=
        Real.log ((s.card : Real) * Real.exp (theta * s.sup' hs f)) :=
      Real.log_le_log hsum_pos hsum_le
    _ = Real.log (s.card : Real) + theta * s.sup' hs f := by
      rw [Real.log_mul (ne_of_gt hcard_pos) (Real.exp_ne_zero _), Real.log_exp]

end HighDimProb
