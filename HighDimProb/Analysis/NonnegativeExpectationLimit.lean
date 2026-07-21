import Mathlib.MeasureTheory.Function.L1Space.Integrable
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Integral.Lebesgue.Add

set_option autoImplicit false

namespace HighDimProb

open Filter MeasureTheory Topology
open scoped ENNReal

/-
The proof is organized around the nonnegative `ENNReal` integral.  This keeps
Fatou's lemma separate from the Bochner integral convention that returns zero
for a nonintegrable function.
-/
private theorem lintegral_limit_le_of_ae_tendsto_of_liminf_bound
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {g : Nat -> Omega -> ENNReal} {gLimit : Omega -> ENNReal} {B : ENNReal}
    (hMeas : forall n, AEMeasurable (g n) P)
    (hTendsto : ∀ᵐ omega ∂P,
      Tendsto (fun n => g n omega) atTop (𝓝 (gLimit omega)))
    (hLiminfBound :
      liminf (fun n => ∫⁻ omega, g n omega ∂P) atTop <= B) :
    (∫⁻ omega, gLimit omega ∂P) <= B := by
  have hLiminf : ∀ᵐ omega ∂P,
      liminf (fun n => g n omega) atTop = gLimit omega := by
    filter_upwards [hTendsto] with omega hOmega
    exact hOmega.liminf_eq
  calc
    (∫⁻ omega, gLimit omega ∂P) =
        ∫⁻ omega, liminf (fun n => g n omega) atTop ∂P := by
      apply lintegral_congr_ae
      filter_upwards [hLiminf] with omega hOmega
      exact hOmega.symm
    _ <= liminf (fun n => ∫⁻ omega, g n omega ∂P) atTop :=
      lintegral_liminf_le' hMeas
    _ <= B := hLiminfBound

private theorem integrable_and_integral_le_of_nonnegative_of_lintegral_le
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {fLimit : Omega -> Real} {C : Real}
    (hLimitMeas : Measurable fLimit)
    (hLimitNonneg : 0 ≤ᵐ[P] fLimit)
    (hC : 0 <= C)
    (hLIntegralBound :
      (∫⁻ omega, ENNReal.ofReal (fLimit omega) ∂P) <= ENNReal.ofReal C) :
    Integrable fLimit P ∧ (∫ omega, fLimit omega ∂P) <= C := by
  have hLIntegralFinite :
      (∫⁻ omega, ENNReal.ofReal (fLimit omega) ∂P) ≠ ∞ :=
    ne_top_of_le_ne_top ENNReal.ofReal_ne_top hLIntegralBound
  have hLimitInt : Integrable fLimit P :=
    (lintegral_ofReal_ne_top_iff_integrable
      hLimitMeas.aestronglyMeasurable hLimitNonneg).mp hLIntegralFinite
  have hIntegralBound :
      ENNReal.ofReal (∫ omega, fLimit omega ∂P) <= ENNReal.ofReal C := by
    rw [ofReal_integral_eq_lintegral_ofReal hLimitInt hLimitNonneg]
    exact hLIntegralBound
  refine ⟨hLimitInt, ?_⟩
  exact (ENNReal.ofReal_le_ofReal_iff
    (p := ∫ omega, fLimit omega ∂P) (q := C) hC).mp hIntegralBound

/--
If measurable nonnegative real-valued functions converge almost everywhere to
a measurable nonnegative limit and their integrals are bounded by a finite
nonnegative constant, then the limit is integrable and has integral at most
that constant.

The proof applies Fatou to `ENNReal.ofReal (f n omega)`.  The limit function is
shown integrable from the resulting finite lintegral before its Bochner
integral is used.
-/
theorem integrable_of_ae_tendsto_of_nonneg_of_integral_le
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {f : Nat -> Omega -> Real} {fLimit : Omega -> Real} {C : Real}
    (hMeas : forall n, Measurable (f n))
    (hLimitMeas : Measurable fLimit)
    (hNonneg : forall n, 0 ≤ᵐ[P] f n)
    (hLimitNonneg : 0 ≤ᵐ[P] fLimit)
    (hTendsto : ∀ᵐ omega ∂P,
      Tendsto (fun n => f n omega) atTop (𝓝 (fLimit omega)))
    (hIntegrable : forall n, Integrable (f n) P)
    (hC : 0 <= C)
    (hBound : forall n, (∫ omega, f n omega ∂P) <= C) :
    Integrable fLimit P ∧ (∫ omega, fLimit omega ∂P) <= C := by
  let g : Nat -> Omega -> ENNReal := fun n omega => ENNReal.ofReal (f n omega)
  have hGMeas : forall n, AEMeasurable (g n) P := by
    intro n
    simpa [g] using (hMeas n).aemeasurable.ennreal_ofReal
  have hGTendsto : ∀ᵐ omega ∂P,
      Tendsto (fun n => g n omega) atTop
        (𝓝 (ENNReal.ofReal (fLimit omega))) := by
    filter_upwards [hTendsto] with omega hOmega
    exact (ENNReal.continuous_ofReal.tendsto _).comp hOmega
  have hGBound : forall n, (∫⁻ omega, g n omega ∂P) <= ENNReal.ofReal C := by
    intro n
    calc
      (∫⁻ omega, g n omega ∂P) =
          ENNReal.ofReal (∫ omega, f n omega ∂P) := by
        simpa [g] using
          (ofReal_integral_eq_lintegral_ofReal
            (hIntegrable n) (hNonneg n)).symm
      _ <= ENNReal.ofReal C :=
        (ENNReal.ofReal_le_ofReal_iff
          (p := ∫ omega, f n omega ∂P) (q := C) hC).mpr (hBound n)
  have hLiminfBound :
      liminf (fun n => ∫⁻ omega, g n omega ∂P) atTop <= ENNReal.ofReal C := by
    calc
      liminf (fun n => ∫⁻ omega, g n omega ∂P) atTop <=
          liminf (fun _ : Nat => ENNReal.ofReal C) atTop :=
        Filter.liminf_le_liminf (Filter.Eventually.of_forall hGBound)
      _ = ENNReal.ofReal C := Filter.liminf_const _
  have hLIntegralBound :
      (∫⁻ omega, ENNReal.ofReal (fLimit omega) ∂P) <= ENNReal.ofReal C :=
    lintegral_limit_le_of_ae_tendsto_of_liminf_bound
      hGMeas hGTendsto hLiminfBound
  exact integrable_and_integral_le_of_nonnegative_of_lintegral_le
    hLimitMeas hLimitNonneg hC hLIntegralBound

/-- Pointwise-convergence wrapper for `integrable_of_ae_tendsto_of_nonneg_of_integral_le`. -/
theorem integrable_of_tendsto_of_nonneg_of_integral_le
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {f : Nat -> Omega -> Real} {fLimit : Omega -> Real} {C : Real}
    (hMeas : forall n, Measurable (f n))
    (hLimitMeas : Measurable fLimit)
    (hNonneg : forall n omega, 0 <= f n omega)
    (hLimitNonneg : forall omega, 0 <= fLimit omega)
    (hTendsto : forall omega,
      Tendsto (fun n => f n omega) atTop (𝓝 (fLimit omega)))
    (hIntegrable : forall n, Integrable (f n) P)
    (hC : 0 <= C)
    (hBound : forall n, (∫ omega, f n omega ∂P) <= C) :
    Integrable fLimit P ∧ (∫ omega, fLimit omega ∂P) <= C := by
  exact integrable_of_ae_tendsto_of_nonneg_of_integral_le
    hMeas hLimitMeas
    (fun n => ae_of_all P (hNonneg n))
    (ae_of_all P hLimitNonneg)
    (ae_of_all P hTendsto)
    hIntegrable hC hBound

/--
Moving-bound version: the real integral of `f n` is bounded by `CSeq n`, and
the finite nonnegative bounds converge to `C`.
-/
theorem integrable_of_ae_tendsto_of_nonneg_of_integral_bound_tendsto
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {f : Nat -> Omega -> Real} {fLimit : Omega -> Real}
    {CSeq : Nat -> Real} {C : Real}
    (hMeas : forall n, Measurable (f n))
    (hLimitMeas : Measurable fLimit)
    (hNonneg : forall n, 0 ≤ᵐ[P] f n)
    (hLimitNonneg : 0 ≤ᵐ[P] fLimit)
    (hTendsto : ∀ᵐ omega ∂P,
      Tendsto (fun n => f n omega) atTop (𝓝 (fLimit omega)))
    (hIntegrable : forall n, Integrable (f n) P)
    (hCSeqNonneg : forall n, 0 <= CSeq n)
    (hCSeqTendsto : Tendsto CSeq atTop (𝓝 C))
    (hBound : forall n, (∫ omega, f n omega ∂P) <= CSeq n)
    (hC : 0 <= C) :
    Integrable fLimit P ∧ (∫ omega, fLimit omega ∂P) <= C := by
  let g : Nat -> Omega -> ENNReal := fun n omega => ENNReal.ofReal (f n omega)
  have hGMeas : forall n, AEMeasurable (g n) P := by
    intro n
    simpa [g] using (hMeas n).aemeasurable.ennreal_ofReal
  have hGTendsto : ∀ᵐ omega ∂P,
      Tendsto (fun n => g n omega) atTop
        (𝓝 (ENNReal.ofReal (fLimit omega))) := by
    filter_upwards [hTendsto] with omega hOmega
    exact (ENNReal.continuous_ofReal.tendsto _).comp hOmega
  have hGBound :
      forall n, (∫⁻ omega, g n omega ∂P) <= ENNReal.ofReal (CSeq n) := by
    intro n
    calc
      (∫⁻ omega, g n omega ∂P) =
          ENNReal.ofReal (∫ omega, f n omega ∂P) := by
        simpa [g] using
          (ofReal_integral_eq_lintegral_ofReal
            (hIntegrable n) (hNonneg n)).symm
      _ <= ENNReal.ofReal (CSeq n) :=
        (ENNReal.ofReal_le_ofReal_iff
          (p := ∫ omega, f n omega ∂P) (q := CSeq n)
          (hCSeqNonneg n)).mpr (hBound n)
  have hLiminfBound :
      liminf (fun n => ∫⁻ omega, g n omega ∂P) atTop <= ENNReal.ofReal C := by
    calc
      liminf (fun n => ∫⁻ omega, g n omega ∂P) atTop <=
          liminf (fun n => ENNReal.ofReal (CSeq n)) atTop :=
        Filter.liminf_le_liminf (Filter.Eventually.of_forall hGBound)
      _ = ENNReal.ofReal C := by
        exact ((ENNReal.continuous_ofReal.tendsto _).comp hCSeqTendsto).liminf_eq
  have hLIntegralBound :
      (∫⁻ omega, ENNReal.ofReal (fLimit omega) ∂P) <= ENNReal.ofReal C :=
    lintegral_limit_le_of_ae_tendsto_of_liminf_bound
      hGMeas hGTendsto hLiminfBound
  exact integrable_and_integral_le_of_nonnegative_of_lintegral_le
    hLimitMeas hLimitNonneg hC hLIntegralBound

end HighDimProb
