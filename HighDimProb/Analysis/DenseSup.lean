import Mathlib.Topology.Order.IsLUB
import Mathlib.Topology.Instances.Real.Lemmas

set_option autoImplicit false

namespace HighDimProb

/-!
# Supremum over a dense sequence

This module packages the standard dense-subset supremum theorem for a sequence.
-/

/-- A continuous real-valued function has the same supremum on a dense sequence
as on the whole domain, provided its range is bounded above. -/
theorem ciSup_eq_ciSup_of_denseRange
    {α : Type*} [TopologicalSpace α]
    (u : ℕ → α) (hu : DenseRange u)
    (f : α → ℝ) (hf : Continuous f)
    (hfbdd : BddAbove (Set.range f)) :
    (⨆ x : α, f x) = ⨆ n : ℕ, f (u n) := by
  calc
    (⨆ x : α, f x) = ⨆ s : Set.range u, f s :=
      (Dense.ciSup hu hf hfbdd).symm
    _ = ⨆ n : ℕ, f (u n) :=
      iSup_range' f u

end HighDimProb
