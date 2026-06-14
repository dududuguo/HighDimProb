import HighDimProb.RandomMatrix

open MeasureTheory
open scoped Matrix.Norms.L2Operator

#check HighDimProb.isRealRandomVariable_operatorNorm
#check HighDimProb.deterministicOperatorNorm_sub_le_add
#check HighDimProb.rankOneOperatorNorm_le_vectorSqNorm
#check HighDimProb.matrixExpect_eq_integral_l2Operator
#check HighDimProb.matrixExpect_eq_integral
#check HighDimProb.deterministicOperatorNorm_matrixExpect_le_of_boundedOperatorNorm
#check HighDimProb.expectationOperatorNormBound_of_pointwiseOperatorNormBound
#check HighDimProb.rankOneRandomMatrixFamily
#check HighDimProb.centeredRankOneRandomMatrix
#check HighDimProb.centeredRankOneRandomMatrixFamily
#check HighDimProb.BoundedOperatorNorm_rankOneRandomMatrix_of_sqNorm_bound
#check HighDimProb.PointwiseOperatorNormBound_rankOneRandomMatrix_of_sqNorm_bound
#check HighDimProb.BoundedOperatorNorm_centered_of_bound_expect_bound
#check HighDimProb.PointwiseOperatorNormBound_centered_of_bound_expect_bound
#check HighDimProb.PointwiseOperatorNormBound_centered_of_bound_expect_bound_same
#check HighDimProb.BoundedOperatorNorm_centered_of_boundedOperatorNorm
#check HighDimProb.PointwiseOperatorNormBound_centered_of_pointwiseOperatorNormBound
#check HighDimProb.PointwiseOperatorNormBound_centered_of_pointwiseOperatorNormBound_same
#check HighDimProb.BoundedOperatorNorm_centeredRankOneRandomMatrix_of_sqNorm_bound
#check HighDimProb.PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound

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
      (HighDimProb.rankOneMatrix v) <= HighDimProb.vectorSqNorm v := by
  exact HighDimProb.rankOneOperatorNorm_le_vectorSqNorm v

example {m n : Nat} (A B : Matrix (Fin m) (Fin n) Real) :
    HighDimProb.deterministicOperatorNorm (A - B) <=
      HighDimProb.deterministicOperatorNorm A + HighDimProb.deterministicOperatorNorm B := by
  exact HighDimProb.deterministicOperatorNorm_sub_le_add A B

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {m n : Nat} {A : HighDimProb.RandomMatrix Omega m n} {R : Real}
    (hMeas : HighDimProb.IsRandomMatrix P A)
    (hInt : HighDimProb.IntegrableRandomMatrix P A)
    (hBound : HighDimProb.BoundedOperatorNorm A R)
    (hR : 0 <= R) :
    HighDimProb.deterministicOperatorNorm (HighDimProb.matrixExpect P A) <= R := by
  exact HighDimProb.deterministicOperatorNorm_matrixExpect_le_of_boundedOperatorNorm
    hMeas hInt hBound hR

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat}
    {A : HighDimProb.RandomMatrix Omega m n}
    (hA : HighDimProb.IntegrableRandomMatrix P A) :
    HighDimProb.matrixExpect P A = ∫ omega, A omega ∂P := by
  exact HighDimProb.matrixExpect_eq_integral hA

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {I : Type*} {m n : Nat}
    {A : I -> HighDimProb.RandomMatrix Omega m n} {R : Real}
    (hMeas : forall i, HighDimProb.IsRandomMatrix P (A i))
    (hInt : forall i, HighDimProb.IntegrableRandomMatrix P (A i))
    (hBound : HighDimProb.PointwiseOperatorNormBound A R)
    (hR : 0 <= R) :
    forall i, HighDimProb.deterministicOperatorNorm
      (HighDimProb.matrixExpect P (A i)) <= R := by
  exact HighDimProb.expectationOperatorNormBound_of_pointwiseOperatorNormBound
    hMeas hInt hBound hR

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {I : Type*} {m n : Nat}
    {A : I -> HighDimProb.RandomMatrix Omega m n} {R : Real}
    (hMeas : forall i, HighDimProb.IsRandomMatrix P (A i))
    (hInt : forall i, HighDimProb.IntegrableRandomMatrix P (A i))
    (hBound : HighDimProb.PointwiseOperatorNormBound A R)
    (hR : 0 <= R) :
    HighDimProb.PointwiseOperatorNormBound
      (HighDimProb.centeredRandomMatrixFamily P A) (2 * R) := by
  exact HighDimProb.PointwiseOperatorNormBound_centered_of_pointwiseOperatorNormBound
    hMeas hInt hBound hR

example {Omega : Type*} [MeasurableSpace Omega] {I : Type*} {n : Nat}
    (X : I -> Omega -> Fin n -> Real) (R : Real)
    (hX : forall i omega, HighDimProb.vectorSqNorm (X i omega) <= R) :
    HighDimProb.PointwiseOperatorNormBound
      (HighDimProb.rankOneRandomMatrixFamily X) R := by
  exact HighDimProb.PointwiseOperatorNormBound_rankOneRandomMatrix_of_sqNorm_bound X R hX

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    {X : HighDimProb.RandomVector Omega n} {R : Real}
    (hMeas : HighDimProb.IsRandomVector P X)
    (hLp : forall j : Fin n,
      HighDimProb.MemLpRealRandomVariable P (HighDimProb.coord X j) 2)
    (hSq : forall omega, HighDimProb.vectorSqNorm (X omega) <= R)
    (hR : 0 <= R) :
    HighDimProb.BoundedOperatorNorm
      (HighDimProb.centeredRankOneRandomMatrix P X) (2 * R) := by
  exact HighDimProb.BoundedOperatorNorm_centeredRankOneRandomMatrix_of_sqNorm_bound
    hMeas hLp hSq hR

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {I : Type*} {n : Nat}
    {X : I -> HighDimProb.RandomVector Omega n} {R : Real}
    (hMeas : forall i, HighDimProb.IsRandomVector P (X i))
    (hLp : forall i, forall j : Fin n,
      HighDimProb.MemLpRealRandomVariable P (HighDimProb.coord (X i) j) 2)
    (hSq : forall i omega, HighDimProb.vectorSqNorm (X i omega) <= R)
    (hR : 0 <= R) :
    HighDimProb.PointwiseOperatorNormBound
      (HighDimProb.centeredRankOneRandomMatrixFamily P X) (2 * R) := by
  exact
    HighDimProb.PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound
      hMeas hLp hSq hR

example {Omega : Type*} [MeasurableSpace Omega] {I : Type*} {m n : Nat}
    (P : MeasureTheory.Measure Omega) (X : I -> HighDimProb.RandomMatrix Omega m n)
    (R Rexp : Real)
    (hX : HighDimProb.PointwiseOperatorNormBound X R)
    (hExp : forall i,
      HighDimProb.deterministicOperatorNorm (HighDimProb.matrixExpect P (X i)) <= Rexp) :
    HighDimProb.PointwiseOperatorNormBound
      (HighDimProb.centeredRandomMatrixFamily P X) (R + Rexp) := by
  exact HighDimProb.PointwiseOperatorNormBound_centered_of_bound_expect_bound
    P X R Rexp hX hExp
