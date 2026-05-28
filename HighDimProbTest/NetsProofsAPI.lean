import HighDimProb.Nets

open HighDimProb

variable {alpha : Type*} [PseudoMetricSpace alpha]
variable (K N : Set alpha)
variable (eps : Real)

#check MaximalEpsilonSeparatedIn
#check isInternalEpsilonNet_of_maximalEpsilonSeparatedIn

#check (MaximalEpsilonSeparatedIn K N eps : Prop)
