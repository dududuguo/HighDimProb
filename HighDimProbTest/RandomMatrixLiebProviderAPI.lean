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
#check cfcLogSelfAdjoint
#check CFCLog.Carrier
#check CFCLog.derivSAAt
#check CFCLog.lineDeriv
#check CFCLog.hasDerivAt_line
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
#check troppNaturalHistoryMeasurable_of_suffix_entry_measurable
#check troppHistoryStepIndependent_of_iIndepFun_of_measurable
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
