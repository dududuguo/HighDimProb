import HighDimProb.RandomMatrix.LiebProvider

#check HighDimProb.CFCLog.lineDeriv_one_zero
#check HighDimProb.goldenThompsonTraceExp

example {n : Nat} (A B : Matrix (Fin n) (Fin n) Real) :
    HighDimProb.goldenThompsonTraceExp_statement A B :=
  HighDimProb.goldenThompsonTraceExp A B