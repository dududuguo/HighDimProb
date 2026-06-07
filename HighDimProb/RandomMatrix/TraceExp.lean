import Mathlib.Analysis.Normed.Algebra.MatrixExponential
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.ExpLog.Basic
import Mathlib.Data.Real.StarOrdered
import Mathlib.LinearAlgebra.Matrix.PosDef
import HighDimProb.RandomMatrix.Spectral
import HighDimProb.RandomMatrix.VarianceProxy

/-!
# Matrix exponential and trace-exponential vocabulary

Mathlib provides matrix exponential facts through `NormedSpace.exp` and
`Mathlib.Analysis.Normed.Algebra.MatrixExponential`. This module wraps those
objects with HighDimProb-facing names for future matrix Laplace and trace-mgf
arguments.

No Golden-Thompson, Lieb, trace-mgf, or matrix Bernstein theorem is proved
here.
-/

namespace HighDimProb

open MeasureTheory

noncomputable section

/-- Matrix exponential wrapper using Mathlib's `NormedSpace.exp`. -/
def matrixExp {n : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    Matrix (Fin n) (Fin n) Real :=
  NormedSpace.exp A

@[simp]
theorem matrixExp_apply {n : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    matrixExp A = NormedSpace.exp A :=
  rfl

/-- Matrix trace wrapper. -/
def matrixTrace {n : Nat} (A : Matrix (Fin n) (Fin n) Real) : Real :=
  Matrix.trace A

@[simp]
theorem matrixTrace_apply {n : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    matrixTrace A = Matrix.trace A :=
  rfl

/-- Trace of the matrix exponential. -/
def traceMatrixExp {n : Nat} (A : Matrix (Fin n) (Fin n) Real) : Real :=
  matrixTrace (matrixExp A)

@[simp]
theorem traceMatrixExp_apply {n : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    traceMatrixExp A = Matrix.trace (NormedSpace.exp A) :=
  rfl

/-- Matrix exponentials preserve real self-adjointness. -/
theorem isSelfAdjointMatrix_matrixExp {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : IsSelfAdjointMatrix A) :
    IsSelfAdjointMatrix (matrixExp A) := by
  simpa [matrixExp] using Matrix.IsHermitian.exp hA

/-- A Mathlib-positive-semidefinite matrix has nonnegative trace. -/
theorem matrixTrace_nonneg_of_posSemidef {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : Matrix.PosSemidef A) :
    0 <= matrixTrace A := by
  simpa [matrixTrace] using hA.trace_nonneg

/-- If the matrix exponential is known to be Mathlib-positive-semidefinite,
then its trace is nonnegative.  The remaining self-adjoint-to-PSD bridge is
recorded by `matrixExp_posSemidef_of_selfAdjoint_statement`. -/
theorem traceMatrixExp_nonneg_of_matrixExp_posSemidef {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real}
    (hA : Matrix.PosSemidef (matrixExp A)) :
    0 <= traceMatrixExp A := by
  simpa [traceMatrixExp] using
    (matrixTrace_nonneg_of_posSemidef (A := matrixExp A) hA)

/-- Compatibility target: the matrix exponential of a real self-adjoint matrix
is Mathlib-positive-semidefinite. -/
abbrev matrixExp_posSemidef_of_selfAdjoint_statement {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) : Prop :=
  IsSelfAdjointMatrix A -> Matrix.PosSemidef (matrixExp A)

section MatrixExpPosSemidef

open scoped MatrixOrder Matrix.Norms.Operator

/-- The matrix exponential of a real self-adjoint matrix is
Mathlib-positive-semidefinite.

The proof uses Mathlib's scoped matrix Loewner order and the CFC theorem
`IsSelfAdjoint.exp_nonneg`, then converts `0 <= exp A` back to
`Matrix.PosSemidef`. -/
theorem matrixExp_posSemidef_of_selfAdjoint {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : IsSelfAdjointMatrix A) :
    Matrix.PosSemidef (matrixExp A) := by
  exact Matrix.nonneg_iff_posSemidef.mp (by
    simpa [matrixExp] using IsSelfAdjoint.exp_nonneg hA.isSelfAdjoint)

end MatrixExpPosSemidef

/-- Square-factor proof of PSD for the matrix exponential of a real
self-adjoint matrix.

This factors `exp A` as `exp (A/2) * exp (A/2)`, rewrites the first factor as
the conjugate transpose of the second using Hermitian preservation, and then
applies Mathlib's PSD theorem for `Bᴴ * B`. -/
private theorem matrixExp_posSemidef_of_selfAdjoint_square {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : IsSelfAdjointMatrix A) :
    Matrix.PosSemidef (matrixExp A) := by
  let H : Matrix (Fin n) (Fin n) Real :=
    SMul.smul (((1 : Real) / (2 : Real))) A
  let E : Matrix (Fin n) (Fin n) Real := matrixExp H
  have hH : IsSelfAdjointMatrix H := by
    have hHalf : IsSelfAdjoint (((1 : Real) / (2 : Real))) := by
      simp [IsSelfAdjoint]
    change (SMul.smul (((1 : Real) / (2 : Real))) A).IsHermitian
    exact hA.smul hHalf
  have hE : IsSelfAdjointMatrix E := by
    simpa [E] using isSelfAdjointMatrix_matrixExp hH
  have hPSD : Matrix.PosSemidef (E * E) := by
    have hSquare : Matrix.PosSemidef (star E * E) := by
      simpa using Matrix.posSemidef_conjTranspose_mul_self E
    have hStarE : star E = E := hE.eq
    simpa [hStarE] using hSquare
  have hsplit : A = H + H := by
    ext i j
    change A i j =
      (((1 : Real) / (2 : Real)) * A i j) +
        (((1 : Real) / (2 : Real)) * A i j)
    ring
  have hExpSplit : matrixExp A = E * E := by
    rw [matrixExp, hsplit]
    simpa [E, matrixExp] using Matrix.exp_add_of_commute H H (Commute.refl H)
  rw [hExpSplit]
  exact hPSD

/-- Trace-exponential moment of a random square matrix at scalar parameter
`theta`.

This is the scalar integrand shared by the raw expectation and lintegral
versions below. -/
def traceExpIntegrand {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (Y : RandomMatrix Omega n n) (theta : Real) : RealRandomVariable Omega :=
  fun omega => traceMatrixExp (SMul.smul theta (Y omega))

/-- Trace-exponential moment of a random square matrix at scalar parameter
`theta`.

This is a raw expectation wrapper. Integrability and finiteness hypotheses
belong in theorem statements using it. -/
def traceExpMoment {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : Measure Omega) (Y : RandomMatrix Omega n n) (theta : Real) : Real :=
  expect P (traceExpIntegrand Y theta)

/-- LIntegral version of the trace-exponential moment.

This is the nonnegative-integral object needed by Markov/Laplace arguments.
The bridge to the raw real expectation is kept as a statement target below
because it requires nonnegativity and integrability of the trace-exponential
random variable. -/
def traceExpMomentLIntegral {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : Measure Omega) (Y : RandomMatrix Omega n n) (theta : Real) : ENNReal :=
  ∫⁻ omega, ENNReal.ofReal (traceExpIntegrand Y theta omega) ∂P

/-! ## Semantic trace-mgf bounds -/

/-- Semantic real trace-mgf upper bound.

`TraceMGFBound P Y theta rhs` means the raw trace-exponential moment of `Y`
at `theta` is bounded by the deterministic real value `rhs`. Integrability and
provider assumptions are deliberately external. -/
def TraceMGFBound {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : Measure Omega) (Y : RandomMatrix Omega n n) (theta rhs : Real) : Prop :=
  traceExpMoment P Y theta <= rhs

/-- Semantic lintegral trace-mgf upper bound.

This is the nonnegative-integral counterpart of `TraceMGFBound`, used by the
already proved lintegral Laplace wrappers. -/
def TraceMGFBoundLIntegral {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : Measure Omega) (Y : RandomMatrix Omega n n) (theta : Real)
    (rhs : ENNReal) : Prop :=
  traceExpMomentLIntegral P Y theta <= rhs

/-- Semantic trace-mgf bound supplied by a deterministic variance-proxy matrix.

This records the usual future matrix-mgf target without proving the
Golden-Thompson/Lieb or independence machinery needed to establish it. -/
def TraceMGFVarianceProxyBound {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (P : Measure Omega) (Y : RandomMatrix Omega n n)
    (V : Matrix (Fin n) (Fin n) Real) (theta : Real) : Prop :=
  TraceMGFBound P Y theta (traceMatrixExp ((theta ^ 2 / 2) • V))

/-- LIntegral-form trace-mgf bound supplied by a deterministic variance-proxy
matrix. -/
def TraceMGFVarianceProxyBoundLIntegral {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (P : Measure Omega) (Y : RandomMatrix Omega n n)
    (V : Matrix (Fin n) (Fin n) Real) (theta : Real) : Prop :=
  TraceMGFBoundLIntegral P Y theta
    (ENNReal.ofReal (traceMatrixExp ((theta ^ 2 / 2) • V)))

/-- Typed target: trace of the exponential of a real self-adjoint matrix is
nonnegative.

The theorem below now proves this target via
`matrixExp_posSemidef_of_selfAdjoint` and
`traceMatrixExp_nonneg_of_matrixExp_posSemidef`. -/
abbrev traceMatrixExp_nonneg_of_selfAdjoint_statement {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) : Prop :=
  IsSelfAdjointMatrix A -> 0 <= traceMatrixExp A

/-- Trace of the exponential of a real self-adjoint matrix is nonnegative. -/
theorem traceMatrixExp_nonneg_of_selfAdjoint {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : IsSelfAdjointMatrix A) :
    0 <= traceMatrixExp A :=
  traceMatrixExp_nonneg_of_matrixExp_posSemidef
    (matrixExp_posSemidef_of_selfAdjoint hA)

section LambdaMaxOrderedMatrixExp

open scoped MatrixOrder Matrix.Norms.Operator

/-- The real spectrum of the matrix exponential of a self-adjoint real matrix
is the pointwise real exponential image of the original real spectrum. -/
private theorem matrixExp_spectrum_real_eq_exp_image {n : Nat}
    {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) :
    spectrum Real (matrixExp A) = Real.exp '' spectrum Real A := by
  rw [matrixExp]
  rw [← CFC.real_exp_eq_normedSpace_exp (a := A) hA.isSelfAdjoint]
  exact cfc_map_spectrum Real.exp A hA.isSelfAdjoint

/-- The ordered lambda-max endpoint is a real spectral value. -/
private theorem lambdaMaxOrdered_mem_spectrum_real_for_traceExp {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) :
    lambdaMaxOrdered A hA ∈ spectrum Real A := by
  classical
  let e : Fin (Fintype.card (Fin (n + 1))) ≃ Fin (n + 1) :=
    Fintype.equivOfCardEq (by simp)
  have hmem := hA.eigenvalues_mem_spectrum_real (e 0)
  simpa [lambdaMaxOrdered, Matrix.IsHermitian.eigenvalues, e] using hmem

/-- Every real spectral value of a self-adjoint matrix is bounded by the
ordered endpoint. -/
private theorem spectrum_real_le_lambdaMaxOrdered_for_traceExp {n : Nat}
    {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) {x : Real}
    (hx : x ∈ spectrum Real A) :
    x <= lambdaMaxOrdered A hA := by
  classical
  rw [hA.spectrum_real_eq_range_eigenvalues] at hx
  rcases hx with ⟨i, rfl⟩
  dsimp [lambdaMaxOrdered, Matrix.IsHermitian.eigenvalues]
  exact hA.eigenvalues₀_antitone (Fin.zero_le _)

/-- The ordered largest eigenvalue of the matrix exponential is the real
exponential of the ordered largest eigenvalue. -/
theorem lambdaMaxOrdered_matrixExp
    {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) :
    lambdaMaxOrdered (matrixExp A) (isSelfAdjointMatrix_matrixExp hA)
      = Real.exp (lambdaMaxOrdered A hA) := by
  classical
  let hExpA : IsSelfAdjointMatrix (matrixExp A) :=
    isSelfAdjointMatrix_matrixExp hA
  change lambdaMaxOrdered (matrixExp A) hExpA
      = Real.exp (lambdaMaxOrdered A hA)
  apply le_antisymm
  · have hmemExp :
        lambdaMaxOrdered (matrixExp A) hExpA ∈ spectrum Real (matrixExp A) :=
      lambdaMaxOrdered_mem_spectrum_real_for_traceExp (matrixExp A) hExpA
    have hspectrum :
        spectrum Real (matrixExp A) = Real.exp '' spectrum Real A :=
      matrixExp_spectrum_real_eq_exp_image hA
    rw [hspectrum] at hmemExp
    rcases hmemExp with ⟨mu, hmu, hmul⟩
    rw [← hmul]
    exact Real.exp_le_exp.mpr
      (spectrum_real_le_lambdaMaxOrdered_for_traceExp hA hmu)
  · have hmemTop :
        Real.exp (lambdaMaxOrdered A hA) ∈ spectrum Real (matrixExp A) := by
      rw [matrixExp_spectrum_real_eq_exp_image hA]
      exact ⟨lambdaMaxOrdered A hA,
        lambdaMaxOrdered_mem_spectrum_real_for_traceExp A hA, rfl⟩
    exact spectrum_real_le_lambdaMaxOrdered_for_traceExp hExpA hmemTop

end LambdaMaxOrderedMatrixExp

/-- Typed target for nonnegativity of the real trace-exponential moment. -/
abbrev traceExpMoment_nonneg_statement {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (P : Measure Omega) (Y : RandomMatrix Omega n n)
    (theta : Real) : Prop :=
  RandomSelfAdjointMatrix P Y ->
    0 <= theta ->
      0 <= traceExpMoment P Y theta

/-- The real trace-exponential moment is nonnegative whenever its scalar
integrand is pointwise nonnegative. -/
theorem traceExpMoment_nonneg_of_nonneg {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} (Y : RandomMatrix Omega n n)
    (theta : Real)
    (hNonneg : forall omega, 0 <= traceExpIntegrand Y theta omega) :
    0 <= traceExpMoment P Y theta := by
  simpa [traceExpMoment] using
    integral_nonneg_of_ae (ae_of_all P hNonneg)

/-- The trace-exponential integrand is pointwise nonnegative for a random
self-adjoint matrix, for every real scalar parameter. -/
theorem traceExpIntegrand_nonneg_of_randomSelfAdjoint {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {Y : RandomMatrix Omega n n} (theta : Real)
    (hY : RandomSelfAdjointMatrix P Y) :
    forall omega, 0 <= traceExpIntegrand Y theta omega := by
  intro omega
  exact traceMatrixExp_nonneg_of_selfAdjoint
    (isSelfAdjointMatrix_smul theta (hY omega))

/-- The real trace-exponential moment is nonnegative for a random
self-adjoint matrix, for every real scalar parameter. -/
theorem traceExpMoment_nonneg_of_randomSelfAdjoint {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : RandomMatrix Omega n n) (theta : Real)
    (hY : RandomSelfAdjointMatrix P Y) :
    0 <= traceExpMoment P Y theta := by
  exact traceExpMoment_nonneg_of_nonneg Y theta
    (traceExpIntegrand_nonneg_of_randomSelfAdjoint theta hY)

/-- The lintegral trace-exponential moment is always nonnegative as an
`ENNReal` value. -/
theorem traceExpMomentLIntegral_nonneg {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} (Y : RandomMatrix Omega n n)
    (theta : Real) :
    0 <= traceExpMomentLIntegral P Y theta := by
  exact bot_le

/-- Typed target connecting the lintegral and real-expectation trace-exp
moments under the hypotheses future Laplace proofs should make explicit. -/
abbrev traceExpMomentLIntegral_eq_ofReal_statement {Omega : Type*}
    [MeasurableSpace Omega] {n : Nat} (P : Measure Omega)
    (Y : RandomMatrix Omega n n) (theta : Real) : Prop :=
  IntegrableRealRandomVariable P (traceExpIntegrand Y theta) ->
    (forall omega, 0 <= traceExpIntegrand Y theta omega) ->
      traceExpMomentLIntegral P Y theta =
        ENNReal.ofReal (traceExpMoment P Y theta)

/-- For a nonnegative integrable trace-exponential integrand, the lintegral
through `ENNReal.ofReal` is the `ENNReal.ofReal` of the raw real expectation. -/
theorem traceExpMomentLIntegral_eq_ofReal_traceExpMoment {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : RandomMatrix Omega n n) (theta : Real)
    (hInt : IntegrableRealRandomVariable P (traceExpIntegrand Y theta))
    (hNonneg : forall omega, 0 <= traceExpIntegrand Y theta omega) :
    traceExpMomentLIntegral P Y theta =
      ENNReal.ofReal (traceExpMoment P Y theta) := by
  rw [traceExpMomentLIntegral, traceExpMoment]
  exact (ofReal_integral_eq_lintegral_ofReal hInt (ae_of_all P hNonneg)).symm

/-- Typed target for future trace-exponential moment bounds.

The right side is supplied as a scalar bound so different future trace-mgf
theorems can choose their own constants and variance proxies. -/
abbrev traceExpMomentBoundStatement {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (P : Measure Omega) (Y : RandomMatrix Omega n n)
    (theta rhs : Real) : Prop :=
  RandomSelfAdjointMatrix P Y ->
    0 <= theta ->
      traceExpMoment P Y theta <= rhs

/-- Typed target for the matrix-Bernstein-style trace-mgf bound using a
deterministic variance proxy matrix. -/
abbrev traceExpVarianceProxyBoundStatement {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (P : Measure Omega) (Y : RandomMatrix Omega n n)
    (V : Matrix (Fin n) (Fin n) Real) (theta : Real) : Prop :=
  RandomSelfAdjointMatrix P Y ->
    IsPSDMatrix V ->
      0 <= theta ->
        traceExpMoment P Y theta <= traceMatrixExp ((theta ^ 2 / 2) • V)

/-! ## Typed trace-mgf targets over the semantic layer -/

/-- Typed target for future real trace-mgf bounds, stated through the semantic
predicate rather than directly through `traceExpMoment`. -/
abbrev traceMGFBound_statement {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (P : Measure Omega) (Y : RandomMatrix Omega n n)
    (theta rhs : Real) : Prop :=
  RandomSelfAdjointMatrix P Y ->
    0 <= theta ->
      TraceMGFBound P Y theta rhs

/-- Typed target for future lintegral trace-mgf bounds. -/
abbrev traceMGFBoundLIntegral_statement {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (P : Measure Omega) (Y : RandomMatrix Omega n n)
    (theta : Real) (rhs : ENNReal) : Prop :=
  RandomSelfAdjointMatrix P Y ->
    0 <= theta ->
      TraceMGFBoundLIntegral P Y theta rhs

/-- Typed target for future variance-proxy trace-mgf bounds. This is the
semantic form of `traceExpVarianceProxyBoundStatement`; the hard provider proof
is intentionally deferred. -/
abbrev traceMGFVarianceProxyBound_statement {Omega : Type*}
    [MeasurableSpace Omega] {n : Nat} (P : Measure Omega)
    (Y : RandomMatrix Omega n n) (V : Matrix (Fin n) (Fin n) Real)
    (theta : Real) : Prop :=
  RandomSelfAdjointMatrix P Y ->
    IsPSDMatrix V ->
      0 <= theta ->
        TraceMGFVarianceProxyBound P Y V theta

end

end HighDimProb
