import HighDimProb.Orlicz

namespace HighDimProb

example (p : ℕ) (x : ℝ) :
    psiPower p x = Real.exp (|x| ^ p) - 1 :=
  rfl

end HighDimProb
