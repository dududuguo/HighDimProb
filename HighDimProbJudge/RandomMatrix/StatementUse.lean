import HighDimProb.RandomMatrix

#check HighDimProb.matrixBernsteinStatement
#check HighDimProb.matrixBernsteinTraceMGF_statement
#check HighDimProb.matrixBernsteinTraceMGFWithBernsteinCoeff_statement
#check HighDimProb.matrixBernsteinTraceMGFWithBernsteinCoeff_of_troppMasterTraceMGFFiniteFamily

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

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {n : Nat} (P : MeasureTheory.Measure Omega)
    (A : I -> HighDimProb.RandomMatrix Omega n n)
    (theta : Real) : Prop :=
  HighDimProb.matrixBernsteinTraceMGF_statement P A theta

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {n : Nat} (P : MeasureTheory.Measure Omega)
    (A : I -> HighDimProb.RandomMatrix Omega n n)
    (theta R : Real) : Prop :=
  HighDimProb.matrixBernsteinTraceMGFWithBernsteinCoeff_statement P A theta R
