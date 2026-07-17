import HighDimProb.Analysis.DenseSup

open HighDimProb

#check HighDimProb.ciSup_eq_ciSup_of_denseRange

example {α : Type*} [TopologicalSpace α]
    (u : ℕ → α) (hu : DenseRange u)
    (f : α → ℝ) (hf : Continuous f)
    (hfbdd : BddAbove (Set.range f)) :
    (⨆ x : α, f x) = ⨆ n : ℕ, f (u n) := by
  exact ciSup_eq_ciSup_of_denseRange u hu f hf hfbdd
