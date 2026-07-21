import HighDimProb.Analysis.Softmax

open HighDimProb
open scoped BigOperators

#check @HighDimProb.expNormalized
#check @HighDimProb.expNormalized_pos
#check @HighDimProb.expNormalized_sum
#check @HighDimProb.expNormalized_le_one
#check @HighDimProb.expNormalized_sq_sum_le_one
#check @HighDimProb.expNormalized_shift_invariant
#check @HighDimProb.measurable_expNormalized

/-- External-user view: exponential (Gibbs) normalization outputs a probability
vector (positive, summing to one) with squared norm at most one, and is a
measurable map of the scores. Softmax attention weights are this object at a
positive temperature (see the Attention example). -/
example {ι : Type*} [Fintype ι] [Nonempty ι] (tau : Real) (z : ι → Real) :
    (∀ i, 0 < expNormalized tau z i) ∧ (∑ i, expNormalized tau z i = 1) ∧
      (∑ i, expNormalized tau z i ^ 2 ≤ 1) :=
  ⟨fun i => expNormalized_pos tau z i, expNormalized_sum tau z,
    expNormalized_sq_sum_le_one tau z⟩
