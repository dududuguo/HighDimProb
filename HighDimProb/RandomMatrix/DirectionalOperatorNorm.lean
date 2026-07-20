import HighDimProb.RandomMatrix.DirectionalSubGaussian
import HighDimProb.RandomMatrix.Spectral
import HighDimProb.RandomMatrix.Assumptions
import HighDimProb.ProbabilitySpace
import HighDimProb.Tail

/-!
# ε-net operator-norm tail for directional sub-Gaussian self-adjoint matrices

This module turns the fixed-direction sub-Gaussian control of
`DirectionallySubGaussianSelfAdjointMatrix` into an operator-norm tail bound via
the classical ε-net (covering) argument for self-adjoint matrices. The route is:

1. A **deterministic** ε-net operator-norm bound: for a real self-adjoint matrix
   `A` and a finite ε-net `N` of unit vectors (`0 ≤ ε < 1/2`),
   `‖A‖op ≤ (1 - 2ε)⁻¹ · maxᵥ |⟨v, A v⟩|`. This uses the self-adjoint numerical
   radius identity `exists_unitVector_abs_matrixQuadraticForm_eq_deterministicOperatorNorm`
   and a bilinear Cauchy–Schwarz estimate; no spectral localization is used.
2. A pointwise event inclusion `{‖Y‖ ≥ t} ⊆ ⋃_{v∈N} {|⟨v, Y v⟩| ≥ (1-2ε)t}`.
3. A finite union bound plus the fixed-direction upper/lower tails, giving
   `P(‖X - EX‖ ≥ t) ≤ 2·|N|·exp(-((1-2ε)²t²)/(4K²))`, whose exponential constant
   `4K²` is inherited verbatim from the scalar `CenteredSubGaussianMGF` tails.

The independent finite-sum version is a thin corollary of the single-matrix
theorem composed with `directionallySubGaussianSelfAdjointMatrix_sum_of_iIndepFun`,
with proxy scale `sqrt (∑ᵢ Kᵢ²)`.

This module does **not** attempt the (generally false) implication from directional
quadratic-form sub-Gaussianity to a Loewner matrix-MGF or an `n·exp(λ²K²/2)`
trace-MGF; the operator-norm control here carries a covering-number `|N|`
prefactor, not a dimension-`n` trace prefactor.

Verified references:
* Operator norm: https://en.wikipedia.org/wiki/Operator_norm
* Covering number: https://en.wikipedia.org/wiki/Covering_number
* Sub-Gaussian distribution: https://en.wikipedia.org/wiki/Sub-Gaussian_distribution
-/

namespace HighDimProb

open MeasureTheory
open scoped BigOperators Matrix.Norms.L2Operator ENNReal

noncomputable section

/-- Bilinear Cauchy–Schwarz estimate for the deterministic operator norm:
`|⟨w, A y⟩| ≤ ‖A‖op · ‖w‖₂ · ‖y‖₂`. This generalizes the unit-vector quadratic
bound `abs_matrixQuadraticForm_le_deterministicOperatorNorm` to two vectors. -/
private theorem abs_dotProduct_mulVec_le {n : Nat} (A : Matrix (Fin n) (Fin n) Real)
    (w y : Fin n -> Real) :
    |dotProduct w (Matrix.mulVec A y)| <=
      deterministicOperatorNorm A *
        norm (WithLp.toLp 2 w : EuclideanSpace Real (Fin n)) *
        norm (WithLp.toLp 2 y : EuclideanSpace Real (Fin n)) := by
  have hmul' :
      norm ((EuclideanSpace.equiv (Fin n) Real).symm (Matrix.mulVec A y) :
        EuclideanSpace Real (Fin n)) <=
        norm A * norm (WithLp.toLp 2 y : EuclideanSpace Real (Fin n)) := by
    simpa using Matrix.l2_opNorm_mulVec A (WithLp.toLp 2 y : EuclideanSpace Real (Fin n))
  have hinner :
      dotProduct w (Matrix.mulVec A y) =
        inner Real
          ((EuclideanSpace.equiv (Fin n) Real).symm (Matrix.mulVec A y) :
            EuclideanSpace Real (Fin n))
          (WithLp.toLp 2 w : EuclideanSpace Real (Fin n)) := by
    simp [Matrix.mulVec, dotProduct, inner, mul_comm]
  rw [hinner]
  calc
    |inner Real
          ((EuclideanSpace.equiv (Fin n) Real).symm (Matrix.mulVec A y) :
            EuclideanSpace Real (Fin n))
          (WithLp.toLp 2 w : EuclideanSpace Real (Fin n))|
        <= norm ((EuclideanSpace.equiv (Fin n) Real).symm (Matrix.mulVec A y) :
              EuclideanSpace Real (Fin n)) *
            norm (WithLp.toLp 2 w : EuclideanSpace Real (Fin n)) :=
          abs_real_inner_le_norm _ _
    _ <= (norm A * norm (WithLp.toLp 2 y : EuclideanSpace Real (Fin n))) *
            norm (WithLp.toLp 2 w : EuclideanSpace Real (Fin n)) :=
          mul_le_mul_of_nonneg_right hmul' (norm_nonneg _)
    _ = deterministicOperatorNorm A *
          norm (WithLp.toLp 2 w : EuclideanSpace Real (Fin n)) *
          norm (WithLp.toLp 2 y : EuclideanSpace Real (Fin n)) := by
        rw [deterministicOperatorNorm]; ring

/-- Bilinear difference identity for quadratic forms (no self-adjointness needed):
`⟨x, A x⟩ - ⟨v, A v⟩ = ⟨x - v, A x⟩ + ⟨v, A (x - v)⟩`. -/
private theorem matrixQuadraticForm_sub_eq_bilinear {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) (x v : Fin n -> Real) :
    matrixQuadraticForm A x - matrixQuadraticForm A v =
      dotProduct (x - v) (Matrix.mulVec A x) +
        dotProduct v (Matrix.mulVec A (x - v)) := by
  have hq : ∀ z : Fin n -> Real,
      matrixQuadraticForm A z = dotProduct z (Matrix.mulVec A z) := by
    intro z
    simp [matrixQuadraticForm, dotProduct, Matrix.mulVec, Finset.mul_sum, mul_assoc]
  rw [hq x, hq v, Matrix.mulVec_sub, dotProduct_sub, sub_dotProduct]
  ring

/-- Deterministic ε-net operator-norm bound for a real self-adjoint matrix.

If `N` is a finite set of unit vectors that `ε`-covers the unit sphere in the
Euclidean metric (`0 ≤ ε < 1/2`), and every net quadratic form obeys
`|⟨v, A v⟩| ≤ M`, then `‖A‖op ≤ (1 - 2ε)⁻¹ · M`.

Formula reference: the standard ε-net bound for the spectral norm of a symmetric
matrix; see https://en.wikipedia.org/wiki/Operator_norm and
https://en.wikipedia.org/wiki/Covering_number -/
theorem deterministicOperatorNorm_le_of_isUnitVectorNet {n : Nat}
    {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real} (hA : IsSelfAdjointMatrix A)
    {N : Finset (Fin (n + 1) -> Real)} {eps M : Real}
    (heps0 : 0 <= eps) (heps : eps < 1 / 2)
    (hNunit : ∀ v ∈ N, IsUnitVector v)
    (hNcover : ∀ x, IsUnitVector x → ∃ v ∈ N, vectorSqNorm (x - v) <= eps ^ 2)
    (hM : ∀ v ∈ N, |matrixQuadraticForm A v| <= M) :
    deterministicOperatorNorm A <= (1 - 2 * eps)⁻¹ * M := by
  obtain ⟨x, hxU, hxEq⟩ :=
    exists_unitVector_abs_matrixQuadraticForm_eq_deterministicOperatorNorm hA
  obtain ⟨v, hvN, hvcov⟩ := hNcover x hxU
  have h12 : (0 : Real) < 1 - 2 * eps := by linarith
  have hAnn : (0 : Real) <= deterministicOperatorNorm A := norm_nonneg A
  have hnx : norm (WithLp.toLp 2 x : EuclideanSpace Real (Fin (n + 1))) = 1 :=
    norm_toLp_eq_one_of_isUnitVector hxU
  have hnv : norm (WithLp.toLp 2 v : EuclideanSpace Real (Fin (n + 1))) = 1 :=
    norm_toLp_eq_one_of_isUnitVector (hNunit v hvN)
  have hnxv :
      norm (WithLp.toLp 2 (x - v) : EuclideanSpace Real (Fin (n + 1))) <= eps := by
    have h1 :
        norm (WithLp.toLp 2 (x - v) : EuclideanSpace Real (Fin (n + 1))) ^ 2 =
          vectorSqNorm (x - v) := norm_sq_toLp_eq_vectorSqNorm _
    nlinarith [norm_nonneg (WithLp.toLp 2 (x - v) : EuclideanSpace Real (Fin (n + 1))),
      hvcov, heps0, h1]
  have hb1 :
      |dotProduct (x - v) (Matrix.mulVec A x)| <= deterministicOperatorNorm A * eps := by
    have hcs := abs_dotProduct_mulVec_le A (x - v) x
    rw [hnx, mul_one] at hcs
    exact hcs.trans (mul_le_mul_of_nonneg_left hnxv hAnn)
  have hb2 :
      |dotProduct v (Matrix.mulVec A (x - v))| <= deterministicOperatorNorm A * eps := by
    have hcs := abs_dotProduct_mulVec_le A v (x - v)
    rw [hnv, mul_one] at hcs
    exact hcs.trans (mul_le_mul_of_nonneg_left hnxv hAnn)
  have hqd :
      |matrixQuadraticForm A x - matrixQuadraticForm A v| <=
        2 * eps * deterministicOperatorNorm A := by
    rw [matrixQuadraticForm_sub_eq_bilinear]
    calc
      |dotProduct (x - v) (Matrix.mulVec A x) + dotProduct v (Matrix.mulVec A (x - v))|
          <= |dotProduct (x - v) (Matrix.mulVec A x)| +
              |dotProduct v (Matrix.mulVec A (x - v))| := by
            simpa [Real.norm_eq_abs] using
              norm_add_le (dotProduct (x - v) (Matrix.mulVec A x))
                (dotProduct v (Matrix.mulVec A (x - v)))
      _ <= deterministicOperatorNorm A * eps + deterministicOperatorNorm A * eps :=
            add_le_add hb1 hb2
      _ = 2 * eps * deterministicOperatorNorm A := by ring
  have htri :
      |matrixQuadraticForm A x| <=
        |matrixQuadraticForm A v| +
          |matrixQuadraticForm A x - matrixQuadraticForm A v| := by
    have := abs_sub_abs_le_abs_sub (matrixQuadraticForm A x) (matrixQuadraticForm A v)
    linarith
  have hstep :
      deterministicOperatorNorm A <= M + 2 * eps * deterministicOperatorNorm A := by
    calc
      deterministicOperatorNorm A = |matrixQuadraticForm A x| := hxEq.symm
      _ <= |matrixQuadraticForm A v| +
            |matrixQuadraticForm A x - matrixQuadraticForm A v| := htri
      _ <= M + 2 * eps * deterministicOperatorNorm A := add_le_add (hM v hvN) hqd
  have key : (1 - 2 * eps) * deterministicOperatorNorm A <= M := by nlinarith [hstep]
  calc
    deterministicOperatorNorm A
        = (1 - 2 * eps)⁻¹ * ((1 - 2 * eps) * deterministicOperatorNorm A) := by
          rw [← mul_assoc, inv_mul_cancel₀ (ne_of_gt h12), one_mul]
    _ <= (1 - 2 * eps)⁻¹ * M :=
          mul_le_mul_of_nonneg_left key (le_of_lt (inv_pos.mpr h12))

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
entrywise integrability of `X`. This bridges the entrywise-centering convention
of `centeredRandomMatrix` to the scalar-centering convention controlled by the
directional predicate. -/
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

/-- Event inclusion: the operator-norm upper-tail event of a pointwise
self-adjoint random matrix is covered by the finite union, over the net, of the
absolute-tail events of its fixed-direction quadratic forms at threshold
`(1 - 2ε)·t`. -/
private theorem operatorNorm_upperTailEvent_subset_biUnion {Omega : Type*}
    [MeasurableSpace Omega] {n : Nat}
    {Y : RandomMatrix Omega (n + 1) (n + 1)}
    (hYSA : ∀ omega, IsSelfAdjointMatrix (Y omega))
    {N : Finset (Fin (n + 1) -> Real)} {eps t : Real}
    (heps0 : 0 <= eps) (heps : eps < 1 / 2)
    (hNunit : ∀ v ∈ N, IsUnitVector v)
    (hNcover : ∀ x, IsUnitVector x → ∃ v ∈ N, vectorSqNorm (x - v) <= eps ^ 2) :
    upperTailEvent (operatorNorm Y) t ⊆
      ⋃ v ∈ N, absTailEvent (fun omega => matrixQuadraticForm (Y omega) v)
        ((1 - 2 * eps) * t) := by
  intro omega homega
  rw [mem_upperTailEvent] at homega
  have homega' : t <= deterministicOperatorNorm (Y omega) := homega
  have h12 : (0 : Real) < 1 - 2 * eps := by linarith
  obtain ⟨x0, hx0U, _⟩ :=
    exists_unitVector_abs_matrixQuadraticForm_eq_deterministicOperatorNorm (hYSA omega)
  obtain ⟨v0, hv0N, _⟩ := hNcover x0 hx0U
  have hNe : N.Nonempty := ⟨v0, hv0N⟩
  obtain ⟨vmax, hvmaxN, hvmax⟩ :=
    Finset.exists_max_image N (fun v => |matrixQuadraticForm (Y omega) v|) hNe
  have hdet :=
    deterministicOperatorNorm_le_of_isUnitVectorNet (hYSA omega) heps0 heps hNunit hNcover
      (M := |matrixQuadraticForm (Y omega) vmax|) (fun w hw => hvmax w hw)
  have hprod :
      (1 - 2 * eps) * deterministicOperatorNorm (Y omega) <=
        |matrixQuadraticForm (Y omega) vmax| := by
    have hmul := mul_le_mul_of_nonneg_left hdet (le_of_lt h12)
    rwa [← mul_assoc, mul_inv_cancel₀ (ne_of_gt h12), one_mul] at hmul
  refine Set.mem_biUnion hvmaxN ?_
  rw [mem_absTailEvent]
  calc
    (1 - 2 * eps) * t <= (1 - 2 * eps) * deterministicOperatorNorm (Y omega) :=
      mul_le_mul_of_nonneg_left homega' (le_of_lt h12)
    _ <= |matrixQuadraticForm (Y omega) vmax| := hprod

/-- Two-sided tail bound for a fixed-direction centered quadratic form, obtained
from the directional upper and lower tails. -/
private theorem absTailProb_centeredMatrixQuadraticForm_le {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    {X : RandomMatrix Omega n n} {K : Real}
    (hX : DirectionallySubGaussianSelfAdjointMatrix P X K)
    {u : Fin n -> Real} (hu : IsUnitVector u) {s : Real} (hs : 0 <= s) :
    P (absTailEvent (centeredMatrixQuadraticForm P X u) s) <=
      ENNReal.ofReal (2 * Real.exp (-(s ^ 2 / (4 * K ^ 2)))) := by
  have hup := directionallySubGaussianSelfAdjointMatrix_upperTail hX hu hs
  have hlo := directionallySubGaussianSelfAdjointMatrix_lowerTail hX hu hs
  calc
    P (absTailEvent (centeredMatrixQuadraticForm P X u) s)
        <= P (upperTailEvent (centeredMatrixQuadraticForm P X u) s ∪
            lowerTailEvent (centeredMatrixQuadraticForm P X u) (-s)) :=
          measure_mono (absTailEvent_subset_upperTailEvent_union_lowerTailEvent_neg _ _)
    _ <= P (upperTailEvent (centeredMatrixQuadraticForm P X u) s) +
          P (lowerTailEvent (centeredMatrixQuadraticForm P X u) (-s)) :=
          measure_union_le _ _
    _ <= ENNReal.ofReal (Real.exp (-(s ^ 2 / (4 * K ^ 2)))) +
          ENNReal.ofReal (Real.exp (-(s ^ 2 / (4 * K ^ 2)))) := add_le_add hup hlo
    _ = ENNReal.ofReal (2 * Real.exp (-(s ^ 2 / (4 * K ^ 2)))) := by
          rw [← ENNReal.ofReal_add (Real.exp_nonneg _) (Real.exp_nonneg _)]
          congr 1
          ring

/-- Single-matrix ε-net operator-norm tail for a directional sub-Gaussian
self-adjoint random matrix.

For `X` directional sub-Gaussian with scale `K` and entrywise integrable, and a
finite `ε`-net `N` of unit vectors (`0 ≤ ε < 1/2`), the operator norm of the
centered matrix `X - EX` obeys
`P(‖X - EX‖op ≥ t) ≤ 2·|N|·exp(-((1-2ε)²·t²)/(4K²))`.

The exponential constant `4K²` is exactly the one from the scalar
`CenteredSubGaussianMGF` tails; the prefactor is the net cardinality `|N|`, not a
dimension factor. -/
theorem directionallySubGaussianSelfAdjointMatrix_operatorNorm_netTail {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    {X : RandomMatrix Omega (n + 1) (n + 1)} {K : Real}
    (hX : DirectionallySubGaussianSelfAdjointMatrix P X K)
    (hInt : IntegrableRandomMatrix P X)
    {N : Finset (Fin (n + 1) -> Real)} {eps t : Real}
    (heps0 : 0 <= eps) (heps : eps < 1 / 2)
    (hNunit : ∀ v ∈ N, IsUnitVector v)
    (hNcover : ∀ x, IsUnitVector x → ∃ v ∈ N, vectorSqNorm (x - v) <= eps ^ 2)
    (ht : 0 <= t) :
    P (upperTailEvent (operatorNorm (centeredRandomMatrix P X)) t) <=
      ENNReal.ofReal
        (2 * (N.card : Real) *
          Real.exp (-((1 - 2 * eps) ^ 2 * t ^ 2 / (4 * K ^ 2)))) := by
  have hYSA : ∀ omega, IsSelfAdjointMatrix ((centeredRandomMatrix P X) omega) :=
    randomSelfAdjointMatrix_centeredRandomMatrix hX.randomSelfAdjoint
  have hs0 : (0 : Real) <= (1 - 2 * eps) * t :=
    mul_nonneg (by linarith) ht
  have hsub :=
    operatorNorm_upperTailEvent_subset_biUnion (Y := centeredRandomMatrix P X) (t := t)
      hYSA heps0 heps hNunit hNcover
  have hbridge : ∀ v : Fin (n + 1) -> Real,
      (fun omega => matrixQuadraticForm ((centeredRandomMatrix P X) omega) v) =
        centeredMatrixQuadraticForm P X v := by
    intro v
    funext omega
    exact matrixQuadraticForm_centeredRandomMatrix hInt v omega
  calc
    P (upperTailEvent (operatorNorm (centeredRandomMatrix P X)) t)
        <= P (⋃ v ∈ N, absTailEvent
              (fun omega => matrixQuadraticForm ((centeredRandomMatrix P X) omega) v)
              ((1 - 2 * eps) * t)) := measure_mono hsub
    _ = P (⋃ v ∈ N, absTailEvent (centeredMatrixQuadraticForm P X v)
            ((1 - 2 * eps) * t)) := by simp_rw [hbridge]
    _ <= ∑ v ∈ N, P (absTailEvent (centeredMatrixQuadraticForm P X v)
            ((1 - 2 * eps) * t)) :=
          measure_biUnion_le P N
            (fun v => absTailEvent (centeredMatrixQuadraticForm P X v) ((1 - 2 * eps) * t))
    _ <= ∑ _v ∈ N, ENNReal.ofReal
            (2 * Real.exp (-(((1 - 2 * eps) * t) ^ 2 / (4 * K ^ 2)))) :=
          Finset.sum_le_sum (fun v hv =>
            absTailProb_centeredMatrixQuadraticForm_le hX (hNunit v hv) hs0)
    _ = (N.card : ENNReal) *
          ENNReal.ofReal (2 * Real.exp (-(((1 - 2 * eps) * t) ^ 2 / (4 * K ^ 2)))) := by
          rw [Finset.sum_const, nsmul_eq_mul]
    _ = ENNReal.ofReal
          (2 * (N.card : Real) *
            Real.exp (-((1 - 2 * eps) ^ 2 * t ^ 2 / (4 * K ^ 2)))) := by
          rw [show ((N.card : ENNReal)) = ENNReal.ofReal (N.card : Real) from
              (ENNReal.ofReal_natCast N.card).symm,
            ← ENNReal.ofReal_mul (Nat.cast_nonneg _)]
          congr 1
          rw [mul_pow]
          ring

/-- Independent finite-sum ε-net operator-norm tail (thin corollary).

For an independent family of directional sub-Gaussian self-adjoint random
matrices `Xᵢ` with scales `Kᵢ`, whose sum is entrywise integrable, the operator
norm of the centered sum `∑ Xᵢ - E(∑ Xᵢ)` obeys the net tail with proxy scale
`sqrt (∑ᵢ Kᵢ²)`, i.e. exponential constant `4·(∑ᵢ Kᵢ²)`. This just composes
`directionallySubGaussianSelfAdjointMatrix_sum_of_iIndepFun` with the
single-matrix net tail. -/
theorem directionallySubGaussianSelfAdjointMatrix_operatorNorm_netTail_sum_of_iIndepFun
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    {X : I -> RandomMatrix Omega (n + 1) (n + 1)} {K : I -> Real}
    (hKsum : 0 < ∑ i : I, (K i) ^ 2)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hSG : ∀ i, DirectionallySubGaussianSelfAdjointMatrix P (X i) (K i))
    (hIntSum : IntegrableRandomMatrix P (randomMatrixSum X))
    {N : Finset (Fin (n + 1) -> Real)} {eps t : Real}
    (heps0 : 0 <= eps) (heps : eps < 1 / 2)
    (hNunit : ∀ v ∈ N, IsUnitVector v)
    (hNcover : ∀ x, IsUnitVector x → ∃ v ∈ N, vectorSqNorm (x - v) <= eps ^ 2)
    (ht : 0 <= t) :
    P (upperTailEvent (operatorNorm (centeredRandomMatrix P (randomMatrixSum X))) t) <=
      ENNReal.ofReal
        (2 * (N.card : Real) *
          Real.exp (-((1 - 2 * eps) ^ 2 * t ^ 2 / (4 * (∑ i : I, (K i) ^ 2))))) := by
  have hclosure :=
    directionallySubGaussianSelfAdjointMatrix_sum_of_iIndepFun hKsum hIndep hSG
  have hmain :=
    directionallySubGaussianSelfAdjointMatrix_operatorNorm_netTail hclosure hIntSum
      heps0 heps hNunit hNcover ht
  rwa [Real.sq_sqrt (le_of_lt hKsum)] at hmain

end

end HighDimProb
