import HighDimProb.RandomMatrix

#check HighDimProb.isRandomMatrix_centeredRandomMatrix
#check HighDimProb.integrableRandomMatrix_centeredRandomMatrix
#check HighDimProb.isSelfAdjointMatrix_matrixExpect_of_randomSelfAdjoint
#check HighDimProb.randomSelfAdjointMatrix_centeredRandomMatrix
#check HighDimProb.matrixExpect_centeredRandomMatrix
#check HighDimProb.selfAdjointRandomMatrixFamily_centeredRandomMatrixFamily
#check HighDimProb.centeredSelfAdjointRandomMatrixFamily_centeredRandomMatrixFamily
#check HighDimProb.rankOneRandomMatrixFamily
#check HighDimProb.centeredRankOneRandomMatrix
#check HighDimProb.centeredRankOneRandomMatrixFamily
#check HighDimProb.isSelfAdjointMatrix_rankOneMatrix
#check HighDimProb.randomSelfAdjointMatrix_rankOneRandomMatrix
#check HighDimProb.centeredRankOneRandomMatrix_isRandomMatrix
#check HighDimProb.centeredRankOneRandomMatrix_integrable_of_memLp_two
#check HighDimProb.centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two

#check
  (HighDimProb.isRandomMatrix_centeredRandomMatrix :
    {Omega : Type*} -> [MeasurableSpace Omega] ->
      {P : MeasureTheory.Measure Omega} -> {m n : Nat} ->
        {A : HighDimProb.RandomMatrix Omega m n} ->
          HighDimProb.IsRandomMatrix P A ->
            HighDimProb.IsRandomMatrix P
              (HighDimProb.centeredRandomMatrix P A))

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {m n : Nat} {A : HighDimProb.RandomMatrix Omega m n}
    (hA : HighDimProb.IntegrableRandomMatrix P A) :
    HighDimProb.matrixExpect P (HighDimProb.centeredRandomMatrix P A) = 0 := by
  exact HighDimProb.matrixExpect_centeredRandomMatrix hA

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} {n : Nat}
    {A : HighDimProb.RandomMatrix Omega n n}
    (hA : HighDimProb.RandomSelfAdjointMatrix P A) :
    HighDimProb.RandomSelfAdjointMatrix P
      (HighDimProb.centeredRandomMatrix P A) := by
  exact HighDimProb.randomSelfAdjointMatrix_centeredRandomMatrix hA

example {n : Nat} (x : Fin n -> Real) :
    HighDimProb.IsSelfAdjointMatrix (HighDimProb.rankOneMatrix x) := by
  exact HighDimProb.isSelfAdjointMatrix_rankOneMatrix x

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} {n : Nat}
    (X : HighDimProb.RandomVector Omega n) :
    HighDimProb.RandomSelfAdjointMatrix P
      (HighDimProb.rankOneRandomMatrix X) := by
  exact HighDimProb.randomSelfAdjointMatrix_rankOneRandomMatrix X

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} {n : Nat}
    {X : HighDimProb.RandomVector Omega n}
    (hX : HighDimProb.IsRandomVector P X) :
    HighDimProb.IsRandomMatrix P
      (HighDimProb.centeredRankOneRandomMatrix P X) := by
  exact HighDimProb.centeredRankOneRandomMatrix_isRandomMatrix hX

example {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsFiniteMeasure P]
    {n : Nat} {X : HighDimProb.RandomVector Omega n}
    (hX : forall j : Fin n,
      HighDimProb.MemLpRealRandomVariable P (HighDimProb.coord X j) 2) :
    HighDimProb.IntegrableRandomMatrix P
      (HighDimProb.centeredRankOneRandomMatrix P X) := by
  exact HighDimProb.centeredRankOneRandomMatrix_integrable_of_memLp_two hX

example {Omega I : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {n : Nat} {A : I -> HighDimProb.RandomMatrix Omega n n}
    (hA : HighDimProb.SelfAdjointRandomMatrixFamily P A)
    (hInt : forall i, HighDimProb.IntegrableRandomMatrix P (A i)) :
    HighDimProb.CenteredSelfAdjointRandomMatrixFamily P
      (HighDimProb.centeredRandomMatrixFamily P A) := by
  exact HighDimProb.centeredSelfAdjointRandomMatrixFamily_centeredRandomMatrixFamily hA hInt

example {Omega I : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    {n : Nat} {X : I -> HighDimProb.RandomVector Omega n}
    (hX : forall i, HighDimProb.IsRandomVector P (X i))
    (hLp : forall i, forall j : Fin n,
      HighDimProb.MemLpRealRandomVariable P (HighDimProb.coord (X i) j) 2) :
    HighDimProb.CenteredSelfAdjointRandomMatrixFamily P
      (HighDimProb.centeredRankOneRandomMatrixFamily P X) := by
  exact HighDimProb.centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two
    hX hLp
