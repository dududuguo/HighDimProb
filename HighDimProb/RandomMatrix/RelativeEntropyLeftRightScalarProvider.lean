import HighDimProb.RandomMatrix.RelativeEntropyProvider
import Mathlib.Analysis.SpecialFunctions.ImproperIntegrals
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.Tactic

/-!
# Scalar left/right relative-entropy integral provider

This module contains the one-dimensional integral identities used by the
Lindblad/Effros left/right relative-entropy route. They are scalar inputs for
the later spectral-overlap, density-integrability, and matrix integral
representation leaves.

It does not prove matrix relative-entropy joint convexity, Epstein, Lieb,
Tropp, Golden-Thompson, or Matrix Bernstein.
-/

namespace HighDimProb

open MeasureTheory Filter
open scoped Topology

noncomputable section

namespace RelativeEntropy

/--
Scalar improper-integral representation for the perspective of `x log x`.

The representation measure has density `t / (1 + t)^2` on `(0, inf)`.
-/
theorem real_log_perspective_integral {x : Real} (hx : 0 < x) :
    ∫ t in Set.Ioi (0 : Real), ((x - 1) ^ 2 * t) / ((x + t) * (1 + t) ^ 2) =
      x * Real.log x - x + 1 := by
  let F : Real -> Real :=
    ((fun t : Real => -x * Real.log (x + t)) + fun t => x * Real.log (1 + t)) +
      fun t => (x - 1) * (1 + t)⁻¹
  let f : Real -> Real :=
    fun t => ((x - 1) ^ 2 * t) / ((x + t) * (1 + t) ^ 2)
  have hderiv : ∀ t ∈ Set.Ici (0 : Real), HasDerivAt F (f t) t := by
    intro t ht
    have ht0 : 0 <= t := ht
    have hxt_pos : 0 < x + t := by linarith
    have h1t_pos : 0 < 1 + t := by linarith
    have hxt : x + t ≠ 0 := hxt_pos.ne'
    have h1t : 1 + t ≠ 0 := h1t_pos.ne'
    have hlogx : HasDerivAt (fun y : Real => Real.log (x + y)) (1 / (x + t)) t := by
      have hbase : HasDerivAt (fun y : Real => x + y) 1 t :=
        (hasDerivAt_id t).const_add x
      simpa [one_div] using hbase.log hxt
    have hlog1 : HasDerivAt (fun y : Real => Real.log (1 + y)) (1 / (1 + t)) t := by
      have hbase : HasDerivAt (fun y : Real => 1 + y) 1 t :=
        (hasDerivAt_id t).const_add 1
      simpa [one_div] using hbase.log h1t
    have hinv1 : HasDerivAt (fun y : Real => (x - 1) * (1 + y)⁻¹)
        ((x - 1) * (-1 / (1 + t) ^ 2)) t := by
      have hbase : HasDerivAt (fun y : Real => 1 + y) 1 t :=
        (hasDerivAt_id t).const_add 1
      simpa using (hbase.inv h1t).const_mul (x - 1)
    have hraw : HasDerivAt F
        ((-x) * (1 / (x + t)) + x * (1 / (1 + t)) +
          ((x - 1) * (-1 / (1 + t) ^ 2))) t := by
      simpa [F] using ((hlogx.const_mul (-x)).add (hlog1.const_mul x)).add hinv1
    convert hraw using 1
    change
      ((x - 1) ^ 2 * t) / ((x + t) * (1 + t) ^ 2) =
        -x * (1 / (x + t)) + x * (1 / (1 + t)) +
          (x - 1) * (-1 / (1 + t) ^ 2)
    field_simp [hxt, h1t]
    ring
  have hnonneg : ∀ t ∈ Set.Ioi (0 : Real), 0 <= f t := by
    intro t ht
    have ht0 : 0 <= t := le_of_lt ht
    have hden_pos : 0 < (x + t) * (1 + t) ^ 2 := by positivity
    exact div_nonneg (mul_nonneg (sq_nonneg _) ht0) hden_pos.le
  have hlim : Tendsto F atTop (𝓝 0) := by
    have hlog_ratio :
        Tendsto (fun t : Real => Real.log ((1 + t) / (x + t))) atTop (𝓝 0) := by
      have hratio :
          Tendsto (fun t : Real => (1 + t) / (x + t)) atTop (𝓝 1) := by
        have hden_atTop : Tendsto (fun t : Real => x + t) atTop atTop :=
          tendsto_atTop_add_const_left atTop x tendsto_id
        have hsmall :
            Tendsto (fun t : Real => (1 - x) / (x + t)) atTop (𝓝 0) := by
          have hinv : Tendsto (fun t : Real => (x + t)⁻¹) atTop (𝓝 0) :=
            tendsto_inv_atTop_zero.comp hden_atTop
          simpa [div_eq_mul_inv] using (tendsto_const_nhds.mul hinv :
            Tendsto (fun t : Real => (1 - x) * (x + t)⁻¹) atTop (𝓝 ((1 - x) * 0)))
        have hsum : Tendsto (fun t : Real => 1 + (1 - x) / (x + t)) atTop (𝓝 1) := by
          simpa using tendsto_const_nhds.add hsmall
        refine hsum.congr' ?_
        filter_upwards [Ioi_mem_atTop (-x)] with t ht
        have ht' : -x < t := ht
        have hxt : x + t ≠ 0 := by linarith
        field_simp [hxt]
        ring
      simpa [Function.comp_def, Real.log_one] using
        (Real.continuousAt_log (by norm_num : (1 : Real) ≠ 0)).tendsto.comp hratio
    have hmain :
        Tendsto (fun t : Real => x * Real.log ((1 + t) / (x + t))) atTop (𝓝 0) := by
      simpa using tendsto_const_nhds.mul hlog_ratio
    have htail : Tendsto (fun t : Real => (x - 1) * (1 + t)⁻¹) atTop (𝓝 0) := by
      have hden : Tendsto (fun t : Real => (1 + t)) atTop atTop :=
        tendsto_atTop_add_const_left atTop (1 : Real) tendsto_id
      have hinv : Tendsto (fun t : Real => (1 + t)⁻¹) atTop (𝓝 0) :=
        tendsto_inv_atTop_zero.comp hden
      simpa using (tendsto_const_nhds.mul hinv :
        Tendsto (fun t : Real => (x - 1) * (1 + t)⁻¹) atTop (𝓝 ((x - 1) * 0)))
    have hF_eq :
        (fun t => F t) =ᶠ[atTop]
          fun t => x * Real.log ((1 + t) / (x + t)) + (x - 1) * (1 + t)⁻¹ := by
      filter_upwards [Ioi_mem_atTop (max 0 (-x))] with t ht
      have hxt_pos : 0 < x + t := by
        have ht' : -x < t := lt_of_le_of_lt (le_max_right 0 (-x)) ht
        linarith
      have h1t_pos : 0 < 1 + t := by
        have ht0 : 0 < t := lt_of_le_of_lt (le_max_left 0 (-x)) ht
        linarith
      simp [F]
      rw [Real.log_div h1t_pos.ne' hxt_pos.ne']
      ring
    simpa using (hmain.add htail).congr' hF_eq.symm
  have hInt := integral_Ioi_of_hasDerivAt_of_nonneg'
      (a := (0 : Real)) (g := F) (g' := f) (l := 0) hderiv hnonneg hlim
  calc
    ∫ t in Set.Ioi (0 : Real), ((x - 1) ^ 2 * t) / ((x + t) * (1 + t) ^ 2)
        = ∫ t in Set.Ioi (0 : Real), f t := rfl
    _ = 0 - F 0 := hInt
    _ = x * Real.log x - x + 1 := by
      simp [F, Real.log_one]
      ring

/--
Two-parameter scalar relative-entropy representation with denominator
`a + t b`.
-/
theorem real_relativeEntropy_integral_representation
    {a b : Real} (ha : 0 < a) (hb : 0 < b) :
    ∫ t in Set.Ioi (0 : Real),
        ((a - b) ^ 2 * t) / ((a + t * b) * (1 + t) ^ 2) =
      a * (Real.log a - Real.log b) - (a - b) := by
  have hx : 0 < a / b := div_pos ha hb
  have hpoint :
      Set.EqOn
        (fun t : Real => ((a - b) ^ 2 * t) / ((a + t * b) * (1 + t) ^ 2))
        (fun t : Real => b * ((((a / b) - 1) ^ 2 * t) / (((a / b) + t) * (1 + t) ^ 2)))
        (Set.Ioi (0 : Real)) := by
    intro t ht
    have ht0 : 0 < t := ht
    have hbne : b ≠ 0 := hb.ne'
    have hden₁ : a + t * b ≠ 0 := by
      exact (add_pos_of_pos_of_nonneg ha (mul_nonneg (le_of_lt ht0) hb.le)).ne'
    have hden₂ : a / b + t ≠ 0 := by
      have : 0 < a / b + t := add_pos hx ht0
      exact this.ne'
    have hden₃ : 1 + t ≠ 0 := by
      have : 0 < 1 + t := by linarith
      exact this.ne'
    field_simp [hbne, hden₁, hden₂, hden₃]
  calc
    ∫ t in Set.Ioi (0 : Real), ((a - b) ^ 2 * t) / ((a + t * b) * (1 + t) ^ 2)
        = ∫ t in Set.Ioi (0 : Real),
            b * ((((a / b) - 1) ^ 2 * t) / (((a / b) + t) * (1 + t) ^ 2)) := by
      exact setIntegral_congr_fun measurableSet_Ioi hpoint
    _ = b * (∫ t in Set.Ioi (0 : Real),
            (((a / b) - 1) ^ 2 * t) / (((a / b) + t) * (1 + t) ^ 2)) := by
      rw [integral_const_mul]
    _ = b * ((a / b) * Real.log (a / b) - (a / b) + 1) := by
      rw [real_log_perspective_integral hx]
    _ = a * (Real.log a - Real.log b) - (a - b) := by
      rw [Real.log_div ha.ne' hb.ne']
      field_simp [hb.ne']
      ring

/-- Density form of `real_relativeEntropy_integral_representation`. -/
theorem real_relativeEntropy_integral_representation_density
    {a b : Real} (ha : 0 < a) (hb : 0 < b) :
    ∫ t in Set.Ioi (0 : Real),
        (t / (1 + t) ^ 2) * ((a - b) ^ 2 / (a + t * b)) =
      a * (Real.log a - Real.log b) - (a - b) := by
  calc
    ∫ t in Set.Ioi (0 : Real),
        (t / (1 + t) ^ 2) * ((a - b) ^ 2 / (a + t * b))
        = ∫ t in Set.Ioi (0 : Real),
            ((a - b) ^ 2 * t) / ((a + t * b) * (1 + t) ^ 2) := by
      refine setIntegral_congr_fun measurableSet_Ioi ?_
      intro t ht
      have ht0 : 0 < t := ht
      have hden₁ : a + t * b ≠ 0 := by
        exact (add_pos_of_pos_of_nonneg ha (mul_nonneg (le_of_lt ht) hb.le)).ne'
      have hden₂ : (1 + t) ^ 2 ≠ 0 := by
        have h1t : 1 + t ≠ 0 := by linarith
        exact pow_ne_zero 2 h1t
      field_simp [hden₁, hden₂]
    _ = a * (Real.log a - Real.log b) - (a - b) :=
      real_relativeEntropy_integral_representation ha hb

/-- Integrability of the scalar relative-entropy representation integrand on `(0, inf)`. -/
theorem real_relativeEntropy_integrand_integrableOn
    {a b : Real} (ha : 0 < a) (hb : 0 < b) :
    IntegrableOn
      (fun t : Real => ((a - b) ^ 2 * t) / ((a + t * b) * (1 + t) ^ 2))
      (Set.Ioi (0 : Real)) := by
  by_cases hab : a = b
  · subst a
    simp
  · rw [IntegrableOn]
    refine Integrable.of_integral_ne_zero ?_
    have hrepr := real_relativeEntropy_integral_representation (a := a) (b := b) ha hb
    have hx : 0 < a / b := div_pos ha hb
    have hxne : a / b ≠ 1 := by
      intro h
      have hbne : b ≠ 0 := hb.ne'
      have : a = b := by
        field_simp [hbne] at h
        exact h
      exact hab this
    have hinner_pos : 0 < (a / b) * Real.log (a / b) - (a / b) + 1 := by
      have hinv_ne : (a / b)⁻¹ ≠ 1 := by
        intro h
        apply hxne
        rw [← inv_inv (a / b), h]
        norm_num
      have hlt := Real.log_lt_sub_one_of_pos (inv_pos.mpr hx) hinv_ne
      rw [Real.log_inv] at hlt
      have hlog_lower : 1 - (a / b)⁻¹ < Real.log (a / b) := by linarith
      have hxmul :
          (a / b) * (1 - (a / b)⁻¹) < (a / b) * Real.log (a / b) :=
        mul_lt_mul_of_pos_left hlog_lower hx
      have hleft : (a / b) * (1 - (a / b)⁻¹) = (a / b) - 1 := by
        field_simp [hx.ne']
      linarith
    have hrhs_pos : 0 < a * (Real.log a - Real.log b) - (a - b) := by
      have hrewrite :
          a * (Real.log a - Real.log b) - (a - b) =
            b * ((a / b) * Real.log (a / b) - (a / b) + 1) := by
        rw [Real.log_div ha.ne' hb.ne']
        have hbne : b ≠ 0 := hb.ne'
        field_simp [hbne]
        ring
      rw [hrewrite]
      exact mul_pos hb hinner_pos
    exact ne_of_gt (by simpa [hrepr] using hrhs_pos)

end RelativeEntropy

end

end HighDimProb
