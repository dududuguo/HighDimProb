import HighDimProb.Expectation
import HighDimProb.Chaining
import HighDimProb.Analysis.LogSumExp
import Mathlib.Analysis.Convex.Integral
import Mathlib.MeasureTheory.Integral.Bochner.Basic

/-!
# Finite maximum expectation bounds

This module gives the fixed-parameter MGF bound for a finite supremum of a
real-valued random process.
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators

noncomputable section

/-- Exponential soft-max domination for a finite process supremum. -/
theorem exp_mul_processSup_le_sum {Omega T : Type*} [MeasurableSpace Omega]
    {X : RandomProcess Omega T Real} {s : Finset T} (hs : s.Nonempty)
    (theta : Real) (omega : Omega) :
    Real.exp (theta * processSup X s hs omega) <=
      ∑ t ∈ s, Real.exp (theta * X t omega) := by
  unfold processSup
  simp only [Finset.sup'_apply]
  exact exp_mul_sup'_le_sum_exp hs (fun t => X t omega) theta

/-- Expectation is bounded by the logarithm of the exponential moment. -/
theorem expect_le_log_mgf {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {Y : RealRandomVariable Omega} (hYInt : IntegrableRealRandomVariable P Y)
    {theta : Real} (hTheta : 0 < theta)
    (hYExpInt :
      IntegrableRealRandomVariable P (fun omega => Real.exp (theta * Y omega))) :
    expect P Y <= (1 / theta) * Real.log
      (expect P (fun omega => Real.exp (theta * Y omega))) := by
  have hconv : ConvexOn Real Set.univ Real.exp := convexOn_exp
  have hcont : ContinuousOn Real.exp Set.univ :=
    Real.continuous_exp.continuousOn
  have hclosed : IsClosed (Set.univ : Set Real) := isClosed_univ
  have hThetaYInt : Integrable (fun omega => theta * Y omega) P :=
    hYInt.const_mul theta
  have hJensen := ConvexOn.map_integral_le hconv hcont hclosed (by simp)
    hThetaYInt hYExpInt
  have hIntegral : (∫ omega, theta * Y omega ∂P) = theta * expect P Y :=
    integral_const_mul theta Y
  have hLogBound : theta * expect P Y <=
      Real.log (expect P (fun omega => Real.exp (theta * Y omega))) := by
    have hExpBound : Real.exp (theta * expect P Y) <=
        expect P (fun omega => Real.exp (theta * Y omega)) :=
      hIntegral ▸ hJensen
    calc
      theta * expect P Y = Real.log (Real.exp (theta * expect P Y)) :=
        (Real.log_exp _).symm
      _ <= Real.log (expect P (fun omega => Real.exp (theta * Y omega))) := by
        exact Real.strictMonoOn_log.monotoneOn
          (Set.mem_Ioi.mpr (Real.exp_pos _))
          (Set.mem_Ioi.mpr (integral_exp_pos hYExpInt)) hExpBound
  have hResult : expect P Y <=
      (1 / theta) * Real.log
        (expect P (fun omega => Real.exp (theta * Y omega))) := by
    have hLogBound' : expect P Y * theta <=
        Real.log (expect P (fun omega => Real.exp (theta * Y omega))) := by
      linarith
    calc
      expect P Y = expect P Y * theta / theta := by field_simp
      _ <= Real.log (expect P (fun omega => Real.exp (theta * Y omega))) / theta := by
        apply div_le_div_of_nonneg_right hLogBound' (le_of_lt hTheta)
      _ = (1 / theta) * Real.log
          (expect P (fun omega => Real.exp (theta * Y omega))) := by ring
  exact hResult

/--
Fixed-parameter finite maximum expectation bound from pointwise C.G.F. bounds.

Only nonemptiness of `s` is required; its positive cardinality supplies the
positivity needed for the logarithm, including the singleton case.
-/
theorem expect_processSup_le_of_cgf_bound_at {Omega T : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {X : RandomProcess Omega T Real} {s : Finset T} (hs : s.Nonempty)
    {theta a : Real} (hTheta : 0 < theta)
    (hXMeas : forall t, t ∈ s -> Measurable (X t))
    (hXInt : forall t, t ∈ s -> IntegrableRealRandomVariable P (X t))
    (hXCgf : forall t, t ∈ s -> ProbabilityTheory.cgf (X t) P theta <= a)
    (hXExpInt : forall t, t ∈ s ->
      IntegrableRealRandomVariable P
        (fun omega => Real.exp (theta * X t omega))) :
    expect P (processSup X s hs) <=
      (1 / theta) * (Real.log (s.card : Real) + a) := by
  have hSupMeas : Measurable (processSup X s hs) := by
    unfold processSup
    exact Finset.measurable_sup' hs (fun t ht => hXMeas t ht)
  have hSupInt : IntegrableRealRandomVariable P (processSup X s hs) :=
    integrable_processSup hs hXInt
  have hMgfBound : forall t, t ∈ s ->
      expect P (fun omega => Real.exp (theta * X t omega)) <= Real.exp a := by
    intro t ht
    have hCgf := hXCgf t ht
    unfold ProbabilityTheory.cgf at hCgf
    have hExpBound := Real.exp_le_exp.mpr hCgf
    unfold ProbabilityTheory.mgf at hExpBound
    simp only [Real.exp_log (integral_exp_pos (hXExpInt t ht))] at hExpBound
    exact hExpBound
  have hSumInt : Integrable (fun omega =>
      ∑ t ∈ s, Real.exp (theta * X t omega)) P :=
    integrable_finset_sum s (fun t ht => hXExpInt t ht)
  have hSupExpBound :
      expect P (fun omega =>
        Real.exp (theta * processSup X s hs omega)) <=
        (s.card : Real) * Real.exp a := by
    calc
      expect P (fun omega =>
          Real.exp (theta * processSup X s hs omega)) <=
          expect P (fun omega => ∑ t ∈ s, Real.exp (theta * X t omega)) := by
        apply integral_mono_of_nonneg
        · exact ae_of_all P (fun _ => (Real.exp_pos _).le)
        · exact hSumInt
        · exact ae_of_all P (fun omega =>
            exp_mul_processSup_le_sum hs theta omega)
      _ = ∑ t ∈ s, expect P (fun omega => Real.exp (theta * X t omega)) :=
        integral_finset_sum s (fun t ht => hXExpInt t ht)
      _ <= ∑ t ∈ s, Real.exp a :=
        Finset.sum_le_sum (fun t ht => hMgfBound t ht)
      _ = (s.card : Real) * Real.exp a := by simp
  have hSupExpInt : Integrable (fun omega =>
      Real.exp (theta * processSup X s hs omega)) P := by
    apply Integrable.mono' hSumInt
    · apply Measurable.aestronglyMeasurable
      apply Measurable.exp
      apply Measurable.const_mul
      exact hSupMeas
    · refine ae_of_all P (fun omega => ?_)
      simp only [Real.norm_eq_abs]
      rw [abs_of_pos (Real.exp_pos _)]
      exact exp_mul_processSup_le_sum hs theta omega
  have hSupExpPos : 0 < expect P (fun omega =>
      Real.exp (theta * processSup X s hs omega)) :=
    integral_exp_pos hSupExpInt
  have hCardPos : 0 < (s.card : Real) := by
    exact_mod_cast (Finset.card_pos.mpr hs)
  have hLogBound : Real.log (expect P (fun omega =>
      Real.exp (theta * processSup X s hs omega))) <=
      Real.log (s.card : Real) + a := by
    calc
      Real.log (expect P (fun omega =>
          Real.exp (theta * processSup X s hs omega))) <=
          Real.log ((s.card : Real) * Real.exp a) := by
        exact Real.strictMonoOn_log.monotoneOn
          (Set.mem_Ioi.mpr hSupExpPos)
          (Set.mem_Ioi.mpr (mul_pos hCardPos (Real.exp_pos a))) hSupExpBound
      _ = Real.log (s.card : Real) + Real.log (Real.exp a) := by
        rw [Real.log_mul hCardPos.ne' (Real.exp_pos a).ne']
      _ = Real.log (s.card : Real) + a := by rw [Real.log_exp]
  calc
    expect P (processSup X s hs) <=
        (1 / theta) * Real.log
          (expect P (fun omega =>
            Real.exp (theta * processSup X s hs omega))) :=
      expect_le_log_mgf hSupInt hTheta hSupExpInt
    _ <= (1 / theta) * (Real.log (s.card : Real) + a) := by
      exact mul_le_mul_of_nonneg_left hLogBound
        (le_of_lt (one_div_pos.mpr hTheta))

end

end HighDimProb
