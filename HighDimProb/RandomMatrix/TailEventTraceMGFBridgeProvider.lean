import HighDimProb.RandomMatrix.ConcentrationStatements
import HighDimProb.RandomMatrix.ConditioningBernsteinTraceExpProvider
import HighDimProb.RandomMatrix.TailEventDominationProvider

/-!
# Tail-event to trace-MGF bridge provider

This module proves a thin wrapper around the existing conditioning trace-MGF to
tail consumer by discharging only the explicit tail-event subset premise from
the existing self-adjoint tail-event domination provider.

It does not prove conditioning, trace-MGF bounds, variance-proxy
normalization, theta optimization, or Matrix Bernstein.
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators Matrix.Norms.L2Operator MatrixOrder

noncomputable section

/-- Tail-subset-discharge wrapper for the conditioning trace-MGF to
quadratic-form tail bridge.

This keeps the conditioning, trace-MGF, integrability, comparison, and
variance-proxy assumptions explicit. It removes only the final
`quadraticFormUpperTailEvent ⊆ traceExpThresholdEvent` premise by synthesizing
it from the existing self-adjoint tail-event domination provider and the
self-adjointness of the random summands. -/
theorem
    matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge_tailSubsetDischarged_of_randomSelfAdjoint
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (V : Matrix (Fin n) (Fin n) Real)
    (theta R t : Real)
    (mHist : Fin m -> MeasurableSpace Omega)
    (hChain :
      @troppConditionalStep_of_iIndepFun_statement Omega mOmega P m n
        theta X K mHist)
    (hHist :
      @troppNaturalHistoryMeasurable_statement Omega mOmega m n
        theta X K mHist)
    (hHistIndep :
      @troppHistoryStepIndependent_of_iIndepFun_statement Omega mOmega P m n
        theta X K)
    (hCondExp :
      forall i,
        @condExp_traceExp_history_add_independent_step_statement
          Omega mOmega P n
          (mHist i) (@troppStateHistory Omega mOmega m n theta X K i)
          (@troppCurrentRandomStep Omega mOmega m n theta X i) (K i))
    (hHistSub : forall i, mHist i <= mOmega)
    (hHistRand :
      forall i,
        @IsRandomMatrix Omega mOmega n n P
          (troppStateHistory theta X K i))
    (hZRand :
      forall i,
        @IsRandomMatrix Omega mOmega n n P
          (troppCurrentRandomStep theta X i))
    (hHistSA :
      forall i omega, IsSelfAdjointMatrix (troppStateHistory theta X K i omega))
    (hZSA :
      forall i,
        @RandomSelfAdjointMatrix Omega mOmega n P
          (troppCurrentRandomStep theta X i))
    (hCondTraceInt :
      forall i,
        @IntegrableRealRandomVariable Omega mOmega P
          (fun omega =>
            traceMatrixExp
              (troppStateHistory theta X K i omega +
                troppCurrentRandomStep theta X i omega)))
    (hExpIntStep :
      forall i,
        @IntegrableRandomMatrix Omega mOmega n n P
          (fun omega => matrixExp (troppCurrentRandomStep theta X i omega)))
    (hExpMeanSA :
      forall i,
        IsSelfAdjointMatrix
          (@matrixExpect Omega mOmega n n P
            (fun omega => matrixExp (troppCurrentRandomStep theta X i omega))))
    (hExpMeanPos :
      forall i,
        IsStrictlyPositive
          (@matrixExpect Omega mOmega n n P
            (fun omega => matrixExp (troppCurrentRandomStep theta X i omega))))
    (hSigma : forall i, SigmaFinite (P.trim (hHistSub i)))
    (hRhsInt :
      forall i,
        @IntegrableRealRandomVariable Omega mOmega P
          (fun omega =>
            traceMatrixExp (troppStateHistory theta X K i omega + K i)))
    (hRand : forall i, IsRandomMatrix P (X i))
    (hSA : forall i, RandomSelfAdjointMatrix P (X i))
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hExpInt :
      forall i,
        IntegrableRandomMatrix P
          (fun omega => matrixExp (SMul.smul theta (X i omega))))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum X) theta))
    (hKSA : forall i, IsSelfAdjointMatrix (K i))
    (hVSA : IsSelfAdjointMatrix V)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3)
    (hMGF :
      forall i,
        MatrixLE
          (matrixExpect P
            (fun omega => matrixExp (SMul.smul theta (X i omega))))
          (matrixExp (K i)))
    (hNorm :
      Finset.univ.sum (fun i : Fin m => K i) =
        SMul.smul (bernsteinMGFCoeff theta R) V)
    (hTailMeas :
      AEMeasurable
        (fun omega => ENNReal.ofReal
          (traceExpIntegrand (randomMatrixSum X) theta omega)) P)
    (hTheta : 0 <= theta) :
    P (quadraticFormUpperTailEvent (randomMatrixSum X) t) <=
      ENNReal.ofReal (Real.exp (-(theta * t))) *
        ENNReal.ofReal
          (traceMatrixExp (SMul.smul (bernsteinMGFCoeff theta R) V)) := by
  have hTailSubset :
      quadraticFormUpperTailEvent (randomMatrixSum X) t ⊆
        traceExpThresholdEvent (randomMatrixSum X) theta t := by
    cases n with
    | zero =>
        rw [quadraticFormUpperTailEvent_empty_of_zero_dim (randomMatrixSum X) t]
        intro omega hEvent
        cases hEvent
    | succ n =>
        simpa using
          quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint
            (Y := randomMatrixSum X) theta t (randomSelfAdjointMatrix_sum hSA) hTheta
  exact
    matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge
      X K V theta R t mHist
      hChain hHist hHistIndep hCondExp hHistSub hHistRand hZRand hHistSA hZSA
      hCondTraceInt hExpIntStep hExpMeanSA hExpMeanPos hSigma hRhsInt hRand hSA
      hIndep hExpInt hTraceInt hKSA hVSA hR hRange hMGF hNorm hTailMeas
      hTailSubset

/-- Quadratic-form upper-tail Laplace bound from Bernstein primitives with the
tail-event subset bridge discharged by self-adjointness.

This is a thin wrapper around
`matrixBernsteinQuadraticFormUpperTail_generatedHistory_of_bernsteinPrimitives`.
It still leaves tail-side measurability explicit, but no longer asks callers to
provide the event-subset bridge separately. -/
theorem matrixBernsteinQuadraticFormUpperTail_generatedHistory_of_bernsteinPrimitives_tailSubsetDischarged_of_randomSelfAdjoint
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (theta t R : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P X)
    (hIndepSA : IndependentSelfAdjointRandomMatrices P X)
    (hIntX : forall j, IntegrableRandomMatrix P (X j))
    (hIntSq : forall j, IntegrableRandomMatrix P (randomMatrixSquare (X j)))
    (hBound : PointwiseOperatorNormBound X R)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3)
    (hTailMeas :
      AEMeasurable
        (fun omega => ENNReal.ofReal
          (traceExpIntegrand (randomMatrixSum X) theta omega)) P)
    (hTheta : 0 <= theta) :
    P (quadraticFormUpperTailEvent (randomMatrixSum X) t) <=
      ENNReal.ofReal (Real.exp (-(theta * t))) *
        ENNReal.ofReal
          (traceMatrixExp
            (SMul.smul (bernsteinMGFCoeff theta R) (matrixVarianceProxy P X))) := by
  have hSA : forall j, RandomSelfAdjointMatrix P (X j) := hCentered.1.2
  have hTailSubset :
      quadraticFormUpperTailEvent (randomMatrixSum X) t ⊆
        traceExpThresholdEvent (randomMatrixSum X) theta t := by
    cases n with
    | zero =>
        rw [quadraticFormUpperTailEvent_empty_of_zero_dim (randomMatrixSum X) t]
        intro omega hEvent
        cases hEvent
    | succ n =>
        simpa using
          quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_randomSelfAdjoint
            (Y := randomMatrixSum X) theta t (randomSelfAdjointMatrix_sum hSA) hTheta
  exact
    matrixBernsteinQuadraticFormUpperTail_generatedHistory_of_bernsteinPrimitives
      (mOmega := mOmega) (P := P) theta t R X
      hCentered hIndepSA hIntX hIntSq hBound hR hRange hTailMeas hTailSubset

end

end HighDimProb
