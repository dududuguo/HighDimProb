import HighDimProb.Concentration.Dudley

/-!
# Full-interval Dudley entropy integrals

This file names the covering-number integrand used by the finite truncated
Dudley bound and records the interval comparison needed to pass from any
positive dyadic truncation to the full interval.  The integrability premise is
kept explicit because the covering number at radius zero may be infinite.
-/

namespace HighDimProb

open MeasureTheory

set_option autoImplicit false

noncomputable section

namespace Dudley

/-- The covering-number integrand in the Dudley entropy integral.

The full Dudley theorem uses this only for a totally bounded set and positive
radii, where `coveringNumber K t` is finite. At radius zero, `ENat.toNat`
totalizes a possibly infinite covering number; that endpoint does not affect
the Lebesgue interval integral. This real-valued definition is not an extended
entropy integral for arbitrary non-totally-bounded sets. -/
def entropyIntegrand {alpha : Type*} [PseudoMetricSpace alpha]
    (K : Set alpha) (t : Real) : Real :=
  Real.sqrt (2 * Real.log (2 * ((coveringNumber K t).toNat : Real)))

/-- The full interval Dudley entropy integral at base radius `R`. -/
def entropyIntegral {alpha : Type*} [PseudoMetricSpace alpha]
    (K : Set alpha) (R : Real) : Real :=
  ∫ t in 0..R, entropyIntegrand K t

namespace Internal

/-- The Dudley entropy integrand is pointwise nonnegative. -/
theorem entropyIntegrand_nonneg {alpha : Type*} [PseudoMetricSpace alpha]
    (K : Set alpha) (t : Real) :
    0 <= entropyIntegrand K t := by
  exact Real.sqrt_nonneg _

/-- Every positive dyadic truncation is bounded by the full entropy integral. -/
theorem truncatedEntropyIntegral_le_entropyIntegral
    {alpha : Type*} [PseudoMetricSpace alpha]
    {K : Set alpha} {R : Real} (L : Nat) (hR : 0 < R)
    (hInt : IntervalIntegrable (entropyIntegrand K) volume 0 R) :
    (∫ t in dyadicRadius R (L + 1)..R, entropyIntegrand K t) <=
      entropyIntegral K R := by
  have hRadius : forall {i j : Nat}, i <= j ->
      dyadicRadius R j <= dyadicRadius R i := by
    intro i j hij
    rw [dyadicRadius, dyadicRadius]
    apply (div_le_div_iff_of_pos_left hR (by positivity) (by positivity)).2
    exact pow_le_pow_right₀ (by norm_num) hij
  have haR : dyadicRadius R (L + 1) <= R := by
    have h := hRadius (i := 0) (j := L + 1) (by omega)
    simpa [dyadicRadius] using h
  have ha : 0 <= dyadicRadius R (L + 1) :=
    (dyadicRadius_pos hR (L + 1)).le
  have h0a : IntervalIntegrable (entropyIntegrand K) volume 0
      (dyadicRadius R (L + 1)) :=
    hInt.mono_set (by
      rw [Set.uIcc_of_le ha, Set.uIcc_of_le hR.le]
      exact Set.Icc_subset_Icc le_rfl haR)
  have haR' : IntervalIntegrable (entropyIntegrand K) volume
      (dyadicRadius R (L + 1)) R :=
    hInt.mono_set (by
      rw [Set.uIcc_of_le haR, Set.uIcc_of_le hR.le]
      exact Set.Icc_subset_Icc ha le_rfl)
  have h0a_nonneg :
      0 <= ∫ t in 0..dyadicRadius R (L + 1), entropyIntegrand K t :=
    intervalIntegral.integral_nonneg ha (fun t _ => entropyIntegrand_nonneg K t)
  have hadd := intervalIntegral.integral_add_adjacent_intervals h0a haR'
  calc
    (∫ t in dyadicRadius R (L + 1)..R, entropyIntegrand K t) <=
        (∫ t in 0..dyadicRadius R (L + 1), entropyIntegrand K t) +
          (∫ t in dyadicRadius R (L + 1)..R, entropyIntegrand K t) := by
      linarith
    _ = ∫ t in 0..R, entropyIntegrand K t := hadd
    _ = entropyIntegral K R := by
      rfl

/-- The dyadic radii converge to zero, for every real base radius. -/
theorem dyadicRadius_tendsto_zero {R : Real} :
    Filter.Tendsto (fun i : Nat => dyadicRadius R i)
      Filter.atTop (nhds 0) := by
  have hpow :
      Filter.Tendsto (fun i : Nat => ((1 / 2 : Real) ^ i))
        Filter.atTop (nhds 0) :=
    tendsto_pow_atTop_nhds_zero_of_lt_one (by norm_num) (by norm_num)
  have hmul :
      Filter.Tendsto (fun i : Nat => R * ((1 / 2 : Real) ^ i))
        Filter.atTop (nhds (R * 0)) :=
    tendsto_const_nhds.mul hpow
  simpa [dyadicRadius, div_eq_mul_inv, inv_pow] using hmul

end Internal

end Dudley

end

end HighDimProb
