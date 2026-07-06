import HighDimProb.RandomMatrix.TailEventProviderAssumptionBridgeProvider

open MeasureTheory
open scoped BigOperators Matrix.Norms.L2Operator MatrixOrder

#check
  HighDimProb.matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFProviderAssumptions_tailSubsetDischarged_of_randomSelfAdjoint

example {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    (X : Fin m -> HighDimProb.RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (V : Matrix (Fin n) (Fin n) Real)
    (theta R t RH RZ RK RX : Real)
    (mHist : Fin m -> MeasurableSpace Omega)
    (hChain :
      @HighDimProb.troppConditionalStep_of_iIndepFun_statement Omega mOmega P m n
        theta X K mHist)
    (hSuffix :
      forall i : Fin m,
        forall j : Fin m,
          ((i.succ : Fin (m + 1)) : Nat) <= (j : Nat) ->
            forall r c,
              @Measurable Omega Real (mHist i) inferInstance
                (fun omega => X j omega r c))
    (hHistoryStepIndependent :
      @HighDimProb.troppHistoryStepIndependent_of_iIndepFun_statement Omega mOmega P m n
        theta X K)
    (hConditionalExpectation :
      forall i,
        @HighDimProb.condExp_traceExp_history_add_independent_step_statement
          Omega mOmega P n
          (mHist i) (@HighDimProb.troppStateHistory Omega mOmega m n theta X K i)
          (@HighDimProb.troppCurrentRandomStep Omega mOmega m n theta X i) (K i))
    (hHistorySub : forall i, mHist i <= mOmega)
    (hHistoryRandom :
      forall i,
        @HighDimProb.IsRandomMatrix Omega mOmega n n P
          (HighDimProb.troppStateHistory theta X K i))
    (hStepRandom :
      forall i,
        @HighDimProb.IsRandomMatrix Omega mOmega n n P
          (HighDimProb.troppCurrentRandomStep theta X i))
    (hHistorySelfAdjoint :
      forall i omega,
        HighDimProb.IsSelfAdjointMatrix (HighDimProb.troppStateHistory theta X K i omega))
    (hStepSelfAdjoint :
      forall i,
        @HighDimProb.RandomSelfAdjointMatrix Omega mOmega n P
          (HighDimProb.troppCurrentRandomStep theta X i))
    (hFiniteMeasure : IsFiniteMeasure P)
    (hHistoryOperatorNormBound :
      forall i omega,
        HighDimProb.operatorNorm
          (@HighDimProb.troppStateHistory Omega mOmega m n theta X K i) omega <= RH)
    (hStepOperatorNormBound :
      forall i omega,
        HighDimProb.operatorNorm
          (@HighDimProb.troppCurrentRandomStep Omega mOmega m n theta X i) omega <= RZ)
    (hKOperatorNormBound :
      forall i omega,
        HighDimProb.operatorNorm (fun _ : Omega => K i) omega <= RK)
    (hSummandOperatorNormBound :
      forall i omega, HighDimProb.operatorNorm (X i) omega <= RX)
    (hSummandRadiusNonneg : 0 <= RX)
    (hExpMeanSelfAdjoint :
      forall i,
        HighDimProb.IsSelfAdjointMatrix
          (@HighDimProb.matrixExpect Omega mOmega n n P
            (fun omega => HighDimProb.matrixExp (HighDimProb.troppCurrentRandomStep theta X i omega))))
    (hExpMeanStrictlyPositive :
      forall i,
        IsStrictlyPositive
          (@HighDimProb.matrixExpect Omega mOmega n n P
            (fun omega => HighDimProb.matrixExp (HighDimProb.troppCurrentRandomStep theta X i omega))))
    (hSigmaFiniteHistory : forall i, SigmaFinite (P.trim (hHistorySub i)))
    (hRandomMatrix : forall i, HighDimProb.IsRandomMatrix P (X i))
    (hSelfAdjoint : forall i, HighDimProb.RandomSelfAdjointMatrix P (X i))
    (hIndependent : ProbabilityTheory.iIndepFun X P)
    (hTraceIntegrable :
      HighDimProb.IntegrableRealRandomVariable P
        (HighDimProb.traceExpIntegrand (HighDimProb.randomMatrixSum X) theta))
    (hComparisonSelfAdjoint : forall i, HighDimProb.IsSelfAdjointMatrix (K i))
    (hVarianceProxySelfAdjoint : HighDimProb.IsSelfAdjointMatrix V)
    (hRadiusNonneg : 0 <= R)
    (hThetaRange : abs theta * R < 3)
    (hMGFComparison :
      forall i,
        HighDimProb.MatrixLE
          (HighDimProb.matrixExpect P
            (fun omega => HighDimProb.matrixExp (SMul.smul theta (X i omega))))
          (HighDimProb.matrixExp (K i)))
    (hVarianceProxyNormalization :
      Finset.univ.sum (fun i : Fin m => K i) =
        SMul.smul (HighDimProb.bernsteinMGFCoeff theta R) V)
    (hTailAEMeasurable :
      AEMeasurable
        (fun omega => ENNReal.ofReal
          (HighDimProb.traceExpIntegrand (HighDimProb.randomMatrixSum X) theta omega)) P)
    (hTheta : 0 <= theta) :
    P (HighDimProb.quadraticFormUpperTailEvent (HighDimProb.randomMatrixSum X) t) <=
      ENNReal.ofReal (Real.exp (-(theta * t))) *
        ENNReal.ofReal
          (HighDimProb.traceMatrixExp (SMul.smul (HighDimProb.bernsteinMGFCoeff theta R) V)) := by
  exact
    HighDimProb.matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFProviderAssumptions_tailSubsetDischarged_of_randomSelfAdjoint
      X K V theta R t RH RZ RK RX mHist
      hChain hSuffix hHistoryStepIndependent hConditionalExpectation
      hHistorySub hHistoryRandom hStepRandom hHistorySelfAdjoint hStepSelfAdjoint
      hFiniteMeasure hHistoryOperatorNormBound hStepOperatorNormBound
      hKOperatorNormBound hSummandOperatorNormBound hSummandRadiusNonneg
      hExpMeanSelfAdjoint hExpMeanStrictlyPositive hSigmaFiniteHistory
      hRandomMatrix hSelfAdjoint hIndependent hTraceIntegrable
      hComparisonSelfAdjoint hVarianceProxySelfAdjoint hRadiusNonneg
      hThetaRange hMGFComparison hVarianceProxyNormalization hTailAEMeasurable
      hTheta
