import HighDimProb.RandomMatrix.ConditioningExpectationProvider

open MeasureTheory

namespace HighDimProbTest

section

variable {Omega : Type*} [mOmega : MeasurableSpace Omega]
variable {P : Measure Omega} {n : Nat}
variable (mHist : MeasurableSpace Omega)
variable (H Z : @HighDimProb.RandomMatrix Omega mOmega n n)

#check HighDimProb.indepFun_of_history_entry_measurable_of_indep

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

end HighDimProbTest
