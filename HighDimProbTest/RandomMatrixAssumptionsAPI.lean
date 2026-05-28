import HighDimProb.RandomMatrix.Assumptions

open MeasureTheory
open HighDimProb

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable {m n : Nat}
variable (A : RandomMatrix Omega m n)
variable (K : Real)

#check SubGaussianEntriesOrlicz
#check SubGaussianEntriesTail
#check SubGaussianRowsOrlicz
#check IsotropicRowsSecondMoment
#check IsotropicRowsCovariance
#check CenteredEntries

#check (SubGaussianEntriesOrlicz P A K : Prop)
#check (SubGaussianEntriesTail P A K : Prop)
#check (SubGaussianRowsOrlicz P A K : Prop)
#check (IsotropicRowsSecondMoment P A : Prop)
#check (IsotropicRowsCovariance P A : Prop)
#check (CenteredEntries P A : Prop)
