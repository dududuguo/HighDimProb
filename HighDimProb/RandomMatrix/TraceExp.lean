import Mathlib.Analysis.Normed.Algebra.MatrixExponential
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.ExpLog.Basic
import Mathlib.Data.Real.StarOrdered
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Probability.Independence.Basic
import HighDimProb.RandomMatrix.Spectral
import HighDimProb.RandomMatrix.VarianceProxy

/-!
# Matrix exponential and trace-exponential vocabulary

Verified Wikipedia references:
* Matrix exponential: https://en.wikipedia.org/wiki/Matrix_exponential
* Trace: https://en.wikipedia.org/wiki/Trace_(linear_algebra)
* Self-adjoint operator: https://en.wikipedia.org/wiki/Self-adjoint_operator
* Loewner order: https://en.wikipedia.org/wiki/Loewner_order

Note: Golden-Thompson-type trace-exponential inequalities are background for
this area, but this file's current comments only cite concepts directly present
in the definitions and theorem statements.

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

/-- Matrix exponential dominates its affine first-order lower bound in the
explicit HighDimProb Loewner-style order.

This is the CFC lift of the scalar inequality `x + 1 <= exp x`, converted from
Mathlib's matrix order to `MatrixLE`. -/
theorem matrixLE_one_add_self_le_matrixExp_of_selfAdjoint {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : IsSelfAdjointMatrix A) :
    MatrixLE ((1 : Matrix (Fin n) (Fin n) Real) + A) (matrixExp A) := by
  unfold MatrixLE
  have hle :
      (1 : Matrix (Fin n) (Fin n) Real) + A <= matrixExp A := by
    have hmono :
        cfc (fun x : Real => x + 1) A <= cfc Real.exp A := by
      exact cfc_mono (a := A)
        (f := fun x : Real => x + 1)
        (g := Real.exp)
        (by
          intro x _hx
          exact Real.add_one_le_exp x)
    have hlin :
        cfc (fun x : Real => x + 1) A =
          A + (1 : Matrix (Fin n) (Fin n) Real) := by
      calc
        cfc (fun x : Real => x + 1) A =
            cfc (fun x : Real => id x + (1 : Real)) A := rfl
        _ = cfc id A + cfc (1 : Real -> Real) A := by
            exact cfc_add A id (1 : Real -> Real)
        _ = A + (1 : Matrix (Fin n) (Fin n) Real) := by
            rw [cfc_id Real A hA.isSelfAdjoint, cfc_one Real A hA.isSelfAdjoint]
    have hexp : cfc Real.exp A = matrixExp A := by
      simpa [matrixExp] using
        (CFC.real_exp_eq_normedSpace_exp (a := A) hA.isSelfAdjoint)
    calc
      (1 : Matrix (Fin n) (Fin n) Real) + A =
          A + (1 : Matrix (Fin n) (Fin n) Real) := by
            rw [add_comm]
      _ = cfc (fun x : Real => x + 1) A := hlin.symm
      _ <= cfc Real.exp A := hmono
      _ = matrixExp A := hexp
  have hPSD :
      (matrixExp A - ((1 : Matrix (Fin n) (Fin n) Real) + A)).PosSemidef :=
    Matrix.le_iff.mp hle
  constructor
  · apply Matrix.IsSymm.ext
    intro i j
    have h := Matrix.IsHermitian.apply hPSD.isHermitian i j
    simpa using h
  · intro x
    exact matrixQuadraticForm_nonneg_of_posSemidef hPSD x

/-- Scalar-multiple wrapper for the matrix exponential affine lower bound. -/
theorem matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint {n : Nat}
    {V : Matrix (Fin n) (Fin n) Real} (c : Real)
    (hV : IsSelfAdjointMatrix V) :
    MatrixLE ((1 : Matrix (Fin n) (Fin n) Real) + SMul.smul c V)
      (matrixExp (SMul.smul c V)) := by
  exact matrixLE_one_add_self_le_matrixExp_of_selfAdjoint
    (isSelfAdjointMatrix_smul c hV)

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

/-! ## Typed Tropp/Lieb trace-mgf primitive -/

section TroppMasterTraceMGFStep

open scoped BigOperators MatrixOrder Matrix.Norms.Operator

/-- Typed Tropp master trace-mgf step.

This is the source-backed primitive
`E tr exp(H + Z) <= tr exp(H + log E exp Z)` from the Lieb/Tropp matrix-mgf
route. It is only a `Prop`-valued typed statement: the hard Lieb concavity and
Jensen/conditional-expectation proof is not supplied here.

All currently visible infrastructure assumptions are explicit. The matrix
exponential moment uses HighDimProb's entrywise `matrixExpect`, and the
self-adjointness and strict positivity needed to form the matrix logarithm are
assumptions rather than hidden providers. -/
abbrev troppMasterTraceMGFStep_statement {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (H : Matrix (Fin n) (Fin n) Real)
    (Z : RandomMatrix Omega n n) : Prop :=
  IsSelfAdjointMatrix H ->
    RandomSelfAdjointMatrix P Z ->
      IntegrableRealRandomVariable P
        (fun omega => traceMatrixExp (H + Z omega)) ->
        IntegrableRandomMatrix P (fun omega => matrixExp (Z omega)) ->
          IsSelfAdjointMatrix
            (matrixExpect P (fun omega => matrixExp (Z omega))) ->
            IsStrictlyPositive
              (matrixExpect P (fun omega => matrixExp (Z omega))) ->
              expect P (fun omega => traceMatrixExp (H + Z omega)) <=
                traceMatrixExp
                  (H + CFC.log
                    (matrixExpect P (fun omega => matrixExp (Z omega))))

end TroppMasterTraceMGFStep

/-! ## Typed Bernstein functional-calculus primitive -/

section BernsteinFunctionalCalculus

open scoped MatrixOrder Matrix.Norms.Operator

/-- Canonical bounded-Bernstein matrix-MGF coefficient. -/
def bernsteinMGFCoeff (theta R : Real) : Real :=
  (theta ^ 2 / 2) / (1 - abs theta * R / 3)

/-- Nonnegativity of the Bernstein quadratic coefficient under the standard
theta-range hypothesis. -/
theorem bernsteinCoefficient_nonneg {theta R : Real}
    (hRange : abs theta * R < 3) :
    0 <= (theta ^ 2 / 2) / (1 - abs theta * R / 3) := by
  have hNum : 0 <= theta ^ 2 / 2 := by
    exact div_nonneg (sq_nonneg theta) (by norm_num : (0 : Real) <= 2)
  have hDenPos : 0 < 1 - abs theta * R / 3 := by
    nlinarith [hRange]
  exact div_nonneg hNum (le_of_lt hDenPos)

/-- Named-coefficient wrapper for `bernsteinCoefficient_nonneg`. -/
theorem bernsteinMGFCoeff_nonneg {theta R : Real}
    (hRange : abs theta * R < 3) :
    0 <= bernsteinMGFCoeff theta R := by
  simpa [bernsteinMGFCoeff] using bernsteinCoefficient_nonneg hRange

/-- Semantic trace-mgf bound using the bounded-Bernstein coefficient.

This is the RHS normal form produced by the bounded single-summand Bernstein
MGF route. The older `TraceMGFVarianceProxyBound` remains available for the
subGaussian-style coefficient `theta ^ 2 / 2`. -/
def TraceMGFBernsteinVarianceProxyBound {Omega : Type*}
    [MeasurableSpace Omega] {n : Nat} (P : Measure Omega)
    (Y : RandomMatrix Omega n n) (V : Matrix (Fin n) (Fin n) Real)
    (theta R : Real) : Prop :=
  TraceMGFBound P Y theta
    (traceMatrixExp (SMul.smul (bernsteinMGFCoeff theta R) V))

/-- LIntegral-form trace-mgf bound using the bounded-Bernstein coefficient. -/
def TraceMGFBernsteinVarianceProxyBoundLIntegral {Omega : Type*}
    [MeasurableSpace Omega] {n : Nat} (P : Measure Omega)
    (Y : RandomMatrix Omega n n) (V : Matrix (Fin n) (Fin n) Real)
    (theta R : Real) : Prop :=
  TraceMGFBoundLIntegral P Y theta
    (ENNReal.ofReal
      (traceMatrixExp (SMul.smul (bernsteinMGFCoeff theta R) V)))

/-- Typed finite-family Tropp/Lieb trace-mgf comparison primitive.

This is the iteration-shaped interface needed by the Matrix Bernstein
trace-mgf route after the one-summand matrix-MGF comparison has been proved.
It is only a `Prop`-valued typed statement. It does not prove Lieb concavity,
Golden-Thompson, conditional expectation, independence iteration, or the
trace-mgf provider.

The primitive consumes explicit per-summand matrix-MGF comparisons
`E exp(theta X_i) <= exp(K_i)`, an independence assumption, full-sum
trace-exp integrability, and an explicit RHS normalization from
`sum_i K_i` to the bounded Bernstein coefficient normal form. Its conclusion
is the bounded semantic trace-mgf target for the random finite sum. The older
one-step log-form primitive `troppMasterTraceMGFStep_statement` remains
available for source-level Lieb/Tropp work. -/
abbrev troppMasterTraceMGFFiniteFamily_statement {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {I : Type*}
    [Fintype I] {n : Nat}
    (X : I -> RandomMatrix Omega n n)
    (K : I -> Matrix (Fin n) (Fin n) Real)
    (V : Matrix (Fin n) (Fin n) Real)
    (theta R : Real) : Prop :=
  (forall i, IsRandomMatrix P (X i)) ->
    (forall i, RandomSelfAdjointMatrix P (X i)) ->
      ProbabilityTheory.iIndepFun X P ->
        (forall i,
          IntegrableRandomMatrix P
            (fun omega => matrixExp (SMul.smul theta (X i omega)))) ->
          IntegrableRealRandomVariable P
            (traceExpIntegrand (randomMatrixSum X) theta) ->
            (forall i, IsSelfAdjointMatrix (K i)) ->
              IsSelfAdjointMatrix V ->
                0 <= R ->
                  abs theta * R < 3 ->
                    (forall i,
                      MatrixLE
                        (matrixExpect P
                          (fun omega =>
                            matrixExp (SMul.smul theta (X i omega))))
                        (matrixExp (K i))) ->
                      Finset.univ.sum (fun i : I => K i) =
                        SMul.smul (bernsteinMGFCoeff theta R) V ->
                        TraceMGFBernsteinVarianceProxyBound P (randomMatrixSum X)
                          V theta R

/-- Thin semantic trace-mgf provider from the finite-family Tropp typed
primitive.

This theorem does not prove the finite-family Tropp/Lieb primitive. It takes
that primitive as an explicit assumption and applies it to its fully exposed
hypotheses. -/
theorem traceMGFBernsteinVarianceProxyBound_of_troppMasterTraceMGFFiniteFamily
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {I : Type*} [Fintype I] {n : Nat}
    (X : I -> RandomMatrix Omega n n)
    (K : I -> Matrix (Fin n) (Fin n) Real)
    (V : Matrix (Fin n) (Fin n) Real) (theta R : Real)
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement (P := P) X K V theta R)
    (hRand : forall i, IsRandomMatrix P (X i))
    (hSA : forall i, RandomSelfAdjointMatrix P (X i))
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hExpInt :
      forall i,
        IntegrableRandomMatrix P
          (fun omega => matrixExp (SMul.smul theta (X i omega))))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum X) theta))
    (hKSA : forall i, IsSelfAdjointMatrix (K i))
    (hVSA : IsSelfAdjointMatrix V)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3)
    (hMGF :
      forall i,
        MatrixLE
          (matrixExpect P
            (fun omega => matrixExp (SMul.smul theta (X i omega))))
          (matrixExp (K i)))
    (hNorm :
      Finset.univ.sum (fun i : I => K i) =
        SMul.smul (bernsteinMGFCoeff theta R) V) :
    TraceMGFBernsteinVarianceProxyBound P (randomMatrixSum X) V theta R :=
  hTropp hRand hSA hIndep hExpInt hTraceInt hKSA hVSA hR hRange hMGF hNorm

/-- Typed Bernstein-specific scalar-to-matrix functional-calculus primitive.

This records the source-backed lift of the scalar Bernstein exponential
inequality to the explicit HighDimProb Loewner-style order:
`exp(theta A) <= I + theta A + g(theta, R) A^2`.

It is only a `Prop`-valued typed statement. The scalar Bernstein inequality,
CFC expression rewrites, conversion to `MatrixLE`, and
operator-norm-to-spectral-interval bridge are not proved here. -/
abbrev bernsteinMatrixExp_le_quadratic_statement {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) (theta R : Real) : Prop :=
  IsSelfAdjointMatrix A ->
    deterministicOperatorNorm A <= R ->
      0 <= R ->
        abs theta * R < 3 ->
          MatrixLE
            (matrixExp (SMul.smul theta A))
            ((1 : Matrix (Fin n) (Fin n) Real) +
              SMul.smul theta A +
                SMul.smul (bernsteinMGFCoeff theta R) (matrixSquare A))

end BernsteinFunctionalCalculus

/-! ## Typed single-summand matrix-mgf primitive -/

section SingleSummandMatrixMGF

open scoped MatrixOrder Matrix.Norms.Operator

/-- Typed single-summand matrix MGF variance-proxy primitive.

This records the source-backed Bernstein single-summand step
`E exp(theta X) <= exp(g(theta, R) V)` in the explicit HighDimProb
Loewner-style order. It is only a `Prop`-valued typed statement. The scalar
functional-calculus lift, matrix-valued expectation monotonicity, and
boundedness-to-spectrum bridge are not proved here.

All assumptions currently needed by the future proof route are explicit:
measurability, pointwise self-adjointness, integrability of `X`, `X^2`, and
`exp(theta X)`, entrywise zero mean, pointwise operator-norm boundedness,
theta-range, self-adjoint/PSD structure of the deterministic comparison
matrix, and the square/variance-proxy comparison. -/
abbrev singleSummandMatrixMGFVarianceProxy_statement {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (X : RandomMatrix Omega n n) (V : Matrix (Fin n) (Fin n) Real)
    (theta R : Real) : Prop :=
  IsRandomMatrix P X ->
    RandomSelfAdjointMatrix P X ->
      IntegrableRandomMatrix P X ->
        IntegrableRandomMatrix P (randomMatrixSquare X) ->
          IntegrableRandomMatrix P
            (fun omega => matrixExp (SMul.smul theta (X omega))) ->
            matrixExpect P X = 0 ->
              (forall omega, operatorNorm X omega <= R) ->
                0 <= R ->
                  abs theta * R < 3 ->
                    IsSelfAdjointMatrix V ->
                      IsPSDMatrix V ->
                        MatrixLE (matrixSecondMoment P X) V ->
                          MatrixLE
                            (matrixExpect P
                              (fun omega =>
                                matrixExp (SMul.smul theta (X omega))))
                            (matrixExp
                              (SMul.smul (bernsteinMGFCoeff theta R) V))

/-- Single-summand matrix MGF variance-proxy provider assuming the pointwise
Bernstein functional-calculus primitive.

This theorem does not prove the CFC primitive
`bernsteinMatrixExp_le_quadratic_statement`; it takes that primitive as an
explicit pointwise assumption and assembles the expectation monotonicity,
linearity, variance-proxy comparison, coefficient nonnegativity, and
exponential lower-bound infrastructure. -/
theorem singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {n : Nat}
    (X : RandomMatrix Omega n n)
    (V : Matrix (Fin n) (Fin n) Real) (theta R : Real)
    (hCFC :
      forall omega,
        bernsteinMatrixExp_le_quadratic_statement (X omega) theta R) :
  singleSummandMatrixMGFVarianceProxy_statement (P := P) X V theta R := by
  intro hRand hSA hIntX hIntSq hIntExp hMeanZero hBound hR hRange hVSA hVPSD hSecond
  let c : Real := bernsteinMGFCoeff theta R
  let rhsRandom : RandomMatrix Omega n n :=
    fun omega =>
      (1 : Matrix (Fin n) (Fin n) Real) + SMul.smul theta (X omega) +
        SMul.smul c (matrixSquare (X omega))
  have hConstInt :
      IntegrableRandomMatrix P
        (fun _omega => (1 : Matrix (Fin n) (Fin n) Real)) :=
    integrableRandomMatrix_const (P := P) (1 : Matrix (Fin n) (Fin n) Real)
  have hThetaInt :
      IntegrableRandomMatrix P (fun omega => SMul.smul theta (X omega)) :=
    integrableRandomMatrix_smul theta hIntX
  have hCoeffInt :
      IntegrableRandomMatrix P
        (fun omega => SMul.smul c (matrixSquare (X omega))) := by
    simpa [c, randomMatrixSquare] using
      (integrableRandomMatrix_smul c hIntSq)
  have hRhsInt : IntegrableRandomMatrix P rhsRandom := by
    exact integrableRandomMatrix_add
      (integrableRandomMatrix_add hConstInt hThetaInt) hCoeffInt
  have hPointwise :
      forall omega,
        MatrixLE
          (matrixExp (SMul.smul theta (X omega)))
          (rhsRandom omega) := by
    intro omega
    dsimp [rhsRandom, c]
    exact hCFC omega (hSA omega) (by simpa [operatorNorm] using hBound omega)
      hR hRange
  have hExpectToRhs :
      MatrixLE
        (matrixExpect P
          (fun omega => matrixExp (SMul.smul theta (X omega))))
        (matrixExpect P rhsRandom) :=
    matrixExpect_matrixLE_of_pointwise_matrixLE hIntExp hRhsInt hPointwise
  have hRhsExpect :
      matrixExpect P rhsRandom =
        (1 : Matrix (Fin n) (Fin n) Real) +
          SMul.smul theta (matrixExpect P X) +
            SMul.smul c (matrixSecondMoment P X) := by
    have hThetaExp :
        matrixExpect P (fun omega => SMul.smul theta (X omega)) =
          SMul.smul theta (matrixExpect P X) :=
      matrixExpect_smul theta
    have hCoeffExp :
        matrixExpect P (fun omega => SMul.smul c (matrixSquare (X omega))) =
          SMul.smul c (matrixExpect P (randomMatrixSquare X)) := by
      simpa [c, randomMatrixSquare] using
        (matrixExpect_smul (P := P) (A := randomMatrixSquare X) c)
    calc
      matrixExpect P rhsRandom =
          matrixExpect P
              (fun omega =>
                (1 : Matrix (Fin n) (Fin n) Real) +
                  SMul.smul theta (X omega)) +
            matrixExpect P
              (fun omega => SMul.smul c (matrixSquare (X omega))) := by
            rw [matrixExpect_add
              (integrableRandomMatrix_add hConstInt hThetaInt) hCoeffInt]
      _ =
          (matrixExpect P
              (fun _omega => (1 : Matrix (Fin n) (Fin n) Real)) +
            matrixExpect P (fun omega => SMul.smul theta (X omega))) +
            matrixExpect P
              (fun omega => SMul.smul c (matrixSquare (X omega))) := by
            rw [matrixExpect_add hConstInt hThetaInt]
      _ =
        (1 : Matrix (Fin n) (Fin n) Real) +
          SMul.smul theta (matrixExpect P X) +
            SMul.smul c (matrixSecondMoment P X) := by
            simp [matrixExpect_const_of_isProbabilityMeasure, hThetaExp, hCoeffExp,
              matrixSecondMoment, add_assoc]
  have hRhsCentered :
      matrixExpect P rhsRandom =
        (1 : Matrix (Fin n) (Fin n) Real) +
          SMul.smul c (matrixSecondMoment P X) := by
    calc
      matrixExpect P rhsRandom =
          (1 : Matrix (Fin n) (Fin n) Real) +
            SMul.smul theta (matrixExpect P X) +
              SMul.smul c (matrixSecondMoment P X) := hRhsExpect
      _ =
          (1 : Matrix (Fin n) (Fin n) Real) +
            SMul.smul theta (0 : Matrix (Fin n) (Fin n) Real) +
              SMul.smul c (matrixSecondMoment P X) := by
            rw [hMeanZero]
      _ =
          (1 : Matrix (Fin n) (Fin n) Real) +
            SMul.smul c (matrixSecondMoment P X) := by
            have hThetaZero :
                SMul.smul theta (0 : Matrix (Fin n) (Fin n) Real) =
                  (0 : Matrix (Fin n) (Fin n) Real) := by
              exact smul_zero theta
            rw [hThetaZero, add_zero]
  have hRhsToSecond :
      MatrixLE
        (matrixExpect P rhsRandom)
        ((1 : Matrix (Fin n) (Fin n) Real) +
          SMul.smul c (matrixSecondMoment P X)) :=
    matrixLE_of_eq hRhsCentered
  have hCoeffNonneg : 0 <= c := by
    dsimp [c]
    exact bernsteinMGFCoeff_nonneg hRange
  have hSecondToV :
      MatrixLE
        ((1 : Matrix (Fin n) (Fin n) Real) +
          SMul.smul c (matrixSecondMoment P X))
        ((1 : Matrix (Fin n) (Fin n) Real) + SMul.smul c V) :=
    matrixLE_add_left (1 : Matrix (Fin n) (Fin n) Real)
      (matrixLE_smul_of_nonneg hCoeffNonneg hSecond)
  have hVToExp :
      MatrixLE
        ((1 : Matrix (Fin n) (Fin n) Real) + SMul.smul c V)
        (matrixExp (SMul.smul c V)) :=
    matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint c hVSA
  have hFinal :
      MatrixLE
        (matrixExpect P
          (fun omega => matrixExp (SMul.smul theta (X omega))))
        (matrixExp (SMul.smul c V)) :=
    matrixLE_trans hExpectToRhs
      (matrixLE_trans hRhsToSecond (matrixLE_trans hSecondToV hVToExp))
  simpa [c] using hFinal

end SingleSummandMatrixMGF

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

/-- Trace-exp is bounded by dimension times the largest exponential eigenvalue.

This is the deterministic eigenvalue-count step used before applying a
separate spectral/norm bound to the input matrix. -/
private theorem traceMatrixExp_le_card_mul_exp_lambdaMaxOrdered
    {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) :
    traceMatrixExp A <=
      (n + 1 : Real) * Real.exp (lambdaMaxOrdered A hA) := by
  classical
  let hExpA : IsSelfAdjointMatrix (matrixExp A) :=
    isSelfAdjointMatrix_matrixExp hA
  let e : Fin (Fintype.card (Fin (n + 1))) ≃ Fin (n + 1) :=
    Fintype.equivOfCardEq (by simp)
  have htrace :
      Matrix.trace (matrixExp A) = ∑ i, hExpA.eigenvalues i :=
    hExpA.trace_eq_sum_eigenvalues
  have hterm :
      ∀ i : Fin (n + 1),
        hExpA.eigenvalues i <=
          lambdaMaxOrdered (matrixExp A) hExpA := by
    intro i
    have hgreat :=
      lambdaMaxOrdered_is_greatest_eigenvalue (matrixExp A) hExpA (e.symm i)
    simpa [lambdaMaxOrdered, Matrix.IsHermitian.eigenvalues, e] using hgreat
  calc
    traceMatrixExp A
        = ∑ i : Fin (n + 1), hExpA.eigenvalues i := by
          simpa [traceMatrixExp, matrixTrace] using htrace
    _ <= ∑ _i : Fin (n + 1), lambdaMaxOrdered (matrixExp A) hExpA := by
          exact Finset.sum_le_sum (by
            intro i _hi
            exact hterm i)
    _ = (n + 1 : Real) * lambdaMaxOrdered (matrixExp A) hExpA := by
          simp [Finset.sum_const, nsmul_eq_mul]
    _ = (n + 1 : Real) * Real.exp (lambdaMaxOrdered A hA) := by
          rw [lambdaMaxOrdered_matrixExp hA]

/-- Deterministic trace-exponential dimension bound under a direct ordered
lambda-max upper bound.

This is generic deterministic spectral infrastructure.  It does not mention
random matrices, variance proxies, Bernstein coefficients, or tail bounds. -/
theorem traceMatrixExp_smul_le_card_exp_of_lambdaMaxOrdered_le
    {n : Nat} {V : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (c sigmaSq : Real)
    (hc : 0 <= c)
    (hV : IsSelfAdjointMatrix V)
    (hSpec : lambdaMaxOrdered V hV <= sigmaSq) :
    traceMatrixExp (c • V) <=
      (n + 1 : Real) * Real.exp (c * sigmaSq) := by
  let hCV : IsSelfAdjointMatrix (c • V) :=
    isSelfAdjointMatrix_smul c hV
  have hTrace :
      traceMatrixExp (c • V) <=
        (n + 1 : Real) *
          Real.exp (lambdaMaxOrdered (c • V) hCV) :=
    traceMatrixExp_le_card_mul_exp_lambdaMaxOrdered hCV
  have hLambda :
      lambdaMaxOrdered (c • V) hCV <= c * sigmaSq := by
    change
      lambdaMaxOrdered (c • V) (isSelfAdjointMatrix_smul c hV) <=
        c * sigmaSq
    rw [lambdaMaxOrdered_smul_of_nonneg c hc hV]
    exact mul_le_mul_of_nonneg_left hSpec hc
  have hExp :
      Real.exp (lambdaMaxOrdered (c • V) hCV) <=
        Real.exp (c * sigmaSq) :=
    Real.exp_le_exp.mpr hLambda
  have hCardNonneg : 0 <= (n + 1 : Real) := by
    positivity
  exact le_trans hTrace (mul_le_mul_of_nonneg_left hExp hCardNonneg)

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

/-- Convert a bounded-Bernstein real trace-MGF semantic bound into its
lintegral semantic form.

This is only the real-to-lintegral bridge. It does not prove a trace-MGF
provider, a Laplace event theorem, dimension/norm reduction, theta
optimization, or Matrix Bernstein. -/
theorem traceMGFBernsteinVarianceProxyBoundLIntegral_of_traceMGFBernsteinVarianceProxyBound
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : RandomMatrix Omega n n) (V : Matrix (Fin n) (Fin n) Real)
    (theta R : Real)
    (hY : RandomSelfAdjointMatrix P Y)
    (hInt : IntegrableRealRandomVariable P (traceExpIntegrand Y theta))
    (hReal : TraceMGFBernsteinVarianceProxyBound P Y V theta R) :
    TraceMGFBernsteinVarianceProxyBoundLIntegral P Y V theta R := by
  have hRaw :
      traceExpMoment P Y theta <=
        traceMatrixExp (SMul.smul (bernsteinMGFCoeff theta R) V) := by
    simpa [TraceMGFBernsteinVarianceProxyBound, TraceMGFBound] using hReal
  unfold TraceMGFBernsteinVarianceProxyBoundLIntegral TraceMGFBoundLIntegral
  rw [traceExpMomentLIntegral_eq_ofReal_traceExpMoment
    Y theta hInt (traceExpIntegrand_nonneg_of_randomSelfAdjoint theta hY)]
  exact ENNReal.ofReal_le_ofReal hRaw

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

/-- Typed target for future bounded-Bernstein variance-proxy trace-mgf bounds.

This variant records the denominator coefficient used by the bounded Matrix
Bernstein single-summand route. The hard trace-mgf provider remains deferred. -/
abbrev traceMGFBernsteinVarianceProxyBound_statement {Omega : Type*}
    [MeasurableSpace Omega] {n : Nat} (P : Measure Omega)
    (Y : RandomMatrix Omega n n) (V : Matrix (Fin n) (Fin n) Real)
    (theta R : Real) : Prop :=
  RandomSelfAdjointMatrix P Y ->
    IsPSDMatrix V ->
      0 <= theta ->
        abs theta * R < 3 ->
          TraceMGFBernsteinVarianceProxyBound P Y V theta R

end

end HighDimProb
