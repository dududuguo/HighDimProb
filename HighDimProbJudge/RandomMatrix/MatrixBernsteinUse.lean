import HighDimProb.RandomMatrix

#check HighDimProb.matrixBernsteinStatement
#check HighDimProb.matrixBernsteinSelfAdjointStatement
#check HighDimProb.matrixBernsteinLaplacePrerequisitesStatement
#check HighDimProb.matrixBernsteinTraceMGF_statement
#check HighDimProb.matrixBernsteinTraceMGFWithBernsteinCoeff_statement
#check HighDimProb.matrixBernsteinTraceMGFWithBernsteinCoeff_of_troppMasterTraceMGFFiniteFamily
#check HighDimProb.matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives
#check HighDimProb.matrixBernsteinTraceMGFToLaplaceContract_statement
#check HighDimProb.matrixBernsteinTraceMGFToLaplaceContract_under_primitives_statement
#check HighDimProb.matrixVarianceProxyNorm
#check HighDimProb.PointwiseOperatorNormBound
#check HighDimProb.IndependentSelfAdjointRandomMatrices
#check HighDimProb.CenteredSelfAdjointRandomMatrixFamily
#check HighDimProb.isPSD_matrixVarianceProxy_of_selfAdjoint
#check HighDimProb.matrixLaplaceTransformStatement
#check HighDimProb.matrixLaplaceTransformLIntegralStatement
#check HighDimProb.selfAdjointOperatorNormLaplaceStatement
#check HighDimProb.selfAdjointOperatorNormLaplaceLIntegralStatement

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {n : Nat} (P : MeasureTheory.Measure Omega)
    [MeasureTheory.IsProbabilityMeasure P]
    (A : I -> HighDimProb.RandomMatrix Omega n n)
    (sigma2 R c1 c2 t : Real) : Prop :=
  HighDimProb.matrixBernsteinSelfAdjointStatement P A sigma2 R c1 c2 t

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta t : Real) : Prop :=
  HighDimProb.matrixBernsteinLaplacePrerequisitesStatement P Y theta t

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


example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {n : Nat} (P : MeasureTheory.Measure Omega)
    [MeasureTheory.IsProbabilityMeasure P]
    (A : I -> HighDimProb.RandomMatrix Omega n n)
    (theta t R : Real) : Prop :=
  HighDimProb.matrixBernsteinTraceMGFToLaplaceContract_statement P A theta t R

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {n : Nat} (P : MeasureTheory.Measure Omega)
    [MeasureTheory.IsProbabilityMeasure P]
    (A : I -> HighDimProb.RandomMatrix Omega n n)
    (theta t R : Real) : Prop :=
  HighDimProb.matrixBernsteinTraceMGFToLaplaceContract_under_primitives_statement P A theta t R
