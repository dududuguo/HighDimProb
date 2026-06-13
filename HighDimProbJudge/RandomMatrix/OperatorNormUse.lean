import HighDimProb.RandomMatrix

#check HighDimProb.isRealRandomVariable_operatorNorm
#check HighDimProb.rankOneOperatorNorm_le_vectorSqNorm
#check HighDimProb.BoundedOperatorNorm_rankOne_of_sqNorm_bound
#check HighDimProb.PointwiseOperatorNormBound_rankOne_of_sqNorm_bound

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

example {n : Nat} (v : Fin n -> Real) :
    HighDimProb.deterministicOperatorNorm
      (fun i j : Fin n => v i * v j) <= HighDimProb.vectorSqNorm v := by
  exact HighDimProb.rankOneOperatorNorm_le_vectorSqNorm v

example {Omega : Type*} [MeasurableSpace Omega] {I : Type*} {n : Nat}
    (X : I -> Omega -> Fin n -> Real) (R : Real)
    (hR : 0 <= R)
    (hX : forall i omega, HighDimProb.vectorSqNorm (X i omega) <= R) :
    HighDimProb.PointwiseOperatorNormBound
      (fun i omega a b => X i omega a * X i omega b) R := by
  exact HighDimProb.PointwiseOperatorNormBound_rankOne_of_sqNorm_bound X R hR hX
