import Mathlib.Probability.Distributions.Gaussian.Real
import Mathlib.Probability.Independence.Basic

set_option autoImplicit false

namespace HighDimProb

open MeasureTheory ProbabilityTheory
open scoped NNReal ENNReal

/-!
# Gaussian affine stability (G1a)

On the product probability space `γ.prod γ` with `γ = gaussianReal 0 1`, any
linear combination `z ↦ a * z.1 + b * z.2` is Gaussian with mean `0` and
variance `a^2 + b^2`:

`((gaussianReal 0 1).prod (gaussianReal 0 1)).map (fun z => a * z.1 + b * z.2)
  = gaussianReal 0 ⟨a^2 + b^2, _⟩`.

Recall (checked against the Mathlib source) that the second argument of
`gaussianReal` is the *variance* (`variance_id_gaussianReal : Var[id; gaussianReal μ v] = v`),
not the standard deviation. The degenerate case `a^2 + b^2 = 0` (equivalently
`a = b = 0`) is included: variance `0` gives `Measure.dirac 0`.

The proof reuses Mathlib's Gaussian scaling (`gaussianReal_map_const_mul`),
independent-Gaussian summation (`gaussianReal_add_gaussianReal_of_indepFun`),
and the independence of the two coordinates on a product measure
(`indepFun_iff_map_prod_eq_prod_map_map`); it does not reprove Gaussian
convolution from the density. No Poincaré, log-Sobolev, Herbst, or Dudley
content is touched.
-/

/-- Independence on the Gaussian product space: the two coordinates of
`(gaussianReal 0 1).prod (gaussianReal 0 1)` are independent, since the product
measure is by construction the joint law of independent coordinates. -/
theorem indepFun_fst_snd_gaussianReal_prod :
    IndepFun Prod.fst Prod.snd ((gaussianReal 0 1).prod (gaussianReal 0 1)) := by
  rw [indepFun_iff_map_prod_eq_prod_map_map measurable_fst.aemeasurable
    measurable_snd.aemeasurable]
  have hid : (fun z : ℝ × ℝ => (z.1, z.2)) = id := funext fun _ => rfl
  rw [hid, Measure.map_id, Measure.map_fst_prod, Measure.map_snd_prod]
  simp

/-- Affine stability of the standard Gaussian: on `γ.prod γ`, the linear
combination `z ↦ a * z.1 + b * z.2` has law `gaussianReal 0 ⟨a^2 + b^2, _⟩`.
The case `a = b = 0` is included (degenerate variance, a Dirac mass). -/
theorem gaussianReal_prod_map_add_linear (a b : ℝ) :
    ((gaussianReal 0 1).prod (gaussianReal 0 1)).map
        (fun z : ℝ × ℝ => a * z.1 + b * z.2) =
      gaussianReal 0 ⟨a ^ 2 + b ^ 2, add_nonneg (sq_nonneg a) (sq_nonneg b)⟩ := by
  have hax : Measurable (fun x : ℝ => a * x) := by fun_prop
  have hbx : Measurable (fun x : ℝ => b * x) := by fun_prop
  have hXY : IndepFun (fun z : ℝ × ℝ => a * z.1) (fun z : ℝ × ℝ => b * z.2)
      ((gaussianReal 0 1).prod (gaussianReal 0 1)) :=
    indepFun_fst_snd_gaussianReal_prod.comp hax hbx
  have hX : ((gaussianReal 0 1).prod (gaussianReal 0 1)).map
        (fun z : ℝ × ℝ => a * z.1) = gaussianReal 0 ⟨a ^ 2, sq_nonneg a⟩ := by
    rw [show (fun z : ℝ × ℝ => a * z.1) = (fun x : ℝ => a * x) ∘ Prod.fst from rfl,
      ← Measure.map_map hax measurable_fst, Measure.map_fst_prod, measure_univ,
      one_smul, gaussianReal_map_const_mul, mul_zero, mul_one]
  have hY : ((gaussianReal 0 1).prod (gaussianReal 0 1)).map
        (fun z : ℝ × ℝ => b * z.2) = gaussianReal 0 ⟨b ^ 2, sq_nonneg b⟩ := by
    rw [show (fun z : ℝ × ℝ => b * z.2) = (fun x : ℝ => b * x) ∘ Prod.snd from rfl,
      ← Measure.map_map hbx measurable_snd, Measure.map_snd_prod, measure_univ,
      one_smul, gaussianReal_map_const_mul, mul_zero, mul_one]
  have h := gaussianReal_add_gaussianReal_of_indepFun hXY hX hY
  have hfun : (fun z : ℝ × ℝ => a * z.1) + (fun z : ℝ × ℝ => b * z.2) =
      fun z : ℝ × ℝ => a * z.1 + b * z.2 := rfl
  have hmean : (0 : ℝ) + 0 = 0 := by ring
  have hvar : (⟨a ^ 2, sq_nonneg a⟩ + ⟨b ^ 2, sq_nonneg b⟩ : ℝ≥0) =
      ⟨a ^ 2 + b ^ 2, add_nonneg (sq_nonneg a) (sq_nonneg b)⟩ := by
    apply NNReal.coe_injective
    push_cast
    ring
  rw [hfun, hmean, hvar] at h
  exact h

/-- Unit-variance stability: if `a^2 + b^2 = 1`, the linear combination is
again standard Gaussian. -/
theorem gaussianReal_prod_map_add_linear_of_sq_add_sq_eq_one (a b : ℝ)
    (h : a ^ 2 + b ^ 2 = 1) :
    ((gaussianReal 0 1).prod (gaussianReal 0 1)).map
        (fun z : ℝ × ℝ => a * z.1 + b * z.2) = gaussianReal 0 1 := by
  rw [gaussianReal_prod_map_add_linear a b]
  congr 1
  apply NNReal.coe_injective
  simp only [NNReal.coe_mk, NNReal.coe_one]
  exact h

/-- Degenerate variance: at `a = b = 0` the combination is the constant `0`,
whose law is `Measure.dirac 0`, matching the general formula at variance `0`. -/
theorem gaussianReal_prod_map_add_linear_zero_zero :
    ((gaussianReal 0 1).prod (gaussianReal 0 1)).map
        (fun z : ℝ × ℝ => (0 : ℝ) * z.1 + (0 : ℝ) * z.2) = Measure.dirac 0 := by
  have hconst : (fun z : ℝ × ℝ => (0 : ℝ) * z.1 + (0 : ℝ) * z.2) =
      fun _ => 0 := by
    funext z
    ring
  rw [hconst, Measure.map_const, measure_univ, one_smul]

/-- Integrability transport: if a real `f` is integrable against the image
Gaussian, its composition with the linear combination is integrable on the
product space. -/
theorem integrable_gaussianReal_prod_add_linear {f : ℝ → ℝ} (a b : ℝ)
    (hfm : Measurable f)
    (hfi : Integrable f
      (gaussianReal 0 ⟨a ^ 2 + b ^ 2, add_nonneg (sq_nonneg a) (sq_nonneg b)⟩)) :
    Integrable (fun z : ℝ × ℝ => f (a * z.1 + b * z.2))
      ((gaussianReal 0 1).prod (gaussianReal 0 1)) := by
  have hgm : Measurable (fun z : ℝ × ℝ => a * z.1 + b * z.2) :=
    (measurable_fst.const_mul a).add (measurable_snd.const_mul b)
  have hfi' : Integrable f (((gaussianReal 0 1).prod (gaussianReal 0 1)).map
      (fun z : ℝ × ℝ => a * z.1 + b * z.2)) := by
    rw [gaussianReal_prod_map_add_linear]
    exact hfi
  exact (integrable_map_measure hfm.aestronglyMeasurable hgm.aemeasurable).mp hfi'

/-- Integral transport for the linear combination: for a measurable real `f`
integrable against the image Gaussian, the product-space integral equals the
integral against `gaussianReal 0 ⟨a^2 + b^2, _⟩`; the composed integrand is
itself integrable (first component), so no non-integrability convention is
used. -/
theorem integral_gaussianReal_prod_add_linear {f : ℝ → ℝ} (a b : ℝ)
    (hfm : Measurable f)
    (hfi : Integrable f
      (gaussianReal 0 ⟨a ^ 2 + b ^ 2, add_nonneg (sq_nonneg a) (sq_nonneg b)⟩)) :
    Integrable (fun z : ℝ × ℝ => f (a * z.1 + b * z.2))
        ((gaussianReal 0 1).prod (gaussianReal 0 1)) ∧
      ∫ z, f (a * z.1 + b * z.2) ∂((gaussianReal 0 1).prod (gaussianReal 0 1)) =
        ∫ u, f u ∂(gaussianReal 0 ⟨a ^ 2 + b ^ 2,
          add_nonneg (sq_nonneg a) (sq_nonneg b)⟩) := by
  refine ⟨integrable_gaussianReal_prod_add_linear a b hfm hfi, ?_⟩
  have hgm : Measurable (fun z : ℝ × ℝ => a * z.1 + b * z.2) :=
    (measurable_fst.const_mul a).add (measurable_snd.const_mul b)
  rw [← gaussianReal_prod_map_add_linear a b]
  exact (integral_map hgm.aemeasurable hfm.aestronglyMeasurable).symm

/-- The Ornstein–Uhlenbeck/Mehler coefficients `a(t) = exp(-t)`,
`b(t) = sqrt(1 - exp(-2t))` square to one for `t ≥ 0`. -/
theorem ou_coeff_sq_add_sq_eq_one {t : ℝ} (ht : 0 ≤ t) :
    Real.exp (-t) ^ 2 + Real.sqrt (1 - Real.exp (-2 * t)) ^ 2 = 1 := by
  have h1 : Real.exp (-t) ^ 2 = Real.exp (-2 * t) := by
    rw [pow_two, ← Real.exp_add]
    congr 1
    ring
  have hle : Real.exp (-2 * t) ≤ 1 := by
    have harg : -2 * t ≤ 0 := by linarith
    calc Real.exp (-2 * t) ≤ Real.exp 0 := Real.exp_le_exp.mpr harg
      _ = 1 := Real.exp_zero
  have h2 : Real.sqrt (1 - Real.exp (-2 * t)) ^ 2 = 1 - Real.exp (-2 * t) :=
    Real.sq_sqrt (by linarith)
  rw [h1, h2]
  ring

/-- Mehler stability: for `t ≥ 0`, `exp(-t) * z.1 + sqrt(1 - exp(-2t)) * z.2`
is standard Gaussian on the product space. -/
theorem gaussianReal_prod_map_ouLinear {t : ℝ} (ht : 0 ≤ t) :
    ((gaussianReal 0 1).prod (gaussianReal 0 1)).map
        (fun z : ℝ × ℝ => Real.exp (-t) * z.1 +
          Real.sqrt (1 - Real.exp (-2 * t)) * z.2) = gaussianReal 0 1 :=
  gaussianReal_prod_map_add_linear_of_sq_add_sq_eq_one _ _
    (ou_coeff_sq_add_sq_eq_one ht)

end HighDimProb
