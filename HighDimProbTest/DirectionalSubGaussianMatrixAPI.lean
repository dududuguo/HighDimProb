import HighDimProb.RandomMatrix.Concentration

/-! Compile-time checks for the public directional sub-Gaussian matrix surface. -/

open HighDimProb
open MeasureTheory
open scoped BigOperators

-- Predicate and reusable scalar projection.
#check @HighDimProb.DirectionallySubGaussianSelfAdjointMatrix
#check @HighDimProb.centeredMatrixQuadraticForm
#check @HighDimProb.centeredMatrixQuadraticForm_apply
#check @HighDimProb.isRealRandomVariable_centeredMatrixQuadraticForm
#check @HighDimProb.centeredMatrixQuadraticForm_smul
#check @HighDimProb.centeredMatrixQuadraticForm_neg
#check @HighDimProb.centeredMatrixQuadraticForm_randomMatrixSum

-- Predicate projection / elimination API.
#check @HighDimProb.DirectionallySubGaussianSelfAdjointMatrix.K_pos
#check @HighDimProb.DirectionallySubGaussianSelfAdjointMatrix.isRandomMatrix
#check @HighDimProb.DirectionallySubGaussianSelfAdjointMatrix.randomSelfAdjoint
#check @HighDimProb.DirectionallySubGaussianSelfAdjointMatrix.centeredSubGaussianMGF
#check @HighDimProb.DirectionallySubGaussianSelfAdjointMatrix.integrable_centeredMatrixQuadraticForm
#check @HighDimProb.DirectionallySubGaussianSelfAdjointMatrix.integrable_matrixQuadraticForm
#check @HighDimProb.DirectionallySubGaussianSelfAdjointMatrix.expect_centeredMatrixQuadraticForm_eq_zero

-- Independent finite-sum closure and fixed-direction tail bounds.
#check @HighDimProb.directionallySubGaussianSelfAdjointMatrix_sum_of_iIndepFun
#check @HighDimProb.directionallySubGaussianSelfAdjointMatrix_upperTail
#check @HighDimProb.directionallySubGaussianSelfAdjointMatrix_lowerTail

/-- Downstream parameter-inferability check: the independent finite-sum closure
composes with the fixed-direction upper tail, with the proxy scale
`K = sqrt (∑ᵢ Kᵢ²)` inferred automatically from the closure result. -/
example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (X : I → RandomMatrix Omega n n) (K : I → Real)
    (hKsum : 0 < ∑ i : I, (K i) ^ 2)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hSG : ∀ i, DirectionallySubGaussianSelfAdjointMatrix P (X i) (K i))
    {u : Fin n → Real} (hu : IsUnitVector u) {t : Real} (ht : 0 ≤ t) :
    upperTailProb P (centeredMatrixQuadraticForm P (randomMatrixSum X) u) t ≤
      ENNReal.ofReal
        (Real.exp (-(t ^ 2 / (4 * (Real.sqrt (∑ i : I, (K i) ^ 2)) ^ 2)))) :=
  directionallySubGaussianSelfAdjointMatrix_upperTail
    (directionallySubGaussianSelfAdjointMatrix_sum_of_iIndepFun hKsum hIndep hSG)
    hu ht

example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {n : Nat} {X : RandomMatrix Omega n n} {K : Real}
    (hSG : DirectionallySubGaussianSelfAdjointMatrix P X K)
    {u : Fin n → Real} (hu : IsUnitVector u) {t : Real} (ht : 0 ≤ t) :
    lowerTailProb P (centeredMatrixQuadraticForm P X u) (-t) ≤
      ENNReal.ofReal (Real.exp (-(t ^ 2 / (4 * K ^ 2)))) :=
  directionallySubGaussianSelfAdjointMatrix_lowerTail hSG hu ht
