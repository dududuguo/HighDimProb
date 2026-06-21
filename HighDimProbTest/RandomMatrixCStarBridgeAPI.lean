import HighDimProb.RandomMatrix.CStarBridge

open HighDimProb
open scoped ComplexOrder MatrixOrder Matrix.Norms.Operator

variable {n : Nat}
variable (A B : Matrix (Fin n) (Fin n) Real)

#check realMatrixToCStarMatrix
#check realMatrixToCStarMatrix_apply
#check realMatrixToCStarMatrix_add
#check realMatrixToCStarMatrix_sub
#check isSelfAdjoint_realMatrixToCStarMatrix
#check realMatrixToCStarMatrix_nonneg_of_complexified_nonneg
#check realMatrixToCStarMatrixLE_of_complexified_le
#check realMatrixToCStarStrictlyPositive_of_complexified
#check realMatrixToCStarStrictlyPositive_statement
#check realMatrixToCStarMatrixLE_statement
#check realMatrixToCStarLogBack_statement
#check realMatrixToCStarLogBack_of_transport

example
    (hA : 0 <= A.map (algebraMap Real Complex)) :
    0 <= realMatrixToCStarMatrix A :=
  realMatrixToCStarMatrix_nonneg_of_complexified_nonneg A hA

example
    (hAB : A.map (algebraMap Real Complex) <= B.map (algebraMap Real Complex)) :
    realMatrixToCStarMatrix A <= realMatrixToCStarMatrix B :=
  realMatrixToCStarMatrixLE_of_complexified_le A B hAB

example
    (hA : IsStrictlyPositive (A.map (algebraMap Real Complex))) :
    IsStrictlyPositive (realMatrixToCStarMatrix A) :=
  realMatrixToCStarStrictlyPositive_of_complexified A hA

example
    (hlog : CFC.log (realMatrixToCStarMatrix A) =
      realMatrixToCStarMatrix (CFC.log A)) :
    realMatrixToCStarLogBack_statement A :=
  realMatrixToCStarLogBack_of_transport A hlog
