import HighDimProb.RandomMatrix.HardboneStatements

open MeasureTheory
open HighDimProb
open scoped MatrixOrder Matrix.Norms.Operator

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega}
variable [MeasureTheory.IsProbabilityMeasure P]
variable {m n : Nat}
variable (A H M K : Matrix (Fin n) (Fin n) Real)
variable (B S : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
variable (Y : RandomMatrix Omega n n)
variable (D : RealRandomVariable Omega)
variable (theta R sigmaSq effectiveRank : Real)
variable (rankBound supportDim : Nat)
variable (X : Fin m -> RandomMatrix Omega n n)
variable (Kfam : Fin m -> Matrix (Fin n) (Fin n) Real)
variable (mHist : Fin m -> MeasurableSpace Omega)

#check scalarBernsteinExpQuadraticInequality_statement
#check selfAdjointSpectrumBoundedByOperatorNorm_statement
#check cfcScalarInequalityToMatrixLE_statement
#check bernsteinCFCExpressionNormalization_statement
#check bernsteinMatrixExp_le_quadratic_of_cfcChain_statement
#check operatorLogMonotoneOnPositiveMatrices_statement
#check matrixExpLogDomainForSelfAdjoint_statement
#check matrixLog_le_of_le_matrixExp_statement
#check traceMatrixExp_mono_add_selfAdjoint_statement
#check troppLogExpComparisonToK_of_logOrderKChain_statement
#check liebTraceExpConcavity_statement
#check liebJensenTraceExp_statement
#check goldenThompsonTraceExp_statement
#check matrixExpLogSelfAdjointNormalization_statement
#check troppMasterTraceMGFStep_of_liebJensen_statement
#check troppNaturalHistoryMeasurable_statement
#check troppHistoryStepIndependent_of_iIndepFun_statement
#check condExp_traceExp_history_add_independent_step_statement
#check troppConditionalStep_of_iIndepFun_statement
#check matrixExpScaledIntegrable_of_provider_statement
#check traceExpIntegrable_troppStateHistory_add_step_statement
#check traceExpIntegrable_troppStateHistory_add_K_statement
#check traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider_statement
#check matrixSquare_centeredRandomMatrix_expectation_expansion_statement
#check centeredRankOneSquare_le_rankOneSecondMoment_statement
#check sampleCovarianceVarianceProxy_sharp_statement
#check varianceProxyNormBound_of_centeredSquareChain_statement
#check traceMatrixExp_le_rank_exp_lambdaMax_statement
#check traceMatrixExp_le_supportDim_exp_lambdaMax_statement
#check traceMatrixExp_effectiveRank_bound_statement
#check traceMatrixExp_effectiveRank_bound
#check traceMatrixExp_effectiveRank_bound_of_ambientTraceCertificate
#check bernsteinMatrixExp_le_quadratic_of_cfcChain
#check selfAdjointSpectrumBoundedByOperatorNorm
#check bernsteinCFCExpressionNormalization
#check cfcScalarInequalityToMatrixLE_bernsteinExpQuadratic
#check bernsteinMatrixExp_le_quadratic_of_cfcLeaves
#check bernsteinMatrixExp_le_quadratic
#check bernsteinMatrixExp_le_quadratic_of_spectrum_cfcOrder
#check bernsteinMatrixExp_le_quadratic_of_cfcChain_spectrum
#check troppLogExpComparisonToK_of_logMonotone_traceExpMono
#check troppMasterTraceMGFStep_of_liebJensen
#check troppMasterTraceMGFConditionalStep_of_conditioningBridge
#check traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider
#check varianceProxyNormBound_of_centeredSquareChain
#check matrixTrace_smul
#check matrixTrace_le_of_matrixLE
#check traceMatrixExp_le_trace_support_exp_lambdaMax_of_matrixExp_le_smul_support
#check traceMatrixExp_le_rank_exp_lambdaMax
#check traceMatrixExp_le_supportDim_exp_lambdaMax

example : Prop :=
  scalarBernsteinExpQuadraticInequality_statement theta R

example : Prop :=
  bernsteinMatrixExp_le_quadratic_of_cfcChain_statement A theta R

example : Prop :=
  troppLogExpComparisonToK_of_logOrderKChain_statement H M K

example : Prop :=
  troppMasterTraceMGFStep_of_liebJensen_statement (P := P) H Y

example : Prop :=
  troppConditionalStep_of_iIndepFun_statement (P := P) theta X Kfam mHist

example : Prop :=
  traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider_statement
    (P := P) theta X D

example
    (hChain :
      traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider_statement
        (P := P) theta X D)
    (hD : IntegrableRealRandomVariable P D)
    (hD_nonneg : forall omega, 0 <= D omega)
    (hDom : forall omega,
      abs (traceExpIntegrand (randomMatrixSum X) theta omega) <= D omega) :
    IntegrableRealRandomVariable P (traceExpIntegrand (randomMatrixSum X) theta) :=
  traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider
    theta X D hChain hD hD_nonneg hDom

example
    (hChain :
      varianceProxyNormBound_of_centeredSquareChain_statement (P := P) X Kfam sigmaSq)
    (hExpansion : forall i,
      matrixSquare_centeredRandomMatrix_expectation_expansion_statement
        (P := P) (X i))
    (hLE : forall i,
      MatrixLE (matrixSecondMoment P (centeredRandomMatrix P (X i))) (Kfam i))
    (hNorm : deterministicMatrixVarianceProxyNorm (Finset.univ.sum fun i => Kfam i) <=
      sigmaSq) :
    MatrixVarianceProxyNormBound P (centeredRandomMatrixFamily P X) sigmaSq :=
  varianceProxyNormBound_of_centeredSquareChain
    X Kfam sigmaSq hChain hExpansion hLE hNorm

example : Prop :=
  traceMatrixExp_le_rank_exp_lambdaMax_statement B S rankBound

example : Prop :=
  traceMatrixExp_le_supportDim_exp_lambdaMax_statement B S supportDim

example : Prop :=
  traceMatrixExp_effectiveRank_bound_statement B theta sigmaSq effectiveRank

example
    (hc : 0 <= theta) (hsigma : 0 < sigmaSq)
    (hEff : 0 <= effectiveRank)
    (hPSD : IsPSDMatrix B)
    (hTrace : matrixTrace B <= effectiveRank * sigmaSq)
    (hB : IsSelfAdjointMatrix B)
    (hSpec : lambdaMaxOrdered B hB <= sigmaSq) :
    traceMatrixExp (theta • B) <=
      ((n + 1 : Nat) : Real) +
        effectiveRank * (Real.exp (theta * sigmaSq) - 1) := by
  have hStmt := traceMatrixExp_effectiveRank_bound B theta sigmaSq effectiveRank
  exact hStmt hc hsigma hEff hPSD hTrace hB hSpec

example
    (hc : 0 <= theta) (hsigma : 0 < sigmaSq)
    (hPSD : IsPSDMatrix B)
    (hB : IsSelfAdjointMatrix B)
    (hSpec : lambdaMaxOrdered B hB <= sigmaSq) :
    traceMatrixExp (theta • B) <=
      ((n + 1 : Nat) : Real) +
        ((n + 1 : Nat) : Real) * (Real.exp (theta * sigmaSq) - 1) :=
  traceMatrixExp_effectiveRank_bound_of_ambientTraceCertificate
    B theta sigmaSq hc hsigma hPSD hB hSpec

example :
    traceMatrixExp_le_rank_exp_lambdaMax_statement B S rankBound :=
  traceMatrixExp_le_rank_exp_lambdaMax B S rankBound

example :
    traceMatrixExp_le_supportDim_exp_lambdaMax_statement B S supportDim :=
  traceMatrixExp_le_supportDim_exp_lambdaMax B S supportDim

-- Proved scalar Bernstein leaf: the typed statement is now a proved theorem.
#check @scalarBernsteinExpQuadraticInequality

example :
    scalarBernsteinExpQuadraticInequality_statement theta R :=
  scalarBernsteinExpQuadraticInequality theta R

example :
    bernsteinCFCExpressionNormalization_statement A theta R :=
  bernsteinCFCExpressionNormalization A theta R

example :
    cfcScalarInequalityToMatrixLE_statement
      (fun x : Real => Real.exp (theta * x))
      (fun x : Real =>
        1 + theta * x + bernsteinMGFCoeff theta R * x ^ 2)
      A :=
  cfcScalarInequalityToMatrixLE_bernsteinExpQuadratic A theta R

example :
    selfAdjointSpectrumBoundedByOperatorNorm_statement A R :=
  selfAdjointSpectrumBoundedByOperatorNorm A R

example :
    bernsteinMatrixExp_le_quadratic_statement A theta R :=
  bernsteinMatrixExp_le_quadratic A theta R
