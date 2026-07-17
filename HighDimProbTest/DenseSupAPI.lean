import HighDimProb.Analysis.DenseSup

open HighDimProb

variable {α : Type*} [TopologicalSpace α]
variable (u : ℕ → α) (hu : DenseRange u) (f : α → ℝ)

#check ciSup_eq_ciSup_of_denseRange

example (hf : Continuous f)
    (hfbdd : BddAbove (Set.range f)) :
    (⨆ x : α, f x) = ⨆ n : ℕ, f (u n) :=
  ciSup_eq_ciSup_of_denseRange u hu f hf hfbdd

example {β : Type*} [TopologicalSpace β] {K : Set β}
    (v : ℕ → K) (hv : DenseRange v) (g : K → ℝ)
    (hg : Continuous g) (hgbdd : BddAbove (Set.range g)) :
    (⨆ x : K, g x) = ⨆ n : ℕ, g (v n) := by
  exact ciSup_eq_ciSup_of_denseRange v hv g hg hgbdd

example (hf : Continuous f) (hfbdd : BddAbove (Set.range f)) :
    (⨆ n : ℕ, f (u n)) = ⨆ x : α, f x := by
  symm
  exact ciSup_eq_ciSup_of_denseRange u hu f hf hfbdd
