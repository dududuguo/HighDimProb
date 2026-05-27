import HighDimProb.RandomMatrix

namespace HighDimProb

example {Ω : Type*} [MeasurableSpace Ω] {m n : ℕ}
    (A : RandomMatrix Ω m n) (i : Fin m) (j : Fin n) (ω : Ω) :
    matrixEntry A i j ω = A ω i j :=
  rfl

end HighDimProb
