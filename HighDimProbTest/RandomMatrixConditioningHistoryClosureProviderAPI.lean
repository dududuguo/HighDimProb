import HighDimProb.RandomMatrix.ConditioningBernsteinTraceExpProvider

open MeasureTheory
open HighDimProb
open scoped ProbabilityTheory MatrixOrder Matrix.Norms.L2Operator

#check TraceExpTroppFrozenBoundInputs
#check TraceExpConditioning.troppStep_of_history_le
#check TraceExpConditioning.condExpStep_of_history_le

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
