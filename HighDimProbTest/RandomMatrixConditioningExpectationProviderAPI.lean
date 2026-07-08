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

section

variable {Omega Alpha Beta : Type*} [mOmega : MeasurableSpace Omega]
variable [mAlpha : MeasurableSpace Alpha] [mBeta : MeasurableSpace Beta]
variable [sBeta : StandardBorelSpace Beta] [hOmega : Nonempty Omega] [hBeta : Nonempty Beta]
variable {P : Measure Omega} [hFin : IsFiniteMeasure P]
variable {mHist : MeasurableSpace Omega}
variable {H : Omega -> Alpha} {Z : Omega -> Beta}
variable {F : Alpha -> Beta -> Real} {B : Alpha -> Real}

#check HighDimProb.condExp_le_of_indep_sigma_under_frozen_bound

example
    (hHistSub : mHist ≤ mOmega)
    (hH : @Measurable Omega Alpha mHist inferInstance H)
    (hZ : AEMeasurable Z P)
    (hIndepSigma :
      ProbabilityTheory.Indep mHist (MeasurableSpace.comap Z inferInstance) P)
    (hInt : Integrable (fun p : Prod Alpha Beta => F p.1 p.2)
      (@Measure.map Omega (Alpha × Beta) mOmega inferInstance
        (fun omega => (H omega, Z omega)) P))
    (hBound : forall a,
      MeasureTheory.integral (@Measure.map Omega Beta mOmega inferInstance Z P)
        (fun z => F a z) <= B a) :
    Filter.EventuallyLE (MeasureTheory.ae P)
      (MeasureTheory.condExp (m := mHist) P (fun omega => F (H omega) (Z omega)))
      (fun omega => B (H omega)) :=
  @HighDimProb.condExp_le_of_indep_sigma_under_frozen_bound
    Omega Alpha Beta mOmega mAlpha mBeta sBeta hOmega hBeta P hFin mHist H Z F B
    hHistSub hH hZ hIndepSigma hInt hBound

end

end HighDimProbTest
