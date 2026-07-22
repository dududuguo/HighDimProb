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

/-- The covering-number integrand in the Dudley entropy integral. -/
def dudleyEntropyIntegrand {alpha : Type*} [PseudoMetricSpace alpha]
    (K : Set alpha) (t : Real) : Real :=
  Real.sqrt (2 * Real.log (2 * ((coveringNumber K t).toNat : Real)))

/-- The full interval Dudley entropy integral at base radius `R`. -/
def dudleyEntropyIntegral {alpha : Type*} [PseudoMetricSpace alpha]
    (K : Set alpha) (R : Real) : Real :=
  ∫ t in 0..R, dudleyEntropyIntegrand K t

/-- The Dudley entropy integrand is pointwise nonnegative. -/
theorem dudleyEntropyIntegrand_nonneg {alpha : Type*} [PseudoMetricSpace alpha]
    (K : Set alpha) (t : Real) :
    0 <= dudleyEntropyIntegrand K t := by
  exact Real.sqrt_nonneg _

/-- Every positive dyadic truncation is bounded by the full entropy integral. -/
theorem truncatedDudleyEntropyIntegral_le_dudleyEntropyIntegral
    {alpha : Type*} [PseudoMetricSpace alpha]
    {K : Set alpha} {R : Real} (L : Nat) (hR : 0 < R)
    (hInt : IntervalIntegrable (dudleyEntropyIntegrand K) volume 0 R) :
    (∫ t in dyadicRadius R (L + 1)..R, dudleyEntropyIntegrand K t) <=
      dudleyEntropyIntegral K R := by
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
  have h0a : IntervalIntegrable (dudleyEntropyIntegrand K) volume 0
      (dyadicRadius R (L + 1)) :=
    hInt.mono_set (by
      rw [Set.uIcc_of_le ha, Set.uIcc_of_le hR.le]
      exact Set.Icc_subset_Icc le_rfl haR)
  have haR' : IntervalIntegrable (dudleyEntropyIntegrand K) volume
      (dyadicRadius R (L + 1)) R :=
    hInt.mono_set (by
      rw [Set.uIcc_of_le haR, Set.uIcc_of_le hR.le]
      exact Set.Icc_subset_Icc ha le_rfl)
  have h0a_nonneg :
      0 <= ∫ t in 0..dyadicRadius R (L + 1), dudleyEntropyIntegrand K t :=
    intervalIntegral.integral_nonneg ha (fun t _ => dudleyEntropyIntegrand_nonneg K t)
  have hadd := intervalIntegral.integral_add_adjacent_intervals h0a haR'
  calc
    (∫ t in dyadicRadius R (L + 1)..R, dudleyEntropyIntegrand K t) <=
        (∫ t in 0..dyadicRadius R (L + 1), dudleyEntropyIntegrand K t) +
          (∫ t in dyadicRadius R (L + 1)..R, dudleyEntropyIntegrand K t) := by
      linarith
    _ = ∫ t in 0..R, dudleyEntropyIntegrand K t := hadd
    _ = dudleyEntropyIntegral K R := by
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

/-- The full Dudley entropy integral is nonnegative for a nonnegative radius. -/
theorem dudleyEntropyIntegral_nonneg {alpha : Type*} [PseudoMetricSpace alpha]
    (K : Set alpha) {R : Real} (hR : 0 <= R) :
    0 <= dudleyEntropyIntegral K R := by
  exact intervalIntegral.integral_nonneg hR
    (fun t _ => dudleyEntropyIntegrand_nonneg K t)

/-- A nonnegative scalar preserves nonnegativity of the full Dudley integral. -/
theorem four_mul_sigma_mul_dudleyEntropyIntegral_nonneg
    {alpha : Type*} [PseudoMetricSpace alpha] (K : Set alpha)
    {R sigma : Real} (hR : 0 <= R) (hsigma : 0 <= sigma) :
    0 <= 4 * sigma * dudleyEntropyIntegral K R := by
  exact mul_nonneg (mul_nonneg (by norm_num) hsigma)
    (dudleyEntropyIntegral_nonneg K hR)

end

end HighDimProb
