import Mathlib.Probability.Independence.Basic
import HighDimProb.RandomMatrix.Expectation
import HighDimProb.RandomMatrix.OperatorNorm
import HighDimProb.RandomMatrix.RowsCols
import HighDimProb.RandomMatrix.SelfAdjoint
import HighDimProb.SubGaussianVector
import HighDimProb.Isotropic

/-!
# Random matrix assumption predicates

Verified Wikipedia references:
* Random matrix: https://en.wikipedia.org/wiki/Random_matrix
* Sub-Gaussian distribution: https://en.wikipedia.org/wiki/Sub-Gaussian_distribution
* Isotropic position: https://en.wikipedia.org/wiki/Isotropic_position
* Self-adjoint operator: https://en.wikipedia.org/wiki/Self-adjoint_operator
* Operator norm: https://en.wikipedia.org/wiki/Operator_norm
* Independence: https://en.wikipedia.org/wiki/Independence_(probability_theory)
-/

namespace HighDimProb

open MeasureTheory

/-- Entrywise Orlicz subGaussian assumption with common scale `K`. -/
def SubGaussianEntriesOrlicz {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) (K : Real) : Prop :=
  forall i : Fin m, forall j : Fin n, SubGaussianOrlicz P (matrixEntry A i j) K

/-- Entrywise tail-form subGaussian assumption with common scale `K`. -/
def SubGaussianEntriesTail {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) (K : Real) : Prop :=
  forall i : Fin m, forall j : Fin n, SubGaussianTail P (matrixEntry A i j) K

/-- Rowwise Orlicz subGaussian assumption with common scale `K`. -/
def SubGaussianRowsOrlicz {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) (K : Real) : Prop :=
  forall i : Fin m, SubGaussianVectorOrlicz P (rowVector A i) K

/-- Each row is isotropic in the second-moment formulation. -/
def IsotropicRowsSecondMoment {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) : Prop :=
  forall i : Fin m, IsotropicSecondMoment P (rowVector A i)

/-- Each row is isotropic in the covariance formulation. -/
def IsotropicRowsCovariance {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) : Prop :=
  forall i : Fin m, IsotropicCovariance P (rowVector A i)

/-- Entrywise centeredness assumption. -/
def CenteredEntries {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (A : RandomMatrix Omega m n) : Prop :=
  forall i : Fin m, forall j : Fin n, Centered P (matrixEntry A i j)

/-- Matrix-valued independence wrapper around Mathlib `ProbabilityTheory.iIndepFun`. -/
abbrev IndependentRandomMatrices {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} {m n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega m n) : Prop :=
  ProbabilityTheory.iIndepFun A P

/-- A finite or indexed family of random self-adjoint square matrices. -/
def SelfAdjointRandomMatrixFamily {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) : Prop :=
  (forall i, IsRandomMatrix P (A i)) /\
    (forall i, RandomSelfAdjointMatrix P (A i))

/-- Independent self-adjoint random matrix family. -/
def IndependentSelfAdjointRandomMatrices {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) : Prop :=
  SelfAdjointRandomMatrixFamily P A /\ IndependentRandomMatrices P A

/-- Pointwise self-adjoint family with entrywise zero mean expressed through
the entrywise matrix expectation. -/
def CenteredSelfAdjointRandomMatrixFamily {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) : Prop :=
  SelfAdjointRandomMatrixFamily P A /\ forall i, matrixExpect P (A i) = 0

/-- Compatibility predicate from the MC1 statement layer: centeredness is
entrywise centeredness rather than the bundled matrix-expectation equality. -/
def CenteredRandomSelfAdjointMatrices {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) : Prop :=
  (forall i, IsRandomMatrix P (A i)) /\
    (forall i, RandomSelfAdjointMatrix P (A i)) /\
      (forall i, CenteredEntries P (A i))

/-- Pointwise operator-norm bound for one random matrix. -/
def BoundedOperatorNorm {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (A : RandomMatrix Omega m n) (R : Real) : Prop :=
  forall omega, operatorNorm A omega <= R

/--
A pointwise squared-vector-norm bound gives an operator-norm bound for the
rank-one random matrix `omega |-> X(omega) X(omega)^T`.

Formula reference: the deterministic ingredient is
`||v v^T||op <= ||v||_2^2` for a rank-one outer product; see
https://en.wikipedia.org/wiki/Outer_product and
https://en.wikipedia.org/wiki/Operator_norm
-/
theorem BoundedOperatorNorm_rankOne_of_sqNorm_bound {Omega : Type*}
    [MeasurableSpace Omega] {n : Nat}
    (X : Omega -> Fin n -> Real) (R : Real)
    (_hR : 0 <= R)
    (hX : forall omega, vectorSqNorm (X omega) <= R) :
    BoundedOperatorNorm (fun omega i j => X omega i * X omega j) R := by
  intro omega
  exact (rankOneOperatorNorm_le_vectorSqNorm (X omega)).trans (hX omega)

/--
If a random matrix and its deterministic entrywise expectation have explicit
operator-norm bounds, then the centered random matrix is bounded by the sum of
those two bounds.

This is only an algebraic triangle-inequality wrapper around the existing
`matrixExpect` / `centeredRandomMatrix` vocabulary. It does not prove
entrywise integrability, measurability, or any contraction theorem bounding
`||E X||op` from the pointwise bound on `X`; the expectation norm bound is an
explicit hypothesis.

Formula reference: centering uses `X(omega) - E X`, and the proof is the
operator-norm triangle inequality `||X(omega) - E X|| <= ||X(omega)|| +
||E X||`; see https://en.wikipedia.org/wiki/Operator_norm and the sample
covariance/expectation background at
https://en.wikipedia.org/wiki/Sample_mean_and_covariance
-/
theorem BoundedOperatorNorm_centered_of_bound_expect_bound {Omega : Type*}
    [MeasurableSpace Omega] {m n : Nat}
    (P : Measure Omega) (X : RandomMatrix Omega m n) (R Rexp : Real)
    (hX : BoundedOperatorNorm X R)
    (hExp : deterministicOperatorNorm (matrixExpect P X) <= Rexp) :
    BoundedOperatorNorm (centeredRandomMatrix P X) (R + Rexp) := by
  intro omega
  have hTri :
      deterministicOperatorNorm (X omega - matrixExpect P X) <=
        deterministicOperatorNorm (X omega) +
          deterministicOperatorNorm (matrixExpect P X) :=
    deterministicOperatorNorm_sub_le_add (X omega) (matrixExpect P X)
  have hBound :
      deterministicOperatorNorm (X omega) +
          deterministicOperatorNorm (matrixExpect P X) <= R + Rexp :=
    add_le_add (hX omega) hExp
  exact hTri.trans hBound

/-- Pointwise uniform operator-norm bound for a matrix family. -/
def PointwiseOperatorNormBound {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} {m n : Nat} (A : I -> RandomMatrix Omega m n)
    (R : Real) : Prop :=
  forall i, BoundedOperatorNorm (A i) R

/--
Family version of the rank-one operator-norm bridge: if every vector sample has
`vectorSqNorm <= R`, then the associated rank-one matrix family is pointwise
operator-norm bounded by `R`.

Formula reference: this packages the outer-product bound
`||v v^T||op <= ||v||_2^2`; see
https://en.wikipedia.org/wiki/Outer_product and
https://en.wikipedia.org/wiki/Operator_norm
-/
theorem PointwiseOperatorNormBound_rankOne_of_sqNorm_bound {Omega : Type*}
    [MeasurableSpace Omega] {I : Type*} {n : Nat}
    (X : I -> Omega -> Fin n -> Real) (R : Real)
    (hR : 0 <= R)
    (hX : forall i omega, vectorSqNorm (X i omega) <= R) :
    PointwiseOperatorNormBound (fun i omega a b => X i omega a * X i omega b) R := by
  intro i
  exact BoundedOperatorNorm_rankOne_of_sqNorm_bound (X i) R hR (hX i)

/--
Family version of the centered operator-norm bridge under an explicit bound on
each deterministic expectation.

This is the family form of the algebraic wrapper above. It intentionally keeps
the expectation operator-norm bound as a hypothesis and does not establish
integrability or expectation contraction.

Formula reference: this packages the triangle-bound route
`||X_i(omega) - E X_i|| <= ||X_i(omega)|| + ||E X_i||`; see
https://en.wikipedia.org/wiki/Operator_norm and
https://en.wikipedia.org/wiki/Sample_mean_and_covariance
-/
theorem PointwiseOperatorNormBound_centered_of_bound_expect_bound {Omega : Type*}
    [MeasurableSpace Omega] {I : Type*} {m n : Nat}
    (P : Measure Omega) (X : I -> RandomMatrix Omega m n) (R Rexp : Real)
    (hX : PointwiseOperatorNormBound X R)
    (hExp : forall i, deterministicOperatorNorm (matrixExpect P (X i)) <= Rexp) :
    PointwiseOperatorNormBound (fun i => centeredRandomMatrix P (X i)) (R + Rexp) := by
  intro i
  exact BoundedOperatorNorm_centered_of_bound_expect_bound P (X i) R Rexp
    (hX i) (hExp i)

/--
Same-radius centered operator-norm wrapper: if both `X_i(omega)` and
`E X_i` are bounded by `R`, then the centered family is bounded by `R + R`.

This remains an explicit-bound wrapper; the hypothesis on `E X_i` is not
derived from the pointwise bound on `X_i`.

Formula reference: this is the special case `R_exp = R` of the operator-norm
triangle inequality; see https://en.wikipedia.org/wiki/Operator_norm
-/
theorem PointwiseOperatorNormBound_centered_of_bound_expect_bound_same {Omega : Type*}
    [MeasurableSpace Omega] {I : Type*} {m n : Nat}
    (P : Measure Omega) (X : I -> RandomMatrix Omega m n) (R : Real)
    (hX : PointwiseOperatorNormBound X R)
    (hExp : forall i, deterministicOperatorNorm (matrixExpect P (X i)) <= R) :
    PointwiseOperatorNormBound (fun i => centeredRandomMatrix P (X i)) (R + R) := by
  exact PointwiseOperatorNormBound_centered_of_bound_expect_bound P X R R hX hExp

/-- Alias emphasizing that the uniform bound is pointwise, not a.e. -/
abbrev UniformOperatorNormBound {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} {m n : Nat} (A : I -> RandomMatrix Omega m n)
    (R : Real) : Prop :=
  PointwiseOperatorNormBound A R

/-- A.e. operator-norm bound for a matrix family. This is recorded separately
from the pointwise predicate so theorem statements do not hide the distinction. -/
def AeOperatorNormBound {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} {m n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega m n) (R : Real) : Prop :=
  forall i, ∀ᵐ omega ∂P, operatorNorm (A i) omega <= R

end HighDimProb
