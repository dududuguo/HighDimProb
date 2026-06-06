import HighDimProb.RandomMatrix

#check HighDimProb.isRealRandomVariable_operatorNorm

#check
  (HighDimProb.isRealRandomVariable_operatorNorm :
    {Omega : Type*} -> [MeasurableSpace Omega] ->
      {P : MeasureTheory.Measure Omega} -> {m n : Nat} ->
        {A : HighDimProb.RandomMatrix Omega m n} ->
          HighDimProb.IsRandomMatrix P A ->
            HighDimProb.IsRealRandomVariable P (HighDimProb.operatorNorm A))

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} {m n : Nat}
    {A : HighDimProb.RandomMatrix Omega m n}
    (hA : HighDimProb.IsRandomMatrix P A) :
    HighDimProb.IsRealRandomVariable P (HighDimProb.operatorNorm A) := by
  exact HighDimProb.isRealRandomVariable_operatorNorm hA
