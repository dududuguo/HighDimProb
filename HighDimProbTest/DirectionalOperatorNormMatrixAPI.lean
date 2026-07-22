import HighDimProb.RandomMatrix.Concentration

/-! Downstream consumer checks for the directional ε-net operator-norm surface,
importing only the stable aggregation module `HighDimProb.RandomMatrix.Concentration`. -/

open HighDimProb
open MeasureTheory
open scoped BigOperators Matrix.Norms.L2Operator ENNReal

#check @HighDimProb.IsUnitSphereNet
#check @HighDimProb.IsUnitSphereNet.unit
#check @HighDimProb.IsUnitSphereNet.cover
#check @HighDimProb.deterministicOperatorNorm_le_of_isUnitSphereNet
#check @HighDimProb.directionallySubGaussianSelfAdjointMatrix_operatorNorm_netTail
#check @HighDimProb.directionallySubGaussianSelfAdjointMatrix_operatorNorm_netTail_sum_of_iIndepFun

/-- Consumer: deterministic ε-net operator-norm bound for a self-adjoint matrix. -/
example {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) {N : Finset (Fin (n + 1) → Real)} {eps M : Real}
    (heps0 : 0 ≤ eps) (heps : eps < 1 / 2)
    (hN : IsUnitSphereNet N eps)
    (hM : ∀ v ∈ N, |matrixQuadraticForm A v| ≤ M) :
    deterministicOperatorNorm A ≤ (1 - 2 * eps)⁻¹ * M :=
  deterministicOperatorNorm_le_of_isUnitSphereNet hA heps0 heps hN hM

/-- Consumer: single-matrix ε-net operator-norm tail for `‖X - EX‖`. -/
example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {n : Nat}
    {X : RandomMatrix Omega (n + 1) (n + 1)} {K : Real}
    (hX : DirectionallySubGaussianSelfAdjointMatrix P X K)
    (hInt : IntegrableRandomMatrix P X)
    {N : Finset (Fin (n + 1) → Real)} {eps t : Real}
    (heps0 : 0 ≤ eps) (heps : eps < 1 / 2)
    (hN : IsUnitSphereNet N eps)
    (ht : 0 ≤ t) :
    P (upperTailEvent (operatorNorm (centeredRandomMatrix P X)) t) ≤
      ENNReal.ofReal
        (2 * (N.card : Real) *
          Real.exp (-((1 - 2 * eps) ^ 2 * t ^ 2 / (4 * K ^ 2)))) :=
  directionallySubGaussianSelfAdjointMatrix_operatorNorm_netTail hX hInt heps0 heps
    hN ht

/-- Consumer: independent finite-sum ε-net operator-norm tail with proxy
`sqrt (∑ᵢ Kᵢ²)`, i.e. exponential constant `4·(∑ᵢ Kᵢ²)`. -/
example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    {X : I → RandomMatrix Omega (n + 1) (n + 1)} {K : I → Real}
    (hKsum : 0 < ∑ i : I, (K i) ^ 2)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hSG : ∀ i, DirectionallySubGaussianSelfAdjointMatrix P (X i) (K i))
    (hIntSum : IntegrableRandomMatrix P (randomMatrixSum X))
    {N : Finset (Fin (n + 1) → Real)} {eps t : Real}
    (heps0 : 0 ≤ eps) (heps : eps < 1 / 2)
    (hN : IsUnitSphereNet N eps)
    (ht : 0 ≤ t) :
    P (upperTailEvent (operatorNorm (centeredRandomMatrix P (randomMatrixSum X))) t) ≤
      ENNReal.ofReal
        (2 * (N.card : Real) *
          Real.exp (-((1 - 2 * eps) ^ 2 * t ^ 2 / (4 * (∑ i : I, (K i) ^ 2))))) :=
  directionallySubGaussianSelfAdjointMatrix_operatorNorm_netTail_sum_of_iIndepFun
    hKsum hIndep hSG hIntSum heps0 heps hN ht
