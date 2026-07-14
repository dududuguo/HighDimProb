import HighDimProb.Concentration.FiniteMax
import HighDimProb.SubGaussian

/-!
# Finite maxima of centered subGaussian processes

This module specializes the fixed-parameter finite-maximum bound to a common
Mathlib subGaussian MGF scale and evaluates it at the optimized parameter.
-/

namespace HighDimProb

open MeasureTheory

noncomputable section

/--
Expected finite-process maximum bound for a common centered subGaussian scale.

The MGF and exponential-integrability obligations are discharged directly from
Mathlib's `HasSubgaussianMGF` fields.
-/
theorem expect_processSup_le_of_centeredSubGaussianMGF {Omega T : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {X : RandomProcess Omega T Real} {s : Finset T} (hs : s.Nonempty)
    (hs_card : 2 ≤ s.card)
    {K : Real}
    (hXMeas : ∀ t, t ∈ s → Measurable (X t))
    (hXSG : ∀ t, t ∈ s → CenteredSubGaussianMGF P (X t) K) :
    expect P (processSup X s hs) <=
      K * Real.sqrt (2 * Real.log (s.card : Real)) := by
  have hK : 0 < K := by
    obtain ⟨t, ht⟩ := hs
    exact (hXSG t ht).1
  have hLogPos : 0 < Real.log (s.card : Real) :=
    Real.log_pos (by exact_mod_cast hs_card)
  have hTwoLogPos : 0 < 2 * Real.log (s.card : Real) := by
    positivity
  let q : Real := Real.sqrt (2 * Real.log (s.card : Real))
  have hqPos : 0 < q := by
    dsimp [q]
    exact Real.sqrt_pos.mpr hTwoLogPos
  let theta : Real := q / K
  have hTheta : 0 < theta := by
    dsimp [theta]
    exact div_pos hqPos hK
  have hXCgf : ∀ t, t ∈ s →
      ProbabilityTheory.cgf (X t) P theta <= theta ^ 2 * K ^ 2 / 2 := by
    intro t ht
    have h := (hXSG t ht).2.cgf_le theta
    simpa [theta, q, mul_comm] using h
  have hXExpInt : ∀ t, t ∈ s →
      IntegrableRealRandomVariable P
        (fun omega => Real.exp (theta * X t omega)) := by
    intro t ht
    exact (hXSG t ht).2.integrable_exp_mul theta
  have hXInt : ∀ t, t ∈ s → IntegrableRealRandomVariable P (X t) := by
    intro t ht
    exact (hXSG t ht).2.integrable
  have hBound := expect_processSup_le_of_cgf_bound_at
    (P := P) (X := X) (s := s) hs hTheta hXMeas hXInt hXCgf hXExpInt
  have hqSq : q ^ 2 = 2 * Real.log (s.card : Real) := by
    dsimp [q]
    exact Real.sq_sqrt (le_of_lt hTwoLogPos)
  have hAlg :
      (1 / theta) * (Real.log (s.card : Real) + theta ^ 2 * K ^ 2 / 2) =
        K * q := by
    dsimp [theta]
    field_simp [ne_of_gt hK, ne_of_gt hqPos]
    nlinarith [hqSq]
  calc
    expect P (processSup X s hs) <=
        (1 / theta) * (Real.log (s.card : Real) + theta ^ 2 * K ^ 2 / 2) := hBound
    _ = K * Real.sqrt (2 * Real.log (s.card : Real)) := by
      rw [hAlg]

end

end HighDimProb
