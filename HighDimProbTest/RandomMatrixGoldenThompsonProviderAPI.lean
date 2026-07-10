import HighDimProb.RandomMatrix.LiebProvider

open HighDimProb
open scoped MatrixOrder Matrix.Norms.Operator RightActions

#check CFCLog.lineDeriv_one_zero
#check goldenThompsonTraceExp

example {n : Nat} (A B : Matrix (Fin n) (Fin n) Real) :
    goldenThompsonTraceExp_statement A B :=
  goldenThompsonTraceExp A B