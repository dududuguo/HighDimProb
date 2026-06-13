import HighDimProb.Examples.RandomMatrix.RankOnePSDUsage
import HighDimProb.Examples.RandomMatrix.NTKGramDecompositionUsage
import HighDimProb.Examples.RandomMatrix.RandomFeatureKernelUsage
import HighDimProb.Examples.RandomMatrix.GradientCovarianceUsage
import HighDimProb.RandomMatrix.Spectral

/-!
# Kernel nullspace usage example

This examples-only file introduces nullspace and invisible-direction vocabulary
for kernel, NTK Gram, random-feature, and gradient covariance matrices. It
keeps the vocabulary deterministic and conservative. The PSD nullspace converse
is supplied by the core bridge in `HighDimProb.RandomMatrix.Spectral`.
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

/-- The examples-local `matrixAction` is Mathlib's matrix-vector
multiplication.

Formula reference: the PSD nullspace converse is stated for the usual matrix
action `A x`; see
https://math.stackexchange.com/questions/3918031/prove-that-if-xtax-0-rightarrow-ax-0 .
-/
theorem matrixAction_eq_mulVec {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (x : Fin (n + 1) -> Real) :
    matrixAction A x = Matrix.mulVec A x := by
  ext i
  simp [matrixAction, Matrix.mulVec, dotProduct]

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

/-- PSD nullspace converse for the examples-local invisible-direction
vocabulary, using Mathlib `Matrix.PosSemidef`.

Formula reference: a real symmetric positive semidefinite matrix with
`x^T A x = 0` sends `x` to zero; see
https://en.wikipedia.org/wiki/Definite_matrix#Square_root .
-/
theorem invisible_of_quadraticNull_of_posSemidef {n : Nat}
    {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    {x : Fin (n + 1) -> Real}
    (hPSD : A.PosSemidef)
    (hNull : KernelQuadraticNullDirection A x) :
    KernelInvisibleDirection A x := by
  unfold KernelQuadraticNullDirection at hNull
  unfold KernelInvisibleDirection
  rw [matrixAction_eq_mulVec]
  exact matrix_mulVec_eq_zero_of_posSemidef_quadraticForm_eq_zero hPSD hNull

/-- PSD nullspace converse for the examples-local vocabulary, using
HighDimProb's explicit `IsPSDMatrix` predicate. -/
theorem invisible_of_quadraticNull_of_psd {n : Nat}
    {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    {x : Fin (n + 1) -> Real}
    (hPSD : IsPSDMatrix A)
    (hNull : KernelQuadraticNullDirection A x) :
    KernelInvisibleDirection A x := by
  unfold KernelQuadraticNullDirection at hNull
  unfold KernelInvisibleDirection
  rw [matrixAction_eq_mulVec]
  exact matrix_mulVec_eq_zero_of_isPSDMatrix_quadraticForm_eq_zero hPSD hNull

/-- Pointwise random version of the Mathlib-PSD nullspace converse. -/
theorem randomInvisible_of_quadraticNull_of_posSemidef {Omega : Type*}
    [MeasurableSpace Omega] {n : Nat}
    {A : RandomMatrix Omega (n + 1) (n + 1)}
    {x : Fin (n + 1) -> Real}
    (hPSD : forall omega, Matrix.PosSemidef (A omega))
    (hNull : RandomKernelQuadraticNullDirection A x) :
    RandomKernelInvisibleDirection A x := by
  intro omega
  exact invisible_of_quadraticNull_of_posSemidef (hPSD omega) (hNull omega)

/-- Pointwise random version of the explicit-PSD nullspace converse. -/
theorem randomInvisible_of_quadraticNull_of_psd {Omega : Type*}
    [MeasurableSpace Omega] {P : MeasureTheory.Measure Omega} {n : Nat}
    {A : RandomMatrix Omega (n + 1) (n + 1)}
    {x : Fin (n + 1) -> Real}
    (hPSD : RandomPSDMatrix P A)
    (hNull : RandomKernelQuadraticNullDirection A x) :
    RandomKernelInvisibleDirection A x := by
  intro omega
  exact invisible_of_quadraticNull_of_psd (hPSD omega) (hNull omega)

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

/-- Example-local adapter for the PSD converse.

For PSD matrices the mathematical statement is that `x^T A x = 0` should
force `A x = 0`. This predicate is kept as compatibility vocabulary for older
examples; `psdQuadraticNullImpliesInvisible_of_core` below supplies it from the
core PSD nullspace bridge. -/
def PSDQuadraticNullImpliesInvisible {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) : Prop :=
  IsPSDMatrix A ->
    forall x : Fin (n + 1) -> Real,
      KernelQuadraticNullDirection A x -> KernelInvisibleDirection A x

/-- The core PSD nullspace bridge supplies the examples-local adapter. -/
theorem psdQuadraticNullImpliesInvisible_of_core {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) :
    PSDQuadraticNullImpliesInvisible A := by
  intro hPSD x hNull
  exact invisible_of_quadraticNull_of_psd hPSD hNull

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
