import HighDimProb.RandomMatrix.TraceExp
import HighDimProb.RandomMatrix.TailEventTraceMGFBridgeProvider

/-!
# Natural Tropp pipeline usage

This examples-only file shows the new natural-state Tropp route at the
TraceExp layer. It demonstrates the canonical prefix/suffix state endpoints and
checks the provider names without introducing application-specific assumptions.

The route still keeps the conditional-step analytic primitive, history
measurability, independence, trace-exp integrability, log/K comparison, CFC, and
variance-proxy inputs explicit in core theorem signatures.

The final example shows the same consumer route for an arbitrary user-supplied
history sigma-algebra family, not only the generated natural history.
-/

namespace HighDimProb.Examples.RandomMatrix.NaturalTroppPipelineUsage

open MeasureTheory
open scoped MatrixOrder

noncomputable section

/-- The natural trace state starts at the full scaled random sum. -/
theorem naturalTropp_traceState_zero_usage {Omega : Type*}
    [MeasurableSpace Omega] {m n : Nat} (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real) :
    troppTraceState theta X K 0 =
      fun omega =>
        traceMatrixExp
          (randomMatrixSum (scaledRandomMatrixFamily theta X) omega) := by
  exact troppNaturalState_zero theta X K

/-- The natural trace state ends at the full deterministic comparison sum. -/
theorem naturalTropp_traceState_last_usage {Omega : Type*}
    [MeasurableSpace Omega] {m n : Nat} (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real) :
    troppTraceState theta X K (Fin.last m) =
      fun _omega : Omega =>
        traceMatrixExp (Finset.univ.sum fun i : Fin m => K i) := by
  exact troppNaturalState_last theta X K

/-- The left adjacent state is the natural history plus the current random step. -/
theorem naturalTropp_traceState_left_usage {Omega : Type*}
    [MeasurableSpace Omega] {m n : Nat} (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real) (i : Fin m) :
    troppStateLeft theta X K i =
      fun omega =>
        traceMatrixExp
          (troppStateHistory theta X K i omega +
            troppCurrentRandomStep theta X i omega) := by
  exact troppNaturalState_left theta X K i

/-- The right adjacent state is the natural history plus the current comparison step. -/
theorem naturalTropp_traceState_right_usage {Omega : Type*}
    [MeasurableSpace Omega] {m n : Nat} (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real) (i : Fin m) :
    troppStateRight theta X K i =
      fun omega =>
        traceMatrixExp
          (troppStateHistory theta X K i omega +
            troppCurrentComparisonStep K i) := by
  exact troppNaturalState_right theta X K i

/-- Arbitrary-history quadratic-form Bernstein tail usage.

This example is intentionally not a product-space coordinate model. The history
family `mHist` is supplied by the user. Once the user provides the explicit
conditioning, measurability, independence, integrability, and comparison
premises for that history, the same TailEvent bridge discharges the final
quadratic-form-to-trace-exp subset premise under random self-adjointness. -/
theorem arbitraryHistory_quadraticForm_tail_usage
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
  exact
    matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge_tailSubsetDischarged_of_randomSelfAdjoint
      X K V theta R t mHist
      hChain hHist hHistIndep hCondExp hHistSub hHistRand hZRand hHistSA hZSA
      hCondTraceInt hExpIntStep hExpMeanSA hExpMeanPos hSigma hRhsInt hRand hSA
      hIndep hExpInt hTraceInt hKSA hVSA hR hRange hMGF hNorm hTailMeas hTheta

end

end HighDimProb.Examples.RandomMatrix.NaturalTroppPipelineUsage
