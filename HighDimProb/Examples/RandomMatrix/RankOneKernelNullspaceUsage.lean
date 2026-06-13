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
  Finset.univ.sum fun a : I => rankOneOuter (V a)

/-- Entry formula for a finite sum of rank-one kernels. -/
theorem rankOneKernelSum_apply {I : Type*} [Fintype I] {n : Nat}
    (V : I -> RankOneVector n) (i j : Fin (n + 1)) :
    rankOneKernelSum V i j =
      Finset.univ.sum fun a : I => V a i * V a j := by
  simp [rankOneKernelSum, rankOneOuter, Matrix.sum_apply]

/-- Matrix action of a sum of rank-one kernels. -/
theorem rankOneKernelSum_matrixAction {I : Type*} [Fintype I] {n : Nat}
    (V : I -> RankOneVector n) (x : Fin (n + 1) -> Real) :
    matrixAction (rankOneKernelSum V) x =
      fun i => Finset.univ.sum fun a : I =>
        V a i * (Finset.univ.sum fun j : Fin (n + 1) => V a j * x j) := by
  ext i
  calc
    matrixAction (rankOneKernelSum V) x i
        = Finset.univ.sum fun j : Fin (n + 1) =>
            (Finset.univ.sum fun a : I => V a i * V a j) * x j := by
          simp [matrixAction, rankOneKernelSum_apply]
    _ = Finset.univ.sum fun j : Fin (n + 1) =>
          Finset.univ.sum fun a : I => V a i * V a j * x j := by
          apply Finset.sum_congr rfl
          intro j _hj
          rw [Finset.sum_mul]
    _ = Finset.univ.sum fun a : I =>
          Finset.univ.sum fun j : Fin (n + 1) => V a i * V a j * x j := by
          rw [Finset.sum_comm]
    _ = Finset.univ.sum fun a : I =>
          V a i * (Finset.univ.sum fun j : Fin (n + 1) => V a j * x j) := by
          apply Finset.sum_congr rfl
          intro a _ha
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro j _hj
          ring

/-- If a direction is orthogonal to every feature vector, it is invisible to
the finite rank-one kernel sum. -/
theorem rankOneKernelSum_invisible_of_forall_orthogonal
    {I : Type*} [Fintype I] {n : Nat}
    {V : I -> RankOneVector n} {x : Fin (n + 1) -> Real}
    (hOrth : forall a : I, OrthogonalToFeature (V a) x) :
    KernelInvisibleDirection (rankOneKernelSum V) x := by
  unfold KernelInvisibleDirection
  rw [rankOneKernelSum_matrixAction]
  ext i
  apply Finset.sum_eq_zero
  intro a _ha
  have h := hOrth a
  unfold OrthogonalToFeature at h
  rw [h]
  simp

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
