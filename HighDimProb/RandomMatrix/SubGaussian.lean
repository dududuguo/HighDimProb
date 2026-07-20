import HighDimProb.RandomMatrix.TraceExp
import HighDimProb.RandomMatrix.VarianceProxy
import HighDimProb.RandomMatrix.Laplace

/-!
# Matrix sub-Gaussian random matrices

This module introduces the matrix sub-Gaussian moment-generating-function
predicate as a conditional matrix-order bound and connects it to the existing
coefficient-agnostic trace-exponential infrastructure.

The design decision, verified against the Bernstein trace-MGF pipeline, is to
state matrix sub-Gaussianity **directly** as the Loewner matrix-MGF bound

  `E[exp(θ X)] ⪯ exp((θ² / 2) V)`

for a variance-proxy matrix `V`. This is exactly the
shape consumed by the finite-family Tropp/Lieb assembly
(`troppMasterTraceMGFFiniteFamily_statement`) at the single-summand slot, so it
drops in without a spectral-localization bridge. It differs from the Bernstein
single-summand primitive
(`singleSummandMatrixMGFVarianceProxy_statement`) only in the coefficient:
`θ² / 2` (sub-Gaussian, all `θ`) instead of `bernsteinMGFCoeff θ R`
(bounded, `|θ| R < 3`).

The predicate itself does not bundle centeredness, self-adjointness, positive
semidefiniteness, measurability, integrability, or probability-measure
assumptions. Those facts remain explicit at the downstream consumers.
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators MatrixOrder

noncomputable section

/-- Conditional matrix-order matrix sub-Gaussian moment-generating-function
predicate.

`MatrixSubGaussianMGF P X V` states that the entrywise matrix
moment-generating function of `X` is Loewner-dominated by
`exp((θ² / 2) V)` for every real `θ`.

This predicate is only the conditional matrix-order MGF bound. It does not
bundle centeredness, self-adjointness, positive semidefiniteness,
measurability, integrability, or probability-measure assumptions.

Formula reference: the matrix sub-Gaussian MGF condition
`E[exp(θ X)] ⪯ exp(θ² V / 2)` is the matrix analogue of the scalar
variance-proxy MGF bound; see
https://en.wikipedia.org/wiki/Sub-Gaussian_distribution -/
def MatrixSubGaussianMGF {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (P : Measure Omega) (X : RandomMatrix Omega n n)
    (V : Matrix (Fin n) (Fin n) Real) : Prop :=
  ∀ theta : Real,
    MatrixLE
      (matrixExpect P (fun omega => matrixExp (theta • X omega)))
      (matrixExp ((theta ^ 2 / 2) • V))

/-- Negation preserves the matrix sub-Gaussian MGF bound with the same
variance proxy, because the proxy coefficient `θ² / 2` is even in `θ`. -/
theorem MatrixSubGaussianMGF.neg {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} {P : Measure Omega} {X : RandomMatrix Omega n n}
    {V : Matrix (Fin n) (Fin n) Real}
    (h : MatrixSubGaussianMGF P X V) :
    MatrixSubGaussianMGF P (-X) V := by
  intro theta
  have hkey := h (-theta)
  have hfam :
      (fun omega => matrixExp (theta • (-X) omega)) =
        (fun omega => matrixExp ((-theta) • X omega)) := by
    funext omega
    congr 1
    simp [Pi.neg_apply, smul_neg, neg_smul]
  have hsq : (theta ^ 2 / 2) • V = ((-theta) ^ 2 / 2) • V := by
    congr 1
    ring
  rw [hfam, hsq]
  exact hkey

/-- `bernsteinMGFCoeff θ 0 = θ² / 2`: the bounded Bernstein MGF coefficient at
zero radius is exactly the sub-Gaussian coefficient. This is the algebraic
identity that lets the sub-Gaussian route reuse the bounded finite-family
Tropp/Lieb assembly as its `R = 0` specialization. -/
private theorem bernsteinMGFCoeff_zero (theta : Real) :
    bernsteinMGFCoeff theta 0 = theta ^ 2 / 2 := by
  simp [bernsteinMGFCoeff]

/-- Finite-family sub-Gaussian trace-MGF variance-proxy bound under an explicit
Tropp primitive.

From per-summand matrix sub-Gaussianity `E[exp(θ Xᵢ)] ⪯ exp((θ²/2) Vᵢ)`, the
random finite sum satisfies the sub-Gaussian trace-MGF bound
`E tr exp(θ ∑ Xᵢ) ≤ tr exp((θ²/2) ∑ Vᵢ)` for **every** real `θ`.

This reuses the bounded Bernstein finite-family assembly
`traceMGFBernsteinVarianceProxyBound_of_troppMasterTraceMGFFiniteFamily` at
radius `R = 0`, where `bernsteinMGFCoeff θ 0 = θ²/2` and the range condition
`|θ| · R < 3` holds for all `θ`. The per-summand comparison matrices are
`Kᵢ = (θ²/2) Vᵢ`, so the sub-Gaussian MGF bound matches the abstract
`hMGF` slot exactly, with no log-order bridge.

The finite-family comparison and the matrix-exponential integrability of the
summands are explicit hypotheses, since sub-Gaussian summands are unbounded:

* `hTropp`: the coefficient-agnostic finite-family comparison primitive;
* `hExpInt` / `hTraceInt`: matrix-exponential and trace-exponential
  integrability of the unbounded summands.
-/
theorem traceMGFVarianceProxyBound_of_matrixSubGaussian_under_troppPrimitive
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {I : Type*} [Fintype I] {n : Nat}
    (X : I -> RandomMatrix Omega n n)
    (V : I -> Matrix (Fin n) (Fin n) Real) (theta : Real)
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement (P := P) X
        (fun i => (theta ^ 2 / 2) • V i) (Finset.univ.sum V) theta 0)
    (hRand : forall i, IsRandomMatrix P (X i))
    (hSA : forall i, RandomSelfAdjointMatrix P (X i))
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hExpInt :
      forall i,
        IntegrableRandomMatrix P
          (fun omega => matrixExp (theta • X i omega)))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum X) theta))
    (hVSA : forall i, IsSelfAdjointMatrix (V i))
    (hSG : forall i, MatrixSubGaussianMGF P (X i) (V i)) :
    TraceMGFVarianceProxyBound P (randomMatrixSum X)
      (Finset.univ.sum V) theta := by
  have hcoeff : bernsteinMGFCoeff theta 0 = theta ^ 2 / 2 :=
    bernsteinMGFCoeff_zero theta
  have hKSA :
      forall i, IsSelfAdjointMatrix ((theta ^ 2 / 2) • V i) := by
    intro i
    exact isSelfAdjointMatrix_smul (theta ^ 2 / 2) (hVSA i)
  have hVSAsum : IsSelfAdjointMatrix (Finset.univ.sum V) :=
    isSelfAdjointMatrix_sum hVSA
  have hRange : |theta| * (0 : Real) < 3 := by
    rw [mul_zero]; norm_num
  have hMGF :
      forall i,
        MatrixLE
          (matrixExpect P
            (fun omega => matrixExp (theta • X i omega)))
          (matrixExp ((theta ^ 2 / 2) • V i)) :=
    fun i => hSG i theta
  have hNorm :
      Finset.univ.sum (fun i => (theta ^ 2 / 2) • V i) =
        SMul.smul (bernsteinMGFCoeff theta 0) (Finset.univ.sum V) := by
    rw [hcoeff]
    exact (Finset.smul_sum).symm
  have hResult :=
    traceMGFBernsteinVarianceProxyBound_of_troppMasterTraceMGFFiniteFamily
      X (fun i => (theta ^ 2 / 2) • V i) (Finset.univ.sum V) theta 0
      hTropp hRand hSA hIndep hExpInt hTraceInt hKSA hVSAsum le_rfl hRange
      hMGF hNorm
  unfold TraceMGFBernsteinVarianceProxyBound at hResult
  rw [hcoeff] at hResult
  exact hResult

/-- LIntegral form of the sub-Gaussian trace-MGF variance-proxy bound.

This is the nonnegative-integral bridge required by the Markov/Laplace tail
argument, mirroring
`traceMGFBernsteinVarianceProxyBoundLIntegral_of_traceMGFBernsteinVarianceProxyBound`
for the sub-Gaussian coefficient `θ² / 2`. -/
private theorem traceMGFVarianceProxyBoundLIntegral_of_traceMGFVarianceProxyBound
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : RandomMatrix Omega n n) (V : Matrix (Fin n) (Fin n) Real)
    (theta : Real)
    (hY : RandomSelfAdjointMatrix P Y)
    (hInt : IntegrableRealRandomVariable P (traceExpIntegrand Y theta))
    (hReal : TraceMGFVarianceProxyBound P Y V theta) :
    TraceMGFVarianceProxyBoundLIntegral P Y V theta := by
  have hRaw :
      traceExpMoment P Y theta <=
        traceMatrixExp ((theta ^ 2 / 2) • V) := by
    simpa [TraceMGFVarianceProxyBound, TraceMGFBound] using hReal
  unfold TraceMGFVarianceProxyBoundLIntegral TraceMGFBoundLIntegral
  rw [traceExpMomentLIntegral_eq_ofReal_traceExpMoment
    Y theta hInt (traceExpIntegrand_nonneg_of_randomSelfAdjoint theta hY)]
  exact ENNReal.ofReal_le_ofReal hRaw

/-- Canonical unconstrained sub-Gaussian exponential-tail optimizing choice.

Unlike the Bernstein choice, no range constraint `|θ| R < 3` is imposed: the
sub-Gaussian MGF bound holds for all `θ`, so `θ = t / v` is always admissible. -/
private def subGaussianThetaChoice (t v : Real) : Real := t / v

/-- The sub-Gaussian exponent simplification.

At the optimizing choice `θ = t / v` (`v > 0`), the Laplace exponent
`-θ t + (θ² / 2) v` collapses to the sharp sub-Gaussian exponent
`-t² / (2 v)`. This is the sub-Gaussian analogue of
`bernsteinThetaChoice_exponent_eq`, and is strictly simpler because there is no
denominator to clear. -/
private theorem subGaussianThetaChoice_exponent_eq {t v : Real} (hv : 0 < v) :
    -(subGaussianThetaChoice t v * t) +
        subGaussianThetaChoice t v ^ 2 / 2 * v =
      -(t ^ 2 / (2 * v)) := by
  unfold subGaussianThetaChoice
  field_simp
  ring

/-- The sub-Gaussian optimizing choice is nonnegative for nonnegative deviation
and nonnegative variance proxy. -/
private theorem subGaussianThetaChoice_nonneg {t v : Real} (ht : 0 <= t) (hv : 0 <= v) :
    0 <= subGaussianThetaChoice t v :=
  div_nonneg ht hv

/-- Ambient-dimension trace-exponential bound for the sub-Gaussian
variance-proxy coefficient.

Applying the deterministic spectral dimension factor at the sub-Gaussian
coefficient `c = θ² / 2` gives
`tr exp((θ²/2) V) ≤ (n+1) · exp((θ²/2) σ²)` whenever `λ_max(V) ≤ σ²`. This
is the sub-Gaussian analogue of
`traceMatrixExp_bernsteinMGFCoeff_matrixVarianceProxy_le_card_exp`, obtained by
reusing `traceMatrixExp_smul_le_card_exp_of_lambdaMaxOrdered_le` with the
nonnegative coefficient `θ² / 2`. -/
private theorem traceMatrixExp_subGaussianVarianceProxy_le_card_exp
    {n : Nat} {V : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (theta sigmaSq : Real)
    (hV : IsSelfAdjointMatrix V)
    (hSpec : lambdaMaxOrdered V hV <= sigmaSq) :
    traceMatrixExp ((theta ^ 2 / 2) • V) <=
      (n + 1 : Real) * Real.exp ((theta ^ 2 / 2) * sigmaSq) :=
  traceMatrixExp_smul_le_card_exp_of_lambdaMaxOrdered_le
    (theta ^ 2 / 2) sigmaSq (by positivity) hV hSpec

/-- Sub-Gaussian quadratic-form upper-tail bound under an explicit finite-family
Tropp primitive.

For an independent family of matrix sub-Gaussian summands with variance
proxies `Vᵢ`, whose aggregate proxy `∑ Vᵢ` has largest ordered eigenvalue at
most `σ²`, the quadratic-form upper tail of the random matrix sum obeys the
sharp sub-Gaussian upper-tail bound

  `P(⟨u, S u⟩ ≥ t) ≤ (n + 1) · exp(-t² / (2 σ²))`.

The result is conditional on the finite-family comparison primitive and on
matrix/trace-exponential integrability at the optimizing choice `θ = t / σ²`.
It composes the sub-Gaussian trace-MGF closure, its LIntegral bridge, the
coefficient-agnostic Laplace reduction, the ambient-dimension trace factor,
and the sub-Gaussian exponent identity.

The finite-family comparison and matrix/trace-exponential integrability
premises are required only at `θ = t / sigmaSq`. The
trace-exp measurability premise is derived from trace-exp integrability, and
the sum self-adjointness premise is derived from the summand premises. -/
theorem subGaussian_quadraticFormUpperTail_under_troppPrimitive
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {I : Type*} [Fintype I] {n : Nat}
    (X : I -> RandomMatrix Omega (n + 1) (n + 1))
    (V : I -> Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (sigmaSq t : Real)
    (hsig : 0 < sigmaSq) (ht : 0 <= t)
    (hVSA : forall i, IsSelfAdjointMatrix (V i))
    (hSpec :
      lambdaMaxOrdered (Finset.univ.sum V) (isSelfAdjointMatrix_sum hVSA) <=
        sigmaSq)
    (hRand : forall i, IsRandomMatrix P (X i))
    (hSA : forall i, RandomSelfAdjointMatrix P (X i))
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hSG : forall i, MatrixSubGaussianMGF P (X i) (V i))
    (hTropp :
      troppMasterTraceMGFFiniteFamily_statement (P := P) X
        (fun i => ((t / sigmaSq) ^ 2 / 2) • V i)
        (Finset.univ.sum V) (t / sigmaSq) 0)
    (hExpInt :
      forall i,
        IntegrableRandomMatrix P
          (fun omega =>
            matrixExp ((t / sigmaSq) • X i omega)))
    (hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum X) (t / sigmaSq))) :
    P (quadraticFormUpperTailEvent (randomMatrixSum X) t) <=
      ENNReal.ofReal ((n + 1 : Real) * Real.exp (-(t ^ 2 / (2 * sigmaSq)))) := by
  set theta := subGaussianThetaChoice t sigmaSq with htheta_def
  have htheta : 0 <= theta :=
    subGaussianThetaChoice_nonneg ht hsig.le
  have hSAsum : RandomSelfAdjointMatrix P (randomMatrixSum X) :=
    randomSelfAdjointMatrix_sum hSA
  have hMeas :
      AEMeasurable
        (fun omega =>
          ENNReal.ofReal
            (traceExpIntegrand (randomMatrixSum X) theta omega)) P :=
    hTraceInt.aemeasurable.ennreal_ofReal
  have hVsumSA : IsSelfAdjointMatrix (Finset.univ.sum V) :=
    isSelfAdjointMatrix_sum hVSA
  have hTM :
      TraceMGFVarianceProxyBound P (randomMatrixSum X)
        (Finset.univ.sum V) theta :=
    traceMGFVarianceProxyBound_of_matrixSubGaussian_under_troppPrimitive
      X V theta hTropp hRand hSA hIndep hExpInt hTraceInt hVSA hSG
  have hTML :
      TraceMGFVarianceProxyBoundLIntegral P (randomMatrixSum X)
        (Finset.univ.sum V) theta :=
    traceMGFVarianceProxyBoundLIntegral_of_traceMGFVarianceProxyBound
      (randomMatrixSum X) (Finset.univ.sum V) theta hSAsum hTraceInt hTM
  have hTML' :
      traceExpMomentLIntegral P (randomMatrixSum X) theta <=
        ENNReal.ofReal
          (traceMatrixExp ((theta ^ 2 / 2) • Finset.univ.sum V)) := hTML
  have hLap :
      P (quadraticFormUpperTailEvent (randomMatrixSum X) t) <=
        matrixLaplaceRHSLIntegral P (randomMatrixSum X) theta t :=
    matrixLaplaceTransformLIntegral_of_randomSelfAdjoint
      (randomMatrixSum X) theta t hMeas hSAsum htheta
  have hDim :
      traceMatrixExp ((theta ^ 2 / 2) • Finset.univ.sum V) <=
        (n + 1 : Real) * Real.exp (theta ^ 2 / 2 * sigmaSq) :=
    traceMatrixExp_subGaussianVarianceProxy_le_card_exp
      (V := Finset.univ.sum V) theta sigmaSq hVsumSA hSpec
  have hexp :
      -(theta * t) + theta ^ 2 / 2 * sigmaSq =
        -(t ^ 2 / (2 * sigmaSq)) := by
    have h := subGaussianThetaChoice_exponent_eq (t := t) (v := sigmaSq) hsig
    rw [htheta_def]
    simpa using h
  have hscalar :
      Real.exp (-(theta * t)) *
          ((n + 1 : Real) * Real.exp (theta ^ 2 / 2 * sigmaSq)) =
        (n + 1 : Real) * Real.exp (-(t ^ 2 / (2 * sigmaSq))) := by
    calc
      Real.exp (-(theta * t)) *
            ((n + 1 : Real) * Real.exp (theta ^ 2 / 2 * sigmaSq))
          = (n + 1 : Real) *
              (Real.exp (-(theta * t)) *
                Real.exp (theta ^ 2 / 2 * sigmaSq)) := by ring
      _ = (n + 1 : Real) *
              Real.exp (-(theta * t) + theta ^ 2 / 2 * sigmaSq) := by
            rw [Real.exp_add]
      _ = (n + 1 : Real) * Real.exp (-(t ^ 2 / (2 * sigmaSq))) := by
            rw [hexp]
  calc
    P (quadraticFormUpperTailEvent (randomMatrixSum X) t)
        <= matrixLaplaceRHSLIntegral P (randomMatrixSum X) theta t := hLap
    _ = ENNReal.ofReal (Real.exp (-(theta * t))) *
          traceExpMomentLIntegral P (randomMatrixSum X) theta := rfl
    _ <= ENNReal.ofReal (Real.exp (-(theta * t))) *
          ENNReal.ofReal
            (traceMatrixExp ((theta ^ 2 / 2) • Finset.univ.sum V)) :=
          mul_le_mul' le_rfl hTML'
    _ <= ENNReal.ofReal (Real.exp (-(theta * t))) *
          ENNReal.ofReal
            ((n + 1 : Real) * Real.exp (theta ^ 2 / 2 * sigmaSq)) :=
          mul_le_mul' le_rfl (ENNReal.ofReal_le_ofReal hDim)
    _ = ENNReal.ofReal
          (Real.exp (-(theta * t)) *
            ((n + 1 : Real) * Real.exp (theta ^ 2 / 2 * sigmaSq))) :=
          (ENNReal.ofReal_mul (Real.exp_nonneg _)).symm
    _ = ENNReal.ofReal
          ((n + 1 : Real) * Real.exp (-(t ^ 2 / (2 * sigmaSq)))) := by
          rw [hscalar]

end

end HighDimProb
