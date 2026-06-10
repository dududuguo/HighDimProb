import HighDimProb.RandomMatrix.Laplace

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega}
variable {n : Nat}
variable (Y : RandomMatrix Omega n n)
variable (V : Matrix (Fin n) (Fin n) Real)
variable (L : Omega -> Real)
variable (theta t rhs : Real)
variable (R : Real)
variable (hTheta : 0 <= theta)
variable (hRayleigh : forall omega, RayleighUpperBound (Y omega) (L omega))
variable (hUpper : forall omega, SpectralUpperBound (Y omega) (L omega))
variable (hTraceDom :
  forall omega, TraceExpDominatesUpperBound (Y omega) (L omega) theta)
variable (hMeas : AEMeasurable
  (fun omega => ENNReal.ofReal (traceExpIntegrand Y theta omega)) P)
variable (hSubset :
  quadraticFormUpperTailEvent Y t ⊆ traceExpThresholdEvent Y theta t)
variable (hDom : TraceExpDominatesQuadraticFormUpperTail Y theta t)
variable (hBernBound : TraceMGFBernsteinVarianceProxyBoundLIntegral P Y V theta R)

#check matrixLaplaceRHS
#check matrixLaplaceRHSLIntegral
#check traceExpThresholdEvent
#check TraceExpDominatesUpperBound
#check lambdaMaxOrdered_traceExpDominatesUpperBound
#check matrixUpperBoundTailEvent_subset_traceExpThresholdEvent_of_traceExpDominatesUpperBound
#check matrixLaplaceRHSLIntegralDiv
#check matrixLaplaceRHSLIntegralDiv_eq_matrixLaplaceRHSLIntegral
#check traceExpThresholdEvent_lintegral_bound
#check matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset
#check matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset
#check TraceExpDominatesQuadraticFormUpperTail
#check traceExpDominatesQuadraticFormUpperTailStatement
#check quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates
#check quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_rayleighUpperBound_of_traceExpDominatesUpperBound
#check quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_spectralUpperBound_of_traceExpDominatesUpperBound
#check traceExpDominatesQuadraticFormUpperTail_of_rayleighUpperBound_of_traceExpDominatesUpperBound
#check traceExpDominatesQuadraticFormUpperTail_of_spectralUpperBound_of_traceExpDominatesUpperBound
#check traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint
#check matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail
#check matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail
#check matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint
#check matrixLaplaceTransformLIntegral_of_randomSelfAdjoint
#check matrixLaplaceRHSLIntegral_le_of_traceMGFBernsteinVarianceProxyBoundLIntegral
#check quadraticFormUpperTail_laplace_bound_of_traceMGFBernsteinVarianceProxyBoundLIntegral
#check quadraticFormUpperTail_laplace_bound_of_traceMGFBernsteinVarianceProxyBoundLIntegral_statement
#check matrixLaplaceTransformStatement
#check matrixLaplaceTransformLIntegralStatement
#check matrixChernoffFromTraceExpStatement
#check matrixChernoffFromTraceExpLIntegralStatement
#check selfAdjointOperatorNormLaplaceRHSLIntegral
#check selfAdjointOperatorNormLaplaceStatement
#check selfAdjointOperatorNormLaplaceLIntegralStatement

#check (matrixLaplaceRHS P Y theta t : ENNReal)
#check (matrixLaplaceRHSLIntegral P Y theta t : ENNReal)
#check (traceExpThresholdEvent Y theta t : Set Omega)
#check (TraceExpDominatesUpperBound (n := n) :
  Matrix (Fin n) (Fin n) Real -> Real -> Real -> Prop)
#check (matrixUpperBoundTailEvent_subset_traceExpThresholdEvent_of_traceExpDominatesUpperBound
  Y L theta t hTheta hTraceDom :
    matrixUpperBoundTailEvent Y L t ⊆ traceExpThresholdEvent Y theta t)
#check (matrixLaplaceRHSLIntegralDiv P Y theta t : ENNReal)
#check (matrixLaplaceRHSLIntegralDiv_eq_matrixLaplaceRHSLIntegral Y theta t :
  matrixLaplaceRHSLIntegralDiv P Y theta t =
    matrixLaplaceRHSLIntegral P Y theta t)
#check (traceExpThresholdEvent_lintegral_bound Y theta t hMeas :
  P (traceExpThresholdEvent Y theta t) <=
    matrixLaplaceRHSLIntegral P Y theta t)
#check (matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset
  Y theta t hMeas hSubset :
    P (quadraticFormUpperTailEvent Y t) <=
      matrixLaplaceRHSLIntegralDiv P Y theta t)
#check (matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset
  Y theta t hMeas hSubset :
    P (quadraticFormUpperTailEvent Y t) <=
      matrixLaplaceRHSLIntegral P Y theta t)
#check (TraceExpDominatesQuadraticFormUpperTail Y theta t : Prop)
#check (traceExpDominatesQuadraticFormUpperTailStatement (P := P) Y theta t :
  Prop)
#check (quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates
  Y theta t hDom :
    quadraticFormUpperTailEvent Y t ⊆ traceExpThresholdEvent Y theta t)
#check (quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_rayleighUpperBound_of_traceExpDominatesUpperBound
  Y L theta t hTheta hRayleigh hTraceDom :
    quadraticFormUpperTailEvent Y t ⊆ traceExpThresholdEvent Y theta t)
#check (quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_spectralUpperBound_of_traceExpDominatesUpperBound
  Y L theta t hTheta hUpper hTraceDom :
    quadraticFormUpperTailEvent Y t ⊆ traceExpThresholdEvent Y theta t)
#check (traceExpDominatesQuadraticFormUpperTail_of_rayleighUpperBound_of_traceExpDominatesUpperBound
  Y L theta t hTheta hRayleigh hTraceDom :
    TraceExpDominatesQuadraticFormUpperTail Y theta t)
#check (traceExpDominatesQuadraticFormUpperTail_of_spectralUpperBound_of_traceExpDominatesUpperBound
  Y L theta t hTheta hUpper hTraceDom :
    TraceExpDominatesQuadraticFormUpperTail Y theta t)
#check (matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail
  Y theta t hMeas hDom :
    P (quadraticFormUpperTailEvent Y t) <=
      matrixLaplaceRHSLIntegralDiv P Y theta t)
#check (matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail
  Y theta t hMeas hDom :
    P (quadraticFormUpperTailEvent Y t) <=
      matrixLaplaceRHSLIntegral P Y theta t)
#check (matrixLaplaceRHSLIntegral_le_of_traceMGFBernsteinVarianceProxyBoundLIntegral
  Y V theta t R hBernBound :
    matrixLaplaceRHSLIntegral P Y theta t <=
      ENNReal.ofReal (Real.exp (-(theta * t))) *
        ENNReal.ofReal
          (traceMatrixExp (SMul.smul (bernsteinMGFCoeff theta R) V)))
#check (quadraticFormUpperTail_laplace_bound_of_traceMGFBernsteinVarianceProxyBoundLIntegral
  Y V theta t R hMeas hSubset hBernBound :
    P (quadraticFormUpperTailEvent Y t) <=
      ENNReal.ofReal (Real.exp (-(theta * t))) *
        ENNReal.ofReal
          (traceMatrixExp (SMul.smul (bernsteinMGFCoeff theta R) V)))
#check (quadraticFormUpperTail_laplace_bound_of_traceMGFBernsteinVarianceProxyBoundLIntegral_statement
  P Y V theta t R : Prop)
#check (matrixLaplaceTransformStatement P Y theta t : Prop)
#check (matrixLaplaceTransformLIntegralStatement P Y theta t : Prop)
#check (matrixChernoffFromTraceExpStatement P Y theta t rhs : Prop)
#check (matrixChernoffFromTraceExpLIntegralStatement P Y theta t
  (ENNReal.ofReal rhs) : Prop)
#check (selfAdjointOperatorNormLaplaceRHSLIntegral P Y theta t : ENNReal)
#check (selfAdjointOperatorNormLaplaceStatement P Y theta t : Prop)
#check (selfAdjointOperatorNormLaplaceLIntegralStatement P Y theta t : Prop)

example : matrixLaplaceRHS P Y theta t =
    ENNReal.ofReal (Real.exp (-(theta * t)) * traceExpMoment P Y theta) := by
  rfl

example : matrixLaplaceRHSLIntegral P Y theta t =
    ENNReal.ofReal (Real.exp (-(theta * t))) *
      traceExpMomentLIntegral P Y theta := by
  rfl

example : traceExpThresholdEvent Y theta t =
    {omega | ENNReal.ofReal (Real.exp (theta * t)) <=
      ENNReal.ofReal (traceExpIntegrand Y theta omega)} := by
  rfl

example {A : Matrix (Fin n) (Fin n) Real} {L0 theta0 : Real} :
    TraceExpDominatesUpperBound A L0 theta0 =
      (Real.exp (theta0 * L0) <= traceMatrixExp (theta0 • A)) := by
  rfl

example {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) :
    TraceExpDominatesUpperBound A (lambdaMaxOrdered A hA) theta := by
  exact lambdaMaxOrdered_traceExpDominatesUpperBound hA theta hTheta

example :
    matrixUpperBoundTailEvent Y L t ⊆ traceExpThresholdEvent Y theta t := by
  exact
    matrixUpperBoundTailEvent_subset_traceExpThresholdEvent_of_traceExpDominatesUpperBound
      Y L theta t hTheta hTraceDom

example : matrixLaplaceRHSLIntegralDiv P Y theta t =
    traceExpMomentLIntegral P Y theta /
      ENNReal.ofReal (Real.exp (theta * t)) := by
  rfl

example : TraceExpDominatesQuadraticFormUpperTail Y theta t =
    (quadraticFormUpperTailEvent Y t ⊆
      traceExpThresholdEvent Y theta t) := by
  rfl

example :
    P (traceExpThresholdEvent Y theta t) <=
      matrixLaplaceRHSLIntegral P Y theta t := by
  exact traceExpThresholdEvent_lintegral_bound Y theta t hMeas

example :
    P (quadraticFormUpperTailEvent Y t) <=
      matrixLaplaceRHSLIntegralDiv P Y theta t := by
  exact matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset
    Y theta t hMeas hSubset

example :
    P (quadraticFormUpperTailEvent Y t) <=
      matrixLaplaceRHSLIntegral P Y theta t := by
  exact matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset
    Y theta t hMeas hSubset

example :
    quadraticFormUpperTailEvent Y t ⊆
      traceExpThresholdEvent Y theta t := by
  exact quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates
    Y theta t hDom

example :
    quadraticFormUpperTailEvent Y t ⊆
      traceExpThresholdEvent Y theta t := by
  exact
    quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_rayleighUpperBound_of_traceExpDominatesUpperBound
      Y L theta t hTheta hRayleigh hTraceDom

example :
    quadraticFormUpperTailEvent Y t ⊆
      traceExpThresholdEvent Y theta t := by
  exact
    quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_spectralUpperBound_of_traceExpDominatesUpperBound
      Y L theta t hTheta hUpper hTraceDom

example :
    TraceExpDominatesQuadraticFormUpperTail Y theta t := by
  exact
    traceExpDominatesQuadraticFormUpperTail_of_rayleighUpperBound_of_traceExpDominatesUpperBound
      Y L theta t hTheta hRayleigh hTraceDom

example :
    TraceExpDominatesQuadraticFormUpperTail Y theta t := by
  exact
    traceExpDominatesQuadraticFormUpperTail_of_spectralUpperBound_of_traceExpDominatesUpperBound
      Y L theta t hTheta hUpper hTraceDom

example (Y : RandomMatrix Omega (n + 1) (n + 1))
    (hY : RandomSelfAdjointMatrix P Y) :
    TraceExpDominatesQuadraticFormUpperTail Y theta t := by
  exact
    traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint
      Y theta t hY hTheta

example :
    P (quadraticFormUpperTailEvent Y t) <=
      matrixLaplaceRHSLIntegralDiv P Y theta t := by
  exact matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail
    Y theta t hMeas hDom

example :
    P (quadraticFormUpperTailEvent Y t) <=
      matrixLaplaceRHSLIntegral P Y theta t := by
  exact matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail
    Y theta t hMeas hDom

example :
    matrixLaplaceRHSLIntegral P Y theta t <=
      ENNReal.ofReal (Real.exp (-(theta * t))) *
        ENNReal.ofReal
          (traceMatrixExp (SMul.smul (bernsteinMGFCoeff theta R) V)) := by
  exact
    matrixLaplaceRHSLIntegral_le_of_traceMGFBernsteinVarianceProxyBoundLIntegral
      Y V theta t R hBernBound

example :
    P (quadraticFormUpperTailEvent Y t) <=
      ENNReal.ofReal (Real.exp (-(theta * t))) *
        ENNReal.ofReal
          (traceMatrixExp (SMul.smul (bernsteinMGFCoeff theta R) V)) := by
  exact
    quadraticFormUpperTail_laplace_bound_of_traceMGFBernsteinVarianceProxyBoundLIntegral
      Y V theta t R hMeas hSubset hBernBound

example (Y : RandomMatrix Omega (n + 1) (n + 1))
    (hMeas : AEMeasurable
      (fun omega => ENNReal.ofReal (traceExpIntegrand Y theta omega)) P)
    (hY : RandomSelfAdjointMatrix P Y) :
    P (quadraticFormUpperTailEvent Y t) <=
      matrixLaplaceRHSLIntegralDiv P Y theta t := by
  exact
    matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint
      Y theta t hMeas hY hTheta

example (Y : RandomMatrix Omega (n + 1) (n + 1))
    (hMeas : AEMeasurable
      (fun omega => ENNReal.ofReal (traceExpIntegrand Y theta omega)) P)
    (hY : RandomSelfAdjointMatrix P Y) :
    P (quadraticFormUpperTailEvent Y t) <=
      matrixLaplaceRHSLIntegral P Y theta t := by
  exact
    matrixLaplaceTransformLIntegral_of_randomSelfAdjoint
      Y theta t hMeas hY hTheta
