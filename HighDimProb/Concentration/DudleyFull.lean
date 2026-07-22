import HighDimProb.Analysis.NetSupremum
import HighDimProb.Analysis.NonnegativeExpectationLimit
import HighDimProb.RandomProcess.PathRegularity
import HighDimProb.Concentration.DudleyEntropyIntegral

/-!
# Full Dudley inequality

This file passes from finite terminal nets to the actual supremum over a
totally bounded index set.  The finite nets are chosen independently at the
dyadic radii; no nesting or countability assumption on `K` is used.  The
sample-path hypothesis supplies the pointwise limit of the finite suprema,
while the nonnegative Fatou wrapper supplies integrability of that limit.
-/

namespace HighDimProb

open Filter MeasureTheory Topology

set_option autoImplicit false

noncomputable section

/-- The anchored absolute-increment supremum over the actual index set `K`. -/
def dudleySupremum
    {Omega alpha : Type*} [MeasurableSpace Omega]
    (X : RandomProcess Omega alpha Real) (K : Set alpha) (t0 : alpha) :
    Omega -> Real :=
  fun omega => sSup (Set.image (fun t => |X t omega - X t0 omega|) K)

/-- Full Dudley bound for the measurable, integrable supremum over `K`. -/
theorem dudley_full_supremum_bound
    {Omega alpha : Type*} [MeasurableSpace Omega] [PseudoMetricSpace alpha]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {X : RandomProcess Omega alpha Real}
    {K : Set alpha} {t0 : alpha} {R sigma : Real}
    (hK : TotallyBounded K) (ht0 : t0 ∈ K) (hR : 0 < R)
    (hdist : ∀ t ∈ K, dist t t0 ≤ R)
    (hXMeas : ∀ t, Measurable (X t))
    (hX : HasSubGaussianMGFIncrements P X sigma) (hsigma : 0 < sigma)
    (hPath : HasUniformlyContinuousSamplePathsOn
      (fun t omega => X t omega) K)
    (hEntropy : IntervalIntegrable (dudleyEntropyIntegrand K) volume 0 R) :
    Measurable (dudleySupremum X K t0) ∧
      Integrable (dudleySupremum X K t0) P ∧
        expect P (dudleySupremum X K t0) ≤
          4 * sigma * dudleyEntropyIntegral K R := by
  have hExist : ∀ n : Nat, ∃ T : Finset alpha, ∃ hT : T.Nonempty,
      (T : Set alpha) ⊆ K ∧
      IsInternalEpsilonNet K (T : Set alpha) (dyadicRadius R n) ∧
      expect P (fun omega =>
          T.sup' hT (fun t => |X t omega - X t0 omega|)) ≤
        4 * sigma * (∫ t in dyadicRadius R (n + 1)..R,
          dudleyEntropyIntegrand K t) := by
    intro n
    simpa [dudleyEntropyIntegrand] using
      (exists_terminal_net_expect_sup'_abs_sub_le_truncatedEntropyIntegral
        (P := P) (X := X) (K := K) (R := R)
        n hK ht0 hR hdist hXMeas hX hsigma)
  choose T hT hTsub hnet hbound using hExist
  let YFinite : RandomProcess Omega alpha Real :=
    fun t omega => |X t omega - X t0 omega|
  let fFinite : Nat -> Omega -> Real := fun n omega =>
    processSup YFinite (T n) (hT n) omega
  let C : Real := 4 * sigma * dudleyEntropyIntegral K R
  have hFiniteMeas : ∀ n, Measurable (fFinite n) := by
    intro n
    dsimp [fFinite]
    unfold processSup
    exact Finset.measurable_sup' (hT n) (fun t _ht =>
      ((hXMeas t).sub (hXMeas t0)).abs)
  have hFiniteInt : ∀ n, Integrable (fFinite n) P := by
    intro n

    have hYInt : ∀ t, t ∈ T n -> IntegrableRealRandomVariable P (YFinite t) := by
      intro t ht
      have htK : t ∈ K := hTsub n ht
      have hSG := HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le
        hX hsigma hR (hdist t htK)
      change IntegrableRealRandomVariable P
        (fun omega => |X t omega - X t0 omega|)
      exact hSG.2.integrable.abs
    have hSup := integrable_processSup
      (P := P) (X := YFinite) (s := T n) (hT n) (hYInt)
    exact hSup
  have hFiniteNonneg : forall n omega, 0 <= fFinite n omega := by
    intro n omega
    have hpoint : 0 <= (T n).sup' (hT n)
        (fun t => |X t omega - X t0 omega|) := by
      obtain ⟨t, ht⟩ := hT n
      exact (abs_nonneg _).trans
        (Finset.le_sup' (fun t => |X t omega - X t0 omega|) ht)
    simpa only [fFinite, YFinite, processSup, Finset.sup'_apply] using hpoint
  have hFiniteBound : ∀ n, expect P (fFinite n) ≤ C := by
    intro n
    have hTrunc := truncatedDudleyEntropyIntegral_le_dudleyEntropyIntegral
      (K := K) (R := R) n hR hEntropy
    have hScaled := mul_le_mul_of_nonneg_left hTrunc
      (mul_nonneg (by norm_num : (0 : Real) <= 4) hsigma.le)
    dsimp [C]
    calc
      expect P (fFinite n) = expect P (fun omega =>
          (T n).sup' (hT n) (fun t => |X t omega - X t0 omega|)) := by
        simp [fFinite, YFinite, processSup, Finset.sup'_apply]
      _ ≤ 4 * sigma * (∫ t in dyadicRadius R (n + 1)..R,
          dudleyEntropyIntegrand K t) := hbound n
      _ ≤ 4 * sigma * dudleyEntropyIntegral K R := by
        exact hScaled
  have hTendsto : ∀ omega,
      Tendsto (fun n => fFinite n omega) atTop
        (nhds (dudleySupremum X K t0 omega)) := by
    intro omega
    simpa [fFinite, YFinite, dudleySupremum, anchoredAbsIncrement, processSup, Finset.sup'_apply] using
      (tendsto_finset_sup'_abs_sub_of_uniformContinuousOn_of_isInternalEpsilonNet
        (K := K) (T := T) (eps := fun n => dyadicRadius R n)
        (f := fun t => X t omega) (t0 := t0) ht0 hT hnet
        (fun n => dyadicRadius_pos hR n) dyadicRadius_tendsto_zero
        (hPath omega))
  have hLimitNonneg : ∀ omega, 0 ≤ dudleySupremum X K t0 omega := by
    intro omega
    apply le_csSup (bddAbove_anchoredAbsIncrement_image hK hPath t0 omega)
    refine ⟨t0, ht0, ?_⟩
    simp [anchoredAbsIncrement]
  have hLimitMeas : Measurable (dudleySupremum X K t0) :=
    measurable_of_tendsto_metrizable hFiniteMeas
      ((tendsto_pi_nhds).2 hTendsto)
  have hCore : Integrable (dudleySupremum X K t0) P ∧
      expect P (dudleySupremum X K t0) ≤ C :=
    integrable_of_tendsto_of_nonneg_of_integral_le
      hFiniteMeas hLimitMeas hFiniteNonneg hLimitNonneg hTendsto
      hFiniteInt (by
        dsimp [C]
        exact four_mul_sigma_mul_dudleyEntropyIntegral_nonneg
          (K := K) (R := R) (sigma := sigma)
          (hR := hR.le) (hsigma := hsigma.le) (hInt := hEntropy)) hFiniteBound
  exact ⟨hLimitMeas, hCore.1, by simpa [C] using hCore.2⟩

end

end HighDimProb
