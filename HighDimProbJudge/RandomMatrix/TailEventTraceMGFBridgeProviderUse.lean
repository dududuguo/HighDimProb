import HighDimProb.RandomMatrix.TailEventTraceMGFBridgeProvider

open MeasureTheory
open scoped BigOperators Matrix.Norms.L2Operator MatrixOrder

#check
  HighDimProb.matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge_tailSubsetDischarged_of_randomSelfAdjoint

example {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    (X : Fin m -> HighDimProb.RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (V : Matrix (Fin n) (Fin n) Real)
    (theta R t : Real)
    (mHist : Fin m -> MeasurableSpace Omega)
    (hChain :
      @HighDimProb.troppConditionalStep_of_iIndepFun_statement Omega mOmega P m n
        theta X K mHist)
    (hHist :
      @HighDimProb.troppNaturalHistoryMeasurable_statement Omega mOmega m n
        theta X K mHist)
    (hHistIndep :
      @HighDimProb.troppHistoryStepIndependent_of_iIndepFun_statement Omega mOmega P m n
        theta X K)
    (hCondExp :
      forall i,
        @HighDimProb.condExp_traceExp_history_add_independent_step_statement
          Omega mOmega P n
          (mHist i) (@HighDimProb.troppStateHistory Omega mOmega m n theta X K i)
          (@HighDimProb.troppCurrentRandomStep Omega mOmega m n theta X i) (K i))
    (hHistSub : forall i, mHist i <= mOmega)
    (hHistRand :
      forall i,
        @HighDimProb.IsRandomMatrix Omega mOmega n n P
          (HighDimProb.troppStateHistory theta X K i))
    (hZRand :
      forall i,
        @HighDimProb.IsRandomMatrix Omega mOmega n n P
          (HighDimProb.troppCurrentRandomStep theta X i))
    (hHistSA :
      forall i omega, HighDimProb.IsSelfAdjointMatrix (HighDimProb.troppStateHistory theta X K i omega))
    (hZSA :
      forall i,
        @HighDimProb.RandomSelfAdjointMatrix Omega mOmega n P
          (HighDimProb.troppCurrentRandomStep theta X i))
    (hCondTraceInt :
      forall i,
        @HighDimProb.IntegrableRealRandomVariable Omega mOmega P
          (fun omega =>
            HighDimProb.traceMatrixExp
              (HighDimProb.troppStateHistory theta X K i omega +
                HighDimProb.troppCurrentRandomStep theta X i omega)))
    (hExpIntStep :
      forall i,
        @HighDimProb.IntegrableRandomMatrix Omega mOmega n n P
          (fun omega => HighDimProb.matrixExp (HighDimProb.troppCurrentRandomStep theta X i omega)))
    (hExpMeanSA :
      forall i,
        HighDimProb.IsSelfAdjointMatrix
          (@HighDimProb.matrixExpect Omega mOmega n n P
            (fun omega => HighDimProb.matrixExp (HighDimProb.troppCurrentRandomStep theta X i omega))))
    (hExpMeanPos :
      forall i,
        IsStrictlyPositive
          (@HighDimProb.matrixExpect Omega mOmega n n P
            (fun omega => HighDimProb.matrixExp (HighDimProb.troppCurrentRandomStep theta X i omega))))
    (hSigma : forall i, SigmaFinite (P.trim (hHistSub i)))
    (hRhsInt :
      forall i,
        @HighDimProb.IntegrableRealRandomVariable Omega mOmega P
          (fun omega =>
            HighDimProb.traceMatrixExp (HighDimProb.troppStateHistory theta X K i omega + K i)))
    (hRand : forall i, HighDimProb.IsRandomMatrix P (X i))
    (hSA : forall i, HighDimProb.RandomSelfAdjointMatrix P (X i))
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hExpInt :
      forall i,
        HighDimProb.IntegrableRandomMatrix P
          (fun omega => HighDimProb.matrixExp (SMul.smul theta (X i omega))))
    (hTraceInt :
      HighDimProb.IntegrableRealRandomVariable P
        (HighDimProb.traceExpIntegrand (HighDimProb.randomMatrixSum X) theta))
    (hKSA : forall i, HighDimProb.IsSelfAdjointMatrix (K i))
    (hVSA : HighDimProb.IsSelfAdjointMatrix V)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3)
    (hMGF :
      forall i,
        HighDimProb.MatrixLE
          (HighDimProb.matrixExpect P
            (fun omega => HighDimProb.matrixExp (SMul.smul theta (X i omega))))
          (HighDimProb.matrixExp (K i)))
    (hNorm :
      Finset.univ.sum (fun i : Fin m => K i) =
        SMul.smul (HighDimProb.bernsteinMGFCoeff theta R) V)
    (hTailMeas :
      AEMeasurable
        (fun omega => ENNReal.ofReal
          (HighDimProb.traceExpIntegrand (HighDimProb.randomMatrixSum X) theta omega)) P)
    (hTheta : 0 <= theta) :
    P (HighDimProb.quadraticFormUpperTailEvent (HighDimProb.randomMatrixSum X) t) <=
      ENNReal.ofReal (Real.exp (-(theta * t))) *
        ENNReal.ofReal
          (HighDimProb.traceMatrixExp (SMul.smul (HighDimProb.bernsteinMGFCoeff theta R) V)) := by
  exact
    HighDimProb.matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge_tailSubsetDischarged_of_randomSelfAdjoint
      X K V theta R t mHist
      hChain hHist hHistIndep hCondExp hHistSub hHistRand hZRand hHistSA hZSA
      hCondTraceInt hExpIntStep hExpMeanSA hExpMeanPos hSigma hRhsInt hRand hSA
      hIndep hExpInt hTraceInt hKSA hVSA hR hRange hMGF hNorm hTailMeas hTheta
