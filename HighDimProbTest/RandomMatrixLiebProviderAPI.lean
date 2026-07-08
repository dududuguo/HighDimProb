import HighDimProb.RandomMatrix.LiebProvider
import HighDimProb.RandomMatrix.ConcentrationStatements

open MeasureTheory
open HighDimProb
open scoped MatrixOrder Matrix.Norms.Operator Matrix.Norms.L2Operator

#check operatorLogMonotoneOnPositiveMatrices
#check traceMatrixExp_mono_add_selfAdjoint
#check matrixExpFDeriv
#check hasFDerivAt_matrix_exp
#check hasStrictFDerivAt_matrix_exp
#check matrixExpSelfAdjoint
#check matrixExpFDerivSelfAdjoint
#check matrixExpFDerivSelfAdjoint_spectral_equiv
#check hasFDerivAt_matrix_exp_selfAdjoint
#check hasStrictFDerivAt_matrix_exp_selfAdjoint
#check matrixExpDividedDifferenceSeries
#check matrixExpDividedDifferenceSeries_pos
#check matrixExpDividedDifferenceSeries_ne_zero
#check matrixExpFDerivSelfAdjoint_diagonal_symm_entry_mul
#check trace_mul_matrixExpFDerivSelfAdjoint_conj_diagonal_symm_eq_sum
#check MatrixExpFDeriv.conjDiagonalSymmTraceSum
#check cfcLogSelfAdjoint
#check CFCLog.Carrier
#check CFCLog.derivSAAt
#check CFCLog.lineDeriv
#check CFCLog.hasDerivAt_line
#check CFCLog.derivSAAt_matrixExpSelfAdjoint_diagonal_entry_mul
#check CFCLog.diagonalDerivEntryMul
#check CFCLog.lineDerivSA_matrixExpSelfAdjoint_diagonal_entry_mul
#check CFCLog.diagonalLineDerivEntryMul
#check CFCLog.trace_mul_lineDerivSA_matrixExpSelfAdjoint_diagonal_eq_sum
#check CFCLog.diagonalLineDerivTraceSum
#check exists_hasDerivAt_cfcLog_affineLine_of_strictlyPositive
#check hasDerivAt_cfcLog_affineLine_of_strictlyPositive
#check hasDerivAt_inverse_affineLine
#check hasDerivAt_inverse_affineLine_of_strictlyPositive
#check trace_resolvent_derivative_cycle
#check neg_trace_resolvent_derivative_cycle
#check hasDerivAt_trace_mul_inverse_affineLine_general
#check hasDerivAt_trace_mul_inverse_affineLine_general_neg_cycle
#check hasDerivAt_trace_mul_inverse_affineLine_general_of_strictlyPositive
#check hasDerivAt_trace_mul_inverse_affineLine_general_neg_cycle_of_strictlyPositive
#check hasDerivAt_trace_mul_inverse_affineLine
#check hasDerivAt_trace_mul_inverse_affineLine_of_strictlyPositive
#check LogResolvent.kernelFixedSum
#check LogResolvent.kernelCutoffSum
#check LogResolvent.shiftedInvTraceSum
#check LogResolvent.identityCutoffSum
#check LogResolvent.identityCutoffTraceLogSub
#check LogResolvent.weightedCutoffSum
#check LogResolvent.weightedCutoffTraceLogSub
#check LogResolvent.weightedTraceLogEqShiftSubCutoff
#check LogResolvent.weightedShiftTraceLogSubScalarLog_tendsto_zero
#check LogResolvent.weightedCutoffSubScalarLog_tendsto_negTraceLog
#check LogResolvent.weightedShiftRemainderTendstoZero
#check LogResolvent.weightedCutoffRenormTendstoNegTraceLog
#check inv_quadraticForm_affine_le_of_posDef
#check inv_quadraticForm_iSup_affine_of_posDef
#check convexCombo_posDef_of_posDef
#check inv_quadraticForm_convex_combo_le_of_posDef
#check inv_matrixLE_convex_combo_le_of_posDef
#check RelativeEntropy.scalarTerm
#check RelativeEntropy.diagonalTerm
#check RelativeEntropy.diagonalMatrixTerm
#check RelativeEntropy.scalarTerm_nonneg
#check RelativeEntropy.diagonalTerm
#check RelativeEntropy.diagonalMatrixTerm_nonneg
#check kleinInequality_scalar_relativeEntropy_nonneg
#check kleinInequality_relativeEntropy_nonneg_diagonal
#check kleinInequality_relativeEntropy_nonneg_diagonal_matrix
#check RelativeEntropy.cfcLog_diagonal_eq_diagonal_log_of_pos
#check RelativeEntropy.trace_diagonal_mul_cfcLog_diagonal_eq_sum
#check RelativeEntropy.diagonalMatrixTerm_cfcLog_eq
#check RelativeEntropy.diagonalMatrixTerm_cfcLog_nonneg
#check kleinInequality_relativeEntropy_nonneg_diagonal_matrix_cfcLog
#check RelativeEntropy.commonEigenbasisWeight
#check RelativeEntropy.trace_mul_cfcLog_eq_sum_conj_diag_of_isHermitian
#check RelativeEntropy.trace_mul_cfcLog_eq_sum_commonEigenbasisWeight_of_isHermitian
#check RelativeEntropy.overlapWeight
#check RelativeEntropy.overlapWeight_nonneg
#check RelativeEntropy.commonEigenbasisWeight_self_eq_eigenvalue
#check RelativeEntropy.commonEigenbasisWeight_pos_of_isHermitian_of_isStrictlyPositive
#check RelativeEntropy.weightedSpectralKlein_nonneg
#check RelativeEntropy.overlapWeight_sum_right
#check RelativeEntropy.overlapWeight_sum_left
#check RelativeEntropy.commonEigenbasisWeight_eq_sum_overlapWeight_mul_eigenvalues
#check RelativeEntropy.trace_eq_sum_eigenvalues_of_isHermitian
#check RelativeEntropy.fullMatrixKlein_eq_weightedSpectralSum_of_isHermitian_of_strictlyPositive
#check RelativeEntropy.fullMatrixKlein_nonneg_of_isHermitian_of_strictlyPositive
#check RelativeEntropy.kleinInequality_relativeEntropy_nonneg
#check kleinInequality_relativeEntropy_nonneg
#check gibbsObjective_le_traceMatrixExp_of_kleinPremise
#check gibbsObjective_eq_traceMatrixExp_at_matrixExp
#check RelativeEntropy.relativeEntropyUnnormalized
#check RelativeEntropy.gibbsObjective
#check RelativeEntropy.logShift
#check RelativeEntropy.expLogMatrix
#check RelativeEntropy.gibbsObjective_eq_trace_shift_sub_relativeEntropy
#check RelativeEntropy.expLogWitness
#check RelativeEntropy.expLogWitness_mem_selfAdjointStrictlyPositiveSet
#check RelativeEntropy.carrierGibbs_le_traceMatrixExp_of_kleinPremise
#check RelativeEntropy.carrierGibbs_eq_traceMatrixExp_at_matrixExp_logPoint
#check RelativeEntropy.gibbsObjective_eq_traceMatrixExp_at_expLogWitness
#check RelativeEntropyJointConvexity
#check GibbsVariationalUpperBoundPremise
#check liebTraceExpConcavity_selfAdjointCarrier_of_relativeEntropyJointConvexity_and_gibbsUpperBoundPremise
#check epsteinAffineLineConcavity_of_relativeEntropyJointConvexity_and_gibbsUpperBoundPremise
#check gibbsVariationalUpperBoundPremise_of_gibbsKleinPremise
#check epsteinAffineLineConcavity_of_relativeEntropyJointConvexity_and_gibbsKleinPremise
#check gibbsKleinPremise_of_fullMatrixKlein
#check gibbsVariationalUpperBoundPremise_of_fullMatrixKlein
#check epsteinAffineLineConcavity_of_relativeEntropyJointConvexity_and_fullMatrixKlein
#check RelativeEntropy.fullKlein_liebCarrierConcavity
#check RelativeEntropy.fullKlein_liebConcavity
#check RelativeEntropy.fullKlein_epsteinConcavity
#check RelativeEntropy.fullKlein_liebCarrierConcavity_of_leftRight
#check RelativeEntropy.fullKlein_liebConcavity_of_leftRight
#check RelativeEntropy.fullKlein_epsteinConcavity_of_leftRight
#check liebTraceExpConcavity_statement_of_leftRight
#check epsteinAffineLineConcavity_of_leftRight

example : GibbsKleinPremise :=
  gibbsKleinPremise_of_fullMatrixKlein

example : GibbsVariationalUpperBoundPremise :=
  gibbsVariationalUpperBoundPremise_of_fullMatrixKlein

example (hRE : RelativeEntropyJointConvexity) : EpsteinAffineLineConcavity :=
  RelativeEntropy.fullKlein_epsteinConcavity hRE
#check epsteinAffineLineConcavity_of_liebTraceExpConcavity_selfAdjointCarrier
#check cfcLogLineDerivTraceSecond
#check EpsteinLine.traceSlope
#check EpsteinLine.traceSecond
#check EpsteinLine.hasDerivAt_traceSlope
#check EpsteinLine.hasDerivAt_traceSlope_of_lineDerivSA
#check EpsteinLine.hasDerivAt_traceSlope_of_hasDerivAt_eval
#check EpsteinLine.concavity_of_traceSecond_nonpos
#check EpsteinLine.concavity_of_traceSecond_nonpos_of_lineDerivSA
#check EpsteinLine.concavity_of_traceSecond_nonpos_of_eval
#check epsteinAffineLineConcavity_of_cfcLog_hasDerivAt_traceDerivative_nonpos
#check epsteinAffineLineConcavity_of_cfcLog_lineDeriv_traceDerivative_nonpos
#check epsteinAffineLineConcavity_of_cfcLogLineDerivTraceSecond_nonpos
#check troppLogExpComparisonToK_of_providerLogOrder
#check EpsteinAffineLineConcavity
#check liebTraceExpConcavity_of_epsteinAffineLine
#check liebJensenTraceExp_statement_of_epsteinAffineLine
#check troppMasterTraceMGFStep_of_epsteinAffineLine
#check troppMasterTraceMGFStep_trace_bound_of_epsteinAffineLine_and_providerLogOrder
#check troppMasterTraceMGFStep_of_leftRight
#check troppMasterTraceMGFStep_trace_bound_of_leftRight_and_providerLogOrder
#check troppNaturalHistoryMeasurable_of_suffix_entry_measurable
#check troppHistoryStepIndependent_of_iIndepFun_of_measurable
#check TroppNaturalHistory.suffixMeasurable
#check TroppNaturalHistory.historyStepIndependent
#check matrixExpScaledIntegrable_of_provider_finiteMeasure
#check traceExpIntegrable_troppStateHistory_add_step_of_operatorNormBounds_finiteMeasure
#check traceExpIntegrable_troppStateHistory_add_K_of_operatorNormBounds_finiteMeasure
#check troppCurrentRandomStep_operatorNorm_le_of_summand_bound
#check troppStateHistory_operatorNorm_le_of_summand_and_comparison_bounds
#check traceExpIntegrable_troppStateHistory_add_step_of_summand_and_comparison_bounds_finiteMeasure
#check traceExpIntegrable_troppStateHistory_add_K_of_summand_and_comparison_bounds_finiteMeasure

example {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (theta RX : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (hXBound : forall j omega, operatorNorm (X j) omega <= RX) :
    forall i omega,
      operatorNorm (@troppCurrentRandomStep Omega _ m n theta X i) omega <= abs theta * RX := by
  exact troppCurrentRandomStep_operatorNorm_le_of_summand_bound theta RX X hXBound

example {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (theta RX RK : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (hRX : 0 <= RX) (hRK : 0 <= RK)
    (hXBound : forall j omega, operatorNorm (X j) omega <= RX)
    (hKBound : forall j, deterministicOperatorNorm (K j) <= RK) :
    forall i omega,
      operatorNorm (@troppStateHistory Omega _ m n theta X K i) omega <=
        m * RK + m * (abs theta * RX) := by
  exact troppStateHistory_operatorNorm_le_of_summand_and_comparison_bounds
    theta RX RK X K hRX hRK hXBound hKBound

example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} [IsFiniteMeasure P]
    {m n : Nat} (theta RX RK : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (hHist : forall i, IsRandomMatrix P (@troppStateHistory Omega _ m n theta X K i))
    (hStep : forall i, IsRandomMatrix P (@troppCurrentRandomStep Omega _ m n theta X i))
    (hRX : 0 <= RX) (hRK : 0 <= RK)
    (hXBound : forall j omega, operatorNorm (X j) omega <= RX)
    (hKBound : forall j, deterministicOperatorNorm (K j) <= RK) :
    forall i,
      IntegrableRealRandomVariable P
        (fun omega =>
          traceMatrixExp
            (@troppStateHistory Omega _ m n theta X K i omega +
              @troppCurrentRandomStep Omega _ m n theta X i omega)) := by
  exact traceExpIntegrable_troppStateHistory_add_step_of_summand_and_comparison_bounds_finiteMeasure
    (P := P) theta RX RK X K hHist hStep hRX hRK hXBound hKBound

example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} [IsFiniteMeasure P]
    {m n : Nat} (theta RX RK : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (hHist : forall i, IsRandomMatrix P (@troppStateHistory Omega _ m n theta X K i))
    (hRX : 0 <= RX) (hRK : 0 <= RK)
    (hXBound : forall j omega, operatorNorm (X j) omega <= RX)
    (hKBound : forall j, deterministicOperatorNorm (K j) <= RK) :
    forall i,
      IntegrableRealRandomVariable P
        (fun omega =>
          traceMatrixExp
            (@troppStateHistory Omega _ m n theta X K i omega + K i)) := by
  exact traceExpIntegrable_troppStateHistory_add_K_of_summand_and_comparison_bounds_finiteMeasure
    (P := P) theta RX RK X K hHist hRX hRK hXBound hKBound
#check matrixExpSupportDomination_identity
#check lambdaMaxOrdered_le_of_matrixLE_selfAdjoint
#check lambdaMinOrdered_le_of_matrixLE_selfAdjoint
#check traceMGFBernsteinVarianceProxyBoundLIntegral_of_real
#check matrixBernsteinTraceMGFToLaplaceContract
#check matrixBernsteinTraceMGFToLaplaceContract_under_primitives
#check MatrixBernsteinConditioningTraceMGFProviderAssumptions
#check MatrixBernsteinConditioningTraceMGFProviderAssumptions.toTailAssumptions
#check matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFProviderAssumptions
#check matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions
