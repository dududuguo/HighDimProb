import Mathlib.Analysis.Convex.Continuous
import Mathlib.Analysis.Convex.Integral

/-!
# Open-domain Jensen

This module upgrades Mathlib's closed-domain integral Jensen inequality to the
case of a concave function on an open convex set, provided the Bochner mean is
known to stay in the domain.
-/

noncomputable section

open MeasureTheory Set
open scoped Topology

section ClosureHypograph

variable {E : Type*} [TopologicalSpace E]
variable {s : Set E} {g : E → Real}

private theorem le_of_mem_closure_hypograph_of_isOpen
    (hgc : ContinuousOn g s) (hsOpen : IsOpen s)
    {x : E} (hx : x ∈ s) {r : Real}
    (hr : (x, r) ∈ closure {p : E × Real | p.1 ∈ s ∧ p.2 ≤ g p.1}) :
    r ≤ g x := by
  let hypograph : Set (E × Real) := {p | p.1 ∈ s ∧ p.2 ≤ g p.1}
  let strictEpigraph : Set (E × Real) := {p | p.1 ∈ s ∧ g p.1 < p.2}
  by_contra hle
  have hxr : (x, r) ∈ strictEpigraph := by
    exact ⟨hx, lt_of_not_ge hle⟩
  have hmap :
      ContinuousOn (fun p : E × Real => (g p.1, p.2)) (s ×ˢ (Set.univ : Set Real)) :=
    hgc.prodMap continuousOn_id
  have hOpenStrict : IsOpen strictEpigraph := by
    have :
        IsOpen
          ((s ×ˢ (Set.univ : Set Real)) ∩
            (fun p : E × Real => (g p.1, p.2)) ⁻¹'
              {q : Real × Real | q.1 < q.2}) :=
      hmap.isOpen_inter_preimage (hsOpen.prod isOpen_univ)
        (isOpen_lt continuous_fst continuous_snd)
    simpa [strictEpigraph, Set.prod_eq] using this
  rcases mem_closure_iff_nhds.mp hr strictEpigraph (hOpenStrict.mem_nhds hxr) with
    ⟨p, hpStrict, hpHypo⟩
  exact (not_lt_of_ge hpHypo.2) hpStrict.2

end ClosureHypograph

variable {α E : Type*}
variable [MeasurableSpace α]
variable [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
variable [FiniteDimensional ℝ E]
variable {μ : Measure α} [IsProbabilityMeasure μ]
variable {s : Set E} {f : α → E} {g : E → Real}

namespace ConcaveOn

/-- Integral Jensen for a concave function on a convex open domain.

Mathlib already provides `ConcaveOn.le_map_integral` for convex closed domains.
This wrapper uses the convex hypograph together with continuity on open convex
sets to remove the closedness assumption, replacing it with an explicit
hypothesis that the Bochner mean stays in the domain.
-/
theorem le_map_integral_of_mem_open
    (hg : ConcaveOn ℝ s g) (hsOpen : IsOpen s)
    (hfs : ∀ᵐ x ∂μ, f x ∈ s) (hfi : Integrable f μ) (hgi : Integrable (g ∘ f) μ)
    (hmean : ∫ x, f x ∂μ ∈ s) :
    ∫ x, g (f x) ∂μ ≤ g (∫ x, f x ∂μ) := by
  let hypograph : Set (E × Real) := {p | p.1 ∈ s ∧ p.2 ≤ g p.1}
  have hmem :
      ∀ᵐ x ∂μ, (f x, g (f x)) ∈ hypograph := by
    filter_upwards [hfs] with x hx
    exact ⟨hx, le_rfl⟩
  have hpairInt : Integrable (fun x => (f x, g (f x))) μ :=
    hfi.prodMk <| by simpa [Function.comp] using hgi
  have hpairClosure :
      ∫ x, (f x, g (f x)) ∂μ ∈ closure hypograph := by
    exact hg.convex_hypograph.closure.integral_mem isClosed_closure
      (hmem.mono fun _ hx => subset_closure hx) hpairInt
  have hpair :
      (∫ x, f x ∂μ, ∫ x, g (f x) ∂μ) ∈ closure hypograph := by
    rw [integral_pair hfi (by simpa [Function.comp] using hgi)] at hpairClosure
    exact hpairClosure
  exact le_of_mem_closure_hypograph_of_isOpen
    (s := s) (g := g) (hg.continuousOn hsOpen) hsOpen hmean hpair

end ConcaveOn
