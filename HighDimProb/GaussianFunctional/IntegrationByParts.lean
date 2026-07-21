import Mathlib.Probability.Distributions.Gaussian.Real
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import Mathlib.Topology.Algebra.Support

set_option autoImplicit false

namespace HighDimProb

open MeasureTheory ProbabilityTheory Topology

noncomputable section

/-!
# Gaussian integration by parts (Stein identity), G0

The first strict base layer of the Gaussian functional inequalities route:
for the standard Gaussian measure `γ = gaussianReal 0 1` and a compactly
supported `C^1` test function `f : ℝ → ℝ`,

`∫ x, x * f x ∂γ = ∫ x, deriv f x ∂γ`.

The proof differentiates the Gaussian density (`φ' = -x φ`, so the final sign
is positive), integrates `deriv (f * φ)` to zero via the fundamental theorem of
calculus on a bounded interval containing the support, splits by integral
linearity with separately proved integrability, and transfers back to
`gaussianReal 0 1` through `integral_gaussianReal_eq_integral_smul`. Both sides
are proved integrable; the argument never relies on the Bochner integral of a
non-integrable function being zero by convention.

This module proves no Poincaré, log-Sobolev, Herbst, or concentration bound.
-/

/-- Derivative of the standard Gaussian density: `φ'(x) = -x * φ(x)`. -/
theorem hasDerivAt_gaussianPDFReal_zero_one (x : ℝ) :
    HasDerivAt (gaussianPDFReal 0 1) (-x * gaussianPDFReal 0 1 x) x := by
  have hφ : gaussianPDFReal 0 1 =
      fun y => (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-y ^ 2 / 2) := by
    funext y
    simp [gaussianPDFReal]
  have h1 : HasDerivAt (fun y : ℝ => -y ^ 2 / 2) (-x) x := by
    have h := ((hasDerivAt_pow 2 x).neg).div_const (2 : ℝ)
    have he : (fun y : ℝ => -y ^ 2 / 2) = (fun y : ℝ => -(y ^ 2) / 2) := by
      ext y
      ring
    rw [he]
    convert h using 1
    ring
  have hexp : HasDerivAt (fun y : ℝ => Real.exp (-y ^ 2 / 2))
      (Real.exp (-x ^ 2 / 2) * (-x)) x :=
    h1.exp
  rw [hφ]
  have h := hexp.const_mul (Real.sqrt (2 * Real.pi))⁻¹
  convert h using 1
  ring

/-- The standard Gaussian density is continuous. -/
theorem continuous_gaussianPDFReal_zero_one : Continuous (gaussianPDFReal 0 1) :=
  Differentiable.continuous (fun x =>
    (hasDerivAt_gaussianPDFReal_zero_one x).differentiableAt)

/-- A function that vanishes off the closed support of `f` has vanishing
derivative there as well; here applied to `f` itself. -/
theorem deriv_eq_zero_of_notMem_tsupport {f : ℝ → ℝ} {x : ℝ}
    (hx : x ∉ tsupport f) : deriv f x = 0 := by
  have hnhds : (tsupport f)ᶜ ∈ 𝓝 x :=
    (isClosed_tsupport f).isOpen_compl.mem_nhds hx
  have hf0 : f =ᶠ[𝓝 x] 0 := by
    filter_upwards [hnhds] with y hy
    by_contra hfy
    exact hy (subset_closure (Function.mem_support.mpr hfy))
  rw [hf0.deriv_eq]
  simp

/-- The derivative of a compactly supported function has compact support, since
`tsupport (deriv f) ⊆ tsupport f`: off the closed support, `f` is locally zero,
so its derivative vanishes there. -/
theorem hasCompactSupport_deriv_of_hasCompactSupport {f : ℝ → ℝ}
    (hfc : HasCompactSupport f) :
    HasCompactSupport (deriv f) := by
  apply IsCompact.of_isClosed_subset hfc (isClosed_tsupport (deriv f))
  apply closure_minimal _ (isClosed_tsupport f)
  intro x hx
  by_contra hxf
  exact (Function.mem_support.mp hx) (deriv_eq_zero_of_notMem_tsupport hxf)

/-- Pointwise derivative of `f * φ` with `φ` the standard Gaussian density. -/
theorem deriv_mul_gaussianPDFReal_zero_one {f : ℝ → ℝ}
    (hf : ContDiff ℝ 1 f) (x : ℝ) :
    deriv (fun y => f y * gaussianPDFReal 0 1 y) x =
      deriv f x * gaussianPDFReal 0 1 x -
        x * f x * gaussianPDFReal 0 1 x := by
  show deriv (f * gaussianPDFReal 0 1) x =
    deriv f x * gaussianPDFReal 0 1 x - x * f x * gaussianPDFReal 0 1 x
  rw [deriv_mul (hf.differentiable (by decide) x)
    (hasDerivAt_gaussianPDFReal_zero_one x).differentiableAt,
    (hasDerivAt_gaussianPDFReal_zero_one x).deriv]
  ring

/-- Volume integrability of `deriv f * φ`. -/
theorem integrable_deriv_mul_gaussianPDFReal_zero_one {f : ℝ → ℝ}
    (hf : ContDiff ℝ 1 f) (hfc : HasCompactSupport f) :
    Integrable (fun x => deriv f x * gaussianPDFReal 0 1 x) volume := by
  have hcs : HasCompactSupport (fun x => deriv f x * gaussianPDFReal 0 1 x) :=
    (hasCompactSupport_deriv_of_hasCompactSupport hfc).mul_right
  exact ((hf.continuous_deriv le_rfl).mul
    continuous_gaussianPDFReal_zero_one).integrable_of_hasCompactSupport hcs

/-- Volume integrability of `x * f x * φ x`. -/
theorem integrable_id_mul_mul_gaussianPDFReal_zero_one {f : ℝ → ℝ}
    (hf : ContDiff ℝ 1 f) (hfc : HasCompactSupport f) :
    Integrable (fun x => x * f x * gaussianPDFReal 0 1 x) volume := by
  have hcs1 : HasCompactSupport (fun x => x * f x) := hfc.mul_left
  have hcs : HasCompactSupport (fun x => x * f x * gaussianPDFReal 0 1 x) :=
    hcs1.mul_right
  exact ((continuous_id'.mul hf.continuous).mul
    continuous_gaussianPDFReal_zero_one).integrable_of_hasCompactSupport hcs

/-- The derivative of `f * φ` integrates to zero over the real line: choose a
bounded interval containing the support, apply the fundamental theorem of
calculus, and note that `f * φ` vanishes at both endpoints. -/
theorem integral_deriv_mul_gaussianPDFReal_zero_one_eq_zero {f : ℝ → ℝ}
    (hf : ContDiff ℝ 1 f) (hfc : HasCompactSupport f) :
    ∫ x, deriv (fun y => f y * gaussianPDFReal 0 1 y) x = 0 := by
  have hfdiff : Differentiable ℝ f := hf.differentiable (by decide)
  have hφdiff : Differentiable ℝ (gaussianPDFReal 0 1) :=
    fun x => (hasDerivAt_gaussianPDFReal_zero_one x).differentiableAt
  have hfzero : ∀ x ∉ tsupport f, f x = 0 := by
    intro x hx
    by_contra hfx
    exact hx (subset_closure (Function.mem_support.mpr hfx))
  obtain ⟨C, hC⟩ := (IsCompact.isBounded hfc).exists_norm_le
  set B := |C| + 1 with hBdef
  have hBpos : 0 < B := by
    rw [hBdef]
    positivity
  have hsubIoo : tsupport f ⊆ Set.Ioo (-B) B := by
    intro x hx
    have hxC := hC x hx
    rw [Real.norm_eq_abs] at hxC
    have habs : |x| ≤ |C| := hxC.trans (le_abs_self C)
    obtain ⟨h1, h2⟩ := abs_le.mp habs
    exact ⟨by linarith, by linarith⟩
  have hgderiv : ∀ x, deriv (fun y => f y * gaussianPDFReal 0 1 y) x =
      deriv f x * gaussianPDFReal 0 1 x -
        x * f x * gaussianPDFReal 0 1 x :=
    deriv_mul_gaussianPDFReal_zero_one hf
  have hgcont : Continuous (deriv (fun y => f y * gaussianPDFReal 0 1 y)) := by
    have h : deriv (fun y => f y * gaussianPDFReal 0 1 y) =
        fun x => deriv f x * gaussianPDFReal 0 1 x -
          x * f x * gaussianPDFReal 0 1 x :=
      funext hgderiv
    rw [h]
    exact ((hf.continuous_deriv le_rfl).mul
      continuous_gaussianPDFReal_zero_one).sub
      ((continuous_id'.mul hf.continuous).mul
        continuous_gaussianPDFReal_zero_one)
  have hgzero_out : ∀ x ∉ Set.Icc (-B) B,
      deriv (fun y => f y * gaussianPDFReal 0 1 y) x = 0 := by
    intro x hx
    have hxf : x ∉ tsupport f := fun hxs =>
      hx (Set.Ioo_subset_Icc_self (hsubIoo hxs))
    rw [hgderiv x, deriv_eq_zero_of_notMem_tsupport hxf, hfzero x hxf]
    ring
  have hgB : f B * gaussianPDFReal 0 1 B = 0 ∧
      f (-B) * gaussianPDFReal 0 1 (-B) = 0 := by
    have hBabs : |B| = B := abs_of_pos hBpos
    have hBnot : B ∉ tsupport f ∧ (-B) ∉ tsupport f := by
      constructor
      · intro hxs
        have hxC := hC B hxs
        rw [Real.norm_eq_abs, hBabs, hBdef] at hxC
        have := le_abs_self C
        linarith
      · intro hxs
        have hxC := hC (-B) hxs
        rw [Real.norm_eq_abs, abs_neg, hBabs, hBdef] at hxC
        have := le_abs_self C
        linarith
    exact ⟨by rw [hfzero B hBnot.1, zero_mul],
      by rw [hfzero (-B) hBnot.2, zero_mul]⟩
  have h1 : ∫ x, deriv (fun y => f y * gaussianPDFReal 0 1 y) x =
      ∫ x in Set.Icc (-B) B, deriv (fun y => f y * gaussianPDFReal 0 1 y) x :=
    (setIntegral_eq_integral_of_forall_compl_eq_zero hgzero_out).symm
  have h2 : ∫ x in Set.Icc (-B) B,
        deriv (fun y => f y * gaussianPDFReal 0 1 y) x =
      ∫ x in (-B)..B, deriv (fun y => f y * gaussianPDFReal 0 1 y) x := by
    rw [intervalIntegral.integral_of_le (by linarith : -B ≤ B)]
    exact (setIntegral_congr_set (μ := volume) Ioc_ae_eq_Icc).symm
  have h3 : ∫ x in (-B)..B, deriv (fun y => f y * gaussianPDFReal 0 1 y) x =
      f B * gaussianPDFReal 0 1 B - f (-B) * gaussianPDFReal 0 1 (-B) :=
    intervalIntegral.integral_deriv_eq_sub
      (fun x _ => (hfdiff x).mul (hφdiff x))
      (hgcont.intervalIntegrable _ _)
  rw [h1, h2, h3, hgB.1, hgB.2, sub_zero]

/-- The derivative is integrable with respect to the standard Gaussian measure
for a compactly supported `C^1` test function. -/
theorem integrable_deriv_of_gaussianReal_zero_one {f : ℝ → ℝ}
    (hf : ContDiff ℝ 1 f) (hfc : HasCompactSupport f) :
    Integrable (deriv f) (gaussianReal 0 1) := by
  rw [gaussianReal_of_var_ne_zero 0 one_ne_zero]
  refine (integrable_withDensity_iff (measurable_gaussianPDF 0 1)
    (ae_of_all _ (fun _ => gaussianPDF_lt_top))).mpr ?_
  simpa only [toReal_gaussianPDF] using
    integrable_deriv_mul_gaussianPDFReal_zero_one hf hfc

/-- `x ↦ x * f x` is integrable with respect to the standard Gaussian measure
for a compactly supported `C^1` test function. -/
theorem integrable_id_mul_of_gaussianReal_zero_one {f : ℝ → ℝ}
    (hf : ContDiff ℝ 1 f) (hfc : HasCompactSupport f) :
    Integrable (fun x => x * f x) (gaussianReal 0 1) := by
  rw [gaussianReal_of_var_ne_zero 0 one_ne_zero]
  refine (integrable_withDensity_iff (measurable_gaussianPDF 0 1)
    (ae_of_all _ (fun _ => gaussianPDF_lt_top))).mpr ?_
  simpa only [toReal_gaussianPDF] using
    integrable_id_mul_mul_gaussianPDFReal_zero_one hf hfc

/-- Gaussian integration by parts / Stein identity on the standard Gaussian
measure: for a compactly supported `C^1` function `f`,

`∫ x, x * f x ∂(gaussianReal 0 1) = ∫ x, deriv f x ∂(gaussianReal 0 1)`.

Both sides are integrable (`integrable_id_mul_of_gaussianReal_zero_one`,
`integrable_deriv_of_gaussianReal_zero_one`). -/
theorem integral_id_mul_eq_integral_deriv_of_gaussianReal_zero_one {f : ℝ → ℝ}
    (hf : ContDiff ℝ 1 f) (hfc : HasCompactSupport f) :
    ∫ x, x * f x ∂(gaussianReal 0 1) =
      ∫ x, deriv f x ∂(gaussianReal 0 1) := by
  have hvol : ∫ x, deriv f x * gaussianPDFReal 0 1 x =
      ∫ x, x * f x * gaussianPDFReal 0 1 x := by
    have hzero := integral_deriv_mul_gaussianPDFReal_zero_one_eq_zero hf hfc
    rw [integral_congr_ae
        (ae_of_all _ (deriv_mul_gaussianPDFReal_zero_one hf)),
      MeasureTheory.integral_sub
        (integrable_deriv_mul_gaussianPDFReal_zero_one hf hfc)
        (integrable_id_mul_mul_gaussianPDFReal_zero_one hf hfc)] at hzero
    exact sub_eq_zero.mp hzero
  calc
    ∫ x, x * f x ∂(gaussianReal 0 1)
        = ∫ x, gaussianPDFReal 0 1 x • (x * f x) :=
      integral_gaussianReal_eq_integral_smul (f := fun x => x * f x) one_ne_zero
    _ = ∫ x, x * f x * gaussianPDFReal 0 1 x := by
      apply integral_congr_ae
      filter_upwards with x
      rw [smul_eq_mul]
      ring
    _ = ∫ x, deriv f x * gaussianPDFReal 0 1 x := hvol.symm
    _ = ∫ x, gaussianPDFReal 0 1 x • deriv f x := by
      apply integral_congr_ae
      filter_upwards with x
      rw [smul_eq_mul]
      ring
    _ = ∫ x, deriv f x ∂(gaussianReal 0 1) :=
      (integral_gaussianReal_eq_integral_smul (f := deriv f) one_ne_zero).symm

end

end HighDimProb
