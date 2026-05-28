import HighDimProb.Experimental

open HighDimProb

variable {alpha : Type*} [PseudoMetricSpace alpha]
variable (K N : Set alpha)
variable (eps : Real)

#check maximalSeparatedNetStatement
#check epsilonNetCoveringNumberStatement
#check packingCoveringInequalityStatement

#check (maximalSeparatedNetStatement K N eps : Prop)
#check (epsilonNetCoveringNumberStatement K N eps : Prop)
#check (packingCoveringInequalityStatement K eps : Prop)
