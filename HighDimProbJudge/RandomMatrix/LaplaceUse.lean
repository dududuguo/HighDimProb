import HighDimProb.RandomMatrix

open MeasureTheory

#check HighDimProb.matrixLaplaceRHS
#check HighDimProb.matrixLaplaceRHSLIntegral
#check HighDimProb.traceExpThresholdEvent
#check HighDimProb.TraceExpDominatesUpperBound
#check HighDimProb.lambdaMaxOrdered_traceExpDominatesUpperBound
#check HighDimProb.matrixUpperBoundTailEvent_subset_traceExpThresholdEvent_of_traceExpDominatesUpperBound
#check HighDimProb.matrixLaplaceRHSLIntegralDiv
#check HighDimProb.matrixLaplaceRHSLIntegralDiv_eq_matrixLaplaceRHSLIntegral
#check HighDimProb.traceExpThresholdEvent_lintegral_bound
#check HighDimProb.matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset
#check HighDimProb.matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset
#check HighDimProb.TraceExpDominatesQuadraticFormUpperTail
#check HighDimProb.traceExpDominatesQuadraticFormUpperTailStatement
#check HighDimProb.quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates
#check HighDimProb.quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_rayleighUpperBound_of_traceExpDominatesUpperBound
#check HighDimProb.quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_spectralUpperBound_of_traceExpDominatesUpperBound
#check HighDimProb.traceExpDominatesQuadraticFormUpperTail_of_rayleighUpperBound_of_traceExpDominatesUpperBound
#check HighDimProb.traceExpDominatesQuadraticFormUpperTail_of_spectralUpperBound_of_traceExpDominatesUpperBound
#check HighDimProb.traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint
#check HighDimProb.matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail
#check HighDimProb.matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail
#check HighDimProb.matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint
#check HighDimProb.matrixLaplaceTransformLIntegral_of_randomSelfAdjoint
#check HighDimProb.matrixLaplaceRHSLIntegral_le_of_traceMGFBernsteinVarianceProxyBoundLIntegral
#check HighDimProb.quadraticFormUpperTail_laplace_bound_of_traceMGFBernsteinVarianceProxyBoundLIntegral
#check HighDimProb.quadraticFormUpperTail_laplace_bound_of_traceMGFBernsteinVarianceProxyBoundLIntegral_statement
#check HighDimProb.matrixLaplaceTransformStatement
#check HighDimProb.matrixLaplaceTransformLIntegralStatement
#check HighDimProb.matrixChernoffFromTraceExpStatement
#check HighDimProb.matrixChernoffFromTraceExpLIntegralStatement
#check HighDimProb.selfAdjointOperatorNormLaplaceRHSLIntegral
#check HighDimProb.selfAdjointOperatorNormLaplaceStatement
#check HighDimProb.selfAdjointOperatorNormLaplaceLIntegralStatement

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta t : Real) :
    HighDimProb.matrixLaplaceRHS P Y theta t =
      ENNReal.ofReal
        (Real.exp (-(theta * t)) *
          HighDimProb.traceExpMoment P Y theta) := by
  rfl

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta t : Real) :
    HighDimProb.matrixLaplaceRHSLIntegral P Y theta t =
      ENNReal.ofReal (Real.exp (-(theta * t))) *
        HighDimProb.traceExpMomentLIntegral P Y theta := by
  rfl

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (Y : HighDimProb.RandomMatrix Omega n n) (theta t : Real) :
    HighDimProb.traceExpThresholdEvent Y theta t =
      {omega | ENNReal.ofReal (Real.exp (theta * t)) <=
        ENNReal.ofReal (HighDimProb.traceExpIntegrand Y theta omega)} := by
  rfl

example {n : Nat} {A : Matrix (Fin n) (Fin n) Real} {L theta : Real} :
    HighDimProb.TraceExpDominatesUpperBound A L theta =
      (Real.exp (theta * L) <= HighDimProb.traceMatrixExp (theta • A)) := by
  rfl

example {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : HighDimProb.IsSelfAdjointMatrix A)
    (theta : Real) (hTheta : 0 <= theta) :
    HighDimProb.TraceExpDominatesUpperBound A
      (HighDimProb.lambdaMaxOrdered A hA) theta := by
  exact HighDimProb.lambdaMaxOrdered_traceExpDominatesUpperBound hA theta hTheta

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (Y : HighDimProb.RandomMatrix Omega n n) (L : Omega -> Real)
    (theta t : Real) (hTheta : 0 <= theta)
    (hDom : forall omega,
      HighDimProb.TraceExpDominatesUpperBound (Y omega) (L omega) theta) :
    HighDimProb.matrixUpperBoundTailEvent Y L t ⊆
      HighDimProb.traceExpThresholdEvent Y theta t := by
  exact
    HighDimProb.matrixUpperBoundTailEvent_subset_traceExpThresholdEvent_of_traceExpDominatesUpperBound
      Y L theta t hTheta hDom

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta t : Real) :
    HighDimProb.matrixLaplaceRHSLIntegralDiv P Y theta t =
      HighDimProb.traceExpMomentLIntegral P Y theta /
        ENNReal.ofReal (Real.exp (theta * t)) := by
  rfl

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (Y : HighDimProb.RandomMatrix Omega n n) (theta t : Real) :
    HighDimProb.TraceExpDominatesQuadraticFormUpperTail Y theta t =
      (HighDimProb.quadraticFormUpperTailEvent Y t ⊆
        HighDimProb.traceExpThresholdEvent Y theta t) := by
  rfl

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta t : Real) : Prop :=
  HighDimProb.traceExpDominatesQuadraticFormUpperTailStatement
    (P := P) Y theta t

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta t : Real)
    (hMeas : AEMeasurable
      (fun omega =>
        ENNReal.ofReal (HighDimProb.traceExpIntegrand Y theta omega)) P) :
    P (HighDimProb.traceExpThresholdEvent Y theta t) <=
      HighDimProb.matrixLaplaceRHSLIntegral P Y theta t := by
  exact HighDimProb.traceExpThresholdEvent_lintegral_bound Y theta t hMeas

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta t : Real)
    (hMeas : AEMeasurable
      (fun omega =>
        ENNReal.ofReal (HighDimProb.traceExpIntegrand Y theta omega)) P)
    (hSubset :
      HighDimProb.quadraticFormUpperTailEvent Y t ⊆
        HighDimProb.traceExpThresholdEvent Y theta t) :
    P (HighDimProb.quadraticFormUpperTailEvent Y t) <=
      HighDimProb.matrixLaplaceRHSLIntegralDiv P Y theta t := by
  exact
    HighDimProb.matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset
      Y theta t hMeas hSubset

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta t : Real)
    (hMeas : AEMeasurable
      (fun omega =>
        ENNReal.ofReal (HighDimProb.traceExpIntegrand Y theta omega)) P)
    (hSubset :
      HighDimProb.quadraticFormUpperTailEvent Y t ⊆
        HighDimProb.traceExpThresholdEvent Y theta t) :
    P (HighDimProb.quadraticFormUpperTailEvent Y t) <=
      HighDimProb.matrixLaplaceRHSLIntegral P Y theta t := by
  exact
    HighDimProb.matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset
      Y theta t hMeas hSubset

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (Y : HighDimProb.RandomMatrix Omega n n) (theta t : Real)
    (hDom : HighDimProb.TraceExpDominatesQuadraticFormUpperTail Y theta t) :
    HighDimProb.quadraticFormUpperTailEvent Y t ⊆
      HighDimProb.traceExpThresholdEvent Y theta t := by
  exact
    HighDimProb.quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates
      Y theta t hDom

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (Y : HighDimProb.RandomMatrix Omega n n) (L : Omega -> Real)
    (theta t : Real) (hTheta : 0 <= theta)
    (hRayleigh : forall omega,
      HighDimProb.RayleighUpperBound (Y omega) (L omega))
    (hDom : forall omega,
      HighDimProb.TraceExpDominatesUpperBound (Y omega) (L omega) theta) :
    HighDimProb.quadraticFormUpperTailEvent Y t ⊆
      HighDimProb.traceExpThresholdEvent Y theta t := by
  exact
    HighDimProb.quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_rayleighUpperBound_of_traceExpDominatesUpperBound
      Y L theta t hTheta hRayleigh hDom

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (Y : HighDimProb.RandomMatrix Omega n n) (L : Omega -> Real)
    (theta t : Real) (hTheta : 0 <= theta)
    (hUpper : forall omega,
      HighDimProb.SpectralUpperBound (Y omega) (L omega))
    (hDom : forall omega,
      HighDimProb.TraceExpDominatesUpperBound (Y omega) (L omega) theta) :
    HighDimProb.quadraticFormUpperTailEvent Y t ⊆
      HighDimProb.traceExpThresholdEvent Y theta t := by
  exact
    HighDimProb.quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_spectralUpperBound_of_traceExpDominatesUpperBound
      Y L theta t hTheta hUpper hDom

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (Y : HighDimProb.RandomMatrix Omega n n) (L : Omega -> Real)
    (theta t : Real) (hTheta : 0 <= theta)
    (hRayleigh : forall omega,
      HighDimProb.RayleighUpperBound (Y omega) (L omega))
    (hDom : forall omega,
      HighDimProb.TraceExpDominatesUpperBound (Y omega) (L omega) theta) :
    HighDimProb.TraceExpDominatesQuadraticFormUpperTail Y theta t := by
  exact
    HighDimProb.traceExpDominatesQuadraticFormUpperTail_of_rayleighUpperBound_of_traceExpDominatesUpperBound
      Y L theta t hTheta hRayleigh hDom

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (Y : HighDimProb.RandomMatrix Omega n n) (L : Omega -> Real)
    (theta t : Real) (hTheta : 0 <= theta)
    (hUpper : forall omega,
      HighDimProb.SpectralUpperBound (Y omega) (L omega))
    (hDom : forall omega,
      HighDimProb.TraceExpDominatesUpperBound (Y omega) (L omega) theta) :
    HighDimProb.TraceExpDominatesQuadraticFormUpperTail Y theta t := by
  exact
    HighDimProb.traceExpDominatesQuadraticFormUpperTail_of_spectralUpperBound_of_traceExpDominatesUpperBound
      Y L theta t hTheta hUpper hDom

example {Omega : Type*} [MeasurableSpace Omega] {P : MeasureTheory.Measure Omega}
    {n : Nat} (Y : HighDimProb.RandomMatrix Omega (n + 1) (n + 1))
    (theta t : Real) (hY : HighDimProb.RandomSelfAdjointMatrix P Y)
    (hTheta : 0 <= theta) :
    HighDimProb.TraceExpDominatesQuadraticFormUpperTail Y theta t := by
  exact
    HighDimProb.traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint
      Y theta t hY hTheta

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta t : Real)
    (hMeas : AEMeasurable
      (fun omega =>
        ENNReal.ofReal (HighDimProb.traceExpIntegrand Y theta omega)) P)
    (hDom : HighDimProb.TraceExpDominatesQuadraticFormUpperTail Y theta t) :
    P (HighDimProb.quadraticFormUpperTailEvent Y t) <=
      HighDimProb.matrixLaplaceRHSLIntegralDiv P Y theta t := by
  exact
    HighDimProb.matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail
      Y theta t hMeas hDom

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta t : Real)
    (hMeas : AEMeasurable
      (fun omega =>
        ENNReal.ofReal (HighDimProb.traceExpIntegrand Y theta omega)) P)
    (hDom : HighDimProb.TraceExpDominatesQuadraticFormUpperTail Y theta t) :
    P (HighDimProb.quadraticFormUpperTailEvent Y t) <=
      HighDimProb.matrixLaplaceRHSLIntegral P Y theta t := by
  exact
    HighDimProb.matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail
      Y theta t hMeas hDom

example {Omega : Type*} [MeasurableSpace Omega] {P : MeasureTheory.Measure Omega}
    {n : Nat} (Y : HighDimProb.RandomMatrix Omega (n + 1) (n + 1))
    (theta t : Real)
    (hMeas : AEMeasurable
      (fun omega =>
        ENNReal.ofReal (HighDimProb.traceExpIntegrand Y theta omega)) P)
    (hY : HighDimProb.RandomSelfAdjointMatrix P Y)
    (hTheta : 0 <= theta) :
    P (HighDimProb.quadraticFormUpperTailEvent Y t) <=
      HighDimProb.matrixLaplaceRHSLIntegralDiv P Y theta t := by
  exact
    HighDimProb.matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint
      Y theta t hMeas hY hTheta

example {Omega : Type*} [MeasurableSpace Omega] {P : MeasureTheory.Measure Omega}
    {n : Nat} (Y : HighDimProb.RandomMatrix Omega (n + 1) (n + 1))
    (theta t : Real)
    (hMeas : AEMeasurable
      (fun omega =>
        ENNReal.ofReal (HighDimProb.traceExpIntegrand Y theta omega)) P)
    (hY : HighDimProb.RandomSelfAdjointMatrix P Y)
    (hTheta : 0 <= theta) :
    P (HighDimProb.quadraticFormUpperTailEvent Y t) <=
      HighDimProb.matrixLaplaceRHSLIntegral P Y theta t := by
  exact
    HighDimProb.matrixLaplaceTransformLIntegral_of_randomSelfAdjoint
      Y theta t hMeas hY hTheta

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta t : Real) : Prop :=
  HighDimProb.matrixLaplaceTransformStatement P Y theta t
