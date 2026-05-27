import HighDimProb.Lp
import HighDimProb.Moment

open MeasureTheory
open HighDimProb

variable {Ω : Type*} [MeasurableSpace Ω]
variable (P : Measure Ω) (X : Ω → ℝ) (p : ENNReal)

#check MemLpRandomVariable
#check MemLpRealRandomVariable
#check lpNormRandomVariable
#check realLpNorm
#check IntegrableRandomVariable
#check IntegrableRealRandomVariable
#check HasFiniteMoment
#check momentSeminorm

example : MemLpRealRandomVariable P X p ↔ MemLp X p P :=
  Iff.rfl

example : realLpNorm P X p = eLpNorm X p P :=
  rfl

example : IntegrableRealRandomVariable P X ↔ Integrable X P :=
  Iff.rfl

example : HasFiniteMoment P X p ↔ MemLp X p P :=
  Iff.rfl

example : momentSeminorm P X p = realLpNorm P X p :=
  rfl
