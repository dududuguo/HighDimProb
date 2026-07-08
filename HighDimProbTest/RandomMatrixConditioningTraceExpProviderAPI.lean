import HighDimProb.RandomMatrix.ConditioningTraceExpProvider

open MeasureTheory

namespace HighDimProbTest

section

variable {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
variable {P : Measure Omega} [IsFiniteMeasure P] {n : Nat}
variable [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
variable (mHist : MeasurableSpace Omega)
variable (H Z : @HighDimProb.RandomMatrix Omega mOmega n n)
variable (K : Matrix (Fin n) (Fin n) Real)

#check HighDimProb.condExp_traceExp_history_add_independent_step_of_indep_sigma

example
    (hHistStepIndep :
      ProbabilityTheory.Indep mHist (MeasurableSpace.comap Z inferInstance) P)
    (hPairInt : Integrable
      (fun p : Matrix (Fin n) (Fin n) Real × Matrix (Fin n) (Fin n) Real =>
        HighDimProb.traceMatrixExp (p.1 + p.2))
      (@Measure.map Omega
        (Matrix (Fin n) (Fin n) Real × Matrix (Fin n) (Fin n) Real)
        mOmega inferInstance (fun omega => (H omega, Z omega)) P))
    (hFrozenBound :
      forall A : Matrix (Fin n) (Fin n) Real,
        MeasureTheory.integral
          (@Measure.map Omega (Matrix (Fin n) (Fin n) Real) mOmega inferInstance
            Z P)
          (fun B => HighDimProb.traceMatrixExp (A + B)) <=
        HighDimProb.traceMatrixExp (A + K)) :
    @HighDimProb.condExp_traceExp_history_add_independent_step_statement
      Omega mOmega P n mHist H Z K :=
  @HighDimProb.condExp_traceExp_history_add_independent_step_of_indep_sigma
    Omega mOmega (by infer_instance) P (by infer_instance) n (by infer_instance)
    mHist H Z K hHistStepIndep hPairInt hFrozenBound

end

end HighDimProbTest
