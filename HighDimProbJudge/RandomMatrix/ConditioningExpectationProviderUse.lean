import HighDimProb.RandomMatrix.ConditioningExpectationProvider

open MeasureTheory

namespace HighDimProbJudge.RandomMatrix

section

variable {Omega : Type*} [mOmega : MeasurableSpace Omega]
variable {P : Measure Omega} {n : Nat}
variable (mHist : MeasurableSpace Omega)
variable (H Z : @HighDimProb.RandomMatrix Omega mOmega n n)

example
    (hHmeas :
      forall i j,
        @Measurable Omega Real mHist inferInstance
          (fun omega => H omega i j))
    (hIndepSigma :
      ProbabilityTheory.Indep mHist (MeasurableSpace.comap Z inferInstance) P) :
    @ProbabilityTheory.IndepFun Omega _ _ mOmega _ _ H Z P :=
  @HighDimProb.indepFun_of_history_entry_measurable_of_indep
    Omega mOmega P n mHist H Z hHmeas hIndepSigma

end

section

variable {Omega Alpha Beta : Type*} [mOmega : MeasurableSpace Omega]
variable [MeasurableSpace Alpha] [MeasurableSpace Beta]
variable [StandardBorelSpace Beta] [Nonempty Omega] [Nonempty Beta]
variable {P : Measure Omega} [IsFiniteMeasure P]
variable {mHist : MeasurableSpace Omega}
variable {H : Omega -> Alpha} {Z : Omega -> Beta}
variable {F : Alpha -> Beta -> Real} {B : Alpha -> Real}

#check HighDimProb.condExp_le_of_indep_sigma_under_frozen_bound

end

end HighDimProbJudge.RandomMatrix
