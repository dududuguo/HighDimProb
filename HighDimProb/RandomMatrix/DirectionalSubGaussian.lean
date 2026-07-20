import HighDimProb.RandomMatrix.Sums
import HighDimProb.RandomMatrix.MatrixOrder
import HighDimProb.RandomMatrix.UnitSphere
import HighDimProb.Expectation
import HighDimProb.Concentration.MGF
import HighDimProb.Concentration.SubGaussianSums

/-!
# Directional sub-Gaussian self-adjoint random matrices

This module introduces a **directional** sub-Gaussian predicate for self-adjoint
random matrices, phrased through the scalar sub-Gaussian moment-generating
function of the centered quadratic form `⟨u, X u⟩` for every fixed unit
direction `u`.

This predicate is deliberately kept separate from the Loewner matrix-MGF
predicate `MatrixSubGaussianMGF`
(`HighDimProb/RandomMatrix/SubGaussian.lean`). Without additional hypotheses,
the two formulations should not be treated as a direct implication in either
direction. In particular, directional control does not supply the Loewner
matrix-MGF bound or its `n`-prefactor trace route. The latter stays with
`MatrixSubGaussianMGF` and the Tropp primitive. The separate module
`HighDimProb.RandomMatrix.DirectionalOperatorNorm` supplies an ε-net route with
an explicit finite-net cardinality factor; constructing a net and deriving a
dimension-only cardinality bound remain separate steps.

The scale arithmetic and the exponential tail constants come verbatim from the
scalar `CenteredSubGaussianMGF` layer: independent finite sums use the proxy
`sqrt (∑ᵢ Kᵢ²)`, and a fixed-direction tail is `exp(-(t² / (4 · K²)))`.

Formula references:
* Sub-Gaussian distribution: https://en.wikipedia.org/wiki/Sub-Gaussian_distribution
* Quadratic form: https://en.wikipedia.org/wiki/Quadratic_form
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators

noncomputable section

/-- Centered scalar quadratic form `ω ↦ ⟨u, X(ω) u⟩ - E⟨u, X u⟩` in a fixed
direction `u`.

This is the reusable scalar projection carrying the directional sub-Gaussian
information. The centering uses the scalar expectation `expect` (an integral),
not `matrixExpect`. -/
def centeredMatrixQuadraticForm {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : Measure Omega) (X : RandomMatrix Omega n n) (u : Fin n → Real) :
    RealRandomVariable Omega :=
  fun omega =>
    matrixQuadraticForm (X omega) u -
      expect P (fun omega' => matrixQuadraticForm (X omega') u)

@[simp]
theorem centeredMatrixQuadraticForm_apply {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (P : Measure Omega) (X : RandomMatrix Omega n n) (u : Fin n → Real)
    (omega : Omega) :
    centeredMatrixQuadraticForm P X u omega =
      matrixQuadraticForm (X omega) u -
        expect P (fun omega' => matrixQuadraticForm (X omega') u) :=
  rfl

/-- The centered directional quadratic form of an entrywise-measurable random
matrix is a real random variable. -/
theorem isRealRandomVariable_centeredMatrixQuadraticForm {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomMatrix Omega n n} (hX : IsRandomMatrix P X) (u : Fin n → Real) :
    IsRealRandomVariable P (centeredMatrixQuadraticForm P X u) := by
  dsimp [IsRealRandomVariable, IsRandomVariable, centeredMatrixQuadraticForm,
    matrixQuadraticForm]
  refine Measurable.sub ?_ measurable_const
  exact Finset.measurable_sum _ fun i _ =>
    Finset.measurable_sum _ fun j _ => ((hX i j).const_mul (u i)).mul_const (u j)

/-- Scalar-multiplication linearity of the centered directional quadratic form. -/
theorem centeredMatrixQuadraticForm_smul {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} (c : Real) (X : RandomMatrix Omega n n)
    (u : Fin n → Real) :
    centeredMatrixQuadraticForm P (scaledRandomMatrix c X) u =
      fun omega => c * centeredMatrixQuadraticForm P X u omega := by
  have hpt : ∀ w : Omega,
      matrixQuadraticForm (scaledRandomMatrix c X w) u =
        c * matrixQuadraticForm (X w) u := by
    intro w
    rw [scaledRandomMatrix_apply]
    exact matrixQuadraticForm_smul c (X w) u
  funext omega
  simp only [centeredMatrixQuadraticForm, hpt]
  rw [mul_sub]
  congr 1
  simp only [expect]
  rw [integral_const_mul]

/-- Negation acts by negation on the centered directional quadratic form. -/
theorem centeredMatrixQuadraticForm_neg {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} (X : RandomMatrix Omega n n) (u : Fin n → Real) :
    centeredMatrixQuadraticForm P (negRandomMatrix X) u =
      fun omega => -(centeredMatrixQuadraticForm P X u omega) := by
  have hneg : ∀ w : Omega,
      matrixQuadraticForm (-(X w)) u = -(matrixQuadraticForm (X w) u) := by
    intro w
    rw [← neg_one_smul Real (X w), matrixQuadraticForm_smul, neg_one_mul]
  funext omega
  simp only [centeredMatrixQuadraticForm, negRandomMatrix_apply]
  rw [hneg omega]
  have hexp :
      expect P (fun w => matrixQuadraticForm (-(X w)) u) =
        -(expect P (fun w => matrixQuadraticForm (X w) u)) := by
    simp only [expect]
    rw [← integral_neg]
    congr 1
    funext w
    exact hneg w
  rw [hexp]
  ring

/-- Finite-sum decomposition of the centered directional quadratic form.

Under per-summand integrability of the fixed-direction quadratic forms, the
centered directional quadratic form of a random-matrix sum equals the pointwise
sum of the per-summand centered directional quadratic forms. This is the sum
rule consumed by the independent finite-sum closure. -/
theorem centeredMatrixQuadraticForm_randomMatrixSum {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {I : Type*} [Fintype I] {n : Nat}
    (X : I → RandomMatrix Omega n n) (u : Fin n → Real)
    (hInt : ∀ i, Integrable (fun w => matrixQuadraticForm (X i w) u) P) :
    centeredMatrixQuadraticForm P (randomMatrixSum X) u =
      fun omega => ∑ i : I, centeredMatrixQuadraticForm P (X i) u omega := by
  funext omega
  simp only [centeredMatrixQuadraticForm, randomMatrixSum_apply,
    matrixQuadraticForm_sum]
  rw [Finset.sum_sub_distrib]
  congr 1
  simp only [expect]
  exact integral_finset_sum Finset.univ (fun i _ => hInt i)

/-- Quadratic form of the entrywise matrix mean equals the mean of the quadratic
form, under entrywise integrability. -/
private theorem matrixQuadraticForm_matrixExpect_eq_expect {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomMatrix Omega n n} (hInt : IntegrableRandomMatrix P X)
    (v : Fin n -> Real) :
    matrixQuadraticForm (matrixExpect P X) v =
      expect P (fun omega => matrixQuadraticForm (X omega) v) := by
  have hInt_ij : ∀ i j, Integrable (fun omega => v i * X omega i j * v j) P := by
    intro i j
    exact ((hInt i j).const_mul (v i)).mul_const (v j)
  have hInt_i :
      ∀ i, Integrable (fun omega => ∑ j : Fin n, v i * X omega i j * v j) P := by
    intro i
    exact integrable_finset_sum _ (fun j _ => hInt_ij i j)
  simp only [matrixQuadraticForm, expect]
  rw [integral_finset_sum _ (fun i _ => hInt_i i)]
  refine Finset.sum_congr rfl (fun i _ => ?_)
  rw [integral_finset_sum _ (fun j _ => hInt_ij i j)]
  refine Finset.sum_congr rfl (fun j _ => ?_)
  rw [matrixExpect_apply, expect, integral_mul_const, integral_const_mul]
  rfl

/-- The fixed-direction quadratic form of the centered random matrix `X - EX`
equals the centered scalar quadratic form `centeredMatrixQuadraticForm`, under
entrywise integrability of `X`.

This is the public bridge from entrywise matrix centering to the scalar
centering convention used by the directional sub-Gaussian predicate. -/
theorem matrixQuadraticForm_centeredRandomMatrix {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomMatrix Omega n n} (hInt : IntegrableRandomMatrix P X)
    (v : Fin n -> Real) (omega : Omega) :
    matrixQuadraticForm ((centeredRandomMatrix P X) omega) v =
      centeredMatrixQuadraticForm P X v omega := by
  have hcRM : (centeredRandomMatrix P X) omega = X omega - matrixExpect P X := by
    funext i j
    simp only [centeredRandomMatrix_apply, Matrix.sub_apply]
  rw [hcRM, matrixQuadraticForm_sub, centeredMatrixQuadraticForm_apply,
    matrixQuadraticForm_matrixExpect_eq_expect hInt]

/-- Directional sub-Gaussian self-adjoint random matrix.

`DirectionallySubGaussianSelfAdjointMatrix P X K` bundles positivity of the
scale `K`, entrywise measurability, pointwise self-adjointness, and, for every
fixed unit direction `u`, the scalar sub-Gaussian MGF bound
`CenteredSubGaussianMGF P (centeredMatrixQuadraticForm P X u) K` on the centered
quadratic form `⟨u, X u⟩`.

This is strictly the directional (fixed-direction) statement. It does not
bundle or by itself establish the Loewner matrix-MGF predicate
`MatrixSubGaussianMGF`, so the `n`-prefactor trace-MGF and corresponding
`2n` operator-norm route are unavailable. A covering-number operator-norm
bound remains a separate ε-net consequence.

Formula reference: sub-Gaussian distribution,
https://en.wikipedia.org/wiki/Sub-Gaussian_distribution -/
def DirectionallySubGaussianSelfAdjointMatrix {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {n : Nat} (X : RandomMatrix Omega n n) (K : Real) : Prop :=
  0 < K ∧
    IsRandomMatrix P X ∧
      RandomSelfAdjointMatrix P X ∧
        ∀ u : Fin n → Real, IsUnitVector u →
          CenteredSubGaussianMGF P (centeredMatrixQuadraticForm P X u) K

/-- The directional sub-Gaussian scale is positive. -/
theorem DirectionallySubGaussianSelfAdjointMatrix.K_pos {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomMatrix Omega n n} {K : Real}
    (h : DirectionallySubGaussianSelfAdjointMatrix P X K) : 0 < K :=
  h.1

/-- A directional sub-Gaussian matrix is entrywise measurable. -/
theorem DirectionallySubGaussianSelfAdjointMatrix.isRandomMatrix {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomMatrix Omega n n} {K : Real}
    (h : DirectionallySubGaussianSelfAdjointMatrix P X K) : IsRandomMatrix P X :=
  h.2.1

/-- A directional sub-Gaussian matrix is pointwise self-adjoint. -/
theorem DirectionallySubGaussianSelfAdjointMatrix.randomSelfAdjoint {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomMatrix Omega n n} {K : Real}
    (h : DirectionallySubGaussianSelfAdjointMatrix P X K) :
    RandomSelfAdjointMatrix P X :=
  h.2.2.1

/-- Directional elimination: the fixed-direction centered quadratic form is
scalar sub-Gaussian with the same scale `K`. -/
theorem DirectionallySubGaussianSelfAdjointMatrix.centeredSubGaussianMGF
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomMatrix Omega n n} {K : Real}
    (h : DirectionallySubGaussianSelfAdjointMatrix P X K) {u : Fin n → Real}
    (hu : IsUnitVector u) :
    CenteredSubGaussianMGF P (centeredMatrixQuadraticForm P X u) K :=
  h.2.2.2 u hu

/-- The centered quadratic form in a fixed unit direction is integrable. -/
theorem DirectionallySubGaussianSelfAdjointMatrix.integrable_centeredMatrixQuadraticForm
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomMatrix Omega n n} {K : Real}
    (h : DirectionallySubGaussianSelfAdjointMatrix P X K) {u : Fin n → Real}
    (hu : IsUnitVector u) :
    Integrable (centeredMatrixQuadraticForm P X u) P :=
  (h.centeredSubGaussianMGF hu).2.integrable

/-- The uncentered quadratic form in a fixed unit direction is integrable.

This is the expectation-linearity input used by finite sums and later
centered-matrix consumers. -/
theorem DirectionallySubGaussianSelfAdjointMatrix.integrable_matrixQuadraticForm
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {n : Nat}
    {X : RandomMatrix Omega n n} {K : Real}
    (h : DirectionallySubGaussianSelfAdjointMatrix P X K) {u : Fin n → Real}
    (hu : IsUnitVector u) :
    Integrable (fun omega => matrixQuadraticForm (X omega) u) P := by
  have hcentered := h.integrable_centeredMatrixQuadraticForm hu
  have heq :
      (fun omega => matrixQuadraticForm (X omega) u) =
        fun omega =>
          centeredMatrixQuadraticForm P X u omega +
            expect P (fun omega' => matrixQuadraticForm (X omega') u) := by
    funext omega
    rw [centeredMatrixQuadraticForm_apply]
    ring
  rw [heq]
  exact hcentered.add (integrable_const _)

/-- The centered quadratic form has zero expectation under a probability measure. -/
theorem DirectionallySubGaussianSelfAdjointMatrix.expect_centeredMatrixQuadraticForm_eq_zero
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {n : Nat}
    {X : RandomMatrix Omega n n} {K : Real}
    (h : DirectionallySubGaussianSelfAdjointMatrix P X K) {u : Fin n → Real}
    (hu : IsUnitVector u) :
    expect P (centeredMatrixQuadraticForm P X u) = 0 := by
  have hInt := h.integrable_matrixQuadraticForm hu
  simp only [centeredMatrixQuadraticForm, expect]
  rw [integral_sub hInt (integrable_const _), integral_const]
  rw [measureReal_def, measure_univ, ENNReal.toReal_one, one_smul, sub_self]

/-- Independent finite-sum closure of the directional sub-Gaussian predicate.

For an independent family of directional sub-Gaussian self-adjoint random
matrices with scales `Kᵢ`, the pointwise sum is directional sub-Gaussian with
proxy scale `sqrt (∑ᵢ Kᵢ²)`.

The directional independence of the centered scalar quadratic forms is obtained
by measurable composition of the matrix independence `hIndep`; it is not assumed
separately. Per-summand integrability of the fixed-direction quadratic forms is
derived from the sub-Gaussian hypothesis, not added as a premise. The measurable
and self-adjoint closures reuse `isRandomMatrix_sum` and
`randomSelfAdjointMatrix_sum`.

Formula reference: independent sub-Gaussian sums add variance proxies, i.e. the
scale composes as `sqrt (∑ᵢ Kᵢ²)`; see
https://en.wikipedia.org/wiki/Sub-Gaussian_distribution -/
theorem directionallySubGaussianSelfAdjointMatrix_sum_of_iIndepFun {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat} {X : I → RandomMatrix Omega n n}
    {K : I → Real} (hKsum : 0 < ∑ i : I, (K i) ^ 2)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hSG : ∀ i, DirectionallySubGaussianSelfAdjointMatrix P (X i) (K i)) :
    DirectionallySubGaussianSelfAdjointMatrix P (randomMatrixSum X)
      (Real.sqrt (∑ i : I, (K i) ^ 2)) := by
  refine ⟨Real.sqrt_pos.mpr hKsum,
    isRandomMatrix_sum (fun i => (hSG i).isRandomMatrix),
    randomSelfAdjointMatrix_sum (fun i => (hSG i).randomSelfAdjoint), ?_⟩
  intro u hu
  have hInt : ∀ i, Integrable (fun w => matrixQuadraticForm (X i w) u) P :=
    fun i => (hSG i).integrable_matrixQuadraticForm hu
  have hIndepScalar :
      ProbabilityTheory.iIndepFun
        (fun i => centeredMatrixQuadraticForm P (X i) u) P := by
    have hg : ∀ i, Measurable
        (fun M : Matrix (Fin n) (Fin n) Real =>
          matrixQuadraticForm M u -
            expect P (fun w => matrixQuadraticForm (X i w) u)) := by
      intro i
      unfold matrixQuadraticForm
      fun_prop
    exact hIndep.comp
      (fun i (M : Matrix (Fin n) (Fin n) Real) =>
        matrixQuadraticForm M u -
          expect P (fun w => matrixQuadraticForm (X i w) u))
      hg
  have hMGF : ∀ i,
      CenteredSubGaussianMGF P (centeredMatrixQuadraticForm P (X i) u) (K i) :=
    fun i => (hSG i).centeredSubGaussianMGF hu
  have hsum :=
    centeredSubGaussianMGF_sum_of_iIndepFun_of_pos
      (X := fun i => centeredMatrixQuadraticForm P (X i) u) (K := K)
      hKsum hIndepScalar hMGF
  rw [centeredMatrixQuadraticForm_randomMatrixSum X u hInt]
  exact hsum

/-- Fixed-direction upper-tail bound.

For a directional sub-Gaussian self-adjoint random matrix and a fixed unit
direction `u`, the centered quadratic form `⟨u, X u⟩` obeys the scalar
sub-Gaussian upper-tail bound with the repository-standard constant
`exp(-(t² / (4 · K²)))`. Like the scalar theorem it wraps, this statement is
measure-level and does not require a probability-measure instance. -/
theorem directionallySubGaussianSelfAdjointMatrix_upperTail {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomMatrix Omega n n} {K : Real}
    (hX : DirectionallySubGaussianSelfAdjointMatrix P X K)
    {u : Fin n → Real} (hu : IsUnitVector u) {t : Real} (ht : 0 ≤ t) :
    upperTailProb P (centeredMatrixQuadraticForm P X u) t ≤
      ENNReal.ofReal (Real.exp (-(t ^ 2 / (4 * K ^ 2)))) :=
  upperTailProb_le_exp_neg_sq_of_centeredSubGaussianMGF
    (isRealRandomVariable_centeredMatrixQuadraticForm hX.isRandomMatrix u)
    (hX.centeredSubGaussianMGF hu) ht

/-- Fixed-direction lower-tail bound.

The lower-tail companion of `directionallySubGaussianSelfAdjointMatrix_upperTail`,
with the same repository-standard constant `exp(-(t² / (4 · K²)))`. It keeps
the same measure-level generality as the scalar theorem. -/
theorem directionallySubGaussianSelfAdjointMatrix_lowerTail {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomMatrix Omega n n} {K : Real}
    (hX : DirectionallySubGaussianSelfAdjointMatrix P X K)
    {u : Fin n → Real} (hu : IsUnitVector u) {t : Real} (ht : 0 ≤ t) :
    lowerTailProb P (centeredMatrixQuadraticForm P X u) (-t) ≤
      ENNReal.ofReal (Real.exp (-(t ^ 2 / (4 * K ^ 2)))) :=
  lowerTailProb_le_exp_neg_sq_of_centeredSubGaussianMGF
    (isRealRandomVariable_centeredMatrixQuadraticForm hX.isRandomMatrix u)
    (hX.centeredSubGaussianMGF hu) ht

end

end HighDimProb
