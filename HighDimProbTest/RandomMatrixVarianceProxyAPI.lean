import HighDimProb.RandomMatrix.ConcentrationStatements

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega}
variable {I : Type*} [Fintype I]
variable {m n : Nat}
variable (A : I -> RandomMatrix Omega n n)
variable (X : RandomMatrix Omega n n)
variable (Y : RandomMatrix Omega m n)
variable (Z : RandomVector Omega n)
variable (M V : Matrix (Fin n) (Fin n) Real)
variable (i : I)
variable (omega : Omega)
variable (r cidx : Fin n)
variable (R sigma2 c theta t : Real)
variable (hA : forall i, IsRandomMatrix P (A i))
variable (hX : IsRandomMatrix P X)
variable (hProdZ : forall i : Fin n, forall j : Fin n,
  IntegrableRealRandomVariable P (fun omega => Z omega i * Z omega j))
variable (hZ2 : forall i : Fin n, MemLpRealRandomVariable P (coord Z i) 2)
variable (hSA : forall i, RandomSelfAdjointMatrix P (A i))
variable (hM : IsSelfAdjointMatrix M)
variable (hXSA : RandomSelfAdjointMatrix P X)
variable (hXsqInt : IntegrableRandomMatrix P (randomMatrixSquare X))
variable (hAsqInt : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i)))
variable (hBoundA : PointwiseOperatorNormBound A R)
variable (hRnonneg : 0 <= R)

#check randomMatrixSum
#check randomMatrixSum_apply
#check randomMatrixSum_entry
#check isRandomMatrix_sum
#check isSelfAdjointMatrix_sum
#check randomSelfAdjointMatrix_sum
#check IndependentRandomMatrices
#check SelfAdjointRandomMatrixFamily
#check IndependentSelfAdjointRandomMatrices
#check CenteredSelfAdjointRandomMatrixFamily
#check CenteredRandomSelfAdjointMatrices
#check IntegrableRandomMatrix
#check integrableRandomMatrix_rankOneRandomMatrix_of_integrable_products
#check integrableRandomMatrix_rankOneRandomMatrix_of_memLp_two
#check BoundedOperatorNorm
#check PointwiseOperatorNormBound
#check UniformOperatorNormBound
#check AeOperatorNormBound
#check matrixSquare
#check matrixSquare_apply
#check matrixSquare_neg
#check matrixQuadraticForm_sum
#check matrixQuadraticForm_add
#check matrixQuadraticForm_smul
#check isPSDMatrix_zero
#check isPSDMatrix_sum
#check isPSDMatrix_add
#check isPSDMatrix_smul_of_nonneg
#check matrixLE_refl
#check matrixLE_of_eq
#check matrixLE_trans
#check matrixLE_add
#check matrixLE_add_left
#check matrixLE_add_right
#check matrixLE_smul_of_nonneg
#check randomMatrixSquare
#check randomMatrixSquare_apply
#check randomMatrixSquare_neg
#check isRandomMatrix_matrixSquare
#check matrixQuadraticForm_matrixExpect
#check integrableRandomMatrix_sub
#check integrableRandomMatrix_add
#check integrableRandomMatrix_smul
#check integrableRandomMatrix_zero
#check integrableRandomMatrix_const
#check matrixExpect_sub
#check matrixExpect_add
#check matrixExpect_smul
#check matrixExpect_zero
#check matrixExpect_const
#check matrixExpect_const_of_isProbabilityMeasure
#check matrixExpect_one_of_isProbabilityMeasure
#check isPSDMatrix_matrixExpect_of_pointwise_isPSD
#check matrixExpect_matrixLE_of_pointwise_matrixLE
#check matrixSecondMoment
#check matrixSecondMoment_apply
#check matrixVarianceProxy
#check matrixVarianceProxy_apply
#check MatrixVarianceProxy
#check matrixVarianceProxyBound
#check MatrixVarianceProxyBound
#check MatrixVarianceProxyUpperBound
#check deterministicMatrixVarianceProxyNorm
#check deterministicMatrixVarianceProxyNorm_apply
#check matrixVarianceProxyNorm
#check matrixVarianceProxyNorm_apply
#check MatrixVarianceProxyNormBound
#check pointwiseOperatorNormVarianceProxyNormRHS
#check deterministicOperatorNorm_matrixSquare_le_sq
#check deterministicOperatorNorm_matrixSquare_le_sq_of_le
#check deterministicOperatorNorm_matrixSecondMoment_le_sq_of_forall
#check matrixVarianceProxyNorm_le_pointwiseOperatorNormVarianceProxyNormRHS
#check MatrixVarianceProxyNormBound_of_pointwiseOperatorNormBound
#check centeredRankOneVarianceProxyNormRHS
#check MatrixVarianceProxyNormBound_centeredRankOneRandomMatrixFamily_of_sqNorm_bound
#check isSelfAdjointMatrix_matrixSquare_of_isSelfAdjointMatrix
#check matrixQuadraticForm_matrixSquare_eq_matVecSqNorm_of_selfAdjoint
#check isPSD_matrixSquare_of_selfAdjoint
#check isPSD_matrixSquare_of_selfAdjoint_statement
#check isSelfAdjointMatrix_matrixSecondMoment
#check isPSD_matrixSecondMoment_of_selfAdjoint
#check isPSD_matrixSecondMoment_of_selfAdjoint_statement
#check isSelfAdjointMatrix_matrixVarianceProxy
#check isPSD_matrixVarianceProxy_of_selfAdjoint
#check isPSD_matrixVarianceProxy_of_selfAdjoint_statement
#check matrixBernsteinStatement
#check matrixBernsteinTraceMGF_statement
#check matrixBernsteinTraceMGFWithBernsteinCoeff_statement
#check matrixBernsteinTraceMGFWithBernsteinCoeff_of_troppMasterTraceMGFFiniteFamily

#check (randomMatrixSum A : RandomMatrix Omega n n)
#check (randomMatrixSum A omega : Matrix (Fin n) (Fin n) Real)
#check (randomMatrixSum_entry A omega r cidx :
  randomMatrixSum A omega r cidx = Finset.univ.sum fun i : I => A i omega r cidx)
#check (isRandomMatrix_sum (A := A) hA :
  IsRandomMatrix P (randomMatrixSum A))
#check (randomSelfAdjointMatrix_sum (A := A) hSA :
  RandomSelfAdjointMatrix P (randomMatrixSum A))
#check (IndependentRandomMatrices P A : Prop)
#check (SelfAdjointRandomMatrixFamily P A : Prop)
#check (IndependentSelfAdjointRandomMatrices P A : Prop)
#check (CenteredSelfAdjointRandomMatrixFamily P A : Prop)
#check (CenteredRandomSelfAdjointMatrices P A : Prop)
#check (IntegrableRandomMatrix P X : Prop)
#check (integrableRandomMatrix_rankOneRandomMatrix_of_integrable_products
  (X := Z) hProdZ :
  IntegrableRandomMatrix P (rankOneRandomMatrix Z))
#check (integrableRandomMatrix_rankOneRandomMatrix_of_memLp_two
  (X := Z) hZ2 :
  IntegrableRandomMatrix P (rankOneRandomMatrix Z))
#check (BoundedOperatorNorm X R : Prop)
#check (PointwiseOperatorNormBound A R : Prop)
#check (UniformOperatorNormBound A R : Prop)
#check (AeOperatorNormBound P A R : Prop)
#check (matrixSquare M : Matrix (Fin n) (Fin n) Real)
#check (matrixSquare_neg M : matrixSquare (-M) = matrixSquare M)
#check (randomMatrixSquare X : RandomMatrix Omega n n)
#check (randomMatrixSquare_neg X :
  randomMatrixSquare (fun omega => -X omega) = randomMatrixSquare X)
#check (isRandomMatrix_matrixSquare hX :
  IsRandomMatrix P (randomMatrixSquare X))
#check (matrixSecondMoment P X : Matrix (Fin n) (Fin n) Real)
#check (matrixVarianceProxy P A : Matrix (Fin n) (Fin n) Real)
#check (MatrixVarianceProxy P A : Matrix (Fin n) (Fin n) Real)
#check (matrixVarianceProxyBound V sigma2 : Prop)
#check (MatrixVarianceProxyBound V sigma2 : Prop)
#check (MatrixVarianceProxyUpperBound P A V : Prop)
#check (deterministicMatrixVarianceProxyNorm V : Real)
#check (matrixVarianceProxyNorm P A : Real)
#check (MatrixVarianceProxyNormBound P A sigma2 : Prop)
#check (pointwiseOperatorNormVarianceProxyNormRHS (I := I) R : Real)
#check (isSelfAdjointMatrix_matrixSquare_of_isSelfAdjointMatrix hM :
  IsSelfAdjointMatrix (matrixSquare M))
#check (deterministicOperatorNorm_matrixSquare_le_sq M :
  deterministicOperatorNorm (matrixSquare M) <= deterministicOperatorNorm M ^ 2)
#check (matrixQuadraticForm_matrixSquare_eq_matVecSqNorm_of_selfAdjoint hM :
  forall x : Fin n -> Real, matrixQuadraticForm (matrixSquare M) x = matVecSqNorm M x)
#check (isPSD_matrixSquare_of_selfAdjoint hM :
  IsPSDMatrix (matrixSquare M))
#check (isPSD_matrixSquare_of_selfAdjoint_statement hM : Prop)
#check (matrixQuadraticForm_matrixExpect hXsqInt :
  forall x : Fin n -> Real,
    matrixQuadraticForm (matrixExpect P (randomMatrixSquare X)) x =
      expect P (fun omega => matrixQuadraticForm (randomMatrixSquare X omega) x))
#check (integrableRandomMatrix_sub hXsqInt hXsqInt :
  IntegrableRandomMatrix P
    (fun omega => randomMatrixSquare X omega - randomMatrixSquare X omega))
#check (isPSD_matrixSecondMoment_of_selfAdjoint hXSA hXsqInt :
  IsPSDMatrix (matrixSecondMoment P X))
#check (isPSD_matrixVarianceProxy_of_selfAdjoint P hSA hAsqInt :
  IsPSDMatrix (matrixVarianceProxy P A))
#check (matrixBernsteinStatement P A sigma2 R c t : Prop)
#check (matrixBernsteinTraceMGF_statement P A theta : Prop)
#check (matrixBernsteinTraceMGFWithBernsteinCoeff_statement P A theta R : Prop)

section PointwiseVarianceProxyNormBound

variable [IsProbabilityMeasure P]

#check (MatrixVarianceProxyNormBound_of_pointwiseOperatorNormBound
  (P := P) (A := A) (R := R) hAsqInt hBoundA hRnonneg :
  MatrixVarianceProxyNormBound P A
    (pointwiseOperatorNormVarianceProxyNormRHS (I := I) R))

end PointwiseVarianceProxyNormBound

example : MatrixVarianceProxyUpperBound P A V =
    MatrixLE (matrixVarianceProxy P A) V := by
  rfl

example : MatrixVarianceProxyNormBound P A sigma2 =
    (matrixVarianceProxyNorm P A <= sigma2) := by
  rfl

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} {X : RandomMatrix Omega n n}
    (hInt : IntegrableRandomMatrix P X)
    (hPSD : forall omega, IsPSDMatrix (X omega)) :
    IsPSDMatrix (matrixExpect P X) := by
  exact isPSDMatrix_matrixExpect_of_pointwise_isPSD hInt hPSD

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} {X Y : RandomMatrix Omega n n}
    (hIntX : IntegrableRandomMatrix P X)
    (hIntY : IntegrableRandomMatrix P Y)
    (hLE : forall omega, MatrixLE (X omega) (Y omega)) :
    MatrixLE (matrixExpect P X) (matrixExpect P Y) := by
  exact matrixExpect_matrixLE_of_pointwise_matrixLE hIntX hIntY hLE

example {n : Nat} (M : Matrix (Fin n) (Fin n) Real) :
    MatrixLE M M := by
  exact matrixLE_refl M

example {n : Nat} {M N K : Matrix (Fin n) (Fin n) Real}
    (hMN : MatrixLE M N) (hNK : MatrixLE N K) :
    MatrixLE M K := by
  exact matrixLE_trans hMN hNK

example {n : Nat} {M N K L : Matrix (Fin n) (Fin n) Real}
    (hMN : MatrixLE M N) (hKL : MatrixLE K L) :
    MatrixLE (M + K) (N + L) := by
  exact matrixLE_add hMN hKL

example {n : Nat} {M N : Matrix (Fin n) (Fin n) Real}
    {a : Real} (ha : 0 <= a) (hMN : MatrixLE M N) :
    MatrixLE (a • M) (a • N) := by
  exact matrixLE_smul_of_nonneg ha hMN

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {X Y : RandomMatrix Omega m n}
    (hIntX : IntegrableRandomMatrix P X)
    (hIntY : IntegrableRandomMatrix P Y) :
    IntegrableRandomMatrix P (fun omega => Y omega - X omega) := by
  exact integrableRandomMatrix_sub hIntX hIntY

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {X Y : RandomMatrix Omega m n}
    (hIntX : IntegrableRandomMatrix P X)
    (hIntY : IntegrableRandomMatrix P Y) :
    IntegrableRandomMatrix P (fun omega => X omega + Y omega) := by
  exact integrableRandomMatrix_add hIntX hIntY

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {X : RandomMatrix Omega m n}
    (a : Real) (hIntX : IntegrableRandomMatrix P X) :
    IntegrableRandomMatrix P (fun omega => a • X omega) := by
  exact integrableRandomMatrix_smul a hIntX

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} :
    IntegrableRandomMatrix P
      (fun _omega => (0 : Matrix (Fin m) (Fin n) Real)) := by
  exact integrableRandomMatrix_zero

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsFiniteMeasure P] {m n : Nat}
    (M : Matrix (Fin m) (Fin n) Real) :
    IntegrableRandomMatrix P (fun _omega => M) := by
  exact integrableRandomMatrix_const M

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {X Y : RandomMatrix Omega m n}
    (hIntX : IntegrableRandomMatrix P X)
    (hIntY : IntegrableRandomMatrix P Y) :
    matrixExpect P (fun omega => Y omega - X omega) =
      matrixExpect P Y - matrixExpect P X := by
  exact matrixExpect_sub hIntX hIntY

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {X Y : RandomMatrix Omega m n}
    (hIntX : IntegrableRandomMatrix P X)
    (hIntY : IntegrableRandomMatrix P Y) :
    matrixExpect P (fun omega => X omega + Y omega) =
      matrixExpect P X + matrixExpect P Y := by
  exact matrixExpect_add hIntX hIntY

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} {X : RandomMatrix Omega m n}
    (a : Real) :
    matrixExpect P (fun omega => a • X omega) =
      a • matrixExpect P X := by
  exact matrixExpect_smul a

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat} :
    matrixExpect P (fun _omega => (0 : Matrix (Fin m) (Fin n) Real)) = 0 := by
  exact matrixExpect_zero

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {m n : Nat}
    (M : Matrix (Fin m) (Fin n) Real) :
    matrixExpect P (fun _omega => M) = (P.real Set.univ) • M := by
  exact matrixExpect_const M

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    (M : Matrix (Fin m) (Fin n) Real) :
    matrixExpect P (fun _omega => M) = M := by
  exact matrixExpect_const_of_isProbabilityMeasure M

example {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat} :
    matrixExpect P (fun _omega => (1 : Matrix (Fin n) (Fin n) Real)) = 1 := by
  exact matrixExpect_one_of_isProbabilityMeasure
