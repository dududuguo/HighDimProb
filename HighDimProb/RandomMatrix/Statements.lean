import HighDimProb.Nets
import HighDimProb.RandomMatrix.OperatorNorm
import HighDimProb.RandomMatrix.SampleCovariance
import HighDimProb.RandomMatrix.QuadraticForm
import HighDimProb.RandomMatrix.Assumptions

/-!
# Random matrix theorem statement layer

This module contains typechecked `Prop` specifications for random-matrix
theorem targets only when the required vocabulary already exists.

Most book-level random matrix results are still blocked at the statement layer
because essential assumptions such as independent rows, iid entries, symmetric
random matrices, PSD/order vocabulary, and probability-high syntax are not yet
available as HighDimProb declarations.
-/

namespace HighDimProb

open MeasureTheory
open scoped Matrix.Norms.L2Operator

noncomputable section

/--
Statement target: an epsilon-net on the Euclidean unit sphere controls the
operator norm of a deterministic square matrix.

This is intentionally a typed specification only. It records the dependency
between the geometry branch and the matrix operator-norm convention, without
claiming a proof in this module.
-/
abbrev epsilonNetOperatorNormStatement {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) (N : Set (Fin n -> Real))
    (eps C : Real) : Prop :=
  0 < eps ->
    eps < 1 ->
      IsEpsilonNet {x : Fin n -> Real | ‖x‖ = 1} N eps ->
        (forall x, x ∈ N -> ‖A.mulVec x‖ <= C) ->
          ‖A‖ <= C / (1 - eps)

end

end HighDimProb
