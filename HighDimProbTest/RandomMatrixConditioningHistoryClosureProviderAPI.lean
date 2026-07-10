import HighDimProb.RandomMatrix.ConditioningBernsteinTraceExpProvider

open MeasureTheory
open HighDimProb
open scoped ProbabilityTheory MatrixOrder Matrix.Norms.L2Operator

#check TraceExpTroppFrozenBoundInputs
#check TraceExpConditioning.troppStep_of_history_le
#check TraceExpConditioning.condExpStep_of_history_le
#check TraceExpConditioning.bernsteinInputs_of_primitives
#check TraceExpConditioning.bernsteinStep_of_history_le

example
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    {mHist : MeasurableSpace Omega}
    {H Z : @RandomMatrix Omega mOmega n n}
    {K : Matrix (Fin n) (Fin n) Real}
    (hHistoryLe : mHist <= MeasurableSpace.comap H inferInstance)
    (hTropp : TraceExpTroppFrozenBoundInputs (mOmega := mOmega) (P := P) Z K) :
    @troppMasterTraceMGFConditionalStep_statement
      Omega mOmega P n mHist H Z K :=
  TraceExpConditioning.troppStep_of_history_le
    (mOmega := mOmega) (P := P) hHistoryLe hTropp

example
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (theta R : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (i : Fin m)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P X)
    (hIntX : forall j, IntegrableRandomMatrix P (X j))
    (hIntSq : forall j, IntegrableRandomMatrix P (randomMatrixSquare (X j)))
    (hBound : PointwiseOperatorNormBound X R)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3)
    {mHist : MeasurableSpace Omega}
    {H : @RandomMatrix Omega mOmega n n}
    (hHistoryLe : mHist <= MeasurableSpace.comap H inferInstance) :
    @troppMasterTraceMGFConditionalStep_statement
      Omega mOmega P n mHist H
      (@troppCurrentRandomStep Omega mOmega m n theta X i)
      (@bernsteinSecondMomentComparisonFamily
        Omega mOmega (Fin m) n P X theta R i) :=
  TraceExpConditioning.bernsteinStep_of_history_le
    (mOmega := mOmega) (P := P) theta R X i
    hCentered hIntX hIntSq hBound hR hRange hHistoryLe
