import HighDimProb.RandomMatrix.HardboneStatements

/-!
# Hardbone statement atlas usage

This example module checks that the RandomMatrix hardbone statement atlas is
available through the public RandomMatrix surface. The declarations below are
statement targets or thin consumers only; this file does not prove CFC, Lieb,
Golden-Thompson, conditioning, finite-family Tropp, or Matrix Bernstein.
-/

namespace HighDimProb.Examples.RandomMatrix.HardboneStatementAtlasUsage

open MeasureTheory
open HighDimProb

open scoped MatrixOrder Matrix.Norms.Operator

#check scalarBernsteinExpQuadraticInequality_statement
#check selfAdjointSpectrumBoundedByOperatorNorm_statement
#check cfcScalarInequalityToMatrixLE_statement
#check bernsteinMatrixExp_le_quadratic_of_cfcChain_statement
#check operatorLogMonotoneOnPositiveMatrices_statement
#check matrixLog_le_of_le_matrixExp_statement
#check troppLogExpComparisonToK_of_logOrderKChain_statement
#check liebTraceExpConcavity_statement
#check troppMasterTraceMGFStep_of_liebJensen_statement
#check troppConditionalStep_of_iIndepFun_statement
#check matrixExpScaledIntegrable_of_provider_statement
#check traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider_statement
#check sampleCovarianceVarianceProxy_sharp_statement
#check traceMatrixExp_effectiveRank_bound_statement

#check bernsteinMatrixExp_le_quadratic_of_cfcChain
#check selfAdjointSpectrumBoundedByOperatorNorm
#check bernsteinCFCExpressionNormalization
#check cfcScalarInequalityToMatrixLE_bernsteinExpQuadratic
#check bernsteinMatrixExp_le_quadratic_of_cfcLeaves
#check bernsteinMatrixExp_le_quadratic
#check matrixLog_le_of_le_matrixExp
#check troppLogExpComparisonToK_of_logMonotone_traceExpMono
#check troppMasterTraceMGFStep_of_liebJensen
#check troppMasterTraceMGFConditionalStep_of_conditioningBridge

example (theta R : Real) : Prop :=
  scalarBernsteinExpQuadraticInequality_statement theta R

example {n : Nat} (A : Matrix (Fin n) (Fin n) Real) (theta R : Real) :
    Prop :=
  bernsteinMatrixExp_le_quadratic_of_cfcChain_statement A theta R

example {n : Nat} (H M K : Matrix (Fin n) (Fin n) Real) : Prop :=
  troppLogExpComparisonToK_of_logOrderKChain_statement H M K

example {n : Nat} (M K : Matrix (Fin n) (Fin n) Real) :
    matrixLog_le_of_le_matrixExp_statement M K :=
  matrixLog_le_of_le_matrixExp M K

example {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) [IsProbabilityMeasure P] {n : Nat}
    (H : Matrix (Fin n) (Fin n) Real)
    (Z : RandomMatrix Omega n n) : Prop :=
  troppMasterTraceMGFStep_of_liebJensen_statement (P := P) H Z

example {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {m n : Nat}
    (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (mHist : Fin m -> MeasurableSpace Omega) : Prop :=
  troppConditionalStep_of_iIndepFun_statement (P := P) theta X K mHist

example {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {m n : Nat}
    (theta R : Real)
    (X : Fin m -> RandomMatrix Omega n n) : Prop :=
  matrixExpScaledIntegrable_of_provider_statement (P := P) theta R X

example {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {m n : Nat}
    (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (D : RealRandomVariable Omega) : Prop :=
  traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider_statement
    (P := P) theta X D

example {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) [IsProbabilityMeasure P] {m n : Nat}
    (X : Fin m -> RandomVector Omega n)
    (V : Fin m -> Matrix (Fin n) (Fin n) Real)
    (sigma2 : Real) : Prop :=
  sampleCovarianceVarianceProxy_sharp_statement (P := P) X V sigma2

example {n : Nat} (A support : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (rankBound : Nat) : Prop :=
  traceMatrixExp_le_rank_exp_lambdaMax_statement A support rankBound

end HighDimProb.Examples.RandomMatrix.HardboneStatementAtlasUsage
