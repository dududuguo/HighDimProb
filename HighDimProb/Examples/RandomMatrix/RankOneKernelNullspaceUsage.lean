import HighDimProb.Examples.RandomMatrix.KernelNullspaceUsage

/-!
# Rank-one kernel nullspace usage example

This examples-only file deepens the existing nullspace vocabulary for rank-one
kernels and finite sums of rank-one kernels.
-/

namespace HighDimProb.Examples.RandomMatrix.RankOneKernelNullspaceUsage

open scoped BigOperators
open HighDimProb.Examples.RandomMatrix.RankOnePSDUsage
open HighDimProb.Examples.RandomMatrix.KernelNullspaceUsage

noncomputable section

/-- A finite sum of rank-one kernel matrices. -/
def rankOneKernelSum {I : Type*} [Fintype I] {n : Nat}
    (V : I -> RankOneVector n) :
    Matrix (Fin (n + 1)) (Fin (n + 1)) Real :=
  rankOneMatrixSum V

/-- If a direction is orthogonal to every feature vector, it is invisible to
the finite rank-one kernel sum. -/
theorem rankOneKernelSum_invisible_of_forall_orthogonal
    {I : Type*} [Fintype I] {n : Nat}
    {V : I -> RankOneVector n} {x : Fin (n + 1) -> Real}
    (hOrth : forall a : I, OrthogonalToFeature (V a) x) :
    KernelInvisibleDirection (rankOneKernelSum V) x := by
  unfold KernelInvisibleDirection
  rw [matrixAction_eq_mulVec]
  simpa [rankOneKernelSum, OrthogonalToFeature] using
    rankOneSum_mulVec_eq_zero_of_forall_inner_eq_zero V x hOrth

/-- Quadratic-null version for a finite rank-one kernel sum. -/
theorem rankOneKernelSum_quadraticNull_of_forall_orthogonal
    {I : Type*} [Fintype I] {n : Nat}
    {V : I -> RankOneVector n} {x : Fin (n + 1) -> Real}
    (hOrth : forall a : I, OrthogonalToFeature (V a) x) :
    KernelQuadraticNullDirection (rankOneKernelSum V) x := by
  exact quadraticNullDirection_of_invisible
    (rankOneKernelSum_invisible_of_forall_orthogonal
      (V := V) (x := x) hOrth)

/-- Random-feature finite kernel sums use the same nullspace criterion. -/
theorem featureKernelSum_invisible_of_forall_orthogonal {numFeatures n : Nat}
    {Phi : RandomFeatureKernelUsage.FeatureTable numFeatures n}
    {x : Fin (n + 1) -> Real}
    (hOrth : forall a : Fin numFeatures, OrthogonalToFeature (Phi a) x) :
    KernelInvisibleDirection
      (Finset.univ.sum fun a : Fin numFeatures =>
        RandomFeatureKernelUsage.featureKernelContribution Phi a) x := by
  simpa [rankOneKernelSum, RandomFeatureKernelUsage.featureKernelContribution,
    RandomFeatureKernelUsage.featureKernelOuter,
    NTKGramUsage.ntkGramOuter, rankOneOuter] using
    rankOneKernelSum_invisible_of_forall_orthogonal
      (V := Phi) (x := x) hOrth

/-- Gradient covariance finite sums use the same nullspace criterion. -/
theorem gradientCovarianceSum_invisible_of_forall_orthogonal {batch n : Nat}
    {G : GradientCovarianceUsage.GradientTable batch n}
    {x : Fin (n + 1) -> Real}
    (hOrth : forall b : Fin batch, OrthogonalToFeature (G b) x) :
    KernelInvisibleDirection
      (Finset.univ.sum fun b : Fin batch =>
        GradientCovarianceUsage.gradientCovarianceContribution G b) x := by
  simpa [rankOneKernelSum, GradientCovarianceUsage.gradientCovarianceContribution,
    GradientCovarianceUsage.gradientOuter, rankOneOuter] using
    rankOneKernelSum_invisible_of_forall_orthogonal
      (V := G) (x := x) hOrth

end

end HighDimProb.Examples.RandomMatrix.RankOneKernelNullspaceUsage
