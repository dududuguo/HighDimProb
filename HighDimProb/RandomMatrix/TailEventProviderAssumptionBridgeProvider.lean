import HighDimProb.RandomMatrix.ConcentrationStatements
import HighDimProb.RandomMatrix.TailEventDominationProvider

/-!
# Tail-event discharge for provider-assumption wrappers

This module proves a thin wrapper around the provider-assumption S10 consumer by
discharging only the bundled tail-event subset field from the existing
self-adjoint tail-event domination provider.

It does not prove conditioning, trace-MGF bounds, variance-proxy
normalization, theta optimization, or Matrix Bernstein.
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators Matrix.Norms.L2Operator MatrixOrder

noncomputable section

/-- Tail-subset-discharge wrapper for the provider-assumption S10 route.

This keeps the conditioning, trace-MGF, integrability, comparison, and
variance-proxy assumptions explicit. It removes only the bundled
`quadraticFormUpperTailEvent ⊆ traceExpThresholdEvent` field by synthesizing it
from the existing self-adjoint tail-event domination provider and the
self-adjointness of the random summands. -/
theorem
    matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFProviderAssumptions_tailSubsetDischarged_of_randomSelfAdjoint
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (V : Matrix (Fin n) (Fin n) Real)
    (theta R t RH RZ RK RX : Real)
    (mHist : Fin m -> MeasurableSpace Omega)
    (hChain :
      @troppConditionalStep_of_iIndepFun_statement Omega mOmega P m n
        theta X K mHist)
    (hSuffix :
      forall i : Fin m,
        forall j : Fin m,
          ((i.succ : Fin (m + 1)) : Nat) <= (j : Nat) ->
            forall r c,
              @Measurable Omega Real (mHist i) inferInstance
                (fun omega => X j omega r c))
    (hHistoryStepIndependent :
      @troppHistoryStepIndependent_of_iIndepFun_statement Omega mOmega P m n
        theta X K)
    (hConditionalExpectation :
      forall i,
        @condExp_traceExp_history_add_independent_step_statement
          Omega mOmega P n
          (mHist i) (@troppStateHistory Omega mOmega m n theta X K i)
          (@troppCurrentRandomStep Omega mOmega m n theta X i) (K i))
    (hHistorySub : forall i, mHist i <= mOmega)
    (hHistoryRandom :
      forall i,
        @IsRandomMatrix Omega mOmega n n P
          (troppStateHistory theta X K i))
    (hStepRandom :
      forall i,
        @IsRandomMatrix Omega mOmega n n P
          (troppCurrentRandomStep theta X i))
    (hHistorySelfAdjoint :
      forall i omega, IsSelfAdjointMatrix (troppStateHistory theta X K i omega))
    (hStepSelfAdjoint :
      forall i,
        @RandomSelfAdjointMatrix Omega mOmega n P
          (troppCurrentRandomStep theta X i))
    (hFiniteMeasure : IsFiniteMeasure P)
    (hHistoryOperatorNormBound :
      forall i omega,
        operatorNorm (@troppStateHistory Omega mOmega m n theta X K i) omega <= RH)
    (hStepOperatorNormBound :
      forall i omega,
        operatorNorm (@troppCurrentRandomStep Omega mOmega m n theta X i) omega <= RZ)
    (hKOperatorNormBound :
      forall i omega,
        operatorNorm (fun _ : Omega => K i) omega <= RK)
    (hSummandOperatorNormBound :
      forall i omega, operatorNorm (X i) omega <= RX)
    (hSummandRadiusNonneg : 0 <= RX)
    (hExpMeanSelfAdjoint :
      forall i,
        IsSelfAdjointMatrix
          (@matrixExpect Omega mOmega n n P
            (fun omega => matrixExp (troppCurrentRandomStep theta X i omega))))
    (hExpMeanStrictlyPositive :
      forall i,
        IsStrictlyPositive
          (@matrixExpect Omega mOmega n n P
            (fun omega => matrixExp (troppCurrentRandomStep theta X i omega))))
    (hSigmaFiniteHistory : forall i, SigmaFinite (P.trim (hHistorySub i)))
    (hRandomMatrix : forall i, IsRandomMatrix P (X i))
    (hSelfAdjoint : forall i, RandomSelfAdjointMatrix P (X i))
    (hIndependent : ProbabilityTheory.iIndepFun X P)
    (hTraceIntegrable :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum X) theta))
    (hComparisonSelfAdjoint : forall i, IsSelfAdjointMatrix (K i))
    (hVarianceProxySelfAdjoint : IsSelfAdjointMatrix V)
    (hRadiusNonneg : 0 <= R)
    (hThetaRange : abs theta * R < 3)
    (hMGFComparison :
      forall i,
        MatrixLE
          (matrixExpect P
            (fun omega => matrixExp (SMul.smul theta (X i omega))))
          (matrixExp (K i)))
    (hVarianceProxyNormalization :
      Finset.univ.sum (fun i : Fin m => K i) =
        SMul.smul (bernsteinMGFCoeff theta R) V)
    (hTailAEMeasurable :
      AEMeasurable
        (fun omega => ENNReal.ofReal
          (traceExpIntegrand (randomMatrixSum X) theta omega)) P)
    (hTheta : 0 <= theta) :
    P (quadraticFormUpperTailEvent (randomMatrixSum X) t) <=
      ENNReal.ofReal (Real.exp (-(theta * t))) *
        ENNReal.ofReal
          (traceMatrixExp (SMul.smul (bernsteinMGFCoeff theta R) V)) := by
  have hTailEventSubset :
      Set.Subset
        (quadraticFormUpperTailEvent (randomMatrixSum X) t)
        (traceExpThresholdEvent (randomMatrixSum X) theta t) := by
    cases n with
    | zero =>
        rw [quadraticFormUpperTailEvent_empty_of_zero_dim (randomMatrixSum X) t]
        intro omega hEvent
        cases hEvent
    | succ n =>
        simpa using
          quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint
            (Y := randomMatrixSum X) theta t (randomSelfAdjointMatrix_sum hSelfAdjoint) hTheta
  exact
    matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFProviderAssumptions
      X K V theta R t RH RZ RK RX mHist
      { chain := hChain
        suffixEntryMeasurable := hSuffix
        historyStepIndependent := hHistoryStepIndependent
        conditionalExpectation := hConditionalExpectation
        historySub := hHistorySub
        historyRandom := hHistoryRandom
        stepRandom := hStepRandom
        historySelfAdjoint := hHistorySelfAdjoint
        stepSelfAdjoint := hStepSelfAdjoint
        finiteMeasure := hFiniteMeasure
        historyOperatorNormBound := hHistoryOperatorNormBound
        stepOperatorNormBound := hStepOperatorNormBound
        kOperatorNormBound := hKOperatorNormBound
        summandOperatorNormBound := hSummandOperatorNormBound
        summandRadiusNonneg := hSummandRadiusNonneg
        expMeanSelfAdjoint := hExpMeanSelfAdjoint
        expMeanStrictlyPositive := hExpMeanStrictlyPositive
        sigmaFiniteHistory := hSigmaFiniteHistory
        randomMatrix := hRandomMatrix
        selfAdjoint := hSelfAdjoint
        independent := hIndependent
        traceIntegrable := hTraceIntegrable
        comparisonSelfAdjoint := hComparisonSelfAdjoint
        varianceProxySelfAdjoint := hVarianceProxySelfAdjoint
        radiusNonneg := hRadiusNonneg
        thetaRange := hThetaRange
        mgfComparison := hMGFComparison
        varianceProxyNormalization := hVarianceProxyNormalization
        tailAEMeasurable := hTailAEMeasurable
        tailEventSubset := hTailEventSubset }

end

end HighDimProb
