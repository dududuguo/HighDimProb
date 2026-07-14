import HighDimProb.Analysis.LogSumExp

open HighDimProb

#check sum_exp_pos
#check exp_mul_sup'_le_sum_exp
#check sup'_le_log_sum_exp_div
#check log_sum_exp_le_log_card_add

variable {ι : Type*} {s : Finset ι} {f : ι → Real} {theta : Real}

#check fun (hs : s.Nonempty) => sum_exp_pos hs f theta
#check fun (hs : s.Nonempty) => exp_mul_sup'_le_sum_exp hs f theta
#check fun (hs : s.Nonempty) (htheta : 0 < theta) =>
  sup'_le_log_sum_exp_div hs f htheta
#check fun (hs : s.Nonempty) (htheta : 0 < theta) =>
  log_sum_exp_le_log_card_add hs f htheta

example (hs : s.Nonempty) (htheta : 0 < theta) (i : ι) (hi : i ∈ s) :
    theta * f i <= Real.log (s.sum (fun j => Real.exp (theta * f j))) := by
  have hsup : f i <= s.sup' hs f := Finset.le_sup' f hi
  have hlog := sup'_le_log_sum_exp_div hs f htheta
  rw [le_div_iff₀ htheta] at hlog
  calc
    theta * f i <= theta * s.sup' hs f :=
      mul_le_mul_of_nonneg_left hsup htheta.le
    _ <= Real.log (s.sum (fun j => Real.exp (theta * f j))) := by
      simpa [mul_comm] using hlog

example (hs : s.Nonempty) (htheta : 0 < theta) :
    theta * s.sup' hs f <= Real.log (s.sum (fun j => Real.exp (theta * f j))) ∧
      Real.log (s.sum (fun j => Real.exp (theta * f j))) <=
        Real.log (s.card : Real) + theta * s.sup' hs f := by
  have hlow := sup'_le_log_sum_exp_div hs f htheta
  rw [le_div_iff₀ htheta] at hlow
  exact ⟨by simpa [mul_comm] using hlow,
    log_sum_exp_le_log_card_add hs f htheta⟩
