import HighDimProb.RandomMatrix.ConditioningTraceExpProvider

open MeasureTheory

namespace HighDimProbJudge.RandomMatrix

section

variable {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
variable {P : Measure Omega} [IsFiniteMeasure P] {n : Nat}
variable [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]

#check HighDimProb.condExp_traceExp_history_add_independent_step_of_indep_sigma

end

end HighDimProbJudge.RandomMatrix
