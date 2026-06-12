import HighDimProb.Examples.RandomMatrix.RankOnePSDUsage
import HighDimProb.Examples.RandomMatrix.NTKGramDecompositionUsage
import HighDimProb.Examples.RandomMatrix.RandomFeatureKernelUsage
import HighDimProb.Examples.RandomMatrix.GradientCovarianceUsage

/-!
# Kernel nullspace usage example

This examples-only file introduces nullspace and invisible-direction vocabulary
for kernel, NTK Gram, random-feature, and gradient covariance matrices. It
keeps the vocabulary deterministic and conservative. Hard PSD converses such as
`x^T A x = 0` implying `A x = 0` are exposed as local adapter assumptions
instead of being promoted to core.
-/

namespace HighDimProb.Examples.RandomMatrix.KernelNullspaceUsage

open scoped BigOperators
open HighDimProb.Examples.RandomMatrix.RankOnePSDUsage

noncomputable section

/-- Explicit matrix-vector action in the same finite-sum style as the
HighDimProb quadratic-form API. -/
def matrixAction {n : Nat} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (x : Fin (n + 1) -> Real) : Fin (n + 1) -> Real :=
  fun i => Finset.univ.sum fun j : Fin (n + 1) => A i j * x j

@[simp]
theorem matrixAction_apply {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (x : Fin (n + 1) -> Real) (i : Fin (n + 1)) :
    matrixAction A x i =
      Finset.univ.sum fun j : Fin (n + 1) => A i j * x j := by
  rfl

/-- A direction invisible to a deterministic kernel or Gram matrix. -/
def KernelInvisibleDirection {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (x : Fin (n + 1) -> Real) : Prop :=
  matrixAction A x = 0

/-- A direction whose quadratic form under a deterministic kernel is zero. -/
def KernelQuadraticNullDirection {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (x : Fin (n + 1) -> Real) : Prop :=
  matrixQuadraticForm A x = 0

/-- Pointwise random-matrix version of an invisible direction. -/
def RandomKernelInvisibleDirection {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (A : RandomMatrix Omega (n + 1) (n + 1))
    (x : Fin (n + 1) -> Real) : Prop :=
  forall omega, KernelInvisibleDirection (A omega) x

/-- Pointwise random-matrix version of a quadratic-null direction. -/
def RandomKernelQuadraticNullDirection {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (A : RandomMatrix Omega (n + 1) (n + 1))
    (x : Fin (n + 1) -> Real) : Prop :=
  forall omega, KernelQuadraticNullDirection (A omega) x

/-- Quadratic form as `sum_i x_i * (A x)_i`. -/
theorem matrixQuadraticForm_eq_sum_mul_matrixAction {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (x : Fin (n + 1) -> Real) :
    matrixQuadraticForm A x =
      Finset.univ.sum fun i : Fin (n + 1) => x i * matrixAction A x i := by
  simp [matrixQuadraticForm, matrixAction]
  apply Finset.sum_congr rfl
  intro i _hi
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _hj
  ring

/-- If `A x = 0`, then `x^T A x = 0`. -/
theorem quadraticNullDirection_of_invisible {n : Nat}
    {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    {x : Fin (n + 1) -> Real}
    (h : KernelInvisibleDirection A x) :
    KernelQuadraticNullDirection A x := by
  unfold KernelQuadraticNullDirection
  rw [matrixQuadraticForm_eq_sum_mul_matrixAction]
  rw [h]
  simp

/-- Pointwise random version: invisible directions are quadratic-null. -/
theorem randomQuadraticNullDirection_of_invisible {Omega : Type*}
    [MeasurableSpace Omega] {n : Nat}
    {A : RandomMatrix Omega (n + 1) (n + 1)}
    {x : Fin (n + 1) -> Real}
    (h : RandomKernelInvisibleDirection A x) :
    RandomKernelQuadraticNullDirection A x := by
  intro omega
  exact quadraticNullDirection_of_invisible (h omega)

/-- A direction orthogonal to a feature vector. -/
def OrthogonalToFeature {n : Nat}
    (v : RankOneVector n) (x : Fin (n + 1) -> Real) : Prop :=
  (Finset.univ.sum fun i : Fin (n + 1) => v i * x i) = 0

/-- Matrix action of a rank-one outer product. -/
theorem rankOneOuter_matrixAction {n : Nat}
    (v : RankOneVector n) (x : Fin (n + 1) -> Real) :
    matrixAction (rankOneOuter v) x =
      fun i => v i *
        (Finset.univ.sum fun j : Fin (n + 1) => v j * x j) := by
  ext i
  simp [matrixAction, rankOneOuter]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _hj
  ring

/-- A vector orthogonal to the feature vector is invisible to `v v^T`. -/
theorem rankOneOuter_invisible_of_orthogonal {n : Nat}
    {v : RankOneVector n} {x : Fin (n + 1) -> Real}
    (h : OrthogonalToFeature v x) :
    KernelInvisibleDirection (rankOneOuter v) x := by
  unfold KernelInvisibleDirection
  rw [rankOneOuter_matrixAction]
  ext i
  rw [h]
  simp

/-- NTK rank-one Gram contribution: orthogonal directions are invisible. -/
theorem ntkGramOuter_invisible_of_orthogonal {n : Nat}
    {v : NTKGramUsage.NTKFeatureVector n} {x : Fin (n + 1) -> Real}
    (h : OrthogonalToFeature v x) :
    KernelInvisibleDirection (NTKGramUsage.ntkGramOuter v) x := by
  simpa [ntkGramOuter_eq_rankOneOuter] using
    rankOneOuter_invisible_of_orthogonal (v := v) (x := x) h

/-- Random-feature rank-one kernel contribution: orthogonal directions are invisible. -/
theorem featureKernelOuter_invisible_of_orthogonal {n : Nat}
    {phi : RandomFeatureKernelUsage.FeatureVector n}
    {x : Fin (n + 1) -> Real}
    (h : OrthogonalToFeature phi x) :
    KernelInvisibleDirection (RandomFeatureKernelUsage.featureKernelOuter phi) x := by
  simpa [featureKernelOuter_eq_rankOneOuter] using
    rankOneOuter_invisible_of_orthogonal (v := phi) (x := x) h

/-- Gradient covariance rank-one contribution: orthogonal directions are invisible. -/
theorem gradientOuter_invisible_of_orthogonal {n : Nat}
    {g : GradientCovarianceUsage.GradientVector n}
    {x : Fin (n + 1) -> Real}
    (h : OrthogonalToFeature g x) :
    KernelInvisibleDirection (GradientCovarianceUsage.gradientOuter g) x := by
  simpa [gradientOuter_eq_rankOneOuter] using
    rankOneOuter_invisible_of_orthogonal (v := g) (x := x) h

/-- Example-local adapter for the hard PSD converse.

For PSD matrices the mathematical statement is that `x^T A x = 0` should
force `A x = 0`. The current example layer records it as a named assumption
waiting for future core support instead of proving a full PSD nullspace theory. -/
def PSDQuadraticNullImpliesInvisible {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) : Prop :=
  IsPSDMatrix A ->
    forall x : Fin (n + 1) -> Real,
      KernelQuadraticNullDirection A x -> KernelInvisibleDirection A x

/-- Use the local PSD-nullspace adapter to turn a quadratic-null direction into
an invisible direction. -/
theorem invisible_of_quadraticNull_of_psd_adapter {n : Nat}
    {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    {x : Fin (n + 1) -> Real}
    (hAdapter : PSDQuadraticNullImpliesInvisible A)
    (hPSD : IsPSDMatrix A)
    (hNull : KernelQuadraticNullDirection A x) :
    KernelInvisibleDirection A x :=
  hAdapter hPSD x hNull

end

end HighDimProb.Examples.RandomMatrix.KernelNullspaceUsage
