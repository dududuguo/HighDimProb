import HighDimProb.RandomMatrix.ConcentrationStatements

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable {I : Type*}
variable {m n : Nat}
variable (A : RandomMatrix Omega m n)
variable (B C : RandomMatrix Omega n n)
variable (M : Matrix (Fin m) (Fin n) Real)
variable (S T : Matrix (Fin n) (Fin n) Real)
variable (x : Fin n -> Real)
variable (v : Fin n -> Real)
variable (X : I -> Omega -> Fin n -> Real)
variable (L t bound : Real)
variable (hA : IsRandomMatrix P A)

#check operatorNorm
#check operatorNorm_apply
#check vectorSqNorm
#check IsUnitVector
#check unitSphere
#check vectorSqNorm_apply
#check vectorSqNorm_nonneg
#check vectorSqNorm_eq_norm_sq_toLp
#check norm_sq_toLp_eq_vectorSqNorm
#check mem_unitSphere_iff
#check vectorSqNorm_eq_one_of_isUnitVector
#check isUnitVector_vectorSqNorm_nonneg
#check norm_toLp_eq_one_of_isUnitVector
#check isUnitVector_of_norm_toLp_eq_one
#check instOpensMeasurableSpaceMatrixL2Operator
#check deterministicOperatorNorm
#check deterministicOperatorNorm_apply
#check rankOneOperatorNorm_le_vectorSqNorm
#check matVecSqNorm
#check matVecSqNorm_apply
#check matVecSqNorm_nonneg
#check matVecSqNorm_eq_norm_sq_toLp_mulVec
#check norm_sq_toLp_mulVec_eq_matVecSqNorm
#check randomMatVecSqNorm
#check randomMatVecSqNorm_apply
#check sqNorm_matVec_eq_matVecSqNorm
#check isRealRandomVariable_randomMatVecSqNorm
#check OperatorNormBoundSq
#check RandomOperatorNormBoundSq
#check operatorNormBoundSq_nonneg
#check matVecSqNorm_le_of_operatorNormBoundSq
#check operatorNormBoundSq_of_operatorNorm_le
#check operatorNorm_le_of_operatorNormBoundSq
#check isRealRandomVariable_operatorNorm
#check operatorNorm_le_of_operatorNormBoundSqStatement
#check operatorNormBoundSq_of_operatorNorm_leStatement
#check operatorNormMeasurabilityStatement
#check matrixQuadraticForm_sub
#check quadraticForm_le_of_matrixLE
#check quadraticForm_apply_le_of_matrixLE
#check sampleCovarianceQuadraticFormDeviation
#check sampleCovarianceOperatorNormViaUnitSphereStatement

#check (operatorNorm A : RealRandomVariable Omega)
#check (vectorSqNorm x : Real)
#check (IsUnitVector x : Prop)
#check (unitSphere n : Set (Fin n -> Real))
#check (deterministicOperatorNorm M : Real)
#check (rankOneOperatorNorm_le_vectorSqNorm v :
  deterministicOperatorNorm (fun i j : Fin n => v i * v j) <= vectorSqNorm v)
#check (matVecSqNorm M x : Real)
#check (randomMatVecSqNorm A x : RealRandomVariable Omega)
#check (sqNorm_matVec_eq_matVecSqNorm A x : forall omega, sqNorm (matVec A x) omega = matVecSqNorm (A omega) x)
#check (isRealRandomVariable_randomMatVecSqNorm hA x :
  IsRealRandomVariable P (randomMatVecSqNorm A x))
#check (OperatorNormBoundSq M L : Prop)
#check (RandomOperatorNormBoundSq A L : Prop)
#check (operatorNormBoundSq_of_operatorNorm_le (A := M) (L := L) :
  0 <= L -> deterministicOperatorNorm M <= L -> OperatorNormBoundSq M L)
#check (operatorNorm_le_of_operatorNormBoundSq (A := M) (L := L) :
  OperatorNormBoundSq M L -> deterministicOperatorNorm M <= L)
#check (isRealRandomVariable_operatorNorm hA :
  IsRealRandomVariable P (operatorNorm A))
#check (operatorNorm_le_of_operatorNormBoundSqStatement M L : Prop)
#check (operatorNormBoundSq_of_operatorNorm_leStatement M L : Prop)
#check (operatorNormMeasurabilityStatement P A : Prop)
#check (PointwiseOperatorNormBound_rankOne_of_sqNorm_bound
  (X := X) (R := L) :
  0 <= L ->
  (forall i omega, vectorSqNorm (X i omega) <= L) ->
  PointwiseOperatorNormBound
    (fun i omega a b => X i omega a * X i omega b) L)
#check (matrixQuadraticForm_sub T S x :
  matrixQuadraticForm (T - S) x = matrixQuadraticForm T x - matrixQuadraticForm S x)
#check (quadraticForm_le_of_matrixLE (A := S) (B := T) : MatrixLE S T -> forall x, matrixQuadraticForm S x <= matrixQuadraticForm T x)
#check (sampleCovarianceQuadraticFormDeviation A x : RealRandomVariable Omega)
#check (sampleCovarianceOperatorNormViaUnitSphereStatement P A t bound : Prop)
