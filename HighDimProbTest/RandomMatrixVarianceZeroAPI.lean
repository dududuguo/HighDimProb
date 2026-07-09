import HighDimProb.RandomMatrix.VarianceZero

open HighDimProb
open MeasureTheory

#check matrixVarianceProxy_eq_zero_of_normBound_zero
#check randomMatrixFamily_ae_eq_zero_of_matrixVarianceProxy_eq_zero
#check randomMatrixFamily_ae_eq_zero_of_matrixVarianceProxyNormBound_zero
#check randomMatrixSum_ae_eq_zero_of_family_ae_eq_zero
#check upperTailProb_operatorNorm_randomMatrixSum_eq_zero_of_ae_eq_zero
#check upperTailProb_operatorNorm_randomMatrixSum_eq_zero_of_varianceNormBound_zero

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {I : Type*} [Fintype I] {n : Nat}
    {A : I -> RandomMatrix Omega n n}
    (hSA : forall i, RandomSelfAdjointMatrix P (A i))
    (hInt : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i)))
    (hNorm : MatrixVarianceProxyNormBound P A 0)
    {t : Real} (ht : 0 < t) :
    upperTailProb P (operatorNorm (randomMatrixSum A)) t = 0 := by
  exact
    upperTailProb_operatorNorm_randomMatrixSum_eq_zero_of_varianceNormBound_zero
      hSA hInt hNorm ht
