import HighDimProb.RandomMatrix

#check HighDimProb.matrixBernsteinStatement

#check
  (HighDimProb.matrixBernsteinStatement :
    {Omega : Type*} -> [MeasurableSpace Omega] ->
      {I : Type*} -> [Fintype I] -> {n : Nat} ->
        MeasureTheory.Measure Omega ->
          (I -> HighDimProb.RandomMatrix Omega n n) ->
            Real -> Real -> Real -> Real -> Prop)

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {n : Nat} (P : MeasureTheory.Measure Omega)
    (A : I -> HighDimProb.RandomMatrix Omega n n)
    (sigma2 R c t : Real) : Prop :=
  HighDimProb.matrixBernsteinStatement P A sigma2 R c t
