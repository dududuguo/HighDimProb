import HighDimProb.RandomMatrix.Statements

open HighDimProb

#check epsilonNetOperatorNormStatement

variable {n : Nat}
variable (A : Matrix (Fin n) (Fin n) Real)
variable (N : Set (Fin n -> Real))
variable (eps C : Real)

#check (epsilonNetOperatorNormStatement A N eps C : Prop)
