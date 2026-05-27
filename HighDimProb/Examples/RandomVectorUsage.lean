import HighDimProb.RandomVector

namespace HighDimProb

example {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (X : RandomVector Ω n) (i : Fin n) (ω : Ω) :
    coordinate X i ω = X ω i :=
  rfl

end HighDimProb
