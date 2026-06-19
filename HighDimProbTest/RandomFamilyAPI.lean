import HighDimProb.Process

namespace HighDimProbTest

open MeasureTheory

section RandomFamilyAPI

variable {Omega I E F : Type*} [MeasurableSpace Omega]
variable [MeasurableSpace E] [MeasurableSpace F]
variable {P : Measure Omega}
variable (X : HighDimProb.RandomFamily Omega I E)
variable (hX : HighDimProb.IsRandomFamily P X)
variable (i : I)
variable (f : E -> F) (hf : Measurable f)

#check HighDimProb.RandomFamily
#check HighDimProb.RealRandomFamily
#check HighDimProb.IsRandomFamily
#check HighDimProb.IsRealRandomFamily
#check HighDimProb.familyAt
#check HighDimProb.familyAt_apply
#check HighDimProb.isRandomFamily_iff
#check HighDimProb.isRealRandomFamily_iff
#check HighDimProb.isRandomVariable_familyAt
#check HighDimProb.isRealRandomVariable_familyAt
#check HighDimProb.mapRandomFamily
#check HighDimProb.mapRandomFamily_apply
#check HighDimProb.isRandomFamily_map
#check HighDimProb.IsRandomProcess
#check HighDimProb.processAt
#check HighDimProb.processAt_apply
#check HighDimProb.isRandomProcess_iff
#check HighDimProb.isRandomVariable_processAt
#check HighDimProb.IsRandomSample
#check HighDimProb.sampleEvaluation
#check HighDimProb.sampleEvaluation_apply

example : HighDimProb.familyAt X i = X i :=
  rfl

example : HighDimProb.IsRandomVariable P (HighDimProb.familyAt X i) :=
  HighDimProb.isRandomVariable_familyAt hX i

example :
    HighDimProb.IsRandomFamily P (HighDimProb.mapRandomFamily f X) :=
  HighDimProb.isRandomFamily_map hf hX

end RandomFamilyAPI

section ProcessAPI

variable {Omega T E : Type*} [MeasurableSpace Omega] [MeasurableSpace E]
variable {P : Measure Omega}
variable (X : HighDimProb.RandomProcess Omega T E)
variable (hX : HighDimProb.IsRandomProcess P X)
variable (t : T)

example : HighDimProb.IsRandomVariable P (HighDimProb.processAt X t) :=
  HighDimProb.isRandomVariable_processAt hX t

end ProcessAPI

section SampleAPI

variable {Omega E : Type*} [MeasurableSpace Omega] [MeasurableSpace E]
variable {P : Measure Omega} {n : Nat}
variable (X : HighDimProb.RandomSample Omega E n)
variable (hX : HighDimProb.IsRandomSample P X)

example : HighDimProb.IsRandomFamily P X :=
  hX

end SampleAPI

end HighDimProbTest
