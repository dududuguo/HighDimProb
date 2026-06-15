import HighDimProb.RandomMatrix.Assumptions
import HighDimProb.RandomMatrix.Algebra
import HighDimProb.RandomMatrix.MatrixOrder
import HighDimProb.RandomMatrix.OperatorNorm
import HighDimProb.RandomMatrix.Sums
import HighDimProb.RandomMatrix.VarianceProxy
import HighDimProb.RandomMatrix.Laplace
import HighDimProb.Tail
import Mathlib.Analysis.Normed.Algebra.Spectrum

/-!
# Matrix concentration assumption vocabulary and typed statements

Verified Wikipedia references:
* Matrix Chernoff bound: https://en.wikipedia.org/wiki/Matrix_Chernoff_bound
* Bernstein inequalities: https://en.wikipedia.org/wiki/Bernstein_inequalities_(probability_theory)
* Concentration inequality: https://en.wikipedia.org/wiki/Concentration_inequality
* Random matrix: https://en.wikipedia.org/wiki/Random_matrix

This file contains assumption vocabulary and theorem-target `Prop`
specifications for future matrix concentration work. It intentionally does not
prove matrix Bernstein, matrix Hoeffding, matrix Chernoff, Hanson-Wright, or
covariance estimation.
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators Matrix.Norms.L2Operator

noncomputable section

/-- Sample covariance centered at the identity, as a random matrix. -/
def sampleCovarianceMinusIdentity {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (A : RandomMatrix Omega m n) : RandomMatrix Omega n n :=
  fun omega => sampleCovariance A omega - (1 : Matrix (Fin n) (Fin n) Real)

/-- Typed target for a future finite-dimensional matrix Bernstein theorem.

This is the original MC1/MC3 min-form statement. The PSD hypothesis on the
variance proxy remains explicit for compatibility with the earlier public API.
For the proof-oriented self-adjoint statement below, PSD is instead supplied by
`isPSD_matrixVarianceProxy_of_selfAdjoint` from centered self-adjoint summands
and per-summand square integrability. -/
abbrev matrixBernsteinStatement {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) (sigma2 R c t : Real) : Prop :=
  CenteredSelfAdjointRandomMatrixFamily P A ->
    IndependentSelfAdjointRandomMatrices P A ->
      PointwiseOperatorNormBound A R ->
        IsPSDMatrix (matrixVarianceProxy P A) ->
          matrixVarianceProxyNorm P A <= sigma2 ->
            0 <= t ->
              upperTailProb P (operatorNorm (randomMatrixSum A)) t <=
                ENNReal.ofReal
                  (2 * (n : Real) * Real.exp (-(c * min (t ^ 2 / sigma2) (t / R))))

/-- Refined matrix Bernstein statement with additive denominator form.

This is still a typed `Prop` target, not a theorem. It is proof-oriented:
entrywise integrability of each summand, entrywise integrability of each
matrix square, centered self-adjointness, matrix-valued independence, a
pointwise operator-norm bound, nonnegative scale parameters, positive
denominator constants, and denominator positivity are all visible assumptions.
The PSD variance-proxy condition is no longer a separate hypothesis here:
it follows from `isPSD_matrixVarianceProxy_of_selfAdjoint`.

The intended shape is
`P(||sum_i A_i|| >= t) <= 2 n exp ( -t^2 / (c1*sigma2 + c2*R*t) )`.
Constants are conservative proof targets, not sharp constants.

MC5 keeps this as an operator-norm tail statement. The future analytic route
should pass through the typed spectral, trace-exponential, and Laplace targets
in `Spectral`, `TraceExp`, and `Laplace`; the lambda-max/Rayleigh and
self-adjoint operator-norm endpoint bridges remain unproved. -/
abbrev matrixBernsteinSelfAdjointStatement {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega)
    [IsProbabilityMeasure P]
    (A : I -> RandomMatrix Omega n n) (sigma2 R c1 c2 t : Real) : Prop :=
  0 < n ->
    (forall i, IntegrableRandomMatrix P (A i)) ->
      (forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i))) ->
        CenteredSelfAdjointRandomMatrixFamily P A ->
          IndependentSelfAdjointRandomMatrices P A ->
            PointwiseOperatorNormBound A R ->
              matrixVarianceProxyNorm P A <= sigma2 ->
                0 <= sigma2 ->
                  0 <= R ->
                    0 < c1 ->
                      0 < c2 ->
                        0 <= t ->
                          0 < c1 * sigma2 + c2 * R * t ->
                            upperTailProb P (operatorNorm (randomMatrixSum A)) t <=
                              ENNReal.ofReal
                                (2 * (n : Real) *
                                  Real.exp (-(t ^ 2 / (c1 * sigma2 + c2 * R * t))))

/-- Typed dependency bundle for the future matrix Bernstein Laplace route.

This is not a theorem and does not assert matrix Bernstein. It records the
three bridge targets that remain between the current proof-ready Bernstein
statement and a trace-mgf argument: the self-adjoint operator-norm tail
reduction, the upper quadratic-form matrix Laplace step, and the two-sided
operator-norm Laplace step. -/
abbrev matrixBernsteinLaplacePrerequisitesStatement {Omega : Type*}
    [MeasurableSpace Omega] {n : Nat} (P : Measure Omega)
    (Y : RandomMatrix Omega n n) (theta t : Real) : Prop :=
  selfAdjointOperatorNormTailViaQuadraticFormStatement Y t ∧
    matrixLaplaceTransformLIntegralStatement P Y theta t ∧
      selfAdjointOperatorNormLaplaceLIntegralStatement P Y theta t

/-- Typed target for the future Matrix Bernstein trace-mgf provider.

This statement isolates the hard matrix-mgf comparison for the random sum from
the final Bernstein tail theorem. Proving it is expected to require
Golden-Thompson/Lieb or equivalent noncommutative trace-mgf machinery, plus the
matrix-valued independence and variance-proxy provider steps. -/
abbrev matrixBernsteinTraceMGF_statement {Omega : Type*}
    [MeasurableSpace Omega] {I : Type*} [Fintype I] {n : Nat}
    (P : Measure Omega) (A : I -> RandomMatrix Omega n n)
    (theta : Real) : Prop :=
  TraceMGFVarianceProxyBound P (randomMatrixSum A) (matrixVarianceProxy P A)
    theta

/-- Typed target for the bounded Matrix Bernstein trace-mgf provider.

This is the Bernstein-denominator variant of `matrixBernsteinTraceMGF_statement`.
It preserves the older `theta ^ 2 / 2` target for compatibility while exposing
the coefficient produced by the bounded single-summand MGF route. -/
abbrev matrixBernsteinTraceMGFWithBernsteinCoeff_statement {Omega : Type*}
    [MeasurableSpace Omega] {I : Type*} [Fintype I] {n : Nat}
    (P : Measure Omega) (A : I -> RandomMatrix Omega n n)
    (theta R : Real) : Prop :=
  TraceMGFBernsteinVarianceProxyBound P (randomMatrixSum A)
    (matrixVarianceProxy P A) theta R

/-- Matrix-exponential family `i |-> exp(theta * A_i)`. -/
def matrixExpScaledFamily {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} {n : Nat} (A : I -> RandomMatrix Omega n n)
    (theta : Real) :
    I -> RandomMatrix Omega n n :=
  fun i omega => matrixExp (SMul.smul theta (A i omega))

/-- Pointwise negation of a random-matrix family.

This names the negative-sign family used by two-sided Bernstein wrappers so
public theorem signatures do not expose anonymous lambda expressions. -/
abbrev negRandomMatrixFamily {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} {m n : Nat}
    (A : I -> RandomMatrix Omega m n) :
    I -> RandomMatrix Omega m n :=
  fun i omega => -(A i omega)

@[simp]
theorem negRandomMatrixFamily_apply {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} {m n : Nat}
    (A : I -> RandomMatrix Omega m n) (i : I) (omega : Omega) :
    negRandomMatrixFamily A i omega = -(A i omega) :=
  rfl

@[simp]
theorem matrixExpScaledFamily_apply {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} {n : Nat} (A : I -> RandomMatrix Omega n n)
    (theta : Real) (i : I) (omega : Omega) :
    matrixExpScaledFamily A theta i omega =
      matrixExp (SMul.smul theta (A i omega)) :=
  rfl

/-- Bernstein coefficient times the per-summand matrix second moment. -/
def bernsteinSecondMomentComparisonFamily {Omega : Type*}
    [MeasurableSpace Omega] {I : Type*} {n : Nat}
    (P : Measure Omega) (A : I -> RandomMatrix Omega n n)
    (theta R : Real) :
    I -> Matrix (Fin n) (Fin n) Real :=
  fun i =>
    SMul.smul (bernsteinMGFCoeff theta R)
      (matrixSecondMoment P (A i))

@[simp]
theorem bernsteinSecondMomentComparisonFamily_apply {Omega : Type*}
    [MeasurableSpace Omega] {I : Type*} {n : Nat}
    (P : Measure Omega) (A : I -> RandomMatrix Omega n n)
    (theta R : Real) (i : I) :
    bernsteinSecondMomentComparisonFamily P A theta R i =
      SMul.smul (bernsteinMGFCoeff theta R)
        (matrixSecondMoment P (A i)) :=
  rfl

/-- Thin high-level bounded Matrix Bernstein trace-mgf wrapper from the
finite-family Tropp typed primitive.

This theorem does not prove the finite-family Tropp/Lieb primitive. It
specializes the semantic wrapper to the canonical variance proxy
`matrixVarianceProxy P A`, which is definitionally the RHS used by
`matrixBernsteinTraceMGFWithBernsteinCoeff_statement`. -/
theorem matrixBernsteinTraceMGFWithBernsteinCoeff_of_troppMasterTraceMGFFiniteFamily
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega n n)
    (K : I -> Matrix (Fin n) (Fin n) Real) (theta R : Real)
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P) A K (matrixVarianceProxy P A) theta R)
    (hRand : forall i, IsRandomMatrix P (A i))
    (hSA : forall i, RandomSelfAdjointMatrix P (A i))
    (hIndep : ProbabilityTheory.iIndepFun A P)
    (hExpInt :
      forall i,
        IntegrableRandomMatrix P (matrixExpScaledFamily A theta i))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum A) theta))
    (hKSA : forall i, IsSelfAdjointMatrix (K i))
    (hVSA : IsSelfAdjointMatrix (matrixVarianceProxy P A))
    (hR : 0 <= R)
    (hRange : abs theta * R < 3)
    (hMGF :
      forall i,
        MatrixLE
          (matrixExpect P (matrixExpScaledFamily A theta i))
          (matrixExp (K i)))
    (hNorm :
      Finset.univ.sum (fun i : I => K i) =
        SMul.smul (bernsteinMGFCoeff theta R) (matrixVarianceProxy P A)) :
    matrixBernsteinTraceMGFWithBernsteinCoeff_statement P A theta R := by
  have hExpInt' :
      forall i,
        IntegrableRandomMatrix P
          (fun omega => matrixExp (SMul.smul theta (A i omega))) := by
    simpa [matrixExpScaledFamily] using hExpInt
  have hMGF' :
      forall i,
        MatrixLE
          (matrixExpect P
            (fun omega => matrixExp (SMul.smul theta (A i omega))))
          (matrixExp (K i)) := by
    simpa [matrixExpScaledFamily] using hMGF
  exact
    traceMGFBernsteinVarianceProxyBound_of_troppMasterTraceMGFFiniteFamily
      A K (matrixVarianceProxy P A) theta R hTropp hRand hSA hIndep hExpInt'
      hTraceInt hKSA hVSA hR hRange hMGF' hNorm

/-- Bounded Matrix Bernstein trace-mgf provider under explicit primitive
assumptions.

This theorem packages the ordinary finite-family Matrix Bernstein assumptions
with the two still-typed analytic primitives. It does not prove the
finite-family Tropp/Lieb primitive or the pointwise Bernstein functional
calculus primitive. -/
theorem matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega n n) (theta R : Real)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P A)
    (hIndepSA : IndependentSelfAdjointRandomMatrices P A)
    (hIntX : forall i, IntegrableRandomMatrix P (A i))
    (hIntSq : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i)))
    (hExpInt :
      forall i,
        IntegrableRandomMatrix P (matrixExpScaledFamily A theta i))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum A) theta))
    (hBound : PointwiseOperatorNormBound A R)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3)
    (hCFC :
      forall i omega,
        bernsteinMatrixExp_le_quadratic_statement (A i omega) theta R)
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P) A (bernsteinSecondMomentComparisonFamily P A theta R)
        (matrixVarianceProxy P A) theta R) :
    matrixBernsteinTraceMGFWithBernsteinCoeff_statement P A theta R := by
  have hFam : SelfAdjointRandomMatrixFamily P A := hCentered.1
  have hRand : forall i, IsRandomMatrix P (A i) := hFam.1
  have hSA : forall i, RandomSelfAdjointMatrix P (A i) := hFam.2
  have hMeanZero : forall i, matrixExpect P (A i) = 0 := hCentered.2
  have hIndep : ProbabilityTheory.iIndepFun A P := hIndepSA.2
  have hKSA :
      forall i,
        IsSelfAdjointMatrix
          (bernsteinSecondMomentComparisonFamily P A theta R i) := by
    intro i
    simpa [bernsteinSecondMomentComparisonFamily] using
      isSelfAdjointMatrix_smul (bernsteinMGFCoeff theta R)
        (isSelfAdjointMatrix_matrixSecondMoment (hSA i))
  have hVSA : IsSelfAdjointMatrix (matrixVarianceProxy P A) :=
    isSelfAdjointMatrix_matrixVarianceProxy P hSA
  have hMGF :
      forall i,
        MatrixLE
          (matrixExpect P (matrixExpScaledFamily A theta i))
          (matrixExp
            (SMul.smul (bernsteinMGFCoeff theta R)
              (matrixSecondMoment P (A i)))) := by
    intro i
    simpa [matrixExpScaledFamily] using
      singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic
        (A i) (matrixSecondMoment P (A i)) theta R (hCFC i)
        (hRand i) (hSA i) (hIntX i) (hIntSq i)
        (by simpa [matrixExpScaledFamily] using hExpInt i)
        (hMeanZero i) (hBound i) hR hRange
        (isSelfAdjointMatrix_matrixSecondMoment (hSA i))
        (isPSD_matrixSecondMoment_of_selfAdjoint (hSA i) (hIntSq i))
        (matrixLE_refl (matrixSecondMoment P (A i)))
  have hNorm :
      Finset.univ.sum
          (bernsteinSecondMomentComparisonFamily P A theta R) =
        SMul.smul (bernsteinMGFCoeff theta R) (matrixVarianceProxy P A) := by
    simpa [bernsteinSecondMomentComparisonFamily, matrixVarianceProxy] using
      (Finset.smul_sum (s := Finset.univ)
        (f := fun i : I => matrixSecondMoment P (A i))
        (r := bernsteinMGFCoeff theta R)).symm
  exact
    matrixBernsteinTraceMGFWithBernsteinCoeff_of_troppMasterTraceMGFFiniteFamily
      A (bernsteinSecondMomentComparisonFamily P A theta R)
      theta R hTropp hRand hSA hIndep hExpInt hTraceInt hKSA hVSA hR hRange
      hMGF hNorm

/-- Explicit-theta quadratic-form Matrix Bernstein upper-tail wrapper under
explicit primitive assumptions.

This theorem only connects the bounded trace-MGF provider under primitives to
the existing lintegral Laplace route. The right-hand side remains the
trace-exponential expression; no dimension/norm reduction, theta optimization,
operator-norm tail theorem, Tropp/Lieb proof, or Bernstein CFC proof is
performed here. -/
theorem matrixBernsteinQuadraticFormUpperTailWithBernsteinCoeff_under_primitives
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega (n + 1) (n + 1))
    (theta R t : Real)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P A)
    (hIndepSA : IndependentSelfAdjointRandomMatrices P A)
    (hIntX : forall i, IntegrableRandomMatrix P (A i))
    (hIntSq : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i)))
    (hExpInt :
      forall i,
        IntegrableRandomMatrix P (matrixExpScaledFamily A theta i))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum A) theta))
    (hBound : PointwiseOperatorNormBound A R)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3)
    (hTheta : 0 < theta)
    (hCFC :
      forall i omega,
        bernsteinMatrixExp_le_quadratic_statement (A i omega) theta R)
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P) A (bernsteinSecondMomentComparisonFamily P A theta R)
        (matrixVarianceProxy P A) theta R) :
    P (quadraticFormUpperTailEvent (randomMatrixSum A) t) <=
      ENNReal.ofReal (Real.exp (-(theta * t))) *
        ENNReal.ofReal
          (traceMatrixExp
            (SMul.smul (bernsteinMGFCoeff theta R)
              (matrixVarianceProxy P A))) := by
  have hReal :
      matrixBernsteinTraceMGFWithBernsteinCoeff_statement P A theta R :=
    matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives
      A theta R hCentered hIndepSA hIntX hIntSq hExpInt hTraceInt hBound
      hR hRange hCFC hTropp
  have hY : RandomSelfAdjointMatrix P (randomMatrixSum A) :=
    randomSelfAdjointMatrix_sum hCentered.1.2
  have hLInt :
      TraceMGFBernsteinVarianceProxyBoundLIntegral P (randomMatrixSum A)
        (matrixVarianceProxy P A) theta R :=
    traceMGFBernsteinVarianceProxyBoundLIntegral_of_traceMGFBernsteinVarianceProxyBound
      (randomMatrixSum A) (matrixVarianceProxy P A) theta R hY hTraceInt hReal
  have hMeas :
      AEMeasurable
        (fun omega =>
          ENNReal.ofReal
            (traceExpIntegrand (randomMatrixSum A) theta omega)) P :=
    hTraceInt.aemeasurable.ennreal_ofReal
  have hSubset :
      quadraticFormUpperTailEvent (randomMatrixSum A) t ⊆
        traceExpThresholdEvent (randomMatrixSum A) theta t :=
    quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates
      (randomMatrixSum A) theta t
      (traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint
        (randomMatrixSum A) theta t hY hTheta.le)
  exact
    quadraticFormUpperTail_laplace_bound_of_traceMGFBernsteinVarianceProxyBoundLIntegral
      (randomMatrixSum A) (matrixVarianceProxy P A) theta t R hMeas hSubset hLInt

/-- Variance-proxy specialization of the deterministic trace-exponential
dimension bound with the bounded Matrix Bernstein coefficient.

This only reduces the trace-exponential RHS to a scalar dimension/norm RHS. It
does not apply the tail theorem, multiply by `exp (-theta * t)`, or optimize
theta. -/
theorem traceMatrixExp_bernsteinMGFCoeff_matrixVarianceProxy_le_card_exp
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega (n + 1) (n + 1))
    (theta R sigmaSq : Real)
    (hSA : forall i, RandomSelfAdjointMatrix P (A i))
    (hRange : abs theta * R < 3)
    (hNorm : MatrixVarianceProxyNormBound P A sigmaSq) :
    traceMatrixExp
      (bernsteinMGFCoeff theta R • matrixVarianceProxy P A) <=
      (n + 1 : Real) * Real.exp (bernsteinMGFCoeff theta R * sigmaSq) := by
  let hV : IsSelfAdjointMatrix (matrixVarianceProxy P A) :=
    isSelfAdjointMatrix_matrixVarianceProxy P hSA
  have hNorm' :
      deterministicOperatorNorm (matrixVarianceProxy P A) <= sigmaSq := by
    simpa [MatrixVarianceProxyNormBound, matrixVarianceProxyNorm,
      deterministicMatrixVarianceProxyNorm] using hNorm
  have hSpec :
      lambdaMaxOrdered (matrixVarianceProxy P A) hV <= sigmaSq :=
    (lambdaMaxOrdered_le_deterministicOperatorNorm hV).trans hNorm'
  exact
    traceMatrixExp_smul_le_card_exp_of_lambdaMaxOrdered_le
      (bernsteinMGFCoeff theta R) sigmaSq
      (bernsteinMGFCoeff_nonneg hRange) hV hSpec

/-- Explicit-theta quadratic-form Matrix Bernstein upper-tail wrapper under
explicit primitive assumptions, with the trace-exponential RHS reduced to the
scalar dimension/norm form.

The right-hand side is intentionally left as the unnormalized product
`exp (-(theta * t)) * ((n + 1) * exp (bernsteinMGFCoeff theta R * sigmaSq))`.
No exponent-add normalization, theta optimization, operator-norm tail theorem,
Tropp/Lieb proof, or Bernstein CFC proof is performed here. -/
theorem matrixBernsteinQuadraticFormUpperTailScalarRHSWithBernsteinCoeff_under_primitives
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega (n + 1) (n + 1))
    (theta R t sigmaSq : Real)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P A)
    (hIndepSA : IndependentSelfAdjointRandomMatrices P A)
    (hIntX : forall i, IntegrableRandomMatrix P (A i))
    (hIntSq : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i)))
    (hExpInt :
      forall i,
        IntegrableRandomMatrix P (matrixExpScaledFamily A theta i))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum A) theta))
    (hBound : PointwiseOperatorNormBound A R)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3)
    (hTheta : 0 < theta)
    (hNorm : MatrixVarianceProxyNormBound P A sigmaSq)
    (hCFC :
      forall i omega,
        bernsteinMatrixExp_le_quadratic_statement (A i omega) theta R)
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P) A (bernsteinSecondMomentComparisonFamily P A theta R)
        (matrixVarianceProxy P A) theta R) :
    P (quadraticFormUpperTailEvent (randomMatrixSum A) t) <=
      ENNReal.ofReal
        (Real.exp (-(theta * t)) *
          ((n + 1 : Real) *
            Real.exp (bernsteinMGFCoeff theta R * sigmaSq))) := by
  have hTail :=
    matrixBernsteinQuadraticFormUpperTailWithBernsteinCoeff_under_primitives
      A theta R t hCentered hIndepSA hIntX hIntSq hExpInt hTraceInt hBound
      hR hRange hTheta hCFC hTropp
  have hDim :
      traceMatrixExp
        (SMul.smul (bernsteinMGFCoeff theta R) (matrixVarianceProxy P A)) <=
        (n + 1 : Real) *
          Real.exp (bernsteinMGFCoeff theta R * sigmaSq) :=
    traceMatrixExp_bernsteinMGFCoeff_matrixVarianceProxy_le_card_exp
      A theta R sigmaSq hCentered.1.2 hRange hNorm
  have hDimENN :
      ENNReal.ofReal
        (traceMatrixExp
          (SMul.smul (bernsteinMGFCoeff theta R)
            (matrixVarianceProxy P A))) <=
        ENNReal.ofReal
          ((n + 1 : Real) *
            Real.exp (bernsteinMGFCoeff theta R * sigmaSq)) :=
    ENNReal.ofReal_le_ofReal hDim
  calc
    P (quadraticFormUpperTailEvent (randomMatrixSum A) t)
        <= ENNReal.ofReal (Real.exp (-(theta * t))) *
          ENNReal.ofReal
            (traceMatrixExp
              (SMul.smul (bernsteinMGFCoeff theta R)
                (matrixVarianceProxy P A))) := hTail
    _ <= ENNReal.ofReal (Real.exp (-(theta * t))) *
          ENNReal.ofReal
            ((n + 1 : Real) *
              Real.exp (bernsteinMGFCoeff theta R * sigmaSq)) := by
        simpa [mul_comm, mul_left_comm, mul_assoc] using
          mul_le_mul_right hDimENN (ENNReal.ofReal (Real.exp (-(theta * t))))
    _ = ENNReal.ofReal
          (Real.exp (-(theta * t)) *
            ((n + 1 : Real) *
              Real.exp (bernsteinMGFCoeff theta R * sigmaSq))) :=
        (ENNReal.ofReal_mul (le_of_lt (Real.exp_pos (-(theta * t))))).symm

/-- Explicit-theta quadratic-form Matrix Bernstein upper-tail wrapper under
explicit primitive assumptions, with the scalar RHS normalized into compact
exponential-add form.

This is only a normalization wrapper around
`matrixBernsteinQuadraticFormUpperTailScalarRHSWithBernsteinCoeff_under_primitives`.
It does not optimize theta, prove an operator-norm tail theorem, or prove the
Tropp/Lieb or Bernstein functional-calculus primitives. -/
theorem matrixBernsteinQuadraticFormUpperTailScalarExpRHSWithBernsteinCoeff_under_primitives
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega (n + 1) (n + 1))
    (theta R t sigmaSq : Real)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P A)
    (hIndepSA : IndependentSelfAdjointRandomMatrices P A)
    (hIntX : forall i, IntegrableRandomMatrix P (A i))
    (hIntSq : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i)))
    (hExpInt :
      forall i,
        IntegrableRandomMatrix P (matrixExpScaledFamily A theta i))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum A) theta))
    (hBound : PointwiseOperatorNormBound A R)
    (hR : 0 <= R)
    (hRange : abs theta * R < 3)
    (hTheta : 0 < theta)
    (hNorm : MatrixVarianceProxyNormBound P A sigmaSq)
    (hCFC :
      forall i omega,
        bernsteinMatrixExp_le_quadratic_statement (A i omega) theta R)
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P) A (bernsteinSecondMomentComparisonFamily P A theta R)
        (matrixVarianceProxy P A) theta R) :
    P (quadraticFormUpperTailEvent (randomMatrixSum A) t) <=
      ENNReal.ofReal
        ((n + 1 : Real) *
          Real.exp (-(theta * t) + bernsteinMGFCoeff theta R * sigmaSq)) := by
  have hUnnormalized :=
    matrixBernsteinQuadraticFormUpperTailScalarRHSWithBernsteinCoeff_under_primitives
      A theta R t sigmaSq hCentered hIndepSA hIntX hIntSq hExpInt hTraceInt
      hBound hR hRange hTheta hNorm hCFC hTropp
  convert hUnnormalized using 1
  rw [Real.exp_add]
  ring_nf

/-- Theta-optimized quadratic-form Matrix Bernstein upper-tail wrapper under
explicit primitive assumptions.

This packages the explicit-theta scalar RHS using the conservative Bernstein
choice `theta = t / (sigmaSq + R * t / 3)`, yielding the usual denominator
exponent `-t^2 / (2*sigmaSq + (2/3)*R*t)`. It remains a one-sided
quadratic-form theorem under explicit Tropp/Lieb and Bernstein CFC primitives;
it is not an operator-norm Matrix Bernstein theorem. -/
theorem matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega (n + 1) (n + 1))
    (R t sigmaSq : Real)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P A)
    (hIndepSA : IndependentSelfAdjointRandomMatrices P A)
    (hIntX : forall i, IntegrableRandomMatrix P (A i))
    (hIntSq : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i)))
    (hExpInt :
      forall i,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily A (bernsteinThetaChoice t sigmaSq R) i))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum A)
          (bernsteinThetaChoice t sigmaSq R)))
    (hBound : PointwiseOperatorNormBound A R)
    (hSigma : 0 < sigmaSq)
    (hR : 0 <= R)
    (ht : 0 < t)
    (hNorm : MatrixVarianceProxyNormBound P A sigmaSq)
    (hCFC :
      forall i omega,
        bernsteinMatrixExp_le_quadratic_statement (A i omega)
          (bernsteinThetaChoice t sigmaSq R) R)
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P) A
        (bernsteinSecondMomentComparisonFamily P A
          (bernsteinThetaChoice t sigmaSq R) R)
        (matrixVarianceProxy P A) (bernsteinThetaChoice t sigmaSq R) R) :
    P (quadraticFormUpperTailEvent (randomMatrixSum A) t) <=
      ENNReal.ofReal
        ((n + 1 : Real) *
          Real.exp (-(t ^ 2 / (2 * sigmaSq + (2 / 3) * R * t)))) := by
  let theta := bernsteinThetaChoice t sigmaSq R
  have hden : 0 < sigmaSq + R * t / 3 :=
    bernsteinThetaChoice_den_pos hSigma hR ht.le
  have hTheta : 0 < theta := by
    simpa [theta] using bernsteinThetaChoice_pos ht hden
  have hRange : abs theta * R < 3 := by
    simpa [theta] using bernsteinThetaChoice_range hSigma hR ht.le
  have hExpIntTheta :
      forall i,
        IntegrableRandomMatrix P (matrixExpScaledFamily A theta i) := by
    simpa [theta] using hExpInt
  have hTraceIntTheta :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum A) theta) := by
    exact hTraceInt
  have hCFCTheta :
      forall i omega,
        bernsteinMatrixExp_le_quadratic_statement (A i omega) theta R := by
    exact hCFC
  have hTroppTheta :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P) A (bernsteinSecondMomentComparisonFamily P A theta R)
        (matrixVarianceProxy P A) theta R := by
    simpa [theta] using hTropp
  have hTail :=
    matrixBernsteinQuadraticFormUpperTailScalarExpRHSWithBernsteinCoeff_under_primitives
      A theta R t sigmaSq hCentered hIndepSA hIntX hIntSq hExpIntTheta
      hTraceIntTheta hBound hR hRange hTheta hNorm hCFCTheta hTroppTheta
  simpa [theta, bernsteinThetaChoice_exponent_eq hSigma hR ht.le] using hTail

/-- Two-sided quadratic-form Matrix Bernstein wrapper under explicit primitive
assumptions for both `A` and the pointwise negated summand family.

This combines the existing optimized upper-tail theorem for `A` with the same
theorem applied to `negRandomMatrixFamily A`, then uses the finite union
bound for the existing `twoSidedQuadraticFormTailEvent`. It does not prove any
negation transfer for independence, variance proxies, CFC primitives, Tropp
primitives, or integrability. -/
theorem matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega (n + 1) (n + 1))
    (R Rneg t sigmaSq sigmaSqNeg : Real)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P A)
    (hIndepSA : IndependentSelfAdjointRandomMatrices P A)
    (hIntX : forall i, IntegrableRandomMatrix P (A i))
    (hIntSq : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i)))
    (hExpInt :
      forall i,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily A (bernsteinThetaChoice t sigmaSq R) i))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum A)
          (bernsteinThetaChoice t sigmaSq R)))
    (hBound : PointwiseOperatorNormBound A R)
    (hSigma : 0 < sigmaSq)
    (hR : 0 <= R)
    (ht : 0 < t)
    (hNorm : MatrixVarianceProxyNormBound P A sigmaSq)
    (hCFC :
      forall i omega,
        bernsteinMatrixExp_le_quadratic_statement (A i omega)
          (bernsteinThetaChoice t sigmaSq R) R)
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P) A
        (bernsteinSecondMomentComparisonFamily P A
          (bernsteinThetaChoice t sigmaSq R) R)
        (matrixVarianceProxy P A) (bernsteinThetaChoice t sigmaSq R) R)
    (hCenteredNeg :
      CenteredSelfAdjointRandomMatrixFamily P
        (negRandomMatrixFamily A))
    (hIndepSANeg :
      IndependentSelfAdjointRandomMatrices P
        (negRandomMatrixFamily A))
    (hIntXNeg :
      forall i,
        IntegrableRandomMatrix P
          ((negRandomMatrixFamily A) i))
    (hIntSqNeg :
      forall i,
        IntegrableRandomMatrix P
          (randomMatrixSquare
            ((negRandomMatrixFamily A) i)))
    (hExpIntNeg :
      forall i,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily
            (negRandomMatrixFamily A)
            (bernsteinThetaChoice t sigmaSqNeg Rneg) i))
    (hTraceIntNeg :
      IntegrableRealRandomVariable P
        (traceExpIntegrand
          (randomMatrixSum
            (negRandomMatrixFamily A))
          (bernsteinThetaChoice t sigmaSqNeg Rneg)))
    (hBoundNeg :
      PointwiseOperatorNormBound
        (negRandomMatrixFamily A) Rneg)
    (hSigmaNeg : 0 < sigmaSqNeg)
    (hRNeg : 0 <= Rneg)
    (hNormNeg :
      MatrixVarianceProxyNormBound P
        (negRandomMatrixFamily A) sigmaSqNeg)
    (hCFCNeg :
      forall i omega,
        bernsteinMatrixExp_le_quadratic_statement
          ((negRandomMatrixFamily A) i omega)
          (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg)
    (hTroppNeg :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P) (negRandomMatrixFamily A)
        (bernsteinSecondMomentComparisonFamily P
          (negRandomMatrixFamily A)
          (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg)
        (matrixVarianceProxy P
          (negRandomMatrixFamily A))
        (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg) :
    P (twoSidedQuadraticFormTailEvent (randomMatrixSum A) t) <=
      ENNReal.ofReal
        ((n + 1 : Real) *
          Real.exp (-(t ^ 2 / (2 * sigmaSq + (2 / 3) * R * t)))) +
        ENNReal.ofReal
          ((n + 1 : Real) *
            Real.exp (-(t ^ 2 / (2 * sigmaSqNeg + (2 / 3) * Rneg * t)))) := by
  let Aneg : I -> RandomMatrix Omega (n + 1) (n + 1) :=
    negRandomMatrixFamily A
  have hUpper :
      P (quadraticFormUpperTailEvent (randomMatrixSum A) t) <=
        ENNReal.ofReal
          ((n + 1 : Real) *
            Real.exp (-(t ^ 2 / (2 * sigmaSq + (2 / 3) * R * t)))) :=
    matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
      (P := P) (A := A) (R := R) (t := t) (sigmaSq := sigmaSq)
      hCentered hIndepSA hIntX hIntSq hExpInt hTraceInt hBound
      hSigma hR ht hNorm hCFC hTropp
  have hUpperNeg :
      P (quadraticFormUpperTailEvent (randomMatrixSum Aneg) t) <=
        ENNReal.ofReal
          ((n + 1 : Real) *
            Real.exp (-(t ^ 2 / (2 * sigmaSqNeg + (2 / 3) * Rneg * t)))) :=
    matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
      (P := P) (A := Aneg) (R := Rneg) (t := t) (sigmaSq := sigmaSqNeg)
      (by
        change CenteredSelfAdjointRandomMatrixFamily P
          (negRandomMatrixFamily A)
        exact hCenteredNeg)
      (by
        change IndependentSelfAdjointRandomMatrices P
          (negRandomMatrixFamily A)
        exact hIndepSANeg)
      (by
        change forall i,
          IntegrableRandomMatrix P
            ((negRandomMatrixFamily A) i)
        exact hIntXNeg)
      (by
        change forall i,
          IntegrableRandomMatrix P
            (randomMatrixSquare
              ((negRandomMatrixFamily A) i))
        exact hIntSqNeg)
      (by
        change forall i,
          IntegrableRandomMatrix P
            (matrixExpScaledFamily
              (negRandomMatrixFamily A)
              (bernsteinThetaChoice t sigmaSqNeg Rneg) i)
        exact hExpIntNeg)
      (by
        change IntegrableRealRandomVariable P
          (traceExpIntegrand
            (randomMatrixSum
              (negRandomMatrixFamily A))
            (bernsteinThetaChoice t sigmaSqNeg Rneg))
        exact hTraceIntNeg)
      (by
        change PointwiseOperatorNormBound
          (negRandomMatrixFamily A) Rneg
        exact hBoundNeg)
      hSigmaNeg hRNeg ht
      (by
        change MatrixVarianceProxyNormBound P
          (negRandomMatrixFamily A) sigmaSqNeg
        exact hNormNeg)
      (by
        change forall i omega,
          bernsteinMatrixExp_le_quadratic_statement
            ((negRandomMatrixFamily A) i omega)
            (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg
        exact hCFCNeg)
      (by
        change troppMasterTraceMGFFiniteFamily_statement
          (P := P) (negRandomMatrixFamily A)
          (bernsteinSecondMomentComparisonFamily P
            (negRandomMatrixFamily A)
            (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg)
          (matrixVarianceProxy P
            (negRandomMatrixFamily A))
          (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg
        exact hTroppNeg)
  have hNegSum :
      randomMatrixSum Aneg =
        fun omega : Omega => -(randomMatrixSum A omega) := by
    funext omega
    ext r c
    dsimp [randomMatrixSum, Aneg]
    rw [Matrix.sum_apply]
    change (Finset.univ.sum fun i : I => (-(A i omega)) r c) =
      -((Finset.univ.sum fun i : I => A i omega) r c)
    rw [Matrix.sum_apply]
    change (Finset.univ.sum fun i : I => -(A i omega r c)) =
      -(Finset.univ.sum fun i : I => A i omega r c)
    exact
      Finset.sum_neg_distrib (s := (Finset.univ : Finset I))
        (f := fun i : I => A i omega r c)
  have hLowerSubset :
      quadraticFormLowerTailEvent (randomMatrixSum A) (-t) ⊆
        quadraticFormUpperTailEvent (randomMatrixSum Aneg) t := by
    simpa [hNegSum] using
      quadraticFormLowerTailEvent_subset_quadraticFormUpperTailEvent_neg
        (randomMatrixSum A) t
  have hLower :
      P (quadraticFormLowerTailEvent (randomMatrixSum A) (-t)) <=
        ENNReal.ofReal
          ((n + 1 : Real) *
            Real.exp (-(t ^ 2 / (2 * sigmaSqNeg + (2 / 3) * Rneg * t)))) :=
    (measure_mono hLowerSubset).trans hUpperNeg
  calc
    P (twoSidedQuadraticFormTailEvent (randomMatrixSum A) t)
        <= P (quadraticFormUpperTailEvent (randomMatrixSum A) t) +
          P (quadraticFormLowerTailEvent (randomMatrixSum A) (-t)) := by
            simpa [twoSidedQuadraticFormTailEvent] using
              (measure_union_le
                (quadraticFormUpperTailEvent (randomMatrixSum A) t)
                (quadraticFormLowerTailEvent (randomMatrixSum A) (-t)) :
                  P (quadraticFormUpperTailEvent (randomMatrixSum A) t ∪
                    quadraticFormLowerTailEvent (randomMatrixSum A) (-t)) <=
                    P (quadraticFormUpperTailEvent (randomMatrixSum A) t) +
                      P (quadraticFormLowerTailEvent (randomMatrixSum A) (-t)))
    _ <= ENNReal.ofReal
          ((n + 1 : Real) *
            Real.exp (-(t ^ 2 / (2 * sigmaSq + (2 / 3) * R * t)))) +
        ENNReal.ofReal
          ((n + 1 : Real) *
            Real.exp (-(t ^ 2 / (2 * sigmaSqNeg + (2 / 3) * Rneg * t)))) := by
            exact add_le_add hUpper hLower

/-- Self-adjoint operator-norm Matrix Bernstein wrapper under the explicit
operator-norm-to-two-sided-quadratic-form bridge.

This is the smallest honest operator-norm tail wrapper currently available:
it reuses the proved two-sided quadratic-form wrapper and assumes the existing
typed bridge `selfAdjointOperatorNormTailViaQuadraticFormStatement` for the
random sum. All analytic primitives and sign-specific assumptions remain
explicit exactly as in the two-sided quadratic-form theorem. -/
theorem matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega (n + 1) (n + 1))
    (R Rneg t sigmaSq sigmaSqNeg : Real)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P A)
    (hIndepSA : IndependentSelfAdjointRandomMatrices P A)
    (hIntX : forall i, IntegrableRandomMatrix P (A i))
    (hIntSq : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i)))
    (hExpInt :
      forall i,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily A (bernsteinThetaChoice t sigmaSq R) i))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum A)
          (bernsteinThetaChoice t sigmaSq R)))
    (hBound : PointwiseOperatorNormBound A R)
    (hSigma : 0 < sigmaSq)
    (hR : 0 <= R)
    (ht : 0 < t)
    (hOperatorBridge :
      selfAdjointOperatorNormTailViaQuadraticFormStatement
        (randomMatrixSum A) t)
    (hNorm : MatrixVarianceProxyNormBound P A sigmaSq)
    (hCFC :
      forall i omega,
        bernsteinMatrixExp_le_quadratic_statement (A i omega)
          (bernsteinThetaChoice t sigmaSq R) R)
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P) A
        (bernsteinSecondMomentComparisonFamily P A
          (bernsteinThetaChoice t sigmaSq R) R)
        (matrixVarianceProxy P A) (bernsteinThetaChoice t sigmaSq R) R)
    (hCenteredNeg :
      CenteredSelfAdjointRandomMatrixFamily P
        (negRandomMatrixFamily A))
    (hIndepSANeg :
      IndependentSelfAdjointRandomMatrices P
        (negRandomMatrixFamily A))
    (hIntXNeg :
      forall i,
        IntegrableRandomMatrix P
          ((negRandomMatrixFamily A) i))
    (hIntSqNeg :
      forall i,
        IntegrableRandomMatrix P
          (randomMatrixSquare
            ((negRandomMatrixFamily A) i)))
    (hExpIntNeg :
      forall i,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily
            (negRandomMatrixFamily A)
            (bernsteinThetaChoice t sigmaSqNeg Rneg) i))
    (hTraceIntNeg :
      IntegrableRealRandomVariable P
        (traceExpIntegrand
          (randomMatrixSum
            (negRandomMatrixFamily A))
          (bernsteinThetaChoice t sigmaSqNeg Rneg)))
    (hBoundNeg :
      PointwiseOperatorNormBound
        (negRandomMatrixFamily A) Rneg)
    (hSigmaNeg : 0 < sigmaSqNeg)
    (hRNeg : 0 <= Rneg)
    (hNormNeg :
      MatrixVarianceProxyNormBound P
        (negRandomMatrixFamily A) sigmaSqNeg)
    (hCFCNeg :
      forall i omega,
        bernsteinMatrixExp_le_quadratic_statement
          ((negRandomMatrixFamily A) i omega)
          (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg)
    (hTroppNeg :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P) (negRandomMatrixFamily A)
        (bernsteinSecondMomentComparisonFamily P
          (negRandomMatrixFamily A)
          (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg)
        (matrixVarianceProxy P
          (negRandomMatrixFamily A))
        (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg) :
    P (SelfAdjointOperatorNormTailEvent (randomMatrixSum A) t) <=
      ENNReal.ofReal
        ((n + 1 : Real) *
          Real.exp (-(t ^ 2 / (2 * sigmaSq + (2 / 3) * R * t)))) +
        ENNReal.ofReal
          ((n + 1 : Real) *
            Real.exp (-(t ^ 2 / (2 * sigmaSqNeg + (2 / 3) * Rneg * t)))) := by
  have hSumSelfAdj :
      RandomSelfAdjointMatrix P (randomMatrixSum A) :=
    randomSelfAdjointMatrix_sum (P := P) (A := A) hCentered.1.2
  have hSubset :
      SelfAdjointOperatorNormTailEvent (randomMatrixSum A) t <=
        twoSidedQuadraticFormTailEvent (randomMatrixSum A) t :=
    hOperatorBridge hSumSelfAdj ht.le
  exact (measure_mono hSubset).trans
    (matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
      (P := P) (A := A) (R := R) (Rneg := Rneg) (t := t)
      (sigmaSq := sigmaSq) (sigmaSqNeg := sigmaSqNeg)
      hCentered hIndepSA hIntX hIntSq hExpInt hTraceInt hBound
      hSigma hR ht hNorm hCFC hTropp hCenteredNeg hIndepSANeg
      hIntXNeg hIntSqNeg hExpIntNeg hTraceIntNeg hBoundNeg hSigmaNeg
      hRNeg hNormNeg hCFCNeg hTroppNeg)

/-- Self-adjoint operator-norm Matrix Bernstein wrapper in nonempty square
dimensions under explicit primitive assumptions.

This specializes the conditional operator-norm wrapper to matrices indexed by
`Fin (n + 1)`, where the S3 bridge
`selfAdjointOperatorNormTailViaQuadraticFormStatement_nonempty` discharges the
operator-norm-to-two-sided-quadratic-form event reduction. Variance proxies,
integrability, independence, CFC, and Tropp primitives remain explicit for both
signs. -/
theorem matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_nonempty_under_primitives
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega (n + 1) (n + 1))
    (R Rneg t sigmaSq sigmaSqNeg : Real)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P A)
    (hIndepSA : IndependentSelfAdjointRandomMatrices P A)
    (hIntX : forall i, IntegrableRandomMatrix P (A i))
    (hIntSq : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i)))
    (hExpInt :
      forall i,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily A (bernsteinThetaChoice t sigmaSq R) i))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum A)
          (bernsteinThetaChoice t sigmaSq R)))
    (hBound : PointwiseOperatorNormBound A R)
    (hSigma : 0 < sigmaSq)
    (hR : 0 <= R)
    (ht : 0 < t)
    (hNorm : MatrixVarianceProxyNormBound P A sigmaSq)
    (hCFC :
      forall i omega,
        bernsteinMatrixExp_le_quadratic_statement (A i omega)
          (bernsteinThetaChoice t sigmaSq R) R)
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P) A
        (bernsteinSecondMomentComparisonFamily P A
          (bernsteinThetaChoice t sigmaSq R) R)
        (matrixVarianceProxy P A) (bernsteinThetaChoice t sigmaSq R) R)
    (hCenteredNeg :
      CenteredSelfAdjointRandomMatrixFamily P
        (negRandomMatrixFamily A))
    (hIndepSANeg :
      IndependentSelfAdjointRandomMatrices P
        (negRandomMatrixFamily A))
    (hIntXNeg :
      forall i,
        IntegrableRandomMatrix P
          ((negRandomMatrixFamily A) i))
    (hIntSqNeg :
      forall i,
        IntegrableRandomMatrix P
          (randomMatrixSquare
            ((negRandomMatrixFamily A) i)))
    (hExpIntNeg :
      forall i,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily
            (negRandomMatrixFamily A)
            (bernsteinThetaChoice t sigmaSqNeg Rneg) i))
    (hTraceIntNeg :
      IntegrableRealRandomVariable P
        (traceExpIntegrand
          (randomMatrixSum
            (negRandomMatrixFamily A))
          (bernsteinThetaChoice t sigmaSqNeg Rneg)))
    (hBoundNeg :
      PointwiseOperatorNormBound
        (negRandomMatrixFamily A) Rneg)
    (hSigmaNeg : 0 < sigmaSqNeg)
    (hRNeg : 0 <= Rneg)
    (hNormNeg :
      MatrixVarianceProxyNormBound P
        (negRandomMatrixFamily A) sigmaSqNeg)
    (hCFCNeg :
      forall i omega,
        bernsteinMatrixExp_le_quadratic_statement
          ((negRandomMatrixFamily A) i omega)
          (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg)
    (hTroppNeg :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P) (negRandomMatrixFamily A)
        (bernsteinSecondMomentComparisonFamily P
          (negRandomMatrixFamily A)
          (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg)
        (matrixVarianceProxy P
          (negRandomMatrixFamily A))
        (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg) :
    P (SelfAdjointOperatorNormTailEvent (randomMatrixSum A) t) <=
      ENNReal.ofReal
        ((n + 1 : Real) *
          Real.exp (-(t ^ 2 / (2 * sigmaSq + (2 / 3) * R * t)))) +
        ENNReal.ofReal
          ((n + 1 : Real) *
            Real.exp (-(t ^ 2 / (2 * sigmaSqNeg + (2 / 3) * Rneg * t)))) := by
  exact
    matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
      (P := P) (A := A) (R := R) (Rneg := Rneg) (t := t)
      (sigmaSq := sigmaSq) (sigmaSqNeg := sigmaSqNeg)
      hCentered hIndepSA hIntX hIntSq hExpInt hTraceInt hBound
      hSigma hR ht
      (selfAdjointOperatorNormTailViaQuadraticFormStatement_nonempty
        (randomMatrixSum A) t)
      hNorm hCFC hTropp hCenteredNeg hIndepSANeg hIntXNeg hIntSqNeg
      hExpIntNeg hTraceIntNeg hBoundNeg hSigmaNeg hRNeg hNormNeg
      hCFCNeg hTroppNeg

/-- Arbitrary-dimensional positive-threshold self-adjoint operator-norm Matrix
Bernstein wrapper under explicit primitive assumptions.

The `n = 0` branch is discharged by the zero-dimensional positive-threshold
operator-norm tail emptiness lemma. In successor dimensions, the theorem reuses
the conditional operator-norm wrapper and supplies the corrected positive-
threshold spectral bridge. Variance proxies, integrability, independence, CFC,
and Tropp primitives remain explicit for both signs. -/
theorem matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_pos_under_primitives
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega n n)
    (R Rneg t sigmaSq sigmaSqNeg : Real)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P A)
    (hIndepSA : IndependentSelfAdjointRandomMatrices P A)
    (hIntX : forall i, IntegrableRandomMatrix P (A i))
    (hIntSq : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i)))
    (hExpInt :
      forall i,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily A (bernsteinThetaChoice t sigmaSq R) i))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum A)
          (bernsteinThetaChoice t sigmaSq R)))
    (hBound : PointwiseOperatorNormBound A R)
    (hSigma : 0 < sigmaSq)
    (hR : 0 <= R)
    (ht : 0 < t)
    (hNorm : MatrixVarianceProxyNormBound P A sigmaSq)
    (hCFC :
      forall i omega,
        bernsteinMatrixExp_le_quadratic_statement (A i omega)
          (bernsteinThetaChoice t sigmaSq R) R)
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P) A
        (bernsteinSecondMomentComparisonFamily P A
          (bernsteinThetaChoice t sigmaSq R) R)
        (matrixVarianceProxy P A) (bernsteinThetaChoice t sigmaSq R) R)
    (hCenteredNeg :
      CenteredSelfAdjointRandomMatrixFamily P
        (negRandomMatrixFamily A))
    (hIndepSANeg :
      IndependentSelfAdjointRandomMatrices P
        (negRandomMatrixFamily A))
    (hIntXNeg :
      forall i,
        IntegrableRandomMatrix P
          ((negRandomMatrixFamily A) i))
    (hIntSqNeg :
      forall i,
        IntegrableRandomMatrix P
          (randomMatrixSquare
            ((negRandomMatrixFamily A) i)))
    (hExpIntNeg :
      forall i,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily
            (negRandomMatrixFamily A)
            (bernsteinThetaChoice t sigmaSqNeg Rneg) i))
    (hTraceIntNeg :
      IntegrableRealRandomVariable P
        (traceExpIntegrand
          (randomMatrixSum
            (negRandomMatrixFamily A))
          (bernsteinThetaChoice t sigmaSqNeg Rneg)))
    (hBoundNeg :
      PointwiseOperatorNormBound
        (negRandomMatrixFamily A) Rneg)
    (hSigmaNeg : 0 < sigmaSqNeg)
    (hRNeg : 0 <= Rneg)
    (hNormNeg :
      MatrixVarianceProxyNormBound P
        (negRandomMatrixFamily A) sigmaSqNeg)
    (hCFCNeg :
      forall i omega,
        bernsteinMatrixExp_le_quadratic_statement
          ((negRandomMatrixFamily A) i omega)
          (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg)
    (hTroppNeg :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P) (negRandomMatrixFamily A)
        (bernsteinSecondMomentComparisonFamily P
          (negRandomMatrixFamily A)
          (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg)
        (matrixVarianceProxy P
          (negRandomMatrixFamily A))
        (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg) :
    P (SelfAdjointOperatorNormTailEvent (randomMatrixSum A) t) <=
      ENNReal.ofReal
        ((n : Real) *
          Real.exp (-(t ^ 2 / (2 * sigmaSq + (2 / 3) * R * t)))) +
        ENNReal.ofReal
          ((n : Real) *
            Real.exp (-(t ^ 2 / (2 * sigmaSqNeg + (2 / 3) * Rneg * t)))) := by
  cases n with
  | zero =>
      have hEmpty :
          SelfAdjointOperatorNormTailEvent (randomMatrixSum A) t = ∅ :=
        selfAdjointOperatorNormTailEvent_empty_of_zero_dim_of_pos
          (randomMatrixSum A) ht
      rw [hEmpty, measure_empty]
      exact zero_le _
  | succ n =>
      simpa using
        (matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
          (P := P) (A := A) (R := R) (Rneg := Rneg) (t := t)
          (sigmaSq := sigmaSq) (sigmaSqNeg := sigmaSqNeg)
          hCentered hIndepSA hIntX hIntSq hExpInt hTraceInt hBound
          hSigma hR ht
          (selfAdjointOperatorNormTailViaQuadraticFormStatement_of_pos
            (randomMatrixSum A) ht)
          hNorm hCFC hTropp hCenteredNeg hIndepSANeg hIntXNeg hIntSqNeg
          hExpIntNeg hTraceIntNeg hBoundNeg hSigmaNeg hRNeg hNormNeg
          hCFCNeg hTroppNeg)

/-- Sample-covariance operator-norm event bridge to the unnormalized centered
row rank-one sum.

This is the operator-norm analogue of the normalization bridge used by the
quadratic-form sample-covariance wrapper. It transports the public centered
sample-covariance deviation event to the centered row rank-one sum at threshold
`(m : Real) * t`. The row rank-one integrability hypothesis is exactly the one
needed by `sampleCovariance_deviation_eq_normalized_centered_rowRankOne_sum`.
-/
theorem sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {m n : Nat}
    (A : RandomMatrix Omega m n) (t : Real)
    (hm : 0 < m)
    (hInt :
      forall k : Fin m,
        IntegrableRandomMatrix P (rankOneRandomMatrix (rowVector A k))) :
    SelfAdjointOperatorNormTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t ⊆
      SelfAdjointOperatorNormTailEvent
        (centeredSampleCovarianceRowRankOneSum (P := P) A)
        ((m : Real) * t) := by
  intro omega hTail
  change t <= operatorNorm (centeredRandomMatrix P (sampleCovariance A)) omega at hTail
  have hmReal : 0 < (m : Real) := by
    exact_mod_cast hm
  have hDevEq :=
    congrFun
      (sampleCovariance_deviation_eq_normalized_centered_rowRankOne_sum
        (P := P) A hInt) omega
  have hNorm :
      operatorNorm (centeredRandomMatrix P (sampleCovariance A)) omega =
        (1 / (m : Real)) *
          operatorNorm (centeredSampleCovarianceRowRankOneSum (P := P) A)
            omega := by
    calc
      operatorNorm (centeredRandomMatrix P (sampleCovariance A)) omega =
          norm (centeredRandomMatrix P (sampleCovariance A) omega) := rfl
      _ =
          norm ((1 / (m : Real)) •
            centeredSampleCovarianceRowRankOneSum (P := P) A omega) := by
            rw [hDevEq]
            rfl
      _ =
          |1 / (m : Real)| *
            norm (centeredSampleCovarianceRowRankOneSum (P := P) A omega) := by
            rw [norm_smul, Real.norm_eq_abs]
      _ =
          (1 / (m : Real)) *
            operatorNorm (centeredSampleCovarianceRowRankOneSum (P := P) A)
              omega := by
            rw [abs_of_nonneg (one_div_nonneg.mpr hmReal.le)]
            rfl
  change (m : Real) * t <=
    operatorNorm (centeredSampleCovarianceRowRankOneSum (P := P) A) omega
  rw [hNorm] at hTail
  have hScaled :=
    mul_le_mul_of_nonneg_left hTail hmReal.le
  calc
    (m : Real) * t <=
        (m : Real) *
          ((1 / (m : Real)) *
            operatorNorm (centeredSampleCovarianceRowRankOneSum (P := P) A)
              omega) := hScaled
    _ =
        operatorNorm (centeredSampleCovarianceRowRankOneSum (P := P) A)
          omega := by
          field_simp [ne_of_gt hmReal]

/-- Centered rank-one radius produced by a row squared-norm bound `R`. -/
abbrev sampleCovarianceCenteredRankOneRadius (R : Real) : Real :=
  2 * R

/-- Crude variance-proxy norm bound for the centered row-rank-one family under
a row squared-norm bound `R`. -/
abbrev sampleCovarianceCenteredRankOneVarianceProxyBound {m : Nat}
    (R : Real) : Real :=
  (m : Real) * sampleCovarianceCenteredRankOneRadius R ^ 2

/-- Positivity of the crude sample-covariance variance-proxy norm bound. -/
theorem sampleCovarianceCenteredRankOneVarianceProxyBound_pos {m : Nat}
    {R : Real} (hm : 0 < m) (hR : 0 < R) :
    0 < sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R := by
  have hmReal : 0 < (m : Real) := by
    exact_mod_cast hm
  have hRadius : 0 < sampleCovarianceCenteredRankOneRadius R := by
    simpa [sampleCovarianceCenteredRankOneRadius] using show 0 < 2 * R by
      nlinarith
  exact mul_pos hmReal (sq_pos_of_pos hRadius)

/-- Optimized Bernstein parameter for the sample-covariance tail wrapper. -/
abbrev sampleCovarianceTailTheta {m : Nat} (R t sigmaSq : Real) : Real :=
  bernsteinThetaChoice ((m : Real) * t) sigmaSq
    (sampleCovarianceCenteredRankOneRadius R)

/-- Named scalar RHS for sample-covariance Bernstein tail wrappers.

The dimension parameter `n` is the actual column dimension of the sample
matrix. Existing nonempty wrappers pass `n + 1` explicitly. -/
abbrev sampleCovarianceQuadraticFormTailRHS {m n : Nat}
    (R t sigmaSq : Real) : ENNReal :=
  ENNReal.ofReal
    ((n : Real) *
      Real.exp (-(((m : Real) * t) ^ 2 /
        (2 * sigmaSq + (2 / 3) *
          sampleCovarianceCenteredRankOneRadius R * ((m : Real) * t)))))

/-- Negative centered row-rank-one family for sample covariance wrappers. -/
abbrev centeredSampleCovarianceRowRankOneFamilyNeg
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {m n : Nat}
    (A : RandomMatrix Omega m n) :
    Fin m -> RandomMatrix Omega n n :=
  negRandomMatrixFamily
    (centeredSampleCovarianceRowRankOneFamily (P := P) A)

/-- Sum of the negative centered row-rank-one sample-covariance family. -/
abbrev centeredSampleCovarianceRowRankOneSumNeg
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {m n : Nat}
    (A : RandomMatrix Omega m n) :
    RandomMatrix Omega n n :=
  randomMatrixSum
    (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)

/-- Sample-covariance row-rank-one variance-proxy norm bound from a row
squared-norm bound and explicit square-integrability of the centered
summands. -/
theorem MatrixVarianceProxyNormBound_centeredSampleCovarianceRowRankOneFamily_of_rowSqNorm_bound
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m n) {R : Real}
    (hMeas : IsRandomMatrix P A)
    (hLp :
      forall k : Fin m, forall j : Fin n,
        MemLpRealRandomVariable P (matrixEntry A k j) 2)
    (hSq :
      forall k : Fin m, forall omega,
        vectorSqNorm (rowVector A k omega) <= R)
    (hR : 0 <= R)
    (hIntSq :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (randomMatrixSquare
            ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k))) :
    MatrixVarianceProxyNormBound P
      (centeredSampleCovarianceRowRankOneFamily (P := P) A)
      (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R) := by
  have hRowsRandom :
      forall k : Fin m, IsRandomVector P (rowVector A k) := by
    intro k
    exact isRandomVector_rowVector hMeas k
  have hRowsLp :
      forall k : Fin m, forall j : Fin n,
        MemLpRealRandomVariable P (coord (rowVector A k) j) 2 := by
    intro k j
    change MemLpRealRandomVariable P (matrixEntry A k j) 2
    exact hLp k j
  have hGeneric :
      MatrixVarianceProxyNormBound P
        (centeredRankOneRandomMatrixFamily P (rowVector A))
        (centeredRankOneVarianceProxyNormRHS (I := Fin m) R) :=
    MatrixVarianceProxyNormBound_centeredRankOneRandomMatrixFamily_of_sqNorm_bound
      (P := P) (X := rowVector A) hRowsRandom hRowsLp hSq hR hIntSq
  simpa [centeredSampleCovarianceRowRankOneFamily,
    sampleCovarianceCenteredRankOneVarianceProxyBound,
    sampleCovarianceCenteredRankOneRadius,
    centeredRankOneVarianceProxyNormRHS,
    pointwiseOperatorNormVarianceProxyNormRHS] using hGeneric

/--
Sample covariance quadratic-form upper-tail wrapper under explicit Matrix
Bernstein primitive assumptions.

The wrapper rewrites the centered sample covariance as the normalized centered
row rank-one sum, applies the optimized quadratic-form Matrix Bernstein theorem
to the unnormalized centered row rank-one summands at threshold
`(m : Real) * t`, and transports the result back across the normalization.

The variance proxy remains explicit through
`MatrixVarianceProxyNormBound P (centeredSampleCovarianceRowRankOneFamily (P := P) A) sigmaSq`.
This theorem does not prove variance proxy control, independence, Tropp/Lieb,
Bernstein CFC, or an operator-norm tail bound.
-/
theorem sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m (n + 1))
    (R t sigmaSq : Real)
    (hm : 0 < m)
    (hMeas : IsRandomMatrix P A)
    (hLp :
      forall k : Fin m, forall j : Fin (n + 1),
        MemLpRealRandomVariable P (matrixEntry A k j) 2)
    (hSq :
      forall k : Fin m, forall omega,
        vectorSqNorm (rowVector A k omega) <= R)
    (hIndep :
      IndependentRandomMatrices P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A))
    (hIntSq :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (randomMatrixSquare
            ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k)))
    (hExpInt :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily
            (centeredSampleCovarianceRowRankOneFamily (P := P) A)
            (sampleCovarianceTailTheta (m := m) R t sigmaSq)
            k))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand
          (centeredSampleCovarianceRowRankOneSum (P := P) A)
          (sampleCovarianceTailTheta (m := m) R t sigmaSq)))
    (hSigma : 0 < sigmaSq)
    (hR : 0 <= R)
    (ht : 0 < t)
    (hNorm :
      MatrixVarianceProxyNormBound P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A) sigmaSq)
    (hCFC :
      forall k : Fin m, forall omega,
        bernsteinMatrixExp_le_quadratic_statement
          ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k omega)
          (sampleCovarianceTailTheta (m := m) R t sigmaSq)
          (sampleCovarianceCenteredRankOneRadius R))
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P)
        (centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (bernsteinSecondMomentComparisonFamily P
          (centeredSampleCovarianceRowRankOneFamily (P := P) A)
          (sampleCovarianceTailTheta (m := m) R t sigmaSq)
          (sampleCovarianceCenteredRankOneRadius R))
        (matrixVarianceProxy P
          (centeredSampleCovarianceRowRankOneFamily (P := P) A))
        (sampleCovarianceTailTheta (m := m) R t sigmaSq)
        (sampleCovarianceCenteredRankOneRadius R)) :
    P (quadraticFormUpperTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t) <=
      sampleCovarianceQuadraticFormTailRHS
        (m := m) (n := n + 1) R t sigmaSq := by
  have hmReal : 0 < (m : Real) := by
    exact_mod_cast hm
  have hRowsRandom :
      forall k : Fin m, IsRandomVector P (rowVector A k) := by
    intro k
    exact isRandomVector_rowVector hMeas k
  have hRowsLp :
      forall k : Fin m, forall j : Fin (n + 1),
        MemLpRealRandomVariable P (coord (rowVector A k) j) 2 := by
    intro k j
    change MemLpRealRandomVariable P (matrixEntry A k j) 2
    exact hLp k j
  have hRowsRankOneInt :
      forall k : Fin m,
        IntegrableRandomMatrix P (rankOneRandomMatrix (rowVector A k)) := by
    intro k
    exact integrableRandomMatrix_rankOneRandomMatrix_of_memLp_two
      (P := P) (X := rowVector A k) (hRowsLp k)
  have hCentered :
      CenteredSelfAdjointRandomMatrixFamily P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A) :=
    centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two
      (P := P) (X := rowVector A) hRowsRandom hRowsLp
  have hIndepSA :
      IndependentSelfAdjointRandomMatrices P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A) := by
    exact ⟨hCentered.1, hIndep⟩
  have hIntX :
      forall k : Fin m,
        IntegrableRandomMatrix P
          ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k) := by
    intro k
    change IntegrableRandomMatrix P
      (centeredRankOneRandomMatrix P (rowVector A k))
    exact centeredRankOneRandomMatrix_integrable_of_memLp_two
      (P := P) (X := rowVector A k) (hRowsLp k)
  have hBound :
      PointwiseOperatorNormBound
        (centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (sampleCovarianceCenteredRankOneRadius R) :=
    PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound
      (P := P) (X := rowVector A) hRowsRandom hRowsLp hSq hR
  have hRadius : 0 <= sampleCovarianceCenteredRankOneRadius R := by
    simpa [sampleCovarianceCenteredRankOneRadius] using show 0 <= 2 * R by
      nlinarith
  have hmt : 0 < (m : Real) * t := by
    exact mul_pos hmReal ht
  have hMB :
      P (quadraticFormUpperTailEvent
          (randomMatrixSum
            (centeredSampleCovarianceRowRankOneFamily (P := P) A))
          ((m : Real) * t)) <=
        sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n + 1) R t sigmaSq := by
    simpa [sampleCovarianceQuadraticFormTailRHS, sampleCovarianceTailTheta,
      sampleCovarianceCenteredRankOneRadius] using
      matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
        (P := P)
        (A := centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (R := sampleCovarianceCenteredRankOneRadius R)
        (t := (m : Real) * t) (sigmaSq := sigmaSq)
        hCentered hIndepSA hIntX hIntSq hExpInt
        (by
          change IntegrableRealRandomVariable P
            (traceExpIntegrand
              (centeredSampleCovarianceRowRankOneSum (P := P) A)
              (sampleCovarianceTailTheta (m := m) R t sigmaSq))
          exact hTraceInt)
        hBound hSigma hRadius hmt hNorm hCFC hTropp
  have hMBNamed :
      P (quadraticFormUpperTailEvent
          (centeredSampleCovarianceRowRankOneSum (P := P) A)
          ((m : Real) * t)) <=
        sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n + 1) R t sigmaSq := by
    change P (quadraticFormUpperTailEvent
          (randomMatrixSum
            (centeredSampleCovarianceRowRankOneFamily (P := P) A))
          ((m : Real) * t)) <=
        sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n + 1) R t sigmaSq
    exact hMB
  have hSubset :
      quadraticFormUpperTailEvent
          (centeredRandomMatrix P (sampleCovariance A)) t ⊆
        quadraticFormUpperTailEvent
          (centeredSampleCovarianceRowRankOneSum (P := P) A)
          ((m : Real) * t) := by
    intro omega hTail
    rcases hTail with ⟨x, hxUnit, htTail⟩
    refine ⟨x, hxUnit, ?_⟩
    have hDevEq :=
      congrFun
        (sampleCovariance_deviation_eq_normalized_centered_rowRankOne_sum
          (P := P) A hRowsRankOneInt) omega
    have hQuad :
        matrixQuadraticForm
            (centeredRandomMatrix P (sampleCovariance A) omega) x =
          (1 / (m : Real)) *
            matrixQuadraticForm
              (centeredSampleCovarianceRowRankOneSum (P := P) A omega) x := by
      rw [hDevEq]
      change matrixQuadraticForm
          ((1 / (m : Real)) •
            centeredSampleCovarianceRowRankOneSum (P := P) A omega) x =
        (1 / (m : Real)) *
          matrixQuadraticForm
            (centeredSampleCovarianceRowRankOneSum (P := P) A omega) x
      exact
        (matrixQuadraticForm_smul (1 / (m : Real))
          (centeredSampleCovarianceRowRankOneSum (P := P) A omega) x)
    have htScaled :
        t <=
          (1 / (m : Real)) *
            matrixQuadraticForm
              (centeredSampleCovarianceRowRankOneSum (P := P) A omega) x := by
      rw [hQuad] at htTail
      exact htTail
    have hMul :=
      mul_le_mul_of_nonneg_left htScaled hmReal.le
    calc
      (m : Real) * t <=
          (m : Real) *
            ((1 / (m : Real)) *
              matrixQuadraticForm
                (centeredSampleCovarianceRowRankOneSum (P := P) A omega) x) :=
        hMul
      _ =
          matrixQuadraticForm
            (centeredSampleCovarianceRowRankOneSum (P := P) A omega) x := by
        field_simp [ne_of_gt hmReal]
  exact le_trans (measure_mono hSubset) hMBNamed

/-- Sample-covariance quadratic-form upper-tail wrapper using the crude
bounded-row variance-proxy norm bound.

This removes the explicit `MatrixVarianceProxyNormBound` hypothesis from the
common bounded-row route. It still keeps independence, square-integrability,
trace-integrability, Tropp, and Bernstein CFC primitive assumptions explicit.
-/
theorem sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m (n + 1))
    (R t : Real)
    (hm : 0 < m)
    (hMeas : IsRandomMatrix P A)
    (hLp :
      forall k : Fin m, forall j : Fin (n + 1),
        MemLpRealRandomVariable P (matrixEntry A k j) 2)
    (hSq :
      forall k : Fin m, forall omega,
        vectorSqNorm (rowVector A k omega) <= R)
    (hIndep :
      IndependentRandomMatrices P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A))
    (hIntSq :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (randomMatrixSquare
            ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k)))
    (hExpInt :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily
            (centeredSampleCovarianceRowRankOneFamily (P := P) A)
            (sampleCovarianceTailTheta (m := m) R t
              (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R))
            k))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand
          (centeredSampleCovarianceRowRankOneSum (P := P) A)
          (sampleCovarianceTailTheta (m := m) R t
            (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R))))
    (hR : 0 < R)
    (ht : 0 < t)
    (hCFC :
      forall k : Fin m, forall omega,
        bernsteinMatrixExp_le_quadratic_statement
          ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k omega)
          (sampleCovarianceTailTheta (m := m) R t
            (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R))
          (sampleCovarianceCenteredRankOneRadius R))
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P)
        (centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (bernsteinSecondMomentComparisonFamily P
          (centeredSampleCovarianceRowRankOneFamily (P := P) A)
          (sampleCovarianceTailTheta (m := m) R t
            (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R))
          (sampleCovarianceCenteredRankOneRadius R))
        (matrixVarianceProxy P
          (centeredSampleCovarianceRowRankOneFamily (P := P) A))
        (sampleCovarianceTailTheta (m := m) R t
          (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R))
        (sampleCovarianceCenteredRankOneRadius R)) :
    P (quadraticFormUpperTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t) <=
      sampleCovarianceQuadraticFormTailRHS
        (m := m) (n := n + 1) R t
        (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R) := by
  have hSigma :
      0 < sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R :=
    sampleCovarianceCenteredRankOneVarianceProxyBound_pos hm hR
  have hNorm :
      MatrixVarianceProxyNormBound P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R) :=
    MatrixVarianceProxyNormBound_centeredSampleCovarianceRowRankOneFamily_of_rowSqNorm_bound
      (P := P) A hMeas hLp hSq hR.le hIntSq
  exact
    sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy
      (P := P) (A := A) (R := R) (t := t)
      (sigmaSq := sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R)
      hm hMeas hLp hSq hIndep hIntSq hExpInt hTraceInt hSigma hR.le ht
      hNorm hCFC hTropp

/-- Sample-covariance self-adjoint operator-norm tail wrapper under explicit
variance-proxy and Matrix Bernstein primitive assumptions.

This transports the public centered sample-covariance operator-norm event to
the unnormalized centered row rank-one sum, then applies the conditional
self-adjoint operator-norm Matrix Bernstein wrapper. The operator-norm spectral
bridge remains explicit through
`selfAdjointOperatorNormTailViaQuadraticFormStatement`; variance proxies,
integrability, independence, CFC, and Tropp primitives remain explicit for both
signs.
-/
theorem sampleCovariance_selfAdjointOperatorNorm_tail_optimized_under_explicit_variance_proxy
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m (n + 1))
    (R Rneg t sigmaSq sigmaSqNeg : Real)
    (hm : 0 < m)
    (hMeas : IsRandomMatrix P A)
    (hLp :
      forall k : Fin m, forall j : Fin (n + 1),
        MemLpRealRandomVariable P (matrixEntry A k j) 2)
    (hSq :
      forall k : Fin m, forall omega,
        vectorSqNorm (rowVector A k omega) <= R)
    (hIndep :
      IndependentRandomMatrices P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A))
    (hIntSq :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (randomMatrixSquare
            ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k)))
    (hExpInt :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily
            (centeredSampleCovarianceRowRankOneFamily (P := P) A)
            (sampleCovarianceTailTheta (m := m) R t sigmaSq)
            k))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand
          (centeredSampleCovarianceRowRankOneSum (P := P) A)
          (sampleCovarianceTailTheta (m := m) R t sigmaSq)))
    (hSigma : 0 < sigmaSq)
    (hR : 0 <= R)
    (ht : 0 < t)
    (hOperatorBridge :
      selfAdjointOperatorNormTailViaQuadraticFormStatement
        (centeredSampleCovarianceRowRankOneSum (P := P) A)
        ((m : Real) * t))
    (hNorm :
      MatrixVarianceProxyNormBound P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A) sigmaSq)
    (hCFC :
      forall k : Fin m, forall omega,
        bernsteinMatrixExp_le_quadratic_statement
          ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k omega)
          (sampleCovarianceTailTheta (m := m) R t sigmaSq)
          (sampleCovarianceCenteredRankOneRadius R))
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P)
        (centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (bernsteinSecondMomentComparisonFamily P
          (centeredSampleCovarianceRowRankOneFamily (P := P) A)
          (sampleCovarianceTailTheta (m := m) R t sigmaSq)
          (sampleCovarianceCenteredRankOneRadius R))
        (matrixVarianceProxy P
          (centeredSampleCovarianceRowRankOneFamily (P := P) A))
        (sampleCovarianceTailTheta (m := m) R t sigmaSq)
        (sampleCovarianceCenteredRankOneRadius R))
    (hCenteredNeg :
      CenteredSelfAdjointRandomMatrixFamily P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A))
    (hIndepSANeg :
      IndependentSelfAdjointRandomMatrices P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A))
    (hIntXNeg :
      forall k : Fin m,
        IntegrableRandomMatrix P
          ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A) k))
    (hIntSqNeg :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (randomMatrixSquare
            ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A) k)))
    (hExpIntNeg :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily
            (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
            (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
            k))
    (hTraceIntNeg :
      IntegrableRealRandomVariable P
        (traceExpIntegrand
          (centeredSampleCovarianceRowRankOneSumNeg (P := P) A)
          (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)))
    (hBoundNeg :
      PointwiseOperatorNormBound
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
        (sampleCovarianceCenteredRankOneRadius Rneg))
    (hSigmaNeg : 0 < sigmaSqNeg)
    (hRNeg : 0 <= Rneg)
    (hNormNeg :
      MatrixVarianceProxyNormBound P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
        sigmaSqNeg)
    (hCFCNeg :
      forall k : Fin m, forall omega,
        bernsteinMatrixExp_le_quadratic_statement
          ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
            k omega)
          (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
          (sampleCovarianceCenteredRankOneRadius Rneg))
    (hTroppNeg :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P)
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
        (bernsteinSecondMomentComparisonFamily P
          (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
          (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
          (sampleCovarianceCenteredRankOneRadius Rneg))
        (matrixVarianceProxy P
          (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A))
        (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
        (sampleCovarianceCenteredRankOneRadius Rneg)) :
    P (SelfAdjointOperatorNormTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t) <=
      sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n + 1) R t sigmaSq +
        sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n + 1) Rneg t sigmaSqNeg := by
  have hmReal : 0 < (m : Real) := by
    exact_mod_cast hm
  have hRowsRandom :
      forall k : Fin m, IsRandomVector P (rowVector A k) := by
    intro k
    exact isRandomVector_rowVector hMeas k
  have hRowsLp :
      forall k : Fin m, forall j : Fin (n + 1),
        MemLpRealRandomVariable P (coord (rowVector A k) j) 2 := by
    intro k j
    change MemLpRealRandomVariable P (matrixEntry A k j) 2
    exact hLp k j
  have hRowsRankOneInt :
      forall k : Fin m,
        IntegrableRandomMatrix P (rankOneRandomMatrix (rowVector A k)) := by
    intro k
    exact integrableRandomMatrix_rankOneRandomMatrix_of_memLp_two
      (P := P) (X := rowVector A k) (hRowsLp k)
  have hCentered :
      CenteredSelfAdjointRandomMatrixFamily P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A) :=
    centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two
      (P := P) (X := rowVector A) hRowsRandom hRowsLp
  have hIndepSA :
      IndependentSelfAdjointRandomMatrices P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A) := by
    exact ⟨hCentered.1, hIndep⟩
  have hIntX :
      forall k : Fin m,
        IntegrableRandomMatrix P
          ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k) := by
    intro k
    change IntegrableRandomMatrix P
      (centeredRankOneRandomMatrix P (rowVector A k))
    exact centeredRankOneRandomMatrix_integrable_of_memLp_two
      (P := P) (X := rowVector A k) (hRowsLp k)
  have hBound :
      PointwiseOperatorNormBound
        (centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (sampleCovarianceCenteredRankOneRadius R) :=
    PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound
      (P := P) (X := rowVector A) hRowsRandom hRowsLp hSq hR
  have hRadius : 0 <= sampleCovarianceCenteredRankOneRadius R := by
    simpa [sampleCovarianceCenteredRankOneRadius] using show 0 <= 2 * R by
      nlinarith
  have hRadiusNeg : 0 <= sampleCovarianceCenteredRankOneRadius Rneg := by
    simpa [sampleCovarianceCenteredRankOneRadius] using show 0 <= 2 * Rneg by
      nlinarith
  have hmt : 0 < (m : Real) * t := by
    exact mul_pos hmReal ht
  have hSubset :
      SelfAdjointOperatorNormTailEvent
          (centeredRandomMatrix P (sampleCovariance A)) t ⊆
        SelfAdjointOperatorNormTailEvent
          (centeredSampleCovarianceRowRankOneSum (P := P) A)
          ((m : Real) * t) :=
    sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum
      (P := P) A t hm hRowsRankOneInt
  have hMB :
      P (SelfAdjointOperatorNormTailEvent
          (centeredSampleCovarianceRowRankOneSum (P := P) A)
          ((m : Real) * t)) <=
        sampleCovarianceQuadraticFormTailRHS
            (m := m) (n := n + 1) R t sigmaSq +
          sampleCovarianceQuadraticFormTailRHS
            (m := m) (n := n + 1) Rneg t sigmaSqNeg := by
    simpa [sampleCovarianceQuadraticFormTailRHS,
      sampleCovarianceTailTheta, sampleCovarianceCenteredRankOneRadius] using
      matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
        (P := P)
        (A := centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (R := sampleCovarianceCenteredRankOneRadius R)
        (Rneg := sampleCovarianceCenteredRankOneRadius Rneg)
        (t := (m : Real) * t) (sigmaSq := sigmaSq)
        (sigmaSqNeg := sigmaSqNeg)
        hCentered hIndepSA hIntX hIntSq hExpInt
        (by
          change IntegrableRealRandomVariable P
            (traceExpIntegrand
              (centeredSampleCovarianceRowRankOneSum (P := P) A)
              (sampleCovarianceTailTheta (m := m) R t sigmaSq))
          exact hTraceInt)
        hBound hSigma hRadius hmt
        (by
          change selfAdjointOperatorNormTailViaQuadraticFormStatement
            (centeredSampleCovarianceRowRankOneSum (P := P) A)
            ((m : Real) * t)
          exact hOperatorBridge)
        hNorm hCFC hTropp hCenteredNeg hIndepSANeg hIntXNeg hIntSqNeg
        hExpIntNeg hTraceIntNeg hBoundNeg hSigmaNeg hRadiusNeg hNormNeg
        hCFCNeg hTroppNeg
  exact (measure_mono hSubset).trans hMB

/-- Sample-covariance self-adjoint operator-norm tail wrapper in nonempty
dimensions under explicit variance-proxy and Matrix Bernstein primitive
assumptions.

This is the nonempty-square version of
`sampleCovariance_selfAdjointOperatorNorm_tail_optimized_under_explicit_variance_proxy`.
It transports the public centered sample-covariance operator-norm event to the
unnormalized centered row rank-one sum, then applies the S4 nonempty
self-adjoint operator-norm Matrix Bernstein wrapper. The spectral bridge is
therefore supplied internally by the Matrix Bernstein wrapper; variance
proxies, integrability, independence, CFC, and Tropp primitives remain explicit
for both signs.
-/
theorem sampleCovariance_selfAdjointOperatorNorm_tail_optimized_nonempty_under_explicit_variance_proxy
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m (n + 1))
    (R Rneg t sigmaSq sigmaSqNeg : Real)
    (hm : 0 < m)
    (hMeas : IsRandomMatrix P A)
    (hLp :
      forall k : Fin m, forall j : Fin (n + 1),
        MemLpRealRandomVariable P (matrixEntry A k j) 2)
    (hSq :
      forall k : Fin m, forall omega,
        vectorSqNorm (rowVector A k omega) <= R)
    (hIndep :
      IndependentRandomMatrices P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A))
    (hIntSq :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (randomMatrixSquare
            ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k)))
    (hExpInt :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily
            (centeredSampleCovarianceRowRankOneFamily (P := P) A)
            (sampleCovarianceTailTheta (m := m) R t sigmaSq)
            k))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand
          (centeredSampleCovarianceRowRankOneSum (P := P) A)
          (sampleCovarianceTailTheta (m := m) R t sigmaSq)))
    (hSigma : 0 < sigmaSq)
    (hR : 0 <= R)
    (ht : 0 < t)
    (hNorm :
      MatrixVarianceProxyNormBound P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A) sigmaSq)
    (hCFC :
      forall k : Fin m, forall omega,
        bernsteinMatrixExp_le_quadratic_statement
          ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k omega)
          (sampleCovarianceTailTheta (m := m) R t sigmaSq)
          (sampleCovarianceCenteredRankOneRadius R))
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P)
        (centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (bernsteinSecondMomentComparisonFamily P
          (centeredSampleCovarianceRowRankOneFamily (P := P) A)
          (sampleCovarianceTailTheta (m := m) R t sigmaSq)
          (sampleCovarianceCenteredRankOneRadius R))
        (matrixVarianceProxy P
          (centeredSampleCovarianceRowRankOneFamily (P := P) A))
        (sampleCovarianceTailTheta (m := m) R t sigmaSq)
        (sampleCovarianceCenteredRankOneRadius R))
    (hCenteredNeg :
      CenteredSelfAdjointRandomMatrixFamily P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A))
    (hIndepSANeg :
      IndependentSelfAdjointRandomMatrices P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A))
    (hIntXNeg :
      forall k : Fin m,
        IntegrableRandomMatrix P
          ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A) k))
    (hIntSqNeg :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (randomMatrixSquare
            ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A) k)))
    (hExpIntNeg :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily
            (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
            (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
            k))
    (hTraceIntNeg :
      IntegrableRealRandomVariable P
        (traceExpIntegrand
          (centeredSampleCovarianceRowRankOneSumNeg (P := P) A)
          (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)))
    (hBoundNeg :
      PointwiseOperatorNormBound
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
        (sampleCovarianceCenteredRankOneRadius Rneg))
    (hSigmaNeg : 0 < sigmaSqNeg)
    (hRNeg : 0 <= Rneg)
    (hNormNeg :
      MatrixVarianceProxyNormBound P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
        sigmaSqNeg)
    (hCFCNeg :
      forall k : Fin m, forall omega,
        bernsteinMatrixExp_le_quadratic_statement
          ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
            k omega)
          (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
          (sampleCovarianceCenteredRankOneRadius Rneg))
    (hTroppNeg :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P)
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
        (bernsteinSecondMomentComparisonFamily P
          (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
          (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
          (sampleCovarianceCenteredRankOneRadius Rneg))
        (matrixVarianceProxy P
          (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A))
        (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
        (sampleCovarianceCenteredRankOneRadius Rneg)) :
    P (SelfAdjointOperatorNormTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t) <=
      sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n + 1) R t sigmaSq +
        sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n + 1) Rneg t sigmaSqNeg := by
  have hmReal : 0 < (m : Real) := by
    exact_mod_cast hm
  have hRowsRandom :
      forall k : Fin m, IsRandomVector P (rowVector A k) := by
    intro k
    exact isRandomVector_rowVector hMeas k
  have hRowsLp :
      forall k : Fin m, forall j : Fin (n + 1),
        MemLpRealRandomVariable P (coord (rowVector A k) j) 2 := by
    intro k j
    change MemLpRealRandomVariable P (matrixEntry A k j) 2
    exact hLp k j
  have hRowsRankOneInt :
      forall k : Fin m,
        IntegrableRandomMatrix P (rankOneRandomMatrix (rowVector A k)) := by
    intro k
    exact integrableRandomMatrix_rankOneRandomMatrix_of_memLp_two
      (P := P) (X := rowVector A k) (hRowsLp k)
  have hCentered :
      CenteredSelfAdjointRandomMatrixFamily P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A) :=
    centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two
      (P := P) (X := rowVector A) hRowsRandom hRowsLp
  have hIndepSA :
      IndependentSelfAdjointRandomMatrices P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A) := by
    exact ⟨hCentered.1, hIndep⟩
  have hIntX :
      forall k : Fin m,
        IntegrableRandomMatrix P
          ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k) := by
    intro k
    change IntegrableRandomMatrix P
      (centeredRankOneRandomMatrix P (rowVector A k))
    exact centeredRankOneRandomMatrix_integrable_of_memLp_two
      (P := P) (X := rowVector A k) (hRowsLp k)
  have hBound :
      PointwiseOperatorNormBound
        (centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (sampleCovarianceCenteredRankOneRadius R) :=
    PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound
      (P := P) (X := rowVector A) hRowsRandom hRowsLp hSq hR
  have hRadius : 0 <= sampleCovarianceCenteredRankOneRadius R := by
    simpa [sampleCovarianceCenteredRankOneRadius] using show 0 <= 2 * R by
      nlinarith
  have hRadiusNeg : 0 <= sampleCovarianceCenteredRankOneRadius Rneg := by
    simpa [sampleCovarianceCenteredRankOneRadius] using show 0 <= 2 * Rneg by
      nlinarith
  have hmt : 0 < (m : Real) * t := by
    exact mul_pos hmReal ht
  have hSubset :
      SelfAdjointOperatorNormTailEvent
          (centeredRandomMatrix P (sampleCovariance A)) t <=
        SelfAdjointOperatorNormTailEvent
          (centeredSampleCovarianceRowRankOneSum (P := P) A)
          ((m : Real) * t) :=
    sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum
      (P := P) A t hm hRowsRankOneInt
  have hMB :
      P (SelfAdjointOperatorNormTailEvent
          (centeredSampleCovarianceRowRankOneSum (P := P) A)
          ((m : Real) * t)) <=
        sampleCovarianceQuadraticFormTailRHS
            (m := m) (n := n + 1) R t sigmaSq +
          sampleCovarianceQuadraticFormTailRHS
            (m := m) (n := n + 1) Rneg t sigmaSqNeg := by
    simpa [sampleCovarianceQuadraticFormTailRHS,
      sampleCovarianceTailTheta, sampleCovarianceCenteredRankOneRadius] using
      matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_nonempty_under_primitives
        (P := P)
        (A := centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (R := sampleCovarianceCenteredRankOneRadius R)
        (Rneg := sampleCovarianceCenteredRankOneRadius Rneg)
        (t := (m : Real) * t) (sigmaSq := sigmaSq)
        (sigmaSqNeg := sigmaSqNeg)
        hCentered hIndepSA hIntX hIntSq hExpInt
        (by
          change IntegrableRealRandomVariable P
            (traceExpIntegrand
              (centeredSampleCovarianceRowRankOneSum (P := P) A)
              (sampleCovarianceTailTheta (m := m) R t sigmaSq))
          exact hTraceInt)
        hBound hSigma hRadius hmt
        hNorm hCFC hTropp hCenteredNeg hIndepSANeg hIntXNeg hIntSqNeg
        hExpIntNeg hTraceIntNeg hBoundNeg hSigmaNeg hRadiusNeg hNormNeg
        hCFCNeg hTroppNeg
  exact (measure_mono hSubset).trans hMB

/-- Arbitrary-column sample-covariance self-adjoint operator-norm tail wrapper
under explicit variance-proxy and Matrix Bernstein primitive assumptions.

For positive thresholds, the zero-column endpoint is empty by the deterministic
operator-norm endpoint lemma. In positive dimension this is the existing
nonempty sample-covariance wrapper with the actual column dimension passed to
the named RHS helper. Variance proxies, integrability, independence, CFC, and
Tropp primitives remain explicit for both signs.
-/
theorem sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_explicit_variance_proxy
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m n)
    (R Rneg t sigmaSq sigmaSqNeg : Real)
    (hm : 0 < m)
    (hMeas : IsRandomMatrix P A)
    (hLp :
      forall k : Fin m, forall j : Fin n,
        MemLpRealRandomVariable P (matrixEntry A k j) 2)
    (hSq :
      forall k : Fin m, forall omega,
        vectorSqNorm (rowVector A k omega) <= R)
    (hIndep :
      IndependentRandomMatrices P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A))
    (hIntSq :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (randomMatrixSquare
            ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k)))
    (hExpInt :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily
            (centeredSampleCovarianceRowRankOneFamily (P := P) A)
            (sampleCovarianceTailTheta (m := m) R t sigmaSq)
            k))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand
          (centeredSampleCovarianceRowRankOneSum (P := P) A)
          (sampleCovarianceTailTheta (m := m) R t sigmaSq)))
    (hSigma : 0 < sigmaSq)
    (hR : 0 <= R)
    (ht : 0 < t)
    (hNorm :
      MatrixVarianceProxyNormBound P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A) sigmaSq)
    (hCFC :
      forall k : Fin m, forall omega,
        bernsteinMatrixExp_le_quadratic_statement
          ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k omega)
          (sampleCovarianceTailTheta (m := m) R t sigmaSq)
          (sampleCovarianceCenteredRankOneRadius R))
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P)
        (centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (bernsteinSecondMomentComparisonFamily P
          (centeredSampleCovarianceRowRankOneFamily (P := P) A)
          (sampleCovarianceTailTheta (m := m) R t sigmaSq)
          (sampleCovarianceCenteredRankOneRadius R))
        (matrixVarianceProxy P
          (centeredSampleCovarianceRowRankOneFamily (P := P) A))
        (sampleCovarianceTailTheta (m := m) R t sigmaSq)
        (sampleCovarianceCenteredRankOneRadius R))
    (hCenteredNeg :
      CenteredSelfAdjointRandomMatrixFamily P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A))
    (hIndepSANeg :
      IndependentSelfAdjointRandomMatrices P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A))
    (hIntXNeg :
      forall k : Fin m,
        IntegrableRandomMatrix P
          ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A) k))
    (hIntSqNeg :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (randomMatrixSquare
            ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A) k)))
    (hExpIntNeg :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily
            (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
            (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
            k))
    (hTraceIntNeg :
      IntegrableRealRandomVariable P
        (traceExpIntegrand
          (centeredSampleCovarianceRowRankOneSumNeg (P := P) A)
          (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)))
    (hBoundNeg :
      PointwiseOperatorNormBound
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
        (sampleCovarianceCenteredRankOneRadius Rneg))
    (hSigmaNeg : 0 < sigmaSqNeg)
    (hRNeg : 0 <= Rneg)
    (hNormNeg :
      MatrixVarianceProxyNormBound P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
        sigmaSqNeg)
    (hCFCNeg :
      forall k : Fin m, forall omega,
        bernsteinMatrixExp_le_quadratic_statement
          ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
            k omega)
          (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
          (sampleCovarianceCenteredRankOneRadius Rneg))
    (hTroppNeg :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P)
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
        (bernsteinSecondMomentComparisonFamily P
          (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
          (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
          (sampleCovarianceCenteredRankOneRadius Rneg))
        (matrixVarianceProxy P
          (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A))
        (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
        (sampleCovarianceCenteredRankOneRadius Rneg)) :
    P (SelfAdjointOperatorNormTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t) <=
      sampleCovarianceQuadraticFormTailRHS (m := m) (n := n) R t sigmaSq +
        sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n) Rneg t sigmaSqNeg := by
  cases n with
  | zero =>
      have hEmpty :
          SelfAdjointOperatorNormTailEvent
              (centeredRandomMatrix P (sampleCovariance A)) t = ∅ :=
        selfAdjointOperatorNormTailEvent_empty_of_zero_dim_of_pos
          (centeredRandomMatrix P (sampleCovariance A)) ht
      rw [hEmpty, measure_empty]
      exact zero_le _
  | succ n =>
      exact
        sampleCovariance_selfAdjointOperatorNorm_tail_optimized_nonempty_under_explicit_variance_proxy
          (P := P) (A := A) (R := R) (Rneg := Rneg) (t := t)
          (sigmaSq := sigmaSq) (sigmaSqNeg := sigmaSqNeg)
          hm hMeas hLp hSq hIndep hIntSq hExpInt hTraceInt hSigma hR ht
          hNorm hCFC hTropp hCenteredNeg hIndepSANeg hIntXNeg hIntSqNeg
          hExpIntNeg hTraceIntNeg hBoundNeg hSigmaNeg hRNeg hNormNeg
          hCFCNeg hTroppNeg

/-- Arbitrary-column sample-covariance self-adjoint operator-norm tail wrapper
using crude bounded-row variance-proxy norm bounds.

This removes the explicit variance-proxy norm assumptions for both the
centered row-rank-one family and the negative family. The remaining analytic
primitive, independence, integrability, and negative-family structural
assumptions stay explicit.
-/
theorem sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {m n : Nat}
    (A : RandomMatrix Omega m n)
    (R Rneg t : Real)
    (hm : 0 < m)
    (hMeas : IsRandomMatrix P A)
    (hLp :
      forall k : Fin m, forall j : Fin n,
        MemLpRealRandomVariable P (matrixEntry A k j) 2)
    (hSq :
      forall k : Fin m, forall omega,
        vectorSqNorm (rowVector A k omega) <= R)
    (hIndep :
      IndependentRandomMatrices P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A))
    (hIntSq :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (randomMatrixSquare
            ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k)))
    (hExpInt :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily
            (centeredSampleCovarianceRowRankOneFamily (P := P) A)
            (sampleCovarianceTailTheta (m := m) R t
              (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R))
            k))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand
          (centeredSampleCovarianceRowRankOneSum (P := P) A)
          (sampleCovarianceTailTheta (m := m) R t
            (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R))))
    (hR : 0 < R)
    (ht : 0 < t)
    (hCFC :
      forall k : Fin m, forall omega,
        bernsteinMatrixExp_le_quadratic_statement
          ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k omega)
          (sampleCovarianceTailTheta (m := m) R t
            (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R))
          (sampleCovarianceCenteredRankOneRadius R))
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P)
        (centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (bernsteinSecondMomentComparisonFamily P
          (centeredSampleCovarianceRowRankOneFamily (P := P) A)
          (sampleCovarianceTailTheta (m := m) R t
            (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R))
          (sampleCovarianceCenteredRankOneRadius R))
        (matrixVarianceProxy P
          (centeredSampleCovarianceRowRankOneFamily (P := P) A))
        (sampleCovarianceTailTheta (m := m) R t
          (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R))
        (sampleCovarianceCenteredRankOneRadius R))
    (hCenteredNeg :
      CenteredSelfAdjointRandomMatrixFamily P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A))
    (hIndepSANeg :
      IndependentSelfAdjointRandomMatrices P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A))
    (hIntXNeg :
      forall k : Fin m,
        IntegrableRandomMatrix P
          ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A) k))
    (hIntSqNeg :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (randomMatrixSquare
            ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A) k)))
    (hExpIntNeg :
      forall k : Fin m,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily
            (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
            (sampleCovarianceTailTheta (m := m) Rneg t
              (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) Rneg))
            k))
    (hTraceIntNeg :
      IntegrableRealRandomVariable P
        (traceExpIntegrand
          (centeredSampleCovarianceRowRankOneSumNeg (P := P) A)
          (sampleCovarianceTailTheta (m := m) Rneg t
            (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) Rneg))))
    (hBoundNeg :
      PointwiseOperatorNormBound
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
        (sampleCovarianceCenteredRankOneRadius Rneg))
    (hRNeg : 0 < Rneg)
    (hCFCNeg :
      forall k : Fin m, forall omega,
        bernsteinMatrixExp_le_quadratic_statement
          ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
            k omega)
          (sampleCovarianceTailTheta (m := m) Rneg t
            (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) Rneg))
          (sampleCovarianceCenteredRankOneRadius Rneg))
    (hTroppNeg :
      troppMasterTraceMGFFiniteFamily_statement
        (P := P)
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
        (bernsteinSecondMomentComparisonFamily P
          (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
          (sampleCovarianceTailTheta (m := m) Rneg t
            (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) Rneg))
          (sampleCovarianceCenteredRankOneRadius Rneg))
        (matrixVarianceProxy P
          (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A))
        (sampleCovarianceTailTheta (m := m) Rneg t
          (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) Rneg))
        (sampleCovarianceCenteredRankOneRadius Rneg)) :
    P (SelfAdjointOperatorNormTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t) <=
      sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n) R t
          (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R) +
        sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n) Rneg t
          (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) Rneg) := by
  have hSigma :
      0 < sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R :=
    sampleCovarianceCenteredRankOneVarianceProxyBound_pos hm hR
  have hSigmaNeg :
      0 < sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) Rneg :=
    sampleCovarianceCenteredRankOneVarianceProxyBound_pos hm hRNeg
  have hNorm :
      MatrixVarianceProxyNormBound P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R) :=
    MatrixVarianceProxyNormBound_centeredSampleCovarianceRowRankOneFamily_of_rowSqNorm_bound
      (P := P) A hMeas hLp hSq hR.le hIntSq
  have hRadiusNeg :
      0 <= sampleCovarianceCenteredRankOneRadius Rneg := by
    simpa [sampleCovarianceCenteredRankOneRadius] using show 0 <= 2 * Rneg by
      nlinarith
  have hNormNegRaw :
      MatrixVarianceProxyNormBound P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
        (pointwiseOperatorNormVarianceProxyNormRHS (I := Fin m)
          (sampleCovarianceCenteredRankOneRadius Rneg)) :=
    MatrixVarianceProxyNormBound_of_pointwiseOperatorNormBound
      (P := P)
      (A := centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
      (R := sampleCovarianceCenteredRankOneRadius Rneg)
      hIntSqNeg hBoundNeg hRadiusNeg
  have hNormNeg :
      MatrixVarianceProxyNormBound P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
        (sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) Rneg) := by
    simpa [sampleCovarianceCenteredRankOneVarianceProxyBound,
      pointwiseOperatorNormVarianceProxyNormRHS] using hNormNegRaw
  exact
    sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_explicit_variance_proxy
      (P := P) (A := A) (R := R) (Rneg := Rneg) (t := t)
      (sigmaSq := sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) R)
      (sigmaSqNeg :=
        sampleCovarianceCenteredRankOneVarianceProxyBound (m := m) Rneg)
      hm hMeas hLp hSq hIndep hIntSq hExpInt hTraceInt hSigma hR.le ht
      hNorm hCFC hTropp hCenteredNeg hIndepSANeg hIntXNeg hIntSqNeg
      hExpIntNeg hTraceIntNeg hBoundNeg hSigmaNeg hRNeg.le hNormNeg
      hCFCNeg hTroppNeg

abbrev matrixBernsteinTraceMGFToLaplaceContract_statement {Omega : Type*}
    [MeasurableSpace Omega] {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) (theta t R : Real) : Prop :=
  AEMeasurable
    (fun omega => ENNReal.ofReal (traceExpIntegrand (randomMatrixSum A) theta omega)) P ->
    (quadraticFormUpperTailEvent (randomMatrixSum A) t ⊆
      traceExpThresholdEvent (randomMatrixSum A) theta t) ->
      TraceMGFBernsteinVarianceProxyBoundLIntegral P (randomMatrixSum A)
        (matrixVarianceProxy P A) theta R ->
        P (quadraticFormUpperTailEvent (randomMatrixSum A) t) <=
          ENNReal.ofReal (Real.exp (-(theta * t))) *
            ENNReal.ofReal
              (traceMatrixExp
                (SMul.smul (bernsteinMGFCoeff theta R) (matrixVarianceProxy P A)))

/-- Typed contract for feeding the proved MB-S9 bounded trace-MGF result into the
Laplace/tail layer.

The proved theorem under primitives supplies the premise
`matrixBernsteinTraceMGFWithBernsteinCoeff_statement P A theta R`; this contract
keeps the remaining downstream gaps visible instead of hiding them:
1. AEMeasurability of the trace-exp integrand ENNReal lift,
2. The event-subset bridge `quadraticFormUpperTailEvent ⊆ traceExpThresholdEvent`,
3. The real-to-lintegral trace-MGF bridge from `TraceMGFBernsteinVarianceProxyBound`
   to `TraceMGFBernsteinVarianceProxyBoundLIntegral`.
-/
abbrev matrixBernsteinTraceMGFToLaplaceContract_under_primitives_statement
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega)
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega n n) (theta t R : Real) : Prop :=
  let Y := randomMatrixSum A
  let V := matrixVarianceProxy P A
  AEMeasurable (fun omega => ENNReal.ofReal (traceExpIntegrand Y theta omega)) P ->
    (quadraticFormUpperTailEvent Y t ⊆ traceExpThresholdEvent Y theta t) ->
      IntegrableRealRandomVariable P (traceExpIntegrand Y theta) ->
        (forall omega, 0 <= traceExpIntegrand Y theta omega) ->
          matrixBernsteinTraceMGFWithBernsteinCoeff_statement P A theta R ->
            P (quadraticFormUpperTailEvent Y t) <=
              ENNReal.ofReal (Real.exp (-(theta * t))) *
                ENNReal.ofReal
                  (traceMatrixExp (SMul.smul (bernsteinMGFCoeff theta R) V))

/-- Typed target for the spectral-radius reduction for self-adjoint matrices.

This records a future bridge between HighDimProb's deterministic L2 operator
norm wrapper and Mathlib's spectral radius. It is not a theorem. -/
abbrev operatorNorm_eq_spectralRadius_of_selfAdjointStatement {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) : Prop :=
  IsSelfAdjointMatrix A ->
    deterministicOperatorNorm A = (spectralRadius ℝ A).toReal

/-- Lightweight high-probability bound notation.

`HighProbabilityBound P event rhs` means that `P(event) <= rhs`.
This is a thin wrapper around measure comparison for readability. -/
def HighProbabilityBound {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) (event : Set Omega) (rhs : ENNReal) : Prop :=
  P event <= rhs

/-- Variant of `HighProbabilityBound` for events given as `Set Omega`. -/
abbrev highProbabilityBound {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) (event : Set Omega) (rhs : ENNReal) : Prop :=
  HighProbabilityBound P event rhs

/-- Typed target for a future matrix Hoeffding theorem. -/
abbrev matrixHoeffdingStatement {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) (R c t : Real) : Prop :=
  CenteredRandomSelfAdjointMatrices P A ->
    IndependentRandomMatrices P A ->
      PointwiseOperatorNormBound A R ->
        0 <= t ->
          upperTailProb P (operatorNorm (randomMatrixSum A)) t <=
            ENNReal.ofReal
              (2 * (n : Real) * Real.exp (-(c * t ^ 2 / ((Fintype.card I : Real) * R ^ 2))))

/-- Typed target for a future matrix Chernoff theorem for PSD summands. -/
abbrev matrixChernoffStatement {Omega : Type*} [MeasurableSpace Omega]
    {I : Type*} [Fintype I] {n : Nat} (P : Measure Omega)
    (A : I -> RandomMatrix Omega n n) (R c t : Real) : Prop :=
  (forall i, RandomPSDMatrix P (A i)) ->
    IndependentRandomMatrices P A ->
      PointwiseOperatorNormBound A R ->
        0 <= t ->
          upperTailProb P (operatorNorm (randomMatrixSum A)) t <=
            ENNReal.ofReal (2 * (n : Real) * Real.exp (-(c * t / R)))

/-- Typed target for future operator-norm covariance estimation from subGaussian isotropic rows. -/
abbrev covarianceEstimationStatement {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (P : Measure Omega) (A : RandomMatrix Omega m n)
    (K c t : Real) : Prop :=
  IsRandomMatrix P A ->
    SubGaussianRowsOrlicz P A K ->
      IsotropicRowsSecondMoment P A ->
        0 <= t ->
          upperTailProb P (operatorNorm (sampleCovarianceMinusIdentity A)) t <=
            ENNReal.ofReal (2 * Real.exp (-(c * t ^ 2)))

/-- Absolute quadratic-form deviation of the centered sample covariance. -/
def sampleCovarianceQuadraticFormDeviation {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (A : RandomMatrix Omega m n) (x : Fin n -> Real) :
    RealRandomVariable Omega :=
  fun omega => abs (matrixQuadraticForm (sampleCovarianceMinusIdentity A omega) x)

/-- Typed target for a future unit-sphere reduction of sample-covariance
operator-norm tails. This is a statement dependency, not a proved concentration
or covering theorem. -/
abbrev sampleCovarianceOperatorNormViaUnitSphereStatement {Omega : Type*}
    [MeasurableSpace Omega] {m n : Nat} (P : Measure Omega)
    (A : RandomMatrix Omega m n) (t bound : Real) : Prop :=
  0 <= bound ->
    (forall x : Fin n -> Real,
      IsUnitVector x ->
        upperTailProb P (sampleCovarianceQuadraticFormDeviation A x) t <=
          ENNReal.ofReal bound) ->
      upperTailProb P (operatorNorm (sampleCovarianceMinusIdentity A)) t <=
        ENNReal.ofReal bound

/-- Typed target for a generic sample-covariance operator-norm tail statement. -/
abbrev sampleCovarianceOperatorNormStatement {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat} (P : Measure Omega) (A : RandomMatrix Omega m n)
    (t bound : Real) : Prop :=
  0 <= bound ->
    upperTailProb P (operatorNorm (sampleCovariance A)) t <= ENNReal.ofReal bound

end

end HighDimProb
