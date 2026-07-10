import HighDimProb.RandomMatrix.TailEventProviderAssumptionBridgeProvider

/-!
# Tail-event discharge for natural-state provider wrappers

This module proves a thin wrapper around the existing natural-state S16
consumer by discharging only the explicit tail-event subset premise through the
already proved provider-assumption tail-subset-discharge wrapper.

It does not prove conditioning, trace-MGF bounds, variance-proxy
normalization, theta optimization, or Matrix Bernstein.
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators Matrix.Norms.L2Operator MatrixOrder

noncomputable section

/-- Tail-subset-discharge wrapper for the natural-state provider S16 route.

This keeps the conditioning, trace-MGF, integrability, comparison, and
variance-proxy assumptions explicit. It removes only the final
`quadraticFormUpperTailEvent ⊆ traceExpThresholdEvent` premise by forwarding to
the existing provider-assumption tail-subset-discharge theorem. -/
theorem
    matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions_tailSubsetDischarged_of_randomSelfAdjoint
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
  exact
    matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFProviderAssumptions_tailSubsetDischarged_of_randomSelfAdjoint
      X K V theta R t RH RZ RK RX mHist
      hChain hSuffix hConditionalExpectation
      hHistorySub hHistoryRandom hStepRandom hHistorySelfAdjoint hStepSelfAdjoint
      hFiniteMeasure hHistoryOperatorNormBound hStepOperatorNormBound
      hKOperatorNormBound hSummandOperatorNormBound hSummandRadiusNonneg
      hExpMeanSelfAdjoint hExpMeanStrictlyPositive hSigmaFiniteHistory
      hRandomMatrix hSelfAdjoint hIndependent hTraceIntegrable
      hComparisonSelfAdjoint hVarianceProxySelfAdjoint hRadiusNonneg
      hThetaRange hMGFComparison hVarianceProxyNormalization hTailAEMeasurable
      hTheta

end

end HighDimProb
