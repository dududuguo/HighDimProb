import HighDimProb.Analysis.Softmax

open scoped BigOperators

#check @HighDimProb.expNormalized
#check @HighDimProb.expNormalized_pos
#check @HighDimProb.expNormalized_nonneg
#check @HighDimProb.expNormalized_sum
#check @HighDimProb.expNormalized_le_one
#check @HighDimProb.expNormalized_sq_sum_le_one
#check @HighDimProb.expNormalized_shift_invariant
#check @HighDimProb.measurable_expNormalized
#check @HighDimProb.measurable_expNormalized_coord

/-- Exponential (Gibbs) normalization is a probability vector with sub-unit
squared norm. -/
example {ι : Type*} [Fintype ι] [Nonempty ι] (tau : Real) (z : ι → Real) :
    (∀ i, 0 < HighDimProb.expNormalized tau z i) ∧
      (∑ i, HighDimProb.expNormalized tau z i = 1) ∧
      (∑ i, HighDimProb.expNormalized tau z i ^ 2 ≤ 1) :=
  ⟨fun i => HighDimProb.expNormalized_pos tau z i, HighDimProb.expNormalized_sum tau z,
    HighDimProb.expNormalized_sq_sum_le_one tau z⟩
