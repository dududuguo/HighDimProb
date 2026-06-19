import HighDimProb.RandomFamily

/-!
# Random processes

Verified Wikipedia reference:
https://en.wikipedia.org/wiki/Stochastic_process
-/

namespace HighDimProb

open MeasureTheory

/--
A random process indexed by `T` with values in `E`.

Formula reference: a stochastic process is a family of random variables indexed
by a set such as time; see https://en.wikipedia.org/wiki/Stochastic_process
-/
abbrev RandomProcess (Ω T E : Type*) [MeasurableSpace Ω] :=
  T → RandomVariable Ω E

/-- Pointwise measurability predicate for random processes. -/
abbrev IsRandomProcess {Ω T E : Type*} [MeasurableSpace Ω] [MeasurableSpace E]
    (P : Measure Ω) (X : RandomProcess Ω T E) : Prop :=
  IsRandomFamily P X

/--
Evaluation of a random process at an index.

Formula reference: `X_t` denotes the random variable at index `t`; see
https://en.wikipedia.org/wiki/Stochastic_process
-/
def processAt {Ω T E : Type*} [MeasurableSpace Ω]
    (X : RandomProcess Ω T E) (t : T) : RandomVariable Ω E :=
  X t

@[simp]
theorem processAt_apply {Ω T E : Type*} [MeasurableSpace Ω]
    (X : RandomProcess Ω T E) (t : T) (ω : Ω) :
    processAt X t ω = X t ω :=
  rfl

@[simp]
theorem isRandomProcess_iff {Ω T E : Type*} [MeasurableSpace Ω]
    [MeasurableSpace E] (P : Measure Ω) (X : RandomProcess Ω T E) :
    IsRandomProcess P X ↔ ∀ t, IsRandomVariable P (processAt X t) :=
  Iff.rfl

/-- A measurable random process has measurable time/index slices. -/
theorem isRandomVariable_processAt {Ω T E : Type*} [MeasurableSpace Ω]
    [MeasurableSpace E] {P : Measure Ω} {X : RandomProcess Ω T E}
    (hX : IsRandomProcess P X) (t : T) :
    IsRandomVariable P (processAt X t) :=
  hX t

end HighDimProb
