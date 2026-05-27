import HighDimProb.RandomVariable

/-!
# Random processes
-/

namespace HighDimProb

open MeasureTheory

/-- A random process indexed by `T` with values in `E`. -/
abbrev RandomProcess (Ω T E : Type*) [MeasurableSpace Ω] :=
  T → RandomVariable Ω E

/-- Evaluation of a random process at an index. -/
def processAt {Ω T E : Type*} [MeasurableSpace Ω]
    (X : RandomProcess Ω T E) (t : T) : RandomVariable Ω E :=
  X t

@[simp]
theorem processAt_apply {Ω T E : Type*} [MeasurableSpace Ω]
    (X : RandomProcess Ω T E) (t : T) (ω : Ω) :
    processAt X t ω = X t ω :=
  rfl

end HighDimProb
