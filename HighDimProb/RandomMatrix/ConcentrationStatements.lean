import HighDimProb.RandomMatrix.Assumptions
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
        IntegrableRandomMatrix P
          (fun omega => matrixExp (SMul.smul theta (A i omega))))
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
          (matrixExpect P
            (fun omega => matrixExp (SMul.smul theta (A i omega))))
          (matrixExp (K i)))
    (hNorm :
      Finset.univ.sum (fun i : I => K i) =
        SMul.smul (bernsteinMGFCoeff theta R) (matrixVarianceProxy P A)) :
    matrixBernsteinTraceMGFWithBernsteinCoeff_statement P A theta R :=
  traceMGFBernsteinVarianceProxyBound_of_troppMasterTraceMGFFiniteFamily
    A K (matrixVarianceProxy P A) theta R hTropp hRand hSA hIndep hExpInt
    hTraceInt hKSA hVSA hR hRange hMGF hNorm

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
        IntegrableRandomMatrix P
          (fun omega => matrixExp (SMul.smul theta (A i omega))))
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
        (P := P) A
        (fun i => SMul.smul (bernsteinMGFCoeff theta R)
          (matrixSecondMoment P (A i)))
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
          (SMul.smul (bernsteinMGFCoeff theta R)
            (matrixSecondMoment P (A i))) := by
    intro i
    exact isSelfAdjointMatrix_smul (bernsteinMGFCoeff theta R)
      (isSelfAdjointMatrix_matrixSecondMoment (hSA i))
  have hVSA : IsSelfAdjointMatrix (matrixVarianceProxy P A) :=
    isSelfAdjointMatrix_matrixVarianceProxy P hSA
  have hMGF :
      forall i,
        MatrixLE
          (matrixExpect P
            (fun omega => matrixExp (SMul.smul theta (A i omega))))
          (matrixExp
            (SMul.smul (bernsteinMGFCoeff theta R)
              (matrixSecondMoment P (A i)))) := by
    intro i
    exact
      singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic
        (A i) (matrixSecondMoment P (A i)) theta R (hCFC i)
        (hRand i) (hSA i) (hIntX i) (hIntSq i) (hExpInt i)
        (hMeanZero i) (hBound i) hR hRange
        (isSelfAdjointMatrix_matrixSecondMoment (hSA i))
        (isPSD_matrixSecondMoment_of_selfAdjoint (hSA i) (hIntSq i))
        (matrixLE_refl (matrixSecondMoment P (A i)))
  have hNorm :
      Finset.univ.sum
          (fun i : I =>
            SMul.smul (bernsteinMGFCoeff theta R)
              (matrixSecondMoment P (A i))) =
        SMul.smul (bernsteinMGFCoeff theta R) (matrixVarianceProxy P A) := by
    simpa [matrixVarianceProxy] using
      (Finset.smul_sum (s := Finset.univ)
        (f := fun i : I => matrixSecondMoment P (A i))
        (r := bernsteinMGFCoeff theta R)).symm
  exact
    matrixBernsteinTraceMGFWithBernsteinCoeff_of_troppMasterTraceMGFFiniteFamily
      A
      (fun i => SMul.smul (bernsteinMGFCoeff theta R)
        (matrixSecondMoment P (A i)))
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
        IntegrableRandomMatrix P
          (fun omega => matrixExp (SMul.smul theta (A i omega))))
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
        (P := P) A
        (fun i => SMul.smul (bernsteinMGFCoeff theta R)
          (matrixSecondMoment P (A i)))
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
        IntegrableRandomMatrix P
          (fun omega => matrixExp (SMul.smul theta (A i omega))))
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
        (P := P) A
        (fun i => SMul.smul (bernsteinMGFCoeff theta R)
          (matrixSecondMoment P (A i)))
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
        IntegrableRandomMatrix P
          (fun omega => matrixExp (SMul.smul theta (A i omega))))
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
        (P := P) A
        (fun i => SMul.smul (bernsteinMGFCoeff theta R)
          (matrixSecondMoment P (A i)))
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
      traceMGFBernsteinVarianceProxyBoundLIntegral_of_real_statement P Y V theta R ->
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
