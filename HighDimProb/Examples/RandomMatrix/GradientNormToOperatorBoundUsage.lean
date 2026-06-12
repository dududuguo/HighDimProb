import HighDimProb.Examples.RandomMatrix.GradientCovarianceUsage
import HighDimProb.Examples.RandomMatrix.RankOnePSDUsage

/-!
# Gradient norm to operator-bound usage example

This examples-only file records the intended bridge from gradient norm bounds
to Matrix Bernstein operator-norm assumptions for rank-one covariance
summands. The current core API has the relevant operator-norm predicates, but
does not yet provide a theorem that bounds the operator norm of `g g^T` by a
gradient squared norm, nor the centered version after subtracting an
expectation. Those bridges are exposed as precise example-local assumptions.
-/

namespace HighDimProb.Examples.RandomMatrix.GradientNormToOperatorBoundUsage

open MeasureTheory
open scoped BigOperators
open HighDimProb.Examples.RandomMatrix.GradientCovarianceUsage
open HighDimProb.Examples.RandomMatrix.RankOnePSDUsage

noncomputable section

/-- Squared Euclidean norm of a finite gradient vector. -/
def gradientSqNorm {n : Nat} (g : GradientVector n) : Real :=
  Finset.univ.sum fun i : Fin (n + 1) => g i ^ 2

@[simp]
theorem gradientSqNorm_apply {n : Nat} (g : GradientVector n) :
    gradientSqNorm g =
      Finset.univ.sum fun i : Fin (n + 1) => g i ^ 2 := by
  rfl

/-- Squared gradient norm is nonnegative. -/
theorem gradientSqNorm_nonneg {n : Nat} (g : GradientVector n) :
    0 <= gradientSqNorm g := by
  unfold gradientSqNorm
  exact Finset.sum_nonneg fun i _hi => sq_nonneg (g i)

/-- A pointwise squared-gradient-norm bound for a random gradient table. -/
def GradientSqNormBound {Omega : Type*} [MeasurableSpace Omega]
    {batch n : Nat} (G : RandomGradientTable Omega batch n) (R : Real) :
    Prop :=
  forall b omega, gradientSqNorm (G omega b) <= R

/-- Example-local bridge from a squared-gradient-norm bound to an operator-norm
bound on uncentered rank-one covariance contributions.

This is a precise adapter assumption waiting for future core support for the
deterministic fact `||g g^T|| <= ||g||^2`. -/
structure RankOneGradientOperatorNormBridge {Omega : Type*}
    [MeasurableSpace Omega] {batch n : Nat}
    (G : RandomGradientTable Omega batch n) (R : Real) : Prop where
  gradientSqNormBound : GradientSqNormBound G R
  uncenteredOperatorNormBound :
    forall b omega,
      operatorNorm (randomGradientCovarianceContribution G b) omega <= R

/-- The uncentered bridge supplies the Matrix Bernstein pointwise
operator-norm predicate for the uncentered rank-one family. -/
theorem uncenteredGradientCovariance_pointwiseOperatorNormBound
    {Omega : Type*} [MeasurableSpace Omega] {batch n : Nat}
    (G : RandomGradientTable Omega batch n) (R : Real)
    (h : RankOneGradientOperatorNormBridge G R) :
    PointwiseOperatorNormBound
      (fun b : Fin batch => randomGradientCovarianceContribution G b) R := by
  intro b omega
  exact h.uncenteredOperatorNormBound b omega

/-- Example-local bridge from gradient norm control to the centered summand
operator-norm bound used by the Matrix Bernstein examples.

The `centeredOperatorNormBound` field is intentionally explicit: deriving it
from `gradientSqNormBound` needs future core facts about rank-one operator
norms and the effect of subtracting entrywise expectations. -/
structure CenteredGradientCovarianceOperatorNormAdapter {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {batch n : Nat}
    (G : RandomGradientTable Omega batch n)
    (A : Fin batch -> RandomMatrix Omega (n + 1) (n + 1))
    (R : Real) : Prop where
  centeredAdapter : IsCenteredGradientCovarianceSummandFamily (P := P) G A
  gradientSqNormBound : GradientSqNormBound G R
  centeredOperatorNormBound : PointwiseOperatorNormBound A R

/-- The centered adapter supplies the exact `PointwiseOperatorNormBound`
assumption consumed by the gradient covariance Matrix Bernstein examples. -/
theorem centeredGradientCovariance_pointwiseOperatorNormBound
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {batch n : Nat}
    (G : RandomGradientTable Omega batch n)
    (A : Fin batch -> RandomMatrix Omega (n + 1) (n + 1))
    (R : Real)
    (h : CenteredGradientCovarianceOperatorNormAdapter (P := P) G A R) :
    PointwiseOperatorNormBound A R :=
  h.centeredOperatorNormBound

/-- Rank-one gradient covariance contributions are structurally PSD; the
operator-norm part is separate from this PSD fact. -/
theorem gradientCovarianceContribution_structural_psd {batch n : Nat}
    (G : GradientTable batch n) (b : Fin batch) :
    IsPSDMatrix (gradientCovarianceContribution G b) := by
  exact gradientCovarianceContribution_psd G b

end

end HighDimProb.Examples.RandomMatrix.GradientNormToOperatorBoundUsage
