import HighDimProb.RandomMatrix

#check HighDimProb.isRealRandomVariable_operatorNorm
#check HighDimProb.deterministicOperatorNorm_sub_le_add
#check HighDimProb.rankOneOperatorNorm_le_vectorSqNorm
#check HighDimProb.BoundedOperatorNorm_rankOne_of_sqNorm_bound
#check HighDimProb.PointwiseOperatorNormBound_rankOne_of_sqNorm_bound
#check HighDimProb.BoundedOperatorNorm_centered_of_bound_expect_bound
#check HighDimProb.PointwiseOperatorNormBound_centered_of_bound_expect_bound
#check HighDimProb.PointwiseOperatorNormBound_centered_of_bound_expect_bound_same

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

example {m n : Nat} (A B : Matrix (Fin m) (Fin n) Real) :
    HighDimProb.deterministicOperatorNorm (A - B) <=
      HighDimProb.deterministicOperatorNorm A + HighDimProb.deterministicOperatorNorm B := by
  exact HighDimProb.deterministicOperatorNorm_sub_le_add A B

example {Omega : Type*} [MeasurableSpace Omega] {I : Type*} {n : Nat}
    (X : I -> Omega -> Fin n -> Real) (R : Real)
    (hR : 0 <= R)
    (hX : forall i omega, HighDimProb.vectorSqNorm (X i omega) <= R) :
    HighDimProb.PointwiseOperatorNormBound
      (fun i omega a b => X i omega a * X i omega b) R := by
  exact HighDimProb.PointwiseOperatorNormBound_rankOne_of_sqNorm_bound X R hR hX

example {Omega : Type*} [MeasurableSpace Omega] {I : Type*} {m n : Nat}
    (P : MeasureTheory.Measure Omega) (X : I -> HighDimProb.RandomMatrix Omega m n)
    (R Rexp : Real)
    (hX : HighDimProb.PointwiseOperatorNormBound X R)
    (hExp : forall i,
      HighDimProb.deterministicOperatorNorm (HighDimProb.matrixExpect P (X i)) <= Rexp) :
    HighDimProb.PointwiseOperatorNormBound
      (fun i => HighDimProb.centeredRandomMatrix P (X i)) (R + Rexp) := by
  exact HighDimProb.PointwiseOperatorNormBound_centered_of_bound_expect_bound
    P X R Rexp hX hExp
