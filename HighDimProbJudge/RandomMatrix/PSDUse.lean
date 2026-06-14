import HighDimProb.RandomMatrix

#check HighDimProb.IsPSDMatrix
#check HighDimProb.RandomPSDMatrix
#check HighDimProb.MatrixLE
#check HighDimProb.matrixQuadraticForm
#check HighDimProb.matrixQuadraticForm_apply
#check HighDimProb.isPSDMatrix_rankOneMatrix
#check HighDimProb.randomPSDMatrix_rankOneRandomMatrix
#check HighDimProb.quadraticForm_le_of_matrixLE
#check HighDimProb.quadraticForm_apply_le_of_matrixLE

example {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hAB : HighDimProb.MatrixLE A B) (x : Fin n -> Real) :
    HighDimProb.matrixQuadraticForm A x <=
      HighDimProb.matrixQuadraticForm B x := by
  exact HighDimProb.quadraticForm_le_of_matrixLE hAB x

example {n : Nat} (x : Fin n -> Real) :
    HighDimProb.IsPSDMatrix (HighDimProb.rankOneMatrix x) := by
  exact HighDimProb.isPSDMatrix_rankOneMatrix x

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} {n : Nat}
    (X : HighDimProb.RandomVector Omega n) :
    HighDimProb.RandomPSDMatrix P (HighDimProb.rankOneRandomMatrix X) := by
  exact HighDimProb.randomPSDMatrix_rankOneRandomMatrix X
